
VPATH = tmp:bb6502
.SUFFIXES:

.PHONY: all
all: cbmbasic1.bin cbmbasic2.bin kbdbasic.bin osi.bin kb9.bin applesoft.bin microtan.bin aim65.bin sym1.bin bb6502.bin

%.bin: %.o %.cfg
	ld65 -C $*.cfg tmp/$*.o -o tmp/$*.bin -Ln tmp/$*.lbl

%.o: *.s
	@mkdir -p tmp
	@echo $*
	ca65 -D $* msbasic.s -o tmp/$@
