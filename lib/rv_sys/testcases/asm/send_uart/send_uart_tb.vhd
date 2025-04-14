library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std; -- for Printing
use std.env.all;
use std.textio.all;

use work.rv_sys_pkg.all;
use work.tb_util_pkg.all;

entity send_uart_tb is
	generic (
		TESTCASE_NAME : string;
		ELF_FILE : string
	);
end entity;

architecture arch of send_uart_tb is

	constant CLK_PERIOD : time := 20 ns;
	constant BAUD_RATE : integer := 115200;

	signal clk, res_n : std_logic;
	signal tx : std_logic;

	signal imem_in, dmem_in : mem_in_t;
	signal imem_out, dmem_out : mem_out_t;

	constant GPIO_ADDR_WIDTH : natural := 3;

	signal stop_clock : boolean := false;
begin

	rv_inst : entity work.rv
	port map(
		clk => clk,
		res_n => res_n,
		imem_out => imem_out,
		imem_in  => imem_in,
		dmem_out => dmem_out,
		dmem_in  => dmem_in
	);

	rv_sys_inst : entity work.rv_sys
	generic map (
		BAUD_RATE => BAUD_RATE,
		CLK_FREQ => 50_000_000,
		SIMULATE_ELF_FILE => ELF_FILE,
		GPIO_ADDR_WIDTH => GPIO_ADDR_WIDTH
	)
	port map (
		clk => clk,
		res_n => res_n,

		cpu_reset_n => open,

		imem_out => imem_out,
		imem_in => imem_in,
		dmem_out => dmem_out,
		dmem_in => dmem_in,

		gp_out => open,
		gp_in => (others => (others => '0')),
		rx => '1',
		tx => tx
	);

	main : process
		variable data : std_ulogic_vector(7 downto 0);
		variable error_counter : natural;
		procedure check(expected_data : std_ulogic_vector(7 downto 0)) is
		begin
			if data /= expected_data then
				report "wrong value received!" severity error;
				error_counter := error_counter + 1;
			end if;
		end procedure;
	begin
		res_n <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';

		uart_receive(tx, BAUD_RATE, data);
		check(x"4B");
		uart_receive(tx, BAUD_RATE, data);
		check(x"0A");

		wait for 4*CLK_PERIOD;
		stop_clock <= true;
		wait for CLK_PERIOD;
		tc_print_result(TESTCASE_NAME, error_counter = 0);
		wait;
	end process;

	tc_timeout(TESTCASE_NAME, (1000 ms/BAUD_RATE) * 30, stop_clock);
	clk_gen(clk, CLK_PERIOD, stop_clock);

end architecture;
