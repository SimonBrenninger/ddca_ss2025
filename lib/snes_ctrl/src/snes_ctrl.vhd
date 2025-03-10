library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.snes_ctrl_pkg.all;


entity snes_ctrl is
	generic (
		CLK_FREQ        : integer := 50_000_000;
		CLK_OUT_FREQ    : integer := 100_000;
		REFRESH_TIMEOUT : integer := 1000
	);
	port (
		clk        : in std_ulogic;
		res_n      : in std_ulogic;
		-- Interface to the SNES controller
		snes_clk   : out std_ulogic;
		snes_latch : out std_ulogic;
		snes_data  : in  std_ulogic;
		-- Button states
		ctrl_state : out snes_ctrl_state_t
	);
end entity;

