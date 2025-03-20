

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.gfx_util_pkg.all;
use work.gfx_core_pkg.all;
use work.sram_ctrl_pkg.all;

entity pixel_writer is
	generic (
		VRAM_ADDR_WIDTH : integer := 20;
		VRAM_DATA_WIDTH : integer := 16
	);
	port(
		clk      : in std_ulogic;
		res_n    : in std_ulogic;

		-- back pressure signals
		wr_in_progress : out std_logic;
		stall          : out std_ulogic;
		
		-- pixel informaiton
		wr          : in std_logic;
		bd          : in bd_t;
		color       : in color_t;
		position    : in vec2d_s16_t;
		alpha_mode  : in std_ulogic;
		alpha_color : in color_t;

		-- auxilary signals
		oob : out std_ulogic; -- inidcates whether position is out-of-bounds

		-- VRAM write interface
		vram_wr_addr        : out std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		vram_wr_data        : out std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
		vram_wr_full        : in  std_ulogic;
		vram_wr             : out std_ulogic;
		vram_wr_access_mode : out sram_access_mode_t
	);
end entity;

architecture arch of pixel_writer is

		type s1_t is record
			valid       : std_ulogic;
			bd          : bd_t;
			color       : color_t;
			y           : std_ulogic_vector(position.y'range);
			x           : std_ulogic_vector(position.x'range);
			alpha_mode  : std_ulogic;
			alpha_color : color_t;
		end record;

		type s2_t is record
			vram_wr : std_ulogic;
			vram_addr : std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
			vram_data : std_ulogic_vector(7 downto 0);
		end record;

		signal s1 : s1_t;
		signal s2, s2_nxt : s2_t;
begin

	wr_in_progress <= s1.valid or s2.vram_wr;
	stall <= vram_wr_full;

	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			s1 <= (
				valid => '0',
				alpha_mode => '0',
				bd => BD_ZERO,
				x => (others => '0'),
				y => (others => '0'),
				color => (others => '0'),
				alpha_color => (others => '0')
			);
			s2 <= (
				vram_wr => '0',
				others=>(others=>'0')
			);
		elsif (rising_edge(clk)) then
			if (vram_wr_full = '0') then
				s1.valid <= wr;
				s1.bd <= bd;
				s1.color <= color;
				s1.y <= std_ulogic_vector(position.y);
				s1.x <= std_ulogic_vector(position.x);
				s1.alpha_mode <= alpha_mode;
				s1.alpha_color <= alpha_color;
				s2 <= s2_nxt;
			end if;
		end if;
	end process;

	s2_comb : process(all)
	begin
		s2_nxt.vram_wr <= s1.valid;
		oob <= '0';

		-- out-of-bounds?
		if not (signed(s1.x) >= 0 and signed(s1.x) < signed('0' & s1.bd.w) and
			signed(s1.y) >= 0 and signed(s1.y) < signed('0' & s1.bd.h)) then
			s2_nxt.vram_wr <= '0';
			oob <= '1';
		end if;

		-- alpha mode
		if (s1.alpha_mode = '1' and s1.color = s1.alpha_color) then
			s2_nxt.vram_wr <= '0';
		end if;

		s2_nxt.vram_addr <= std_ulogic_vector(resize(
			unsigned(s1.bd.b) + unsigned(s1.x) + unsigned(s1.bd.w) * unsigned(s1.y), vram_wr_addr'length));
		s2_nxt.vram_data <= s1.color;
	end process;

	process(all)
	begin
		vram_wr_data <= (others => '0');
		vram_wr_data(7 downto 0) <= s2.vram_data;
		vram_wr_addr <= s2.vram_addr;
		vram_wr <= s2.vram_wr;
		vram_wr_access_mode <= BYTE;
	end process;

end architecture;
