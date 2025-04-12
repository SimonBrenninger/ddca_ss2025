
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_sys_pkg.all;

entity mm_gpio is
	generic (
		ADDR_WIDTH : positive := 1
	);
	port (
		clk     : in  std_ulogic;
		res_n   : in  std_ulogic;

		address : in  std_ulogic_vector(ADDR_WIDTH-1 downto 0);
		wr      : in  std_ulogic;
		wr_data : in  mem_data_t;
		rd      : in  std_ulogic;
		rd_data : out mem_data_t;
		busy    : out std_ulogic;

		gp_out : out mem_data_array_t(2**ADDR_WIDTH-1 downto 0);
		gp_in  : in  mem_data_array_t(2**ADDR_WIDTH-1 downto 0)
	);
end entity;


architecture arch of mm_gpio is
	signal addr_int : natural;
	signal busy_int : std_ulogic;
begin
	addr_int <= to_integer(unsigned(address));

	sync : process(clk, res_n)
	begin
		if res_n='0' then
			gp_out <= (others => (others => '0'));
			busy_int <= '0';
			rd_data <= (others => '0');
		elsif rising_edge(clk) then
			busy_int <= '0';
			if wr = '1' then
				gp_out(addr_int) <= swap_endianness(wr_data);
			end if;
			if rd = '1' then
				busy_int <= '1';
				rd_data <= swap_endianness(gp_in(addr_int));
			end if;
		end if;
	end process;
	busy <= rd or busy_int;
end architecture;

