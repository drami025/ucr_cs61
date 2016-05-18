;
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 02
;

.orig x3000
;-----------------
; Instructions
;-----------------

	LD R5, NEW_DEC		; R5 <-- contents stored in NEW_DEC
	LD R6, NEW_HEX		; R6 <-- contents stores in NEW_HEX

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

	NEW_DEC	.FILL x4000	; Puts x4000 address here
	NEW_HEX	.FILL x4001	; Puts x4001 address here
	
	.orig x4000		; New memory location point
	DEC_65	.FILL	#65	; Puts #65 into memory here
	HEX_41	.FILL	x41	; Puts x41 into memory here

.end
