
# VGA Graphics Controller Package
Comming Soon


[[_TOC_]]

## Required Files

- [frame_reader.vhd](src/frame_reader.vhd)

- [vga_gfx_ctrl_pkg.vhd](src/vga_gfx_ctrl_pkg.vhd)

- [vga_gfx_ctrl.vhd](src/vga_gfx_ctrl.vhd)

- [gfx_circle.vhd](src/gfx_circle.vhd)

- [rasterizer.vhd](src/rasterizer.vhd)

- [gfx_util_pkg.vhd](src/gfx_util_pkg.vhd)

- [pixel_reader.vhd](src/pixel_reader.vhd)

- [pixel_writer.vhd](src/pixel_writer.vhd)

- [rasterizer_arch_ref.vhd](src/rasterizer_arch_ref.vhd)

## Components

### vga_gfx_ctrl
...


```vhdl
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
```


#### Interface

Coming soon



[Return to main page](../../README.md)
