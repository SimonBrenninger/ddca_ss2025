library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_core_pkg.all;
use work.rv_ext_m_pkg.all;

entity rv_ext_m_tb is
end entity;

architecture tb of rv_ext_m_tb is
	constant CLK_PERIOD : time := 20 ns;
	constant DATA_WIDTH : natural := 6;
	signal clk, res_n : std_ulogic := '0';
	signal a, b, result : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal op : ext_m_op_t := M_MUL;
	signal start, busy: std_ulogic;

begin

	stim : process is
	-- TODO: Add useful procedures, functions, variables etc.
	begin
		res_n <= '0';
		op <= M_MUL;
		start <= '0';
		A <= (others => '0');
		B <= (others => '0');
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';
		wait until rising_edge(clk);
		-- TODO: Add your tests
		report "Testbench done";
		std.env.stop;
		wait;
	end process;

	generate_clk : process
	begin
		while True loop
			clk <= '0', '1' after CLK_PERIOD / 2;
			wait for CLK_PERIOD;
		end loop;
		wait;
	end process;

	uut : entity work.rv_ext_m
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		clk    => clk,
		res_n  => res_n,
		a      => a,
		b      => b,
		result => result,
		op     => op,
		start  => start,
		busy   => busy
	);

end architecture;
