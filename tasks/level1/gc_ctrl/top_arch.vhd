library ieee;
use ieee.std_logic_1164.all;

use work.gc_ctrl_pkg.all;
use work.util_pkg.all;


architecture top_arch of top is
	signal ctrl_state : gc_ctrl_state_t;
begin

	gc_ctrl_inst : entity work.gc_ctrl(arch)
	port map (
		clk        => clk,
		res_n      => keys(0),
		data       => gc_data,
		rumble     => keys(1),
		ctrl_state => ctrl_state
	);

	ledr(12 downto 0) <= to_sulv(ctrl_state)(60 downto 48);

	process (all )is
	begin
		if switches(0) = '1' then
			-- joystick (the gray one)
			hex0 <= to_segs(to_sulv(ctrl_state)(43 downto 40));
			hex1 <= to_segs(to_sulv(ctrl_state)(47 downto 44));
			hex2 <= to_segs(to_sulv(ctrl_state)(35 downto 32));
			hex3 <= to_segs(to_sulv(ctrl_state)(39 downto 36));
		else
			-- C (yellow joystick)
			hex0 <= to_segs(to_sulv(ctrl_state)(27 downto 24));
			hex1 <= to_segs(to_sulv(ctrl_state)(31 downto 28));
			hex2 <= to_segs(to_sulv(ctrl_state)(19 downto 16));
			hex3 <= to_segs(to_sulv(ctrl_state)(23 downto 20));
		end if;
	end process;

	-- left trigger
	hex4 <= to_segs(to_sulv(ctrl_state)(11 downto 8));
	hex5 <= to_segs(to_sulv(ctrl_state)(15 downto 12));

	-- right trigger
	hex6 <= to_segs(to_sulv(ctrl_state)(3 downto 0));
	hex7 <= to_segs(to_sulv(ctrl_state)(7 downto 4));

end architecture;

