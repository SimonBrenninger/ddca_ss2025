library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package snes_ctrl_pkg is

	type snes_ctrl_state_t is record
		btn_up     : std_ulogic;
		btn_down   : std_ulogic;
		btn_left   : std_ulogic;
		btn_right  : std_ulogic;
		btn_a      : std_ulogic;
		btn_b      : std_ulogic;
		btn_x      : std_ulogic;
		btn_y      : std_ulogic;
		btn_l      : std_ulogic;
		btn_r      : std_ulogic;
		btn_start  : std_ulogic;
		btn_select : std_ulogic;
	end record;

	constant SNES_CTRL_STATE_RESET_VALUE : snes_ctrl_state_t := (others=>'0');

	component snes_ctrl is
		generic (
			CLK_FREQ        : integer := 50_000_000;
			CLK_OUT_FREQ    : integer := 100_000;
			REFRESH_TIMEOUT : integer := 1000
		);
		port (
			clk        : in  std_ulogic;
			res_n      : in  std_ulogic;
			snes_clk   : out std_ulogic;
			snes_latch : out std_ulogic;
			snes_data  : in  std_ulogic;
			ctrl_state : out snes_ctrl_state_t
		);
	end component;

	function to_sulv(s : snes_ctrl_state_t) return std_ulogic_vector;
	function to_snes_ctrl_state(sulv : std_ulogic_vector(11 downto 0)) return snes_ctrl_state_t;

end package;

package body snes_ctrl_pkg is
	function to_sulv(s : snes_ctrl_state_t) return std_ulogic_vector is
		variable ret : std_ulogic_vector(11 downto 0);
	begin
		ret(0)  := s.btn_b;
		ret(1)  := s.btn_y;
		ret(2)  := s.btn_select;
		ret(3)  := s.btn_start;
		ret(4)  := s.btn_up;
		ret(5)  := s.btn_down;
		ret(6)  := s.btn_left;
		ret(7)  := s.btn_right;
		ret(8)  := s.btn_a;
		ret(9)  := s.btn_x;
		ret(10) := s.btn_l;
		ret(11) := s.btn_r;
		return ret;
	end function;

	function to_snes_ctrl_state(sulv : std_ulogic_vector(11 downto 0)) return snes_ctrl_state_t is
		variable ret : snes_ctrl_state_t;
	begin
		ret.btn_b      := sulv(0);
		ret.btn_y      := sulv(1);
		ret.btn_select := sulv(2);
		ret.btn_start  := sulv(3);
		ret.btn_up     := sulv(4);
		ret.btn_down   := sulv(5);
		ret.btn_left   := sulv(6);
		ret.btn_right  := sulv(7);
		ret.btn_a      := sulv(8);
		ret.btn_x      := sulv(9);
		ret.btn_l      := sulv(10);
		ret.btn_r      := sulv(11);
		return ret;
	end function;
end package body;
