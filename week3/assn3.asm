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
		
	LD R1, NUM		; Loads xABCD into R1.
	LD R2, CMP		; Loads #32767 into R2.
	LD R3, SP_COUNT		; Loads #4 into R3.
	LD R4, COUNT		; Loads #16 into R4.

	NOT R2, R2		; Inverts the bits in R2.

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
	HALT

	ONE	.FILL	#49		; Put #49 (ASCII '1') into memory here.
	ZERO	.FILL	#48		; Put #48 (ASCII '0') into memory here.
	CMP	.FILL	#32767		; Put #32767 into memory here (used to get 1000....0000
					;  in program).
	NUM	.FILL	xABCD		; Put xABCD into memory here (number to be converted).
	COUNT	.FILL	#16		; Put #16 into memory here. Also counter for outer
					;   loop.
	SP_COUNT	.FILL	#4	; Put #4 into memory here. Also counter for SPACE loop.
	SPACE	.STRINGZ	" "	; Put string " " into memory here. Used for spacing.
.end	
