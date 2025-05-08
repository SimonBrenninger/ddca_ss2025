VHDL_FILES = \
	../../../lib/math/src/math_pkg.vhd\
	../../../lib/rv_core/src/rv_core_pkg.vhd\
	./src/rv_ext_m_pkg.vhd\
	./src/rv_ext_m.vhd\
	./tb/rv_ext_m_tb.vhd

TB=rv_ext_m_tb
CLEAN_DIRS=vendor_libs
WAVE_FILE=wave.do

# Use altera libraries for simulating LPM_MULT, LPM_DIV, ALTSQRT IPs
GHDL_USE_ALTERA_LIB=1

include ../../../util/simple_flow.mk

