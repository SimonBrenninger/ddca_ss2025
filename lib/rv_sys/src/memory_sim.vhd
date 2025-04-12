library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.rv_sys_pkg.all;

-- Quartus does not need to look at this entity
-- pragma synthesis_off

entity file_ram is
	generic (
		MEM_ADR_WIDTH : natural := 13;
		MEM_FILE      : string  := ""
	);
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;

		-- data interface
		mem_in   : out mem_in_t;
		mem_out  : in  mem_out_t
	);
end entity;

architecture arch of file_ram is
	constant MEMORY_WORDS : natural := 2**MEM_ADR_WIDTH;

	type ram_t is array (0 to MEMORY_WORDS-1) of mem_data_t;

	impure function init_ram_file(filename : string) return ram_t is
		file text_file : text open read_mode is filename;
		variable text_line : line;
		variable ram_content : ram_t;
	begin
		ram_content := (others => (others => '0'));
		for i in 0 to MEMORY_WORDS-1 loop
			exit when endfile(text_file);
			readline(text_file, text_line);
			hread(text_line, ram_content(i));
		end loop;
		return ram_content;
	end function;

	impure function init_ram(filename : string) return ram_t is
	begin
		if filename = "" then
			return (others => (others => '0'));
		else
			return init_ram_file(filename);
		end if;
	end function;

	pure function en_to_mask(byteena : mem_byteena_t) return mem_data_t is
		variable rslt : mem_data_t := (others => '0');
	begin
		for I in byteena'range loop
			if byteena(I) = '1' then
				rslt((I+1)*8-1 downto I*8) := (others => '1');
			end if;
		end loop;
		return rslt;
	end function;

	signal mem : ram_t := init_ram(MEM_FILE);
	signal rddate_int : mem_data_t;
	signal mask : mem_data_t;
	signal addr : unsigned(MEM_ADR_WIDTH-1 downto 0);

begin

	addr <= unsigned(mem_out.address(addr'high downto 0)) when res_n = '1' else (others => '0');
	mask <= en_to_mask(mem_out.byteena)                   when res_n = '1' else (others => '0');

	mem_in.rddata <= rddate_int;
	mem_in.busy <= '0'; -- this ram supplies data in the next cycle

	read : process(clk, res_n)
	begin
		if res_n = '0' then
			rddate_int <= (others => 'X');
		elsif rising_edge(clk) then
			rddate_int <= mem(to_integer(addr));
		end if;
	end process;

	write : process(clk)
		variable tmp : mem_data_t;
	begin
		if rising_edge(clk) then
			if mem_out.wr = '1' then
				tmp := mem(to_integer(addr));
				tmp := (tmp and (not mask)) or (mem_out.wrdata and mask);
				mem(to_integer(addr)) <= tmp;
			end if;
		end if;
	end process;

end architecture;

-- pragma synthesis_on

library ieee;
use ieee.std_logic_1164.all;
use work.rv_sys_pkg.all;
use std.textio.all;

entity memory_sim is
	generic (
		RAM_SIZE_LD : natural := 10;
		ELF_FILE : string
	);
	port (
		clk   : in std_ulogic;
		res_n : in std_ulogic;

		control    : out mem_data_t;

		-- instruction interface
		imem_out  : in  mem_out_t;
		imem_in   : out mem_in_t;

		-- data interface
		dmem_out  : in  mem_out_t;
		dmem_in   : out mem_in_t
	);
end entity;

architecture arch of memory_sim is
	-- pragma synthesis_off
	constant IMEM_FILE : string := ELF_FILE(1 to ELF_FILE'length-4) & ".imem.mif";
	constant DMEM_FILE : string := ELF_FILE(1 to ELF_FILE'length-4) & ".dmem.mif";
	
	component file_ram is
		generic (
			MEM_ADR_WIDTH : natural := 13;
			MEM_FILE : string := ""
		);
		port (
			clk : in std_ulogic;
			res_n : in std_ulogic;
			mem_in : out mem_in_t;
			mem_out : in mem_out_t
		);
	end component;
	-- pragma synthesis_on
begin
	-- pragma synthesis_off
	check_elf_file : process is
		file text_file : text open read_mode is ELF_FILE;
	begin
		wait;
	end process;

	imem_inst : file_ram
	generic map (
		MEM_ADR_WIDTH  => RAM_SIZE_LD,
		MEM_FILE => IMEM_FILE
	)
	port map (
		clk   => clk,
		res_n => res_n,

		mem_out => imem_out,
		mem_in => imem_in
	);

	dmem_inst : file_ram
	generic map (
		MEM_ADR_WIDTH  => RAM_SIZE_LD,
		MEM_FILE => DMEM_FILE
	)
	port map (
		clk   => clk,
		res_n => res_n,

		mem_out => dmem_out,
		mem_in => dmem_in
	);
	-- pragma synthesis_on

	control <= (0 => res_n, others => '0');
end architecture;
