library ieee;
use ieee.std_logic_1164.all;

use work.gfx_core_pkg.all;
use work.sram_ctrl_pkg.all;
use work.vga_ctrl_pkg.all;
use work.mem_pkg.all;


entity vga_gfx_ctrl is
	port (
		clk   : in std_ulogic;
		res_n : in std_ulogic;
		display_clk   : in std_ulogic;
		display_res_n : in std_ulogic;

		-- gfx command interface
		gci_in : in gci_in_t;
		gci_out : out gci_out_t;

		-- external interface to SRAM
		sram_dq : inout std_logic_vector(15 downto 0);
		sram_addr : out std_ulogic_vector(19 downto 0);
		sram_ub_n : out std_ulogic;
		sram_lb_n : out std_ulogic;
		sram_we_n : out std_ulogic;
		sram_ce_n : out std_ulogic;
		sram_oe_n : out std_ulogic;

		-- connection to VGA connector/DAC
		vga_hsync       : out std_ulogic;
		vga_vsync       : out std_ulogic;
		vga_dac_clk     : out std_ulogic;
		vga_dac_blank_n : out std_ulogic;
		vga_dac_sync_n  : out std_ulogic;
		vga_dac_color   : out vga_pixel_color_t
	);
end entity;

architecture arch of vga_gfx_ctrl is
	constant INSTR_FIFO_DEPTH : integer := 32;

	constant SRAM_ADDR_WIDTH : integer := 21;
	constant SRAM_DATA_WIDTH : integer := 16;

	signal vram_wr_addr : std_ulogic_vector(SRAM_ADDR_WIDTH-1 downto 0);
	signal vram_wr_data : std_ulogic_vector(SRAM_DATA_WIDTH-1 downto 0);
	signal vram_wr      : std_ulogic;
	signal vram_wr_access_mode : sram_access_mode_t;
	signal vram_wr_full : std_ulogic;

	signal vram_rd_addr  : std_ulogic_vector(SRAM_ADDR_WIDTH-1 downto 0);
	signal vram_rd_data  : std_ulogic_vector(SRAM_DATA_WIDTH-1 downto 0);
	signal vram_rd       : std_ulogic;
	signal vram_rd_valid : std_ulogic;
	signal vram_rd_access_mode : sram_access_mode_t;
	signal vram_rd_busy : std_ulogic;
	signal vram_wr_emtpy : std_ulogic;

	signal fr_base_addr : std_ulogic_vector(SRAM_ADDR_WIDTH-1 downto 0);
	signal fr_base_addr_req : std_ulogic;

	signal fr_vram_rd_addr   : std_ulogic_vector(SRAM_ADDR_WIDTH-1 downto 0);
	signal fr_vram_rd        : std_ulogic;
	signal fr_vram_rd_access_mode : sram_access_mode_t;
	signal fr_vram_rd_busy  : std_ulogic;
	signal fr_vram_rd_data  : std_ulogic_vector(SRAM_DATA_WIDTH-1 downto 0);
	signal fr_vram_rd_valid : std_ulogic;

	signal pix_ack : std_ulogic;
	signal pix_color    : vga_pixel_color_t;

	signal gcf_rd : std_ulogic;
	signal gcf_empty : std_ulogic;
	signal gcf_data : gfx_cmd_t;

	signal frame_start : std_ulogic;
begin

	-- graphics command FIFO
	gcf : fifo_1c1r1w
	generic map (
		DEPTH => INSTR_FIFO_DEPTH,
		DATA_WIDTH => GFX_CMD_WIDTH
	)
	port map (
		clk       => clk,
		res_n     => res_n,
		wr_data   => gci_in.wr_data,
		wr        => gci_in.wr,
		full      => gci_out.full,
		rd        => gcf_rd,
		rd_data   => gcf_data,
		empty     => gcf_empty
	);

	rasterizer_inst : entity work.rasterizer
	generic map (
		VRAM_ADDR_WIDTH  => SRAM_ADDR_WIDTH,
		VRAM_DATA_WIDTH => SRAM_DATA_WIDTH
	)
	port map (
		clk   => clk,
		res_n => res_n,
		-- VRAM write port
		vram_wr_addr        => vram_wr_addr,
		vram_wr_data        => vram_wr_data,
		vram_wr_full        => vram_wr_full,
		vram_wr_emtpy       => vram_wr_emtpy,
		vram_wr             => vram_wr,
		vram_wr_access_mode => vram_wr_access_mode,
		-- VRAM read port
		vram_rd_addr        => vram_rd_addr,
		vram_rd_data        => vram_rd_data,
		vram_rd_busy        => vram_rd_busy,
		vram_rd_valid       => vram_rd_valid,
		vram_rd             => vram_rd,
		vram_rd_access_mode => vram_rd_access_mode,
		-- frame reader base address configuration
		fr_base_addr     => fr_base_addr,
		fr_base_addr_req => fr_base_addr_req,
		-- gfx command FIFO read port
		gcf_rd    => gcf_rd,
		gcf_data  => gcf_data,
		gcf_empty => gcf_empty,
		-- gci_out signals
		rd_data    => gci_out.rd_data,
		rd_valid   => gci_out.rd_valid,
		frame_sync => gci_out.frame_sync
	);

	sram_ctrl_inst : entity work.sram_ctrl
	generic map (
		ADDR_WIDTH => SRAM_ADDR_WIDTH,
		DATA_WIDTH => SRAM_DATA_WIDTH
	)
	port map (
		clk       => clk,
		res_n     => res_n,
		-- write port (rasterizer)
		wr_addr   => vram_wr_addr,
		wr_data   => vram_wr_data,
		wr        => vram_wr,
		wr_access_mode => vram_wr_access_mode,
		wr_full   => vram_wr_full,
		wr_empty  => vram_wr_emtpy,
		wr_half_full => open,
		-- read port 1 (frame_reader)
		rd1_addr        => fr_vram_rd_addr,
		rd1             => fr_vram_rd,
		rd1_access_mode => fr_vram_rd_access_mode,
		rd1_busy        => fr_vram_rd_busy,
		rd1_data        => fr_vram_rd_data,
		rd1_valid       => fr_vram_rd_valid,
		-- read port 2 (rasterizer)
		rd2_addr        => vram_rd_addr,
		rd2             => vram_rd,
		rd2_access_mode => vram_rd_access_mode,
		rd2_busy        => vram_rd_busy,
		rd2_data        => vram_rd_data,
		rd2_valid       => vram_rd_valid,
		-- external signals
		sram_dq   => sram_dq,
		sram_addr => sram_addr,
		sram_ub_n => sram_ub_n,
		sram_lb_n => sram_lb_n,
		sram_we_n => sram_we_n ,
		sram_ce_n => sram_ce_n,
		sram_oe_n => sram_oe_n
	);

	frame_reader_inst : entity work.frame_reader
	generic map (
		VRAM_ADDR_WIDTH => SRAM_ADDR_WIDTH,
		VRAM_DATA_WIDTH => SRAM_DATA_WIDTH
	)
	port map (
		clk            => clk,
		res_n          => res_n,
		-- display clock
		display_clk    => display_clk,
		display_res_n  => display_res_n,
		-- interface to Rasterizer
		base_addr_req  => fr_base_addr_req,
		base_addr      => fr_base_addr,
		-- interface to SRAM
		vram_rd_addr   => fr_vram_rd_addr,
		vram_rd        => fr_vram_rd,
		vram_rd_access_mode => fr_vram_rd_access_mode,
		vram_rd_busy   => fr_vram_rd_busy,
		vram_rd_data   => fr_vram_rd_data,
		vram_rd_valid  => fr_vram_rd_valid,
		-- interface to VGA Controller
		frame_start    => frame_start,
		pix_ack        => pix_ack,
		pix_color      => pix_color
	);

	vga_ctrl_inst : entity work.vga_ctrl
	generic map (
		H_FRONT_PORCH  => 16,
		H_BACK_PORCH   => 48,
		H_SYNC_PULSE   => 96,
		H_VISIBLE_AREA => 640,
		V_FRONT_PORCH  => 10,
		V_BACK_PORCH   => 33,
		V_SYNC_PULSE   => 2,
		V_VISIBLE_AREA => 480
	)
	port map (
		clk             => display_clk,
		res_n           => display_res_n,
		frame_start     => frame_start,
		pix_color       => pix_color,
		pix_ack         => pix_ack,
		vga_hsync       => vga_hsync,
		vga_vsync       => vga_vsync,
		vga_dac_clk     => vga_dac_clk,
		vga_dac_blank_n => vga_dac_blank_n,
		vga_dac_sync_n  => vga_dac_sync_n,
		vga_dac_color   => vga_dac_color
	);

end architecture;




