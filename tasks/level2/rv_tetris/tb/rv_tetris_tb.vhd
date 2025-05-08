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
use work.gfx_init_pkg.all;

entity rv_tetris_tb is
	generic (
		TESTCASE_NAME : string := "rv_tetris";
		ELF_FILE : string := "software/tetris.elf"
	);
end entity;

architecture arch of rv_tetris_tb is

	constant CLK_PERIOD : time := 20 ns;
	constant BAUD_RATE : integer := 115200;

	signal clk, res_n : std_logic;

	signal imem_in, dmem_in : mem_in_t;
	signal imem_out, dmem_out : mem_out_t;

	constant GPIO_ADDR_WIDTH : natural := 3;
	signal gp_out : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
	signal gp_in  : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
	signal gci_in : gci_in_t;
	signal gci_out : gci_out_t;

	signal snes_ctrl_state : snes_ctrl_state_t := (others => '0');
	signal tetris_game_rom_out : std_ulogic_vector(31 downto 0);

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

	gfx_cmd_interpreter_inst : entity work.gfx_cmd_interpreter
	generic map (
		OUTPUT_DIR => "./"
	)
	port map (
		clk     => clk,
		gci_in  => gci_in,
		gci_out => gci_out
	);
	
	process (all)
	begin
		for i in 0 to 2**GPIO_ADDR_WIDTH-1 loop
			gp_in(i) <= (others=>'0');
		end loop;

		-- SNES gamepad input
		gp_in(4) <= (others => '0');
		gp_in(4)(11 downto 0) <= to_sulv(snes_ctrl_state);

		-- Tetris Game ROM
		gp_in(5) <= tetris_game_rom_out;

		-- loop back to unused outputs
		gp_in(6) <= gp_out(6);
		gp_in(7) <= gp_out(7);

	end process;

	tetris_game_rom : process(clk, res_n)
	begin
		if res_n = '0' then
			tetris_game_rom_out <= (others => '0');
		elsif rising_edge(clk) then
			tetris_game_rom_out <= (others => '0');
			if signed(gp_out(5)) = -1 then
				tetris_game_rom_out <= std_ulogic_vector(to_unsigned(GFX_INIT_CMDS'length, 32));
			else
				tetris_game_rom_out(GFX_CMD_WIDTH-1 downto 0) <= GFX_INIT_CMDS(to_integer(unsigned(gp_out(5))));
			end if;
		end if;
	end process;

	main : process
		variable error_counter : natural;
	begin
		res_n <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';

		snes_ctrl_state.btn_a <= '1';
		for i in 0 to 3 loop
			wait until rising_edge(gci_out.frame_sync);
			report "frame sync detected";
		end loop;
		
		wait for 4*CLK_PERIOD;
		stop_clock <= true;
		wait for CLK_PERIOD;
		tc_print_result(TESTCASE_NAME, error_counter = 0);
		wait;
	end process;

	tc_timeout(TESTCASE_NAME, 30 ms, stop_clock);
	clk_gen(clk, CLK_PERIOD, stop_clock);

end architecture;
