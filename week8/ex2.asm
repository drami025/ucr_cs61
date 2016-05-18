;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 08
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

;-----------------------------------------------------------------------------------------------
; Test Harness for SUB_PRINT_OPCODES subroutine:
; (1) Call SUB_TO_UPPER subroutine
;-----------------------------------------------------------------------------------------------
.orig x3000
;---------------------------------
; Instructions
;---------------------------------
	
	LD R0, SUB_PRINT_OPCODES_3200
	JSRR R0
	
	HALT
;---------------------------------
; Data
;---------------------------------
	SUB_PRINT_OPCODES_3200		.FILL	x3200
.end

.orig x3200
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODES_3200
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;           and corresponding opcode in the following format:
;           ADD = 0001
;           AND = 0101
;           BR = 0000
;           …
; Return Value: None
;-----------------------------------------------------------------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3200
	ST R1, BACKUP_R1_3200
	ST R2, BACKUP_R2_3200

; (2) Subroutine's Algorithm
	
	LD R1, ARRAY_TO_OPS
	LD R2, ARRAY_TO_INST
	
PRINT_LINE:

PRINT_STRING:					; This loop prints out the strings in the ARRAY_TO_INST array
	LDR R0, R2, #0
	OUT
	ADD R2, R2, #1
	LDR R3, R2, #0
	ADD R3, R3, #0
	BRp PRINT_STRING			; While the number in R3 is some character, this will always be positive
	
	ADD R3, R3, #0				; If the number in R3 is negative, we have reached the end of string array.
	BRn BREAK					
	
	LDR R4, R1, #0
	
	LD R0, SUB_PRINT_BIN_3400	; This subroutine will print out the number in binary that correlates to the string
	JSRR R0
	
	ADD R1, R1, #1
	
	LD R0, NEWLINE_3200			
	OUT
	
	
	BRnzp PRINT_LINE
	
BREAK: 
	
; (3) Restore registers 
	
	LD R7, BACKUP_R7_3200
	LD R1, BACKUP_R1_3200
	LD R2, BACKUP_R2_3200
	
; (4) Return back to main
	
	RET
	
	HALT

;------------------------------------------------
; Subroutine Data
;------------------------------------------------
	
	BACKUP_R7_3200		.BLKW		#1
	BACKUP_R1_3200		.BLKW		#1
	BACKUP_R2_3200		.BLKW		#1
	NEWLINE_3200		.FILL		#10
	ARRAY_TO_OPS		.FILL		x3301
	ARRAY_TO_INST		.FILL		x3351
	SUB_PRINT_BIN_3400	.FILL		x3400
	
		
.end


;---------------------------------------------------
; Array that holds the op-code numbers
;---------------------------------------------------
.orig x3300

	HALT
;---------------------------------------------------
; Array Data
;---------------------------------------------------	
	ADD_OP			.FILL		#1
	AND_OP			.FILL		#5
	BR_OP			.FILL		#0
	JMP_OP			.FILL		#12
	JSR_OP			.FILL		#4
	JSRR_OP			.FILL		#4
	LD_OP			.FILL		#2
	LDI_OP			.FILL		#10
	LDR_OP			.FILL		#6
	LEA_OP			.FILL		#14
	NOT_OP			.FILL		#9
	RET_OP			.FILL		#12
	RTI_OP			.FILL		#8
	ST_OP			.FILL		#3
	STI_OP			.FILL		#11
	STR_OP			.FILL		#7
	TRAP_OP			.FILL		#15
	
.end

;----------------------------------------------------
; Array that holds the op-code instruction strings
;----------------------------------------------------

.orig x3350

	HALT
;----------------------------------------------------
; Array Data
;----------------------------------------------------	
	ADD_INST		.STRINGZ		"ADD = "
	AND_INST		.STRINGZ		"AND = "
	BR_INST			.STRINGZ		"BR = "
	JMP_INST		.STRINGZ		"JMP = "
	JSR_INST		.STRINGZ		"JSR = "
	JSRR_INST		.STRINGZ		"JSRR = "
	LD_INST			.STRINGZ		"LD = "
	LDI_INST		.STRINGZ		"LDI = "
	LDR_INST		.STRINGZ		"LDR = "
	LEA_INST		.STRINGZ		"LEA = "
	NOT_INST		.STRINGZ		"NOT = "
	RET_INST		.STRINGZ		"RET = "
	RTI_INST		.STRINGZ		"RTI = "
	ST_INST			.STRINGZ		"ST = "
	STI_INST		.STRINGZ		"STI = "
	STR_INST		.STRINGZ		"STR = "
	TRAP_INST		.STRINGZ		"TRAP = "
	NULL			.FILL			#-1

;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_BIN_3200
; Parameters: (R4) <-- The number to be printed out as a binary number
; Postcondition: The subroutine has printed out a number in binary
; Return Value: None
;-----------------------------------------------------------------------------------------------
.orig x3400
;-----------------------------------------
; Subroutine Instructions
;-----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3400
	ST R0, BACKUP_R0_3400
	ST R4, BACKUP_R4_3400
	ST R2, BACKUP_R2_3400
	
; (2) Subroutine's Algorithm	
	
	AND R2, R2, #0				
	ADD R2, R2, #4			; This part sets the value in R2 to #4

PRINT_ONES_ZEROS:

	AND R0, R4, #8			; Ands #8 to value in R0 to find the 4th binary digit
	BRz PRINT_ZERO			; If ANDing it was #0, we print out a zero and skip this part
		LD R0, ONE			; If ANDing it was not #0, we print out a one here
		OUT
		BRnzp SKIP_ZERO
		
PRINT_ZERO:
	LD R0, ZERO				; Print out a zero here.
	OUT
	
SKIP_ZERO:

	ADD R4, R4, R4			; Left shifts the bits in the value of R4
	ADD R2, R2, #-1			; Loop only iterates 4 times.
	BRp PRINT_ONES_ZEROS
	
; (3) Restore registers 	
	
	LD R7, BACKUP_R7_3400
	LD R0, BACKUP_R0_3400
	LD R4, BACKUP_R4_3400
	LD R2, BACKUP_R2_3400
	
; (4) Return back to main	
	
	RET
	
	HALT
	
	BACKUP_R7_3400		.BLKW		#1
	BACKUP_R0_3400		.BLKW		#1
	BACKUP_R4_3400		.BLKW		#1
	BACKUP_R2_3400		.BLKW		#1
	ONE				.FILL			#49
	ZERO				.FILL			#48
	
.end
