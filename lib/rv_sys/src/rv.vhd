library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_sys_pkg.all;

entity rv is
	generic (
		CLK_FREQ : positive := 50_000_000
	);
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;
		-- Interface to instruction memory
		imem_out : out mem_out_t;
		imem_in  : in mem_in_t;
		-- Interface to data memory
		dmem_out : out mem_out_t;
		dmem_in  : in mem_in_t
	);
end entity;
