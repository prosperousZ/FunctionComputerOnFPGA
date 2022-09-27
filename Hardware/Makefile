assemble = java -cp Assembler/assembler/assembler/bin assembler.Main
assembler:
	javac Assembler/assembler/assembler/src/assembler/*.java -d Assembler/assembler/assembler/bin

bios:
	$(assemble) Application/src/BIOS.asm Application/build/BIOS.out

key_display_demo:
	$(assemble) Application/src/key_display.asm Application/build/key_display.out
	python fixmem.py

snake:
	$(assemble) Application/src/snake.asm Application/build/snake.out
	python fixmem.py

verilog:
	~/intelFPGA_lite/18.1/quartus/bin/quartus_sh --flow compile FinalProject

all: key_display_demo verilog
