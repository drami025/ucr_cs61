;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 03
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;----------------------
; Instructions
;----------------------
	
	LD R0, COUNTER			; R0 <-- Value stored in address labelled COUNTER
	LD R1, POINTER			; R1 <-- Value stored in address labelled POINTER
	LD R3, NUMBER			; R3 <-- Value stored in address labelled NUMBER

	FIRST_LOOP:			; Beginning of "FIRST_LOOP" loop
		STR R3, R1, #0		; Stores number in R3 to address in R1
		ADD R1, R1, #1		; Increments the address in R1 by #1
		ADD R3, R3, R3		; Doubles the value in R3
		ADD R0, R0, #1		; Adds #1 to the counter in R0
	BRn FIRST_LOOP			; Loop breaks once R0 is zero

	LD R1, POINTER			; R1 <-- Value stored in address labelled POINTER

	LD R2, COUNTER			; R2 <-- Value stored in address labelled COUNTER
	

	LAST_LOOP:			; Beginning of "LAST_LOOP" loop

	LD R4, SUBROUTE			; R4 <-- Value stored in address labelled SUBROUTE

	ST R2, COUNTER			; Stores the updated valued of the counter into COUNTER

	LDR R2, R1, #0			; R2<-- Loads the value in the address in R1

	JMP R4				; Jump to address stored in R4

	LD R0, NEWLINE			; R0 <-- Value stored in address labelled NEWLINE
	OUT				; Prints a NEWLINE to console

	LD R1, POINTER			; R1 <-- Value stored in address labelled POINTER
	ADD R1, R1, #1			; Increments the address in R1 by #1
	ST R1, POINTER			; Store the new address in R1 to address labelled POINTER
	
	LD R2, COUNTER			; R2 <-- Value stored in address labelled COUNTER
	ADD R2, R2, #1			; Adds #1 to the counter 
	
	BRn LAST_LOOP			; Once the counter is negative, we exit loop

	HALT
;------------------------------------
; Local Data
;------------------------------------
	
	NEWLINE		.FILL	#10	
	
	POINTER		.FILL	x4000
	
	COUNTER		.FILL	#-10
	
	NUMBER		.FILL	#1

	SUBROUTE	.FILL	x3500
	.orig x4000
		.BLKW		#10
	
.end	


.orig x3500
;-----------------------------------
; Subroutine Instructions
;-----------------------------------

	ST R2, NUM	
	LD R1, NUM		; Loads xABCD into R1.
	LD R2, CMP		; Loads #32767 into R2.
	LD R3, SP_COUNT		; Loads #4 into R3.
	LD R4, COUNT		; Loads #16 into R4.

	NOT R2, R2		; Inverts the bits in R2.

	LD R0, LETTERB
	OUT

	LOOP:			; Beginning of "Loop" loop.

	
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
	
	BRp LOOP		; Once the value stored in R4 falls to zero, loop finishes.

	LD R0, BACK		; R0 <-- Value stored in address labelled BACK
	JMP R0			; Jumps back to address stored in R0


	HALT
;------------------------------------
; Subroutine Data
;------------------------------------

	ONE	.FILL	#49		; Put #49 (ASCII '1') into memory here.
	ZERO	.FILL	#48		; Put #48 (ASCII '0') into memory here.
	CMP	.FILL	#32767		; Put #32767 into memory here (used to get 1000....0000
					;  in program).
	NUM	.FILL	xABCD		; Put xABCD into memory here (number to be converted).
	COUNT	.FILL	#16		; Put #16 into memory here. Also counter for outer
					;   loop.
	SP_COUNT	.FILL	#4	; Put #4 into memory here. Also counter for SPACE loop.
	SPACE	.STRINGZ	" "	; Put string " " into memory here. Used for spacing.
	LETTERB		.FILL	#98
	BACK	.FILL		x300E
