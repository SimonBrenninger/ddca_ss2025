library ieee;
use ieee.std_logic_1164.all;

use work.vga_ctrl_pkg.all;


architecture top_arch_vga_ctrl of top is
	signal clk_25, res_n            : std_ulogic;
	signal frame_start, pix_ack     : std_ulogic;
	signal pix_color, vga_dac_color : vga_pixel_color_t;
begin

	res_n <= keys(0);

	-- the vga_trl is clocked by 25 MHz rather than 50
	pll_inst : entity work.pll
	port map (
		inclk0 => clk,
		c0     => clk_25
	);

	vga_cntrl_inst : entity work.vga_ctrl(arch)
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
		clk   => clk_25,
		res_n => res_n,

		frame_start => frame_start,
		pix_color   => pix_color,
		pix_ack     => pix_ack,

		vga_hsync       => vga_hsync,
		vga_vsync       => vga_vsync,
		vga_dac_clk     => vga_dac_clk,
		vga_dac_blank_n => vga_dac_blank_n,
		vga_dac_sync_n  => vga_dac_sync_n,
		vga_dac_color   => vga_dac_color
	);

	vga_dac_r <= std_ulogic_vector(vga_dac_color.r);
	vga_dac_g <= std_ulogic_vector(vga_dac_color.g);
	vga_dac_b <= std_ulogic_vector(vga_dac_color.b);

	tpg_inst : entity work.tpg
	port map (
		clk   => clk_25,
		res_n => res_n,

		frame_start => frame_start,
		pix_color   => pix_color,
		pix_ack     => pix_ack
	);

end architecture;
