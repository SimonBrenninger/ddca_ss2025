library ieee;
use ieee.std_logic_1164.all;


package rv_alu_pkg is
	type rv_alu_op_t is (
		ALU_NOP,
		ALU_SLT,
		ALU_SLTU,
		ALU_SLL,
		ALU_SRL,
		ALU_SRA,
		ALU_ADD,
		ALU_SUB,
		ALU_AND,
		ALU_OR,
		ALU_XOR
	);

	component rv_alu is
		port (
			op     : in  rv_alu_op_t;
			a, b   : in  std_ulogic_vector(31 downto 0);
			result : out std_ulogic_vector(31 downto 0);
			z      : out std_ulogic
		);
	end component;
end package;
