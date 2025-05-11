VHDL_FILES = \
	../../../lib/util/src/util_pkg.vhd\
	../../../lib/math/src/math_pkg.vhd\
	../../../lib/sync/src/sync_pkg.vhd\
	../../../lib/sync/src/sync.vhd\
	../../../lib/mem/src/mem_pkg.vhd\
	../../../lib/mem/src/dp_ram_1c1r1w.vhd\
	../../../lib/mem/src/fifo_1c1r1w.vhd\
	../../../lib/mem/src/fifo_1c1r1w_fwft.vhd\
	../../../lib/uart_data_streamer/src/uart_data_streamer_pkg.vhd\
	../../../lib/uart_data_streamer/src/uart_data_streamer.vhd\
	../../../lib/top/src/top.vhd\
	src/vnorm_pkg.vhd\
	src/vnorm.vhd\
	tb/vnorm_tb.vhd\
	top_arch.vhd

TB=vnorm_tb
WAVE_FILE=wave.do
GTK_WAVE_FILE=wave.gtkw

GHDL_USE_ALTERA_LIB=1
CLEAN_DIRS=vendor_libs

include ../../../util/simple_flow.mk
include ../../../util/quartus.mk

