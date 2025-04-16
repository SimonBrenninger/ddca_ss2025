
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.mem_pkg.all;

entity fifo_1c1r1w_fwft is
	generic (
		DEPTH      : positive;
		DATA_WIDTH : positive
	);
	port (
		clk       : in  std_ulogic;
		res_n     : in  std_ulogic;

		rd_data   : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
		rd_ack    : in  std_ulogic;
		rd_valid  : out std_ulogic;

		wr_data   : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
		wr        : in  std_ulogic;
		full      : out std_ulogic;
		half_full : out std_ulogic
	);
end entity;


architecture arch of fifo_1c1r1w_fwft is
	signal rd, empty, not_empty : std_ulogic;
begin

	fifo_inst : fifo_1c1r1w
	generic map (
		DEPTH      => DEPTH,
		DATA_WIDTH => DATA_WIDTH
	)
	port map (
		clk        => clk,
		res_n      => res_n,
		rd_data    => rd_data,
		rd         => rd,
		wr_data    => wr_data,
		wr         => wr,
		empty      => empty,
		full       => full,
		half_full  => half_full
	);

	not_empty <= not empty;
	rd <= (rd_ack and not_empty) or (not_empty and not rd_valid);
	
	sync : process(clk, res_n)
	begin
		if (res_n = '0') then
			rd_valid <= '0';
		elsif (rising_edge(clk)) then
			if (rd = '1' or rd_ack='1') then
				rd_valid <= not_empty;
			end if;
		end if;
	end process;

end architecture;


