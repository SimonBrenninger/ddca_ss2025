

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gfx_core_pkg.all;
use work.math_pkg.all;

entity decimal_printer is
	port (
		clk : in std_ulogic;
		res_n : in std_ulogic;
		
		-- interface to vga_gfx_ctrl
		gci_in : out gci_in_t;
		gci_out : in gci_out_t;
		
		-- control signals
		start : in std_ulogic;
		busy : out std_ulogic;
		number : in std_ulogic_vector(15 downto 0);
		bmpidx : in bmpidx_t;
		charwidth : in charwidth_t
	);
end entity;


architecture arch of decimal_printer is
	constant NUMBER_DIGITS : integer := log10c(2**number'length-1);
	type fsm_state_t is (IDLE, CALC_DIGITS, BB_CHAR, BB_CHAR_ARG, DIGIT_DONE);

	type bcd_data_t is array(NUMBER_DIGITS-1 downto 0) of std_ulogic_vector(3 downto 0);

	type state_t is record
		fsm_state : fsm_state_t;
		number : std_ulogic_vector(15 downto 0);
		bcd_data : bcd_data_t;
		digit_cnt : integer range 0 to NUMBER_DIGITS-1;
		busy : std_ulogic;
	end record;
	
	signal state, state_nxt : state_t;
begin
	
	busy <= state.busy;
	
	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			state <= (
				fsm_state => IDLE,
				number => (others=>'0'),
				bcd_data => (others=>(others=>'0')),
				digit_cnt => 0,
				busy => '0'
			);
		elsif (rising_edge(clk)) then
			state <= state_nxt;
		end if;
	end process;
	
	process(all)
	begin
		state_nxt <= state;
		
		gci_in.wr_data <= (others=>'0');
		gci_in.wr <= '0';
		
		case state.fsm_state is
			when IDLE =>
				state_nxt.number <= number;
				state_nxt.bcd_data <= (others=>(others=>'0'));
				state_nxt.digit_cnt <= 0;
				if (start = '1') then
					state_nxt.fsm_state <= CALC_DIGITS;
					state_nxt.busy <= '1';
				end if;
				
			when CALC_DIGITS =>
				if (unsigned(state.number) >= 10000 ) then
					state_nxt.bcd_data(4) <= std_ulogic_vector(unsigned(state.bcd_data(4)) + 1);
					state_nxt.number <= std_ulogic_vector(unsigned(state.number) - 10000);
				elsif (unsigned(state.number) >= 1000 ) then
					state_nxt.bcd_data(3) <= std_ulogic_vector(unsigned(state.bcd_data(3)) + 1);
					state_nxt.number <= std_ulogic_vector(unsigned(state.number) - 1000);
				elsif (unsigned(state.number) >= 100 ) then
					state_nxt.bcd_data(2) <= std_ulogic_vector(unsigned(state.bcd_data(2)) + 1);
					state_nxt.number <= std_ulogic_vector(unsigned(state.number) - 100);
				elsif (unsigned(state.number) >= 10 ) then
					state_nxt.bcd_data(1) <= std_ulogic_vector(unsigned(state.bcd_data(1)) + 1);
					state_nxt.number <= std_ulogic_vector(unsigned(state.number) - 10);
				else
					state_nxt.bcd_data(0) <= state.number(3 downto 0);
					state_nxt.fsm_state <= BB_CHAR;
				end if;
			
			when BB_CHAR =>
				if gci_out.full = '0' then
					gci_in.wr <= '1';
					gci_in.wr_data <= create_gfx_instr(opcode=>OPCODE_BB_CHAR, mx=>'1', bmpidx=>bmpidx);
					state_nxt.fsm_state <= BB_CHAR_ARG;
				end if;
			
			when BB_CHAR_ARG =>
				if gci_out.full = '0' then
					gci_in.wr <= '1';
					gci_in.wr_data <= create_bb_char_op(
						charwidth => charwidth,
						xoffset => std_ulogic_vector(resize(unsigned(state.bcd_data(NUMBER_DIGITS-1))*unsigned(charwidth), WIDTH_XOFFSET))
					);
					state_nxt.fsm_state <= DIGIT_DONE;
				end if;
			
			when DIGIT_DONE =>
				state_nxt.bcd_data(NUMBER_DIGITS-1 downto 1) <= state.bcd_data(NUMBER_DIGITS-2 downto 0);
				state_nxt.bcd_data(0) <= x"0";
				if (state.digit_cnt = NUMBER_DIGITS-1) then
					state_nxt.fsm_state <= IDLE;
					state_nxt.busy <= '0';
				else
					state_nxt.digit_cnt <= state.digit_cnt + 1;
					state_nxt.fsm_state <= BB_CHAR;
				end if;
			
			when others =>
				null;
		end case;
	end process;

end architecture;
