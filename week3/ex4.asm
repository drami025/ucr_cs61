;
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 03
;


.orig x3000
;--------------------------
; Instructions
;--------------------------

	LEA R0, PROMPT			; Loads PROMPT string into R0
	PUTS				; Outputs PROMPT in R0
	LEA R0, NEWLINE			; Loads NEWLINE string into R0
	PUTS				; Outputs NEWLINE string in R0

	LD R3, ARRAY			; Loads the address of the beginning
					;  of array into R3

	DO_WHILE_LOOP			; Do-While loop beginning
		
		LEA R0, SPACE		; Loads SPACE string into R0
		PUTS			; Outputs SPACE string in R0

		GETC			; Gets user-inputted character, loads into R0
		OUT			; Outputs content of R0
		
		STR R0, R3, #0		; Stores the content of R0 to address stored in R3

		ADD R3, R3, #1		; Increments the address stored in R3 by #1
		
		ADD R0, R0, #-10	; Adds #-10 to content stored in R0, which was the
					;  user-inputted character.

	BRnp DO_WHILE_LOOP		; If the user character was a newline character, which
	END_DO_WHILE_LOOP		;   is #10 in the ASCII table, adding 10 would make it
					;   #0. So loop breaks if R0 - 10 = 0.
	LD R4, ARRAY			; Loads address stored in ARRAY label to R4

	LEA R0, NEWLINE			; Loads NEWLINE string into R0
	PUTS				; Outputs NEWLINE string in R0
	LEA R0, YOUR_ARRAY		; Loads YOUR_ARRAY string into R0
	PUTS				; Outputs YOUR_ARRAY string in R0
	
	WHILE_LOOP			; Beginning of another loop
		LEA R0, SPACE		; Loads SPACE string into R0
		PUTS			; Outputs SPACE string in R0

		LDR R0, R4, #0		; Loads the content of address stored in R4 to R0
		OUT			; Outputs content of R0
		
		ADD R4, R4, #1		; Increments the address contained in R4 by #1

		
		ADD R0, R0, #-10	; Adds #-10 to content stored at R0, which was the 
					;   user-inputted character.
	BRnp WHILE_LOOP			; Loop ends once R0 contains the newline character,
	END_WHILE_LOOP			;   which added with #-10, will give us 0.
		
		
	HALT
;-----------------------
; Local Data
;----------------------
	
	PROMPT	.STRINGZ	"Enter an array of characters(no spaces):"
	YOUR_ARRAY	.STRINGZ	"Your array: "
	ARRAY	.FILL	x4000			; Where our array will be stored.
	SPACE	.STRINGZ	" "
	NEWLINE	.STRINGZ	"\n"
	
.end
