library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gc_ctrl_pkg.all;


entity gc_ctrl is
	generic (
		CLK_FREQ        : positive := 50_000_000;
		SYNC_STAGES     : positive := 2;
		REFRESH_TIMEOUT : positive := 60000
	);
	port (
		clk        : in    std_ulogic;
		res_n      : in    std_ulogic;
		-- connection to the controller
		data       : inout std_logic;
		-- internal connection
		ctrl_state : out   gc_ctrl_state_t;
		rumble     : in    std_ulogic
	);
end entity;



