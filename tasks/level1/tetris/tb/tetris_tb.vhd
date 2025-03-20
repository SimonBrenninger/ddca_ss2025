library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gfx_core_pkg.all;
use work.tetris_pkg.all;

entity tetris_tb is
end entity;

architecture bench of tetris_tb is

	constant OUTPUT_DIR : string := "./";
	signal clk : std_logic;
	signal res_n : std_logic;

	signal gci_in : gci_in_t;
	signal gci_out : gci_out_t;

	signal gamepad : tetris_gamepad_t;

	signal frame_counter : integer := 0;

	constant CLK_PERIOD : time := 10 ns;
	signal stop_clock : boolean := false;
begin

	uut : entity work.tetris
	port map (
		clk => clk,
		res_n => res_n,
		gci_in => gci_in,
		gci_out => gci_out,
		gamepad => gamepad,
		rumble => open
	);

	gfx_cmd_interpreter_inst : entity work.gfx_cmd_interpreter
	generic map (
		OUTPUT_DIR => OUTPUT_DIR
	)
	port map (
		clk     => clk,
		gci_in  => gci_in,
		gci_out => gci_out
	);
	
	process
	begin
		wait until rising_edge(clk);
		res_n <= '0';
		gamepad.a <= '0';
		gamepad.b <= '0';
		gamepad.dir_right <= '0';
		gamepad.dir_left <= '0';
		gamepad.dir_up <= '0';
		gamepad.dir_down <= '0';
		gamepad.start <= '0';
		gamepad.sel <= '0';
		wait for 2*CLK_PERIOD;
		res_n <= '1';

		wait until frame_counter = 4;
		gamepad.a <= '1';

		wait until frame_counter = 8;
		stop_clock <= true;
		report "done";
		wait;
	end process;

	process
	begin
		wait until rising_edge(clk);
		if gci_out.frame_sync = '1' then
			frame_counter <= frame_counter + 1;
		end if;
	end process;

	generate_clk : process
	begin
		while not stop_clock loop
			clk <= '0', '1' after CLK_PERIOD / 2;
			wait for CLK_PERIOD;
		end loop;
		wait;
	end process;

end architecture;

