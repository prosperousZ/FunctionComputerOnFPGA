@INC_LABELS("memory_map.ln")
@START_ADDR(.SOFTWARE_ENTRY)
  MOVI 0x00,r10
  MOV .VGA(r0),r7
  ADDI 80,r7
  MOVI 0,r1
  MOVI 0,r5

  .clk_loop


  MOV r7,r11
  ADDI 1,r10

  JAL r15,.PRINT_WORD_HEX

  MOVI 1,r1
  MOVI 0,r3
  .delay
  ADDI 1,r1
  CMPI 0x00,r1
  BNE .delay
  ADDI 1,r3
  CMPI 0x18,r3
  BNE .delay

  MOVI 0,r1

.c_find_keypress_loop


  ADDI 1,r1

  CMPI 0x7f,r1
  BEQ .c_exit
  MOV r1,r3
  ADD r2,r3
  LOAD r4,r3



  CMPI 0,r4
  BNE .c_exit

  BUC .c_find_keypress_loop
  .c_exit

  CMPI 0x1B,r1
  JEQ .prompt

  CMPI 0x7f,r1
  BNE .do_lap


  MOVI 0,r5

  BUC .clk_loop

  .do_lap

  CMPI 0,r5
  BNE .clk_loop
  MOVI 1,r5
  ADDI 80,r7
  BUC .clk_loop
