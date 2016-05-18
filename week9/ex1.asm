;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Lab 09
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;-----------------------------------------------
; Instructions
;-----------------------------------------------

	LEA R0, STACK_PROMPT			;Asks user to enter numbers into the stack.
	PUTS
	LD R1, STACK					; Loads the address of the stack into R1 and R2
	LD R2, STACK
	AND R3, R3, #0					; This sets the value of R3 (the capacity) to #3
	ADD R3, R3, #3
	
	LD R4, SUB_STACK_PUSH_3200		; R4 <-- the address of the subroutine 

STACK_LOOP:
		
	GETC							; Gets character from user
	OUT
	
	ADD R5, R0, #-10				; Stops getting characters from user when newline character is detected
	BRz END_STACK_LOOP
	
	JSRR R4							; Jumps to subroutine to push values into the stack
	
	BRnzp STACK_LOOP
	
END_STACK_LOOP:
	


	HALT
;-----------------------------------------------
; Data
;-----------------------------------------------

	SUB_STACK_PUSH_3200		.FILL		x3200
	STACK_PROMPT			.STRINGZ	"Enter numbers to put onto the stack. Hit [ENTER] when done: \n"
	STACK					.FILL		x3150


.end


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH_3200
; Parameter (R0): The value to push onto the stack
; Parameter (R1): stack_addr: A pointer to the beginning of the stack
; Parameter (R2): top: A pointer to the next place to PUSH an item
; Parameter (R3): capacity: The number of additional items the stack can hold
; Postcondition: The subroutine has pushed (R0) onto the stack. If an overflow
; occurred, the subroutine has printed an overflow error message
; and terminated.
; Return Value: R2 ﬂ updated top value
; R3 ﬂ updated capacity value
;-----------------------------------------------------------------------------------------------

.orig x3200
;---------------------------------------------
; Subroutine Instructions
;---------------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3200
	ST R4, BACKUP_R4_3200	
	
; (2) Subroutine's Algorithm		

	ADD R3, R3, #-1					; Once the remaining capacity is #0, if the user tries to add to the stack again, we overflow
	BRzp NO_OVERFLOW_3200	
		LEA R0, OVERFLOW_PROMPT_3200	; Tells user there was an overflow
		PUTS
		BRnzp OVERFLOWED_3200			; Jumps to after RET to halt/end the program

NO_OVERFLOW_3200:
		
	STR R0, R2, #0						; Stores the character into the top of the stack
	ADD R2, R2, #1						; Increments the value in R2 to point to the new top of the stack
	
; (3) Restore registers 	

	LD R7, BACKUP_R7_3200
	LD R4, BACKUP_R4_3200
		
; (4) Return back to main	
	
	RET

OVERFLOWED_3200:

	HALT
;---------------------------------------------
; Subroutine Data
;---------------------------------------------

	BACKUP_R7_3200		.BLKW		#1
	BACKUP_R4_3200		.BLKW		#1
	TERMINATE_ADDR		.FILL		x300D
	OVERFLOW_PROMPT_3200	.STRINGZ	"\n\nThe stack has an overflow. Terminating program. \n"

.end
