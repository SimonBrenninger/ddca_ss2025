LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY pll_150MHz IS
	PORT (
		inclk0 : IN STD_LOGIC  := '0';
		c0     : OUT STD_LOGIC
	);
END ENTITY;


ARCHITECTURE SYN OF pll_150mhz IS

	SIGNAL sub_wire0 : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL sub_wire1 : STD_LOGIC ;
	SIGNAL sub_wire2 : STD_LOGIC ;
	SIGNAL sub_wire3 : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL sub_wire4_bv : BIT_VECTOR (0 DOWNTO 0);
	SIGNAL sub_wire4 : STD_LOGIC_VECTOR (0 DOWNTO 0);

	COMPONENT altpll
	GENERIC (
		bandwidth_type : STRING;
		clk0_divide_by : NATURAL;
		clk0_duty_cycle : NATURAL;
		clk0_multiply_by : NATURAL;
		clk0_phase_shift : STRING;
		compensate_clock : STRING;
		inclk0_input_frequency : NATURAL;
		intended_device_family : STRING;
		lpm_hint : STRING;
		lpm_type : STRING;
		operation_mode : STRING;
		pll_type : STRING;
		port_activeclock : STRING;
		port_areset : STRING;
		port_clkbad0 : STRING;
		port_clkbad1 : STRING;
		port_clkloss : STRING;
		port_clkswitch : STRING;
		port_configupdate : STRING;
		port_fbin : STRING;
		port_inclk0 : STRING;
		port_inclk1 : STRING;
		port_locked : STRING;
		port_pfdena : STRING;
		port_phasecounterselect : STRING;
		port_phasedone : STRING;
		port_phasestep : STRING;
		port_phaseupdown : STRING;
		port_pllena : STRING;
		port_scanaclr : STRING;
		port_scanclk : STRING;
		port_scanclkena : STRING;
		port_scandata : STRING;
		port_scandataout : STRING;
		port_scandone : STRING;
		port_scanread : STRING;
		port_scanwrite : STRING;
		port_clk0 : STRING;
		port_clk1 : STRING;
		port_clk2 : STRING;
		port_clk3 : STRING;
		port_clk4 : STRING;
		port_clk5 : STRING;
		port_clkena0 : STRING;
		port_clkena1 : STRING;
		port_clkena2 : STRING;
		port_clkena3 : STRING;
		port_clkena4 : STRING;
		port_clkena5 : STRING;
		port_extclk0 : STRING;
		port_extclk1 : STRING;
		port_extclk2 : STRING;
		port_extclk3 : STRING;
		width_clock : NATURAL
	);
	PORT (
		inclk : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		clk : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
	);
	END COMPONENT;
BEGIN
	sub_wire4_bv(0 DOWNTO 0) <= "0";
	sub_wire4    <= To_stdlogicvector(sub_wire4_bv);
	sub_wire1    <= sub_wire0(0);
	c0    <= sub_wire1;
	sub_wire2    <= inclk0;
	sub_wire3    <= sub_wire4(0 DOWNTO 0) & sub_wire2;

	altpll_component : altpll
	GENERIC MAP (
		bandwidth_type => "AUTO",
		clk0_divide_by => 1,
		clk0_duty_cycle => 50,
		clk0_multiply_by => 3,
		clk0_phase_shift => "0",
		compensate_clock => "CLK0",
		inclk0_input_frequency => 20000,
		intended_device_family => "Cyclone IV E",
		lpm_hint => "CBX_MODULE_PREFIX=pll_150MHz",
		lpm_type => "altpll",
		operation_mode => "NORMAL",
		pll_type => "AUTO",
		port_activeclock => "PORT_UNUSED",
		port_areset => "PORT_UNUSED",
		port_clkbad0 => "PORT_UNUSED",
		port_clkbad1 => "PORT_UNUSED",
		port_clkloss => "PORT_UNUSED",
		port_clkswitch => "PORT_UNUSED",
		port_configupdate => "PORT_UNUSED",
		port_fbin => "PORT_UNUSED",
		port_inclk0 => "PORT_USED",
		port_inclk1 => "PORT_UNUSED",
		port_locked => "PORT_UNUSED",
		port_pfdena => "PORT_UNUSED",
		port_phasecounterselect => "PORT_UNUSED",
		port_phasedone => "PORT_UNUSED",
		port_phasestep => "PORT_UNUSED",
		port_phaseupdown => "PORT_UNUSED",
		port_pllena => "PORT_UNUSED",
		port_scanaclr => "PORT_UNUSED",
		port_scanclk => "PORT_UNUSED",
		port_scanclkena => "PORT_UNUSED",
		port_scandata => "PORT_UNUSED",
		port_scandataout => "PORT_UNUSED",
		port_scandone => "PORT_UNUSED",
		port_scanread => "PORT_UNUSED",
		port_scanwrite => "PORT_UNUSED",
		port_clk0 => "PORT_USED",
		port_clk1 => "PORT_UNUSED",
		port_clk2 => "PORT_UNUSED",
		port_clk3 => "PORT_UNUSED",
		port_clk4 => "PORT_UNUSED",
		port_clk5 => "PORT_UNUSED",
		port_clkena0 => "PORT_UNUSED",
		port_clkena1 => "PORT_UNUSED",
		port_clkena2 => "PORT_UNUSED",
		port_clkena3 => "PORT_UNUSED",
		port_clkena4 => "PORT_UNUSED",
		port_clkena5 => "PORT_UNUSED",
		port_extclk0 => "PORT_UNUSED",
		port_extclk1 => "PORT_UNUSED",
		port_extclk2 => "PORT_UNUSED",
		port_extclk3 => "PORT_UNUSED",
		width_clock => 5
	)
	PORT MAP (
		inclk => sub_wire3,
		clk => sub_wire0
	);

END ARCHITECTURE;
