library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package rv_core_pkg is
	-- width of a byte
	constant BYTE_WIDTH       : positive := 8;
	-- width of a dataword (multiple of BYTE_WIDTH)
	constant DATA_WIDTH       : positive := 32;
	-- width of an instruction word
	constant WIDTH_INSTRUCTION : natural := 32;
	-- width of byte enable
	constant BYTEEN_WIDTH     : positive := DATA_WIDTH/BYTE_WIDTH;
	-- CPU data type
	subtype data_t  is std_ulogic_vector(DATA_WIDTH-1 downto 0);
	-- CPU instruction type
	subtype instr_t is std_ulogic_vector(WIDTH_INSTRUCTION-1 downto 0);

	-- constants for RISC-V instruction fields
	constant INDEX_OPCODE      : natural := 0;
	constant WIDTH_OPCODE      : natural := 7;
	constant WIDTH_REG_ADDRESS : natural := 5;
	constant INDEX_RD          : natural := 7;
	constant INDEX_RS1         : natural := 15;
	constant INDEX_RS2         : natural := 20;
	constant INDEX_FUNCT3      : natural := 12;
	constant WIDTH_FUNCT3      : natural := 3;
	constant INDEX_FUNCT7      : natural := 25;
	constant WIDTH_FUNCT7      : natural := 7;

	-- utility subtypes for the RISC-V instruction fields
	subtype opcode_t      is std_ulogic_vector(WIDTH_OPCODE-1 downto 0);
	subtype reg_address_t is std_ulogic_vector(WIDTH_REG_ADDRESS-1 downto 0);
	subtype funct3_t      is std_ulogic_vector(WIDTH_FUNCT3-1 downto 0);
	subtype funct7_t      is std_ulogic_vector(WIDTH_FUNCT7-1 downto 0);

	-- utility functions for extracting fields from RISC-V instructions
	function get_opcode (instr : instr_t) return opcode_t;
	function get_rd (instr : instr_t) return reg_address_t;
	function get_rs1 (instr : instr_t) return reg_address_t;
	function get_rs2 (instr : instr_t) return reg_address_t;
	function get_funct3 (instr : instr_t) return funct3_t;
	function get_funct7 (instr : instr_t) return funct7_t;

	constant OPCODE_LOAD   : opcode_t := "0000011";
	constant OPCODE_STORE  : opcode_t := "0100011";
	constant OPCODE_BRANCH : opcode_t := "1100011";
	constant OPCODE_JALR   : opcode_t := "1100111";
	constant OPCODE_JAL    : opcode_t := "1101111";
	constant OPCODE_OP_IMM : opcode_t := "0010011";
	constant OPCODE_OP     : opcode_t := "0110011";
	constant OPCODE_AUIPC  : opcode_t := "0010111";
	constant OPCODE_LUI    : opcode_t := "0110111";
	constant OPCODE_FENCE  : opcode_t := "0001111";
	constant OPCODE_SYSTEM : opcode_t := "1110011";

	-- M extension
	constant FUNCT7_EXT_M  : funct7_t := "0000001";
	constant FUNCT3_MUL    : funct3_t := "000";
	constant FUNCT3_MULH   : funct3_t := "001";
	constant FUNCT3_MULHSU : funct3_t := "010";
	constant FUNCT3_MULHU  : funct3_t := "011";
	constant FUNCT3_DIV    : funct3_t := "100";
	constant FUNCT3_DIVU   : funct3_t := "101";
	constant FUNCT3_REM    : funct3_t := "110";
	constant FUNCT3_REMU   : funct3_t := "111";


	-- further useful constants
	constant REG_COUNT : positive      := 2**WIDTH_REG_ADDRESS;
	constant ZERO_REG  : reg_address_t := (others => '0');
	constant ZERO_DATA : data_t        := (others => '0');

	constant NOP_INSTR    : instr_t := X"00000013"; -- addi x0,x0,0
	constant EBREAK_INSTR : instr_t := X"00100073";
	constant ECALL_INSTR  : instr_t := X"00000073";

	type instr_format_t is (
		FORMAT_U,
		FORMAT_J,
		FORMAT_I,
		FORMAT_B,
		FORMAT_S,
		FORMAT_R,
		FORMAT_INVALID
	);

	function opcode_to_string(opcode : opcode_t) return string;
	function to_string(fmt : instr_format_t) return string;


end package;


package body rv_core_pkg is

	function get_opcode (instr : instr_t) return opcode_t is
	begin
		return instr(WIDTH_OPCODE+INDEX_OPCODE-1 downto INDEX_OPCODE);
	end function;

	function get_rd (instr : instr_t) return reg_address_t is
	begin
		return instr(WIDTH_REG_ADDRESS+INDEX_RD-1 downto INDEX_RD);
	end function;

	function get_rs1 (instr : instr_t) return reg_address_t is
	begin
		return instr(WIDTH_REG_ADDRESS+INDEX_RS1-1 downto INDEX_RS1);
	end function;

	function get_rs2 (instr : instr_t) return reg_address_t is
	begin
		return instr(WIDTH_REG_ADDRESS+INDEX_RS2-1 downto INDEX_RS2);
	end function;

	function get_funct3 (instr : instr_t) return funct3_t is
	begin
		return instr(WIDTH_FUNCT3+INDEX_FUNCT3-1 downto INDEX_FUNCT3);
	end function;

	function get_funct7 (instr : instr_t) return funct7_t is
	begin
		return instr(WIDTH_FUNCT7+INDEX_FUNCT7-1 downto INDEX_FUNCT7);
	end function;


	function opcode_to_string(opcode : opcode_t) return string is
	begin
		case opcode is
			when OPCODE_LOAD   => return "load";
			when OPCODE_STORE  => return "store";
			when OPCODE_BRANCH => return "branch";
			when OPCODE_JALR   => return "jalr";
			when OPCODE_JAL    => return "jal";
			when OPCODE_OP_IMM => return "op_imm";
			when OPCODE_OP     => return "op";
			when OPCODE_AUIPC  => return "auipc";
			when OPCODE_LUI    => return "lui";
			when OPCODE_FENCE  => return "fence";
			when OPCODE_SYSTEM => return "system";
			when others   => null;
		end case;
		return "UNKNOWN";
	end function;

	function to_string(fmt : instr_format_t) return string is
	begin
		case fmt is
			when FORMAT_U => return "U";
			when FORMAT_J => return "J";
			when FORMAT_I => return "I";
			when FORMAT_B => return "B";
			when FORMAT_S => return "S";
			when FORMAT_R => return "R";
			when FORMAT_INVALID => return "INVALID";
		end case;
		return "UNKNOWN";
	end function;


end package body;
