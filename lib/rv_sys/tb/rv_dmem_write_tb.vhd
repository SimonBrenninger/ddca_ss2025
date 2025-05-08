library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.env.all;
use std.textio.all;

use work.rv_sys_pkg.all;
use work.tb_util_pkg.all;

entity rv_dmem_write_tb is
	generic (
		TESTCASE_NAME : string;
		ELF_FILE : string;
		DMEM_FILE : string;
		MODE : string := "CHECK" -- or "LOG"
	);
end entity;

architecture arch of rv_dmem_write_tb is

	constant CLK_PERIOD : time := 20 ns;
	constant BAUD_RATE : integer := 115200;

	signal clk, res_n : std_logic;

	signal imem_in, dmem_in : mem_in_t;
	signal imem_out, dmem_out : mem_out_t;

	constant GPIO_ADDR_WIDTH : natural := 3;

	signal stop_clock : boolean := false;

	signal dmem_out_address32 : std_logic_vector(31 downto 0);


	type LINE_VECTOR is array(NATURAL range <>) of LINE;

	function trim(str : string) return string is
		alias src : string(1 to str'length) is str;
		variable ltrim, rtrim : natural;
	begin
		ltrim := 0;
		for i in src'range loop
			if src(i) /= ' ' then -- not space
				ltrim := i;
				exit;
			end if;
		end loop;

		if ltrim = 0 then
			return "";
		end if;

		rtrim := src'right;
		for i in src'reverse_range loop
			if src(i) /= ' ' then -- not space
				rtrim := i;
				exit;
			end if;
		end loop;
		return src(ltrim to rtrim);
	end function;

	function hex_to_slv(hex : string; width : integer) return std_logic_vector is
		variable ret_value : std_logic_vector(width-1 downto 0) := (others=>'0');
		variable temp : std_logic_vector(3 downto 0);
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

	impure function count_lines(filename : in string) return integer is
		file input_file : text open read_mode is filename;
		variable line_buf : line;
		variable line_count : integer := 0;
	begin
		while not endfile(input_file) loop
			readline(input_file, line_buf);
			line_count := line_count + 1;
		end loop;
	
		file_close(input_file);
		return line_count;
	end function;

	impure function split(s : string) return line_vector is
		function count_words(str : string) return integer is
			variable count : integer := 1;
			variable last_char : character := 'X';
			constant trimmed_str : string := trim(str);
		begin
			for i in trimmed_str'range loop
				if trimmed_str(i) /= ' ' and last_char = ' ' then
					count := count + 1;
				end if;
				last_char := trimmed_str(i);
			end loop;
			return count;
		end function;
		variable result : line_vector(0 to count_words(s)-1);
		variable start_idx : natural := 1;
		variable end_idx : natural := 1;
		variable idx : natural := 0;
	begin
		report s;
		loop
			while s(start_idx) = ' ' loop
				start_idx := start_idx + 1;
			end loop;

			end_idx := start_idx;
			while end_idx < s'right and s(end_idx+1) /= ' ' loop
				end_idx := end_idx + 1;
			end loop;
			report to_string(start_idx);
			report to_string(end_idx);
			report "'" & s(start_idx to end_idx) & "'";

			swrite(result(idx), s(start_idx to end_idx));

			start_idx := end_idx+1;
			idx := idx + 1;

			if end_idx >= s'length then
				exit;
			end if;
		end loop;
		return result;
	end function;
begin

	rv_inst : entity work.rv
	port map(
		clk => clk,
		res_n => res_n,
		imem_out => imem_out,
		imem_in  => imem_in,
		dmem_out => dmem_out,
		dmem_in  => dmem_in
	);

	rv_sys_inst : entity work.rv_sys
	generic map (
		BAUD_RATE => BAUD_RATE,
		CLK_FREQ => 50_000_000,
		SIMULATE_ELF_FILE => ELF_FILE,
		GPIO_ADDR_WIDTH => GPIO_ADDR_WIDTH
	)
	port map (
		clk => clk,
		res_n => res_n,

		cpu_reset_n => open,

		imem_out => imem_out,
		imem_in => imem_in,
		dmem_out => dmem_out,
		dmem_in => dmem_in,

		gp_out => open,
		gp_in => (others => (others => '0')),

		rx => '0',
		tx => open
	);

	main : process
		variable error_counter : natural := 0;
		file f : text;
		variable line_buffer : line;

		procedure check_output is
			type ref_t is record
				address : std_logic_vector(31 downto 0);
				data    : std_logic_vector(31 downto 0);
				byteena : std_logic_vector(3 downto 0);
			end record;
			type ref_array_t is array (natural range <>) of ref_t;
			impure function read_ref_file return ref_array_t is
				variable result : ref_array_t(0 to count_lines(DMEM_FILE)-1);
				variable i : natural := 0;
				variable data: line_vector(0 to 2);
			begin
				file_open(f, DMEM_FILE, READ_MODE);
				while not endfile(f) loop
					readline(f, line_buffer);
					
					data := split(line_buffer.all);
					result(i).address := hex_to_slv(data(0).all, 32);
					result(i).data := hex_to_slv(data(1).all, 32);
					result(i).byteena := hex_to_slv(data(2).all, 4);
					--report "address: " & to_hstring(result(i).address) & " data: " & to_hstring(result(i).data) & " byteena: " & to_hstring(result(i).byteena);
					i := i + 1;
				end loop;
				file_close(f);
				return result;
			end function;
			constant ref_data : ref_array_t := read_ref_file;
		begin
			for i in ref_data'range loop
				loop
					wait until rising_edge(clk);
					if (dmem_out.wr = '1') then
						exit;
					end if;
				end loop;
				
				if dmem_out_address32 /= ref_data(i).address then
					report "wrong address received: 0x" & to_hstring(dmem_out_address32) & "(expected: 0x" & to_hstring(ref_data(i).address) & ")" severity error;
					error_counter := error_counter + 1;
				end if;
				if dmem_out.wrdata /= ref_data(i).data then
					report "wrong data received!" severity error;
					error_counter := error_counter + 1;
				end if;
				if dmem_out.byteena /= ref_data(i).byteena then
					report "wrong byteena received!" severity error;
					error_counter := error_counter + 1;
				end if;
			end loop;
		end procedure;

	begin
		res_n <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';

		if MODE = "CHECK" then
			check_output;
		else
			wait for 10 us;
		end if;

		wait for 4*CLK_PERIOD;
		stop_clock <= true;
		wait for CLK_PERIOD;
		tc_print_result(TESTCASE_NAME, error_counter = 0);
		wait;
	end process;

	dmem_out_address32 <= std_logic_vector(resize(unsigned(dmem_out.address), 32));

	dmem_logger : process
		file f : text;
		variable myline : line;
	begin
		if MODE = "LOG" then
			file_open(f, DMEM_FILE, WRITE_MODE);
			file_close(f);
			loop
				wait until rising_edge(clk);
				if (dmem_out.wr = '1') then
					file_open(f, DMEM_FILE, APPEND_MODE);
					swrite(myline, to_hstring(dmem_out_address32) & " " & to_hstring(dmem_out.wrdata) & " " & to_hstring(dmem_out.byteena));
					writeline(f, myline);
					file_close(f);
				end if;
			end loop;
		end if;
		wait;
	end process;

	tc_timeout(TESTCASE_NAME, 100 us, stop_clock);
	clk_gen(clk, CLK_PERIOD, stop_clock);

end architecture;
