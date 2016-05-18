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

;--------------------------------------------------------------------------------------------------------------------
; Test Harness for SUB_TO_UPPER subroutine:
; 
; (1) R0 ﬂ Some address where we will store a user-input string
; (2) Call SUB_TO_UPPER subroutine
; (3) Trap x22 (i.e. print out the now-uppercase string)
;--------------------------------------------------------------------------------------------------------------------
.orig x3000
;----------------------------------------
; Instructions
;----------------------------------------

	LEA R0, PROMPT					; Prompts the user to enter a string
	PUTS
	
	LD R0, ARRAY					; Loads the address where the user inputted string will go to R0
	
	LD R1, SUB_TO_UPPER_3200		; Jumps to subroutine that will set string to uppercase
	JSRR R1
	
	LEA R0, NEWLINE
	PUTS
	
	LD R0, ARRAY					; Loads the address where the new string is stored
	PUTS							; Outputs new string

	HALT
;----------------------------------------
; Data
;----------------------------------------
	PROMPT		.STRINGZ		"Please enter a string to convert to uppercase: "
	NEWLINE		.STRINGZ		"\n\n"
	SUB_TO_UPPER_3200		.FILL		x3200
	ARRAY		.FILL			x3400
	
.end


;--------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_TO_UPPER_3200
; Parameter (R0): Address to store a string at
; Postcondition: The subroutine has allowed the user to input a string,
; terminated by the [ENTER] key, has converted the string
; to upper-case, and has stored it in a null-terminated array that
; starts at (R0).
; Return Value: R0 ﬂ The address of the now upper case string.
;--------------------------------------------------------------------------------------------------------------------

.orig x3200
;----------------------------------------
; Subroutine Instructions
;----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value
	ST R0, BACKUP_R0_3200
	ST R1, BACKUP_R1_3200
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R7, BACKUP_R7_3200
	
; (2) Subroutine's Algorithm	
	
	LD R2, UPPER_3200			; Loads the value that will set letters to uppercase
	AND R3, R0, #-1				; Copies value in R0 to R3
	LD R4, SPACE_OFFSET			; Loads the offset for a space character in R4

LOOP_3200:
	GETC
	OUT
	
	ADD R1, R0, #-10			; If character entered was a newline character, end loop
	BRz END_STRING
	
	ADD R1, R4, R0				; If R1 + R4 != 0, then entered character was not a space, so we skip
	BRnp NOT_SPACE_3200
		STR R0, R3, #0			; Stores the space character into the array
		ADD R3, R3, #1
		BRnzp NEXT_3200

NOT_SPACE_3200:
	
	AND R1, R0, R2				; ANDs the uppercase offset with the character, giving us the uppercase 
	STR R1, R3, #0				; Stores new uppercase character into the array
	ADD R3, R3, #1

NEXT_3200:

	BRnzp LOOP_3200
	
END_STRING:
	ADD R3, R3, #1
	AND R0, R0, #0
	STR R0, R3, #0
	STR R0, R3, #0
	
; (3) Restore registers 

	LD R0, BACKUP_R0_3200
	LD R1, BACKUP_R1_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R7, BACKUP_R7_3200
	
; (4) Return back to main	
	
	RET

	HALT
;----------------------------------------
; Subroutine Data
;----------------------------------------

	UPPER_3200			.FILL		x005F
	SPACE_OFFSET		.FILL		#-32
	BACKUP_R0_3200		.BLKW		#1
	BACKUP_R1_3200		.BLKW		#1
	BACKUP_R2_3200		.BLKW		#1
	BACKUP_R3_3200		.BLKW		#1
	BACKUP_R4_3200		.BLKW		#1
	BACKUP_R7_3200		.BLKW		#1

.end

