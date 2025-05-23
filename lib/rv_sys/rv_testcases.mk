rv_sys_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))


VHDL_FILES+=$(wildcard $(rv_sys_dir)/tb/*.vhd)

TESTCASE_FILES := $(shell find $(rv_sys_dir)/testcases -type f -name '*rvtc.mk')

include $(TESTCASE_FILES)

define rv_def_tc_vars

$1_WAVE_FILE?=$(WAVE_FILE)
$1_GTK_WAVE_FILE?=$(GTKW_WAVE_FILE)
$1_NAME?=$1
$1_GENERICS=-gELF_FILE=$($1_ELF) -gTESTCASE_NAME=$($1_NAME)

endef

define rv_def_tc_rules

$($1_ELF):
	@echo "Building software"
	@make --no-print-directory -C $(dir $($1_ELF)) clean # always do a fresh build before simulation
	@make --no-print-directory -C $(dir $($1_ELF)) $(notdir $(basename $($1_ELF))).imem.mif $(notdir $(basename $($1_ELF))).dmem.mif 2>&1

.PHONY: $($1_ELF)

$($1_NAME)_sim: compile $($1_ELF)
	@make --no-print-directory sim TB=$($1_TB) VSIM_USER_ARGS="$($1_VSIM_USER_ARGS) $($1_GENERICS)"

$($1_NAME)_sim_gui: compile $($1_ELF)
	@make --no-print-directory sim_gui TB=$($1_TB) WAVE_FILE=$($1_WAVE_FILE) VSIM_USER_ARGS="$($1_VSIM_USER_ARGS) $($1_GENERICS)"

$($1_NAME)_gsim: $($1_ELF) gcompile
	@make --no-print-directory gsim TB=$($1_TB) GHDL_USER_ARGS="$($1_GHDL_USER_ARGS) $($1_GENERICS)"

$($1_NAME)_gsim_gui: $($1_ELF) gcompile
	@make --no-print-directory gsim_gui TB=$($1_TB) GTK_WAVE_FILE=$($1_GTK_WAVE_FILE) GHDL_USER_ARGS="$($1_GHDL_USER_ARGS) $($1_GENERICS)"

$($1_NAME)_info:
	@echo "NAME           $($1_NAME)"
	@echo "ELF            $($1_ELF)"
	@echo "TB             $($1_TB)"
	@echo "WAVE_FILE      $($1_WAVE_FILE)"
	@echo "VSIM_USER_ARGS $($1_VSIM_USER_ARGS)"
	@echo "GHDL_USER_ARGS $($1_GHDL_USER_ARGS)"
	@echo "VHDL_FILES     $($1_VHDL_FILES)"

$($1_NAME)_disassemble:
	/opt/ddca/riscv/bin/riscv32-unknown-elf-objdump -d $($1_ELF)

_GRUN_$1:
	@(make $($(tc)_NAME)_gsim 2>&1 | grep -E "PASSED|FAILED") || echo "$($(tc)_NAME) FAILED (to run)"

_RUN_$1:
	@(make $($(tc)_NAME)_sim 2>&1 | grep -E "PASSED|FAILED") || echo "# $($(tc)_NAME) FAILED (to run)"

endef

$(foreach tc, $(RV_TESTCASES), $(eval VHDL_FILES += $($(tc)_VHDL_FILES)))
$(foreach tc, $(RV_TESTCASES), $(eval $(call rv_def_tc_vars,$(tc))))
$(foreach tc, $(RV_TESTCASES), $(eval $(call rv_def_tc_rules,$(tc))))

rvall_gsim:
	@make --no-print-directory $(foreach tc, $(RV_TESTCASES), _GRUN_$(tc))

rvall_sim:
	@make --no-print-directory $(foreach tc, $(RV_TESTCASES), _RUN_$(tc))

