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
;------------------------------
; Instruction
;------------------------------

GO_BACK:				; Program starts all over if incorrect character put in

	LEA R0, PROMPT			; Prompt to tell user to enter a number (up to 5 chars)
	PUTS				

	LD R1, INPUT			; R1 <-- value stored in address labelled INPUT, which is #0
	LD R6, RESET			; R6 <-- value stored in address labelled RESET, which is #0
	ST R6, NEG_TEST			; Stores value in R6 to NEG_TEST (to reset NEG_TEST to #0)

LOOP:					; Beginning of main Loop


	GETC				; Gets character from console
	OUT				; Outputs character back to console

	ST R0, INPUT			; Stores the character in address labelled INPUT

	LD R2, INPUT			; R2 <--- character in INPUT
	ADD R2, R2, #-10		; Adds #-10 to value in R2. If it's a #0, then that means it was
	BRz SKIP_TO_END			;   a newline character ended, so we skip to the end of program
	
	LD R2, INPUT			; R2 <--- character in INPUT
	LD R3, NEG_CHAR			; R3 <--- value stored in address labelled NEG_CHAR
	ADD R2, R2, R3			; Adds value in R2 with R3. If it is #0, that means input was a
					;    negative character, so we skip to SKIP_NEG, near end of loop
	BRz SKIP_NEG

	LD R2, INPUT			; R2 <--- character in INPUT
	LD R3, POS_CHAR			; R3 <--- value stored in address labelled POS_CHAR
	ADD R2, R2, R3			; Adds value in R2 with R3. If it is #0, that means input was a
	BRz SKIP_POS			;    positive char, so we skip to SKIP_POS, at the end of loop

	LD R2, INPUT			; R2 <--- character in INPUT
	LD R3, BELOW_NUM		; R3 <-- value stored in address labelled BELOW_NUM
	ADD R2, R2, R3			; Adds value in R2 with R3. If it is negative or #0, input was a 
	BRnz ERROR1			;    character below the numbers in the ASCII table. Skip to ERROR1

	LD R2, INPUT			; R2 <--- character in INPUT
	LD R3, ABOVE_NUM		; R3 <--- value stored in address labelled ABOVE_NUM
	ADD R2, R2, R3			; Adds value in R2 with R3. If it is positive or zero, input was
	BRzp ERROR2			;   a character above numbers in the ASCII table. Skip to ERROR2
	
	LD R4, NUM_COUNT		; This parts stores into NUM_COUNT how many times a character
	ADD R4, R4, #1			;     was inputted
	ST R4, NUM_COUNT
	
	LD R4, FIRST			; R4 <-- value stored in address labelled FIRST, which is #1
	
	LD R2, CHAR_OFFSET		; R2 <--- Value stored in address labelled CHAR_OFFSET
	ADD R5, R0, R2			; Adds value in R0 (the original input) with R2. This loads the number,
					;   not ASCII value, of the input into R5
	ADD R4, R4, #-1			; Subtracts #1 from R4
	BRz SKIP_JUMP			; Since the value in R4 will only be #0 once in the program, this ensures we
		LD R6, SUBROUTE		;   don't multiply the first number by 10.
		JMP R6			; After the first input, we jump to subroutine SUBROUTE
SKIP_JUMP:		

	ST R4, FIRST
	
	ADD R1, R1, R5			; We now add the multiplied number by the inputted number 

SKIP_NEG:

	ADD R4, R4, #0			; We add value in R4 by #0. Since R4 will only be positive once, when the sign is
	BRnz SKIP_NEG_CHECK		;    determined, if the char was the negative char, R6 be value in NEG_TEST, add
	LD R6, NEG_TEST			;    #1 to itself, and then store it back into NEG_TEST. This can happen only once
	ADD R6, R6, #1
	ST R6, NEG_TEST

SKIP_NEG_CHECK:				

SKIP_POS:				
SKIP_TO_END:
	
	ADD R0, R0, #-10		; If the character is a newline character, the main loop breaks.
	BRnp LOOP

	BRnzp END			; Skips to end of program, to avoid setting off Errors.
ERROR1:
ERROR2:

	LEA R0, WRONG_CHAR		; If an incorrect ASCII character was inputted, prompt tells user to try again.
	PUTS

	LD R1, RESET			; Resets the value in R1 to #0
	ST R1, INPUT			; Stores #0 back to INPUT to reset the value in that address

	BRnzp GO_BACK			; Goes back to the beginning of program if there was an error.
	
MAKE_NEG:

END:
	LD R6, NEG_TEST			; R6 <-- value stored in address labelled NEG_TEST
	ADD R6, R6, #-1			; Adds #1 to value in R6. If it turns out to be #0, then we take the
	BRnp LAST_SKIP			;    two's complement of the entire number in R1
	
	NOT R1, R1			; Here we take the two's complement of R1 if user inputted number was negative
	ADD R1, R1, #1

LAST_SKIP:

	ADD R1, R1, #1
	LD R5, NUM_COUNT
	
	LD R0, SUB_PRINT_CHARS_3700
	
	JSRR R0
	
	HALT
;------------------------------
; Local Data
;------------------------------

	INPUT		.FILL		#0
	FIRST		.FILL		#1
	PROMPT		.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
	NEG_CHAR	.FILL		#-45
	POS_CHAR	.FILL		#-43
	BELOW_NUM	.FILL		#-47
	ABOVE_NUM	.FILL		#-58
	CHAR_OFFSET	.FILL		#-48
	SUBROUTE	.FILL		x3500
	WRONG_CHAR	.STRINGZ	"\n\nInput not a number. Please try again.\n\n"
	NEG_TEST	.FILL		#0
	RESET		.FILL		#0
	SUB_PRINT_CHARS_3700	.FILL	x3700
	NUM_COUNT	.FILL		#0

.end


.orig x3500
;---------------------------
; Instructions
;---------------------------

	LD R2, TEN				; R2 <--- value stored in address labelled TEN
	ST R1, VALUE				; Stores the user inputted value into address labelled VALUE
	LD R3, VALUE				; R3 <-- value stored in address labelled VALUE
	
LOOP_TEN_POW					; Beginning of loop to multiply VALUE by 10

	ADD R1, R1, R3				; Adds the user inputted value to the sum
	ADD R2, R2, #-1				; Counter to make sure we only iterate 10 times
	BRp LOOP_TEN_POW

	LD R6, BACK				; Loads address of the point we need to jump back to in main program
	JMP R6					; Jumps back to main program

	HALT

	TEN		.FILL		#9
	BACK		.FILL		x3025
	VALUE		.FILL		#0



;----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_CHARS_3700
; Input (R1): Some value to print out as characters to console 
; Input (R5): Some value that determined how many character inputs there were by user
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

; (2) Subroutine's Algorithm


	LD R0, SUB_NEW_LINE				; This part outputs a newline twice
	OUT
	OUT
	
	LD R3,SUB_CHAR_OFFSET			; R3 <--- the valued stored in the adress labelled SUB_CHAR_OFFSET
	LD R2, TENS_ARR					; Loads the location of an array where powers of #10 are stored.
	ADD R5, R5, #-1					; Adds one less to the number of characters inputted
	ADD R2, R2, R5					; Reason we add  #-1 to R5 to so we know what power of ten to start    
									;   from, which is what ADD R2, R2, R5 does.

NEXT_DIGIT:							; Loop to find out what the next digit in the value is 
	LDR R4, R2, #0					; Loads the power of ten
	AND R0, R0, #0					; Sets R0 to #0
	
PRINT_TEN_LOOP:						; Beginning of loop to print out characters

	ADD R1, R1, R4					; We subtract the power of ten from the number in R1
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
	ADD R1, R1, #0					; Once R1 is #0, we got all the numbers and outputted them correctly.
	BRnp NEXT_DIGIT
	
; (3) Restore registers 

	LD R7, BACKUP_R7_3700
	LD R0, BACKUP_R0_3700
	LD R1, BACKUP_R1_3700
	LD R2, BACKUP_R2_3700
	LD R3, BACKUP_R3_3700
	LD R4, BACKUP_R4_3700
	LD R5, BACKUP_R5_3700
	
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
	
