library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sram_ctrl_pkg.all;
use work.tb_util_pkg.all;


entity sram_ctrl_tb is
end entity;

architecture bench of sram_ctrl_tb is

	-- TODO: Declare types and signals as required

	signal CLK_PERIOD : time := 20 ns;
	signal stop_clk : boolean := false;
	signal clk, res_n : std_ulogic;

	constant ADDR_WIDTH  : positive := 21;
	constant DATA_WIDTH  : positive := 16;
	constant WR_BUF_SIZE : positive := 8;

	signal wr_addr, rd1_addr, rd2_addr                      : std_ulogic_vector(ADDR_WIDTH-1 downto 0);
	signal wr_data, rd1_data, rd2_data                      : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal wr, rd1, rd2                                     : std_ulogic;
	signal wr_empty, wr_full, wr_half_full                  : std_ulogic;
	signal rd1_busy, rd2_busy, rd1_valid, rd2_valid         : std_ulogic;
	signal wr_access_mode, rd1_access_mode, rd2_access_mode : sram_access_mode_t;

	signal sram_dq : std_logic_vector(15 downto 0) := (others => 'Z');
	signal sram_addr : std_ulogic_vector(19 downto 0);
	signal sram_ub_n : std_logic;
	signal sram_lb_n : std_logic;
	signal sram_we_n : std_logic;
	signal sram_ce_n : std_logic;
	signal sram_oe_n : std_logic;

	-- TODO: Implement further useful subprograms (e.g., for reading and writing)

	function int_to_data(x : integer) return std_ulogic_vector is begin
		return std_ulogic_vector(to_unsigned(x, DATA_WIDTH));
	end function;

	function int_to_word_addr(x : integer) return std_ulogic_vector is begin
		return std_ulogic_vector(to_unsigned(x, ADDR_WIDTH-1)) & '0';
	end function;

	function int_to_byte_addr(x : integer) return std_ulogic_vector is begin
		return std_ulogic_vector(to_unsigned(x, ADDR_WIDTH));
	end function;
begin

	-- Stimulus process
	stimulus: process
	begin
		report "Simulation start";

		-- Apply test stimuli

		wait for 10 ns;
		assert 1 = 0 report "Test x failed" severity error;

		report "Simulation end";
		stop_clk <= true;
		wait;
	end process;

sram_inst : entity work.IS61WV102416BLL
	port map (
		a    => sram_addr,
		io   => sram_dq,
		ce_n => sram_ce_n,
		oe_n => sram_oe_n,
		we_n => sram_we_n,
		lb_n => sram_lb_n,
		ub_n => sram_ub_n
	);

	sram_ctrl_inst : entity work.sram_ctrl
	generic map (
		WR_BUF_SIZE => WR_BUF_SIZE
	)
	port map (
		clk   => clk,
		res_n => res_n,

		-- write port (buffered)
		wr_addr        => wr_addr,
		wr_data        => wr_data,
		wr             => wr,
		wr_access_mode => wr_access_mode,
		wr_empty       => wr_empty,
		wr_full        => wr_full,
		wr_half_full   => wr_half_full,

		-- read port 1 (high priority)
		rd1_addr        => rd1_addr,
		rd1             => rd1,
		rd1_access_mode => rd1_access_mode,
		rd1_busy        => rd1_busy,
		rd1_data        => rd1_data,
		rd1_valid       => rd1_valid,

		-- read port 2 (low priority)
		rd2_addr        => rd2_addr,
		rd2             => rd2,
		rd2_access_mode => rd2_access_mode,
		rd2_busy        => rd2_busy,
		rd2_data        => rd2_data,
		rd2_valid       => rd2_valid,

		-- external interface to SRAM
		sram_dq   => sram_dq,
		sram_addr => sram_addr,
		sram_ub_n => sram_ub_n,
		sram_lb_n => sram_lb_n,
		sram_we_n => sram_we_n,
		sram_ce_n => sram_ce_n,
		sram_oe_n => sram_oe_n
	);

	clk_gen : process is
	begin
		while not stop_clk loop
			clk <= '1';
			wait for CLK_PERIOD / 2;
			clk <= '0';
			wait for CLK_PERIOD / 2;
		end loop;
		wait;
	end process;
end architecture;

