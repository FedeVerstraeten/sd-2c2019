# vhdl files
FILES = src/*
VHDLEX = .vhd

# testbench
TESTBENCHPATH = testbench/${TESTBENCH}$(VHDLEX)

#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --ieee=synopsys --warn-no-vital-generic

# Simulation break condition
#GHDL_SIM_OPT = --assert-level=error
# GHDL_SIM_OPT = --stop-time=100us
GHDL_SIM_OPT = --stop-time=5ms

# Working directories
SIMDIR = simulation
WORKLIB = work
WORKDIR_FLAGS = --workdir=$(SIMDIR) --work=$(WORKLIB)

WAVEFORM_VIEWER = gtkwave

all: compile run view

new:
	@echo "Setting up project ${PROJECT}"
	mkdir src testbench simulation

compile:
ifeq ($(strip $(TESTBENCH)),)
	@echo "TESTBENCH not set. Use TESTBENCH=value to set it."
	@exit 2
endif

	mkdir -p simulation
# 	$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHPATH) $(FILES)
# 	$(GHDL_CMD) -m  $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCH)
	$(GHDL_CMD) -i $(GHDL_FLAGS) $(WORKDIR_FLAGS) $(TESTBENCHPATH) $(FILES)
	$(GHDL_CMD) -m  $(GHDL_FLAGS) $(WORKDIR_FLAGS) $(TESTBENCH)
	$(GHDL_CMD) -s $(GHDL_FLAGS) $(WORKDIR_FLAGS) $(TESTBENCHPATH)
	$(GHDL_CMD) -a $(GHDL_FLAGS) $(WORKDIR_FLAGS) $(TESTBENCHPATH)
	$(GHDL_CMD) -e $(WORKDIR_FLAGS) $(TESTBENCH)
# 	@mv $(TESTBENCH) simulation/$(TESTBENCH)

run:
# 	$(SIMDIR)/$(TESTBENCH) $(GHDL_SIM_OPT) --vcdgz=$(SIMDIR)/$(TESTBENCH).vcdgz
	$(GHDL_CMD) -r $(WORKDIR_FLAGS) $(TESTBENCH) $(GHDL_SIM_OPT) --vcdgz=$(SIMDIR)/$(TESTBENCH).vcdgz

view:
	gunzip --stdout $(SIMDIR)/$(TESTBENCH).vcdgz | $(WAVEFORM_VIEWER) --vcd

clean :
	$(GHDL_CMD) --clean --workdir=simulation
	rm -f ./*.o $(SIMDIR)/*.o $(SIMDIR)/*.cf $(SIMDIR)/*.vcdgz $(SIMDIR)/*_tb

