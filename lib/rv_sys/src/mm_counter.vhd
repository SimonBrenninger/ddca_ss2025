library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_sys_pkg.all;

entity mm_counter is
	generic (
		CLK_FREQ : natural
	);
	port (
		clk   : in std_ulogic;
		res_n : in std_ulogic;
		value : out mem_data_t
	);
end entity;

architecture impl of mm_counter is
	constant CYCLE_PER_TICK : natural := CLK_FREQ / 1_000_000;
	signal val : unsigned(RV_SYS_DATA_WIDTH - 1 downto 0);
	signal cnt : natural range 0 to CYCLE_PER_TICK;
begin
	value <= swap_endianness(std_ulogic_vector(val));

	sync : process(clk, res_n)
	begin
		if res_n = '0' then
			val <= (others => '0');
			cnt <= 0;
		elsif rising_edge(clk) then
			if cnt = CYCLE_PER_TICK then
				cnt <= 0;
				val <= val + 1;
			else
				cnt <= cnt + 1;
			end if;
		end if;
	end process;
end architecture;
