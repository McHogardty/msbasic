
VPATH = tmp
.SUFFIXES:

.PHONY: all
all: cbmbasic1.bin cbmbasic2.bin kbdbasic.bin osi.bin kb9.bin applesoft.bin microtan.bin aim65.bin sym1.bin bb6502.bin

%.bin: %.o %.cfg
	ld65 -C $*.cfg tmp/$*.o -o tmp/$*.bin -Ln tmp/$*.lbl

%.o: *.s bb6502/*.s bb6502/*.inc
	@mkdir -p tmp
	@echo $*
	ca65 -D $* msbasic.s -o tmp/$@
