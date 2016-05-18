;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 05
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3200
;-------------------------------
; Subroutine Data
;-------------------------------

	LD R3, OFFSET				; R3 <-- the value stored in address labelled OFFSET

	LEA R0, PROMPT				; R0 <--- the contents of address labelled PROMPT
	PUTS

	GETC					; Gets first character inputted by user, assuming it is a valid number
	OUT

	ADD R0, R0, R3				; Subtracts #-48 to get binary value, not ASCII valued character

	ST R0, NUMBER				; Stores binary value into address labelled NUMBER
	LD R2, NUMBER				; R2 <-- the value stored in address labelled NUMBER

	LD R3, COUNTER				; R3 <-- the value stored in address labelled COUNTER
	LD R4, NUMBER				; R4 <-- the value stored in address labelled NUMBER

LOOP:
	ADD R2, R2, R4				; Adds number into a sum of those numbers, essentially multiplying by 10 for LOOP
	ADD R3, R3, #-1				; Subtracts one from the counter. Iterates only 9 times to add to R2 10 times.
	BRp LOOP				; Once R3 is #0, exit from loop.

	GETC					; Gets the second character from user.
	OUT

	LD R3, OFFSET				; R3 <-- the value stored in address labelled OFFSET

	ADD R0, R0, R3				; Subtracts #-48 to get binary value, not ASCII valued character
 
	ADD R2, R2, R0				; Adds the second number to first number.



	HALT

	PROMPT		.STRINGZ	"Enter a positive decimal value (from '00' - '20'): \n"
	NUMBER		.FILL		#0
	OFFSET		.FILL		#-48
	COUNTER		.FILL		#9
	

.end
