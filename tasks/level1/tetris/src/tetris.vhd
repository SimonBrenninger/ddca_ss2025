library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gfx_core_pkg.all;
use work.tetris_pkg.all;

entity tetris is
	port (
		clk : in std_ulogic;
		res_n : in std_ulogic;

		-- interface to vga_gfx_ctrl
		gci_in  : out gci_in_t;
		gci_out : in gci_out_t;

		--connection to the gamepad
		gamepad : in tetris_gamepad_t;
		rumble  : out std_ulogic
	);
end entity;
