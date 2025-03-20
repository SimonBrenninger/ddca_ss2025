# The order is important!
VHDL_FILES = \
	../math/src/math_pkg.vhd\
	./src/mem_pkg.vhd\
	./src/dp_ram_1c1r1w.vhd\
	./src/dp_ram_2c2rw.vhd\
	./src/dp_ram_2c2rw_byteen.vhd\
	./src/fifo_1c1r1w.vhd\
	./src/fifo_1c1r1w_fwft.vhd\
	./tb/fifo_1c1r1w_tb.vhd

# the list of VHDL files must come before this include!
include ../../util/simple_flow.mk

# Here we don't use the default 'sim' target, but special 'sim_fifo' tragets to
# indicate that only the FIFO is simulated. For that pupose, we need to set
# required variable (i.e., TB and WAVE_FILE) for these targets.
sim_fifo: TB=fifo_1c1r1w_tb
sim_fifo: sim

sim_fifo_gui: WAVE_FILE=wave/fifo_wave.do
sim_fifo_gui: TB=fifo_1c1r1w_tb
sim_fifo_gui: sim_gui

gsim_fifo: TB=fifo_1c1r1w_tb
gsim_fifo: gsim
