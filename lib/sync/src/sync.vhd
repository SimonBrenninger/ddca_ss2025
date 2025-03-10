library ieee;
use ieee.std_logic_1164.all;


entity sync is
	generic (
		SYNC_STAGES : positive;
		RESET_VALUE : std_ulogic
	);
	port (
		clk      : in  std_ulogic;
		res_n    : in  std_ulogic;
		data_in  : in  std_ulogic;
		data_out : out std_ulogic
	);
end entity;


architecture beh of sync is
	-- synchronizer stages
	signal sync_vec : std_ulogic_vector(0 to SYNC_STAGES);
begin
	sync_proc : process(clk, res_n)
	begin
		if res_n = '0' then
			sync_vec <= (others => RESET_VALUE);
		elsif rising_edge(clk) then
			sync_vec(0) <= data_in; -- get new data
			-- forward data to next synchronizer stage
			for i in 1 to SYNC_STAGES loop
				sync_vec(i) <= sync_vec(i - 1);
			end loop;
		end if;
	end process;

	-- output synchronized data
	data_out <= sync_vec(SYNC_STAGES);
end architecture;
