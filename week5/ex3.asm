;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 05
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;----------------------------------
; Instructions
;----------------------------------

GO_BACK:
BACK_TO_START:

	LD R1, SUB_16_BIT_2S_COMP_3200		; R1 <-- Loads the address of the subroutine  
	LD R2, TOTAL				; R2 <-- Loads the value stored in the address labelled TOTAL
	LD R4, B_CHECK
	LD R3, COUNTER_16			; R3 <-- Loads the value stored in the address labelled OFFSET
	LD R5, OFFSET

	LEA R0, PROMPT				; R0 <-- Loads the address of label PROMPT
	PUTS					; Prints out string

	GETC					; Gets first character, which should be 'b'
	OUT

	ADD R4, R0, R4				; Adds #-98 to value in R0. If it is not #0, then it is not a 'b' char.
	BRz CONTINUE				; If it is #0, continue on to main loop.
		LEA R0, ERROR_B			; If not a 'b' char, then prompt tells user to try again.
		PUTS
		BRnzp GO_BACK			; Go back to the beginning if not a 'b' char
CONTINUE:

LOOP:
IS_SPACE:

	LD R4, SPACE_OFFSET			; R4 <-- the value stored in address labelled SPACE_OFFSET	

	GETC					; R0 <-- character inputted by user.
	OUT
	
	ADD R4, R4, R0				; Adds #-32 to value in R0. If it is #0, then character was a
	BRz IS_SPACE				;  "space" character. Branch takes them back to beginning of loop.

	LD R4, IS_ZERO				; Adds #-48 to value in R0. If it is #0, then character was a 
	ADD R4, R0, R4				;    '0'. They continue with the rest of the loop.
	BRz NO_NEG_ERROR

	LD R4, IS_ONE				; Adds #-49 to value in R0. If it is #0, then character was a 
	ADD R4, R0, R4				;   '1'. They continue with the rest of the loop.
	BRz NO_POS_ERROR

	LEA R0, ERROR_01			; If they didn't meet previous criteria, then the character inputted was
	PUTS					;   an incorrect value. 

	BRnzp BACK_TO_START			; Incorrect value means they go back to the beginning of program.

NO_NEG_ERROR:
NO_POS_ERROR:

	

	ADD R4, R0, R5				; R4 <-- Adds #-48 to the character in R0 to get binary 1 or 0

	ADD R2, R2, R2				; Multiplies R2 by 2

	ADD R2, R2, R4				; Adds the number in R4 to R2

	ADD R3, R3, #-1				; Adds #-1 to the counter
	BRp LOOP

	LD R0, NEWLINE				; New line
	OUT

	JSRR R1					; Jumps to subroutine

	HALT
	
	SUB_16_BIT_2S_COMP_3200	.FILL	x3200
	IS_ZERO		.FILL	#-48
	IS_ONE		.FILL	#-49
	SPACE_OFFSET	.FILL	#-32
	NEWLINE		.FILL	#10
	TOTAL		.FILL	#0
	COUNTER_16	.FILL	#16
	OFFSET		.FILL	#-48
	B_CHECK		.FILL	#-98
	PROMPT		.STRINGZ	"\nEnter a 16-bit binary digit (with a 'b' in front): \n"
	ERROR_B		.STRINGZ	"\n\nFirst letter was not a 'b'. Try again.\n"
	ERROR_01	.STRINGZ	"\n\nYou must enter a '0' or '1' after 'b'. Try again. \n"


;----------------------------------------------------------------------------------------------
; Subroutine: SUB_16_BIT_2s_COMP_3200
; Input (R1): Some value to take the 2's complement of and turn into a 16-bit binary 
; Postcondition: The subroutine has take the 2's complement of (R1) and turned into a 16-bit
;			binary word. Stores it back into array.
; Return Value: None, it is a void function.
;----------------------------------------------------------------------------------------------


.orig x3200
;---------------------------------------
; Subroutine Instructions
;---------------------------------------	

; (1) Backup R7 & any registers used in the subroutine except Return Value
	
	ST R7, BACKUP_R7_3200
	ST R5, BACKUP_R5_3200
	ST R4, BACKUP_R4_3200
	ST R3, BACKUP_R3_3200
	ST R2, BACKUP_R2_3200
	ST R1, BACKUP_R1_3200


; (2) Subroutine's Algorithm
		
	LDR R2, R1, #0			; R2<-- Loads the value in the address in R1

	ST R2, NUM	
	LD R1, NUM		; Loads xABCD into R1.
	LD R2, CMP		; Loads #32767 into R2.
	LD R3, SP_COUNT		; Loads #4 into R3.
	LD R4, COUNT		; Loads #16 into R4.

	NOT R2, R2		; Inverts the bits in R2.

	LD R0, LETTERB
	OUT

	LOOP2:			; Beginning of "Loop" loop.

	
	AND R5, R1, R2		; Compares the MSB of content in R1 and R2,
				;   and loads it into R5.
	BRz ELSE		; If the previous operation gave 0, skips to "ELSE:".

	LD R0, ONE		; Loads #49 into R0.
	OUT			; Prints out contents in R0, which is #49 ('1').

	BRnzp END		; Branch statement is used here to skip printing
				;   '0' if AND operation gave us a non-zero.

	ELSE:			; If AND operation gave us #0, perform next lines of code.
	
	LD R0, ZERO		; Loads #48 into R0.
	OUT			; Prints out contents in R0, which is #48 ('0').
	
	END:			; If we printed out a '1', program continues here.
	
	ADD R3, R3, #-1		; Reduces value in R3 by 1.
	BRnp SKIP		; Once value in R3 is reduced by 1, enter this branch,
				;  else it moves on to SKIP.
	
		LEA R0, SPACE	; Loads SPACE string into R0.
		PUTS		; Prints string stored in R0.

		LD R3, SP_COUNT	; Reinitializes value in R3 to #4 (or loads #4 to R3).
	SKIP:
		
	ADD R1, R1, R1		; Multiplies value in R1 by 2, thus left-shifting all bits
				;   stored in R1.

	ADD R4, R4, #-1		; Reduces the value stored in R4 by #-1.
	
	BRp LOOP2		; Once the value stored in R4 falls to zero, loop finishes.

; (3) Restore registers 

	LD R7, BACKUP_R7_3200
	LD R5, BACKUP_R5_3200
	LD R4, BACKUP_R4_3200
	LD R3, BACKUP_R3_3200
	LD R2, BACKUP_R2_3200
	LD R1, BACKUP_R1_3200

; (4) Return back to main
	
	RET

	HALT
;---------------------------------------
; Subroutine Data
;---------------------------------------
	BACKUP_R7_3200		.BLKW	#1
	BACKUP_R5_3200		.BLKW	#1
	BACKUP_R4_3200		.BLKW	#1
	BACKUP_R3_3200		.BLKW	#1
	BACKUP_R2_3200		.BLKW	#1
	BACKUP_R1_3200		.BLKW	#1

	CMP	.FILL	#32767		; Put #32767 into memory here (used to get 1000....0000
					;  in program).
	NUM	.FILL	xABCD		; Put xABCD into memory here (number to be converted).
	COUNT	.FILL	#16		; Put #16 into memory here. Also counter for outer
					;   loop.
	SP_COUNT	.FILL	#4	; Put #4 into memory here. Also counter for SPACE loop.

	LETTERB		.FILL	#98
	SPACE	.STRINGZ	" "	; Put string " " into memory here. Used for spacing.
	ONE	.FILL	#49		; Put #49 (ASCII '1') into memory here.
	ZERO	.FILL	#48		; Put #48 (ASCII '0') into memory here.

.end
