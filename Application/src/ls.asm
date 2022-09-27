@INC_LABELS("memory_map.ln")
@START_ADDR(.SOFTWARE_ENTRY)
  #r0 = kernel sd block
  MOVI 0, r0
  #r1 = kernel length
  MOVI 0, r1
  #load first 256 words into .SD
  LDSD r0, r1
  #r3 is iterator
  MOVI -1, r3
  #r8 stores 256
  MOVI 127, r8
  ADDI 127, r8
  ADDI 2, r8
.file_loop
  MOVI .SD(r3,1),r10
.str_loop
  #increment r3
  ADDI 1, r3
  #check if we should increment the block
  CMP r8, r3
  BEQ .ld_next
  #get SD card value into r4
  LOAD r4, .SD(r3)

  #jump if NULL terminated
  CMPI 0, r4
  BEQ .end_str

  #jump to start of loop
  JUC .str_loop
.end_str
  #found the end of the first entry
  #r3 contains the word address of the null terminator

  #set r0 to the kernel sd block from the FAT
  LOAD r0, .SD(r3,1)
  #set r1 to the kernel length from the FAT
  LOAD r1, .SD(r3,2)
  MOVI .VGA(r14),r11
  JAL r15,.PRINT_STR
  ADDI 1,r11
  JAL r15,.PRINT_WORD_HEX
  #set r3 to -256
  MOVI 0, r3
  SUB r8, r3
.kernel_copy_block
  #increment r3 by 256
  ADD r8, r3
  #check if we have reached the end of the kernel
  CMP r1, r3
  BGE .end
  #If not, we copy words from SD card
  #LDSD r0, r3
  #r2 is sd card memory mapped address incrementer
  MOV .SD(r3), r2
  SUBI 1, r2
  #set r4 to be page increment stop register
  MOV .SD(r3),r4
  ADD r8, r4
  #set r5 to be copy destination
  MOV r3, r5
  SUBI 1, r5

.ld_next
  ADDI 1, r1
  LDSD r0,r1
  MOVI -1,r3
  BUC .first_fat_loop

.end
  MOVI 0, r0
  JUC .KERNEL_ENTRY

.firm_err
  JUC .PROMPT
