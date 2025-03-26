library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.sram_ctrl_pkg.all;
use work.mem_pkg.all;


architecture arch of sram_ctrl is

	-- FSM state register
	type fsm_state_t is (IDLE, WRITE1, WRITE2);
	type state_reg_t is record
		state           : fsm_state_t;
		ub_n            : std_ulogic;
		lb_n            : std_ulogic;
		we_n            : std_ulogic;
		ce_n            : std_ulogic;
		oe_n            : std_ulogic;
		addr            : std_ulogic_vector(sram_addr'range);
		data_out        : std_ulogic_vector(sram_dq'range);
		-- TODO: Add further registers as required
	end record;

	constant STATE_REG_NULL : state_reg_t := (state => IDLE, addr => (others => '0'), data_out => (others => '0'), others => '1');

	signal s, s_nxt  : state_reg_t;
begin

	-- TODO: Correctly drive sram_dq (tri-state)
	sram_dq   <=  (others=>'Z');
	sram_addr <= s.addr;
	sram_ub_n <= s.ub_n;
	sram_lb_n <= s.lb_n;
	sram_we_n <= s.we_n;
	sram_ce_n <= s.ce_n;
	sram_oe_n <= s.oe_n;

	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			s <= STATE_REG_NULL;
		elsif (rising_edge(clk)) then
			s <= s_nxt;
		end if;
	end process;

	comb : process(all)
	begin
		s_nxt       <= STATE_REG_NULL;
		s_nxt.state <= s.state;

		-- TODO: Implement state machine next-state and output logic

	end process;

	-- TODO: Implement read port buffers

	-- TODO: Implement write port buffer

end architecture;

