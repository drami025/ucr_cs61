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
;-------------------------------------------------
; Instructions
;-------------------------------------------------
	LEA R0, STACK_PROMPT			; Asks user to enter a character to pop a value off the stack
	PUTS
	LD R1, STACK					; Loads the address of the stack into R1
	LD R2, TOP_STACK				; Loads the address of the top of the stack into R2
	AND R3, R3, #0					; This part sets the value in R3 to #3
	ADD R3, R3, #3
	
	LD R4, SUB_STACK_POP_3200		; Loads address of the subroutine into R4

STACK_LOOP:
		
	GETC							; Gets character from user
	OUT
	
	ADD R5, R0, #-10				; If user enters a newline character, we end loop
	BRz END_STACK_LOOP
	
	JSRR R4							; Jumps to subroutine SUB_STACK_POP_3200
	
	BRnzp STACK_LOOP
	
END_STACK_LOOP:
	


	HALT
;-----------------------------------------------
; Data
;-----------------------------------------------

	SUB_STACK_POP_3200		.FILL		x3200
	STACK_PROMPT			.STRINGZ	"Enter a character pop off a number from the stack. Hit [ENTER] when done: \n"
	STACK					.FILL		x3151
	TOP_STACK				.FILL		x3154
	
.orig x3150

HALT

	STACK1			.FILL 			#12
	STACK2			.FILL			#3
	STACK3 			.FILL 			#20


.end
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP_3200
; Parameter (R1): stack_addr: A pointer to the beginning of the stack
; Parameter (R2): top: A pointer to the item to POP
; Parameter (R3): capacity: The # of additional items the stack can hold
; Postcondition: The subroutine has popped MEM[top] off of the stack.
; If an underflow occurred, the subroutine has printed an
; underflow error message and terminated.
; Return Value: R0 <-- value popped off of the stack
; R2 <-- updated top value
; R3 <-- updated capacity value
;-----------------------------------------------------------------------------------------------

.orig x3200
;----------------------------------------------------------------------
; Subroutine Instructions
;----------------------------------------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_3200
	ST R4, BACKUP_R4_3200
	
; (2) Subroutine's Algorithm		
	
	NOT R5, R2						; We need to subtract the values in R1 and R2 together. If they equal each other, 
	ADD R5, R5, #1					; then we get #0 if we subtract them together. Thus we know there are no items in the stack
	ADD R5, R5, R1					; and we know there is an underflow
	BRnp NO_UNDERFLOW_3200
		LEA R0, UNDERFLOW_PROMPT	; Tells user there was an underflow
		PUTS
		BRnzp UNDERFLOWED_3200		; Jumps to after RET to halt/end the program
		
NO_UNDERFLOW_3200:

	ADD R3, R3, #1					; Adds 1 to the capacity
	ADD R2, R2, #-1					; Decrements value of R2 to point to the new top of the stack
	
; (3) Restore registers 	
	
	LD R7, BACKUP_R7_3200
	LD R4, BACKUP_R4_3200
	
; (4) Return back to main		
	
	RET
	
UNDERFLOWED_3200:	
	
	HALT
;----------------------------------------------------------------------
; Subroutine Data
;----------------------------------------------------------------------


	BACKUP_R7_3200		.BLKW		#1
	BACKUP_R4_3200		.BLKW		#1
	UNDERFLOW_PROMPT	.STRINGZ	"\n\nUnderflow detected. Program will now terminate. \n"
	TERMINATE_3200		.FILL		x300D
.end
