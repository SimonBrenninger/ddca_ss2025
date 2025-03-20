
LIB=../../../lib

VHDL_FILES = \
	$(LIB)/math/src/math_pkg.vhd\
	$(LIB)/sync/src/sync_pkg.vhd\
	$(LIB)/sync/src/sync.vhd\
	$(LIB)/mem/src/mem_pkg.vhd\
	$(LIB)/mem/src/dp_ram_1c1r1w_rdw.vhd\
	$(LIB)/mem/src/dp_ram_1c1r1w.vhd\
	$(LIB)/mem/src/dp_ram_2c2rw_byteen.vhd\
	$(LIB)/mem/src/dp_ram_2c2rw.vhd\
	$(LIB)/mem/src/fifo_1c1r1w_fwft.vhd\
	$(LIB)/mem/src/fifo_1c1r1w.vhd\
	$(LIB)/sram_ctrl/src/sram_ctrl_pkg.vhd\
	$(LIB)/sram_ctrl/src/sram_ctrl.vhd\
	$(LIB)/sram_ctrl/src/sram_ctrl_arch_ref.vhd\
	$(LIB)/vga_ctrl/src/vga_ctrl_pkg.vhd\
	$(LIB)/vga_ctrl/src/vga_ctrl.vhd\
	$(LIB)/vga_ctrl/src/tpg.vhd\
	$(LIB)/gfx_core/src/gfx_core_pkg.vhd\
	$(LIB)/vga_gfx_ctrl/src/gfx_util_pkg.vhd\
	$(LIB)/vga_gfx_ctrl/src/pixel_writer.vhd\
	$(LIB)/vga_gfx_ctrl/src/pixel_reader.vhd\
	$(LIB)/vga_gfx_ctrl/src/gfx_circle.vhd\
	$(LIB)/vga_gfx_ctrl/src/rasterizer.vhd\
	$(LIB)/vga_gfx_ctrl/src/vga_gfx_ctrl_pkg.vhd\
	$(LIB)/vga_gfx_ctrl/src/frame_reader.vhd\
	$(LIB)/vga_gfx_ctrl/src/vga_gfx_ctrl.vhd\
	$(LIB)/tetris_util/src/tetris_util_pkg.vhd\
	$(LIB)/tetris_util/src/tetromino_collider.vhd\
	$(LIB)/tetris_util/src/tetromino_drawer.vhd\
	$(LIB)/decimal_printer/src/decimal_printer.vhd\
	$(LIB)/decimal_printer/src/decimal_printer_pkg.vhd\
	$(LIB)/snes_ctrl/src/snes_ctrl_pkg.vhd\
	$(LIB)/snes_ctrl/src/snes_ctrl.vhd\
	$(LIB)/snes_ctrl/src/snes_ctrl_arch_ref.vhd\
	src/gfx_init_pkg.vhd\
	src/tetris_pkg.vhd\
	src/tetris.vhd\
	src/tetris_arch.vhd\
	$(LIB)/top/src/top.vhd\
	top_arch.vhd\
	$(LIB)/tb_util/src/tb_util_pkg.vhd\
	../gfx_cmd_interpreter/src/gfx_cmd_interpreter.vhd\
	tb/tetris_tb.vhd
	

TB=tetris_tb

CLEAN_FILES=*.ppm

include ../../../util/simple_flow.mk
include ../../../util/quartus.mk

