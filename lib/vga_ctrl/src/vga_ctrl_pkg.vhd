library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package vga_ctrl_pkg is
	type vga_pixel_color_t is record
		r : std_ulogic_vector(7 downto 0);
		g : std_ulogic_vector(7 downto 0);
		b : std_ulogic_vector(7 downto 0);
	end record;

	constant VGA_PIXEL_COLOR_WHITE : vga_pixel_color_t := (others => x"FF");
	constant VGA_PIXEL_COLOR_BLACK : vga_pixel_color_t := (others => x"00");
	constant VGA_PIXEL_COLOR_RED   : vga_pixel_color_t := (r => x"FF", others => x"00");
	constant VGA_PIXEL_COLOR_GREEN : vga_pixel_color_t := (g => x"FF", others => x"00");
	constant VGA_PIXEL_COLOR_BLUE  : vga_pixel_color_t := (b => x"FF", others => x"00");

	function rgb_to_vga_pixel_color(r, g, b : std_ulogic_vector(7 downto 0)) return vga_pixel_color_t;
	function rgb_to_vga_pixel_color(r, g, b : unsigned(7 downto 0)) return vga_pixel_color_t;
	function rgb_to_vga_pixel_color(r, g, b : natural) return vga_pixel_color_t;

	function rgb_332_to_vga_pixel_color(rgb : std_ulogic_vector(7 downto 0)) return vga_pixel_color_t;
	function rgb_332_to_vga_pixel_color(rgb : unsigned(7 downto 0)) return vga_pixel_color_t;
	function rgb_332_to_vga_pixel_color(rgb : natural) return vga_pixel_color_t;

	function rgb_565_to_vga_pixel_color(rgb : std_ulogic_vector(15 downto 0)) return vga_pixel_color_t;
	function rgb_565_to_vga_pixel_color(rgb : unsigned(15 downto 0)) return vga_pixel_color_t;
	function rgb_565_to_vga_pixel_color(rgb : natural) return vga_pixel_color_t;

	component vga_ctrl is
		generic (
			H_FRONT_PORCH  : integer; -- in clk cycles
			H_BACK_PORCH   : integer; -- in clk cycles
			H_SYNC_PULSE   : integer; -- in clk cycles
			H_VISIBLE_AREA : integer; -- the horizontal resolution
			V_FRONT_PORCH  : integer; -- in lines
			V_BACK_PORCH   : integer; -- in lines
			V_SYNC_PULSE   : integer; -- in lines
			V_VISIBLE_AREA : integer  -- the vertical resolution
		);
		port (
			clk     : in  std_ulogic;
			res_n   : in  std_ulogic;

			frame_start : out std_ulogic;
			pix_color   : in vga_pixel_color_t;
			pix_ack     : out std_ulogic; -- read next pixel value from FIFO

			-- connection to VGA connector/DAC
			vga_hsync       : out std_ulogic;
			vga_vsync       : out std_ulogic;
			vga_dac_clk     : out std_ulogic;
			vga_dac_blank_n : out std_ulogic;
			vga_dac_sync_n  : out std_ulogic;
			vga_dac_color   : out vga_pixel_color_t
		);
	end component;

	component tpg is
		generic (
			WIDTH  : integer := 640;
			HEIGHT : integer := 480
		);
		port (
			clk   : in std_ulogic;
			res_n : in std_ulogic;

			frame_start : in std_ulogic;
			pix_ack     : in std_ulogic;
			pix_color   : out vga_pixel_color_t
		);
	end component;

	component dac_dump is
		generic (
			H_FRONT_PORCH  : integer; -- in clk cycles
			H_BACK_PORCH   : integer; -- in clk cycles
			H_SYNC_PULSE   : integer; -- in clk cycles
			H_VISIBLE_AREA : integer; -- the horizontal resolution
			V_VISIBLE_AREA : integer; -- the vertical resolution
			CLK_PERIOD     : time;    -- the clock period in ns
			BMP_BASE_NAME  : string := "dump" -- base name of dump files
		);
		port (
			clk             : in std_ulogic;
			vga_hsync       : in std_ulogic;
			vga_vsync       : in std_ulogic;
			vga_dac_clk     : in std_ulogic;
			vga_dac_blank_n : in std_ulogic;
			vga_dac_sync_n  : in std_ulogic;
			vga_dac_color   : in vga_pixel_color_t;
			frame_start     : in std_ulogic
		);
	end component;
end package;

package body vga_ctrl_pkg is
	function rgb_to_vga_pixel_color(r, g, b : std_ulogic_vector(7 downto 0)) return vga_pixel_color_t is
		variable pixel_color : vga_pixel_color_t;
	begin
		pixel_color.r := r;
		pixel_color.g := g;
		pixel_color.b := b;

		return pixel_color;
	end function;

	function rgb_to_vga_pixel_color(r, g, b : unsigned(7 downto 0)) return vga_pixel_color_t is
	begin
		return rgb_to_vga_pixel_color(std_ulogic_vector(r), std_ulogic_vector(g), std_ulogic_vector(b));
	end function;

	function rgb_to_vga_pixel_color(r, g, b : natural) return vga_pixel_color_t is
	begin
		-- synthesis translate_off
		assert r <= 255 and g <= 255 and b <= 255 report "Can only convert RGB values <= 255 to VGA pixel color but got R=" & to_string(r) & ", G=" & to_string(g) & ", B=" & to_string(b);
		-- synthesis translate_on
		return rgb_to_vga_pixel_color(to_unsigned(r, 8), to_unsigned(g, 8), to_unsigned(b, 8));
	end function;

	function rgb_332_to_vga_pixel_color(rgb : std_ulogic_vector(7 downto 0)) return vga_pixel_color_t is
		variable pixel_color : vga_pixel_color_t;
	begin
		pixel_color.r := rgb(7 downto 6) & rgb(5) & rgb(5) & rgb(5) & rgb(5) & rgb(5) & rgb(5);
		pixel_color.g := rgb(4 downto 3) & rgb(2) & rgb(2) & rgb(2) & rgb(2) & rgb(2) & rgb(2);
		pixel_color.b := rgb(1 downto 1) & rgb(0) & rgb(0) & rgb(0) & rgb(0) & rgb(0) & rgb(0) & rgb(0);
		return pixel_color;
	end function;

	function rgb_332_to_vga_pixel_color(rgb : unsigned(7 downto 0)) return vga_pixel_color_t is
		variable pixel_color : vga_pixel_color_t;
	begin
		return rgb_332_to_vga_pixel_color(std_ulogic_vector(rgb));
	end function;

	function rgb_332_to_vga_pixel_color(rgb : natural) return vga_pixel_color_t is
		variable pixel_color : vga_pixel_color_t;
	begin
		-- synthesis translate_off
		assert rgb <= 255 report "Can only convert RGB-332 values <= 255 to VGA pixel color but got " & to_string(rgb);
		-- synthesis translate_on
		return rgb_332_to_vga_pixel_color(to_unsigned(rgb, 8));
	end function;

	function rgb_565_to_vga_pixel_color(rgb : std_ulogic_vector(15 downto 0)) return vga_pixel_color_t is
		variable pixel_color : vga_pixel_color_t;
	begin
		pixel_color.r(7 downto 4) := rgb(15 downto 12);
		pixel_color.r(3 downto 0) := (others => rgb(11));

		pixel_color.g(7 downto 3) := rgb(10 downto 6);
		pixel_color.g(2 downto 0) := (others => rgb(5));

		pixel_color.r(7 downto 4) := rgb(4 downto 1);
		pixel_color.r(3 downto 0) := (others => rgb(0));
		return pixel_color;
	end function;

	function rgb_565_to_vga_pixel_color(rgb : unsigned(15 downto 0)) return vga_pixel_color_t is
		variable pixel_color : vga_pixel_color_t;
	begin
		return rgb_565_to_vga_pixel_color(std_ulogic_vector(rgb));
	end function;

	function rgb_565_to_vga_pixel_color(rgb : natural) return vga_pixel_color_t is
		variable pixel_color : vga_pixel_color_t;
	begin
		-- synthesis translate_off
		assert rgb < 2**16 report "Can only convert RGB-332 values < 2^16 to VGA pixel color but got " & to_string(rgb);
		-- synthesis translate_on
		return rgb_565_to_vga_pixel_color(to_unsigned(rgb, 16));
	end function;
end package body;
