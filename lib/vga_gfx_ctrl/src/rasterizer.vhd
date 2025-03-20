
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.mem_pkg.all;
use work.sram_ctrl_pkg.all;
use work.gfx_core_pkg.all;
use work.gfx_util_pkg.all;


entity rasterizer is
	generic (
		VRAM_ADDR_WIDTH : integer := 21;
		VRAM_DATA_WIDTH : integer := 16
	);
	port (
		clk     : in  std_ulogic;
		res_n   : in  std_ulogic;

		-- write interface to VRAM
		vram_wr_addr        : out std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		vram_wr_data        : out std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
		vram_wr_full        : in  std_ulogic;
		vram_wr_emtpy       : in std_ulogic;
		vram_wr             : out std_ulogic;
		vram_wr_access_mode : out sram_access_mode_t;

		-- read interface to VRAM
		vram_rd_addr        : out std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		vram_rd_data        : in  std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
		vram_rd_busy        : in  std_ulogic;
		vram_rd             : out std_ulogic;
		vram_rd_valid       : in std_ulogic;
		vram_rd_access_mode : out sram_access_mode_t;

		-- frame reader signals
		fr_base_addr        : out std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		fr_base_addr_req    : in std_ulogic;

		-- gfx command FIFO
		fifo_gfx_cmd_rd : out std_ulogic;
		fifo_gfx_cmd : in gfx_cmd_t;
		fifo_gfx_cmd_empty : in std_ulogic;

		-- outputs signals
		rd_data    : out gfx_cmd_t;
		rd_valid   : out std_ulogic;
		frame_sync : out std_ulogic
	);
begin
	assert VRAM_DATA_WIDTH = 16 report "Rasterizer only supports VRAMs with 16 bit data width" severity failure;
end entity;
