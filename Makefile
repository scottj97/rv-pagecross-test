# -*- Makefile -*- (tells Emacs what mode to use)

SAIL_RISCV_DIR=../sail-riscv

DIAG=pagecross


.PHONY: all
all: $(DIAG).sail.out

$(DIAG).sail.out: $(DIAG).elf $(DIAG).dis
	($(SAIL_RISCV_DIR)/ocaml_emulator/riscv_ocaml_sim_RV64 -enable-misaligned-access pagecross.elf ) > $@ 2>&1

LDSCRIPT = sim.ld

OBJDUMP_OPTS = \
	  --section=.text \
	  --section=.text.startup \
	  --section=.text.init \
	  --section=.data \
	  --disassemble-zeroes \
	  --disassembler-options=numeric \


$(DIAG).elf: $(DIAG).o $(LDSCRIPT)
	riscv64-unknown-elf-ld \
	  -o $(DIAG).elf \
	  -T $(LDSCRIPT) \
	  $(DIAG).o
	chmod -x $(DIAG).elf

ABI="lp64"
ISA="rv64gc"
RESET_VECTOR = reset.s
$(DIAG).o: $(DIAG).s $(RESET_VECTOR)
	riscv64-unknown-elf-as \
	-march=$(ISA) \
	-mabi=$(ABI) \
	-g \
	-o $(DIAG).o \
	$(DIAG).s \
	$(RESET_VECTOR)


.DELETE_ON_ERROR:

$(DIAG).dis: $(DIAG).elf $(REAL_MAKEFILES)
	riscv64-unknown-elf-objdump \
	  --disassemble-all \
	  --architecture=riscv:rv64 \
	  --disassembler-options=no-aliases \
	  $(OBJDUMP_OPTS) \
	  $(DIAG).elf \
	  > $(DIAG).dis
