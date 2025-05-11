library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

use work.vnorm_pkg.all;

entity vnorm_tb is
generic(
	INPUT_FILE  : string := "./tb/input.txt";
	REF_FILE    : string := "./tb/ref.txt"
);
end entity;

architecture arch of vnorm_tb is
	constant CLK_PERIOD : time := 20 ns;
	signal clk, res_n : std_ulogic;

	signal vec_in, vec_out : vec3_t;
	signal valid_in, valid_out : std_ulogic;

	impure function get_next_valid_line(file f : text) return line is
		variable l : line;
	begin

		-- TODO: Find next non-empty line that is not a comment (starting with #)

		return l;
	end function;

	function hex_to_sulv(hex : string; width : integer) return std_ulogic_vector is
		variable ret_value : std_ulogic_vector(width-1 downto 0) := (others=>'0');
		variable temp : std_ulogic_vector(3 downto 0);
	begin
		for i in 0 to hex'length-1 loop
			case hex(hex'high-i) is
				when '0' => temp := x"0";
				when '1' => temp := x"1";
				when '2' => temp := x"2";
				when '3' => temp := x"3";
				when '4' => temp := x"4";
				when '5' => temp := x"5";
				when '6' => temp := x"6";
				when '7' => temp := x"7";
				when '8' => temp := x"8";
				when '9' => temp := x"9";
				when 'a' | 'A' => temp := x"a";
				when 'b' | 'B' => temp := x"b";
				when 'c' | 'C' => temp := x"c";
				when 'd' | 'D' => temp := x"d";
				when 'e' | 'E' => temp := x"e";
				when 'f' | 'F' => temp := x"f";
				when others => report "Conversion Error: char: " & hex(hex'high-i) severity error;
			end case;
			ret_value((i+1)*4-1 downto i*4) := temp;
		end loop;
		return ret_value;
	end function;

	impure function read_next_vector(file f : text) return vec3_t is
		variable l : line;
		variable vector : vec3_t;
	begin

		-- TODO: Read next vector from file f (can be multiple lines!)

		return vector;
	end function;

begin

	uut : entity work.vnorm
	port map(
		clk        => clk,
		res_n      => res_n,
		valid_in   => valid_in,
		vector_in  => vec_in,
		valid_out  => valid_out,
		vector_out => vec_out
	);

	stimulus : process is
	begin
		res_n    <= '0';
		valid_in <= '0';
		vec_in   <= VEC3_ZERO;
		wait until rising_edge(clk);
		res_n    <= '1';
		wait until rising_edge(clk);

		-- TODO: Open INPUT_FILE, read data in there and apply it to vnorm's vector_in input

		report "Testbench done";
		std.env.stop;
		wait;
	end process;

	score : process is
	begin

		-- TODO: Open REF_FILE, read data, assert that vnorm's vector_out is correct using an assertion

		wait;
	end process;

	clk_gen : process is
	begin
		clk <= '1';
		wait for CLK_PERIOD / 2;
		clk <= '0';
		wait for CLK_PERIOD / 2;
	end process;
end architecture;
