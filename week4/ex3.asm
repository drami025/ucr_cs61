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
;---------------------------
; Instructions
;---------------------------
	LD R0, COUNTER			; R0 <-- Value stored in address labelled COUNTER
	LD R1, POINTER			; R1 <-- Value stored in address labelled POINTER
	LD R3, NUMBER			; R3 <-- Value stored in address labelled NUMBER

	LOOP:				; Beginning of "LOOP" loop
		STR R3, R1, #0		; Stores number in R3 to address in R1
		ADD R1, R1, #1		; Increments the address in R1 by #1
		ADD R3, R3, R3		; Doubles the value in R3
		ADD R0, R0, #1		; Adds #1 to the counter in R0
	BRn LOOP			; Loop breaks once R0 is zero

	LD R1, POINTER			; R1 <-- Value stored in address labelled POINTER
	LDR R2, R1, #6			; R2 <-- the value stored in the address in R1, 
					;   with an offset of #6
	HALT
;---------------------------
; Local Data
;---------------------------
	
	POINTER		.FILL	x4000	; Address where array will be stored
	COUNTER		.FILL	#-10	; Counter for the LOOP loop
	NUMBER		.FILL	#1
	.orig x4000
		.BLKW		#10
	
.end
