library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all;
use ieee.std_logic_textio.all;


package tb_util_pkg is
	type random_t is protected
		impure function gen_sul_01 return std_ulogic;
		impure function gen_sulv_01(len : positive) return std_ulogic_vector;
	end protected;

	type vram_t is protected
		procedure init(addr_width : natural);
		impure function get_byte(addr : natural) return std_ulogic_vector;
		impure function get_word(addr : natural) return std_ulogic_vector;
		procedure set_byte(addr : natural; value : std_ulogic_vector(7 downto 0));
		procedure set_word(addr : natural; value : std_ulogic_vector(15 downto 0));
		procedure dump_bitmap (base_address, width, height : natural; filename : string);
	end protected;

	procedure uart_receive (signal rx: in std_ulogic; baud_rate: positive; rx_data: out std_ulogic_vector(7 downto 0));
	procedure uart_transmit (signal tx: out std_ulogic; baud_rate: positive; tx_data: std_ulogic_vector(7 downto 0));
	function to_character(b: std_ulogic_vector(7 downto 0)) return character;
end package;

package body tb_util_pkg is

	type random_t is protected body
		variable seed1, seed2 : integer := 1;

		impure function gen_sul_01 return std_ulogic is
			variable random_real : real;
		begin
			uniform(seed1, seed2, random_real);
			if (random_real > 0.5) then
				return '0';
			end if;
			return '1';
		end function;

		impure function gen_sulv_01(len : positive) return std_ulogic_vector is
			variable random_real : real;
			variable sulv        : std_ulogic_vector(len - 1 downto 0);
		begin
			for i in sulv'range loop
				uniform(seed1, seed2, random_real);
				sulv(i) := '1';
				if (random_real > 0.5) then sulv(i) := '0'; end if;
			end loop;
			return sulv;
		end function;

	end protected body;

	type vram_t is protected body
		type vram_data_t is array(natural range<>) of std_ulogic_vector;
		type vram_data_ptr_t is access vram_data_t;
		variable vram_data : vram_data_ptr_t;

		procedure init(addr_width : natural) is
		begin
			vram_data := new vram_data_t(0 to 2**addr_width-1)(7 downto 0);
			for i in 0 to vram_data'length-1 loop
				vram_data(i) := std_ulogic_vector(to_unsigned(0, 8));
			end loop;
		end procedure;

		impure function get_byte(addr : natural) return std_ulogic_vector is
			variable value : std_ulogic_vector(7 downto 0);
		begin
			assert addr < vram_data'length report "invalid address: out of bounds of VRAM" severity failure;
			value := vram_data(addr);
			return value;
		end function;

		impure function get_word(addr : natural) return std_ulogic_vector is
			variable value : std_ulogic_vector(15 downto 0);
		begin
			assert addr < vram_data'length report "invalid address: out of bounds of VRAM" severity failure;
			assert addr mod 2 = 0 report "word access is only possible to even addresses" severity failure;
			value := vram_data(addr+1) & vram_data(addr);
			return value;
		end function;

		procedure set_byte(addr : natural; value : std_ulogic_vector(7 downto 0)) is
		begin
			assert addr < vram_data'length report "invalid address: out of bounds of VRAM" severity failure;
			assert value'length = 8 report "data value, must contain exactly 8 bits not " & to_string(value'length) severity failure;
			vram_data(addr) := value;
		end procedure;

		procedure set_word(addr : natural; value : std_ulogic_vector(15 downto 0))is
		begin
			assert addr mod 2 = 0 report "word access is only possible to even addresses" severity failure;
			assert addr < vram_data'length report "invalid address: out of bounds of VRAM" severity failure;
			assert value'length = 16 report "data value, must contain exactly 16 bits not " & to_string(value'length) severity failure;
			vram_data(addr) := value(7 downto 0);
			vram_data(addr+1) := value(15 downto 8);
		end procedure;

		procedure dump_bitmap (base_address, width, height : natural; filename : string) is
			file f_img : text;
			variable img_line : line;
			variable c : std_ulogic_vector(7 downto 0);
			variable r, g, b : integer;
		begin
			assert base_address mod 2 = 0 report "Invalid base address for a bitmap. bitmaps can only start at even addresses!" severity failure;
			file_open(f_img, filename, write_mode);
			-- add header
			swrite(img_line, "P3");
			writeline(f_img, img_line);
			swrite(img_line, to_string(width) & " " & to_string(height));
			writeline(f_img, img_line);
			swrite(img_line, "255");
			writeline(f_img, img_line);
			for n_line in 0 to height-1 loop
				for n_col in 0 to width-1 loop
					c := get_byte(base_address + width * n_line + n_col);
					r := integer(real(to_integer(unsigned(c(7 downto 5)))) * 36.429);
					g := integer(real(to_integer(unsigned(c(4 downto 2)))) * 36.429);
					b := integer(real(to_integer(unsigned(c(1 downto 0)))) * 85.0);
					if n_col /= 0 then
						swrite(img_line, "  ");
					end if;
					swrite(img_line, integer'image(r) & " " & integer'image(g) & " " & integer'image(b));
				end loop;
				writeline(f_img, img_line);
			end loop;
			file_close(f_img);
		end procedure;
	end protected body;

	procedure uart_receive (signal rx : in std_ulogic; baud_rate: positive; rx_data: out std_ulogic_vector(7 downto 0) ) is
	begin
		wait until falling_edge(rx);
		wait for (1000 ms/baud_rate)*0.5;
		assert rx = '0' report "start bit error" severity warning;
		for i in 0 to 7 loop
			wait for (1000 ms/baud_rate);
			rx_data(i) := rx;
		end loop;
		wait for (1000 ms/baud_rate);
		assert rx = '1' report "stop bit error" severity warning;
	end procedure;

	procedure uart_transmit (signal tx : out std_ulogic; baud_rate: positive; tx_data: std_ulogic_vector(7 downto 0)) is
	begin
		tx <= '0';
		wait for (1000 ms/baud_rate);
		for i in 0 to 7 loop
			tx <= tx_data(i);
			wait for (1000 ms/baud_rate);
		end loop;
		tx <= '1';
		wait for (1000 ms/baud_rate);
	end procedure;

	function to_character(b: std_ulogic_vector(7 downto 0)) return character is
	begin
		return character'val(to_integer(unsigned(b)));
	end function;

end package body;
