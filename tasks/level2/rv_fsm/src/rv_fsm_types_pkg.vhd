package rv_fsm_types_pkg is
	type ma_ctrl_t is (SEL_PC, SEL_RF, SEL_RS);
	type mb_ctrl_t is (SEL_IMM, SEL_RF, SEL_4);
	type mpc_ctrl_t is (SEL_WB, SEL_NX);
	type mrs_ctrl_t is (SEL_RS1, SEL_RS2);
	type mwb_ctrl_t is (SEL_WB, SEL_MEMU);
end package;
