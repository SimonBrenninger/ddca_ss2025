--Based on https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/hb/qts/qts_qii51007.pdf
--VHDL Single-Clock Simple Dual-Port Synchronous RAM with New Data Read-During-Write Behavior

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_ram_1c1r1w_rdw is
	generic (
		ADDR_WIDTH : integer;
		DATA_WIDTH : integer
	);
	port (
		clk           : in std_ulogic;
		rd1_addr      : in std_ulogic_vector(ADDR_WIDTH-1 downto 0);
		rd1_data      : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
		wr2_addr      : in std_ulogic_vector(ADDR_WIDTH-1 downto 0);
		wr2_data      : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
		wr2           : in std_ulogic
	);
end entity;

architecture rtl of dp_ram_1c1r1w_rdw is
	type mem_t is array(0 TO (2**ADDR_WIDTH)-1) of std_ulogic_vector(DATA_WIDTH-1 downto 0);
begin
	process(clk)
		variable ram : mem_t;
	begin
		if rising_edge(clk) then
			if (wr2 = '1') then
				ram(to_integer(unsigned(wr2_addr))) := wr2_data;
			end if;
			rd1_data <= ram(to_integer(unsigned(rd1_addr)));
		end if;
	end process;
end architecture;
