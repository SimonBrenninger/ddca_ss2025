library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

use work.vga_ctrl_pkg.all;


entity dac_dump is
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
end entity;


architecture arch of dac_dump is
	file output_img : text;
	shared variable current_img : integer := 0;
begin

	process
		variable img_line : line;
	begin
		wait until rising_edge(frame_start);
		-- frame_start comes one line before the actual data is expected
		wait for (H_VISIBLE_AREA+H_FRONT_PORCH+H_SYNC_PULSE+H_BACK_PORCH+1) * CLK_PERIOD;

		file_open(output_img, BMP_BASE_NAME & to_string(current_img) & ".ppm", write_mode);

		-- add .bmp file header
		swrite(img_line, "P3");
		writeline(output_img, img_line);
		swrite(img_line, to_string(640) & " " & to_string(480));
		writeline(output_img, img_line);
		swrite(img_line, to_string(2**8-1));
		writeline(output_img, img_line);

		for y in 0 to V_VISIBLE_AREA-1 loop -- for 480 lines
			for x in 0 to H_VISIBLE_AREA-1 loop -- 640 cycles data
				if x /= 0 then
					swrite(img_line, "  ");
				end if;
				swrite(img_line, to_string(to_integer(unsigned(vga_dac_color.r))) & " " & to_string(to_integer(unsigned(vga_dac_color.g))) & " " & to_string(to_integer(unsigned(vga_dac_color.b))));
				wait for CLK_PERIOD;
			end loop;

			writeline(output_img, img_line);
			wait for (CLK_PERIOD*(H_FRONT_PORCH+H_BACK_PORCH+H_SYNC_PULSE));
		end loop;

		file_close(output_img);
		current_img := current_img + 1;
	end process;

end architecture;
