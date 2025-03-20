library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vga_ctrl_pkg.all;
use work.gfx_core_pkg.all;

package vga_gfx_ctrl_pkg is

	component vga_gfx_ctrl is
		port (
			clk : in std_ulogic;
			res_n : in std_ulogic;
			display_clk : in std_ulogic;
			display_res_n : in std_ulogic;
			gci_in : in gci_in_t;
			gci_out : out gci_out_t;
			sram_dq : inout std_logic_vector(15 downto 0);
			sram_addr : out std_ulogic_vector(19 downto 0);
			sram_ub_n : out std_ulogic;
			sram_lb_n : out std_ulogic;
			sram_we_n : out std_ulogic;
			sram_ce_n : out std_ulogic;
			sram_oe_n : out std_ulogic;
			vga_hsync : out std_ulogic;
			vga_vsync : out std_ulogic;
			vga_dac_clk : out std_ulogic;
			vga_dac_blank_n : out std_ulogic;
			vga_dac_sync_n : out std_ulogic;
			vga_dac_color : out vga_pixel_color_t
		);
	end component;
end package;

