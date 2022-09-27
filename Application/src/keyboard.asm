@INC_LABELS("memory_map.ln")
@START_ADDR(.KERNEL_ENTRY)
MOVI 0,r1
.kbd_loop
  LOAD .KBD(r1),r2
  ADDI 1,r1
  ANDI 0xFF,r1
  CMPI 0,r1
  BEQ .kbd_loop
SUBI 1,r1
STOR 5,.VGA(r1)
