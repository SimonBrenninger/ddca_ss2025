library ieee;
use ieee.std_logic_1164.all;

use work.tetris_pkg.all;
use work.gfx_core_pkg.all;
use work.vga_gfx_ctrl_pkg.all;
use work.sync_pkg.all;
use work.snes_ctrl_pkg.all;

architecture top_arch_tetris of top is
	component pll is
		port (
			inclk0  : in std_logic := '0';
			c0      : out std_logic
		);
	end component;

	signal display_clk : std_ulogic;
	signal display_res_n, audio_res_n : std_ulogic;
	signal res_n : std_ulogic;

begin

	pll_inst : pll
	port map(
		inclk0 => clk,
		c0     => display_clk
	);

	reset_sync : sync
	generic map (
		SYNC_STAGES => 2,
		RESET_VALUE => '0'
	)
	port map (
		clk => clk,
		res_n => '1',
		data_in => keys(0),
		data_out => res_n
	);

	display_reset_sync : sync
	generic map (
		SYNC_STAGES => 2,
		RESET_VALUE => '0'
	)
	port map (
		clk => display_clk,
		res_n => '1',
		data_in => keys(0),
		data_out => display_res_n
	);

	-- add and connect instances of the following modules
	--  * vga_gfx_ctrl
	--  * tetris
	--  * snes_ctrl (or gc_ctrl)


end architecture;
