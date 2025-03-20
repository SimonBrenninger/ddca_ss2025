library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_ram_2c2rw is
	generic (
		ADDR_WIDTH : integer;
		DATA_WIDTH : integer
	);
	port (
		clk1 : in  std_ulogic;
		clk2 : in  std_ulogic;
		
		-- read/write port 1
		rw1_addr    : in  std_ulogic_vector(ADDR_WIDTH-1 downto 0);
		rw1_rd_data : out std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
		rw1_rd      : in  std_ulogic;
		rw1_wr_data : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
		rw1_wr      : in  std_ulogic;

		-- read/write port 2
		rw2_addr    : in  std_ulogic_vector(ADDR_WIDTH-1 downto 0);
		rw2_rd_data : out std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
		rw2_rd      : in  std_ulogic;
		rw2_wr_data : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
		rw2_wr      : in  std_ulogic
	);
end entity;

-- see Intel Quartus Prime User Guide - Design Recommendations
architecture rtl of dp_ram_2c2rw is
	subtype word_t is std_ulogic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;
	shared variable ram : memory_t;
begin
	-- Port 1
	process(clk1)
	begin
		if (rising_edge(clk1)) then
			if (rw1_wr = '1') then
				ram(to_integer(unsigned(rw1_addr))) := rw1_wr_data;
			end if;
			if (rw1_rd = '1') then
				rw1_rd_data <= ram(to_integer(unsigned(rw1_addr)));
			end if;
		end if;
	end process;

	-- Port 2
	process(clk2)
	begin
		if (rising_edge(clk2)) then
			if (rw2_wr = '1') then
				ram(to_integer(unsigned(rw2_addr))) := rw2_wr_data;
			end if;
			if (rw2_rd = '1') then
				rw2_rd_data <= ram(to_integer(unsigned(rw2_addr)));
			end if;
		end if;
	end process;
end architecture;

