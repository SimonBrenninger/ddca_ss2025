
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_sys_pkg.all;
use work.gfx_core_pkg.all;

entity mm_gci is
	port (
		clk     : in  std_ulogic;
		res_n   : in  std_ulogic;

		address : in  std_ulogic_vector(0 downto 0);
		wr      : in  std_ulogic;
		wr_data : in  mem_data_t;
		rd      : in  std_ulogic;
		rd_data : out mem_data_t;

		gci_in  : out gci_in_t;
		gci_out : in gci_out_t
	);
end entity;


architecture arch of mm_gci is
	signal addr_r : std_ulogic;
	signal rd_r : std_ulogic;
	signal rd_valid : std_ulogic;
	signal frame_sync : std_ulogic;
	signal rd_data_int : std_ulogic_vector(31 downto 0);
begin

	sync: process (clk, res_n)
	begin
		if res_n = '0' then
			addr_r <= '0';
			rd_valid <= '0';
			frame_sync <= '0';
		elsif rising_edge(clk) then
			addr_r <= address(0);
			rd_r <= rd;
			if gci_out.rd_valid = '1' then
				rd_valid <= '1';
			end if;
			if gci_out.frame_sync = '1' then
				frame_sync <= '1';
			end if;

			if rd_r = '1' and addr_r = '1' then
				rd_valid <= '0';
				frame_sync <= '0';
			end if;
		end if;
	end process;

	read: process (all)
	begin
		rd_data_int <= (others => '0');
		if addr_r = '0' then
			rd_data_int(31) <= gci_out.full;
		else
			rd_data_int(31) <= rd_valid;
			rd_data_int(30) <= frame_sync;
			rd_data_int(GFX_CMD_WIDTH-1 downto 0) <= gci_out.rd_data;
		end if;
	end process;

	write : process(all)
	begin
		gci_in.wr <= '0';
		gci_in.wr_data <= swap_endianness(wr_data)(GFX_CMD_WIDTH-1 downto 0);
		if wr = '1' then
			if address = "0" then
				gci_in.wr <= '1';
			end if;
		end if;
	end process;

	rd_data <= swap_endianness(rd_data_int);
end architecture;

