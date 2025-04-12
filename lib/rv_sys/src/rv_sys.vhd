library ieee;
use ieee.std_logic_1164.all;

use work.rv_sys_pkg.all;


entity rv_sys is
	generic (
		BAUD_RATE  : natural := 115200;
		CLK_FREQ   : natural := 75000000;
		SIMULATE_ELF_FILE : string := "OFF";
		GPIO_ADDR_WIDTH : natural := 8;
		DMEM_DELAY : natural := 0;
		IMEM_DELAY : natural := 0
	);
	port (
		clk   : in std_ulogic;
		res_n : in std_ulogic;

		cpu_reset_n : out std_ulogic;

		-- instruction memory interface
		imem_out  : in  mem_out_t;
		imem_in   : out mem_in_t;

		-- data memory interface
		dmem_out  : in  mem_out_t;
		dmem_in   : out mem_in_t;
		
		-- UART port
		rx         : in std_ulogic;
		tx         : out std_ulogic;
		
		-- GPIO
		gp_out : out mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
		gp_in  : in  mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0)
	);
end entity;

architecture arch of rv_sys is
	signal ocram_out : mem_out_t;
	signal ocram_in  : mem_in_t;
	signal ocram_out_del : mem_out_t;
	signal ocram_in_del, ocram_in_del_sim, ocram_in_del_jtag  : mem_in_t;

	signal uart_out : mem_out_t;
	signal uart_in  : mem_in_t;

	signal counter_in  : mem_in_t;

	signal gpio_out : mem_out_t;
	signal gpio_in  : mem_in_t;

	signal imem_in_del, imem_in_del_sim, imem_in_del_jtag : mem_in_t;
	signal imem_out_del : mem_out_t;

	type mux_type is (MUX_OCRAM, MUX_UART, MUX_COUNT, MUX_GPIO);
	signal mux : mux_type;

	signal mem_ctrl, mem_ctrl_sim, mem_ctrl_jtag : mem_data_t;

	-- See comment further below at MUX
	constant IS_SIM : boolean := (SIMULATE_ELF_FILE /= "") and (SIMULATE_ELF_FILE /= "OFF");
begin
	cpu_reset_n <= mem_ctrl(0);

	delay_d : entity work.delay
	generic map (
		CYCLES => DMEM_DELAY
	)
	port map (
		clk      => clk,
		res_n    => res_n,

		-- master interface
		mem_out_m  => ocram_out,
		mem_in_m   => ocram_in,

		-- slave interface
		mem_out_s  => ocram_out_del,
		mem_in_s   => ocram_in_del
	);

	delay_i : entity work.delay
	generic map (
		CYCLES => IMEM_DELAY
	)
	port map (
		clk      => clk,
		res_n    => res_n,

		-- master interface
		mem_out_m  => imem_out,
		mem_in_m   => imem_in,

		-- slave interface
		mem_out_s  => imem_out_del,
		mem_in_s   => imem_in_del
	);

	-- This MUX might seem a bit awkward, but is the result of working around a GHDL bug where GHDL crashes when
	-- dumping signals and using a generate statement based on the string comparison of IS_SIM
	process(all) is
	begin
		if IS_SIM then
			mem_ctrl     <= mem_ctrl_sim;
			imem_in_del <= imem_in_del_sim;
			ocram_in_del <= ocram_in_del_sim;
		else
			mem_ctrl     <= mem_ctrl_jtag;
			imem_in_del <= imem_in_del_jtag;
			ocram_in_del <= ocram_in_del_jtag;
		end if;
	end process;

	mem_sim : entity work.memory_sim
	generic map (
		RAM_SIZE_LD => 12,
		ELF_FILE => SIMULATE_ELF_FILE
	)
	port map (
		clk => clk,
		res_n => res_n,

		control => mem_ctrl_sim,

		imem_out => imem_out_del,
		imem_in  => imem_in_del_sim,

		dmem_out => ocram_out_del,
		dmem_in => ocram_in_del_sim
	);

	mem_jtag : entity work.memory_jtag
	generic map (
		RAM_SIZE_LD => 12
	)
	port map (
		clk => clk,
		res_n => res_n,

		control => mem_ctrl_jtag,

		imem_out => imem_out_del,
		imem_in  => imem_in_del_jtag,

		dmem_out => ocram_out_del,
		dmem_in => ocram_in_del_jtag
	);

	uart : entity work.mm_serial_port
	generic map (
		CLK_FREQ  => CLK_FREQ,
		BAUD_RATE => BAUD_RATE,
		sync_stages => 2,
		tx_fifo_depth => 4,
		rx_fifo_depth => 4
	)
	port map (
		clk     => clk,
		res_n   => res_n,

		address => uart_out.address(0 downto 0),
		wr      => uart_out.wr,
		wr_data => uart_out.wrdata,
		rd      => uart_out.rd,
		rd_data => uart_in.rddata,

		tx      => tx,
		rx      => rx
	);
	uart_in.busy <= '0';

	counter : entity work.mm_counter
	generic map (
		CLK_FREQ => CLK_FREQ
	)
	port map (
		clk => clk,
		res_n => res_n,
		value => counter_in.rddata
	);
	counter_in.busy <= '0';

	gpio : entity work.mm_gpio
	generic map(
		ADDR_WIDTH => GPIO_ADDR_WIDTH
	)
	port map(
		clk     => clk,
		res_n   =>  res_n,

		address => gpio_out.address(GPIO_ADDR_WIDTH-1 downto 0),
		wr      => gpio_out.wr,
		wr_data => gpio_out.wrdata,
		rd      => gpio_out.rd,
		rd_data => gpio_in.rddata,
		busy    => gpio_in.busy,

		gp_out => gp_out,
		gp_in  => gp_in
	);

	iomux: process (all)
	begin

		mux <= MUX_OCRAM;

		case dmem_out.address(RV_SYS_ADDR_WIDTH-1 downto RV_SYS_ADDR_WIDTH-2) is
			when "00" => mux <= MUX_OCRAM;
			when "01" => mux <= MUX_GPIO;
			when "10" => mux <= MUX_COUNT;
			when "11" => mux <= MUX_UART;
			when others => null;
		end case;

		case mux is
			when MUX_OCRAM => dmem_in <= ocram_in;
			when MUX_UART  => dmem_in <= uart_in;
			when MUX_COUNT => dmem_in <= counter_in;
			when MUX_GPIO  => dmem_in <= gpio_in;
			when others    => dmem_in <= MEM_IN_NOP;
		end case;

		ocram_out <= dmem_out;
		if mux /= MUX_OCRAM then
			ocram_out.rd <= '0';
			ocram_out.wr <= '0';
		end if;

		uart_out <= dmem_out;
		if mux /= MUX_UART then
			uart_out.rd <= '0';
			uart_out.wr <= '0';
		end if;

		gpio_out <= dmem_out;
		if mux /= MUX_GPIO then
			gpio_out.rd <= '0';
			gpio_out.wr <= '0';
		end if;
	end process;

end architecture;
