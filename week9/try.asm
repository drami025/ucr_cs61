;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 09
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;-------------------------------------------------
; Instructions
;-------------------------------------------------
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	ADD R3, R3, #2
	
	LD R1, STACK
	LD R2, STACK
	
	LEA R0, PROMPT_NUM1
	PUTS
	
	GETC
	OUT
	
	LD R4, CHAR_OFFSET
	ADD R0, R0, R4
	
	LD R4, SUB_STACK_PUSH
	JSRR R4
	
	LEA R0, PROMPT_NUM2
	PUTS
	
	GETC
	OUT
	
	LD R4, CHAR_OFFSET
	ADD R0, R0, R4
	
	LD R4, SUB_STACK_PUSH
	JSRR R4
	
	LD R4, SUB_RPN_MULTIPLY_3600
	JSRR R4
	
	AND R1, R0, #-1
	LD R4, SUB_PRINT_CHARS_4100
	JSRR R4
	
	
	
	HALT
;-------------------------------------------------
; Data
;-------------------------------------------------

	SUB_STACK_PUSH		.FILL		x3200
	PROMPT_NUM1				.STRINGZ	"\n\nEnter the first number to multiply: "
	PROMPT_NUM2				.STRINGZ	"\n\nEnter the second number to multiply: "
	SUB_RPN_MULTIPLY_3600	.FILL		x3600
	STACK					.FILL		x3150
	SUB_STACK_POP_3400		.FILL		x3400
	CHAR_OFFSET				.FILL		#-48
	SUB_PRINT_CHARS_4100	.FILL		x4100


.end


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH_3200
; Parameter (R0): The value to push onto the stack
; Parameter (R1): stack_addr: A pointer to the beginning of the stack
; Parameter (R2): top: A pointer to the next place to PUSH an item
; Parameter (R3): capacity: The number of additional items the stack can hold
; Postcondition: The subroutine has pushed (R0) onto the stack. If an overflow
; occurred, the subroutine has printed an overflow error message
; and terminated.
; Return Value: R2 ﬂ updated top value
; R3 ﬂ updated capacity value
;-----------------------------------------------------------------------------------------------

.orig x3200
;---------------------------------------------
; Subroutine Instructions
;---------------------------------------------

	ST R7, BACKUP_R7_3200
	ST R4, BACKUP_R4_3200	

	ADD R3, R3, #-1
	BRzp NO_OVERFLOW_3200
		LEA R0, OVERFLOW_PROMPT_3200
		PUTS
		BRnzp OVERFLOWED_3200

NO_OVERFLOW_3200:
		
	STR R0, R2, #0
	ADD R2, R2, #1

	LD R7, BACKUP_R7_3200
	LD R4, BACKUP_R4_3200
		
	
	RET

OVERFLOWED_3200:

	HALT
;---------------------------------------------
; Subroutine Data
;---------------------------------------------

	BACKUP_R7_3200		.BLKW		#1
	BACKUP_R4_3200		.BLKW		#1
	TERMINATE_ADDR		.FILL		x300D
	OVERFLOW_PROMPT_3200	.STRINGZ	"\n\nThe stack has an overflow. Terminating program. \n"

.end

;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP_3400
; Parameter (R1): stack_addr: A pointer to the beginning of the stack
; Parameter (R2): top: A pointer to the item to POP
; Parameter (R3): capacity: The # of additional items the stack can hold
; Postcondition: The subroutine has popped MEM[top] off of the stack.
; If an underflow occurred, the subroutine has printed an
; underflow error message and terminated.
; Return Value: R0 <-- value popped off of the stack
; R2 <-- updated top value
; R3 <-- updated capacity value
;-----------------------------------------------------------------------------------------------

.orig x3400
;----------------------------------------------------------------------
; Subroutine Instructions
;----------------------------------------------------------------------

	ST R7, BACKUP_R7_3400
	ST R4, BACKUP_R4_3400
	
	NOT R5, R2
	ADD R5, R5, #1
	ADD R5, R5, R1
	BRnp NO_UNDERFLOW_3400
		LEA R0, UNDERFLOW_PROMPT
		PUTS
		BRnzp UNDERFLOWED_3400
		
NO_UNDERFLOW_3400:

	ADD R3, R3, #1
	ADD R2, R2, #-1
	
	LD R7, BACKUP_R7_3400
	LD R4, BACKUP_R4_3400
	
	RET
	
UNDERFLOWED_3400:	
	
	HALT
;----------------------------------------------------------------------
; Subroutine Data
;----------------------------------------------------------------------


	BACKUP_R7_3400		.BLKW		#1
	BACKUP_R4_3400		.BLKW		#1
	UNDERFLOW_PROMPT	.STRINGZ	"\n\nUnderflow detected. Program will now terminate. \n"
	TERMINATE_3400		.FILL		x300D
.end

;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY_3600
; Parameter (R1): stack_addr
; Parameter (R2): top
; Parameter (R3): capacity
; Postcondition: The subroutine has popped off the top two values of the stack,
; multiplied them together, and pushed the resulting value back
; onto the stack.
; Return Value: R2 ﬂ updated top value
; R3 ﬂ updated capacity value
;-----------------------------------------------------------------------------------------------

.orig x3600
;-------------------------------------------
; Subroutine Instructions
;-------------------------------------------
	ST R7, BACKUP_R7_3600
	ST R4, BACKUP_R4_3600
	ST R5, BACKUP_R5_3600
	ST R6, BACKUP_R6_3600
	
	LD R6, SUB_STACK_POP_3400
	
	JSRR R6
	LDR R4, R2, #0
	
	JSRR R6
	LDR R5, R2, #0	
	
	LD R6, SUB_MULTIPLY_3800
	JSRR R6
	
	LD R6, SUB_STACK_PUSH_3200
	JSRR R6

	
	LD R7, BACKUP_R7_3600
	LD R4, BACKUP_R4_3600
	LD R5, BACKUP_R5_3600
	LD R6, BACKUP_R6_3600
	
	RET
	
	HALT
;-------------------------------------------
; Subroutine Data 
;-------------------------------------------

	BACKUP_R7_3600			.BLKW			#1
	BACKUP_R4_3600			.BLKW			#1
	BACKUP_R5_3600			.BLKW			#1
	BACKUP_R6_3600			.BLKW			#1
	SUB_STACK_POP_3400		.FILL			x3400
	SUB_MULTIPLY_3800		.FILL			x3800
	STACK_3150				.FILL			x3150
	SUB_STACK_PUSH_3200		.FILL			x3200
	
.end

;----------------------------------------------------------------------------------------------
; Subroutine: SUB_MULTIPLY_3800
; Input(R4): First value user inputs to be multiplied by the second value.
; Input(R5): Second value user inputs to be multiplied by the first value. Note:
;				both parameters are being reference and NOT being changed.
; Input(R3): Referenced register which contains how many negative numbers were inputted by user
; Postcondition: Multiplies the two numbers inputted by user together and stores product in register.
; Return Value: R4 <-- The product of the two multiplicands 
;----------------------------------------------------------------------------------------------

.orig x3800
;----------------------------------
; Subroutine Instructions
;----------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value
	ST R7, BACKUP_R7_3800
	ST R1, BACKUP_R1_3800
	ST R2, BACKUP_R2_3800
	ST R5, BACKUP_R5_3800
	ST R4, BACKUP_R0_3800
	
; (2) Subroutine's Algorithm	
	
	;LD R5, SUB_FIND_BIGGER_4000			; R5 <-- the value stored in the address labelled SUB_FIND_BIGGER_4000
	;JSRR R5								; Jumps to subroutine SUB_FIND_BIGGER_4000
	
	ADD R4, R4, #0						; Adds #0 to the smaller number, which will be in R0. If it is #0, we know
	BRz SUB_IS_ZERO_3800				;    the answer will be #0, in which case we can just skip to the end.
	
	AND R2, R2, #0						; Sets the value to R2 to #0
	AND R0, R4, #-1						; Copies the value in R0 to R4.
	
SUB_MULT_LOOP_3800:						; Loop will add into R2 the value of R1 (the bigger number) times the number
										; in R0 (the smaller number). Done this way for efficiency.
	ADD R2, R2, R5						
	;BRn OVERFLOW						; Since both numbers were set to positive numbers, should the number become negative
										;   there would be an overflow. Thus we skip to OVERFLOW and end the program
	ADD R0, R0, #-1						; Deducts the value in R4 (which was the smaller number) by #1. Once reduced to
	BRp SUB_MULT_LOOP_3800				;  zero, we enter the multiplication loop
	
	ST R2, TOTAL						; Store the value in R2 to address labelled TOTAL
	BRnzp SUB_NOT_ZERO_3800				; Since neither R1 nor R2 were #0 to begin with, we skip next part;


SUB_IS_ZERO_3800:						; If R0 was #0 to begin with, store #0 to TOTAL
	ST R4, TOTAL
	
SUB_NOT_ZERO_3800:
	
	LD R0, TOTAL						; Load final product to R4
	;ADD R5, R3, #-1						; Adds #-1 to the value in R3. If it is #1 or #-1, we know there was either 2 or 0 
	;BRnp SUB_NOT_NEG_3600				;   negative numbers inputted. If sum is #0, there was 1, in which case product is negative
		;NOT R4, R4						; if there WAS one negative number, R4 is inverted to a negative number.
		;ADD R4, R4, #1
		
SUB_NOT_NEG_3800:		
	
; (3) Restore registers 	
	
	LD R7, BACKUP_R7_3800
	LD R1, BACKUP_R1_3800
	LD R2, BACKUP_R2_3800
	LD R5, BACKUP_R5_3800
	LD R4, BACKUP_R0_3800

; (4) Return back to main

	RET
	
OVERFLOW:								; If product is not within range of bits, then we have an over or underflow,
										;    this part will determine that.
	ADD R5, R3, #-1						; Once again, we determine whether there was over or underflow by determining
	BRz UNDERFLOW						;    whether product was negative or positive.
	
	LEA R0, OVER_ERROR					; This part outputs error for overflow if product was positive.
	PUTS
	
	BRnzp SUB_SKIP_3800	
	
UNDERFLOW:

	LEA R0, UNDER_ERROR					; If product was negative, we output error for underflow here.
	PUTS
	
SUB_SKIP_3800:

	HALT
;----------------------------------
; Subroutine Data
;----------------------------------

	BACKUP_R7_3800		.BLKW	#1
	BACKUP_R0_3800		.BLKW	#1
	BACKUP_R2_3800		.BLKW	#1
	BACKUP_R4_3800		.BLKW	#1
	BACKUP_R5_3800		.BLKW	#1
	BACKUP_R1_3800		.BLKW	#1
	SUB_FIND_BIGGER_4000	.FILL	x4000
	TOTAL					.FILL	#0
	OVER_ERROR		.STRINGZ	"\nWoes! Overflow!\n"
	UNDER_ERROR		.STRINGZ	"\nWhoas! Underflow!\n"
	
.end
;----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_CHARS_4100
; Input (R1): Some value to print out as characters to console 
; Input (R5): Some value that determined how many character inputs there were by user
; Postcondition: The subroutine takes a number, subtracts 10^5 to 10^0, and prints out the 
;						character to console.
; Return Value: None, it is a void function.
;----------------------------------------------------------------------------------------------



.orig x4100
;---------------------------
; Subroutine Instructions
;---------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_4100
	ST R0, BACKUP_R0_4100
	ST R1, BACKUP_R1_4100
	ST R2, BACKUP_R2_4100
	ST R3, BACKUP_R3_4100
	ST R4, BACKUP_R4_4100
	ST R5, BACKUP_R5_4100
	ST R6, BACKUP_R5_4100


; (2) Subroutine's Algorithm
	
	LD R3, SUB_CHAR_OFFSET			; R3 <--- the valued stored in the adress labelled SUB_CHAR_OFFSET
	LD R2, TENS_ARR					; Loads the location of an array where powers of #10 are stored.
	LDR R5, R2, #0
	LEA R0, MULT_EQUAL
	PUTS
	
	;ADD R4, R4, #0
	;BRzp SUB_NOT_NEG_4100
	;	NOT R4,R4
	;	ADD R4,R4, #1
	;	LD R0, NEG_CHAR_4100
	;	OUT

;SUB_NOT_NEG_4100:	
	
	ADD R6, R5, R1
	BRzp START_HERE_ONE
		ADD R2, R2, #-1
		LDR R5, R2, #0
		LD R0, FIVE_DIGIT
		ADD R0, R0, #-1
		ST R0, FIVE_DIGIT
	
	ADD R6, R5, R1
	BRzp START_HERE_TWO
		ADD R2, R2, #-1
		LDR R5, R2, #0
		LD R0, FIVE_DIGIT
		ADD R0, R0, #-1
		ST R0, FIVE_DIGIT
	
	ADD R6, R5, R1
	BRzp START_HERE_THREE
		ADD R2, R2, #-1
		LDR R5, R2, #0
		LD R0, FIVE_DIGIT
		ADD R0, R0, #-1
		ST R0, FIVE_DIGIT
	
	ADD R6, R5, R1
	BRzp START_HERE_FOUR
		ADD R2, R2, #-1
		LDR R5, R2, #0
		LD R0, FIVE_DIGIT
		ADD R0, R0, #-1
		ST R0, FIVE_DIGIT
	
START_HERE_ONE:
START_HERE_TWO:
START_HERE_THREE:
START_HERE_FOUR:


	LD R5, FIVE_DIGIT

NEXT_DIGIT:							; Loop to find out what the next digit in the value is 
	
	LDR R4, R2, #0					; Loads the power of ten
	AND R0, R0, #0					; Sets R0 to #0
	
PRINT_TEN_LOOP:						; Beginning of loop to print out characters

	ADD R1, R4, R1					; We subtract the power of ten from the number in R1
	BRn END_LOOP					; Once value in R1 is negative, we end the loop
	
	ADD R0, R0, #1					; This keeps track of how many times we subtract the power
	BRnzp PRINT_TEN_LOOP			; of ten from the value in R1, giving us the number of that digit
									; It keeps looping till value in R1 is negative
	
END_LOOP:
	
	NOT R4, R4						; Inverts power of ten to a positive
	ADD R4, R4, #1					; Adds power of ten back to value in R1 to get the positive number 
	ADD R1, R1, R4					;   before R1 became negative. This gives us the remainder of that power ten.
	ADD R0, R0, R3					; Adds character offset to value in R0, outputting the first digit to console
	OUT
	
	ADD R2, R2, #-1					; Goes to the next, lower power of ten.
	ADD R5, R5, #-1
	;ADD R4, R4, #0					; Once R1 is #0, we got all the numbers and outputted them correctly.
	BRnp NEXT_DIGIT
	
	;ADD R5, R5, #0
	;BRnz FINISHED
	;	ADD R0, R0, #0
	;	OUT
FINISHED:
	
; (3) Restore registers 

	LD R7, BACKUP_R7_4100
	LD R0, BACKUP_R0_4100
	LD R1, BACKUP_R1_4100
	LD R2, BACKUP_R2_4100
	LD R3, BACKUP_R3_4100
	LD R4, BACKUP_R4_4100
	LD R5, BACKUP_R5_4100
	LD R6, BACKUP_R6_4100
	
; (4) Return back to main
	
	RET
	
	HALT
	
;---------------------------------------------
; Subroutine Data
;---------------------------------------------
	
	BACKUP_R7_4100	.BLKW		#1
	BACKUP_R0_4100	.BLKW		#1
	BACKUP_R1_4100	.BLKW		#1
	BACKUP_R2_4100	.BLKW		#1
	BACKUP_R3_4100	.BLKW		#1
	BACKUP_R4_4100	.BLKW		#1
	BACKUP_R5_4100	.BLKW		#1
	BACKUP_R6_4100	.BLKW		#1
	SUB_CHAR_OFFSET		.FILL		#48
	TENS_ARR		.FILL		x4204
	NUM_OFFSET		.FILL		#0
	NEG_CHAR_4100	.FILL		#45
	FIVE_DIGIT		.FILL		#5
	MULT_EQUAL				.STRINGZ	"\n\nValue in stack: " 

	.orig x4200
	
	ONE		.FILL   #-1
	TWO		.FILL	#-10
	THREE	.FILL	#-100
	FOUR	.FILL	#-1000
	FIVE	.FILL	#-10000
	
