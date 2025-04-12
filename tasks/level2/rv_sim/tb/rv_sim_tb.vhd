

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std; -- for Printing
use std.env.all;
use std.textio.all;

use work.rv_sys_pkg.all;
use work.tb_util_pkg.all;

entity rv_sim_tb is
	generic (
		ELF_FILE         : string;
		SIM_STOP_TIME_US : integer
	);
end entity;

architecture arch of rv_sim_tb is
	constant CLK_PERIOD : time := 20 ns;
	constant BAUD_RATE  : integer := 115200;

	signal clk, res_n : std_ulogic;

	signal imem_in, dmem_in   : mem_in_t;
	signal imem_out, dmem_out : mem_out_t;
	signal rx, tx : std_ulogic;

	constant GPIO_ADDR_WIDTH : natural := 3;
	signal gp_out : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
	signal gp_in  : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);

	procedure print_line(s : string) is
	begin
		report s;
	end procedure;
begin

	rv_sim_inst : entity work.rv_sim
	generic map (
		CLK_FREQ => 50_000_000
	)
	port map(
		clk      => clk,
		res_n    => res_n,
		imem_out => imem_out,
		imem_in  => imem_in,
		dmem_out => dmem_out,
		dmem_in  => dmem_in
	);

	rv_sys_inst : entity work.rv_sys
	generic map (
		BAUD_RATE         => BAUD_RATE,
		CLK_FREQ          => 50_000_000,
		SIMULATE_ELF_FILE => ELF_FILE,
		GPIO_ADDR_WIDTH   => GPIO_ADDR_WIDTH,
		IMEM_DELAY        => 0,
		DMEM_DELAY        => 0
	)
	port map (
		clk         => clk,
		res_n       => res_n,
		cpu_reset_n => open,

		imem_out => imem_out,
		imem_in  => imem_in,
		dmem_out => dmem_out,
		dmem_in  => dmem_in,

		gp_out => gp_out,
		gp_in  => gp_in,

		rx => rx,
		tx => tx
	);

	main : process is
	begin
		gp_in <= (others => (others => '0'));
		res_n <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';
		wait until rising_edge(clk);

		wait for SIM_STOP_TIME_US * 1 us;
		print_line("Simulation done");

		std.env.stop;
	end process;

	gpio_printer : process (gp_out)
	begin
		for i in 0 to 2**GPIO_ADDR_WIDTH-1 loop
			print_line("GPIO["  & to_string(i) & "]: " & to_hstring(gp_out(i)));
		end loop;
	end process;

	uart_tx : process
	begin
		rx <= '1';
		wait until res_n = '1';
		uart_transmit(rx, BAUD_RATE, x"55");
		uart_transmit(rx, BAUD_RATE, x"41");
		uart_transmit(rx, BAUD_RATE, x"52");
		uart_transmit(rx, BAUD_RATE, x"54");
		wait;
	end process;

	uart_rx_printer : process
		variable uart_data : std_logic_vector(7 downto 0);
	begin
		loop
			uart_receive(tx, BAUD_RATE, uart_data);
			print_line("UART: " & to_string(to_character(uart_data)));
		end loop;
		wait;
	end process;

	dmem_printer : block
		signal read_issued : std_ulogic := '0';
	begin
		process
		begin
			wait until rising_edge(clk);
			if (dmem_out.wr = '1') then
				print_line(
					"DMEM write: " &
					"addr=0x" & to_hstring(dmem_out.address) & ", " &
					"data=0x" & to_hstring(dmem_out.wrdata) & ", " &
					"byteen=" & to_string(unsigned(dmem_out.byteena))
				);
			end if;

			if dmem_in.busy = '0' then
				read_issued <= '0';
			end if;
			if dmem_out.rd = '1' then
				read_issued <= '1';
			end if;
			if (read_issued = '1' and dmem_in.busy = '0') then
				print_line(
					"DMEM read: " &
					"addr=0x" & to_hstring(dmem_out.address) & ", " &
					"data=0x" & to_hstring(dmem_in.rddata)
				);
			end if;
		end process;
	end block;

	imem_printer : block
		signal read_issued : std_ulogic := '0';
	begin
		process
		begin
			wait until rising_edge(clk);
			if imem_in.busy = '0' then
				read_issued <= '0';
			end if;
			if imem_out.rd = '1' then
				read_issued <= '1';
			end if;
			if (read_issued = '1' and imem_in.busy = '0') then
				print_line(
					"IMEM read: " &
					"addr=0x" & to_hstring(imem_out.address) & ", " &
					"data=0x" & to_hstring(imem_in.rddata)
				);
			end if;
		end process;
	end block;

	clk_gen: process is
	begin
		clk <= '1';
		wait for CLK_PERIOD / 2;
		clk <= '0';
		wait for CLK_PERIOD / 2;
	end process;

end architecture;
