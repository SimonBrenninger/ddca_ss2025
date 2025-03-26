library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package sram_ctrl_pkg is

	type sram_access_mode_t is (BYTE, WORD);

	function to_sul(x : sram_access_mode_t) return std_ulogic;
	function to_sram_access_mode_t(x : std_ulogic) return sram_access_mode_t;

	component sram_ctrl is
		generic (
			ADDR_WIDTH  : positive := 21;
			DATA_WIDTH  : positive := 16;
			WR_BUF_SIZE : positive := 8
		);
		port (
			clk : in std_ulogic;
			res_n : in std_ulogic;

			-- write port (buffered)
			wr_addr        : in  std_ulogic_vector(ADDR_WIDTH-1 downto 0);
			wr_data        : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
			wr             : in  std_ulogic;
			wr_access_mode : in  sram_access_mode_t;
			wr_empty       : out std_ulogic;
			wr_full        : out std_ulogic;
			wr_half_full   : out std_ulogic;

			-- read port 1 (high priority)
			rd1_addr        : in  std_ulogic_vector(ADDR_WIDTH-1 downto 0);
			rd1             : in  std_ulogic;
			rd1_access_mode : in  sram_access_mode_t;
			rd1_busy        : out std_ulogic;
			rd1_data        : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
			rd1_valid       : out std_ulogic;

			-- read port 2 (low priority)
			rd2_addr        : in  std_ulogic_vector(ADDR_WIDTH-1 downto 0);
			rd2             : in  std_ulogic;
			rd2_access_mode : in  sram_access_mode_t;
			rd2_busy        : out std_ulogic;
			rd2_data        : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
			rd2_valid       : out std_ulogic;

			-- external interface to SRAM
			sram_dq   : inout std_logic_vector(DATA_WIDTH-1 downto 0);
			sram_addr :   out std_ulogic_vector(ADDR_WIDTH-2 downto 0);
			sram_ub_n :   out std_ulogic;
			sram_lb_n :   out std_ulogic;
			sram_we_n :   out std_ulogic;
			sram_ce_n :   out std_ulogic;
			sram_oe_n :   out std_ulogic
		);
	end component;

	component IS61WV102416BLL is
		port (
			a    : in    std_ulogic_vector(19 downto 0);
			io   : inout std_ulogic_vector(15 downto 0);
			ce_n : in    std_ulogic;
			oe_n : in    std_ulogic;
			we_n : in    std_ulogic;
			lb_n : in    std_ulogic;
			ub_n : in    std_ulogic
		);
	end component;
end package;


package body sram_ctrl_pkg is

	function to_sul(x : sram_access_mode_t) return std_ulogic is
	begin
		if (x = WORD) then
			return '1';
		end if;
		return '0';
	end function;

	function to_sram_access_mode_t(x : std_ulogic) return sram_access_mode_t is
	begin
		if (x = '1') then
			return WORD;
		end if;
		return BYTE;
	end function;

end package body;

