library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gfx_core_pkg.all;

package decimal_printer_pkg is

	component decimal_printer is
		port (
			clk : in std_ulogic;
			res_n : in std_ulogic;
			gci_in : out gci_in_t;
			gci_out : in gci_out_t;
			start : in std_ulogic;
			busy : out std_ulogic;
			number : in std_ulogic_vector(15 downto 0);
			bmpidx : in bmpidx_t;
			charwidth : in charwidth_t
		);
	end component;
end package;

