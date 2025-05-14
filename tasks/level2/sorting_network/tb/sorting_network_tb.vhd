library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

use work.tb_util_pkg.all;
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

	constant NUM_TESTCASES : integer := 4;
	signal testcase_idx : integer := 0;

	shared variable rnd : random_t;
begin

	-- Testbench process
	stimulus: process
	begin
		res_n <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';

		wait until rising_edge(clk);
		if testcase_idx < NUM_TESTCASES then
			wait until testcase_idx = NUM_TESTCASES;
		end if;

		stop_clock <= true;
		report "Testbench done";
		wait;
	end process;

	generate_sorted_data: process
	begin
		for tc_idx in 0 to NUM_TESTCASES loop
			if unsorted_ready = '0' then
				unsorted_valid <= '0';
				wait until unsorted_ready = '1';
			end if;
			for word in unsorted_data'range loop
				unsorted_data(word) <= rnd.gen_sulv_01(unsorted_data(0)'length);
			end loop;
			unsorted_valid <= '1';
			testcase_idx <= tc_idx;
			wait for 0 ns;
		end loop;
		wait;
	end process;

	assert_sorted_data : process
		variable prev_word : std_ulogic_vector(sorted_data(0)'range);
		variable cur_tc_idx : integer;
	begin
		cur_tc_idx := testcase_idx;
		if sorted_valid = '0' then
			sorted_ready <= '0';
			wait until sorted_valid = '1';
		end if;
		sorted_ready <= '1';

		wait for 0 ns;
		prev_word := sorted_data(0);
		for word in 1 to sorted_data'length-1 loop

			assert unsigned(prev_word) <= unsigned(sorted_data(word))
			report "not sorted: 'word(" & to_string(word-1) & ") 0x" & 
			to_hstring(prev_word) & "' > 'word(" & to_string(word) & ") 0x" &
			to_hstring(sorted_data(word)) & "'";

			prev_word := sorted_data(word);
		end loop;
		if testcase_idx < NUM_TESTCASES then
			if cur_tc_idx = testcase_idx then
				wait until testcase_idx = cur_tc_idx + 1;
			end if;
		else
			wait;
		end if;
	end process;

	uut : entity work.sorting_network(arch_combinatorial)
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
			clk <= '0';
			wait for CLK_PERIOD / 2;
			clk <= '1';
			wait for CLK_PERIOD / 2;
		end loop;
		wait;
	end process;

end architecture;
