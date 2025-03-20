library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tetris_util_pkg.all;
use work.gfx_core_pkg.all;


entity tetromino_drawer is
	generic (
		BLOCK_SIZE : integer
	);
	port (
		clk : in std_ulogic;
		res_n : in std_ulogic;
		
		start : in std_ulogic;
		busy : out std_ulogic;
		
		x : signed(GFX_CMD_WIDTH-1 downto 0);
		y : signed(GFX_CMD_WIDTH-1 downto 0);
		tetromino : tetromino_t;
		rotation : rotation_t;
		bmpidx : bmpidx_t;
		
		-- interface to vga_gfx_ctrl
		gci_in : out gci_in_t;
		gci_out : in gci_out_t
	);
end entity;


architecture arch of tetromino_drawer is
	type fsm_state_t is (TD_IDLE, MOVE_GP, MOVE_GP_X, MOVE_GP_Y, BB, BB_ARG);
	type state_t is record
		fsm_state : fsm_state_t;
		block_coutner : std_ulogic_vector(3 downto 0);
		done : std_ulogic;
	end record;
	
	signal state, state_nxt : state_t;
begin
	sync : process(clk, res_n)
	begin
		if res_n = '0' then
			state <= (
				fsm_state => TD_IDLE,
				block_coutner => (others=>'0'),
				done => '0'
			);
		elsif rising_edge(clk) then
			state <= state_nxt;
		end if;
	end process;
	
	next_state : process(all)
	begin
		state_nxt <= state;
		busy <= '1';
		gci_in.wr <= '0';
		gci_in.wr_data <= (others=>'0');
		
		case state.fsm_state is
			when TD_IDLE =>
				busy <= '0';
				if (start = '1') then
					busy <= '1';
					state_nxt.fsm_state <= MOVE_GP;
					state_nxt.block_coutner <= (others=>'0');
					state_nxt.done <= '0';
				end if;
			
			when MOVE_GP =>
				if (state.done = '1') then
					state_nxt.fsm_state <= TD_IDLE;
					state_nxt.done <= '0';
				elsif (gci_out.full = '0') then
					--new line?
					if (state.block_coutner(1 downto 0) = "00") then
						state_nxt.fsm_state <= MOVE_GP_X;
						gci_in.wr_data <= create_gfx_instr(opcode=>OPCODE_MOVE_GP, rel=>'0');
						gci_in.wr <= '1';
					else
						state_nxt.fsm_state <= BB;
					end if;
				end if;
			
			when MOVE_GP_X =>
				if (gci_out.full = '0') then
					state_nxt.fsm_state <= MOVE_GP_Y;
					gci_in.wr <= '1';
					gci_in.wr_data <= std_ulogic_vector(resize(x, GFX_CMD_WIDTH));
				end if;
				
			when MOVE_GP_Y =>
				if (gci_out.full = '0') then
					state_nxt.fsm_state <= BB;
					gci_in.wr <= '1';
					if (unsigned(state.block_coutner) = 0) then
						gci_in.wr_data <= std_ulogic_vector(resize(y + BLOCK_SIZE*0, GFX_CMD_WIDTH));
					elsif (unsigned(state.block_coutner) = 4) then
						gci_in.wr_data <= std_ulogic_vector(resize(y + BLOCK_SIZE*1, GFX_CMD_WIDTH));
					elsif (unsigned(state.block_coutner) = 8) then
						gci_in.wr_data <= std_ulogic_vector(resize(y + BLOCK_SIZE*2, GFX_CMD_WIDTH));
					elsif (unsigned(state.block_coutner) = 12) then
						gci_in.wr_data <= std_ulogic_vector(resize(y + BLOCK_SIZE*3, GFX_CMD_WIDTH));
					end if;
				end if;
				
			when BB =>
				if (gci_out.full = '0') then
					if (unsigned(state.block_coutner) = 15) then
						state_nxt.done <= '1';
					else
						state_nxt.block_coutner <= std_ulogic_vector(unsigned(state.block_coutner) + 1);
					end if;
					
					if (is_tetromino_solid_at(tetromino, rotation, state.block_coutner(1 downto 0), state.block_coutner(3 downto 2))) then
						gci_in.wr <= '1';
						gci_in.wr_data <= create_gfx_instr(
							opcode => OPCODE_BB_CHAR,
							mx => '1',
							my => '0',
							rot => ROT_R0,
							bmpidx => bmpidx,
							am => '0'
						);
						state_nxt.fsm_state <= BB_ARG;
					else
						--draw nothing, just move the gp
						gci_in.wr <= '1';
						gci_in.wr_data <= create_gfx_instr(
							opcode => OPCODE_INC_GP,
							dir => DIR_X,
							incvalue => std_ulogic_vector(to_unsigned(BLOCK_SIZE, 10))
						);
						state_nxt.fsm_state <= MOVE_GP;
					end if;
				end if;
			
			when BB_ARG =>
				if (gci_out.full = '0') then
					state_nxt.fsm_state <= MOVE_GP;
					gci_in.wr <= '1';
					gci_in.wr_data <= create_bb_char_op(
						xoffset => std_ulogic_vector(resize(unsigned(tetromino)*to_unsigned(BLOCK_SIZE,10), 10)),
						charwidth => std_ulogic_vector(to_unsigned(BLOCK_SIZE, 6))
					);
				end if;
			
		end case;
	end process;
end architecture;
