LIB=../../../lib/

VHDL_FILES = \
	$(LIB)/math/src/math_pkg.vhd\
	$(LIB)/sync/src/sync_pkg.vhd\
	$(LIB)/sync/src/sync.vhd\
	$(LIB)/tb_util/src/tb_util_pkg.vhd\
	$(LIB)/mem/src/mem_pkg.vhd\
	$(LIB)/mem/src/dp_ram_1c1r1w.vhd\
	$(LIB)/mem/src/fifo_1c1r1w.vhd\
	$(LIB)/mem/src/fifo_1c1r1w_fwft.vhd\
	$(LIB)/mem/src/dp_ram_2c2rw.vhd\
	$(LIB)/mem/src/dp_ram_2c2rw_byteen.vhd\
	$(LIB)/snes_ctrl/src/snes_ctrl_pkg.vhd\
	$(LIB)/snes_ctrl/src/snes_ctrl.vhd\
	$(LIB)/snes_ctrl/src/snes_ctrl_arch_ref.vhd\
	$(LIB)/sram_ctrl/src/sram_ctrl_pkg.vhd\
	$(LIB)/sram_ctrl/src/sram_ctrl.vhd\
	$(LIB)/sram_ctrl/src/sram_ctrl_arch_ref.vhd\
	$(LIB)/vga_ctrl/src/vga_ctrl_pkg.vhd\
	$(LIB)/vga_ctrl/src/vga_ctrl.vhd\
	$(LIB)/vga_ctrl/src/vga_ctrl_arch_ref.vhd\
	$(LIB)/vga_ctrl/src/tpg.vhd\
	$(LIB)/gfx_core/src/gfx_core_pkg.vhd\
	$(LIB)/vga_gfx_ctrl/src/gfx_util_pkg.vhd\
	$(LIB)/vga_gfx_ctrl/src/pixel_writer.vhd\
	$(LIB)/vga_gfx_ctrl/src/pixel_reader.vhd\
	$(LIB)/vga_gfx_ctrl/src/gfx_circle.vhd\
	$(LIB)/vga_gfx_ctrl/src/rasterizer.vhd\
	$(LIB)/vga_gfx_ctrl/src/rasterizer_arch_ref.vhd\
	$(LIB)/vga_gfx_ctrl/src/vga_gfx_ctrl_pkg.vhd\
	$(LIB)/vga_gfx_ctrl/src/frame_reader.vhd\
	$(LIB)/vga_gfx_ctrl/src/vga_gfx_ctrl.vhd\
	$(LIB)/rv_core/src/rv_core_pkg.vhd\
	$(LIB)/rv_alu/src/rv_alu_pkg.vhd\
	$(LIB)/rv_alu/src/rv_alu.vhd\
	$(LIB)/rv_sys/src/rv_sys_pkg.vhd\
	$(LIB)/rv_sys/src/delay.vhd\
	$(LIB)/rv_sys/src/virtual_jtag_wrapper.vhd\
	$(LIB)/rv_sys/src/sld_virtual_jtag_stub.vhd\
	$(LIB)/rv_sys/src/memory_sim.vhd\
	$(LIB)/rv_sys/src/memory_jtag.vhd\
	$(LIB)/rv_sys/src/mm_serial_port.vhd\
	$(LIB)/rv_sys/src/mm_counter.vhd\
	$(LIB)/rv_sys/src/mm_gpio.vhd\
	$(LIB)/rv_sys/src/mm_gci.vhd\
	$(LIB)/rv_sys/src/rv_sys.vhd\
	$(LIB)/rv_sys/src/memu.vhd\
	$(LIB)/rv_sys/src/rv.vhd\
	../rv_ext_m/src/rv_ext_m_pkg.vhd\
	../rv_ext_m/src/rv_ext_m.vhd\
	../rv_fsm/src/rv_fsm_types_pkg.vhd\
	../rv_fsm/src/ctrl_fsm.vhd\
	../rv_fsm/src/rf_ram.vhd\
	../rv_fsm/src/rv_fsm.vhd\
	../../level1/tetris/src/gfx_init_pkg.vhd\

VHDL_FILES += ../../level1/gfx_cmd_interpreter/src/gfx_cmd_interpreter.vhd


VHDL_FILES += \
	$(LIB)/top/src/top.vhd\
	top_arch.vhd\
	tb/rv_tetris_tb.vhd

TB=rv_tetris_tb
WAVE_FILE=wave.do
GHDL_USE_ALTERA_LIB=1

include ../../../util/simple_flow.mk
include ../../../util/quartus.mk

run:
	make -C software
	make -C software run

