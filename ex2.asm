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

	LDI R3, NEW_DEC		; R3 <-- loads contents of memory 					;  address of NEW_DEC
	LDI R4, NEW_HEX		; R4 <-- loads contents of memory 					;  address of NEW_HEX
		 
	ADD R3, R3, #1		; Increments R3 by #1
	ADD R4, R4, #1		; Increments R4 by #1
	
	STI R3, NEW_DEC		; Stores contents in R3 to address x4000
	STI R4, NEW_HEX		; Stores contents in R4 to address x4001
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
