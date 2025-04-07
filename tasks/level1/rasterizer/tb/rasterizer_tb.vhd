library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.math_pkg.all;
use work.mem_pkg.all;
use work.tb_util_pkg.all;
use work.sram_ctrl_pkg.all;
use work.gfx_core_pkg.all;


entity rasterizer_tb is
end entity;

architecture bench of rasterizer_tb is
	constant VRAM_ADDR_WIDTH : integer := 21;
	constant VRAM_DATA_WIDTH : integer := 16;

	signal clk : std_logic;
	signal res_n : std_logic;

	signal vram_wr_addr        : std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
	signal vram_wr_data        : std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
	signal vram_wr_full        : std_ulogic;
	signal vram_wr_emtpy       : std_ulogic;
	signal vram_wr             : std_ulogic;
	signal vram_wr_access_mode : sram_access_mode_t;

	signal vram_rd_addr        : std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
	signal vram_rd_data        : std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
	signal vram_rd_busy        : std_ulogic;
	signal vram_rd             : std_ulogic;
	signal vram_rd_valid       : std_ulogic;
	signal vram_rd_access_mode : sram_access_mode_t;

	signal fr_base_addr     : std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
	signal fr_base_addr_req : std_ulogic;

	signal gcf_rd    : std_ulogic;
	signal gcf_data  : gfx_cmd_t;
	signal gcf_empty : std_ulogic;

	constant CLK_PERIOD : time := 10 ns;
	signal stop_clock : boolean := false;

	shared variable vram : vram_t;

	signal gci_in : gci_in_t;
	signal gci_out : gci_out_t;
begin

	gcf : fifo_1c1r1w
	generic map (
		DEPTH => 8,
		DATA_WIDTH => GFX_CMD_WIDTH
	)
	port map (
		clk       => clk,
		res_n     => res_n,
		wr_data   => gci_in.wr_data,
		wr        => gci_in.wr,
		full      => gci_out.full,
		rd        => gcf_rd,
		rd_data   => gcf_data,
		empty     => gcf_empty
	);

	-- change this to work.rasterizer(arch) to test your implementation
	uut: entity work.rasterizer(ref)
	generic map(
		VRAM_ADDR_WIDTH => VRAM_ADDR_WIDTH,
		VRAM_DATA_WIDTH => VRAM_DATA_WIDTH
	)
	port map (
		clk => clk,
		res_n => res_n,

		-- write interface to VRAM
		vram_wr_addr => vram_wr_addr,
		vram_wr_data => vram_wr_data,
		vram_wr_full => vram_wr_full,
		vram_wr_emtpy => vram_wr_emtpy,
		vram_wr => vram_wr,
		vram_wr_access_mode => vram_wr_access_mode,

		-- read interface to VRAM
		vram_rd_addr => vram_rd_addr,
		vram_rd_data => vram_rd_data,
		vram_rd_busy => vram_rd_busy,
		vram_rd => vram_rd,
		vram_rd_valid => vram_rd_valid,
		vram_rd_access_mode => vram_rd_access_mode,

		-- frame reader signals
		fr_base_addr => fr_base_addr,
		fr_base_addr_req => fr_base_addr_req,

		-- gfx command FIFO read port
		gcf_rd => gcf_rd,
		gcf_data => gcf_data,
		gcf_empty => gcf_empty,

		-- outputs signals
		rd_data => gci_out.rd_data,
		rd_valid => gci_out.rd_valid,
		frame_sync => gci_out.frame_sync
	);

	process
		procedure gci_write(data : gfx_cmd_t) is
		begin
		end procedure;
	begin
		res_n <= '0';
		fr_base_addr_req <= '0';
		gci_in.wr <= '0';
		wait until rising_edge(clk);
		wait for 2*CLK_PERIOD;
		res_n <= '1';
		wait for CLK_PERIOD;

		gci_write(create_gfx_instr(opcode=>OPCODE_MOVE_GP, rel=>'0'));
		gci_write(x"0000");
		gci_write(x"0000");
		gci_write(create_gfx_instr(opcode=>OPCODE_SET_COLOR, cs=>CS_PRIMARY, color=>x"55"));
		gci_write(create_gfx_instr(opcode=>OPCODE_SET_COLOR, cs=>CS_SECONDARY, color=>x"aa"));

		gci_write(create_gfx_instr(opcode=>OPCODE_DEFINE_BMP, bmpidx=>"001"));
		gci_write(x"2c00");
		gci_write(x"0001");
		gci_write(x"0020");
		gci_write(x"0018");
		gci_write(create_gfx_instr(opcode=>OPCODE_ACTIVATE_BMP, bmpidx=>"001"));
		gci_write(create_gfx_instr(opcode=>OPCODE_CLEAR, cs=>CS_PRIMARY));

		gci_write(create_gfx_instr(opcode=>OPCODE_DEFINE_BMP, bmpidx=>"000"));
		gci_write(x"0000");
		gci_write(x"0000");
		gci_write(x"0140");
		gci_write(x"00f0");
		gci_write(create_gfx_instr(opcode=>OPCODE_ACTIVATE_BMP, bmpidx=>"000"));
		gci_write(create_gfx_instr(opcode=>OPCODE_CLEAR, cs=>CS_SECONDARY));
		for i in 0 to 9 loop
			gci_write(create_gfx_instr(opcode=>OPCODE_BB_FULL, mx => '1', my => '1', bmpidx=>"001"));
		end loop;
		
		gci_write(create_gfx_instr(opcode=>OPCODE_NOP));

		-- when the NOP is consumed we know that all previous commands have been executed
		wait until gcf_empty = '1';
		vram.dump_bitmap(0, 320, 240, "out.ppm");

		stop_clock <= true;
		wait;

	end process;

	init_vram : process
	begin
		vram.init(21);
		wait;
	end process;

	vram_read : process(clk, res_n)
	begin
		if res_n = '0' then
			vram_rd_busy <= '0'; -- never busy
			vram_rd_data <= (others => '0');
			vram_rd_valid <= '0';
		elsif rising_edge(clk) then
		end if;
	end process;

	vram_write : process(clk, res_n)
	begin
		if res_n = '0' then
			vram_wr_full <= '0'; -- never full
			vram_wr_emtpy <= '1'; -- always empty
		elsif rising_edge(clk) then
		end if;
	end process;
	
	generate_clk : process
	begin
		while not stop_clock loop
			clk <= '0', '1' after CLK_PERIOD / 2;
			wait for CLK_PERIOD;
		end loop;
		wait;
	end process;
end architecture;
