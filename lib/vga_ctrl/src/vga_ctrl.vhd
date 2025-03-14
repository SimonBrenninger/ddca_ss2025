library ieee;
use ieee.std_logic_1164.all;

use work.vga_ctrl_pkg.all;


entity vga_ctrl is
	generic (
		H_FRONT_PORCH  : integer := 16;  -- in clk cycles
		H_BACK_PORCH   : integer := 48;  -- in clk cycles
		H_SYNC_PULSE   : integer := 96;  -- in clk cycles
		H_VISIBLE_AREA : integer := 640; -- the horizontal resolution
		V_FRONT_PORCH  : integer := 10;  -- in lines
		V_BACK_PORCH   : integer := 33;  -- in lines
		V_SYNC_PULSE   : integer := 2;   -- in lines
		V_VISIBLE_AREA : integer := 480  -- the vertical resolution
	);
	port (
		clk     : in  std_ulogic;
		res_n   : in  std_ulogic;

		-- internal interface
		frame_start : out std_ulogic;
		pix_color   : in vga_pixel_color_t;
		pix_ack     : out std_ulogic;

		-- connection to VGA connector/DAC
		vga_hsync       : out std_ulogic;
		vga_vsync       : out std_ulogic;
		vga_dac_clk     : out std_ulogic;
		vga_dac_blank_n : out std_ulogic;
		vga_dac_sync_n  : out std_ulogic;
		vga_dac_color   : out vga_pixel_color_t
	);
end entity;

