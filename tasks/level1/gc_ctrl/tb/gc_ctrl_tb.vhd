library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gc_ctrl_pkg.all;
use work.tb_util_pkg.all;

entity gc_ctrl_tb is
end entity;

architecture bench of gc_ctrl_tb is
	constant CLK_PERIOD : time := 20 ns;
	signal clk, res_n   : std_ulogic := '0';
	signal stop_clock   : boolean := false;

	signal gc_data    : std_logic;
	signal rumble     : std_ulogic;
	signal ctrl_state : gc_ctrl_state_t;

	shared variable rnd : random_t;
begin

	uut : entity work.gc_ctrl
	port map (
		clk        => clk,
		res_n      => res_n,
		data       => gc_data,
		ctrl_state => ctrl_state,
		rumble     => rumble
	);

	-- Stimulus process
	stimulus: process

		procedure send_gc_cntrl_state (data : gc_ctrl_state_t) is
		begin
			-- this procedure simulates the response of the actual controller
			-- only set gc_data to either '0' or 'Z'
			-- TODO: Implement
		end procedure;
		procedure read_polling_command (data : out std_ulogic_vector) is
		begin
			-- this is procedure is used to read the polling command produced by the UUT
			-- the first thing this procedure need to do is what for gc_data to become '0'
			-- TODO: Implement
		end procedure;

			variable gc_ctrl_state : gc_ctrl_state_t;
	begin
		res_n         <= '0';
		rumble        <= '0';
		gc_ctrl_state := GC_CTRL_STATE_RESET_VALUE;
		-- this process also drives gc_data
		gc_data <= 'Z';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';
		wait until rising_edge(clk);


		gc_ctrl_state := to_gc_ctrl_state(rnd.gen_sulv_01(64)); --generate random test data
		report to_string(gc_ctrl_state);

		-- TODO: use read_polling_command to check if the polling command is correctly applied
		-- TODO: use send_gc_ctrl_state to send a random gc_ctrl state and check that ctrl_state is correctly set

		stop_clock <= true;
		report "Testbench done";
		wait;
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


