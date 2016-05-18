;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Assignment 06
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;------------------------------------
; Instructions
;------------------------------------

	LD R0, SUB_GET_BIN_3200					;This part jump to SUB_GET_BIN_3200 subroutine
	JSRR R0

	LEA R0, ANSWER							; This part outputs a phrase letting user know 
	PUTS									;    what the number is in hexadecimal
	
	AND R4, R4, #0							; Sets the value in R4 to #0
	ADD R1, R1, #0							; If the value in R1 is negative, that means there was an
	BRzp IS_POS								;    overflow, so we require a different method to find hex's
		LD R0, SUB_IS_NEG_4000				; Jumps to subroutine that deals with overflowed numbers
		JSRR R0
IS_POS:

	LD R2, MAIN_HEX_ARRAY					; R2 <-- the value stored in the address labelled MAIN_HEX_ARRAY
	LD R3, X_CHAR							; R3 <-- the value stored in the address labelled X_CHAR
	STR R3, R2, #0							; Stores the letter 'x' in the first location of array
	
	LD R0, SUB_FIND_HEX_3600				; This part jumps to subroutine SUB_FIND_HEX_3600
	JSRR R0
	
	AND R0, R0, #0							; Sets value in R0 to #0
	ADD R0, R0, #10							; Adds #10 to value in R0
	OUT										; Outputs newline character to console
;---------------------------------------
; Data
;---------------------------------------
	HALT
	
	X_CHAR				.FILL	#120
	SUB_GET_BIN_3200		.FILL		x3200
	SUB_FIND_HEX_3600	.FILL	x3600
	MAIN_HEX_ARRAY		.FILL	x3705
	SUB_IS_NEG_4000		.FILL	x4000
	ANSWER			.STRINGZ	"\n\nYour number in HEX is: x"


;----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_BIN_3200
; Input: (none)
; Postcondition: The subroutine took character numbers taken from standard input, translates them to
; binary, and stores it in R1
; Return Value: (R1) <-- the binary number of the user's input
;----------------------------------------------------------------------------------------------
.orig x3200
;----------------------------------------
; Subroutine Instructions
;----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3200
	ST R0, BACKUP_R0_3200
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R5, BACKUP_R5_3200
	ST R6, BACKUP_R6_3200
	
; (2) Subroutine's Algorithm	
	
GO_BACK_3200:

	LEA R0, PROMPT_3200
	PUTS
	
	AND R1, R1, #0						; This part sets the values in R1, R6, and R5 to #0
	AND R6, R6, #0
	AND R5, R5, #0
	ADD R5, R5, #1						; Adds #1 to value in R5
	
LOOP_3200:

	GETC								; Gets character from user
	OUT
	
	ST R0, INPUT_3200					; Stores character taken from user to address labelled INPUT_3200
	LD R2, INPUT_3200					; R2 <-- the value in the address labelled INPUT_3200
	ADD R2, R2, #-10					; If the value in R2 is #10 (newline character), then skip next part
	BRz SKIP_TO_END_3200				
	
	LD R2, INPUT_3200					; R2 <-- the value in the address labelled INPUT_3200 
	LD R3, POS_CHAR_3200				; R3 <-- the value in the address labelled POS_CHAR_3200
	ADD R2, R2, R3						; If the value was a positive sign, we ignore it
	BRz SKIP_POS_3200
	
	LD R4, CHAR_COUNT_3200				
	ADD R4, R4, #1
	ST R4, CHAR_COUNT_3200
	
	LD R2, CHAR_OFFSET_3200				; Loads the character offset to R2 to add to user input
	ADD R0, R0, R2						; Subtracts offset to user input, getting binary number
	ADD R5, R5, #-1						 
	BRn SKIP_TENS_3200					
		LD R5, SUB_MULT_TEN_3400		; This subroutine multiplies value in R1 by 10.
		JSRR R5
SKIP_TENS_3200:

	ADD R1, R1, R0						; This is the final value that the hexadecimal number will be
										; 	derived from. 
SKIP_POS_3200:	
	
	BRnzp LOOP_3200
	
SKIP_TO_END_3200

; (3) Restore registers 
	
	LD R7, BACKUP_R7_3200
	LD R0, BACKUP_R0_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R5, BACKUP_R5_3200
	LD R6, BACKUP_R6_3200
	
; (4) Return	
	
	RET

	HALT
	
;----------------------------------------
; Subroutine Data
;----------------------------------------

	BACKUP_R7_3200		.BLKW		#1
	BACKUP_R0_3200		.BLKW		#1
	BACKUP_R1_3200		.BLKW		#1
	BACKUP_R2_3200		.BLKW		#1
	BACKUP_R3_3200		.BLKW		#1
	BACKUP_R4_3200		.BLKW		#1
	BACKUP_R5_3200		.BLKW		#1
	BACKUP_R6_3200		.BLKW		#1
	PROMPT_3200			.STRINGZ	"\nInput a positive number from #0 to #65535, then hit [ENTER].\n"
	POS_CHAR_3200		.FILL		#-43
	INPUT_3200			.FILL		#0
	CHAR_COUNT_3200		.FILL		#0
	CHAR_OFFSET_3200	.FILL		#-48
	SUB_MULT_TEN_3400	.FILL		x3400

.end

;--------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_MULT_TEN_3400
; Parameter (R1): The value to be multiplied by #10
; Postcondition: The value in R1 would have been multiplied by #10
; 				
;Return Value: (R1) <-- #10*(R1)
;--------------------------------------------------------------------------------------------------------------------

.orig x3400
;---------------------------------------
; Subroutine Instructions
;---------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3400
	ST R2, BACKUP_R2_3400
	ST R3, BACKUP_R3_3400
	
; (2) Subroutine's Algorithm	
	
	LD R2, TEN_3400					; R2 <-- the value stored in the address labelled TEN_3400
	AND R3, R1, #-1					; Copies the value of R1 into R3
	
LOOP_TEN_POW_3400:
	ADD R1, R1, R3					; Adds the value in R3 to R1
	ADD R2, R2, #-1					; Loop only happens 10 times
	BRp LOOP_TEN_POW_3400
	
; (3) Restore registers 	
	
	LD R7, BACKUP_R7_3400
	LD R2, BACKUP_R2_3400
	LD R3, BACKUP_R3_3400
	
; (4) Return back to main	
	
	RET
	
	HALT
	
;----------------------------------------
; Subroutine Data
;----------------------------------------

	BACKUP_R7_3400	.BLKW	#1
	BACKUP_R2_3400	.BLKW	#1
	BACKUP_R3_3400	.BLKW	#1
	TEN_3400		.FILL		#9
	
.end

;--------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_HEX_3600
; Parameter (R1): The value to take a hexadecimal number of.
; Postcondition: Outputs the hexadecimal of the number in R1 				
;Return Value: None 
;--------------------------------------------------------------------------------------------------------------------

.orig x3600
;-----------------------------------------
; Subroutine Instructions
;-----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3600
	ST R2, BACKUP_R2_3600
	ST R3, BACKUP_R3_3600
	ST R4, BACKUP_R4_3600
	ST R5, BACKUP_R5_3600
	
; (2) Subroutine's Algorithm	
	
	AND R5, R5, #0					; This parts sets value in R5 to #4
	ADD R5, R5, #4
	
	LD R2, POWS_16_3600				; Loads the address array with powers of 16 in them
									; Starts with 16^3
NEXT_16_3600:

	LDR R3, R2, #0					; Loads power of 16 to R3
	ADD R3, R3, #0
	BRn SKIP_THIS
	
	NOT R3, R3						; Gets the negative of the power of 16
	ADD R3, R3, #1
	
SKIP_THIS:	
LOOP_3600:
	
	ADD R1, R1, R3					; Adds negative power of 16 to value in R1.
	BRn BREAK_LOOP_3600				; Loop breaks when value in R1 is a negative number
	
	ADD R4, R4, #1					; Counts how many times we subtracted power of 16 to R1
	BRnzp LOOP_3600
	
BREAK_LOOP_3600:
		
	NOT R3, R3						; Inverts power of 16 back to positive number
	ADD R3, R3, #1			
	ADD R1, R1, R3					; Adds power of 16 back to value in R1 to make positive again
	
	ADD R2, R2, #1					; Goes to the address of the next smallest power of 16
	
	LD R3, SUB_PRINT_HEX_3800		; Jumps to subroutine SUB_PRINT_HEX_3800
	JSRR R3
	
	AND R4, R4, #0					; Resets value in R4 to #0
	ADD R5, R5, #-1					; Subtracts #-1 from the counter. Only iterates 4 times.
	BRp NEXT_16_3600
	
; (3) Restore registers 	
	
	LD R7, BACKUP_R7_3600
	LD R2, BACKUP_R2_3600
	LD R3, BACKUP_R3_3600
	LD R4, BACKUP_R4_3600
	LD R5, BACKUP_R5_3600
	 
; (4) Return back to main		 
	 
	RET 
	 
	HALT
;-----------------------------------------
; Subroutine Data
;-----------------------------------------
	
	BACKUP_R7_3600		.BLKW		#1
	BACKUP_R2_3600		.BLKW		#1
	BACKUP_R3_3600		.BLKW		#1
	BACKUP_R4_3600		.BLKW		#1
	BACKUP_R5_3600		.BLKW		#1
	POWS_16_3600		.FILL		x3701
	SUB_PRINT_HEX_3800	.FILL		x3800
.end

;=======================================================================
; This is were powers of 16 and hexadecimal array is stored 
;=======================================================================
.orig x3700
;------------------------------------------
; Remote Instructions (none)
;------------------------------------------

	HALT
	
;------------------------------------------
; Remote Data for Subroutine 3600
;------------------------------------------	
		
	SUB_16_FOURTH_3600		.FILL	#4096
	SUB_16_THIRD_3600		.FILL	#256
	SUB_16_SECOND_3600		.FILL	#16
	SUB_16_FIRST_3600		.FILL	#1
	HEX_ARRAY				.BLKW	#5
	
.end


;--------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_HEX_3800
; Parameter (R4): The value to get the hexidecimal value from
; Postcondition: Outputs the hexadecimal from number stored in R4				
;Return Value: None 
;--------------------------------------------------------------------------------------------------------------------
.orig x3800
;-------------------------------------------
; Subroutine Instructions
;-------------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3800
	ST R0, BACKUP_R0_3800
	ST R1, BACKUP_R1_3800
	ST R2, BACKUP_R2_3800
	ST R3, BACKUP_R3_3800
	
; (2) Subroutine's Algorithm	
	
	AND R0, R0, #0						; Sets value in R0 to #0
	AND R1, R1, #0						; Sets value in R1 to #0
	ADD R1, R1, #-10					; Adds #-10 to R1
	LD R3, HEX_ARRAY_3800				; Loads address of array where hexadecimal number will be stored
	
	ADD R1, R1, R4						; Adds value in R1 to R4. If R1 becomes negative, we have a 
	BRzp NOT_NUMBER						; hexadecimal number 0 - 9 
		LD R2, NUM_CHAR_OFFSET			; Loads character offset
		ADD R0, R4, R2					; Adds #48 to R4 to get character of the binary number
		OUT								; Outputs that character to console
		STR R0, R3, #0					; Stores that character to array
		ADD R3, R3, #1					; Moves to next address in array
		ST R3, HEX_ARRAY_3800			; Stores that new address to HEX_ARRAY_3800
		BRnzp END_3800

NOT_NUMBER:
	
	LD R2, OVER_TEN_OFFSET				; If value in R4 is greater than or equal to #10
	ADD R0, R4, R2						;   we must add an offset to get chars A - F
	OUT									; Outputs character to console
	STR R0, R3, #0						; Stores that character to array
	ADD R3, R3, #1						; Increments address of array
	ST R3, HEX_ARRAY_3800
	
END_3800:

; (3) Restore registers 

	LD R7, BACKUP_R7_3800
	LD R0, BACKUP_R0_3800
	LD R1, BACKUP_R1_3800
	LD R2, BACKUP_R2_3800
	LD R3, BACKUP_R3_3800
	
; (4) Return back to main	
	
	RET

	HALT
;-------------------------------------------
; Subroutine Data
;-------------------------------------------
	
	BACKUP_R7_3800		.BLKW		#1
	BACKUP_R0_3800		.BLKW		#1
	BACKUP_R1_3800		.BLKW		#1
	BACKUP_R2_3800		.BLKW		#1
	BACKUP_R3_3800		.BLKW		#1
	NUM_CHAR_OFFSET		.FILL		#48
	OVER_TEN_OFFSET		.FILL		#55
	HEX_ARRAY_3800		.FILL		x3706
.end

;--------------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_IS_NEG_4000
; Parameter (R1): Overflowed number taken from user input
; Postcondition: Deals with R1 while the value in it is negative. Subtracts 16^3 from R1 till it underflows back
; to a positive value, and resets value of R1 to the value it would have been.			
;Return Value: R4 <-- number of times we subtract 16^3 from R1 until it underflowed
;              R1 <-- the value to get the remaining hexadecimal numbers from
;--------------------------------------------------------------------------------------------------------------------

.orig x4000
;-----------------------------------------
; Subroutine Instructions
;-----------------------------------------

	ST R7, BACKUP_R7_4000
	ST R2, BACKUP_R2_4000
	ST R3, BACKUP_R3_4000
	
	LD R2, POWS_16_4000			; Loads address where 16^3 is stored
	
NEXT_16_4000:

	LDR R3, R2, #0				; Loads 16^3 to R2 
	NOT R3, R3					; Inverts value in R3 to a negative number
	ADD R3, R3, #1			
	
LOOP_4000:

	ADD R1, R1, R3				; Subtracts value in R1 to R3
	BRp  BREAK_LOOP_4000		; Once R1 underflows to positve, break loop
	
	ADD R4, R4, #1				; Counts how many times we subtracted before underflow
	BRnzp LOOP_4000
	
BREAK_LOOP_4000:
		
	ADD R4, R4, #1				; Counts once more for the overflowed subtraction
	
	LD R7, BACKUP_R7_4000
	LD R2, BACKUP_R2_4000
	LD R3, BACKUP_R3_4000
	
	RET
	
	HALT
;-----------------------------------------
; Subroutine Data
;-----------------------------------------
	
	BACKUP_R7_4000		.BLKW		#1
	BACKUP_R2_4000		.BLKW		#1
	BACKUP_R3_4000		.BLKW		#1
	POWS_16_4000		.FILL		x3701
	SUB_PRNT_HEX_3800	.FILL		x3800
	LAST_POS_4000		.FILL		x7FFF
.end
