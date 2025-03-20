
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.mem_pkg.all;
use work.sram_ctrl_pkg.all;
use work.gfx_core_pkg.all;
use work.gfx_util_pkg.all;

entity pixel_reader is
	generic (
		VRAM_ADDR_WIDTH : integer := 20;
		VRAM_DATA_WIDTH : integer := 16
	);
	port (
		clk     : in  std_ulogic;
		res_n   : in  std_ulogic;

		start : in std_ulogic;
		bd : in bd_t;
		section : in bitmap_section_t;

		color : out color_t;
		color_valid : out std_ulogic;
		color_ack : in std_ulogic;

		-- VRAM read interface
		vram_rd_addr        : out std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		vram_rd_data        : in  std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
		vram_rd_busy        : in  std_ulogic;
		vram_rd             : out std_ulogic;
		vram_rd_valid       : in std_ulogic;
		vram_rd_access_mode : out sram_access_mode_t
	);
end entity;


architecture arch of pixel_reader is

	constant PIXEL_BUFFER_DEPTH : positive := 8;

	type fsm_state_t is (
		IDLE,
		WAIT_COMPLETE,
		CALCULATE_ADDRESS,
		ISSUE_MEMORY_READ
	);
	type state_t is record
		fsm_state : fsm_state_t;
		x, y : u15_t;
		address : std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		counter : unsigned(log2c(PIXEL_BUFFER_DEPTH)-1 downto 0);
	end record;

	signal state, state_nxt : state_t;
	signal pixbuf_half_full : std_ulogic;
	signal fifo_wr : std_ulogic;

begin
	
	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			state <= (
				fsm_state => IDLE,
				address => (others => '0'),
				counter => (others => '0'),
				others=>(others=>'0')
			);
		elsif (rising_edge(clk)) then
			state <= state_nxt;
		end if;
	end process;

		process (all)
		begin
			state_nxt <= state;

			vram_rd <= '0';
			vram_rd_addr <= state.address;
			vram_rd_access_mode <= BYTE;

			case state.fsm_state is
				when IDLE =>
					if (start = '1') then
						state_nxt.x <= section.x;
						state_nxt.y <= section.y;
						state_nxt.fsm_state <= CALCULATE_ADDRESS;
					end if;
				when CALCULATE_ADDRESS =>
					state_nxt.address <= std_ulogic_vector(resize(unsigned(bd.b) + state.x + state.y * bd.w, VRAM_ADDR_WIDTH));
					if (pixbuf_half_full = '0') then
						state_nxt.fsm_state <= ISSUE_MEMORY_READ;
					end if;
				when ISSUE_MEMORY_READ =>
					if vram_rd_busy = '0' then
						vram_rd <= '1';
						state_nxt.fsm_state <= CALCULATE_ADDRESS;

						if (state.x = section.x + section.w-1) then
							state_nxt.x <= section.x;
							if (state.y = section.y + section.h-1) then
								state_nxt.fsm_state <= WAIT_COMPLETE;
							else
								state_nxt.y <= state.y + 1;
							end if;
						else
							state_nxt.x <= state.x + 1;
						end if;
					end if;
				when WAIT_COMPLETE =>
					if state.counter = 0 then
						state_nxt.fsm_state <= IDLE;
					end if;
			end case;

			if state.fsm_state /= IDLE then
				if vram_rd = '1' and vram_rd_valid = '0' then
					state_nxt.counter <= state.counter + 1;
				elsif vram_rd = '0' and vram_rd_valid = '1' then
					state_nxt.counter <= state.counter - 1;
				end if;
			end if;
		end process;

		fifo_wr <= '1' when vram_rd_valid = '1' and state.fsm_state /= IDLE else '0';

		pixel_buffer : fifo_1c1r1w_fwft
		generic map (
			DEPTH      => PIXEL_BUFFER_DEPTH,
			DATA_WIDTH => 8
		)
		port map (
			clk       => clk,
			res_n     => res_n,
			rd_data   => color,
			rd_ack    => color_ack,
			rd_valid  => color_valid,
			wr_data   => vram_rd_data(7 downto 0),
			wr        => fifo_wr,
			full      => open,
			half_full => pixbuf_half_full
		);

end architecture;
