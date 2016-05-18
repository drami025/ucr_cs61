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
	ST R6, BACKUP_R6_3200
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
	
	LD R5, TEN_OFFSET					; R5 <-- the value in the address labelled CHAR_OFFSET
	
	ADD R6, R2, R5						; Adds the value in R2 by the offset
	BRn SET_TO_ONE
		LD R6, TWO_VALUE
		BRnzp SKIP
		
SET_TO_ONE:
		LD R6, ONE_VALUE
SKIP: 	
	
	LD R1, SUB_PRINT_CHARS_3700
	JSRR R1

; (3) Restore registers 

	LD R0, BACKUP_R0_3200
	LD R1, BACKUP_R1_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R5, BACKUP_R5_3200
	LD R6, BACKUP_R6_3200
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
	BACKUP_R6_3200	.BLKW	#1
	BACKUP_R7_3200	.BLKW	#1
	LAST_NUM	.FILL	x8000
	COUNTER		.FILL	#15
	TEN_OFFSET	.FILL		#-10
	CHAR_OFFSET	.FILL		#48
	ONE_VALUE		.FILL		#1
	TWO_VALUE		.FILL		#2
	SUB_PRINT_CHARS_3700	.FILL	x3700

;----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_CHARS_3700
; Input (R2): Some value to print out as characters to console 
; Input (R6): Some value that determined how many character inputs there were by user
; Postcondition: The subroutine takes a number, subtracts 10^5 to 10^0, and prints out the 
;						character to console.
; Return Value: None, it is a void function.
;----------------------------------------------------------------------------------------------



.orig x3700
;---------------------------
; Subroutine Instructions
;---------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3700
	ST R0, BACKUP_R0_3700
	ST R1, BACKUP_R1_3700
	ST R2, BACKUP_R2_3700
	ST R3, BACKUP_R3_3700
	ST R4, BACKUP_R4_3700
	ST R5, BACKUP_R5_3700
	ST R6, BACKUP_R6_3700

; (2) Subroutine's Algorithm


	LD R0, SUB_NEW_LINE				; This part outputs a newline twice
	OUT
	OUT
	
	LD R3,SUB_CHAR_OFFSET			; R3 <--- the valued stored in the adress labelled SUB_CHAR_OFFSET
	LD R1, TENS_ARR					; Loads the location of an array where powers of #10 are stored.
	ADD R6, R6, #-1					; Adds one less to the number of characters inputted
	ADD R1, R1, R6					; Reason we add  #-1 to R5 to so we know what power of ten to start    
									;   from, which is what ADD R2, R2, R5 does.

NEXT_DIGIT:							; Loop to find out what the next digit in the value is 
	LDR R4, R1, #0					; Loads the power of ten
	AND R0, R0, #0					; Sets R0 to #0
	
PRINT_TEN_LOOP:						; Beginning of loop to print out characters

	ADD R2, R2, R4					; We subtract the power of ten from the number in R1
	BRn END_LOOP					; Once value in R1 is negative, we end the loop
	
	ADD R0, R0, #1					; This keeps track of how many times we subtract the power
	BRnzp PRINT_TEN_LOOP			; of ten from the value in R1, giving us the number of that digit
									; It keeps looping till value in R1 is negative
	
END_LOOP:
	
	NOT R4, R4						; Inverts power of ten to a positive
	ADD R4, R4, #1					; Adds power of ten back to value in R1 to get the positive number 
	ADD R2, R2, R4					;   before R1 became negative. This gives us the remainder of that power ten.
	ADD R0, R0, R3					; Adds character offset to value in R0, outputting the first digit to console
	OUT
	
	ADD R1, R1, #-1					; Goes to the next, lower power of ten.
	ADD R2, R2, #0					; Once R1 is #0, we got all the numbers and outputted them correctly.
	BRnp NEXT_DIGIT
	
; (3) Restore registers 

	LD R7, BACKUP_R7_3700
	LD R0, BACKUP_R0_3700
	LD R1, BACKUP_R1_3700
	LD R2, BACKUP_R2_3700
	LD R3, BACKUP_R3_3700
	LD R4, BACKUP_R4_3700
	LD R5, BACKUP_R5_3700
	LD R6, BACKUP_R6_3700
	
; (4) Return back to main
	
	RET
	
	HALT
	
;---------------------------------------------
; Subroutine Data
;---------------------------------------------
	
	BACKUP_R7_3700	.BLKW		#1
	BACKUP_R0_3700	.BLKW		#1
	BACKUP_R1_3700	.BLKW		#1
	BACKUP_R2_3700	.BLKW		#1
	BACKUP_R3_3700	.BLKW		#1
	BACKUP_R4_3700	.BLKW		#1
	BACKUP_R5_3700	.BLKW		#1
	BACKUP_R6_3700	.BLKW		#1
	SUB_CHAR_OFFSET		.FILL		#48
	TENS_ARR		.FILL		x4000
	NUM_OFFSET		.FILL		#0
	SUB_NEW_LINE	.FILL		#10

	.orig x4000
	
	ONE		.FILL   #-1
	TWO		.FILL	#-10
	THREE	.FILL	#-100
	FOUR	.FILL	#-1000
	FIVE	.FILL	#-10000
	
