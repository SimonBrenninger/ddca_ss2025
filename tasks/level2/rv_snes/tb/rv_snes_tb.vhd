library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.env.all;
use std.textio.all;

use work.rv_sys_pkg.all;
use work.tb_util_pkg.all;
use work.gfx_core_pkg.all;
use work.snes_ctrl_pkg.all;

entity rv_snes_tb is
	generic (
		TESTCASE_NAME : string := "rv_snes";
		ELF_FILE : string := "software/snes.elf"
	);
end entity;

architecture arch of rv_snes_tb is

	constant CLK_PERIOD : time := 20 ns;
	constant BAUD_RATE : integer := 115200;

	signal clk, res_n : std_ulogic;

	signal imem_in, dmem_in : mem_in_t;
	signal imem_out, dmem_out : mem_out_t;

	constant GPIO_ADDR_WIDTH : natural := 3;
	signal gp_out : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
	signal gp_in  : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
	signal gci_in : gci_in_t;
	signal gci_out : gci_out_t;

	signal snes_ctrl_state : snes_ctrl_state_t := (others => '0');
	signal snes_clk, snes_data, snes_latch : std_ulogic;

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

		gp_out => gp_out,
		gp_in => gp_in,

		gci_in => gci_in,
		gci_out => gci_out,

		rx => '0',
		tx => open
	);
	
	process (all)
	begin
		for i in 0 to 2**GPIO_ADDR_WIDTH-1 loop
			gp_in(i) <= (others=>'0');
		end loop;

		-- SNES gamepad
		snes_clk <= gp_out(4)(0);
		snes_latch <= gp_out(4)(1);
		gp_in(4) <= (others => '0');
		gp_in(4)(0) <= snes_data;

		-- loop back to unused outputs
		gp_in(5) <= gp_out(5);
		gp_in(6) <= gp_out(6);
		gp_in(7) <= gp_out(7);
	end process;


	main : process
		variable error_counter : natural;
	begin
		res_n <= '0';
		snes_data <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';

		-- provide some input data for snes_data and check if the output at gp_out(1) is correct
		error_counter := 1000;
		wait for 10 us;
		
		wait for 4*CLK_PERIOD;
		stop_clock <= true;
		wait for CLK_PERIOD;
		tc_print_result(TESTCASE_NAME, error_counter = 0);
		wait;
	end process;

	process(all)
	begin
		report "SNES: snes_latch=" & to_string(snes_latch) & ", " & "snes_clk=" & to_string(snes_clk);
	end process;

	tc_timeout(TESTCASE_NAME, 30 ms, stop_clock);
	clk_gen(clk, CLK_PERIOD, stop_clock);

end architecture;
