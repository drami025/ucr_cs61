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

	LD R1, SUB_GET_STRING
	LD R0, ADDRESS_OF_ARRAY
	
	JSRR R1
	
	PUTS
	
	LD R1, SUB_IS_A_PALINDROME_3600
	JSRR R1
	
	
	
	HALT
;------------------------------
; Data
;------------------------------
	ADDRESS_OF_ARRAY		.FILL		x3100
	SUB_GET_STRING			.FILL		x3200
	SUB_IS_A_PALINDROME_3600	.FILL	x3600
	

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
	BRnp GET_CHAR_ARRAY			; Decrements to the previous address in array
	
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

;----------------------------------------------------------------------------------------------
; Subroutine: SUB_RIGHT_SHIFT_3400
; Input (R5): A character from input to right shift bits
; Postcondition: The subroutine rights shifts all the bits in the inputted parameter
;					
; Return Value: (R5) <-- the right shifted value of the parameter
;----------------------------------------------------------------------------------------------

.orig x3400
;------------------------------
; Subroutine Instructions
;------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R0, BACKUP_R0_3400
	ST R1, BACKUP_R1_3400
	ST R2, BACKUP_R2_3400
	ST R3, BACKUP_R3_3400
	ST R4, BACKUP_R4_3400
	ST R7, BACKUP_R7_3400

; (2) Subroutine's Algorithm

	LD R1, LAST_NUM				; R1 <-- value stored in address labelled LAST_NUM
	AND R2, R2, #0				; Sets value in R2 to #0
	LD R3, COUNTER				; R3 <-- value stored in address labelled COUNTER
	
NEXT_SHIFT:

	AND R4, R1, R5				; Compares MSB, loads into R4
	BRz SKIP_ONE				; If MSB is a 1, skip this part
		ADD R5, R5, R5			; Left shifts bits 
		ADD R5, R5, #1			; Adds 1 to LSB to rotate overflowed 1
		BRnzp SKIP_ZERO			; Skips to SKIP_ZERO if it was a 1
		
SKIP_ONE:
	
		ADD R5, R5, R5			; If it was a zero, all we do is left shift
		
SKIP_ZERO: 						

		ADD R3, R3, #-1			; Adds #-1 to the counter, continues loop while positive
		BRp NEXT_SHIFT
		
		ADD R5, R5, #0			; 
		BRzp NOT_ODD
			LD R1, RESTORE_ODD
			AND R5, R5, R1
NOT_ODD:

; (3) Restore registers 

	LD R0, BACKUP_R0_3400
	LD R1, BACKUP_R1_3400
	LD R2, BACKUP_R2_3400
	LD R3, BACKUP_R3_3400
	LD R4, BACKUP_R4_3400
	LD R7, BACKUP_R7_3400

; (4) Return 

	RET


	HALT
;------------------------------
; Subroutine Data
;------------------------------

	BACKUP_R0_3400	.BLKW	#1
	BACKUP_R1_3400	.BLKW	#1
	BACKUP_R2_3400	.BLKW	#1
	BACKUP_R3_3400	.BLKW	#1
	BACKUP_R4_3400	.BLKW	#1
	BACKUP_R7_3400	.BLKW	#1
	LAST_NUM		.FILL	x8000
	COUNTER			.FILL	#15
	RESTORE_ODD		.FILL	#32767
.end

;--------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_IS_A_PALINDROME_3600
; Parameter (R0): The address of a string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R0) is
; 					a palindrome or not returned a flag indicating such.
;Return Value: R4 ﬂ {1 if the string is a palindrome, 0 otherwise}
;--------------------------------------------------------------------------------------------------------------------

.orig x3600
;---------------------------------
; Subroutine Instructions
;---------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3600
	ST R0, BACKUP_R0_3600
	ST R1, BACKUP_R1_3600
	ST R2, BACKUP_R2_3600
	ST R3, BACKUP_R3_3600
	ST R5, BACKUP_R5_3600
	ST R6, BACKUP_R6_3600

; (2) Subroutine's Algorithm
	
	AND R2, R5, #-1					; Copies value in R5 to R2
	LD R1, SUB_RIGHT_SHIFT_3400		; Loads address of subroutine to R1
	JSRR R1							; Jumps to SUB_RIGHT_SHIFT_3400 subroutine
	
	AND R4, R4, #0					; Initializes value in R4 to #0
	
	AND R6, R0, #-1					; Copies value of R0 to R6
	ADD R6, R6, R2					; Adds value of R2, which is number of characters in array, to R6
	ADD R6, R6, #-1					; Subtracts value in R6 by #-1
	
IS_PALINDROME_LOOP:

	LDR R1, R0, #0					; Loads the value in address pointed to by R0 to R1
	LDR R3, R6, #0					; Loads the value in address pointed to by R6 to R3
	
	NOT R1, R1						; Inverts value in R1 to a negative number
	ADD R1, R1, #1
	ADD R1, R1, R3					; So long as (R1) + (R3) is #0, word can still be a palindrome
	BRnp NOT_PALINDROME
	
	ADD R0, R0, #1					; Increments address stored in R0, going up the array from the beginning
	ADD R6, R6, #-1					; Decrements address stored in R6, going down the array from the end.
	ADD R5, R5, #-1					; Decrements the value in R5(half the array). Ends once we get to the middle of array
	BRp IS_PALINDROME_LOOP
	
	ADD R4, R4, #1					; Adds #1 to value in R4
	
NOT_PALINDROME:

; (3) Restore registers 

	LD R7, BACKUP_R7_3600
	LD R0, BACKUP_R0_3600
	LD R1, BACKUP_R1_3600
	LD R2, BACKUP_R2_3600
	LD R3, BACKUP_R3_3600
	LD R5, BACKUP_R5_3600
	LD R6, BACKUP_R6_3600

; (4) Return back to main
	
	RET

	HALT
;---------------------------------
; Subroutine Data
;---------------------------------

	BACKUP_R7_3600			.BLKW	#1
	BACKUP_R0_3600			.BLKW	#1
	BACKUP_R1_3600			.BLKW	#1
	BACKUP_R2_3600			.BLKW	#1
	BACKUP_R3_3600			.BLKW	#1
	BACKUP_R5_3600			.BLKW	#1
	BACKUP_R6_3600			.BLKW	#1
	SUB_RIGHT_SHIFT_3400	.FILL		x3400

.end
