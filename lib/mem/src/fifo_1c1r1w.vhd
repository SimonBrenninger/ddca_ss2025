library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.mem_pkg.all;

entity fifo_1c1r1w is
	generic (
		DEPTH      : positive;
		DATA_WIDTH : positive
	);
	port (
		clk       : in  std_ulogic;
		res_n     : in  std_ulogic;

		rd_data   : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
		rd        : in  std_ulogic;

		wr_data   : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
		wr        : in  std_ulogic;

		empty     : out std_ulogic;
		full      : out std_ulogic;
		half_full : out std_ulogic
	);
begin
	assert DEPTH = 2**log2c(DEPTH) report "DEPTH must be a power of two!" severity failure;
end entity;


architecture arch of fifo_1c1r1w is
	constant ADDR_WIDTH : integer := log2c(DEPTH);

	signal read_address, read_address_next : unsigned(log2c(DEPTH)-1 downto 0);
	signal write_address, write_address_next : unsigned(log2c(DEPTH)-1 downto 0);
	signal full_next : std_ulogic;
	signal empty_next : std_ulogic;
	signal wr_int, rd_int : std_ulogic;
	signal half_full_next : std_ulogic;
	signal pointer_diff, pointer_diff_next : integer := 0;
begin

	postponed assert not(wr='1' and full='1' and rising_edge(clk)) report "Write operations are not possible on full FIFOs" severity failure;
	postponed assert not(rd='1' and empty='1' and rising_edge(clk)) report "Read operations are not possible on empty FIFOs" severity failure;

	memory_inst : dp_ram_1c1r1w
		generic map (
			ADDR_WIDTH => ADDR_WIDTH,
			DATA_WIDTH => DATA_WIDTH
		)
		port map (
			clk       => clk,
			rd1_addr  => std_ulogic_vector(read_address),
			rd1_data  => rd_data,
			rd1       => rd_int,
			wr2_addr  => std_ulogic_vector(write_address),
			wr2_data  => wr_data,
			wr2       => wr_int
		);

	sync : process(clk, res_n)
	begin
		if res_n = '0' then
			read_address <= (others => '0');
			write_address <= (others => '0');
			full <= '0';
			empty <= '1';
			pointer_diff <= 0;
			half_full <= '0';
		elsif rising_edge(clk) then
			read_address <= read_address_next;
			write_address <= write_address_next;
			full <= full_next;
			empty <= empty_next;
			pointer_diff <= pointer_diff_next;
			half_full <= half_full_next;
		end if;
	end process;

	comb : process(all)
		variable pointer_diff_temp : integer;
	begin
		half_full_next <= '0';
		pointer_diff_next <= pointer_diff;
		pointer_diff_temp := pointer_diff;
		write_address_next <= write_address;
		read_address_next <= read_address;
		full_next <= full;
		empty_next <= empty;
		wr_int <= '0';
		rd_int <= '0';

		if (wr = '1' and full = '0') then
			wr_int <= '1'; -- only write, if fifo is not full
			write_address_next <= write_address + 1;
		end if;

		if (rd = '1' and empty = '0') then
			rd_int <= '1'; -- only read, if fifo is not empty
			read_address_next <= read_address + 1;
		end if;

		-- half full flag
		if (wr = '1' and rd = '0') then
			pointer_diff_temp := pointer_diff + 1;
		elsif (rd = '1' and wr = '0') then
			pointer_diff_temp := pointer_diff - 1;
		end if;

		pointer_diff_next <= pointer_diff_temp;
		if(pointer_diff_temp >= 2**(ADDR_WIDTH-1)) then
			half_full_next <= '1';
		end if;

		-- if memory is empty after current read operation --> set empty flag
		if rd = '1' then
			-- it is not allowed to write to a full fifo! Hence, reading from a FIFO
			-- means that in the next cycle it is not longer full
			full_next <= '0';
			if write_address = read_address + 1 then
				empty_next <= '1';
			end if;
		end if;

		-- if memory is full after current write operation --> set full flag
		if wr = '1' then
			empty_next <= '0'; -- if the FIFO has been written it cannot be empty
			-- account for simultaneuous reads and writes => FIFO only full if not currently read as well
			if read_address = write_address + 1 and rd='0' then
				full_next <= '1';
			end if;
		end if;
	end process;

end architecture;


