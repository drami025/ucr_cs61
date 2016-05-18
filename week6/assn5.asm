;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Assignment 05
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;-------------------------------------------
; Instructions
;-------------------------------------------
	LEA R0, FIRST_PROMPT					; Loads first prompt, asking user to input first number
	PUTS									; Prints out FIRST_PROMPT string
	
	LD R2, ADDRESS1							; R2 <-- value stored in address labelled ADDRESS1
	LD R5, SUB_GET_BIN_3200					; R5 <-- value stored in address labelled SUB_GET_BIN_3200
	JSRR R5									; Jumps to subroutine SUB_GET_BIN_3200
	
	ST R1, FIRST_MULT						; Store the first number received from user into address 
											;   labelled FIRST_MULT.
	AND R1, R1, #0							; Resets value of R1 to #0 by ANDing with #0
	
	LEA R0, SECOND_PROMPT					; Loads second prompt, asking user to input second number
	PUTS									; Prints out SECOND_PROMPT string
	
	LD R2, ADDRESS2							; R2 <-- value stored in address labelled ADDRESS2
	JSRR R5									; Jumps to subroutine SUB_GET_BIN_3200
	
	ST R1, SECOND_MULT						; Store the second number received from user into address
											;   labelled SECOND_MULT
											
	; R0 and R1 will be our "reference" variables throughout the program. They are passed
	; pretty much through every subroutine here. They do not get changed at all (unless a subroutine
	; uses and register, but they will store it back into R0 and R1). Only time they are changed is the
	; last subroutine.
											
	LD R0, FIRST_MULT						; R0 <-- value stored in address labelled FIRST_MULT
	LD R1, SECOND_MULT						; R1 <-- value stored in address labelled SECOND_MULT
	
	LD R5, SUB_CHECK_OUTCOME_3400			; R5 <-- value stored in address labelled SUB_CHECK_OUTCOME_3400
	JSRR R5									; Jumps to subroutine SUB_CHECK_OUTCOME_3400
	
	LD R5, SUB_MULTIPLY_3600				; R5 <-- value stored in address labelled SUB_MULTIPLY_3600
	JSRR R5									; Jumps to subroutine SUB_MULTIPLY_3600
	
	;This is where the format of the output starts
	
	LD R0, NEWLINE							; R0 <-- value stored in address labelled NEWLINE
	OUT										; Outputs a newline character
	
	LEA R0, FIRST_ARR						; R0 <-- address where the first number inputted is stored 
	PUTS									;    saved as an array and outputted like a string
	
	LD R0, SPACE							; R0 <-- value stored in address labelled SPACE
	OUT										; Outputs a space character
	
	LD R0, STAR								; R0 <-- value stored in address labelled STAR
	OUT										; Outputs an asterisk character
	
	LD R0, SPACE							; R0 <-- value stored in address labelled SPACE
	OUT										; Outputs a space character
	
	LEA R0, SECOND_ARR						; R0 <-- address where the second number inputted is stored 
	PUTS									;    saved as an array and outputted like a string
	
	LD R0, SPACE							; R0 <-- value stored in address labelled SPACE
	OUT										; Outputs a space character
	
	LD R0, EQUAL							; R0 <-- value stored in address labelled EQUAL
	OUT										; Outputs an equal-sign character
	
	LD R0, SPACE							; R0 <-- value stored in address labelled SPACE
	OUT										; Outputs a space character						
	
	LD R5, SUB_PRINT_CHARS_4100				; R5 <-- value stored in address labelled SUB_PRINT_CHARS_4100
	JSRR R5									; Jumps to subroutine SUB_PRINT_CHARS_4100
	
	LD R0, NEWLINE							; R0 <-- value stored in address labelled NEWLINE 
	OUT										; Outputs a newline character
	
	
	
	HALT
;-----------------------------------------------
; Local Data
;-----------------------------------------------
	
	FIRST_PROMPT		.STRINGZ	"\nEnter first number: "
	SECOND_PROMPT		.STRINGZ	"\nEnter second number: "
	FIRST_MULT			.FILL		#0
	SECOND_MULT			.FILL		#0
	FINAL_ANS			.FILL		#0
	BACK_TO_START		.FILL		x3000
	SUB_GET_BIN_3200	.FILL		x3200
	SUB_CHECK_OUTCOME_3400	.FILL	x3400
	SUB_MULTIPLY_3600	.FILL		x3600
	SUB_PRINT_CHARS_4100	.FILL	x4100
	ADDRESS1			.FILL		x3101
	ADDRESS2			.FILL		x310B
	SPACE				.FILL		#32
	STAR				.FILL		#42
	EQUAL				.FILL		#61
	NEWLINE				.FILL		#10
.end


;=======================================================================
; Array Data
;=======================================================================

.orig x3100

	HALT
	
	FIRST_ARR		.BLKW	#10			; Where first user input will be stored
	SECOND_ARR		.BLKW	#10			; Where second user input will be stored

;----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_BIN_3200
; Input(R2): The address where character array will be stored
; Postcondition: This program takes character from user and converts it from character numbers
;						to a 16-bit signed binary number.
; Return Value: R1 <--- the 16-bit signed binary number 
;----------------------------------------------------------------------------------------------
.orig x3200
;------------------------------
; Instruction
;------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R0, BACKUP_R0_3200	
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R5, BACKUP_R5_3200
	ST R6, BACKUP_R6_3200
	ST R7, BACKUP_R7_3200

; (2) Subroutine's Algorithm

GO_BACK:						; Program starts all over if incorrect character put in

	LD R2, BACKUP_R2_3200		; Resets address
	LD R4, FIRST				; R4 <-- value stored in address labelled FIRST, which is #1
	LD R1, INPUT				; R1 <-- value stored in address labelled INPUT, which is #0
	LD R6, RESET				; R6 <-- value stored in address labelled RESET, which is #0
	ST R6, NEG_TEST				; Stores value in R6 to NEG_TEST (to reset NEG_TEST to #0)
	ST R2, ARR_ADDRESS			; Stores address taken from parameter

LOOP:							; Beginning of main Loop
	GETC						; Gets character from console
	OUT							; Outputs character back to console

	LD R2, ARR_ADDRESS			; Loads incremented address to R2
	STR R0, R2, #0				; Stores character inputted to address of array
	ADD R2, R2, #1				; Increments to the next address
	ST R2, ARR_ADDRESS			; Stores new address to address labelled ARR_ADDRESS

	ST R0, INPUT				; Stores the character in address labelled INPUT

	LD R2, INPUT				; R2 <--- character in INPUT
	ADD R2, R2, #-10			; Adds #-10 to value in R2. If it's a #0, then that means it was
	BRz SKIP_TO_END				;   a newline character ended, so we skip to the end of program
	
	LD R2, INPUT				; R2 <--- character in INPUT
	LD R3, NEG_CHAR				; R3 <--- value stored in address labelled NEG_CHAR
	ADD R2, R2, R3				; Adds value in R2 with R3. If it is #0, that means input was a
								;    negative character, so we skip to SKIP_NEG, near end of loop
	BRz SKIP_NEG

	LD R2, INPUT				; R2 <--- character in INPUT
	LD R3, POS_CHAR				; R3 <--- value stored in address labelled POS_CHAR
	ADD R2, R2, R3				; Adds value in R2 with R3. If it is #0, that means input was a
	BRz SKIP_POS				;    positive char, so we skip to SKIP_POS, at the end of loop

	LD R2, INPUT				; R2 <--- character in INPUT
	LD R3, BELOW_NUM			; R3 <-- value stored in address labelled BELOW_NUM
	ADD R2, R2, R3				; Adds value in R2 with R3. If it is negative or #0, input was a 
	BRnz ERROR1					;    character below the numbers in the ASCII table. Skip to ERROR1

	LD R2, INPUT				; R2 <--- character in INPUT
	LD R3, ABOVE_NUM			; R3 <--- value stored in address labelled ABOVE_NUM
	ADD R2, R2, R3				; Adds value in R2 with R3. If it is positive or zero, input was
	BRzp ERROR2					;   a character above numbers in the ASCII table. Skip to ERROR2
	
	LD R2, CHAR_OFFSET			; R2 <--- Value stored in address labelled CHAR_OFFSET
	ADD R5, R0, R2				; Adds value in R0 (the original input) with R2. This loads the number,
								;   not ASCII value, of the input into R5
	ADD R4, R4, #-1				; Subtracts #1 from R4
	BRz SKIP_JUMP				; Since the value in R4 will only be #0 once in the program, this ensures we
		LD R6, SUB_MULT_TEN_3800		;   don't multiply the first number by 10.
		JSRR R6					; After the first input, we jump to subroutine SUBROUTE
SKIP_JUMP:				
	
	ADD R1, R1, R5				; We now add the multiplied number by the inputted number 

SKIP_NEG:

	ADD R4, R4, #0				; We add value in R4 by #0. Since R4 will only be positive once, when the sign is
	BRnz SKIP_NEG_CHECK			;    determined, if the char was the negative char, R6 be value in NEG_TEST, add
	LD R6, NEG_TEST				;    #1 to itself, and then store it back into NEG_TEST. This can happen only once
	ADD R6, R6, #1
	ST R6, NEG_TEST

SKIP_NEG_CHECK:				

SKIP_POS:				
SKIP_TO_END:
	
	ADD R0, R0, #-10			; If the character is a newline character, the main loop breaks.
	BRnp LOOP

	BRnzp END					; Skips to end of program, to avoid setting off Errors.
ERROR1:
ERROR2:

	LEA R0, WRONG_CHAR			; If an incorrect ASCII character was inputted, prompt tells user to try again.
	PUTS

	LD R1, RESET				; Resets the value in R1 to #0
	ST R1, INPUT				; Stores #0 back to INPUT to reset the value in that address

	LD R0, START_OF_PROG		; Goes back to start of program if there was an error in input
	JMP R0
	BRnzp GO_BACK				; Goes back to the beginning of program if there was an error.
	
MAKE_NEG:

END:
	LD R6, NEG_TEST				; R6 <-- value stored in address labelled NEG_TEST
	ADD R6, R6, #-1				; Adds #1 to value in R6. If it turns out to be #0, then we take the
	BRnp LAST_SKIP				;    two's complement of the entire number in R1
	
	NOT R1, R1				; Here we take the two's complement of R1 if user inputted number was negative
	ADD R1, R1, #1

LAST_SKIP:

	AND R4, R4, #0				; Resets value in address labelled INPUT to #0
	ST R4, INPUT
	ADD R4, R4, #1				; Resets value in address labelled FIRST to #1
	ST R4, FIRST
	
	LD R2, ARR_ADDRESS			; Loads address after the array, with the last character being a newline
	ADD R2, R2, #-1				; R2 now holds the address where the newline character is
	LD R5, RESET				; R5 now holds the value #0
	STR R5, R2, #0				; Inserts the null character (#0) to the end of the character array

; (3) Restore registers 

	LD R0, BACKUP_R0_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R5, BACKUP_R5_3200
	LD R6, BACKUP_R6_3200
	LD R7, BACKUP_R7_3200
	
; (4) Return back to main	
	
	RET

	HALT
;------------------------------
; Local Data
;------------------------------

	BACKUP_R0_3200	.BLKW	#1
	BACKUP_R2_3200	.BLKW	#1
	BACKUP_R3_3200	.BLKW	#1
	BACKUP_R4_3200	.BLKW	#1
	BACKUP_R5_3200	.BLKW	#1
	BACKUP_R6_3200	.BLKW	#1
	BACKUP_R7_3200	.BLKW	#1
	INPUT		.FILL		#0
	FIRST		.FILL		#1
	NEG_CHAR	.FILL		#-45
	POS_CHAR	.FILL		#-43
	BELOW_NUM	.FILL		#-47
	ABOVE_NUM	.FILL		#-58
	CHAR_OFFSET	.FILL		#-48
	SUB_MULT_TEN_3800	.FILL		x3800
	WRONG_CHAR	.STRINGZ	"\n\nInput not a number. Please try again.\n\n"
	NEG_TEST	.FILL		#0
	RESET		.FILL		#0
	START_OF_PROG	.FILL	x3000
	ARR_ADDRESS		.FILL	x3100
	NUM_COUNT		.FILL	#0
	
.end
;----------------------------------------------------------------------------------------------
; Subroutine: SUB_CHECK_OUTCOME_3400
; Input(R0): First value user inputs to be multiplied by the second value.
; Input(R1): Second value user inputs to be multiplied by the first value. Note:
;				both parameters are being reference and NOT being changed.
; Postcondition: Subroutine checks whether the answer will be positive or negative.
; Return Value: R3 <-- the number of negative numbers being passed by user inputs. Can be either
;						#0 for no negatives, #1 for one, and #2 for two
;----------------------------------------------------------------------------------------------
.orig x3400
;-------------------------------------------
; Subroutine Instructions
;-------------------------------------------

	ST R7, BACKUP_R7_3400

	AND R3, R3, #0					; Sets the value in R3 to #0
	
	ADD R0, R0, #0
	BRzp NOT_NEG_1
		ADD R3, R3, #1
		NOT R0, R0
		ADD R0, R0, #1
		
NOT_NEG_1:

	ADD R1, R1, #0
	BRzp NOT_NEG_2
		ADD R3, R3, #1
		NOT R1, R1
		ADD R1, R1, #1
			
NOT_NEG_2:

	LD R7, BACKUP_R7_3400

	RET
	
	HALT
	
	BACKUP_R7_3400	.BLKW	#1



;----------------------------------------------------------------------------------------------
; Subroutine: SUB_MULTIPLY_3600
; Input(R0): First value user inputs to be multiplied by the second value.
; Input(R1): Second value user inputs to be multiplied by the first value. Note:
;				both parameters are being reference and NOT being changed.
; Input(R3): Referenced register which contains how many negative numbers were inputted by user
; Postcondition: Multiplies the two numbers inputted by user together and stores product in register.
; Return Value: R4 <-- The product of the two multiplicands 
;----------------------------------------------------------------------------------------------

.orig x3600
;----------------------------------
; Subroutine Instructions
;----------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value
	ST R7, BACKUP_R7_3600
	ST R2, BACKUP_R2_3600
	ST R5, BACKUP_R5_3600
	
; (2) Subroutine's Algorithm	
	
	LD R5, SUB_FIND_BIGGER_4000			; R5 <-- the value stored in the address labelled SUB_FIND_BIGGER_4000
	JSRR R5								; Jumps to subroutine SUB_FIND_BIGGER_4000
	
	ADD R0, R0, #0						; Adds #0 to the smaller number, which will be in R0. If it is #0, we know
	BRz SUB_IS_ZERO_3600				;    the answer will be #0, in which case we can just skip to the end.
	
	AND R2, R2, #0						; Sets the value to R2 to #0
	AND R4, R0, #-1						; Copies the value in R0 to R4.
	
SUB_MULT_LOOP_3600:						; Loop will add into R2 the value of R1 (the bigger number) times the number
										; in R0 (the smaller number). Done this way for efficiency.
	ADD R2, R2, R1						
	BRn OVERFLOW						; Since both numbers were set to positive numbers, should the number become negative
										;   there would be an overflow. Thus we skip to OVERFLOW and end the program
	ADD R4, R4, #-1						; Deducts the value in R4 (which was the smaller number) by #1. Once reduced to
	BRp SUB_MULT_LOOP_3600				;  zero, we enter the multiplication loop
	
	ST R2, TOTAL						; Store the value in R2 to address labelled TOTAL
	BRnzp SUB_NOT_ZERO_3600				; Since neither R1 nor R2 were #0 to begin with, we skip next part;


SUB_IS_ZERO_3600:						; If R0 was #0 to begin with, store #0 to TOTAL
	ST R0, TOTAL
	
SUB_NOT_ZERO_3600:
	
	LD R4, TOTAL						; Load final product to R4
	ADD R5, R3, #-1						; Adds #-1 to the value in R3. If it is #1 or #-1, we know there was either 2 or 0 
	BRnp SUB_NOT_NEG_3600				;   negative numbers inputted. If sum is #0, there was 1, in which case product is negative
		NOT R4, R4						; if there WAS one negative number, R4 is inverted to a negative number.
		ADD R4, R4, #1
		
SUB_NOT_NEG_3600:		
	
; (3) Restore registers 	
	
	LD R7, BACKUP_R7_3600
	LD R2, BACKUP_R2_3600
	LD R5, BACKUP_R5_3600

; (4) Return back to main

	RET
	
OVERFLOW:								; If product is not within range of bits, then we have an over or underflow,
										;    this part will determine that.
	ADD R5, R3, #-1						; Once again, we determine whether there was over or underflow by determining
	BRz UNDERFLOW						;    whether product was negative or positive.
	
	LEA R0, OVER_ERROR					; This part outputs error for overflow if product was positive.
	PUTS
	
	BRnzp SUB_SKIP_3600	
	
UNDERFLOW:

	LEA R0, UNDER_ERROR					; If product was negative, we output error for underflow here.
	PUTS
	
SUB_SKIP_3600:

	HALT
;----------------------------------
; Subroutine Data
;----------------------------------

	BACKUP_R7_3600		.BLKW	#1
	BACKUP_R2_3600		.BLKW	#1
	BACKUP_R4_3600		.BLKW	#1
	BACKUP_R5_3600		.BLKW	#1
	SUB_FIND_BIGGER_4000	.FILL	x4000
	TOTAL					.FILL	#0
	OVER_ERROR		.STRINGZ	"\nWoes! Overflow!\n"
	UNDER_ERROR		.STRINGZ	"\nWhoas! Underflow!\n"
	
.end
;----------------------------------------------------------------------------------------------
; Subroutine: SUB_MULT_TEN_3800
; Input(R1): The value to be multiplied by #10. 
; Postcondition: Uses a loop to multiply the value in R1 by #10, uses it for input subroutine.
; Return Value: R1 <-- 10 * R1
;----------------------------------------------------------------------------------------------

.orig x3800
;---------------------------
; Subroutine Instructions
;---------------------------

	ST R7, BACKUP_R7_3800
	ST R2, BACKUP_R2_3800
	ST R3, BACKUP_R3_3800

	LD R2, TEN					; R2 <--- value stored in address labelled TEN
	ST R1, VALUE				; Stores the user inputted value into address labelled VALUE
	LD R3, VALUE				; R3 <-- value stored in address labelled VALUE
	
LOOP_TEN_POW					; Beginning of loop to multiply VALUE by 10

	ADD R1, R1, R3				; Adds the user inputted value to the sum
	ADD R2, R2, #-1				; Counter to make sure we only iterate 10 times
	BRp LOOP_TEN_POW

	LD R7, BACKUP_R7_3800
	LD R2, BACKUP_R2_3800
	LD R3, BACKUP_R3_3800

	RET
	
	HALT
	
;------------------------------
; Subroutine Data
;------------------------------

	BACKUP_R7_3800	.BLKW	#1
	BACKUP_R2_3800	.BLKW	#1
	BACKUP_R3_3800	.BLKW	#1
	TEN			.FILL		#9
	VALUE		.FILL		#0

;----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_CHARS_4100
; Input (R1): Second value inputted by user. Used as a reference parameter.
; Input (R0): First value inputted by user. Used as a reference parameter.
; Postcondition: Subroutine finds the bigger and smaller of the two values in R1 and R0.
;					Swaps values, smaller in R0 and bigger in R1.					
; Return Value: None, it is a void function.
;----------------------------------------------------------------------------------------------

.orig x4000
;----------------------------
; Subroutine Instructions
;----------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_4000
	ST R3, BACKUP_R3_4000
	
; (2) Subroutine's Algorithm
	
	NOT R3, R0
	ADD R3, R3, #1
	
	ADD R3, R3, R1
	BRn R1_NOT_BIGGER				; Swaps the value in R1 and R0
		ST R1, BIGGER
		ST R0, SMALLER
		
	BRnzp SUB_SKIP_4000
	
R1_NOT_BIGGER:

	ST R0, BIGGER
	ST R1, SMALLER
	
SUB_SKIP_4000:
	
	
; (3) Restore registers 


	LD R7, BACKUP_R7_4000
	LD R3, BACKUP_R3_4000
	
; (4) Return back to main
	
	RET
	
	HALT
	
;-----------------------------
; Subroutine Data
;-----------------------------
	BACKUP_R7_4000	.BLKW	#1
	BACKUP_R3_4000	.BLKW	#1
	BIGGER			.FILL	#0
	SMALLER			.FILL	#0



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
	
	ADD R4, R4, #0
	BRzp SUB_NOT_NEG_4100
		NOT R4,R4
		ADD R4,R4, #1
		LD R0, NEG_CHAR_4100
		OUT

SUB_NOT_NEG_4100:	
	
	ADD R6, R5, R4
	BRzp START_HERE_ONE
		ADD R2, R2, #-1
		LDR R5, R2, #0
		LD R0, FIVE_DIGIT
		ADD R0, R0, #-1
		ST R0, FIVE_DIGIT
	
	ADD R6, R5, R4
	BRzp START_HERE_TWO
		ADD R2, R2, #-1
		LDR R5, R2, #0
		LD R0, FIVE_DIGIT
		ADD R0, R0, #-1
		ST R0, FIVE_DIGIT
	
	ADD R6, R5, R4
	BRzp START_HERE_THREE
		ADD R2, R2, #-1
		LDR R5, R2, #0
		LD R0, FIVE_DIGIT
		ADD R0, R0, #-1
		ST R0, FIVE_DIGIT
	
	ADD R6, R5, R4
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
	
	LDR R1, R2, #0					; Loads the power of ten
	AND R0, R0, #0					; Sets R0 to #0
	
PRINT_TEN_LOOP:						; Beginning of loop to print out characters

	ADD R4, R4, R1					; We subtract the power of ten from the number in R1
	BRn END_LOOP					; Once value in R1 is negative, we end the loop
	
	ADD R0, R0, #1					; This keeps track of how many times we subtract the power
	BRnzp PRINT_TEN_LOOP			; of ten from the value in R1, giving us the number of that digit
									; It keeps looping till value in R1 is negative
	
END_LOOP:
	
	NOT R1, R1						; Inverts power of ten to a positive
	ADD R1, R1, #1					; Adds power of ten back to value in R1 to get the positive number 
	ADD R4, R4, R1					;   before R1 became negative. This gives us the remainder of that power ten.
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

	.orig x4200
	
	ONE		.FILL   #-1
	TWO		.FILL	#-10
	THREE	.FILL	#-100
	FOUR	.FILL	#-1000
	FIVE	.FILL	#-10000
	
