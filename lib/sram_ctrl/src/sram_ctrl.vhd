
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sram_ctrl_pkg.all;

entity sram_ctrl is
	generic (
		ADDR_WIDTH  : positive := 21;
		DATA_WIDTH  : positive := 16;
		WR_BUF_SIZE : positive := 8
	);
	port (
		clk   : in  std_ulogic;
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
begin
	assert DATA_WIDTH = 16 severity failure;
end entity;

