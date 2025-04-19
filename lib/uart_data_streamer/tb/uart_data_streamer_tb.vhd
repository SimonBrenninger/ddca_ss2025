
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.uart_data_streamer_pkg.all;
use work.mem_pkg.all;
use work.math_pkg.all;

entity uart_data_streamer_tb is
end entity;


architecture arch of uart_data_streamer_tb is
	constant BSP : std_logic_vector(7 downto 0) := x"55";

	constant CLK_PERIOD : time := 20 ns;
	constant OS_BYTES : positive := 4;
	constant OS_DATA_WIDTH : positive := OS_BYTES * 8;
	constant IS_BYTES : positive := 4;
	constant IS_DATA_WIDTH : positive := IS_BYTES * 8;

	constant CLK_FREQ    : integer := 25_000_000;
	constant BAUD_RATE     : integer := 9600;
	constant CLK_DIVISOR  : integer := CLK_FREQ/BAUD_RATE;

	signal clk, res_n, tx, rx, os_valid, is_valid, os_ready, is_ready, test_fifo_valid, full, half_full, halt : std_logic := '0';
	signal os_data, test_fifo_data : std_logic_vector(OS_DATA_WIDTH - 1 downto 0) := (others => '0');
	signal is_data : std_logic_vector(IS_DATA_WIDTH - 1 downto 0) := (others => '0');
begin

	uut: uart_data_streamer
	generic map (
		--CLK_FREQ      : integer := 25_000_000; --the system clock frequency
		--SYNC_STAGES   : integer := 2; --the amount of sync stages for the receiver
		--RX_FIFO_DEPTH : integer := 16; --the fifo-depth for the receiver
		--TX_FIFO_DEPTH : integer := 16; --the fifo-depth for the transmitter
		--BAUD_RATE     : integer := 9600;
		OS_BYTES => OS_BYTES, --: positive; -- In bytes
		IS_BYTES => IS_BYTES --: positive -- In bytes
	)
	port map (
		clk => clk,
		res_n => res_n, -- : in std_logic;

		-- UART
		rx => rx, -- : in std_logic;
		tx => tx, --: out std_logic;

		halt => halt,

		-- output stream -- from rx to core
		os_valid => os_valid, -- : out std_logic;
		os_data => os_data, -- : out std_logic_vector(OUTPUT_STREAM_DATA_BYTES * 8 - 1 downto 0);
		os_ready => '1', --: in std_logic;

		-- input stream -- from core to tx
		is_valid => is_valid, -- : in std_logic;
		is_data  =>  is_data, --: in std_logic_vector(INPUT_STREAM_DATA_BYTES * 8 - 1 downto 0);
		is_ready => is_ready -- : out std_logic
	);


	rx <= tx;

	stimulus:process
	begin
		res_n <= '0';
		wait for CLK_PERIOD * 5;
		res_n <= '1';
		wait for CLK_PERIOD;

		is_data <= x"55" & x"AA" & x"55" & x"AA";
		is_valid <= '1';
		wait for CLK_PERIOD;
		is_data <= (others => '0');
		is_valid <= '0';

		wait for CLK_PERIOD * CLK_DIVISOR * 100;
		halt <= '1';

		while true loop
			wait until os_valid = '1';
			is_data <= not os_data;
			is_valid <= '1';
			wait for CLK_PERIOD;
			is_valid <= '0';
		end loop;
	end process;

	clkgen: process
	begin
		clk <= '0';
		wait for CLK_PERIOD / 2;
		clk <= '1';
		wait for CLK_PERIOD / 2;
	end process;
end architecture;


