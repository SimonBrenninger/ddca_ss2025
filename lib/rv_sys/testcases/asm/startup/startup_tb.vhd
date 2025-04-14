library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std; -- for Printing
use std.env.all;
use std.textio.all;

use work.rv_sys_pkg.all;
use work.tb_util_pkg.all;

entity startup_tb is
	generic (
		TESTCASE_NAME : string;
		ELF_FILE : string
	);
end entity;

architecture arch of startup_tb is

	constant CLK_PERIOD : time := 20 ns;
	constant BAUD_RATE : integer := 115200;

	signal clk, res_n : std_logic;

	signal imem_in, dmem_in : mem_in_t;
	signal imem_out, dmem_out : mem_out_t;
	
	signal stop_clock : boolean := false;
begin

	rv_fsm_inst : entity work.rv
	port map(
		clk => clk,
		res_n => res_n,
		imem_out => imem_out,
		imem_in  => imem_in,
		dmem_out => dmem_out,
		dmem_in  => dmem_in
	);
	
	rv_sys_inst : entity work.rv_sys
	generic map (
		BAUD_RATE => BAUD_RATE,
		CLK_FREQ => 50_000_000,
		SIMULATE_ELF_FILE => ELF_FILE,
		GPIO_ADDR_WIDTH => 3
	)
	port map (
		clk => clk,
		res_n => res_n,

		cpu_reset_n => open,

		imem_out => imem_out,
		imem_in => imem_in,
		dmem_out => dmem_out,
		dmem_in => dmem_in,

		gp_out => open,
		gp_in => (others => (others => '0')),
		rx => '1',
		tx => open
	);

	main : process is
		variable error_counter : natural;
		procedure verify_dmem_write(addr : mem_address_t; data : mem_data_t; byteena : mem_byteena_t) is
		begin
			loop
				wait until rising_edge(clk);
				if dmem_out.wr = '1' then
					if not (dmem_out.address = addr and dmem_out.wrdata = data) then
						report "wrong memory operation" severity error;
						error_counter := error_counter + 1;
					end if;
					return;
				end if;
			end loop;
		end procedure;
	begin
		res_n <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';
		
		verify_dmem_write(std_ulogic_vector(to_unsigned(1, RV_SYS_ADDR_WIDTH)), x"01000000", "1111");
		verify_dmem_write(std_ulogic_vector(to_unsigned(2, RV_SYS_ADDR_WIDTH)), x"01000000", "1111");
		verify_dmem_write(std_ulogic_vector(to_unsigned(3, RV_SYS_ADDR_WIDTH)), x"01000000", "1111");

		wait for 4*CLK_PERIOD;
		stop_clock <= true;
		wait for CLK_PERIOD;

		tc_print_result(TESTCASE_NAME, error_counter = 0);
		wait;
	end process;

	tc_timeout(TESTCASE_NAME, CLK_PERIOD * 100, stop_clock);
	clk_gen(clk, CLK_PERIOD, stop_clock);

end architecture;
