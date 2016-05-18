;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 07
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;-------------------------------
; Instructions
;-------------------------------

	LD R1, SUB_GET_STRING				; Loads subroutine to R1
	LD R0, ADDRESS_OF_ARRAY				; Loads address of array to R0
	
	JSRR R1								; Jumps to subroutine in R1
	
	PUTS								; Outputs array in R0
	
	
	
	HALT
;------------------------------
; Data
;------------------------------
	ADDRESS_OF_ARRAY		.FILL		x3100
	SUB_GET_STRING			.FILL		x3200

.end

;--------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameter (R0): The address of where to start storing the string
; Postcondition: The subroutine has allowed the user to input a string,
; terminated by the [ENTER] key, and has stored it in an array
; that starts at (R0) and is NULL-terminated.
; Return Value: R5 ﬂ The number of non-sentinel characters read from the user
;--------------------------------------------------------------------------------------------------------------------

.orig x3200
;----------------------------------
; Subroutine Instructions
;----------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3200
	ST R0, BACKUP_R0_3200
	ST R1, BACKUP_R1_3200
	
; (2) Subroutine's Algorithm	
	
	AND R1, R0, #-1				; Copies value in R0 to R1
	
	LEA R0, SUB_PROMPT			; Asks user to enter a string of text
	PUTS
	
	AND R5, R5, #0				; Sets value in R5 to #0
	
GET_CHAR_ARRAY:

	GETC						; Gets character from user
	OUT
	
	STR R0, R1, #0				; Stores character into address of array
	ADD R1, R1, #1				; Increments to the next address in array
	ADD R5, R5, #1				; Adds #1 to value in R5
	
	ADD R0, R0, #-10			; Keeps getting characters until user enters a newline character
	BRnp GET_CHAR_ARRAY
	
	ADD R1, R1, #-1				; Decrements to the previous address in array
	AND R0, R0, #0				; Sets value in R0 to #0
	STR R0, R1, #0 				; Overwrites last value in array to null character
	
	ADD R5, R5, #-1				; Subtracts #-1 to value in R5
	
; (3) Restore registers 	
	
	LD R7, BACKUP_R7_3200
	LD R0, BACKUP_R0_3200
	LD R1, BACKUP_R1_3200
	
; (4) Return back to main	
	
	RET
	
	HALT
	
;-----------------------------------
; Subroutine Data
;-----------------------------------

	BACKUP_R7_3200		.BLKW		#1
	BACKUP_R0_3200		.BLKW		#1
	BACKUP_R1_3200		.BLKW		#1
	ENTER_OFFSET		.FILL		#-10
	SUB_PROMPT			.STRINGZ	"Please enter a string of text. Press [ENTER] when you're done.\n"
	
	
