library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

use work.sorting_network_pkg.all;

entity sorting_network_tb is
end entity;

architecture arch of sorting_network_tb is
	constant CLK_PERIOD : time       := 20 ns;
	signal clk, res_n   : std_ulogic := '0';
	signal stop_clock   : boolean    := false;

	signal unsorted_ready, unsorted_valid : std_ulogic := '0';
	signal sorted_ready, sorted_valid     : std_ulogic := '0';

	signal unsorted_data : word_array_t(0 to 9) := (others => (others => '0'));
	signal sorted_data   : word_array_t(0 to 9) := (others => (others => '0'));
begin

	-- Testbench process
	stimulus: process
	begin
		res_n <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';

		wait until rising_edge(clk);

		stop_clock <= true;
		report "Testbench done";
		wait;
	end process;

	uut : entity work.sorting_network(arch_pipelined)
	port map (
		clk   => clk,
		res_n => res_n,

		unsorted_ready => unsorted_ready,
		unsorted_data  => unsorted_data,
		unsorted_valid => unsorted_valid,

		sorted_ready => sorted_ready,
		sorted_data  => sorted_data,
		sorted_valid => sorted_valid
	);

	generate_clk : process
	begin
		while not stop_clock loop
			clk <= '0', '1' after CLK_PERIOD / 2;
			wait for CLK_PERIOD;
		end loop;
		wait;
	end process;

end architecture;
