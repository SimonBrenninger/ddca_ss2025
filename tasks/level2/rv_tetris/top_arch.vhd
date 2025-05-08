library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.sync_pkg.all;
use work.gfx_core_pkg.all;
use work.vga_gfx_ctrl_pkg.all;
use work.rv_sys_pkg.all;
use work.rv_sys_pkg.all;
use work.snes_ctrl_pkg.all;
use work.gfx_init_pkg.all;


architecture top_arch_rv_fsm of top is
	signal res_n, cpu_reset_n : std_logic;

	signal imem_in,  dmem_in  : mem_in_t;
	signal imem_out, dmem_out : mem_out_t;

	constant GPIO_ADDR_WIDTH : natural := 3;
	signal gp_out : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
	signal gp_in  : mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);

	component pll is
		port (
			inclk0  : in std_logic := '0';
			c0      : out std_logic
		);
	end component;

	signal display_clk : std_ulogic;
	signal display_res_n : std_ulogic;

	signal gci_in : gci_in_t;
	signal gci_out : gci_out_t;

	signal snes_ctrl_state : snes_ctrl_state_t;

	signal tetris_game_rom_out : std_ulogic_vector(31 downto 0);
begin

	pll_inst : pll
	port map(
		inclk0 => clk,
		c0     => display_clk
	);

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

	display_reset_sync : sync
	generic map (
		SYNC_STAGES => 2,
		RESET_VALUE => '0'
	)
	port map (
		clk => display_clk,
		res_n => '1',
		data_in => keys(0),
		data_out => display_res_n
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

		gci_in => gci_in,
		gci_out => gci_out,

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

		-- SNES gamepad input
		gp_in(4) <= (others => '0');
		gp_in(4)(11 downto 0) <= to_sulv(snes_ctrl_state);

		-- Tetris Game ROM
		gp_in(5) <= tetris_game_rom_out;

		-- loop back to unused outputs
		gp_in(6) <= gp_out(6);
		gp_in(7) <= gp_out(7);

	end process;

	tetris_game_rom : process(clk, res_n)
	begin
		if res_n = '0' then
			tetris_game_rom_out <= (others => '0');
		elsif rising_edge(clk) then
			tetris_game_rom_out <= (others => '0');
			if signed(gp_out(5)) = -1 then
				tetris_game_rom_out <= std_ulogic_vector(to_unsigned(GFX_INIT_CMDS'length, 32));
			else
				tetris_game_rom_out(GFX_CMD_WIDTH-1 downto 0) <= GFX_INIT_CMDS(to_integer(unsigned(gp_out(5))));
			end if;
		end if;
	end process;

	vga_gfx_ctrl_inst : vga_gfx_ctrl
	port map (
		clk             => clk,
		res_n           => res_n,
		display_clk     => display_clk,
		display_res_n   => display_res_n,
		gci_out         => gci_out,
		gci_in          => gci_in,
		sram_dq         => sram_dq,
		sram_addr       => sram_addr,
		sram_ub_n       => sram_ub_n,
		sram_lb_n       => sram_lb_n,
		sram_we_n       => sram_we_n,
		sram_ce_n       => sram_ce_n,
		sram_oe_n       => sram_oe_n,
		vga_hsync       => vga_hsync,
		vga_vsync       => vga_vsync,
		vga_dac_clk     => vga_dac_clk,
		vga_dac_blank_n => vga_dac_blank_n,
		vga_dac_sync_n  => vga_dac_sync_n,
		vga_dac_color.r => vga_dac_r,
		vga_dac_color.g => vga_dac_g,
		vga_dac_color.b => vga_dac_b
	);

	snes_ctrl : entity work.snes_ctrl
	port map(
		clk        => clk,
		res_n      => res_n,
		-- Interface to the SNES controller
		snes_clk   => snes_clk,
		snes_latch => snes_latch,
		snes_data  => snes_data,
		-- Button states
		ctrl_state => snes_ctrl_state
	);


end architecture;
