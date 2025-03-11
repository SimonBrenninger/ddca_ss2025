library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all;
use ieee.std_logic_textio.all;

use work.math_pkg.all;
use work.tb_util_pkg.all;
use work.gfx_core_pkg.all;


entity gfx_cmd_interpreter is
	generic (
		OUTPUT_DIR : string := "./"
	);
	port (
		clk     : in std_ulogic;
		gci_in  : in gci_in_t;
		gci_out : out gci_out_t
	);
end entity;

architecture arch of gfx_cmd_interpreter is

	shared variable vram : vram_t;

	type bitmap_descriptor_t is record
		base_address : natural;
		width : natural;
		height : natural;
	end record;

	-- Checks if pixel at x, y is inside bitmap b's bounds
	function is_oob(b : bitmap_descriptor_t; x, y : integer) return boolean is
	begin
	-- TODO: Implement
		return true;
	end function;

	-- Check if in bounds and set pixel
	procedure set_pixel(
		b           : bitmap_descriptor_t;
		x, y        : integer;
		color       : std_ulogic_vector(7 downto 0);
		alpha_mode  : boolean := false;
		alpha_color : std_ulogic_vector(7 downto 0) := (others=>'0')
	) is
	begin
	-- TODO: Implement
	end procedure;

	-- TODO: Add further functions, procedures, types and signals to increase readability and reduce code duplication

begin

	init_vram : process
	begin
		vram.init(21);
		wait;
	end process;

	demo : process
		procedure wait_next_data is
		begin
			loop
				wait until rising_edge(clk);
				gci_out.rd_valid <= '0';
				if (gci_in.wr = '1') then
					return;
				else
					next;
				end if;
			end loop;
		end procedure;

		procedure read_vram_address(addr : out natural) is
		begin
			wait_next_data;
			addr := to_integer(unsigned(gci_in.wr_data));
			wait_next_data;
			addr := addr + 2**16 * to_integer(unsigned(gci_in.wr_data));
		end procedure;

		variable vram_addr : natural;
		variable m         : std_ulogic;

		-- TODO: Add further variables, procedures and functions to increase readability and reduce code duplication
	begin
		gci_out.frame_sync <= '0';
		gci_out.rd_data <= (others => '0');
		gci_out.rd_valid <= '0';

		loop
			wait_next_data;
			m := gci_in.wr_data(INDEX_M);

			case get_opcode(gci_in.wr_data) is
			-- VRAM OPs
				when OPCODE_VRAM_READ =>
					read_vram_address(vram_addr);

					if (m = M_BYTE) then
						gci_out.rd_data <= (7 downto 0 => vram.get_byte(vram_addr), others=>'0');
					else
						gci_out.rd_data <= vram.get_word(vram_addr);
					end if;
					gci_out.rd_valid <= '1';

				when OPCODE_VRAM_WRITE =>
					read_vram_address(vram_addr);

					wait_next_data;
					if (m = M_BYTE) then
						vram.set_byte(vram_addr, gci_in.wr_data(7 downto 0));
					else
						vram.set_word(vram_addr, gci_in.wr_data(15 downto 0));
					end if;

				when OPCODE_DISPLAY_BMP =>
					vram.dump_bitmap(0, 4, 4, "out.ppm");

				-- TODO: Add other operations

				when others => report "unknown instruction: " & to_hstring(gci_in.wr_data);
			end case;
		end loop;
		wait;
	end process;
end architecture;
