@INC_LABELS("memory_map.ln")
@START_ADDR(.FIRMWARE_ENTRY)
#r5 will hold screen location

MOVI 0,r0
#r6 is column
MOV r0,r6
#r7 is row
MOVI 16,r7


MOVI 0x00,r2
LUI 0xD0,r2

.prompt
OR r0,r0
MOV .VGA(r0),r5
#show bash prompt
MOVI 0x3E,r1
LUI 63,r1
STOR r1,r5
ADDI 1,r5
MOVI 1,r6

.find_keypress
OR r0,r0

MOVI 1,r1
MOVI 0,r3
.dloop
ADDI 1,r1
CMPI 0x00,r1
BNE .dloop
ADDI 1,r3
CMPI 0x18,r3
BNE .dloop

JAL r15,.GET_KEY
CMPI 0,r1
BEQ .find_keypress

#r1 contains key value
#check for backspace
CMPI 0x08,r1
BEQ .backspace
#check for enter
CMPI 0x0A,r1
BEQ .enter
LUI 63,r1
STOR r1,r5
ADDI 1,r5
ADDI 1,r6

BUC .find_keypress

.backspace
OR r0,r0
OR r0,r0
SUBI 0x01,r5
SUBI 1,r6
MOV .VGA(r0),r7
CMP r5,r7
BEQ .find_keypress
OR r0,r0
STOR r0,r5
OR r0,r0
BUC .find_keypress


.enter
  MOV r5,r11
  MOVI 0,r1

  #CHECK FOR LS
  MOV .VGA(r0),r10
  ADDI 1,r10
  MOV .LS(r0),r11
  JAL r15,.STR_EQ
  MOV .IS_LS(r0),r9
  STOR r12,r9
  OR r0,r0
  OR r0,r0

  #CHECK FOR CLK
  MOV .VGA(r0),r10
  ADDI 1,r10
  MOV .CLOCK(r0),r11
  JAL r15,.STR_EQ
  MOV .IS_CLK(r0),r9
  STOR r12,r9
  OR r0,r0
  OR r0,r0

  #CHECK FOR KERN
  MOV .VGA(r0),r10
  ADDI 1,r10
  MOV .KERNEL(r0),r11
  JAL r15,.STR_EQ
  MOV .IS_KERN(r0),r9
  STOR r12,r9
  OR r0,r0
  OR r0,r0

  #CHECK FOR HELLO
  MOV .VGA(r0),r10
  ADDI 1,r10
  MOV .HELLOWORLD(r0),r11
  JAL r15,.STR_EQ
  MOV .IS_HELL(r0),r9
  STOR r12,r9
  OR r0,r0
  OR r0,r0

  MOVI 0,r10
  MOV .VGA(r0),r5
  MOV r5,r11
  MOVI 1,r1
  ADDI 80,r11
  MOVI 0xC0,r9
  LUI 0x12,r9
  .clearline
    MOV .VGA(r0),r5
    ADD r1,r5
    STOR r0,r5
    ADDI 1,r1
    CMP r9,r1
    BNE .clearline


  #DO LS
  MOV .IS_LS(r0),r10
  LOAD r12,r10
  OR r0,r0
  OR r0,r0
  CMP r0,r12
  BNE .LS_RUN

  #DO CLK
  MOV .IS_CLK(r0),r10
  LOAD r12,r10
  OR r0,r0
  OR r0,r0
  CMP r0,r12
  BNE .CLK_RUN

  #DO KERN
  MOV .IS_KERN(r0),r10
  LOAD r12,r10
  OR r0,r0
  OR r0,r0
  CMP r0,r12
  BNE .KERN_RUN

  #DO HELLO
  MOV .IS_HELL(r0),r10
  LOAD r12,r10
  OR r0,r0
  OR r0,r0
  CMP r0,r12
  BNE .HEL_RUN

  MOV .NF_TEXT(r0),r10
  MOV .VGA(r0),r11
  ADDI 80,r11
  MOVI 0,r1

  JAL r15,.PRINT
  OR r0,r0
  JUC .prompt

.HEL_RUN
  OR r0,r0
  OR r0,r0
  MOV .HELLOWORLD_T(r0),r10
  MOV .VGA(r0),r11
  ADDI 80,r11
  MOVI 0,r1
  JAL r15,.PRINT
  OR r0,r0
  JUC .prompt

.KERN_RUN
  OR r0,r0
  OR r0,r0
  MOV .NA(r0),r10
  MOV .VGA(r0),r11
  ADDI 80,r11
  MOVI 0,r1
  JAL r15,.PRINT
  OR r0,r0
  JUC .prompt

.LS_RUN
  OR r0,r0
  OR r0,r0
  MOV .LS_LN1(r0),r10
  MOV .VGA(r0),r11
  ADDI 80,r11
  MOVI 0,r1
  JAL r15,.PRINT
  OR r0,r0
  JUC .prompt

.CLK_RUN
    OR r0,r0
    OR r0,r0
    OR r0,r0
    MOVI 0x00,r10
    MOV .VGA(r0),r7
    ADDI 80,r7
    MOVI 0,r1
    MOVI 0,r5

    .clk_loop
    OR r0,r0
    OR r0,r0
    MOV r7,r11
    ADDI 1,r10
    OR r0,r0
    JAL r15,.PRINT_HEX

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
    OR r0,r0
    OR r0,r0
    ADDI 1,r1
    OR r0,r0
    CMPI 0x7f,r1
    BEQ .c_exit
    MOV r1,r3
    ADD r2,r3
    LOAD r4,r3
    OR r0,r0
    OR r0,r0
    OR r0,r0
    CMPI 0,r4
    BNE .c_exit
    OR r0,r0
    BUC .c_find_keypress_loop
    .c_exit
    OR r0,r0
    OR r0,r0

    CMPI 0x1B,r1
    JEQ .prompt
    OR r0,r0
    OR r0,r0
    OR r0,r0
    CMPI 0x7f,r1
    BNE .do_lap

    OR r0,r0
    MOVI 0,r5
    OR r0,r0

    BUC .clk_loop

    .do_lap
    OR r0,r0
    OR r0,r0
    CMPI 0,r5
    BNE .clk_loop
    MOVI 1,r5
    ADDI 80,r7
    BUC .clk_loop

.PRINT_HEX
  OR r0,r0
  OR r0,r0
  MOVI 0xF0,r8
  LUI 0xFF,r8

  .p_hex_run
  OR r0,r0
  CMPI 0,r8
  JEQ r15
  ADDI 4,r8
  MOV r10,r9
  LSH r8,r9
  ANDI 0x0f,r9
  CMPI 9,r9
  BLO .p_ltr

  LUI 63,r9
  ADDI 0x30,r9
  STOR r9,r11
  OR r0,r0
  OR r0,r0
  ADDI 1,r11
  BUC .p_hex_run

  .p_ltr
  OR r0,r0
  OR r0,r0
  LUI 63,r9
  ADDI 0x37,r9
  STOR r9,r11
  OR r0,r0
  OR r0,r0
  ADDI 1,r11
  BUC .p_hex_run

  OR r0,r0

.PRINT
  OR r0,r0
  OR r0,r0
  LOAD r1,r10
  OR r0,r0
  OR r0,r0
  CMPI 0,r1
  JEQ r15
  OR r0,r0
  OR r0,r0
  LUI 63,r1
  OR r0,r0
  STOR r1,r11
  OR r0,r0
  OR r0,r0
  OR r0,r0
  ADDI 1,r10
  ADDI 1,r11
  MOVI 0,r1
  OR r0,r0
  BUC .PRINT

.STR_EQ
  OR r0,r0
  MOVI 0,r12
  .str_eq_loop
    OR r0,r0
    OR r0,r0
    LOAD r8,r10
    OR r0,r0
    OR r0,r0
    OR r0,r0
    OR r0,r0
    LOAD r9,r11
    OR r0,r0
    OR r0,r0
    OR r0,r0
    OR r0,r0
    LUI 0,r8
    LUI 0,r9
    CMP r8,r9
    #return if not the same
    JNE r15
    OR r8,r9
    CMP r0,r9
    BEQ .str_true
    ADDI 1,r10
    ADDI 1,r11
    OR r0,r0
    BUC .str_eq_loop
  .str_true
    OR r0,r0
    OR r0,r0
    MOVI 1,r12
    OR r0,r0
    OR r0,r0
    JUC r15

.GET_KEY
    OR r0,r0
    MOVI 0,r1

  .find_keypress_loop
    ADDI 1,r1
    CMPI 0x7f,r1
    BEQ .GET_KEY
    MOV r1,r3
    ADD r2,r3
    LOAD r4,r3
    OR r0,r0
    CMP r0,r4
    BEQ .find_keypress_loop
    JUC r15

.RETLOC "0"
.NF_TEXT "Command Not Found."
.LS "ls"
.NA "Not allowed."
.KERNEL "kernel"
.LS_LN1 "kernel 03fb | ls 00a4 | clock 0017 | helloworld 0034"
.CLOCK "clock"
.HELLOWORLD_T "Hello World!!!"
.HELLOWORLD "helloworld"
.IS_LS ""
.IS_CLK ""
.IS_KERN ""
.IS_HELL ""
