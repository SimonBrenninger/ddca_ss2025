library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all;
use ieee.std_logic_textio.all;


package tb_util_pkg is
	type random_t is protected
		impure function gen_slv_01(len : positive) return std_ulogic_vector;
		impure function gen_sl_01 return std_ulogic;
	end protected;

end package;

package body tb_util_pkg is

	type random_t is protected body
		variable seed1, seed2 : integer := 1;

		impure function gen_slv_01(len : positive) return std_ulogic_vector is
			variable random_real : real;
			variable slv : std_ulogic_vector(len - 1 downto 0);
		begin
			for i in slv'range loop
				uniform(seed1, seed2, random_real);
				slv(i) := '1';
				if (random_real > 0.5) then slv(i) := '0'; end if;
			end loop;
			return slv;
		end function;

		impure function gen_sl_01 return std_ulogic is
			variable random_real : real;
		begin
			uniform(seed1, seed2, random_real);
			if (random_real > 0.5) then
				return '0';
			end if;
			return '1';
		end function;
	end protected body;


end package body;
