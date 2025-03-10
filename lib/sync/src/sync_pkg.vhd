library ieee;
use ieee.std_logic_1164.all;


package sync_pkg is
	component sync is
		generic(
			SYNC_STAGES : positive;
			RESET_VALUE : std_ulogic
		);
		port (
			clk       : in  std_ulogic;
			res_n     : in  std_ulogic;
			data_in   : in  std_ulogic;
			data_out  : out std_ulogic
		);
	end component;
end package;


