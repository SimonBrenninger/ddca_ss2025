library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.mem_pkg.all;

entity dp_ram_2c2rw_byteen is
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
		rw1_wr_ben  : in  std_ulogic_vector(DATA_WIDTH/8-1 downto 0);
		rw1_wr      : in  std_ulogic;

		-- read/write port 2
		rw2_addr    : in  std_ulogic_vector(ADDR_WIDTH-1 downto 0);
		rw2_rd_data : out std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
		rw2_rd      : in  std_ulogic;
		rw2_wr_data : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
		rw2_wr_ben  : in  std_ulogic_vector(DATA_WIDTH/8-1 downto 0);
		rw2_wr      : in  std_ulogic
	);
begin
	assert DATA_WIDTH = 2**log2c(DATA_WIDTH) report "DATA_WIDTH must be a power of 2!" severity failure;
end entity;


architecture rtl of dp_ram_2c2rw_byteen is
	constant NUM_BYTES : positive := DATA_WIDTH/8;
begin
	bytes : for i in 0 to NUM_BYTES-1 generate
		dp_ram_2c2rw_inst : dp_ram_2c2rw
		generic map (
			ADDR_WIDTH => ADDR_WIDTH,
			DATA_WIDTH => 8
		)
		port map (
			clk1        => clk1,
			clk2        => clk2,
			rw1_addr    => rw1_addr,
			rw1_rd_data => rw1_rd_data((i+1)*8-1 downto i*8),
			rw1_rd      => rw1_rd,
			rw1_wr_data => rw1_wr_data((i+1)*8-1 downto i*8),
			rw1_wr      => rw1_wr and rw1_wr_ben(i),
			rw2_addr    => rw2_addr,
			rw2_rd_data => rw2_rd_data((i+1)*8-1 downto i*8),
			rw2_rd      => rw2_rd,
			rw2_wr_data => rw2_wr_data((i+1)*8-1 downto i*8),
			rw2_wr      => rw2_wr and rw2_wr_ben(i)
		);
	end generate;
end architecture;

-- see Intel Quartus Prime User Guide - Design Recommendations
-- Quartus does not like this code
--architecture rtl of dp_ram_2c2rw_byteen is
--	constant NUM_BYTES : positive := DATA_WIDTH/8;
--	type word_t is array (0 to NUM_BYTES-1) of std_ulogic_vector(7 downto 0);
--	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;
--	shared variable ram : memory_t;
--	signal rw1_rd_data_local, rw2_rd_data_local : word_t;
--begin

--	-- Port 1
--	process(clk1)
--	begin
--		if (rising_edge(clk1)) then
--			if (rw1_wr = '1') then
--				for i in NUM_BYTES-1 downto 0 loop
--					if (rw1_wr_ben(i) = '1') then
--							ram(to_integer(unsigned(rw1_addr)))(i) := rw1_wr_data((i+1)*8-1 downto i*8);
--					end if;
--				end loop;
--			end if;
--			--if (rw1_rd = '1') then
--				rw1_rd_data_local <= ram(to_integer(unsigned(rw1_addr)));
--			--end if;
--		end if;
--	end process;

--	unpack1: for i in 0 to NUM_BYTES-1 generate
--		rw1_rd_data((i+1)*8-1 downto i*8) <= rw1_rd_data_local(i);
--	end generate;

--	-- Port 2
--	process(clk1)
--	begin
--		if (rising_edge(clk1)) then
--			if (rw2_wr = '1') then
--				for i in NUM_BYTES-1 downto 0 loop
--					if (rw2_wr_ben(i) = '1') then
--							ram(to_integer(unsigned(rw2_addr)))(i) := rw2_wr_data((i+1)*8-1 downto i*8);
--					end if;
--				end loop;
--			end if;
--			--if (rw2_rd = '1') then
--				rw2_rd_data_local <= ram(to_integer(unsigned(rw2_addr)));
--			--end if;
--		end if;
--	end process;

--	unpack2: for i in 0 to NUM_BYTES-1 generate
--		rw2_rd_data((i+1)*8-1 downto i*8) <= rw2_rd_data_local(i);
--	end generate;

--end architecture;

