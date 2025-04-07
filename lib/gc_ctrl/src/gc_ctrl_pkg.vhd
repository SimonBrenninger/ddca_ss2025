library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package gc_ctrl_pkg is

	type gc_ctrl_state_t is record
		-- buttons
		btn_up    : std_ulogic;
		btn_down  : std_ulogic;
		btn_left  : std_ulogic;
		btn_right : std_ulogic;
		btn_a     : std_ulogic;
		btn_b     : std_ulogic;
		btn_x     : std_ulogic;
		btn_y     : std_ulogic;
		btn_z     : std_ulogic;
		btn_start : std_ulogic;
		btn_l     : std_ulogic;
		btn_r     : std_ulogic;
		-- joysticks
		joy_x     : std_ulogic_vector(7 downto 0);
		joy_y     : std_ulogic_vector(7 downto 0);
		c_x       : std_ulogic_vector(7 downto 0);
		c_y       : std_ulogic_vector(7 downto 0);
		-- trigger
		trigger_l : std_ulogic_vector(7 downto 0);
		trigger_r : std_ulogic_vector(7 downto 0);
	end record;

	constant GC_CTRL_STATE_RESET_VALUE : gc_ctrl_state_t := (
		joy_x     => (others => '0'),
		joy_y     => (others => '0'),
		c_x       => (others => '0'),
		c_y       => (others => '0'),
		trigger_l => (others => '0'),
		trigger_r => (others => '0'),
		others => '0'
	);

	constant GC_POLL_CMD_PREFIX : std_ulogic_vector(22 downto 0) := b"0100_0000_0000_0011_0000_000";

	function to_sulv (s : gc_ctrl_state_t) return std_ulogic_vector;
	function to_gc_ctrl_state(sulv : std_ulogic_vector(63 downto 0)) return gc_ctrl_state_t;
	-- synthesis translate_off
	function to_string(s : gc_ctrl_state_t) return string;
	-- synthesis translate_on

	component gc_ctrl is
		generic (
			CLK_FREQ        : positive := 50_000_000;
			SYNC_STAGES     : positive := 2;
			REFRESH_TIMEOUT : positive := 60000
		);
		port (
			clk        : in    std_ulogic;
			res_n      : in    std_ulogic;
			-- connection to the controller
			data       : inout std_logic;
			-- internal connection
			ctrl_state : out   gc_ctrl_state_t;
			rumble     : in    std_ulogic
		);
	end component;
end package;

package body gc_ctrl_pkg is
	function to_sulv(s : gc_ctrl_state_t) return std_ulogic_vector is
		variable ret : std_ulogic_vector(63 downto 0);
	begin
		ret(63 downto 61) := "000";
		ret(60)           := s.btn_start;
		ret(59)           := s.btn_y;
		ret(58)           := s.btn_x;
		ret(57)           := s.btn_b;
		ret(56)           := s.btn_a;
		ret(55)           := '1';
		ret(54)           := s.btn_l;
		ret(53)           := s.btn_r;
		ret(52)           := s.btn_z;
		ret(51)           := s.btn_up;
		ret(50)           := s.btn_down;
		ret(49)           := s.btn_right;
		ret(48)           := s.btn_left;
		ret(47 downto 40) := s.joy_x;
		ret(39 downto 32) := s.joy_y;
		ret(31 downto 24) := s.c_x;
		ret(23 downto 16) := s.c_y;
		ret(15 downto  8) := s.trigger_l;
		ret( 7 downto  0) := s.trigger_r;

		return ret;
	end function;

	function to_gc_ctrl_state(sulv : std_ulogic_vector(63 downto 0)) return gc_ctrl_state_t is
		variable ret : gc_ctrl_state_t;
	begin
		ret.btn_start := sulv(60);
		ret.btn_y     := sulv(59);
		ret.btn_x     := sulv(58);
		ret.btn_b     := sulv(57);
		ret.btn_a     := sulv(56);
		ret.btn_l     := sulv(54);
		ret.btn_r     := sulv(53);
		ret.btn_z     := sulv(52);
		ret.btn_up    := sulv(51);
		ret.btn_down  := sulv(50);
		ret.btn_right := sulv(49);
		ret.btn_left  := sulv(48);
		ret.joy_x     := sulv(47 downto 40);
		ret.joy_y     := sulv(39 downto 32);
		ret.c_x       := sulv(31 downto 24);
		ret.c_y       := sulv(23 downto 16);
		ret.trigger_l := sulv(15 downto  8);
		ret.trigger_r := sulv( 7 downto  0);

		return ret;
	end function;

	-- synthesis translate_off
	function to_string(s : gc_ctrl_state_t) return string is
	begin
		return
		"(up,down,left,right)=(" &
		to_string(s.btn_up) & "," & to_string(s.btn_down) & "," & to_string(s.btn_left) & "," & to_string(s.btn_right) & "), " &
		"(A,B,X,Y,Z)=(" &
		to_string(s.btn_a) & "," & to_string(s.btn_b) & "," & to_string(s.btn_x) & "," & to_string(s.btn_y) & "," & to_string(s.btn_z) & "), " &
		"(L,R,S)=(" &
		to_string(s.btn_l) & "," & to_string(s.btn_r) & "," & to_string(s.btn_start) & "), " &
		"JS=(" &
		to_hstring(s.joy_x) & "," & to_hstring(s.joy_y) & "), " &
		"CS=(" &
		to_hstring(s.c_x) & "," & to_hstring(s.c_y) & "), " &
		"(LT,RT)=(" &
		to_hstring(s.trigger_l) & "," & to_hstring(s.trigger_r) & ")";
	end function;
	-- synthesis translate_on

end package body;
