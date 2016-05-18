;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 06
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;---------------------------------
; Instructions
;---------------------------------

	LEA R0, PROMPT1						; Outputs prompt to ask user to enter a character
	PUTS
	
	GETC								; Gets character from user
	OUT
	
	LD R1, SUB_FIND_ONES_3200			; Loads the address of the subroutine SUB_FIND_ONES_3200 
										;    into R1.
	JSRR R1								; Jumps to address of subroutine in R1
	
	LEA R0, PROMPT2						; Loads the prompt that tells user how many 1's were in
	PUTS								;   the binary of character inputted

	ST R2, ALL_ONES						; Stores the value in R2 (the number of 1's) into address 
										;    labelled ALL_ONES
	LD R0, ALL_ONES						; R0 <-- the value in the address labelled ALL_ONES
	OUT									; Outputs that amount
	
	HALT
;---------------------------------
; Local Data
;---------------------------------

	PROMPT1		.STRINGZ	"Please input one single character from the keyboard: "
	PROMPT2		.STRINGZ	"\n\nThe number of 1's is: "
	SUB_FIND_ONES_3200	.FILL	x3200
	ALL_ONES	.FILL		#0
	
	
.end



;----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_ONES_3200
; Input (R0): A character from input to find the 1's from
; Postcondition: The subroutine finds out how many 1's are in the binary digit of the inputted
;					parameter value.
; Return Value: (R2) <-- number of 1's in the binary digit of parameter
;----------------------------------------------------------------------------------------------

.orig x3200
;----------------------------------
; Subroutine Instructions
;----------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R0, BACKUP_R0_3200
	ST R1, BACKUP_R1_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R5, BACKUP_R5_3200
	ST R7, BACKUP_R7_3200
	
; (2) Subroutine's Algorithm

	LD R1, LAST_NUM						; Loads the binary number for 10^15 in R1
	AND R2, R2, #0						; Sets the value in R1 to #0
	LD R3, COUNTER						; R3 <-- the value in the address labelled COUNTER
	
NEXT_SHIFT:								; Beginning of loop to find the value of the MSB

	AND R4, R0, R1						; Determines whether MSB was a 1 or 0
	BRz SKIP_ZERO
		ADD R2, R2, #1					; If it wasn't a 0, it adds #1 to value in R2
	SKIP_ZERO
	
	ADD R0, R0, R0						; Multiplies value in R0 by 2, thus left shifting bits
	
	ADD R3, R3, #-1						; Subtracts the counter stored in R3 by #1
	BRzp NEXT_SHIFT 
	
	LD R5, CHAR_OFFSET
	
	ADD R2, R2, R5

; (3) Restore registers 

	LD R0, BACKUP_R0_3200
	LD R1, BACKUP_R1_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R5, BACKUP_R5_3200
	LD R7, BACKUP_R7_3200

; (4) Return back to main

	RET
;---------------------------------
; Subroutine Data
;---------------------------------

	BACKUP_R0_3200	.BLKW	#1
	BACKUP_R1_3200	.BLKW	#1
	BACKUP_R3_3200	.BLKW 	#1
	BACKUP_R4_3200	.BLKW	#1
	BACKUP_R5_3200	.BLKW	#1
	BACKUP_R7_3200	.BLKW	#1
	LAST_NUM	.FILL	x8000
	COUNTER		.FILL	#15
	CHAR_OFFSET	.FILL		#48
