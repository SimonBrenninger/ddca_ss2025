

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_ram_1c1r1w is
	generic (
		ADDR_WIDTH : positive; -- Address bus width
		DATA_WIDTH : positive  -- Data bus width
	);
	port (
		clk    : in  std_ulogic; -- Connection for the clock signal.
		
		-- Read port
		rd1_addr : in  std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
		rd1_data : out std_ulogic_vector(DATA_WIDTH - 1 downto 0) := (others=>'0');
		rd1      : in  std_ulogic;
		
		-- Write port
		wr2_addr : in  std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
		wr2_data : in  std_ulogic_vector(DATA_WIDTH - 1 downto 0);
		wr2      : in  std_ulogic
	);
end entity;


architecture beh of dp_ram_1c1r1w is
	subtype ram_entry is std_ulogic_vector(DATA_WIDTH - 1 downto 0);
	type ram_type is array(0 to (2 ** ADDR_WIDTH) - 1) of ram_entry;
	signal ram : ram_type := (others => (others => '0'));
begin
	sync : process(clk)
	begin
		if rising_edge(clk) then
			if wr2 = '1' then
				ram(to_integer(unsigned(wr2_addr))) <= wr2_data;
			end if;
			if rd1 = '1' then
				rd1_data <= ram(to_integer(unsigned(rd1_addr)));
			end if;
		end if;
	end process;
end architecture;


