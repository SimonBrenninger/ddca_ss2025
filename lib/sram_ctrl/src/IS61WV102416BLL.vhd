library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity IS61WV102416BLL is
	port (
		a    : in    std_ulogic_vector(19 downto 0);
		io   : inout std_ulogic_vector(15 downto 0);
		ce_n : in    std_ulogic;
		oe_n : in    std_ulogic;
		we_n : in    std_ulogic;
		lb_n : in    std_ulogic;
		ub_n : in    std_ulogic
	);
end entity;

architecture beh of IS61WV102416BLL is
	type memory_t is array(natural range<>) of std_ulogic_vector(15 downto 0);
	shared variable memory : memory_t(2**20-1 downto 0);
	signal readdata : std_ulogic_vector(15 downto 0);
	signal high_z_oe, high_z_ce, high_z_we : boolean := True;
	signal high_z_lb, high_z_ub : boolean := True;

	-- From datasheet page 9 (https://www.issi.com/WW/pdf/61WV102416ALL.pdf)
	-- Read times
	constant TRC   : time := 10 ns;
	constant TAA   : time := 10 ns;
	constant TOHA  : time := 2.5 ns;
	constant TACE  : time := 10 ns;
	constant TDOE  : time := 6.5 ns;
	constant THZOE : time := 4 ns;
	constant TLZOE : time := 0 ns;
	constant THZCE : time := 4 ns;
	constant TLZCE : time := 3 ns;
	constant TBA   : time := 6.5 ns;
	constant THZB  : time := 3 ns;
	constant TLZB  : time := 0 ns;
	constant TPU   : time := 0 ns;
	constant TPD   : time := 10 ns;

	-- Write times
	constant TWC   : time := 10 ns;
	constant TSCE  : time := 8 ns;
	constant TAW   : time := 8 ns;
	constant THA   : time := 0 ns;
	constant TSA   : time := 0 ns;
	constant TPWB  : time := 8 ns;
	constant TPWE1 : time := 8 ns;
	constant TPWE2 : time := 10 ns;
	constant TSD   : time := 6 ns;
	constant THD   : time := 0 ns;
	constant THZWE : time := 5 ns;
	constant TLZWE : time := 2 ns;

	procedure set_high_z(en : std_ulogic; signal high_z: inout boolean; DELAY_FALL, DELAY_RISE : time) is
	begin
		high_z <= False;
		if en = '0' then
			wait for DELAY_FALL;
			high_z <= False;
		elsif en = '1' then
			wait for DELAY_RISE;
			high_z <= True;
		end if;
	end procedure;
begin
	io(7 downto 0) <= readdata(7 downto 0) when (not high_z_ce and not high_z_oe and not high_z_lb and high_z_we) else (others => 'Z');
	io(15 downto 8) <= readdata(15 downto 8) when (not high_z_ce and not high_z_oe and not high_z_ub and high_z_we) else (others => 'Z');

	read : process is
	begin
		wait until a /= (a'range => 'U');
		while true loop
			wait for TAA;
			readdata <= memory(to_integer(unsigned(a)));
			wait on a;
		end loop;
	end process;

	init : process is begin
		for i in 0 to 1000 loop
			memory(i) := std_ulogic_vector(to_unsigned(i, 16));
		end loop;
		wait;
	end process;

	write : process is
		variable tmp : std_ulogic_vector(15 downto 0);
	begin
		wait until falling_edge(WE_N);
		if OE_N = '1' then
			wait for TPWE1-TSD/4;
		else
			wait for TPWE2-TSD/4;
		end if;
		tmp := memory(to_integer(unsigned(a)));
		if lb_n = '0' then
			tmp(7 downto 0) := IO(7 downto 0);
		end if;
		if ub_n = '0' then
			tmp(15 downto 8) := IO(15 downto 8);
		end if;
		memory(to_integer(unsigned(a))) := tmp;
		wait until rising_edge(ce_n) or rising_edge(we_n) or rising_edge(lb_n) or rising_edge(ub_n); -- according to datasheet any signal can terminate write
	end process;

	oe_z : process is
	begin
		wait until oe_n'event;
		set_high_z(oe_n, high_z_oe, TLZOE, THZOE);
	end process;

	ce_z : process is
	begin
		wait until ce_n'event;
		set_high_z(ce_n, high_z_ce, TLZCE, THZCE);
	end process;

	lb_z : process is
	begin
		wait until lb_n'event;
		set_high_z(lb_n, high_z_lb, TLZB, THZB);
	end process;

	ub_z : process is
	begin
		wait until ub_n'event;
		set_high_z(ub_n, high_z_ub, TLZB, THZB);
	end process;

	we_z : process is
	begin
		wait until we_n'event;
		set_high_z(we_n, high_z_we, THZWE, TLZWE);
	end process;
end architecture;

