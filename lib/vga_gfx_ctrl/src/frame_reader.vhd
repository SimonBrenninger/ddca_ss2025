
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.mem_pkg.all;
use work.sram_ctrl_pkg.all;
use work.vga_ctrl_pkg.all;


entity frame_reader is
	generic (
		VRAM_ADDR_WIDTH : integer;
		VRAM_DATA_WIDTH : integer := 16;
		COLOR_DEPTH : integer := 8
	);
	port(
		clk : std_ulogic;
		res_n : std_ulogic;
	
		base_addr_req : out std_ulogic;
		base_addr : in std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
	
		-- read interface
		vram_rd_addr : out std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		vram_rd : out std_ulogic;
		vram_rd_access_mode : out sram_access_mode_t;
		vram_rd_busy : in std_ulogic;
		vram_rd_data : in std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
		vram_rd_valid : in std_ulogic;

		display_clk : in std_ulogic;
		display_res_n : in std_ulogic;

		--interface to VGA controller
		frame_start : in std_ulogic;
		pix_ack : in std_ulogic;
		pix_color : out vga_pixel_color_t
	);
begin
	assert VRAM_DATA_WIDTH = 16 report "Unsupported data width" severity failure;
	assert COLOR_DEPTH = 16 or COLOR_DEPTH = 8 report "Unsupported color depth" severity failure;
end entity;


architecture arch of frame_reader is

	signal pix_data : std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
	signal half_full : std_ulogic;
	signal rd_ack : std_ulogic;

	function get_width (cd : integer) return integer is
	begin
		if (cd = 8) then
			return 160;
		end if;
		return 320;
	end function;

	constant WIDTH : integer := get_width(COLOR_DEPTH);
	constant HEIGHT : integer := 240;

	type frame_reader_state_t is (WAIT_base_addr_req, READ_BASE_ADDR, BURST_START, BURST, WAIT_BURST_COMPLETE);
	signal state : frame_reader_state_t;
	signal state_nxt : frame_reader_state_t;

	signal x_cnt : std_ulogic_vector(log2c(WIDTH)-1 downto 0);
	signal x_cnt_nxt : std_ulogic_vector(log2c(WIDTH)-1 downto 0);

	signal y_cnt : std_ulogic_vector(log2c(2*HEIGHT-1)-1 downto 0);
	signal y_cnt_nxt : std_ulogic_vector(log2c(2*HEIGHT-1)-1 downto 0);

	signal cur_mem_pointer : std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
	signal cur_mem_pointer_nxt : std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
begin
	vram_rd_addr <= cur_mem_pointer;
	vram_rd_access_mode <= WORD;

	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			state <= WAIT_base_addr_req;
			cur_mem_pointer <= (others=>'0');
			x_cnt <= (others=>'0');
			y_cnt <= (others=>'0');
		elsif (rising_edge(clk)) then
			state <= state_nxt;
			cur_mem_pointer <= cur_mem_pointer_nxt;
			x_cnt <= x_cnt_nxt;
			y_cnt <= y_cnt_nxt;
		end if;
	end process;

	process(all)
	begin
		state_nxt <= state;
		cur_mem_pointer_nxt <= cur_mem_pointer;
		x_cnt_nxt <= x_cnt;
		y_cnt_nxt <= y_cnt;

		vram_rd <= '0';
		base_addr_req <= '0';

		case state is
			when WAIT_base_addr_req =>
				if (frame_start = '1') then
					base_addr_req <= '1';
					state_nxt <= READ_BASE_ADDR;
					x_cnt_nxt <= (others=>'0');
					y_cnt_nxt <= (others=>'0');
				end if;

			when READ_BASE_ADDR =>
				cur_mem_pointer_nxt <= base_addr;
				state_nxt <= BURST_START;

			when BURST_START =>
				if (vram_rd_busy = '0' and half_full = '0') then
					vram_rd <= '1';
					cur_mem_pointer_nxt <= std_ulogic_vector(unsigned(cur_mem_pointer) + 2);
					x_cnt_nxt <= std_ulogic_vector(unsigned(x_cnt) + 1);
					state_nxt <= BURST;
				end if;

			when BURST =>
				vram_rd <= '1';
				cur_mem_pointer_nxt <= std_ulogic_vector(unsigned(cur_mem_pointer) + 2);
				x_cnt_nxt <= std_ulogic_vector(unsigned(x_cnt) + 1);
				if (unsigned(x_cnt(1 downto 0)) = 3) then
					state_nxt <= WAIT_BURST_COMPLETE;
				end if;

			when WAIT_BURST_COMPLETE =>
				if (vram_rd_valid = '0') then
					state_nxt <= BURST_START;

					--do pointer management when line is complete
					if (unsigned(x_cnt) = WIDTH) then
						x_cnt_nxt <= (others=>'0');

						-- every line is read twice (upscaling)
						if (y_cnt(0) = '0') then
							cur_mem_pointer_nxt <= std_ulogic_vector(unsigned(cur_mem_pointer) - 2*WIDTH);
						end if;
						
						if unsigned(y_cnt) = 2*HEIGHT-1 then
							state_nxt <= WAIT_base_addr_req; --frame complete
						else
							y_cnt_nxt <= std_ulogic_vector(unsigned(y_cnt) + 1);
						end if;
					end if;
				end if;
		end case;
	end process;

	fifo_1c1r1w_fwft_inst : fifo_1c1r1w_fwft
	generic map (
		DEPTH      => 8,
		DATA_WIDTH => 16
	)
	port map (
		clk       => clk,
		res_n     => res_n,
		rd_data   => pix_data,
		rd_ack    => rd_ack,
		rd_valid  => open,
		wr_data   => vram_rd_data,
		wr        => vram_rd_valid,
		full      => open,
		half_full => half_full
	);

	COLOR_DEPTH_SELECTOR : if COLOR_DEPTH = 8 generate
		signal prev_pix_ack : std_ulogic_vector(3 downto 0);
		signal low_byte_complete : std_ulogic;
		signal pixel_complete : std_ulogic;
	begin

		process(all)
			variable c : std_ulogic_vector(7 downto 0);
		begin
			if (low_byte_complete) then
				c := pix_data(15 downto 8);
			else
				c := pix_data(7 downto 0);
			end if;

			pix_color <= rgb_332_to_vga_pixel_color(c);

		end process;

		count_pix_ack : process(clk, res_n)
		begin
			if (res_n = '0') then
				prev_pix_ack <= (others=>'0');
				low_byte_complete <= '0';
			elsif (rising_edge(clk)) then
				prev_pix_ack(0) <= pix_ack;
				prev_pix_ack(1) <= prev_pix_ack(0);
				prev_pix_ack(2) <= prev_pix_ack(1);
				if (pixel_complete = '1') then
					low_byte_complete <= not low_byte_complete;
					prev_pix_ack <= (others=>'0');
				end if;
			end if;
		end process;

		pixel_complete <= '1' when pix_ack = '1' and prev_pix_ack(2 downto 0) = "111" else '0';
		rd_ack <= '1' when low_byte_complete = '1' and pixel_complete = '1' else '0';
	elsif COLOR_DEPTH = 16 generate
		signal prev_pix_ack : std_ulogic_vector(2 downto 0);
	begin

		pix_color <= rgb_565_to_vga_pixel_color(pix_data);

		count_pix_ack : process(clk, res_n)
		begin
			if (res_n = '0') then
				prev_pix_ack <= (others=>'0');
			elsif (rising_edge(clk)) then
				prev_pix_ack(0) <= pix_ack;
				prev_pix_ack(1) <= prev_pix_ack(0);
				prev_pix_ack(2) <= prev_pix_ack(1);
				if(rd_ack = '1') then
					prev_pix_ack <= (others=>'0');
				end if;
			end if;
		end process;

		rd_ack <= '1' when pix_ack = '1' and (prev_pix_ack(2 downto 0) = "111") else '0';

	end generate;

end architecture;
