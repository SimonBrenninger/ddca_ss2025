library ieee;
use ieee.std_logic_1164.all;

-- pragma synthesis_off
use ieee.fixed_pkg.all;
use ieee.math_real.all;
-- pragma synthesis_on


package vnorm_pkg is

	subtype q16_16_t  is std_logic_vector(31 downto 0);
	type q16_16_arr_t is array (integer range<>) of q16_16_t;
	type slv_arr_t    is array (integer range<>) of std_logic_vector;

	type vec3_t is
	record
		x : q16_16_t;
		y : q16_16_t;
		z : q16_16_t;
	end record;

	type vec3_arr_t is array(integer range<>) of vec3_t;
	constant VEC3_ZERO : vec3_t := (others => (others => '0'));

	function "="(vec1, vec2: vec3_t) return boolean;

	-- pragma synthesis_off
	function to_string(vec: vec3_t) return string;
	function to_real(value: q16_16_t) return real;
	function to_q16_16_t(value: real) return q16_16_t;
	-- pragma synthesis_on

	component vnorm is
		port (
			clk        : in  std_ulogic;
			res_n      : in  std_ulogic;
			vector_in  : in  vec3_t;
			valid_in   : in  std_ulogic;
			vector_out : out vec3_t;
			valid_out  : out std_ulogic
		);
	end component;

end package;


package body vnorm_pkg is

	function "="(vec1, vec2: vec3_t) return boolean is
	begin
		return (vec1.x = vec2.x) and (vec1.y = vec2.y) and (vec1.z = vec2.z);
	end function;

	-- pragma synthesis_off
	function to_string(vec: vec3_t) return string is
	begin
		return "(X: " & to_hstring(vec.x) & ", Y: " & to_hstring(vec.y) & ", Z: " & to_hstring(vec.z) & ")";
	end function;

	function to_real(value : q16_16_t) return real is
	begin
		return to_real(to_sfixed(value, 15, -16));
	end function;

	function to_q16_16_t(value : real) return q16_16_t is
	begin
		return to_slv(to_sfixed(value, 15, -16));
	end function;
	-- pragma synthesis_on

end package body;
