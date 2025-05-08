library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_core_pkg.all;

package rv_ext_m_pkg is

	type ext_m_op_t is (
		M_MUL,
		M_MULH,
		M_MULHU,
		M_MULHSU,
		M_DIV,
		M_DIVU,
		M_REM,
		M_REMU
	);

	component rv_ext_m is
		generic (
			DATA_WIDTH : natural := 32
		);
		port (
			clk    : in std_ulogic;
			res_n  : in std_ulogic;
			a, b   : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
			result : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
			op     : in ext_m_op_t;
			start  : in std_ulogic;
			busy   : out std_ulogic
		);
	end component;

end package;

