library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vga_ctrl_pkg.all;


entity tpg is
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
end entity;

architecture arch of tpg is
	signal x : integer range 0 to WIDTH-1;
	signal y : integer range 0 to HEIGHT;
	signal first_pix : boolean;
	signal frame_start_last : std_ulogic;
begin
	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			x <= 0;
			y <= 0;
			pix_color <= VGA_PIXEL_COLOR_BLACK;
			first_pix <= false;
			frame_start_last <= '0';
		elsif (rising_edge(clk)) then
			frame_start_last <= frame_start;
			first_pix <= false;

			if (frame_start='1' and frame_start_last='0') then
				x <= 0;
				y <= 0;
				first_pix <= true;
			end if;

			if (first_pix or pix_ack = '1') then
				if (x = WIDTH-1) then
					if (y = HEIGHT-1) then
						y <= 0;
					else
						y <= y + 1;
					end if;
					x <= 0;
				else
					x <= x + 1;
				end if;

				pix_color <= VGA_PIXEL_COLOR_BLACK;

				if (x < 256 and y < 256) then
					-- color gradient
					pix_color <= rgb_to_vga_pixel_color(x, y, 255-x);
				elsif (x < WIDTH/5) then
					pix_color <= VGA_PIXEL_COLOR_BLACK;
				elsif (x < WIDTH/5*2) then
					pix_color <= VGA_PIXEL_COLOR_WHITE;
				elsif (x < WIDTH/5*3) then
					pix_color <= VGA_PIXEL_COLOR_RED;
				elsif (x < WIDTH/5*4) then
					pix_color <= VGA_PIXEL_COLOR_GREEN;
				else
					pix_color <= VGA_PIXEL_COLOR_BLUE;
				end if;

				--white frame
				if (x=0 or x=WIDTH-1 or y=0 or y=HEIGHT-1) then
					pix_color <= VGA_PIXEL_COLOR_WHITE;
				end if;
			end if;
		end if;
	end process;
end architecture;

