
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.gfx_core_pkg.all;

package gfx_util_pkg is

	subtype s16_t is signed(15 downto 0);
	subtype u15_t is unsigned(14 downto 0);
	subtype u16_t is unsigned(15 downto 0);

	type vec2d_s16_t is record
		x, y : s16_t;
	end record;

	constant VEC2D_S16_ZERO : vec2d_s16_t := (others => (others => '0'));

	constant BMP_DSC_SIZE_WIDTH : integer := 15;
	type bd_t is record
		b : std_ulogic_vector(31 downto 0);
		w, h : u15_t;
	end record;

	constant BD_ZERO : bd_t := (
		b => (others => '0'),
		w => (others => '0'),
		h => (others => '0')
	);

	type bitmap_section_t is record
		x, y, w, h : u15_t;
	end record;

	type bb_effect_t is record
		mask   : color_t;
		maskop : maskop_t;
	end record;

	function apply_bb_effect (c : color_t; e : bb_effect_t) return color_t;
end package;


package body gfx_util_pkg is
	function apply_bb_effect (c : color_t; e : bb_effect_t) return color_t is
	begin
		case e.maskop is
			when MASKOP_AND => return c and e.mask;
			when MASKOP_OR => return c or e.mask;
			when MASKOP_XOR => return c xor e.mask;
			when others => null;
		end case;
		return c;
	end function;
end package body;
