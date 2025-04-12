library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_sys_pkg.all;

entity delay is
	generic (
		CYCLES : natural := 8
	);
	port (
		clk    : in std_ulogic;
		res_n  : in std_ulogic;

		-- master interface
		mem_out_m  : in  mem_out_t;
		mem_in_m   : out mem_in_t;

		-- slave interface
		mem_out_s  : out mem_out_t;
		mem_in_s   : in  mem_in_t
	);
end entity;

architecture impl of delay is
	signal cnt : natural range 0 to CYCLES;
	signal data : mem_data_t;
	signal read : boolean;

begin
	gen : if CYCLES = 0 generate
		mem_out_s <= mem_out_m;
		mem_in_m <= mem_in_s;
	else generate
		sync : process(clk, res_n)
		begin
			if res_n = '0' then
				data <= (others => '0');
				cnt <= 0;
				read <= false;
			elsif rising_edge(clk) then
				if mem_out_m.rd = '1' then
					cnt <= CYCLES;
					read <= true;
				elsif cnt /= 0 then
					cnt <= cnt - 1;
					read <= false;
				end if;

				if read then
					data <= mem_in_s.rddata;
				end if;
			end if;
		end process;

		io : process(all)
		begin
			mem_out_s <= mem_out_m;

			if cnt = 0 then
				mem_in_m.busy <= '0';
				mem_in_m.rddata <= data;
			else
				mem_in_m.busy <= '1';
				mem_in_m.rddata <= (others => '0');
			end if;
		end process;
	end generate;
end architecture;
