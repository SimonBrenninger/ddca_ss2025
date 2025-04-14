
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_sys_pkg.all;
use work.rv_core_pkg.all;
use work.rv_alu_pkg.all;
use work.rv_fsm_types_pkg.all;

entity ctrl_fsm is
	port (
		clk : in std_logic;
		res_n : in std_logic;
		opcode : in opcode_t;
		funct3 : in funct3_t;
		funct7 : in funct7_t;
		imm10 : in std_ulogic;
		alu_z : in std_ulogic;
		dmem_busy : in std_ulogic;
		imem_busy : in std_ulogic;
		ma : out ma_ctrl_t;
		mb : out mb_ctrl_t;
		mpc : out mpc_ctrl_t;
		mrs : out mrs_ctrl_t;
		mwb : out mwb_ctrl_t;
		wr_pc : out std_ulogic;
		wr_ir : out std_ulogic;
		wr_wb : out std_ulogic;
		wr_nx : out std_ulogic;
		rd_rf : out std_logic;
		wr_rf : out std_logic;
		rd_imem : out std_ulogic;
		alu_op : out rv_alu_op_t;
		memu_op : out memu_op_t
	);
end entity;


architecture arch of ctrl_fsm is
begin
end architecture;
