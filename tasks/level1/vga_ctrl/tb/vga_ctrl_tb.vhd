library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vga_ctrl_pkg.all;


entity vga_ctrl_tb is
end entity;

architecture bench of vga_ctrl_tb is
	constant CLK_PERIOD : time := 40 ns;
	signal stop_clock   : boolean := false;
	signal clk, res_n   : std_ulogic;

	constant H_FRONT_PORCH  : integer := 16;
	constant H_BACK_PORCH   : integer := 48;
	constant H_SYNC_PULSE   : integer := 96;
	constant H_VISIBLE_AREA : integer := 640;
	constant V_FRONT_PORCH  : integer := 10;
	constant V_BACK_PORCH   : integer := 33;
	constant V_SYNC_PULSE   : integer := 2;
	constant V_VISIBLE_AREA : integer := 480;

	-- vga_ctrl input MUX select
	signal vga_ctrl_in_select : std_ulogic := '0';

	signal frame_start, pix_ack : std_ulogic;
	signal pix_color, pix_color_tpg, pix_color_stim : vga_pixel_color_t;
	signal vga_hsync, vga_vsync : std_ulogic;
	signal vga_dac_clk, vga_dac_blank_n, vga_dac_sync_n : std_ulogic;
	signal vga_dac_color : vga_pixel_color_t;
begin

	pix_color <= pix_color_tpg when vga_ctrl_in_select = '0' else pix_color_stim;

	stimulus : process
	begin
		pix_color_stim <= VGA_PIXEL_COLOR_BLACK;
		res_n <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';
		wait until rising_edge(frame_start);

		-- vga_ctrl_in_select <= '1'; -- switch to manual vga_ctrl inputs instead of tpg
		-- TODO: Add manual stimuli here as needed
		-- pix_color_stim <= VGA_PIXEL_COLOR_BLACK;

		stop_clock <= true;
		report "Testbench done";
		wait;
	end process;

	generate_clk : process
	begin
		while not stop_clock loop
			clk <= '0', '1' after CLK_PERIOD / 2;
			wait for CLK_PERIOD;
		end loop;
		wait;
	end process;

	uut: entity work.vga_ctrl(arch)
		generic map (
			H_FRONT_PORCH  => H_FRONT_PORCH,
			H_BACK_PORCH   => H_BACK_PORCH,
			H_SYNC_PULSE   => H_SYNC_PULSE,
			H_VISIBLE_AREA => H_VISIBLE_AREA,
			V_FRONT_PORCH  => V_FRONT_PORCH,
			V_BACK_PORCH   => V_BACK_PORCH,
			V_SYNC_PULSE   => V_SYNC_PULSE,
			V_VISIBLE_AREA => V_VISIBLE_AREA
		)
		port map (
			clk             => clk,
			res_n           => res_n,
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

	dac_dump_inst : entity work.dac_dump
	generic map (
		CLK_PERIOD     => 40 ns,
		H_FRONT_PORCH  => H_FRONT_PORCH,
		H_BACK_PORCH   => H_BACK_PORCH,
		H_SYNC_PULSE   => H_SYNC_PULSE,
		H_VISIBLE_AREA => H_VISIBLE_AREA,
		V_VISIBLE_AREA => V_VISIBLE_AREA
	)
	port map (
		clk             => clk,
		frame_start     => frame_start,
		vga_hsync       => vga_hsync,
		vga_vsync       => vga_vsync,
		vga_dac_clk     => vga_dac_clk,
		vga_dac_blank_n => vga_dac_blank_n,
		vga_dac_sync_n  => vga_dac_sync_n,
		vga_dac_color   => vga_dac_color
	);

	tpg_inst : entity work.tpg
	port map (
		clk   => clk,
		res_n => res_n,

		frame_start => frame_start,
		pix_color   => pix_color_tpg,
		pix_ack     => pix_ack
	);


end architecture;

