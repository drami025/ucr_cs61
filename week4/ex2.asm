;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 04
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;--------------------
; Instructions
;--------------------

	LD R0, COUNT			; R0 <-- Value stored in address labelled COUNT
	LD R1, POINTER			; R1 <-- Value stored in address labelled POINTER
	LD R3, NUMBER			; R3 <-- Value stored in address labelled NUMBER
	LD R4, CHAR_ADD			; R4 <-- Value stored in address labelled CHAR_ADD

	LOOP:				; Beginning of "LOOP" loop
		STR R3, R1, #0		; Stores number in R3 to address in R1
		ADD R1, R1, #1		; Increments the address in R1 by #1
		ADD R3, R3, #1		; Adds #1 to number in R3
		ADD R0, R0, #1		; Adds #1 to the counter in R0
	BRn LOOP			; Loop breaks once R0 is zero

	LD R2, COUNT			; Reloads COUNT to R2 to begin another loop
	LD R1, POINTER			; R1 <-- Value stored in address labelled POINTER
	
	WHILE_LOOP:			; Beginning of "LOOP" Loop
		LDR R0, R1, #0		; Loads the content of array into R0
		ADD R0, R0, R4		; Adds 48 to value in R0 to get correct ASCII value
		OUT			; Outputs value in R0

		LD R0, SPACE		; Loads  #32, which is a space in ASCII, to R0
		OUT			; Outputs space

		ADD R1, R1, #1		; Adds #1 to increment to the next index of array
		ADD R2, R2, #1		; Adds #1 to counter
	BRn WHILE_LOOP 			; Once R2 is #0, exit loop
	
	HALT
;--------------------------
; Local Data
;--------------------------
	
	SPACE		.FILL	#32
	CHAR_ADD	.FILL	#48
	POINTER		.FILL	x4000
	COUNT		.FILL	#-10
	NUMBER		.FILL	#0
	.orig x4000
		.BLKW		#10
	
.end
