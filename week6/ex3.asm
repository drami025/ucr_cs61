;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 06
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;------------------------------
; Instructions
;------------------------------

	;GETC						; This is the main function. It is my test harness.		
	;OUT							; Gets character and outputs it
		
	;LD R2, CHAR_OFFSET			; R2 <-- value in address labelled CHAR_OFFSET
	
	;ADD R0, R0, R2				; Adds the value in R0 with value in R2
	
	LD R0, SOME_NUM
	
	LD R1, SUB_RIGHT_SHIFT_3200	; Loads subroutine address into R1
	JSRR R1						; Jumps to subroutine
	

	HALT
	
	SUB_RIGHT_SHIFT_3200	.FILL	x3200
	CHAR_OFFSET				.FILL	#-48
	SOME_NUM				.FILL	#13
	
.end	

;----------------------------------------------------------------------------------------------
; Subroutine: SUB_RIGHT_SHIFT_3200
; Input (R0): A character from input to right shift bits
; Postcondition: The subroutine rights shifts all the bits in the inputted parameter
;					
; Return Value: (R0) <-- the right shifted value of the parameter
;----------------------------------------------------------------------------------------------

.orig x3200
;------------------------------
; Subroutine Instructions
;------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R1, BACKUP_R1_3200
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R7, BACKUP_R7_3200

; (2) Subroutine's Algorithm

	LD R1, LAST_NUM				; R1 <-- value stored in address labelled LAST_NUM
	AND R2, R2, #0				; Sets value in R2 to #0
	LD R3, COUNTER				; R3 <-- value stored in address labelled COUNTER
	
NEXT_SHIFT:

	AND R4, R1, R0				; Compares MSB, loads into R4
	BRz SKIP_ONE				; If MSB is a 1, skip this part
		ADD R0, R0, R0			; Left shifts bits 
		ADD R0, R0, #1			; Adds 1 to LSB to rotate overflowed 1
		BRnzp SKIP_ZERO			; Skips to SKIP_ZERO if it was a 1
		
SKIP_ONE:
	
		ADD R0, R0, R0			; If it was a zero, all we do is left shift
		
SKIP_ZERO: 						

		ADD R3, R3, #-1			; Adds #-1 to the counter, continues loop while positive
		BRp NEXT_SHIFT
		
		ADD R0, R0, #0
		BRzp NOT_ODD
			LD R1, RESTORE_ODD
			AND R0, R0, R1
NOT_ODD:

; (3) Restore registers 

	LD R1, BACKUP_R1_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R7, BACKUP_R7_3200

; (4) Return back to main

	RET


	HALT
;------------------------------
; Subroutine Data
;------------------------------

	BACKUP_R1_3200	.BLKW	#1
	BACKUP_R2_3200	.BLKW	#1
	BACKUP_R3_3200	.BLKW	#1
	BACKUP_R4_3200	.BLKW	#1
	BACKUP_R7_3200	.BLKW	#1
	LAST_NUM		.FILL	x8000
	COUNTER			.FILL	#15
	RESTORE_ODD		.FILL	#32767
.end
