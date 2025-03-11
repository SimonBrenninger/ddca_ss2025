library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gfx_core_pkg.all;

entity gfx_cmd_interpreter_tb is
end entity;

architecture bench of gfx_cmd_interpreter_tb is

	constant OUTPUT_DIR : string := "./";
	signal clk : std_logic;
	signal gci_in : gci_in_t;
	signal gci_out : gci_out_t;
begin

	-- add your testcode here

	uut : entity work.gfx_cmd_interpreter
	generic map (
		OUTPUT_DIR => OUTPUT_DIR
	)
	port map (
		clk     => clk,
		gci_in  => gci_in,
		gci_out => gci_out
	);
	
end architecture;

