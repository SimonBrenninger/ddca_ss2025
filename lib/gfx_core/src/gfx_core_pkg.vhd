
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package gfx_core_pkg is

	constant GFX_CMD_WIDTH : integer := 16;
	subtype gfx_cmd_t is std_ulogic_vector(GFX_CMD_WIDTH-1 downto 0);

	type gci_in_t is record
		wr_data : gfx_cmd_t;
		wr      : std_ulogic;
	end record;

	type gci_out_t is record
		full       : std_ulogic;
		rd_data    : gfx_cmd_t;
		rd_valid   : std_ulogic;
		frame_sync : std_ulogic;
	end record;

	
	constant INDEX_OPCODE : integer := 11;
	constant WIDTH_OPCODE : integer := 5;
	constant INDEX_MX : integer := 4;
	constant INDEX_MY : integer := 5;
	constant INDEX_MXS : integer := 3;
	constant WIDTH_MXS : integer := 2;
	constant INDEX_MYS : integer := 5;
	constant WIDTH_MYS : integer := 2;
	constant INDEX_CS : integer := 10;
	constant INDEX_REL : integer := 2;
	constant INDEX_M : integer := 0;
	constant INDEX_BMPIDX : integer := 0;
	constant WIDTH_BMPIDX : integer := 3;
	constant INDEX_DIR : integer := 10;
	constant INDEX_ROT : integer := 8;
	constant WIDTH_ROT : integer := 2;
	constant INDEX_FS : integer := 10;
	constant INDEX_COLOR : integer := 0;
	constant WIDTH_COLOR : integer := 8;
	constant INDEX_MASKOP : integer := 8;
	constant WIDTH_MASKOP : integer := 2;
	constant INDEX_AM : integer := 10;
	constant INDEX_INCVALUE : integer := 0;
	constant WIDTH_INCVALUE : integer := 10;
	constant INDEX_MASK : integer := 0;
	constant WIDTH_MASK : integer := 8;
	constant INDEX_XOFFSET : integer := 6;
	constant WIDTH_XOFFSET : integer := 10;
	constant INDEX_CHARWIDTH : integer := 0;
	constant WIDTH_CHARWIDTH : integer := 6;

	
	subtype opcode_t is std_ulogic_vector(WIDTH_OPCODE-1 downto 0);
	subtype mxs_t is std_ulogic_vector(WIDTH_MXS-1 downto 0);
	subtype mys_t is std_ulogic_vector(WIDTH_MYS-1 downto 0);
	subtype bmpidx_t is std_ulogic_vector(WIDTH_BMPIDX-1 downto 0);
	subtype rot_t is std_ulogic_vector(WIDTH_ROT-1 downto 0);
	subtype color_t is std_ulogic_vector(WIDTH_COLOR-1 downto 0);
	subtype maskop_t is std_ulogic_vector(WIDTH_MASKOP-1 downto 0);
	subtype incvalue_t is std_ulogic_vector(WIDTH_INCVALUE-1 downto 0);
	subtype mask_t is std_ulogic_vector(WIDTH_MASK-1 downto 0);
	subtype xoffset_t is std_ulogic_vector(WIDTH_XOFFSET-1 downto 0);
	subtype charwidth_t is std_ulogic_vector(WIDTH_CHARWIDTH-1 downto 0);

	
	-- OPCODE
	constant OPCODE_NOP : opcode_t := 5x"0";
	constant OPCODE_MOVE_GP : opcode_t := 5x"1";
	constant OPCODE_INC_GP : opcode_t := 5x"2";
	constant OPCODE_CLEAR : opcode_t := 5x"4";
	constant OPCODE_SET_PIXEL : opcode_t := 5x"5";
	constant OPCODE_DRAW_HLINE : opcode_t := 5x"6";
	constant OPCODE_DRAW_VLINE : opcode_t := 5x"7";
	constant OPCODE_DRAW_CIRCLE : opcode_t := 5x"8";
	constant OPCODE_GET_PIXEL : opcode_t := 5x"b";
	constant OPCODE_VRAM_READ : opcode_t := 5x"c";
	constant OPCODE_VRAM_WRITE : opcode_t := 5x"d";
	constant OPCODE_VRAM_WRITE_SEQ : opcode_t := 5x"e";
	constant OPCODE_VRAM_WRITE_INIT : opcode_t := 5x"f";
	constant OPCODE_SET_COLOR : opcode_t := 5x"10";
	constant OPCODE_SET_BB_EFFECT : opcode_t := 5x"11";
	constant OPCODE_DEFINE_BMP : opcode_t := 5x"12";
	constant OPCODE_ACTIVATE_BMP : opcode_t := 5x"13";
	constant OPCODE_DISPLAY_BMP : opcode_t := 5x"14";
	constant OPCODE_BB_CLIP : opcode_t := 5x"18";
	constant OPCODE_BB_FULL : opcode_t := 5x"19";
	constant OPCODE_BB_CHAR : opcode_t := 5x"1a";
	constant OPCODE_DBG : opcode_t := 5x"1f";
	-- CS
	constant CS_PRIMARY : std_ulogic := '0';
	constant CS_SECONDARY : std_ulogic := '1';
	-- M
	constant M_BYTE : std_ulogic := '0';
	constant M_WORD : std_ulogic := '1';
	-- DIR
	constant DIR_X : std_ulogic := '0';
	constant DIR_Y : std_ulogic := '1';
	-- ROT
	constant ROT_R0 : rot_t := 2x"0";
	constant ROT_R90 : rot_t := 2x"1";
	constant ROT_R180 : rot_t := 2x"2";
	constant ROT_R270 : rot_t := 2x"3";
	-- COLOR
	constant COLOR_BLACK : color_t := 8x"0";
	constant COLOR_WHITE : color_t := 8x"ff";
	constant COLOR_BLUE : color_t := 8x"3";
	constant COLOR_RED : color_t := 8x"e0";
	constant COLOR_GREEN : color_t := 8x"1c";
	constant COLOR_CYAN : color_t := 8x"1f";
	constant COLOR_MAGENTA : color_t := 8x"e3";
	constant COLOR_YELLOW : color_t := 8x"fc";
	constant COLOR_GRAY : color_t := 8x"92";
	-- MASKOP
	constant MASKOP_NOP : maskop_t := 2x"0";
	constant MASKOP_AND : maskop_t := 2x"1";
	constant MASKOP_OR : maskop_t := 2x"2";
	constant MASKOP_XOR : maskop_t := 2x"3";

	
	function get_opcode (x : gfx_cmd_t) return opcode_t;
	function get_mxs (x : gfx_cmd_t) return mxs_t;
	function get_mys (x : gfx_cmd_t) return mys_t;
	function get_bmpidx (x : gfx_cmd_t) return bmpidx_t;
	function get_rot (x : gfx_cmd_t) return rot_t;
	function get_color (x : gfx_cmd_t) return color_t;
	function get_maskop (x : gfx_cmd_t) return maskop_t;
	function get_incvalue (x : gfx_cmd_t) return incvalue_t;
	function get_mask (x : gfx_cmd_t) return mask_t;
	function get_xoffset (x : gfx_cmd_t) return xoffset_t;
	function get_charwidth (x : gfx_cmd_t) return charwidth_t;
	function create_gfx_instr(
		opcode : opcode_t := (others=>'-');
		mx : std_ulogic := '-';
		my : std_ulogic := '-';
		mxs : mxs_t := (others=>'-');
		mys : mys_t := (others=>'-');
		cs : std_ulogic := '-';
		rel : std_ulogic := '-';
		m : std_ulogic := '-';
		bmpidx : bmpidx_t := (others=>'-');
		dir : std_ulogic := '-';
		rot : rot_t := (others=>'-');
		fs : std_ulogic := '-';
		color : color_t := (others=>'-');
		maskop : maskop_t := (others=>'-');
		am : std_ulogic := '-';
		incvalue : incvalue_t := (others=>'-');
		mask : mask_t := (others=>'-')
	) return gfx_cmd_t;
	function create_bb_char_op(
		xoffset : xoffset_t := (others=>'-');
		charwidth : charwidth_t := (others=>'-')
	) return gfx_cmd_t;

	
	-- returns -1 for variable length instructions
	function get_operands_count(opc : opcode_t) return integer;
end package;


package body gfx_core_pkg is

	
	function get_opcode (x : gfx_cmd_t) return opcode_t is
	begin
		return x(WIDTH_OPCODE+INDEX_OPCODE-1 downto INDEX_OPCODE);
	end function;

	function get_mxs (x : gfx_cmd_t) return mxs_t is
	begin
		return x(WIDTH_MXS+INDEX_MXS-1 downto INDEX_MXS);
	end function;

	function get_mys (x : gfx_cmd_t) return mys_t is
	begin
		return x(WIDTH_MYS+INDEX_MYS-1 downto INDEX_MYS);
	end function;

	function get_bmpidx (x : gfx_cmd_t) return bmpidx_t is
	begin
		return x(WIDTH_BMPIDX+INDEX_BMPIDX-1 downto INDEX_BMPIDX);
	end function;

	function get_rot (x : gfx_cmd_t) return rot_t is
	begin
		return x(WIDTH_ROT+INDEX_ROT-1 downto INDEX_ROT);
	end function;

	function get_color (x : gfx_cmd_t) return color_t is
	begin
		return x(WIDTH_COLOR+INDEX_COLOR-1 downto INDEX_COLOR);
	end function;

	function get_maskop (x : gfx_cmd_t) return maskop_t is
	begin
		return x(WIDTH_MASKOP+INDEX_MASKOP-1 downto INDEX_MASKOP);
	end function;

	function get_incvalue (x : gfx_cmd_t) return incvalue_t is
	begin
		return x(WIDTH_INCVALUE+INDEX_INCVALUE-1 downto INDEX_INCVALUE);
	end function;

	function get_mask (x : gfx_cmd_t) return mask_t is
	begin
		return x(WIDTH_MASK+INDEX_MASK-1 downto INDEX_MASK);
	end function;

	function get_xoffset (x : gfx_cmd_t) return xoffset_t is
	begin
		return x(WIDTH_XOFFSET+INDEX_XOFFSET-1 downto INDEX_XOFFSET);
	end function;

	function get_charwidth (x : gfx_cmd_t) return charwidth_t is
	begin
		return x(WIDTH_CHARWIDTH+INDEX_CHARWIDTH-1 downto INDEX_CHARWIDTH);
	end function;

	function create_gfx_instr(
		opcode : opcode_t := (others=>'-');
		mx : std_ulogic := '-';
		my : std_ulogic := '-';
		mxs : mxs_t := (others=>'-');
		mys : mys_t := (others=>'-');
		cs : std_ulogic := '-';
		rel : std_ulogic := '-';
		m : std_ulogic := '-';
		bmpidx : bmpidx_t := (others=>'-');
		dir : std_ulogic := '-';
		rot : rot_t := (others=>'-');
		fs : std_ulogic := '-';
		color : color_t := (others=>'-');
		maskop : maskop_t := (others=>'-');
		am : std_ulogic := '-';
		incvalue : incvalue_t := (others=>'-');
		mask : mask_t := (others=>'-')
	) return gfx_cmd_t is
		variable instr : gfx_cmd_t := (others=>'0');
	begin
		if (opcode /= "-----") then
			instr(INDEX_OPCODE+WIDTH_OPCODE-1 downto INDEX_OPCODE) := opcode;
		end if;
		if (mx /= '-') then
			instr(INDEX_MX) := mx;
		end if;
		if (my /= '-') then
			instr(INDEX_MY) := my;
		end if;
		if (mxs /= "--") then
			instr(INDEX_MXS+WIDTH_MXS-1 downto INDEX_MXS) := mxs;
		end if;
		if (mys /= "--") then
			instr(INDEX_MYS+WIDTH_MYS-1 downto INDEX_MYS) := mys;
		end if;
		if (cs /= '-') then
			instr(INDEX_CS) := cs;
		end if;
		if (rel /= '-') then
			instr(INDEX_REL) := rel;
		end if;
		if (m /= '-') then
			instr(INDEX_M) := m;
		end if;
		if (bmpidx /= "---") then
			instr(INDEX_BMPIDX+WIDTH_BMPIDX-1 downto INDEX_BMPIDX) := bmpidx;
		end if;
		if (dir /= '-') then
			instr(INDEX_DIR) := dir;
		end if;
		if (rot /= "--") then
			instr(INDEX_ROT+WIDTH_ROT-1 downto INDEX_ROT) := rot;
		end if;
		if (fs /= '-') then
			instr(INDEX_FS) := fs;
		end if;
		if (color /= "--------") then
			instr(INDEX_COLOR+WIDTH_COLOR-1 downto INDEX_COLOR) := color;
		end if;
		if (maskop /= "--") then
			instr(INDEX_MASKOP+WIDTH_MASKOP-1 downto INDEX_MASKOP) := maskop;
		end if;
		if (am /= '-') then
			instr(INDEX_AM) := am;
		end if;
		if (incvalue /= "----------") then
			instr(INDEX_INCVALUE+WIDTH_INCVALUE-1 downto INDEX_INCVALUE) := incvalue;
		end if;
		if (mask /= "--------") then
			instr(INDEX_MASK+WIDTH_MASK-1 downto INDEX_MASK) := mask;
		end if;
		return instr;
	end function;function create_bb_char_op(
		xoffset : xoffset_t := (others=>'-');
		charwidth : charwidth_t := (others=>'-')
	) return gfx_cmd_t is
		variable instr : gfx_cmd_t := (others=>'0');
	begin
		if (xoffset /= "----------") then
			instr(INDEX_XOFFSET+WIDTH_XOFFSET-1 downto INDEX_XOFFSET) := xoffset;
		end if;
		if (charwidth /= "------") then
			instr(INDEX_CHARWIDTH+WIDTH_CHARWIDTH-1 downto INDEX_CHARWIDTH) := charwidth;
		end if;
		return instr;
	end function;

	function get_operands_count(opc : opcode_t) return integer is
	begin 
		case opc is
			when OPCODE_NOP => return 0;
			when OPCODE_MOVE_GP => return 2;
			when OPCODE_INC_GP => return 0;
			when OPCODE_CLEAR => return 0;
			when OPCODE_SET_PIXEL => return 0;
			when OPCODE_DRAW_HLINE => return 1;
			when OPCODE_DRAW_VLINE => return 1;
			when OPCODE_DRAW_CIRCLE => return 1;
			when OPCODE_GET_PIXEL => return 0;
			when OPCODE_VRAM_READ => return 2;
			when OPCODE_VRAM_WRITE => return 3;
			when OPCODE_VRAM_WRITE_SEQ => return -1;
			when OPCODE_VRAM_WRITE_INIT => return 4;
			when OPCODE_SET_COLOR => return 0;
			when OPCODE_SET_BB_EFFECT => return 0;
			when OPCODE_DEFINE_BMP => return 4;
			when OPCODE_ACTIVATE_BMP => return 0;
			when OPCODE_DISPLAY_BMP => return 0;
			when OPCODE_BB_CLIP => return 4;
			when OPCODE_BB_FULL => return 0;
			when OPCODE_BB_CHAR => return 1;
			when OPCODE_DBG => return 0;
			when others => return -2;
		end case;
		return -2;
	end function;
	
end package body;

