rv_sys_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))


VHDL_FILES+=$(wildcard $(rv_sys_dir)/tb/*.vhd)

TESTCASE_FILES := $(shell find $(rv_sys_dir)/testcases -type f -name '*rvtc.mk')

include $(TESTCASE_FILES)

define rv_def_tc_vars

ifndef $($1_WAVE_FILE)
	$1_WAVE_FILE=$(WAVE_FILE)
endif

ifndef $($1_GTKW_WAVE_FILE)
	$1_GTK_WAVE_FILE=$(GTKW_WAVE_FILE)
endif

$1_GENERICS=-gELF_FILE=$($1_ELF) -gTESTCASE_NAME=$($1_NAME)

endef

define rv_def_tc_rules

$($1_ELF):
	@echo "Building software"
	@make --no-print-directory -C $(dir $($1_ELF)) $(notdir $(basename $($1_ELF))).imem.mif $(notdir $(basename $($1_ELF))).dmem.mif

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
	@echo "VCOM_USER_ARGS $($1_VCOM_USER_ARGS)"
	@echo "GHDL_USER_ARGS $($1_GHDL_USER_ARGS)"
	@echo "VHDL_FILES     $($1_VHDL_FILES)"

endef

$(foreach tc, $(RV_TESTCASES), $(eval VHDL_FILES += $($(tc)_VHDL_FILES)))
$(foreach tc, $(RV_TESTCASES), $(eval $(call rv_def_tc_vars,$(tc))))
$(foreach tc, $(RV_TESTCASES), $(eval $(call rv_def_tc_rules,$(tc))))

rvall_gsim:
	make $(foreach tc, $(RV_TESTCASES), $($(tc)_NAME)_gsim) | grep -E "PASSED|FAILED"

rvall_sim:
	make $(foreach tc, $(RV_TESTCASES), $($(tc)_NAME)_sim) | grep -E "PASSED|FAILED"

