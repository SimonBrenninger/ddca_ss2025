library ieee;
use ieee.std_logic_1164.all;

use work.rv_sys_pkg.all;
use work.mem_pkg.all;


entity memory_jtag is
	generic (
		RAM_SIZE_LD : natural := 10
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


architecture arch of memory_jtag is
	signal clk_jtag : std_ulogic;
	signal addr  : std_ulogic_vector(RAM_SIZE_LD + 2 - 1 downto 0);
	signal wrdata : mem_data_t;
	signal rddata : mem_data_t;
	signal wr, rd : std_ulogic;

	signal wr_i, wr_d, wr_c : std_ulogic;
	signal q_i, q_d : mem_data_t;

	type mux_t is (MUX_IMEM, MUX_DMEM, MUX_CTRL);
	signal mux : mux_t;

	signal ctrl : mem_data_t;
begin

	virtual_jtag_wrapper_inst : entity work.virtual_jtag_wrapper
	generic map (
		ADR_WIDTH => RAM_SIZE_LD + 2,
		DATA_WIDTH => RV_SYS_DATA_WIDTH
	)
	port map (
		clk   => clk_jtag,
		res_n => res_n,

		addr => addr,
		rd  => rd,
		wr  => wr,
		rddata => rddata,
		wrdata => wrdata
	);

	iram : dp_ram_2c2rw_byteen
	generic map (
		ADDR_WIDTH => RAM_SIZE_LD,
		DATA_WIDTH => RV_SYS_DATA_WIDTH
	)
	port map (
		clk1        => clk_jtag,
		clk2        => clk,
		-- JTAG read/write port
		rw1_addr    => addr(RAM_SIZE_LD - 1 downto 0),
		rw1_rd_data => q_i,
		rw1_rd      => '1',
		rw1_wr_data => wrdata,
		rw1_wr_ben  => (others=>'1'),
		rw1_wr      => wr_i,
		-- core read/write port
		rw2_addr    => imem_out.address(RAM_SIZE_LD - 1 downto 0),
		rw2_rd_data => imem_in.rddata,
		rw2_rd      => '1',
		rw2_wr_data => imem_out.wrdata,
		rw2_wr_ben  => imem_out.byteena,
		rw2_wr      => imem_out.wr
	);

	dram : dp_ram_2c2rw_byteen
	generic map (
		ADDR_WIDTH => RAM_SIZE_LD,
		DATA_WIDTH => RV_SYS_DATA_WIDTH
	)
	port map (
		clk1        => clk_jtag,
		clk2        => clk,
		rw1_addr    => addr(RAM_SIZE_LD - 1 downto 0),
		rw1_rd_data => q_d,
		rw1_rd      => '1',
		rw1_wr_data => wrdata,
		rw1_wr_ben  => (others=>'1'),
		rw1_wr      => wr_d,
		rw2_addr    => dmem_out.address(RAM_SIZE_LD - 1 downto 0),
		rw2_rd_data => dmem_in.rddata,
		rw2_rd      => '1',
		rw2_wr_data => dmem_out.wrdata,
		rw2_wr_ben  => dmem_out.byteena,
		rw2_wr      => dmem_out.wr
	);

	imem_in.busy <= '0';
	dmem_in.busy <= '0';

	jtag_mux: process (all)
	begin  -- process mux

		mux <= MUX_DMEM;

		case addr(RAM_SIZE_LD + 1 downto RAM_SIZE_LD) is
			when "00" => mux <= MUX_DMEM;
			when "01" => mux <= MUX_IMEM;
			when "11" => mux <= MUX_CTRL;
			when others => null;
		end case;

		rddata <= (others => '0');
		case mux is
			when MUX_DMEM => rddata <= q_d;
			when MUX_IMEM => rddata <= q_i;
			when MUX_CTRL => rddata <= ctrl;
			when others => null;
		end case;

		wr_i <= '0';
		if mux = MUX_IMEM then
			wr_i <= wr;
		end if;

		wr_d <= '0';
		if mux = MUX_DMEM then
			wr_d <= wr;
		end if;

		wr_c <= '0';
		if mux = MUX_CTRL then
			wr_c <= wr;
		end if;
	end process;

	sync : process(clk_jtag, res_n)
	begin
		if res_n = '0' then
			ctrl <= (others => '0');
		elsif rising_edge(clk_jtag) then
			if wr_c = '1' then
				ctrl <= wrdata;
			end if;
		end if;
	end process;

	control <= ctrl;
end architecture;
