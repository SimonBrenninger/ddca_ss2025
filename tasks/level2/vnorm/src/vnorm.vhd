library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lpm;
use lpm.lpm_components.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

use work.vnorm_pkg.all;


entity vnorm is
	port (
		clk        : in  std_ulogic;
		res_n      : in  std_ulogic;
		vector_in  : in  vec3_t;
		valid_in   : in  std_ulogic;
		vector_out : out vec3_t;
		valid_out  : out std_ulogic
	);
end entity;

architecture arch of vnorm is
	constant MULT_PL_DEPTH : positive := 1;
	constant SUM_PL_DEPTH  : positive := 2;
	constant SQRT_PL_DEPTH : positive := 16;
	constant DIV_PL_DEPTH  : positive := 48;
begin


end architecture;



