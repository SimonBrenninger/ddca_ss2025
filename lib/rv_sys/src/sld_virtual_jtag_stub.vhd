-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-- This is just a stub file for simulation as GHDL does not have vendor IP available for ready use --
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity sld_virtual_jtag is
	generic (
		sld_auto_instance_index : string  := "YES";
		sld_instance_index      : integer := 0;
		sld_ir_width            : integer := 1
	);
	port (
		tdi                : out std_logic;
		tdo                : in  std_logic := 'X';
		ir_in              : out std_logic_vector(1 downto 0);
		ir_out             : in  std_logic_vector(1 downto 0) := (others => 'X');
		virtual_state_cdr  : out std_logic;
		virtual_state_sdr  : out std_logic;
		virtual_state_e1dr : out std_logic;
		virtual_state_pdr  : out std_logic;
		virtual_state_e2dr : out std_logic;
		virtual_state_udr  : out std_logic;
		virtual_state_cir  : out std_logic;
		virtual_state_uir  : out std_logic;
		tck                : out std_logic
	);
end entity;

architecture arch of sld_virtual_jtag is
begin
	ir_in <= (others => '0');
	virtual_state_cdr  <= '0';
	virtual_state_sdr  <= '0';
	virtual_state_e1dr <= '0';
	virtual_state_pdr  <= '0';
	virtual_state_e2dr <= '0';
	virtual_state_udr  <= '0';
	virtual_state_cir  <= '0';
	virtual_state_uir  <= '0';
	tck                <= '0';
	tdi                <= '0';
end architecture;
