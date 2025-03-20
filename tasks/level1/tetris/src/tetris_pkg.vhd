library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tetris_pkg is

	type tetris_gamepad_t is record
		a, b : std_ulogic;
		start, sel : std_ulogic;
		dir_left : std_ulogic;
		dir_right : std_ulogic;
		dir_up : std_ulogic;
		dir_down : std_ulogic;
	end record;
	constant TETRIS_GAMEPAD_ZERO : tetris_gamepad_t := (others => '0');
end package;

