library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lpm;
use lpm.lpm_components.all;

use work.math_pkg.all;
use work.rv_ext_m_pkg.all;
use work.rv_core_pkg.all;

entity rv_ext_m is
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
end entity;

architecture arch of rv_ext_m  is
	constant DIV_PL_DEPTH  : integer := DATA_WIDTH;
	constant MINUS_ONE : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '1');
	constant MIN_VALUE : std_ulogic_vector(DATA_WIDTH-1 downto 0) := '1' & (DATA_WIDTH-2 downto 0 => '0');

	signal div_res_slv, div_rem_slv : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mul_res_slv : std_logic_vector(2*DATA_WIDTH-1 downto 0);
	signal div_res, div_rem : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal mul_res : std_ulogic_vector(2*DATA_WIDTH-1 downto 0);
	signal op_a, op_b : std_ulogic_vector(DATA_WIDTH-1 downto 0);
begin


	lpm_mult_inst : lpm_mult
	generic map (
		LPM_WIDTHA         => DATA_WIDTH,
		LPM_WIDTHB         => DATA_WIDTH,
		LPM_WIDTHP         => 2*DATA_WIDTH,
		LPM_REPRESENTATION => "UNSIGNED",
		LPM_PIPELINE       => 1
	)
	port map (
		clock  => clk,
		aclr   => not res_n,
		clken  => '1',
		dataa  => std_logic_vector(op_a),
		datab  => std_logic_vector(op_b),
		sum    => open,
		result => mul_res_slv
	);
	mul_res <= std_ulogic_vector(mul_res_slv);

	lpm_div_inst : lpm_divide
	generic map (
		LPM_WIDTHN          => DATA_WIDTH,
		LPM_WIDTHD          => DATA_WIDTH,
		LPM_NREPRESENTATION => "UNSIGNED",
		LPM_DREPRESENTATION => "UNSIGNED",
		LPM_PIPELINE        => DIV_PL_DEPTH
	)
	port map (
		clock    => clk,
		aclr     => not res_n,
		clken    => '1',
		numer    => std_logic_vector(op_a),
		denom    => std_logic_vector(op_b),
		quotient => div_res_slv,
		remain   => div_rem_slv
	);
	div_res <= std_ulogic_vector(div_res_slv);
	div_rem <= std_ulogic_vector(div_rem_slv);

end architecture;
