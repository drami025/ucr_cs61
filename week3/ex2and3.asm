;
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 03
;

.orig x3000
;------------------------
; Instructions
;------------------------

	LEA R0, PROMPT			; Loads PROMPT string in R0
	PUTS				; Prints PROMPT string

	LD R1, MINUS			; R1 <-- loads the hard-coded value #1

	LD R2, COUNTER1			; R2 <-- loads the hard-coded value #10
	NOT R2, R2			; R2 <-- gets the compliment of COUNTER1
	ADD R2, R2, #1			; R2 <-- completes the 2's compliment so that
					;   R2 is now #-10

	LD R3, ARRAY			; R3 <-- loads the address at label ARRAY,
					;  which is x302F

	DO_WHILE_LOOP			; Beginning of Do-While loop
		
		GETC			; Gets a character from user, stores into R0
		OUT			; Outputs the contents in R0
		
		STR R0, R3, #0		; Stores the character in R0 to R3

		ADD R3, R3, R1		; R3 <-- R3 + 1, to get the next address in the array.

		LEA R0, SPACE		; Loads SPACE string into R0
		PUTS			; Prints SPACE string in R0
		
		ADD R2, R2, R1		; Adds #1 to R2, which starts at #-10
	BRn DO_WHILE_LOOP		; Do-While loops ends when R2 is positive or zero.
	END_DO_WHILE_LOOP		; End of Do-While loop

	LEA R0, NEWLINE			; Loads NEWLINE string into R0
	PUTS				; Prints NEWLINE string in R0
	LEA R0, NEWLINE
	PUTS
	LEA R0, YOUR_ARRAY
	PUTS

	LD R2, COUNTER1			; Loads the hard-coded value #10 to R2
	NOT R2, R2			; Gets the complement of #10
	ADD R2, R2, #1			; Turns complement of #10 to #-10

	LD R4, ARRAY			; Loads the address stored in ARRAY label to R4

	WHILE_LOOP			; Beginning of another loop
		
		LDR R0, R4, #0		; Loads content in address contained in R4 into R0
		OUT			; Outputs contents of R0, essentially outputting
					;  the element of the array at address specified
					;   in R4 
		
		ADD R4, R4, #1		; Increments the address contained in R4 by one

		LEA R0, NEWLINE		; Outputs a newline	
		PUTS

		ADD R2, R2, R1		; Adds #1 to R2 (which at first is #-10) until it 
	BRn WHILE_LOOP			;   becomes positive or zero.
	END_WHILE_LOOP			; End of loop
		
		
	HALT
;------------------------------
; Local Data
;------------------------------
	
	PROMPT	.STRINGZ	"Enter 10 characters(no spaces):"
		.BLKW	#10
	ARRAY	.FILL	x303D		; Beginning address of size 10 array.
	COUNTER1	.FILL	#10	; First counter of 10
	COUNTER2	.FILL	#10	; Second counter of 10
	MINUS	.FILL	#1		; Although it says MINUS, it really is just positive #1
	SPACE	.STRINGZ	" "
	NEWLINE	.STRINGZ	"\n"
	YOUR_ARRAY	.STRINGZ	"Your array: \n"
	

.end
