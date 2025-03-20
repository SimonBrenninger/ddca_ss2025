library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.mem_pkg.all;
use work.gfx_core_pkg.all;
use work.tetris_pkg.all;
use work.tetris_util_pkg.all;
use work.decimal_printer_pkg.all;
use work.gfx_init_pkg.all;

architecture arch of tetris is

	type gfx_instr_array_t is array(natural range<>) of gfx_cmd_t;
	constant DISPLAY_WIDTH : integer := 320;
	constant DISPLAY_HEIGHT : integer := 240;
	constant BLOCK_SIZE : integer := 12;
	constant BLOCKS_X : integer := 10;
	constant BLOCKS_Y : integer := 20;

	--decimal printer signals
	signal dp_gci_in : gci_in_t;
	signal dp_start : std_ulogic;
	signal dp_busy : std_ulogic;
	signal dp_number : std_ulogic_vector(15 downto 0);

	-- gfx initializer
	signal gfx_initializer_gci_in : gci_in_t;
	signal gfx_initializer_start : std_ulogic;
	signal gfx_initializer_busy : std_ulogic;

	-- tetromino drawer
	signal td_gci_in : gci_in_t;
	signal td_start : std_ulogic;
	signal td_busy : std_ulogic;
	signal td_x : signed(GFX_CMD_WIDTH-1 downto 0);
	signal td_y : signed(GFX_CMD_WIDTH-1 downto 0);
	signal td_rotation : rotation_t;
	signal td_tetromino : tetromino_t;

	-- tetromino collider
	signal tc_start : std_ulogic;
	signal tc_busy : std_ulogic;
	signal tc_collision_detected :  std_ulogic;
	signal tc_tetromino_x : signed(log2c(BLOCKS_X) downto 0);
	signal tc_tetromino_y : signed(log2c(BLOCKS_Y) downto 0);
	signal tc_tetromino : tetromino_t;
	signal tc_rotation : rotation_t;
	signal tc_block_map_x : unsigned(log2c(BLOCKS_X)-1 downto 0);
	signal tc_block_map_y : unsigned(log2c(BLOCKS_Y)-1 downto 0);
	signal tc_block_map_rd : std_ulogic;
	signal tc_block_map_solid : std_ulogic;

	signal block_map_rd_x : unsigned(log2c(BLOCKS_X)-1 downto 0);
	signal block_map_rd_y : unsigned(log2c(BLOCKS_Y)-1 downto 0);
	signal block_map_rd : std_ulogic;
	signal block_map_rd_data : std_ulogic_vector(0 downto 0);
	
	signal block_map_wr_x : unsigned(log2c(BLOCKS_X)-1 downto 0);
	signal block_map_wr_y : unsigned(log2c(BLOCKS_Y)-1 downto 0);
	signal block_map_wr : std_ulogic;
	signal block_map_wr_data : std_ulogic_vector(0 downto 0);

	-- pseudo random tetromino generator
	signal prtg_value : tetromino_t;
	signal prtg_en : std_ulogic;

	type fsm_state_t is (
		RESET, WAIT_INIT,
		DO_FRAME_SYNC, WAIT_FRAME_SYNC, SWTICH_FRAME_BUFFER,
		CLEAR_SCREEN,
		TEST_WRITE_BLOCK_MAP, TEST_WRITE_BLOCK_MAP_2,
		PROCESS_INPUT,
		TEST_MOVEMENT, WAIT_CHECK_COLLISION,
		DRAW_TETROMINO, WAIT_DRAW_TETROMINO,
		DRAW_COLLISION_BORDER,
		DRAW_COLLISION_BORDER_1,
		DRAW_COLLISION_BORDER_2,
		DRAW_COLLISION_BORDER_3,
		DRAW_COLLISION_BORDER_4,
		DRAW_COLLISION_BORDER_5,
		DRAW_COLLISION_BORDER_6,
		DRAW_COLLISION_BORDER_7,
		DRAW_COLLISION_BORDER_8,
		DRAW_COLLISION_BORDER_9,
		DRAW_COLLISION_BORDER_10,
		DRAW_COLLISION_BORDER_11,
		DRAW_COLLISION_BORDER_12,
		DRAW_COLLISION_BORDER_13,
		CLEAR_BLOCK_MAP_INIT, CLEAR_BLOCK_MAP_WRITE,
		START_DECIMAL_PRINTER, WAIT_DECIMAL_PRINTER
	);
	
	type state_t is record
		fsm_state : fsm_state_t;
		frame_buffer_selector : std_ulogic;
		last_gamepad_state : tetris_gamepad_t;
		cur_tetromino_x : signed(log2c(BLOCKS_X) downto 0);
		cur_tetromino_y : signed(log2c(BLOCKS_Y) downto 0);
		cur_tetromino : tetromino_t;
		cur_rotation : rotation_t;
		
		dest_tetromino_x : signed(log2c(BLOCKS_X) downto 0);
		dest_tetromino_y : signed(log2c(BLOCKS_Y) downto 0);
		dest_tetromino : tetromino_t;
		dest_rotation : rotation_t;
		
		next_tetromino : tetromino_t;

		row_counter : unsigned(log2c(BLOCKS_Y)-1 downto 0);
		column_counter : unsigned(log2c(BLOCKS_X)-1 downto 0);
	end record;
	
	signal state, state_nxt : state_t;
	

	function unsigned_operand(operand : natural) return gfx_cmd_t is
	begin
		return std_ulogic_vector(to_unsigned(operand, 16));
	end function;
	
	function signed_operand(operand : integer) return gfx_cmd_t is
	begin
		return std_ulogic_vector(to_signed(operand, 16));
	end function;

	constant COLLISION_BORDER : gfx_instr_array_t(0 to 13) := (
		create_gfx_instr(opcode=>OPCODE_MOVE_GP, rel=>'0'),
		unsigned_operand(BLOCKS_X*BLOCK_SIZE),
		unsigned_operand(0),
		create_gfx_instr(opcode=>OPCODE_DRAW_VLINE, cs=>'1', rel=>'1'),
		unsigned_operand(239),
		create_gfx_instr(opcode=>OPCODE_MOVE_GP, rel=>'0'),
		unsigned_operand(0),
		unsigned_operand(9*BLOCK_SIZE),
		create_gfx_instr(opcode=>OPCODE_DRAW_HLINE, cs=>'1', mx=>'1', my=>'0', rel=>'1'),
		unsigned_operand(2*BLOCK_SIZE-1),
		create_gfx_instr(opcode=>OPCODE_DRAW_VLINE, cs=>'1', mx=>'0', my=>'1', rel=>'1'),
		unsigned_operand(BLOCK_SIZE-1),
		create_gfx_instr(opcode=>OPCODE_DRAW_HLINE, cs=>'1', mx=>'1', my=>'1', rel=>'1'),
		signed_operand(-(2*BLOCK_SIZE-1))
	);
begin

	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			state <= (
				fsm_state => RESET,
				frame_buffer_selector => '0',
				last_gamepad_state => TETRIS_GAMEPAD_ZERO,
				cur_tetromino_x => (others => '0'),
				cur_tetromino_y => (others => '0'),
				cur_tetromino => TET_Z,
				cur_rotation => (others => '0'),
				dest_tetromino_x => (others => '0'),
				dest_tetromino_y => (others => '0'),
				dest_tetromino => (others => '0'),
				dest_rotation => (others => '0'),
				next_tetromino => TET_I,
				row_counter => (others => '0'),
				column_counter => (others => '0')
			);
		elsif (rising_edge(clk)) then
			state <= state_nxt;
		end if;
	end process;

	next_state_logic : process(all)
		procedure gci_write(cmd : gfx_cmd_t; next_state : fsm_state_t) is
		begin
			if gci_out.full = '0' then
				gci_in.wr <= '1';
				gci_in.wr_data <= cmd;
				state_nxt.fsm_state <= next_state;
			end if;
		end procedure;
	begin
		state_nxt <= state;

		gci_in.wr <= '0';
		gci_in.wr_data <= (others=>'0');

		-- pseudo random tetromino generator
		prtg_en <= '0';

		-- gfx initializer
		gfx_initializer_start <= '0';

		-- decimal printer
		dp_start <= '0';
		dp_number <= (others => '0');
		dp_number(1 downto 0) <= state.cur_rotation;
		dp_number(4 downto 2) <= state.cur_tetromino;

		-- tetromino collider
		tc_start <= '0';
		tc_tetromino_x <= state.dest_tetromino_x;
		tc_tetromino_y <= state.dest_tetromino_y;
		tc_tetromino <= state.dest_tetromino;
		tc_rotation <= state.dest_rotation;

		-- not used in the core tetris task
		rumble <= '0';

		--tetromino drawer
		td_start <= '0';
		td_tetromino <= state.cur_tetromino;
		td_rotation <= state.cur_rotation;
		td_x <= resize(signed(state.cur_tetromino_x)*BLOCK_SIZE, td_x'length);
		td_y <= resize(signed(state.cur_tetromino_y)*BLOCK_SIZE, td_y'length);
		
		--block map stuff
		block_map_rd_x <= (others=>'0');
		block_map_rd_y <= (others=>'0');
		block_map_rd <= '0';
		block_map_wr <= '0';
		block_map_wr_x <= (others=>'0');
		block_map_wr_y <= (others=>'0');
		block_map_wr_data <= (others=>'0');


		case state.fsm_state is
			when RESET =>
				state_nxt.fsm_state <= WAIT_INIT;
				gfx_initializer_start <= '1';
				gci_in <= gfx_initializer_gci_in;
				
			when WAIT_INIT =>
				gci_in <= gfx_initializer_gci_in;
				if (gfx_initializer_busy = '0') then
					state_nxt.fsm_state <= CLEAR_BLOCK_MAP_INIT;
				end if;
			
			when CLEAR_BLOCK_MAP_INIT =>
				state_nxt.cur_tetromino_x <= to_signed(BLOCKS_X/2-1, state.cur_tetromino_x'length);
				state_nxt.cur_tetromino_y <= (others=>'0');
				state_nxt.row_counter <= (others=>'0');
				state_nxt.column_counter <= (others=>'0');
				state_nxt.fsm_state <= CLEAR_BLOCK_MAP_WRITE;
			
			when CLEAR_BLOCK_MAP_WRITE =>
				if (state.column_counter = BLOCKS_X-1) then
					state_nxt.column_counter <= (others=>'0');
					if (state.row_counter = BLOCKS_Y-1) then
						state_nxt.fsm_state <= DO_FRAME_SYNC;
					else
						state_nxt.row_counter <= state.row_counter + 1;
					end if;
				else
					state_nxt.column_counter <= state.column_counter + 1;
				end if;
				
				block_map_wr_x <= state.column_counter;
				block_map_wr_y <= state.row_counter;
				block_map_wr_data <= (others=>'0');
				block_map_wr <= '1';
			
			when DO_FRAME_SYNC =>
				gci_write(
					create_gfx_instr(
						opcode => OPCODE_DISPLAY_BMP,
						fs => '1',
						bmpidx => (2 downto 1 => '0', 0=>state.frame_buffer_selector)
					), WAIT_FRAME_SYNC
				);
			
			when WAIT_FRAME_SYNC =>
				if gci_out.frame_sync = '1' then
					state_nxt.fsm_state <= SWTICH_FRAME_BUFFER;
					state_nxt.frame_buffer_selector <= not state.frame_buffer_selector;
				end if;
			
			when SWTICH_FRAME_BUFFER =>
				gci_write(
					create_gfx_instr(
						opcode => OPCODE_ACTIVATE_BMP,
						bmpidx => (2 downto 1 => '0', 0=>state.frame_buffer_selector)
					), CLEAR_SCREEN
				);
			
			when CLEAR_SCREEN =>
				gci_write(
					create_gfx_instr(
						opcode => OPCODE_CLEAR,
						cs => CS_PRIMARY
					), TEST_WRITE_BLOCK_MAP
				);
				
			when TEST_WRITE_BLOCK_MAP =>
				block_map_wr <= '1';
				block_map_wr_x <= to_unsigned(0, block_map_wr_x'length);
				block_map_wr_y <= to_unsigned(9, block_map_wr_y'length);
				block_map_wr_data <= "1";
				state_nxt.fsm_state <= TEST_WRITE_BLOCK_MAP_2;
				
			when TEST_WRITE_BLOCK_MAP_2 =>
				block_map_wr <= '1';
				block_map_wr_x <= to_unsigned(1, block_map_wr_x'length);
				block_map_wr_y <= to_unsigned(9, block_map_wr_y'length);
				block_map_wr_data <= "1";
				state_nxt.fsm_state <= PROCESS_INPUT;

			
			--██╗███╗   ██╗██████╗ ██╗   ██╗████████╗
			--██║████╗  ██║██╔══██╗██║   ██║╚══██╔══╝
			--██║██╔██╗ ██║██████╔╝██║   ██║   ██║
			--██║██║╚██╗██║██╔═══╝ ██║   ██║   ██║
			--██║██║ ╚████║██║     ╚██████╔╝   ██║
			--╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝    ╚═╝
			when PROCESS_INPUT =>
				state_nxt.last_gamepad_state <= gamepad;
				state_nxt.fsm_state <= DRAW_COLLISION_BORDER;
				
				state_nxt.dest_tetromino_x <= state.cur_tetromino_x;
				state_nxt.dest_tetromino_y <= state.cur_tetromino_y;
				state_nxt.dest_tetromino <= state.cur_tetromino;
				state_nxt.dest_rotation <= state.cur_rotation;

				if (gamepad.dir_right = '1' and state.last_gamepad_state.dir_right = '0') then
					state_nxt.dest_tetromino_x <= state.cur_tetromino_x + 1;
					state_nxt.fsm_state <= TEST_MOVEMENT;
				end if;
				if (gamepad.dir_left = '1' and state.last_gamepad_state.dir_left = '0') then
					state_nxt.dest_tetromino_x <= state.cur_tetromino_x - 1;
					state_nxt.fsm_state <= TEST_MOVEMENT;
				end if;
				if (gamepad.dir_up = '1' and state.last_gamepad_state.dir_up = '0') then
					state_nxt.dest_tetromino_y <= state.cur_tetromino_y - 1;
					state_nxt.fsm_state <= TEST_MOVEMENT;
				end if;
				if (gamepad.dir_down = '1' and state.last_gamepad_state.dir_down = '0') then
					state_nxt.dest_tetromino_y <= state.cur_tetromino_y + 1;
					state_nxt.fsm_state <= TEST_MOVEMENT;
				end if;
				if (gamepad.a = '1' and state.last_gamepad_state.a = '0') then
					state_nxt.dest_rotation <= std_ulogic_vector(unsigned(state.cur_rotation) + 1);
					state_nxt.fsm_state <= TEST_MOVEMENT;
				end if;
				
				
				if (gamepad.b = '1' and state.last_gamepad_state.b = '0') then
					prtg_en <= '1';
					state_nxt.cur_tetromino <= state.next_tetromino;
					state_nxt.cur_tetromino_x <= to_signed(BLOCKS_X/2-1, state.cur_tetromino_x'length);
					state_nxt.cur_tetromino_y <= (others=>'0');
					state_nxt.cur_rotation <= ROT_0;
					state_nxt.next_tetromino <= prtg_value;
				end if;

			when TEST_MOVEMENT =>
				tc_start <= '1';
				state_nxt.fsm_state <= WAIT_CHECK_COLLISION;
			
			when WAIT_CHECK_COLLISION =>
				if (tc_busy = '0') then
					if (tc_collision_detected = '0') then
						-- no colliision detected -> transform current tetromino to destination state
						state_nxt.cur_tetromino_x <= state.dest_tetromino_x;
						state_nxt.cur_tetromino_y <= state.dest_tetromino_y;
						state_nxt.cur_rotation <= state.dest_rotation;
						state_nxt.cur_tetromino <= state.dest_tetromino;
					end if;
					state_nxt.fsm_state <= DRAW_COLLISION_BORDER;
				end if;
			
			--██████╗  ██████╗ ██████╗ ██████╗ ███████╗██████╗
			--██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
			--██████╔╝██║   ██║██████╔╝██║  ██║█████╗  ██████╔╝
			--██╔══██╗██║   ██║██╔══██╗██║  ██║██╔══╝  ██╔══██╗
			--██████╔╝╚██████╔╝██║  ██║██████╔╝███████╗██║  ██║
			--╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝
			when DRAW_COLLISION_BORDER => gci_write(COLLISION_BORDER(0), DRAW_COLLISION_BORDER_1);
			when DRAW_COLLISION_BORDER_1 => gci_write(COLLISION_BORDER(1), DRAW_COLLISION_BORDER_2);
			when DRAW_COLLISION_BORDER_2 => gci_write(COLLISION_BORDER(2), DRAW_COLLISION_BORDER_3);
			when DRAW_COLLISION_BORDER_3 => gci_write(COLLISION_BORDER(3), DRAW_COLLISION_BORDER_4);
			when DRAW_COLLISION_BORDER_4 => gci_write(COLLISION_BORDER(4), DRAW_COLLISION_BORDER_5);
			when DRAW_COLLISION_BORDER_5 => gci_write(COLLISION_BORDER(5), DRAW_COLLISION_BORDER_6);
			when DRAW_COLLISION_BORDER_6 => gci_write(COLLISION_BORDER(6), DRAW_COLLISION_BORDER_7);
			when DRAW_COLLISION_BORDER_7 => gci_write(COLLISION_BORDER(7), DRAW_COLLISION_BORDER_8);
			when DRAW_COLLISION_BORDER_8 => gci_write(COLLISION_BORDER(8), DRAW_COLLISION_BORDER_9);
			when DRAW_COLLISION_BORDER_9 => gci_write(COLLISION_BORDER(9), DRAW_COLLISION_BORDER_10);
			when DRAW_COLLISION_BORDER_10 => gci_write(COLLISION_BORDER(10), DRAW_COLLISION_BORDER_11);
			when DRAW_COLLISION_BORDER_11 => gci_write(COLLISION_BORDER(11), DRAW_COLLISION_BORDER_12);
			when DRAW_COLLISION_BORDER_12 => gci_write(COLLISION_BORDER(12), DRAW_COLLISION_BORDER_13);
			when DRAW_COLLISION_BORDER_13 => gci_write(COLLISION_BORDER(13), DRAW_TETROMINO);


			--██████╗ ██╗      ██████╗  ██████╗██╗  ██╗███████╗
			--██╔══██╗██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔════╝
			--██████╔╝██║     ██║   ██║██║     █████╔╝ ███████╗
			--██╔══██╗██║     ██║   ██║██║     ██╔═██╗ ╚════██║
			--██████╔╝███████╗╚██████╔╝╚██████╗██║  ██╗███████║
			--╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝
			when DRAW_TETROMINO =>
				td_start <= '1';
				state_nxt.fsm_state <= WAIT_DRAW_TETROMINO;
				
				
			when WAIT_DRAW_TETROMINO =>
				gci_in <= td_gci_in;
				if (td_busy = '0') then
					state_nxt.fsm_state <= START_DECIMAL_PRINTER;
				end if;
			
			--██╗      █████╗ ██████╗ ███████╗██╗
			--██║     ██╔══██╗██╔══██╗██╔════╝██║
			--██║     ███████║██████╔╝█████╗  ██║
			--██║     ██╔══██║██╔══██╗██╔══╝  ██║
			--███████╗██║  ██║██████╔╝███████╗███████╗
			--╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝
			when START_DECIMAL_PRINTER =>
				dp_start <= '1';
				state_nxt.fsm_state <= WAIT_DECIMAL_PRINTER;
				
			when WAIT_DECIMAL_PRINTER =>
				gci_in <= dp_gci_in;
				if (dp_busy = '0') then
					state_nxt.fsm_state <= DO_FRAME_SYNC;
				end if;
			
			when others => null;
		end case;
	end process;

	gfx_initializer : block
		signal instr_cnt : integer := 0;
		signal instr_cnt_nxt : integer := 0;

		signal gfx_initializer_cmd_nxt : gfx_cmd_t;
		signal instr_busy, instr_busy_nxt : std_ulogic;
		signal running, running_nxt : std_ulogic;
	begin
		gfx_initializer_busy <= running;

		process(clk, res_n)
		begin
			if (res_n = '0') then
				instr_cnt <= 0;
				gfx_initializer_gci_in.wr_data <= (others=>'0');
				running <= '0';
			elsif (rising_edge(clk)) then
				gfx_initializer_gci_in.wr_data <= gfx_initializer_cmd_nxt;
				instr_cnt <= instr_cnt_nxt;
				running <= running_nxt;
			end if;
		end process;
		
		process(all)
		begin
			gfx_initializer_gci_in.wr <= '0';
			
			instr_cnt_nxt <= instr_cnt;
			gfx_initializer_cmd_nxt <= gfx_initializer_gci_in.wr_data;
			running_nxt <= running;
			
			if (gfx_initializer_start = '1') then
				instr_cnt_nxt <= 1;
				running_nxt <= '1';
				gfx_initializer_cmd_nxt <= GFX_INIT_CMDS(0);
			end if;

			if (running = '1') then
				if (gci_out.full = '0') then
					gfx_initializer_gci_in.wr <= '1';
					
					if (instr_cnt = 0) then
						running_nxt <= '0';
					elsif (instr_cnt = GFX_INIT_CMDS'length-1) then
						instr_cnt_nxt <= 0;
						gfx_initializer_cmd_nxt <= GFX_INIT_CMDS(instr_cnt);
					else
						gfx_initializer_cmd_nxt <= GFX_INIT_CMDS(instr_cnt);
						instr_cnt_nxt <= instr_cnt + 1;
					end if;
				end if;
			end if;
		end process;
	end block;

	tetromino_drawer_inst : tetromino_drawer
	generic map (
		BLOCK_SIZE => BLOCK_SIZE
	)
	port map (
		clk        => clk,
		res_n      => res_n,
		start      => td_start,
		busy       => td_busy,
		x          => td_x,
		y          => td_y,
		tetromino  => td_tetromino,
		rotation   => td_rotation,
		bmpidx     => "011",
		gci_in     => td_gci_in,
		gci_out    => gci_out
	);
	
	decimal_printer_inst : decimal_printer
	port map (
		clk        => clk,
		res_n      => res_n,
		gci_in     => dp_gci_in,
		gci_out    => gci_out,
		bmpidx     => "010",
		charwidth  => "001000",
		start      => dp_start,
		busy       => dp_busy,
		number     => dp_number
	);
	
	tetromino_collider_inst : tetromino_collider
	generic map (
		BLOCKS_X => BLOCKS_X,
		BLOCKS_Y => BLOCKS_Y
	)
	port map (
		clk                => clk,
		res_n              => res_n,
		start              => tc_start,
		busy               => tc_busy,
		collision_detected => tc_collision_detected,
		tetromino_x        => tc_tetromino_x,
		tetromino_y        => tc_tetromino_y,
		tetromino          => tc_tetromino,
		rotation           => tc_rotation,
		block_map_x        => tc_block_map_x,
		block_map_y        => tc_block_map_y,
		block_map_rd       => tc_block_map_rd,
		block_map_solid    => tc_block_map_solid
	);

	block_map : block
		signal block_map_rd_addr : std_ulogic_vector(log2c(BLOCKS_X*BLOCKS_Y)-1 downto 0);
		signal block_map_wr_addr : std_ulogic_vector(log2c(BLOCKS_X*BLOCKS_Y)-1 downto 0);
	begin
		process(all)
		begin
			block_map_rd_addr <= std_ulogic_vector(resize(block_map_rd_x + BLOCKS_X * block_map_rd_y, block_map_rd_addr'length));
			block_map_wr_addr <= std_ulogic_vector(resize(block_map_wr_x + BLOCKS_X * block_map_wr_y, block_map_wr_addr'length));
			if (tc_block_map_rd = '1') then
				block_map_rd_addr <= std_ulogic_vector(resize(tc_block_map_x + BLOCKS_X * tc_block_map_y, block_map_rd_addr'length));
			end if;
		end process;
		
		tc_block_map_solid <= block_map_rd_data(0);
		
		block_map_ram : dp_ram_1c1r1w
		generic map (
			ADDR_WIDTH => log2c(BLOCKS_X*BLOCKS_Y),
			DATA_WIDTH => 1
		)
		port map (
			clk      => clk,
			rd1_addr => block_map_rd_addr,
			rd1_data => block_map_rd_data,
			rd1      => block_map_rd or tc_block_map_rd,
			wr2_addr => block_map_wr_addr,
			wr2_data => block_map_wr_data,
			wr2      => block_map_wr
		);
	end block;

	prtg : block
		signal lfsr : std_ulogic_vector(14 downto 0); --15 bit
	begin
		process(clk, res_n)
		begin
			if (res_n = '0') then
				lfsr <= std_ulogic_vector(to_unsigned(1234,lfsr'length));
				prtg_value <= (others=>'0');
			elsif (rising_edge(clk)) then
				if (prtg_en = '1') then
					lfsr(lfsr'length-1 downto 1) <= lfsr(lfsr'length-2 downto 0);
					lfsr(0) <= lfsr(14) xor lfsr(13);
					
					prtg_value <= (others=>'0');
					for i in 0 to lfsr'length/3-1 loop
						if (lfsr((i+1)*3-1 downto i*3) /= "111") then
							prtg_value <= lfsr((i+1)*3-1 downto i*3);
							exit;
						end if;
					end loop;
				end if;
			end if;
		end process;
	end block;

end architecture;
