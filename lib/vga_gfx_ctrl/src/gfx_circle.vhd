
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.gfx_util_pkg.all;


entity gfx_circle is
	port (
		clk : in std_ulogic;
		res_n : in std_ulogic;
		
		--control signals
		start : in std_ulogic;
		stall : in std_ulogic;
		busy : out std_ulogic;
		
		center : in vec2d_s16_t;
		radius : in u15_t;
		
		--pixel coordinates output
		pixel_valid : out std_ulogic;
		pixel : out vec2d_s16_t
	);
end entity;

architecture arch of gfx_circle is
	type fsm_state_t is (
		IDLE, INIT, CALC_POINT,
		PIXEL_INIT_0, PIXEL_INIT_1, PIXEL_INIT_2, PIXEL_INIT_3,
		PIXEL_0, PIXEL_1, PIXEL_2, PIXEL_3, PIXEL_4, PIXEL_5, PIXEL_6, PIXEL_7
	);
	
	type state_t is record
		fsm_state : fsm_state_t;
		f, ddF_x, ddF_y, x, y : integer;
	end record;
	
	signal state : state_t := (IDLE, others=>0);
	signal state_nxt : state_t;
begin

	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			state <= (IDLE, others=>0);
		elsif (rising_edge(clk)) then
			if (stall <= '0') then
				state <= state_nxt;
			end if;
		end if;
	end process;

	process(all)
	
		procedure set_pixel(x,y : integer; next_fsm_state : fsm_state_t) is
		begin
			pixel.x <= to_signed(x, 16);
			pixel.y <= to_signed(y, 16);
			pixel_valid <= '1';
			state_nxt.fsm_state <= next_fsm_state;
		end procedure;
		
		variable ddF_y, ddF_x, f : integer;
		variable radius_int, center_x_int, center_y_int : integer;
	begin
		radius_int := to_integer(radius);
		center_x_int := to_integer(center.x);
		center_y_int := to_integer(center.y);

		state_nxt <= state;
		pixel_valid <= '0';
		busy <= '1';
		
		pixel.x <= (others => '0');
		pixel.y <= (others => '0');
		
		ddF_x := state.ddF_x;
		ddF_y := state.ddF_y;
		f := state.f;

		case state.fsm_state is
			when IDLE =>
				busy <= '0';
				if (start = '1') then
					state_nxt.fsm_state <= INIT;
				end if;
			
			when INIT =>
				state_nxt.f <= 1 - radius_int;
				state_nxt.ddF_x <= 0;
				state_nxt.ddF_y <= -2 * radius_int;
				state_nxt.x <= 0;
				state_nxt.y <= radius_int;
				state_nxt.fsm_state <= PIXEL_INIT_0;
			
			when PIXEL_INIT_0 => set_pixel(center_x_int, center_y_int + radius_int, PIXEL_INIT_1);
			when PIXEL_INIT_1 => set_pixel(center_x_int, center_y_int - radius_int, PIXEL_INIT_2);
			when PIXEL_INIT_2 => set_pixel(center_x_int + radius_int, center_y_int, PIXEL_INIT_3);
			when PIXEL_INIT_3 => set_pixel(center_x_int - radius_int, center_y_int, CALC_POINT);
			
			when CALC_POINT =>
				if (state.x < state.y) then
					
					if (state.f >= 0) then
						state_nxt.y <= state.y - 1;
						ddF_y := ddF_y + 2;
						f := f + ddF_y;
					end if;
					state_nxt.x <= state.x + 1;
					ddF_x := ddF_x + 2;
					f := f + ddF_x + 1;
					
					state_nxt.ddF_x <= ddF_x;
					state_nxt.ddF_y <= ddF_y;
					state_nxt.f <= f;

					state_nxt.fsm_state <= PIXEL_0;
				else
					state_nxt.fsm_state <= IDLE;
				end if;
				
			when PIXEL_0 => set_pixel(center_x_int + state.x, center_y_int + state.y, PIXEL_1);
			when PIXEL_1 => set_pixel(center_x_int - state.x, center_y_int + state.y, PIXEL_2);
			when PIXEL_2 => set_pixel(center_x_int + state.x, center_y_int - state.y, PIXEL_3);
			when PIXEL_3 => set_pixel(center_x_int - state.x, center_y_int - state.y, PIXEL_4);
			when PIXEL_4 => set_pixel(center_x_int + state.y, center_y_int + state.x, PIXEL_5);
			when PIXEL_5 => set_pixel(center_x_int - state.y, center_y_int + state.x, PIXEL_6);
			when PIXEL_6 => set_pixel(center_x_int + state.y, center_y_int - state.x, PIXEL_7);
			when PIXEL_7 => set_pixel(center_x_int - state.y, center_y_int - state.x, CALC_POINT);
			
			when others => null;
		
		end case;
	
		if (stall = '1') then
			pixel_valid <= '0';
		end if;
	end process;

end architecture;
