library ieee;
use ieee.std_logic_1164.all;
use work.sorting_network_pkg.all;

entity sorting_network is
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;

		-- UART data streamer interface
		unsorted_ready   : out std_ulogic;
		unsorted_data    : in word_array_t(0 to 9);
		unsorted_valid   : in std_ulogic;

		sorted_ready     : in std_ulogic;
		sorted_data      : out word_array_t(0 to 9);
		sorted_valid     : out std_ulogic
	);
end entity;
