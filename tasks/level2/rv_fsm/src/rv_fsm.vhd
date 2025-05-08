library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_sys_pkg.all;
use work.rv_core_pkg.all;
use work.rv_alu_pkg.all;
use work.rv_fsm_types_pkg.all;
use work.rv_ext_m_pkg.all;

architecture rv_fsm of rv is
	subtype data_t is std_ulogic_vector(31 downto 0);

	-- program counter
	signal pc : data_t;

	-- internal registers
	signal ir : data_t; -- instruction register
	signal wb : data_t; -- ALU output buffer, stores mem addr or data that has to written back to the regfile
	signal nx : data_t; -- ALU output buffer, stores next pc (except for taken branches)
	signal rs : data_t; -- last output of the register file
	signal rf : data_t; -- output of the register file

	-- register write signals
	signal wr_wb, wr_nx, wr_pc, wr_ir : std_ulogic;

	signal imm10 : std_ulogic;

	-- muxes
	signal ma : ma_ctrl_t;
	signal mb : mb_ctrl_t;
	signal mpc : mpc_ctrl_t;
	signal mrs : mrs_ctrl_t;
	signal mwb : mwb_ctrl_t;


	-- ALU signals
	signal alu_op : rv_alu_op_t;
	signal alu_z : std_ulogic;

	-- memroy signals
	signal rd_imem : std_ulogic;
	signal memu_op : memu_op_t;
	signal dmem_busy, imem_busy : std_ulogic;

	--regfile signals
	signal wr_rf : std_ulogic;
	signal rd_rf : std_ulogic;

	-- these signals are only relevant for the rv_ext_m task, you can ignore them for now
	signal ext_m_start, ext_m_busy : std_ulogic;
	signal ext_m_op : ext_m_op_t;

begin

	-- instruction memory interface
	imem_out.address <= pc(imem_out.address'length+1 downto 2);
	imem_out.rd <= rd_imem;
	imem_out.wr <= '0';
	imem_out.byteena <= (others => '1');
	imem_out.wrdata <= (others => '0');

	imem_busy <= imem_in.busy;


	ctrl_fsm_inst : entity work.ctrl_fsm
	port map(
		clk => clk,
		res_n => res_n,
		opcode => get_opcode(ir),
		funct3 => get_funct3(ir),
		funct7 => get_funct7(ir),
		imm10  => imm10,
		alu_z => alu_z,
		dmem_busy => dmem_busy,
		imem_busy => imem_busy,
		ext_m_busy => '0',
		ma => ma,
		mb => mb,
		mpc => mpc,
		mrs => mrs,
		mwb => mwb,
		wr_pc => wr_pc,
		wr_ir => wr_ir,
		wr_wb => wr_wb,
		wr_nx => wr_nx,
		rd_rf => rd_rf,
		wr_rf => wr_rf,
		rd_imem => rd_imem,
		alu_op => alu_op,
		memu_op => memu_op,
		ext_m_op => ext_m_op,
		ext_m_start => ext_m_start
	);

end architecture;
