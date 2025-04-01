
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.mem_pkg.all;
use work.sram_ctrl_pkg.all;
use work.gfx_core_pkg.all;
use work.gfx_util_pkg.all;

architecture arch of rasterizer is

	type ctrl_fsm_state_t is (
		IDLE,
		ACTIVATE_BMP,
		DRAW_CIRCLE, DRAW_CIRCLE_WAIT,
		VRAM_WRITE,
		VRAM_READ, WAIT_VRAM_READ1, WAIT_VRAM_READ2,
		VRAM_WRITE_INIT, VRAM_WRITE_SEQ, VRAM_WRITE_LOOP_LOAD_OPERAND, VRAM_WRITE_LOOP_WRITE,
		DISPLAY_BMP,
		CLEAR, CLEAR_LOOP,
		DRAW_HLINE, DRAW_HLINE_LOOP,
		DRAW_VLINE, DRAW_VLINE_LOOP,
		GET_PIXEL, GET_PIXEL1, GET_PIXEL2, GET_PIXEL_WAIT_VRAM_READ, GET_PIXEL_DONE,
		BB_START, BB_LOOP, BB_COMPLETE
	);


	type state_t is record
		fsm_state : ctrl_fsm_state_t;
		fr_base_addr : std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0); -- register that hold the current base address for the frame reader
		vram_rd_data : std_ulogic_vector(15 downto 0); -- register that holds the data of the last read command (VRAM_READ or GET_PIXEL)
		vram_addr_buffer : std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0); -- temporary register used for executing VRAM_WRITE_INIT/SEQ commands
		write_cnt : u16_t; -- temporay register to keep track of the number of writes when executing VRAM_WRITE_INIT/SEQ commands
		tmp_vec : vec2d_s16_t; -- temporary register used to execute some commands
		-- user "visible" registers
		gp : vec2d_s16_t; -- graphics pointer
		pcol : color_t; -- primary color
		scol : color_t; -- secondary color
		abd : bd_t; -- active bitmap descriptor
		bb_effect : bb_effect_t; -- bit blit effect
	end record;

	constant CNTRL_STATE_RESET : state_t := (
		fsm_state => IDLE,
		fr_base_addr => (others => '0'),
		vram_rd_data => (others => '0'),
		vram_addr_buffer => (others => '0'),
		write_cnt => (others => '0'),
		tmp_vec => VEC2D_S16_ZERO,
		gp => VEC2D_S16_ZERO,
		pcol => (others => '0'),
		scol => (others => '0'),
		abd => ((others=>'0'),(others=>'0'),(others=>'0')),
		bb_effect => (others=>(others=>'0'))
	);

	signal state, state_nxt : state_t;


	signal stall : std_ulogic; -- the stall signal is produced by the pixel writer core

	-- pixel writer interface signals
	signal pw_wr : std_ulogic;
	signal pw_color : color_t;
	signal pw_position : vec2d_s16_t;
	signal pw_alpha_mode : std_ulogic;
	signal pw_oob : std_ulogic;

	signal pw_vram_wr_addr : std_ulogic_vector(vram_wr_addr'range);
	signal pw_vram_wr_data : std_ulogic_vector(vram_wr_data'range);
	signal pw_vram_wr : std_ulogic;
	signal pw_vram_wr_access_mode : sram_access_mode_t;

	--signals used for direct VRAM access in the FSM (used for VRAM_WRITE, VRAM_WRITE_INIT/SEQ)
	signal direct_vram_wr : std_ulogic;
	signal direct_vram_wr_addr : std_ulogic_vector(vram_wr_addr'range);
	signal direct_vram_wr_data : std_ulogic_vector(vram_wr_data'range);
	signal direct_vram_wr_access_mode : sram_access_mode_t;

	-- pixel reader interface signals
	signal pr_start : std_ulogic;
	signal pr_section : bitmap_section_t;
	signal pr_color : color_t;
	signal pr_color_valid : std_ulogic;
	signal pr_color_ack : std_ulogic;

	signal pr_vram_rd_addr : std_ulogic_vector(vram_wr_addr'range);
	signal pr_vram_rd : std_ulogic;
	signal pr_vram_rd_access_mode : sram_access_mode_t;

	-- gfx_circle interface signals
	signal circle_start, circle_busy, circle_pixel_valid : std_ulogic;
	signal circle_pixel : vec2d_s16_t;

	subtype addrlo_t is std_ulogic_vector(15 downto 0);
	subtype addrhi_t is std_ulogic_vector(VRAM_ADDR_WIDTH-16-1 downto 0);
	signal instr_color : color_t; -- signal created combinationally from state.pcol/scol and current_instr

	-- IMPORTANT:
	-- These signals are used by the FSM for the command execution
	-- The individual states list the signals they expect to be set when the state is entered.
	-- Make sure you set them to the currect values, and keep them stable (i.e., don't change them) until the FSM returns to the IDLE state.
	signal current_instr : gfx_cmd_t;        -- the instruction of the command currently beeing executed
	signal bdt_bmpidx    : bd_t;             -- the actual bitmap descriptor referenced by the bmpidx field in BB_* and DISPLAY_BMP commands
	signal dx, dy        : s16_t;            -- the x/y displacement used by the DRAW_H/VLINE commands
	signal radius        : u15_t;            -- the radius used by the DRAW_CIRCLE command
	signal bb_section    : bitmap_section_t; -- the source bitmap section used by BB_* commands
	signal addrlo        : addrlo_t;         -- the 16 low bits of the address specified in VRAM_* commands
	signal addrhi        : addrhi_t;         -- the 5 high bits of the address specified in VRAM_* commands
	signal data          : gfx_cmd_t;        -- the data word specified in VRAM_WRITE and VRAM_WRITE_INIT commands
	signal n             : u16_t;            -- the operand n specified by VRAM_WRITE_INIT/SEQ commands
begin


	rd_data <= state.vram_rd_data;
	fr_base_addr <= state.fr_base_addr;

	process(all)
	begin
		if (current_instr(INDEX_CS) = CS_PRIMARY) then
			instr_color <= state.pcol;
		else
			instr_color <= state.scol;
		end if;
	end process;

	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			state <= CNTRL_STATE_RESET;
		elsif (rising_edge(clk)) then
			state <= state_nxt;
		end if;
	end process;

	next_state : process(all)

		--the write pixel function returns false in the case a write could not be performed in the current cycle because the pixel_writer asserted the stall signal
		impure function write_pixel(x,y : signed(15 downto 0); color : color_t; alpha_mode : std_ulogic := '0') return boolean is
		begin
			pw_alpha_mode <= alpha_mode;
			pw_position.x <= x;
			pw_position.y <= y;
			pw_color <= color;
			if stall = '0' then
				pw_wr <= '1';
				return true;
			end if;
			return false;
		end function;

		impure function write_pixel(vec : vec2d_s16_t; color : color_t; alpha_mode : std_ulogic := '0') return boolean is
		begin
			pw_alpha_mode <= alpha_mode;
			pw_position <= vec;
			pw_color <= color;
			if stall = '0' then
				pw_wr <= '1';
				return true;
			end if;
			return false;
		end function;

		procedure proc_bb_start is
		begin
			pr_start <= '1';
			state_nxt.tmp_vec.x <= (others=>'0');
			state_nxt.tmp_vec.y <= (others=>'0');
			state_nxt.fsm_state <= BB_LOOP;
		end procedure;

		procedure proc_bb_loop is
			variable rot : rot_t;
			variable bb_offset_x, bb_offset_y, tmp_x, tmp_y : s16_t;
		begin
			rot := get_rot(current_instr);

			-- connect the pixel reader to the vram interface while in this state
			vram_rd <= pr_vram_rd;
			vram_rd_addr <= pr_vram_rd_addr;
			vram_rd_access_mode <= pr_vram_rd_access_mode;

			-- it is safe to consider state.x_tmp/y_tmp as signed here because in this state/loop
			-- the MSB will always be zero
			bb_offset_x := state.tmp_vec.x;
			bb_offset_y := state.tmp_vec.y;

			if (rot = ROT_R180 or rot = ROT_R270) then
				bb_offset_x := signed('0' & bb_section.w) - state.tmp_vec.x - 1;
			end if;
			if (rot = ROT_R90 or rot = ROT_R180) then
				bb_offset_y := signed('0' & bb_section.h) - state.tmp_vec.y - 1;
			end if;

			-- switch x any y offset if necessary
			if (rot = ROT_R90 or rot= ROT_R270) then
				tmp_x := state.gp.x + bb_offset_y;
				tmp_y := state.gp.y + bb_offset_x;
			else
				tmp_x := state.gp.x + bb_offset_x;
				tmp_y := state.gp.y + bb_offset_y;
			end if;

			if pr_color_valid = '1' then
				if write_pixel(tmp_x, tmp_y, apply_bb_effect(pr_color, state.bb_effect), current_instr(INDEX_AM)) then
					pr_color_ack <= '1';

					if (unsigned(state.tmp_vec.x) = bb_section.w - 1) then
						state_nxt.tmp_vec.x <= (others=>'0');
						if (unsigned(state.tmp_vec.y) = bb_section.h - 1) then
							state_nxt.fsm_state <= BB_COMPLETE;
						else
							state_nxt.tmp_vec.y <= state.tmp_vec.y + 1;
						end if;
					else
						state_nxt.tmp_vec.x <= state.tmp_vec.x + 1;
					end if;
				end if;
			end if;
		end procedure;

		procedure proc_bb_complete is
			variable rot : rot_t;
		begin
			rot := get_rot(current_instr);

			if (current_instr(INDEX_MX)) then
				if (rot = ROT_R90 or rot = ROT_R270) then
					state_nxt.gp.x <= state.gp.x + signed('0' & bb_section.h);
				else
					state_nxt.gp.x <= state.gp.x + signed('0' & bb_section.w);
				end if;
			end if;

			if (current_instr(INDEX_MY)) then
				if (rot = ROT_R90 or rot= ROT_R270) then
					state_nxt.gp.y <= state.gp.y + signed('0' & bb_section.w);
				else
					state_nxt.gp.y <= state.gp.y + signed('0' & bb_section.h);
				end if;
			end if;

			state_nxt.fsm_state <= IDLE;
		end procedure;

	begin

		state_nxt <= state;

		-- pixel writer default assignments
		pw_wr <= '0';
		pw_color <= (others => '0');
		pw_position <= VEC2D_S16_ZERO;
		pw_alpha_mode <= '0';

		-- pixel reader default assignments
		pr_start <= '0';
		pr_color_ack <= '0';

		-- output control flags
		gcf_rd <= '0';
		frame_sync <= '0';
		rd_valid <= '0';

		direct_vram_wr_addr <= (others=>'0');
		direct_vram_wr_data <= (others=>'0');
		direct_vram_wr <= '0';
		direct_vram_wr_access_mode <= WORD;

		circle_start <= '0';

		vram_rd <= '0';
		vram_rd_addr <= pw_vram_wr_addr;
		vram_rd_access_mode <= BYTE;


		case state.fsm_state is
			when IDLE =>
			-- requires: current_instr, bdt_bmpidx
			when DISPLAY_BMP =>
				if (current_instr(INDEX_FS) = '1') then
					if (fr_base_addr_req = '1') then
						frame_sync <= '1';
						state_nxt.fr_base_addr <= std_ulogic_vector(resize(unsigned(bdt_bmpidx.b), VRAM_ADDR_WIDTH));
						state_nxt.fsm_state <= IDLE;
					end if;
				else
					state_nxt.fr_base_addr <= std_ulogic_vector(resize(unsigned(bdt_bmpidx.b), VRAM_ADDR_WIDTH));
					state_nxt.fsm_state <= IDLE;
				end if;

			-- requires: current_instr
			when CLEAR =>
				state_nxt.tmp_vec <= VEC2D_S16_ZERO;
				state_nxt.fsm_state <= CLEAR_LOOP;

			when CLEAR_LOOP =>
				if write_pixel(state.tmp_vec, instr_color) then
					if (unsigned(state.tmp_vec.x) = state.abd.w - 1) then
						state_nxt.tmp_vec.x <= (others=>'0');
						if (unsigned(state.tmp_vec.y) = state.abd.h - 1) then
							state_nxt.fsm_state <= IDLE;
						else
							state_nxt.tmp_vec.y <= state.tmp_vec.y + 1;
						end if;
					else
						state_nxt.tmp_vec.x <= state.tmp_vec.x + 1;
					end if;
				end if;

			-- requires: current_instr, dx
			when DRAW_HLINE =>
				state_nxt.tmp_vec.x <= state.gp.x;
				state_nxt.fsm_state <= DRAW_HLINE_LOOP;

			when DRAW_HLINE_LOOP =>
				if (state.tmp_vec.x = state.gp.x + dx) then
					state_nxt.fsm_state <= IDLE;
					if (current_instr(INDEX_MX) = '1') then
						state_nxt.gp.x <= state.gp.x + dx;
					end if;
					if (current_instr(INDEX_MY) = '1') then
						state_nxt.gp.y <= state.gp.y + 1;
					end if;
				else
					if write_pixel(state.tmp_vec.x, state.gp.y, instr_color) then
						if (dx < 0) then
							state_nxt.tmp_vec.x <= state.tmp_vec.x - 1;
						else
							state_nxt.tmp_vec.x <= state.tmp_vec.x + 1;
						end if;
					end if;
				end if;

			-- requires: current_instr, dy
			when DRAW_VLINE =>
				state_nxt.tmp_vec.y <= state.gp.y;
				state_nxt.fsm_state <= DRAW_VLINE_LOOP;

			when DRAW_VLINE_LOOP =>
				if (state.tmp_vec.y = state.gp.y + dy) then
					state_nxt.fsm_state <= IDLE;
					if (current_instr(INDEX_MX) = '1') then
						state_nxt.gp.x <= state.gp.x + 1;
					end if;
					if (current_instr(INDEX_MY) = '1') then
						state_nxt.gp.y <= state.gp.y + dy;
					end if;
				else
					if write_pixel(state.gp.x, state.tmp_vec.y, instr_color) then
						if (dy < 0) then
							state_nxt.tmp_vec.y <= state.tmp_vec.y - 1;
						else
							state_nxt.tmp_vec.y <= state.tmp_vec.y + 1;
						end if;
					end if;
				end if;

			-- requries: current_instr, radius
			when DRAW_CIRCLE =>
				if (stall = '0') then
					circle_start <= '1';
					state_nxt.fsm_state <= DRAW_CIRCLE_WAIT;
				end if;

			when DRAW_CIRCLE_WAIT =>
				if circle_pixel_valid = '1' then
					if write_pixel(circle_pixel, instr_color) then
						null;
					end if;
				end if;

				if (circle_busy = '0') then
					if (current_instr(INDEX_MX) = '1') then
						state_nxt.gp.x <= state.gp.x + signed('0' & radius);
					end if;
					if (current_instr(INDEX_MY) = '1') then
						state_nxt.gp.y <= state.gp.y + signed('0' & radius);
					end if;
					state_nxt.fsm_state <= IDLE;
				end if;

			-- requires: current_instr, bb_section, bdt_bmpidx
			when BB_START => proc_bb_start;
			when BB_LOOP => proc_bb_loop;
			when BB_COMPLETE => proc_bb_complete;

			-- requires: current_instr, addrhi, addrlo, data
			when VRAM_WRITE =>
				if (vram_wr_full = '0') then
					direct_vram_wr <= '1';
					direct_vram_wr_addr <= addrhi & addrlo;
					direct_vram_wr_data <= data;
					direct_vram_wr_access_mode <= BYTE;
					if (current_instr(INDEX_M) = M_WORD) then
						direct_vram_wr_access_mode <= WORD;
					end if;
					state_nxt.fsm_state <= IDLE;
				end if;

			-- requires: current_instr, addrhi, addrlo, n
			-- IMPORTANT: when this state is entered the next item in the graphics command FIFO must be data[0]
			-- The state and it successors will read all the required data words out of the command FIFO.
			when VRAM_WRITE_SEQ =>
				state_nxt.vram_addr_buffer <= addrhi & addrlo;
				state_nxt.write_cnt <= n;
				state_nxt.fsm_state <= VRAM_WRITE_LOOP_LOAD_OPERAND;

			-- requires: current_instr, addrhi, addrlo, n, data
			when VRAM_WRITE_INIT =>
				state_nxt.vram_addr_buffer <= addrhi & addrlo;
				state_nxt.write_cnt <= n;
				state_nxt.fsm_state <= VRAM_WRITE_LOOP_LOAD_OPERAND;

			when VRAM_WRITE_LOOP_LOAD_OPERAND =>
				-- for VRAM_WRITE_SEQ, data must be in the FIFO to proceed
				if (gcf_empty = '0' or get_opcode(current_instr) = OPCODE_VRAM_WRITE_INIT) then
					-- this state is also used by the VRAM_WRITE_INIT command, where the same
					-- value is written to all memory locations, hence no need to read new operands.
					if (get_opcode(current_instr) = OPCODE_VRAM_WRITE_SEQ) then
						gcf_rd <= '1';
					end if;
					state_nxt.write_cnt <= state.write_cnt - 1;
					state_nxt.fsm_state <= VRAM_WRITE_LOOP_WRITE;
				end if;

			when VRAM_WRITE_LOOP_WRITE =>
				direct_vram_wr_addr <= state.vram_addr_buffer;
				if get_opcode(current_instr) = OPCODE_VRAM_WRITE_SEQ then
					direct_vram_wr_data <= gcf_data;
				else
					direct_vram_wr_data <= data;
				end if;
				if (vram_wr_full = '0') then
					direct_vram_wr <= '1';
					if (current_instr(INDEX_M) = M_WORD) then
						direct_vram_wr_access_mode <= WORD;
						state_nxt.vram_addr_buffer <= std_ulogic_vector(unsigned(state.vram_addr_buffer) + 2);
					else
						direct_vram_wr_access_mode <= BYTE;
						state_nxt.vram_addr_buffer <= std_ulogic_vector(unsigned(state.vram_addr_buffer) + 1);
					end if;

					if (state.write_cnt = 0) then
						state_nxt.fsm_state <= IDLE;
					else
						state_nxt.fsm_state <= VRAM_WRITE_LOOP_LOAD_OPERAND;
					end if;
				end if;

			-- requires: current_instr, addrhi, addrlo
			when VRAM_READ =>
				state_nxt.fsm_state <= WAIT_VRAM_READ1;
				vram_rd_addr <= addrhi & addrlo;
				if (current_instr(INDEX_M) = M_WORD) then
					vram_rd_access_mode <= WORD;
				else
					vram_rd_access_mode <= BYTE;
				end if;
				-- wait for all writes to complete to avoid memory inconsistencies
				if (vram_wr_emtpy = '1') then
					vram_rd <= '1';
				end if;

			when WAIT_VRAM_READ1 =>
				if (vram_rd_valid = '1') then
					state_nxt.vram_rd_data <= vram_rd_data;
					state_nxt.fsm_state <= WAIT_VRAM_READ2;
				end if;

			when WAIT_VRAM_READ2 =>
				rd_valid <= '1';
				state_nxt.fsm_state <= IDLE;

			--requires: current_instr
			when GET_PIXEL =>
				state_nxt.fsm_state <= GET_PIXEL1;
				-- we use the pixel writer to calculate the effective read address in VRAM and check if the gp is out-of-bounds
				pw_position <= state.gp;

			when GET_PIXEL1 =>
				state_nxt.fsm_state <= GET_PIXEL2;
				pw_position <= state.gp;

			when GET_PIXEL2 =>
				pw_position <= state.gp;

				-- at this point pw_oob and pw_vram_wr_addr are valid
				if (pw_oob = '0') then -- out-of-bounds check
					-- wait for all writes to complete to avoid memory inconsistencies
					if (vram_wr_emtpy = '1') then
						vram_rd <= '1';
						vram_rd_addr <= pw_vram_wr_addr;
						state_nxt.fsm_state <= GET_PIXEL_WAIT_VRAM_READ;
					end if;
				else
					state_nxt.vram_rd_data <= (others=>'1');
					state_nxt.fsm_state <= GET_PIXEL_DONE;
				end if;

			when GET_PIXEL_WAIT_VRAM_READ =>
				pw_position <= state.gp;
				if (vram_rd_valid = '1') then
					state_nxt.vram_rd_data <= vram_rd_data;
					state_nxt.fsm_state <= GET_PIXEL_DONE;
				end if;

			when GET_PIXEL_DONE =>
				rd_valid <= '1';
				state_nxt.fsm_state <= IDLE;
				if (current_instr(INDEX_MX) = '1') then
					state_nxt.gp.x <= state.gp.x + 1;
				end if;
				if (current_instr(INDEX_MY) = '1') then
					state_nxt.gp.y <= state.gp.y + 1;
				end if;

			when others => null;
		end case;
	end process;

	vram_wr_access_control : process(all)
	begin
		vram_wr_addr <= (others=>'0');
		vram_wr_data <= (others=>'0');
		vram_wr <= '0';
		vram_wr_access_mode <= WORD;
		if (direct_vram_wr = '1') then
			vram_wr <= '1';
			vram_wr_addr <= direct_vram_wr_addr;
			vram_wr_data <= direct_vram_wr_data;
			vram_wr_access_mode <= direct_vram_wr_access_mode;
		elsif (pw_vram_wr = '1') then
			vram_wr <= '1';
			vram_wr_addr <= pw_vram_wr_addr;
			vram_wr_data <= pw_vram_wr_data;
			vram_wr_access_mode <= pw_vram_wr_access_mode;
		end if;
	end process;

	gfx_circle_inst : entity work.gfx_circle
	port map (
		clk => clk,
		res_n => res_n,
		start => circle_start,
		stall => stall,
		busy => circle_busy,
		center => state.gp,
		radius => radius,
		pixel_valid => circle_pixel_valid,
		pixel => circle_pixel
	);

	pw : entity work.pixel_writer
	generic map (
		VRAM_ADDR_WIDTH => VRAM_ADDR_WIDTH,
		VRAM_DATA_WIDTH => VRAM_DATA_WIDTH
	)
	port map (
		clk => clk,
		res_n => res_n,
		stall => stall,
		wr_in_progress => open,
		bd => state.abd,
		wr => pw_wr,
		position => pw_position,
		color => pw_color,
		alpha_color => apply_bb_effect(state.scol, state.bb_effect),
		alpha_mode => pw_alpha_mode,
		oob => pw_oob,
		vram_wr_addr => pw_vram_wr_addr,
		vram_wr_data => pw_vram_wr_data,
		vram_wr_full => vram_wr_full,
		vram_wr => pw_vram_wr,
		vram_wr_access_mode => pw_vram_wr_access_mode
	);

	pr : entity work.pixel_reader
	generic map (
		VRAM_ADDR_WIDTH => VRAM_ADDR_WIDTH,
		VRAM_DATA_WIDTH => VRAM_DATA_WIDTH
	)
	port map (
		clk => clk,
		res_n => res_n,

		start => pr_start,
		bd => bdt_bmpidx,
		section => bb_section,

		color => pr_color,
		color_valid => pr_color_valid,
		color_ack => pr_color_ack,

		vram_rd_addr => pr_vram_rd_addr,
		vram_rd_data => vram_rd_data,
		vram_rd_busy => vram_rd_busy,
		vram_rd => pr_vram_rd,
		vram_rd_valid => vram_rd_valid,
		vram_rd_access_mode => pr_vram_rd_access_mode
	);
end architecture;
