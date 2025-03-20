library ieee;
use ieee.std_logic_1164.all;
use work.math_pkg.all;

package mem_pkg is

	component dp_ram_1c1r1w is
		generic (
			ADDR_WIDTH : integer;
			DATA_WIDTH : integer
		);
		port (
			clk : in std_ulogic;
			-- read port
			rd1_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
			rd1_data : out std_ulogic_vector(DATA_WIDTH - 1 downto 0);
			rd1 : in std_ulogic;
			-- write port
			wr2_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
			wr2_data : in std_ulogic_vector(DATA_WIDTH - 1 downto 0);
			wr2 : in std_ulogic
		);
	end component;
	
	component dp_ram_1c1r1w_rdw is
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
	end component;

	component dp_ram_2c2rw is
		generic (
			ADDR_WIDTH : integer;
			DATA_WIDTH : integer
		);
		port (
			clk1 : in std_ulogic;
			clk2 : in std_ulogic;
			-- read/write port 1
			rw1_addr : in std_ulogic_vector(ADDR_WIDTH-1 downto 0);
			rw1_rd_data : out std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
			rw1_rd : in std_ulogic;
			rw1_wr_data : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
			rw1_wr : in std_ulogic;
			-- read/write port 2
			rw2_addr : in std_ulogic_vector(ADDR_WIDTH-1 downto 0);
			rw2_rd_data : out std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
			rw2_rd : in std_ulogic;
			rw2_wr_data : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
			rw2_wr : in std_ulogic
		);
	end component;

	component dp_ram_2c2rw_byteen is
		generic (
			ADDR_WIDTH : integer;
			DATA_WIDTH : integer
		);
		port (
			clk1 : in std_ulogic;
			clk2 : in std_ulogic;
			-- read/write port 1
			rw1_addr : in std_ulogic_vector(ADDR_WIDTH-1 downto 0);
			rw1_rd_data : out std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
			rw1_rd : in std_ulogic;
			rw1_wr_data : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
			rw1_wr_ben : in std_ulogic_vector(DATA_WIDTH/8-1 downto 0);
			rw1_wr : in std_ulogic;
			-- read/write port 2
			rw2_addr : in std_ulogic_vector(ADDR_WIDTH-1 downto 0);
			rw2_rd_data : out std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
			rw2_rd : in std_ulogic;
			rw2_wr_data : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
			rw2_wr_ben : in std_ulogic_vector(DATA_WIDTH/8-1 downto 0);
			rw2_wr : in std_ulogic
		);
	end component;
	
	component fifo_1c1r1w is
		generic (
			DEPTH : integer;
			DATA_WIDTH : integer
		);
		port (
			clk : in std_ulogic;
			res_n : in std_ulogic;
			-- read port
			rd_data : out std_ulogic_vector(DATA_WIDTH - 1 downto 0);
			rd : in std_ulogic;
			-- write port
			wr_data : in std_ulogic_vector(DATA_WIDTH - 1 downto 0);
			wr : in std_ulogic;
			-- status flags
			empty : out std_ulogic;
			full : out std_ulogic;
			half_full : out std_ulogic
		);
	end component;
	
	component fifo_1c1r1w_fwft is
		generic (
			DEPTH : integer;
			DATA_WIDTH : integer
		);
		port (
			clk : in std_ulogic;
			res_n : in std_ulogic;
			-- read port
			rd_data : out std_ulogic_vector(DATA_WIDTH - 1 downto 0);
			rd_ack : in std_ulogic;
			rd_valid : out std_ulogic;
			-- write port
			wr_data : in std_ulogic_vector(DATA_WIDTH - 1 downto 0);
			wr : in std_ulogic;
			-- status flags
			full : out std_ulogic;
			half_full : out std_ulogic
		);
	end component;

end package;

