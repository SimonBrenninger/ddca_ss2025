library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package uart_data_streamer_pkg is
	type BYTE_ORDER_T is (
		LITTLE_ENDIAN,
		BIG_ENDIAN
	);

	component uart_data_streamer is
		generic (
			CLK_FREQ        : positive := 50_000_000;
			SYNC_STAGES     : positive := 2;
			IS_BUFFER_DEPTH : positive := 16;
			IS_BYTES        : positive;
			OS_BUFFER_DEPTH : positive := 16;
			OS_BYTES        : positive;
			BAUD_RATE       : positive := 9600;
			BYTE_ORDER      : BYTE_ORDER_T := BIG_ENDIAN
		);
		port (
			clk   : in std_ulogic;
			res_n : in std_ulogic;

			-- UART
			rx : in  std_ulogic;
			tx : out std_ulogic;

			-- output stream -- from rx to core
			os_valid : out std_ulogic;
			os_data  : out std_ulogic_vector(OS_BYTES * 8 - 1 downto 0);
			os_ready : in  std_ulogic;
			halt     : in  std_ulogic;

			-- input stream -- from core to tx
			is_valid : in  std_ulogic;
			is_data  : in  std_ulogic_vector(IS_BYTES * 8 - 1 downto 0);
			is_ready : out std_ulogic;
			full     : out std_ulogic
		);
	end component;
end package;

