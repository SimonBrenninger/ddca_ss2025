library ieee;
use ieee.std_logic_1164.all;

use work.sram_ctrl_pkg.all;


architecture top_arch_sram_ctrl of top is
	constant ADDR_WIDTH  : positive := 21;
	constant DATA_WIDTH  : positive := 16;
	constant WR_BUF_SIZE : positive := 8;

	signal wr_addr, rd1_addr, rd2_addr                      : std_ulogic_vector(ADDR_WIDTH-1 downto 0);
	signal wr_data, rd1_data, rd2_data                      : std_ulogic_vector(DATA_WIDTH-1 downto 0);
	signal wr, rd1, rd2                                     : std_ulogic;
	signal wr_empty, wr_full, wr_half_full                  : std_ulogic;
	signal rd1_busy, rd2_busy, rd1_valid, rd2_valid         : std_ulogic;
	signal wr_access_mode, rd1_access_mode, rd2_access_mode : sram_access_mode_t;

	signal res_n : std_ulogic;
begin

	res_n <= keys(0);

	sram_cntrl_inst : entity work.sram_ctrl(arch)
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

	-- TODO: Implement the siumulus process as given in the task description
	stimulus : process(clk, res_n) is
	begin
		if not res_n then
			wr  <= '0';
			rd1 <= '0';
			rd2 <= '0';

			wr_access_mode  <= BYTE;
			rd1_access_mode <= BYTE;
			rd2_access_mode <= BYTE;

			wr_addr <= (others => '0');
			wr_data <= (others => '0');
			rd1_addr <= (others => '0');
			rd2_addr <= (others => '0');
		elsif rising_edge(clk) then
			wr  <= '0';
			rd1 <= '0';
			rd2 <= '0';

			wr_access_mode  <= BYTE;
			rd1_access_mode <= BYTE;
			rd2_access_mode <= BYTE;

			wr_addr <= (others => '0');
			wr_data <= (others => '0');
			rd1_addr <= (others => '0');
			rd2_addr <= (others => '0');
		end if;
	end process;

end architecture;
