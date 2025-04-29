library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.sorting_network_pkg.all;
use work.util_pkg.all;
use work.uart_data_streamer_pkg.all;
use work.sync_pkg.all;

architecture top_arch of top is
	constant DATA_BYTES    : positive := 4;
	constant OS_BYTES      : positive := 10 * DATA_BYTES;
	constant OS_DATA_WIDTH : positive := OS_BYTES * 8;
	constant IS_BYTES      : positive := OS_BYTES;
	constant IS_DATA_WIDTH : positive := IS_BYTES * 8;

	signal os_valid, is_valid, os_ready,  is_ready, switch0_d, key0_d : std_ulogic := '0';
	signal os_data : std_ulogic_vector(OS_DATA_WIDTH - 1 downto 0) := (others => '0');
	signal sorted_array : word_array_t(0 to IS_DATA_WIDTH / DATA_BYTES / 8 -1) := (others => (others => '0'));

	signal clk_150MHz : std_ulogic := '0';

	component pll_150MHz is
		port (
			inclk0  : in std_ulogic  := '0';
			c0      : out std_ulogic
		);
	end component;

	function gen_array_from_vector(x: std_ulogic_vector) return word_array_t is
		variable res : word_array_t(0 to OS_DATA_WIDTH / DATA_BYTES / 8 - 1);
	begin
		for i in 0 to res'high loop
			res(i) := x((DATA_BYTES * 8) * (i+1) -  1 downto (DATA_BYTES * 8) * (i));
		end loop;

		return res;
	end function;

	function gen_vector_from_array(x: word_array_t) return std_ulogic_vector is
		variable res : std_ulogic_vector(IS_DATA_WIDTH - 1 downto 0);
	begin
		for i in 0 to x'high loop
			res((DATA_BYTES * 8) * (i+1) -  1 downto (DATA_BYTES * 8) * (i)) := x(i);
		end loop;

		return res;
	end function;
begin
	pll_inst: pll_150MHz
	port map(
		inclk0 => clk,
		c0 => clk_150MHz
	);

	sync_sw: sync
	generic map (
		SYNC_STAGES => 2,
		RESET_VALUE => '0'
	)
	port map (
		clk      => clk_150MHz,
		res_n    => '1',
		data_in  => switches(0),
		data_out => switch0_d
	);

	sync_res: sync
	generic map (
		SYNC_STAGES => 2,
		RESET_VALUE => '0'
	)
	port map (
		clk      => clk_150MHz,
		res_n    => '1',
		data_in  => keys(0),
		data_out => key0_d
	);

	uart_data_streamer_inst : uart_data_streamer
	generic map (
		CLK_FREQ        => 150_000_000,
		BAUD_RATE       => 9600,
		IS_BUFFER_DEPTH => 8,
		OS_BUFFER_DEPTH => 8,
		OS_BYTES        => OS_BYTES,
		IS_BYTES        => IS_BYTES,
		BYTE_ORDER      => LITTLE_ENDIAN
	)
	port map (
		clk   => clk_150MHz,
		res_n => key0_d,

		-- UART
		rx => rx,
		tx => tx,

		halt => switch0_d,
		full => LEDG(0),

		-- output stream -- from rx to core
		os_valid => os_valid,
		os_data  => os_data,
		os_ready => os_ready,

		-- input stream -- from core to tx
		is_valid => is_valid,
		is_data  => gen_vector_from_array(sorted_array),
		is_ready => is_ready
	);

	ledg(1) <= os_valid;
	ledg(2) <= is_ready;

	sorting_network : entity work.sorting_network(arch_combinatorial)
	port map (
		clk   => clk_150MHz,
		res_n => key0_d,

		unsorted_ready  => os_ready,
		unsorted_data   => gen_array_from_vector(os_data),
		unsorted_valid  => os_valid,

		sorted_ready    => is_ready,
		sorted_data     => sorted_array,
		sorted_valid    => is_valid
	);
end architecture;
