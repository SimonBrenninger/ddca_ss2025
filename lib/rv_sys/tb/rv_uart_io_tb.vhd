library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.env.all;
use std.textio.all;

use work.rv_sys_pkg.all;
use work.tb_util_pkg.all;

entity rv_uart_io_tb is
	generic (
		TESTCASE_NAME : string;
		ELF_FILE : string;
		UART_RX : string;
		UART_TX : string := ""
	);
end entity;

architecture arch of rv_uart_io_tb is

	constant CLK_PERIOD : time := 20 ns;
	constant BAUD_RATE : integer := 115200;

	signal clk, res_n : std_logic;
	signal tx, rx : std_logic;

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
		rx => rx,
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

		for i in UART_RX'range loop
			uart_receive(tx, BAUD_RATE, data);
			check(std_ulogic_vector(to_unsigned(character'pos(UART_RX(i)), 8)));
		end loop;

		wait for 4*CLK_PERIOD;
		stop_clock <= true;
		wait for CLK_PERIOD;
		tc_print_result(TESTCASE_NAME, error_counter = 0);
		wait;
	end process;

	uart_transmitter : process
	begin
		wait for 10*CLK_PERIOD;
		for i in UART_TX'range loop
			uart_transmit(rx, BAUD_RATE, std_ulogic_vector(to_unsigned(character'pos(UART_TX(i)), 8)));
		end loop;
		wait;
	end process;

	tc_timeout(TESTCASE_NAME, (1000 ms/BAUD_RATE) * (UART_RX'length+UART_TX'length+100) * 10, stop_clock);
	clk_gen(clk, CLK_PERIOD, stop_clock);

end architecture;
