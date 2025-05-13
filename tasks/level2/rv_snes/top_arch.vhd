library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.sync_pkg.all;
use work.rv_sys_pkg.all;


architecture top_arch_rv_fsm of top is
	signal res_n, cpu_reset_n : std_logic;

	signal imem_in,  dmem_in  : mem_in_t;
	signal imem_out, dmem_out : mem_out_t;

	constant GPIO_ADDR_WIDTH : natural := 3;
	signal gp_out : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
	signal gp_in  : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
begin
	reset_sync : sync
	generic map (
		SYNC_STAGES => 2,
		RESET_VALUE => '0'
	)
	port map (
		clk => clk,
		res_n => '1',
		data_in => keys(0),
		data_out => res_n
	);

	core_inst : entity work.rv
	port map (
		clk       => clk,
		res_n     => cpu_reset_n,

		imem_out => imem_out,
		imem_in  => imem_in,

		dmem_out => dmem_out,
		dmem_in  => dmem_in
	);

	rv_sys_inst : entity work.rv_sys
	generic map (
		BAUD_RATE => 9600,
		CLK_FREQ => 50_000_000,
		GPIO_ADDR_WIDTH => GPIO_ADDR_WIDTH
	)
	port map (
		clk => clk,
		res_n => res_n,

		cpu_reset_n => cpu_reset_n,

		tx => tx,
		rx => rx,

		gp_out => gp_out,
		gp_in => gp_in,

		imem_out => imem_out,
		imem_in  => imem_in,

		dmem_out => dmem_out,
		dmem_in  => dmem_in
	);

	process (all)
	begin
		for i in 0 to 2**GPIO_ADDR_WIDTH-1 loop
			gp_in(i) <= (others=>'0');
		end loop;

		-- DE2-115 FPGA Board I/O
		gp_in(0)(keys'range) <= keys;
		gp_in(1)(switches'range) <= switches;
		
		ledg <= gp_out(0)(ledg'range);
		ledr <= gp_out(1)(ledr'range);
		hex0 <= gp_out(2)(6 downto 0);
		hex1 <= gp_out(2)(14 downto 8);
		hex2 <= gp_out(2)(22 downto 16);
		hex3 <= gp_out(2)(30 downto 24);
		hex4 <= gp_out(3)(6 downto 0);
		hex5 <= gp_out(3)(14 downto 8);
		hex6 <= gp_out(3)(22 downto 16);
		hex7 <= gp_out(3)(30 downto 24);

		-- loop back to unused outputs
		gp_in(6) <= gp_out(6);
		gp_in(7) <= gp_out(7);
		
		-- SNES gamepad
		snes_clk <= gp_out(4)(0);
		snes_latch <= gp_out(4)(1);
		gp_in(4) <= (others => '0');
		gp_in(4)(0) <= snes_data;
	end process;

end architecture;
