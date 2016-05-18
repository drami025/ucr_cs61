;
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 03
;

.orig x3000
;-----------------
; Instructions
;-----------------

	LD R5, DATA_PTR		; R5 <-- loads memory address in DATA_PTR
	LD R6, DATA_PTR		; R6 <-- loads memory address in DATA_PTR

	ADD R6, R6, #1		; R6 <-- R6 + 1, which is the memory location after x4000

	LDR R3, R5, #0		; R3 <-- loads contents of memory address 
				;  stored in R5
	LDR R4, R6, #0		; R4 <-- loads contents of memory address
				;  stored in R6
	 
	ADD R3, R3, #1		; Increments R3 by #1
	ADD R4, R4, #1		; Increments R4 by #1
	
	STR R3, R5, #0		; Stores contents in R3 to address x4000
	STR R4, R6, #0		; Stores contents in R4 to address x4001
	HALT
;----------------
; Local Data
;----------------

	DATA_PTR	.FILL	x4000
	
;-----------------
; Remote Data
;-----------------
	.orig x4000		; New memory location point
	DEC_65	.FILL	#65	; Puts #65 into memory here
	HEX_41	.FILL	x41	; Puts x41 into memory here

.end
