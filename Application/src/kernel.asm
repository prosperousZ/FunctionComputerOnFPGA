@INC_LABELS("memory_map.ln")
@START_ADDR(.KERNEL_ENTRY)
.PROGID "k3rn3l"
#check if the kernel is attempting to load itself
MOV .PROGID(r0),r10
MOV .SOFTWARE_ENTRY(r0),r11
MOVI 0,r1

JAL r15,.STR_EQ

CMPI 0,r12
JNE .EXIT

#r5 will hold screen location
MOVI 0,r0
#r6 is column
MOV r0,r6
#r7 is row
MOVI 16,r7


MOVI 0x00,r2
LUI 0xD0,r2

.prompt

MOV .VGA(r0),r5
#show bash prompt
MOVI 0x3E,r1
LUI 63,r1
STOR r1,r5
ADDI 1,r5
MOVI 1,r6

.find_keypress


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


SUBI 0x01,r5
SUBI 1,r6
MOV .VGA(r0),r7
CMP r5,r7
BEQ .find_keypress

STOR r0,r5

BUC .find_keypress


.enter
  MOV r5,r11
  MOVI 0,r1

  #CHECK FOR found files
  MOV .VGA(r0),r10
  ADDI 1,r10
  MOV .LS(r0),r11
  JAL r15,.load_file


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

  #If there was a file found, jump to load point
  MOV .found_file(r0),r10
  LOAD r12,r10
  CMP r0,r12
  BNE .SOFTWARE_ENTRY

  MOV .NF_TEXT(r0),r10
  MOV .VGA(r0),r11
  ADDI 80,r11
  MOVI 0,r1

  JAL r15,.PRINT_STR

  JUC .prompt

.KERN_RUN


  MOV .NA(r0),r10
  MOV .VGA(r0),r11
  ADDI 80,r11
  MOVI 0,r1
  JAL r15,.PRINT_STR

  JUC .prompt

.LS_RUN


  MOV .LS_LN1(r0),r10
  MOV .VGA(r0),r11
  ADDI 80,r11
  MOVI 0,r1
  JAL r15,.PRINT_STR

  JUC .prompt


.PRINT_WORD_HEX

  MOVI 0xF0,r8
  LUI 0xFF,r8

  .p_hex_run

  CMPI 0,r8
  JEQ r15
  ADDI 4,r8
  MOV r10,r9
  LSH r8,r9
  ANDI 0x0f,r9
  CMPI 9,r9
  BLO .p_ltr
  LOAD r13,.COLOR(r0)
  OR r13,r9
  ADDI 0x30,r9
  STOR r9,r11

  ADDI 1,r11
  BUC .p_hex_run

  .p_ltr

  LUI 63,r9
  ADDI 0x37,r9
  STOR r9,r11
  ADDI 1,r11
  BUC .p_hex_run

.PRINT_STR


  LOAD r1,r10


  CMPI 0,r1
  JEQ r15


  LUI 63,r1

  STOR r1,r11



  ADDI 1,r10
  ADDI 1,r11
  MOVI 0,r1

  BUC .PRINT_STR

.STR_EQ

  MOVI 0,r12
  .str_eq_loop


    LOAD r8,r10




    LOAD r9,r11




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

    BUC .str_eq_loop
  .str_true


    MOVI 1,r12


    JUC r15

.GET_KEY

    MOVI 0,r1

  .find_keypress_loop
    ADDI 1,r1
    CMPI 0x7f,r1
    BEQ .GET_KEY
    MOV r1,r3
    ADD r2,r3
    LOAD r4,r3

    CMP r0,r4
    BEQ .find_keypress_loop
    JUC r15

.EXIT
  MOVI .NA(r0),r10
  MOVI .VGA(r0),r11
  ADDI 80,r11
  JAL r15,.PRINT_STR
  JUC .PROMPT

.SET_PRINT_COLOR
  LSHI 8,r10
  STOR r10,.COLOR(r0)
  JUC r15

#color code for white foreground and black background
.COLOR "?"
.RETLOC "0"
.NF_TEXT "Command Not Found."
.NA "Not allowed."
.KERNEL "kernel"
.found_file ""
