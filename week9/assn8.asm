;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Assignment 08
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;-----------------------------------------
; Instructions
;-----------------------------------------

	LD R0, welcome					; Outputs a welcome message
	PUTS
	
MENU_LOOP: 	 	 	
	
	LD R0, SUB_MENU_3200				; Loads address of the subroutine SUB_MENU_3200 into R0
	JSRR R0								; Jumps to subroutine to output the menu and have the user make a choice
	
	LD R4, CHAR_OFFSET
	
;-----------------------------------------------------------------------------------------------------------------	
; CHOICE 1 3400
;-----------------------------------------------------------------------------------------------------------------
	ADD R0, R1, #-1						; If the user input was #1, we continue to this part
	BRnp NOT_CHOICE_1
		LD R0, SUB_ALL_MACHINES_BUSY_3400	; We jump to subroutine that determines whether all machines are busy
		JSRR R0
		
	ADD R2, R2, #-1						; Adds #-1 to return value in R2. If sum is #0, then all machines are busy
	BRz ALL_ARE_BUSY
		LD R0, not_busy					; If sum was not #0, then we output that all machines are not busy
		PUTS
		BRnzp SKIP_CHOICE_1				
ALL_ARE_BUSY:

		LD R0, busy					; This outputs that all machines are busy
		PUTS
		
SKIP_CHOICE_1:

;-----------------------------------------------------------------------------------------------------------------
; CHOICE 2 3600
;-----------------------------------------------------------------------------------------------------------------		
		
NOT_CHOICE_1:

	ADD R0, R1, #-2						; If the user input was #2, we continue to this part
	BRnp NOT_CHOICE_2			
		LD R0, SUB_ALL_MACHINES_FREE_3600	; We jump to subroutine to determine if all machines are free or not
		JSRR R0
		
	ADD R2, R2, #-1						; Adds #-1 to return value in R2. If sum is #0, then all machines are free
	BRz ALL_ARE_FREE
		LD R0, not_free					; If sum was not #0, then we output that all machines are not free
		PUTS
		BRnzp SKIP_CHOICE_2
ALL_ARE_FREE:

		LD R0, free					; This outputs that all machines are free
		PUTS
		
SKIP_CHOICE_2:

		
;-----------------------------------------------------------------------------------------------------------------
; CHOICE 3 3800
;-----------------------------------------------------------------------------------------------------------------
		
NOT_CHOICE_2:

	ADD R0, R1, #-3						; If the user input was #3, we continue to this part
	BRnp NOT_CHOICE_3
		LD R0, SUB_NUM_BUSY_MACHINES_3800	; We jump to subroutine to determine how many machines are busy
		JSRR R0
		
	LEA R0, THERE_ARE
	PUTS
	
	ADD R3, R2, #-10					; Subtracts #10 from value in R2. If difference is negative, then character
	BRn SKIP_UNDER_TEN_3					; is under ten, so we can just add character offset
		AND R0, R0, #0	
		ADD R0, R0, #1					; If difference is #0, then we output a '1' to console, subtract 10 from value 
		ADD R0, R4, R0					; in R2, then we add offset to R2, and then display it onto console
		OUT
		ADD R2, R2, #-10
SKIP_UNDER_TEN_3:

	ADD R0, R2, R4
	OUT		
	
	LEA R0, MACHINES_BUSY
	PUTS
		
;-----------------------------------------------------------------------------------------------------------------
; CHOICE 4 4000
;-----------------------------------------------------------------------------------------------------------------
		
NOT_CHOICE_3:

	ADD R0, R1, #-4						; If the user input was #4, we continue to this part
	BRnp NOT_CHOICE_4					
		LD R0, SUB_NUM_FREE_MACHINES_4000	; We jump to subroutine to determine how many machines are free
		JSRR R0
		
		
	LEA R0, THERE_ARE
	PUTS
	
	ADD R3, R2, #-10					; Subtracts #10 from value in R2. If difference is negative, then character
	BRn SKIP_UNDER_TEN_4					; is under ten, so we can just add character offset
		AND R0, R0, #0	
		ADD R0, R0, #1					; If difference is #0, then we output a '1' to console, subtract 10 from value 
		ADD R0, R4, R0					; in R2, then we add offset to R2, and then display it onto console
		OUT
		ADD R2, R2, #-10
SKIP_UNDER_TEN_4:

	ADD R0, R2, R4
	OUT		
	
	LEA R0, MACHINES_FREE
	PUTS	
;-----------------------------------------------------------------------------------------------------------------
;CHOICE 5 4200
;-----------------------------------------------------------------------------------------------------------------
		
NOT_CHOICE_4:

	ADD R0, R1, #-5						; If the user input was #5, we continue to this part
	BRnp NOT_CHOICE_5
		LD R0, SUB_MACHINE_STATUS_4200	; We jump to subroutine to determine the status of a particular machine
		JSRR R0
		
	LEA R0, machine
	PUTS
	
	ADD R3, R1, #-10					; Subtracts #10 from value in R2. If difference is negative, then character
	
	BRn SKIP_UNDER_TEN_5					; is under ten, so we can just add character offset
		AND R0, R0, #0	
		ADD R0, R0, #1					; If difference is #0, then we output a '1' to console, subtract 10 from value 
		ADD R0, R4, R0					; in R2, then we add offset to R2, and then display it onto console
		OUT
		ADD R1, R1, #-10
SKIP_UNDER_TEN_5:

	ADD R0, R1, R4
	OUT			
		
	ADD R2, R2, #-1
	BRz ITS_FREE
		LEA R0, is_busy
		PUTS
		BRnzp SKIP_CHOICE_5
		
ITS_FREE:

	LEA R0, is_free
	PUTS
	
SKIP_CHOICE_5:
		
;-----------------------------------------------------------------------------------------------------------------
; CHOICE 6 4400
;-----------------------------------------------------------------------------------------------------------------
		
NOT_CHOICE_5:

	ADD R0, R1, #-6						; If the user input was #6, we continue to this part
	BRnp NOT_CHOICE_6
		LD R0, SUB_FIRST_FREE_4400		; We jump to subroutine to determine the first available machine
		JSRR R0
		
	LEA R0, available
	PUTS
	
	ADD R3, R2, #-10					; Subtracts #10 from value in R2. If difference is negative, then character
	BRn SKIP_UNDER_TEN_6					; is under ten, so we can just add character offset
		AND R0, R0, #0	
		ADD R0, R0, #1					; If difference is #0, then we output a '1' to console, subtract 10 from value 
		ADD R0, R4, R0					; in R2, then we add offset to R2, and then display it onto console
		OUT
		ADD R2, R2, #-10
SKIP_UNDER_TEN_6:

	ADD R0, R2, R4
	OUT		
	AND R0, R0, #0
	ADD R0, R0, #10
	OUT
	OUT
		
NOT_CHOICE_6:

	ADD R0, R1, #-7						; If the user input is #7, then this statement will exit the loop
	BRz QUIT_PROGRAM

IGNORE_NEWLINE:

	BRnzp MENU_LOOP						; Infinite-loop, unless #7 is chosen
	
QUIT_PROGRAM:

		LEA R0, GOODBYE					; Prints out goodbye in French
		PUTS

	HALT
;-----------------------------------------
; Data
;-----------------------------------------

	GOODBYE			.STRINGZ			"\n\nAU REVOIR, MON AMI! (...means bye in French...)\n"
	SUB_ALL_MACHINES_FREE_3600		.FILL		x3600
	SUB_NUM_BUSY_MACHINES_3800		.FILL		x3800
	SUB_NUM_FREE_MACHINES_4000		.FILL		x4000
	SUB_MACHINE_STATUS_4200			.FILL		x4200
	SUB_FIRST_FREE_4400				.FILL		x4400
	BACK_TO_BEGIN					.FILL		x3003
	SUB_ALL_MACHINES_BUSY_3400		.FILL		x3400
	SUB_MENU_3200	.FILL			x3200	
	CHAR_OFFSET						.FILL		#48	
	welcome							.FILL		x4665
	busy							.FILL		x4600
	not_busy						.FILL		x4636
	free							.FILL		x468F
	not_free						.FILL		x46B5	
	THERE_ARE			.STRINGZ		" There are " 
	MACHINES_BUSY		.STRINGZ		" machines that are busy.\n\n"
	MACHINES_FREE		.STRINGZ		" machines that are free.\n\n"
	machine				.STRINGZ		"\nMachine "
	is_busy				.STRINGZ		" is busy\n\n"
	is_free				.STRINGZ		" is free\n\n"
	available			.STRINGZ		" The first available machine is number "
	


.end

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_MENU_3200
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, allowed the
; user to select an option, and returned the selected option.
; Return Value (R1): The option selected: #1, #2, #3, #4, #5, #6 or #7
; no other return value is possible
;-----------------------------------------------------------------------------------------------------------------

.orig x3200
;----------------------------------------
; Subroutine Instructions
;----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value
	ST R7, BACKUP_R7_3200
	ST R0, BACKUP_R0_3200

; (2) Subroutine's Algorithm

	LEA R0, MENU_TITLE_3200				; Outputs menu tile to the console
	PUTS
	
	LEA R0, OPTIONS_3200				; Outputs menu options to the console
	PUTS
	
	GETC								; Gets character from user. This will correlate to the option user has chosen
	OUT
	
	AND R1, R0, #-1						; Copies the character into R1
	
	LD R0, CHAR_OFFSET_3200
	ADD R1, R1, R0
	
	; AND R0, R0, #0						; Sets the value in R0 to #10 to output 2 newline characters.
	; ADD R0, R0, #10
	; OUT
	; OUT

; (3) Restore registers 	

	LD R7, BACKUP_R7_3200
	LD R0, BACKUP_R0_3200
	
; (4) Return back to main	

	RET

	HALT
;----------------------------------------
; Subroutine Data
;----------------------------------------

	BACKUP_R7_3200		.BLKW		#1
	BACKUP_R0_3200		.BLKW		#1
	CHAR_OFFSET_3200	.FILL		#-48
	MENU_TITLE_3200		.STRINGZ		"***************************\n* THE BUSYNESS SERVER MENU*\n***************************\n\n"
	OPTIONS_3200		.STRINGZ		"Please select an enter a number that correlates to an option: \n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of a machine\n6. Report the number of the first available machine\n7. Quit program.\n\n" 
.end


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_ALL_MACHINES_BUSY_3400
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------

.orig x3400
;----------------------------------------
; Subroutine Instructions
;----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value
	
	ST R7, BACKUP_R7_3400
	ST R0, BACKUP_R0_3400
	
; (2) Subroutine's Algorithm
	
	LD R0, BUSYNESS_VECT_3400				; Loads the BUSYNESS vector into R0
	
	LDR R2, R0, #0							; copies the value of the BUSYNESS vector into R2
	
	ADD R2, R2, #0							; If all the bits in the BUSYNESS vector is 1, that means it is binary for #-1. Thus, if we add #1 to the 
	BRnp ALL_NOT_BUSY						;    BUSYNESS vector and get #0, all the machines are busy. Anything else would mean there are some free.
	
		AND R2, R2, #0						; This part sets the value in R1 to #1 because all bits in BUSYNESS vector were a #1	
		ADD R2, R2, #1					
		BRnzp ALL_BUSY
		
ALL_NOT_BUSY:
	
	AND R2, R2, #0							; Sets the value in R2 to #0, since not all bits in BUSYNESS vector were a 1.

	
ALL_BUSY:

; (3) Restore registers 	

	LD R7, BACKUP_R7_3400
	LD R0, BACKUP_R0_3400

; (4) Return back to main	

	RET

	HALT
;----------------------------------------
; Subroutine Data
;----------------------------------------

	BACKUP_R7_3400		.BLKW		#1
	BUSYNESS_VECT_3400	.FILL		x5000
	BACKUP_R0_3400		.BLKW		#1
.end

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_ALL_MACHINES_FREE_3600
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------

.orig x3600
;----------------------------------------
; Subroutine Instructions
;----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value
	
	ST R7, BACKUP_R7_3600
	ST R0, BACKUP_R0_3600
	
; (2) Subroutine's Algorithm
	
	LD R0, BUSYNESS_VECT_3600				; Loads the BUSYNESS vector into R0
	
	LDR R2, R0, #0							; copies the value of the BUSYNESS vector into R2
	
	ADD R2, R2, #1							; If all the bits in the BUSYNESS vector is 1, that means it is binary for #-1. Thus, if we add #1 to the 
	BRnp ALL_NOT_FREE						;    BUSYNESS vector and get #0, all the machines are busy. Anything else would mean there are some free.
	
		AND R2, R2, #0						; This part sets the value in R1 to #1 because all bits in BUSYNESS vector were a #1
		ADD R2, R2, #1						
		BRnzp ALL_FREE
		
ALL_NOT_FREE:
	
	AND R2, R2, #0							; Sets the value in R2 to #0, since not all bits in BUSYNESS vector were a 1.
	
ALL_FREE:

; (3) Restore registers 	

	LD R7, BACKUP_R7_3600
	LD R0, BACKUP_R0_3600

; (4) Return back to main	

	RET

	HALT
;----------------------------------------
; Subroutine Data
;----------------------------------------

	BACKUP_R7_3600		.BLKW		#1
	BACKUP_R0_3600		.BLKW		#1
	BUSYNESS_VECT_3600	.FILL		x5000

.end

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_NUM_BUSY_MACHINES_3800
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy
;-----------------------------------------------------------------------------------------------------------------

.orig x3800
;----------------------------------------
; Subroutine Instructions
;----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value
	ST R7, BACKUP_R7_3800
	ST R0, BACKUP_R0_3800
	ST R1, BACKUP_R1_3800
	ST R3, BACKUP_R3_3800
	ST R4, BACKUP_R4_3800

; (2) Subroutine's Algorithm

	LD R0, BUSYNESS_VECT_3800			; Loads the address of where the BUSYNESS vector is into R0
	LDR R4, R0, #0						; Loads the value of the BUSYNESS vector in R4
	
	NOT R4, R4							; Inverts bits in R4. It's a lot easier to detect 1's with a mask than 0's.
	
	AND R2, R2, #0						; Sets R2 to #0. R2 will have the number of machines that are busy.
	
	LD R1, NUM_OF_MACHINES_3800			; Loads #16 into R1. This is essentially our counter for the following loop.
	LD R3, MSB_3800						; Loads #-32768 into R3, which will be our mask for determining how many machines are busy
	
NUM_MACHINES_LOOP:

	AND R0, R4, R3						; If the MSB is a 1, then we move onto the next part and increment the value of R2 by 1.
	BRz NOT_IN_USE_3800					; If MSB is not a 1, then we skip next section
		ADD R2, R2, #1		
NOT_IN_USE_3800:
	
	ADD R4, R4, R4						; Here we left-shift all the bits for our mask.

	ADD R1, R1, #-1						; Decrements counter. Ends once it is #0.
	BRp NUM_MACHINES_LOOP

; (3) Restore registers 	

	LD R7, BACKUP_R7_3800
	LD R0, BACKUP_R0_3800
	LD R1, BACKUP_R1_3800
	LD R3, BACKUP_R3_3800
	LD R4, BACKUP_R4_3800

; (4) Return back to main	

	RET

	HALT
;----------------------------------------
; Subroutine Data
;----------------------------------------

	BACKUP_R7_3800		.BLKW		#1
	BACKUP_R0_3800		.BLKW		#1
	BACKUP_R1_3800		.BLKW		#1
	BACKUP_R3_3800		.BLKW		#1
	BACKUP_R4_3800		.BLKW		#1
	BUSYNESS_VECT_3800	.FILL		x5000
	NUM_OF_MACHINES_3800	.FILL	#16
	MSB_3800			.FILL		#-32768

.end

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_NUM_FREE_MACHINES_4000
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R2): The number of machines that are free 
;-----------------------------------------------------------------------------------------------------------------

.orig x4000
;----------------------------------------
; Subroutine Instructions
;----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value
	ST R7, BACKUP_R7_4000
	ST R0, BACKUP_R0_4000
	ST R1, BACKUP_R1_4000
	ST R3, BACKUP_R3_4000
	ST R4, BACKUP_R4_4000

; (2) Subroutine's Algorithm
	
	AND R2, R2, #0						; Sets R2 to #0. R2 will have the number of machines that are busy.
	
	LD R0, BUSYNESS_VECT_4000			; Loads the address of where the BUSYNESS vector is into R0
	LDR R4, R0, #0						; Loads the value of the BUSYNESS vector in R4
	
	LD R1, NUM_OF_MACHINES_4000			; Loads #16 into R1. This is essentially our counter for the following loop.
	LD R3, MSB_4000						; Loads #-32768 into R3, which will be our mask for determining how many machines are busy
	
NUM_MACHINES_LOOP_4000:

	AND R0, R4, R3						; If the MSB is a 1, then we move onto the next part and increment the value of R2 by 1.
	BRz NOT_IN_USE_4000					; If MSB is not a 1, then we skip next section
		ADD R2, R2, #1		
NOT_IN_USE_4000:
	
	ADD R4, R4, R4						; Here we left-shift all the bits for our mask.

	ADD R1, R1, #-1						; Decrements counter. Ends once it is #0.
	BRp NUM_MACHINES_LOOP_4000

; (3) Restore registers 	

	LD R7, BACKUP_R7_4000
	LD R0, BACKUP_R0_4000
	LD R1, BACKUP_R1_4000
	LD R3, BACKUP_R3_4000
	LD R4, BACKUP_R4_4000

; (4) Return back to main	

	RET

	HALT
;----------------------------------------
; Subroutine Data
;----------------------------------------

	BACKUP_R7_4000		.BLKW		#1
	BACKUP_R0_4000		.BLKW		#1
	BACKUP_R1_4000		.BLKW		#1
	BACKUP_R3_4000		.BLKW		#1
	BACKUP_R4_4000		.BLKW		#1
	BUSYNESS_VECT_4000	.FILL		x5000
	NUM_OF_MACHINES_4000	.FILL	#16
	MSB_4000			.FILL		#-32768

.end


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_MACHINE_STATUS_4200
; Input (R1): Which machine to check
; Postcondition: The subroutine has returned a value indicating whether the machine indicated
; by (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;-----------------------------------------------------------------------------------------------------------------

.orig x4200
;----------------------------------------
; Subroutine Instructions
;----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_4200
	ST R0, BACKUP_R0_4200
	ST R3, BACKUP_R3_4200
	ST R4, BACKUP_R4_4200


; (2) Subroutine's Algorithm

	LD R0, SUB_FIND_NUM_4800
	JSRR R0

	LD R0, BUSYNESS_VECT_4200				; Loads the address of the BUSYNESS vector into R0
	LDR R3, R0, #0							; Loads the BUSYNESS vector into R3
	
	AND R2, R2, #0							; Sets the value in R2 to #0

	AND R0, R0, #0							; Sets the value in R0 to #0 and then loads #15 into R0 to represent all the machines
	LD R0, NUM_OF_MACHINES_4200

	NOT R1, R1								; Inverts the number of the machine we want to check
	ADD R1, R1, #1
	
	ADD R0, R0, R1							; Here we subtract the machines wanted from the total machines. That way, we load that bit into 
	BRz CHECK_FIRST_4200					;   the MSB by left-shifting it however many times the difference is.

CHECK_MACHINE_4200:
	
	ADD R3, R3, R3
	
	ADD R0, R0, #-1
	BRp CHECK_MACHINE_4200					; Once the counter in R0 is #0, we have the wanted machine in the MSB
	
CHECK_FIRST_4200:

	LD R0, MSB_4200						; Loads the mask with 1 in its MSB to R0
	
	AND R3, R3, R0						; We find out through masking whether the machine is busy or not.
	BRz NOT_FREE_4200
		ADD R2, R2, #1					; Add #1 to R2 if machine is free
NOT_FREE_4200:
	
	NOT R1, R1
	ADD R1, R1, #1

; (3) Restore registers 	

	LD R7, BACKUP_R7_4200
	LD R0, BACKUP_R0_4200
	LD R3, BACKUP_R3_4200
	LD R4, BACKUP_R4_4200

; (4) Return back to main	

	RET

	HALT
;----------------------------------------
; Subroutine Data
;----------------------------------------

	BACKUP_R7_4200		.BLKW		#1
	BACKUP_R0_4200		.BLKW		#1
	BACKUP_R3_4200		.BLKW		#1
	BACKUP_R4_4200		.BLKW		#1
	NUM_OF_MACHINES_4200	.FILL		#15
	MSB_4200			.FILL		#-32768
	BUSYNESS_VECT_4200	.FILL		x5000
	SUB_FIND_NUM_4800	.FILL	x4800

.end

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_FIRST_FREE_4400
; Inputs: None
; Postcondition: 
; The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------

.orig x4400
;----------------------------------------
; Subroutine Instructions
;----------------------------------------

; (1) Backup R7 & any registers used in the subroutine except Return Value

	ST R7, BACKUP_R7_4400
	ST R0, BACKUP_R0_4400
	ST R1, BACKUP_R1_4400
	ST R3, BACKUP_R3_4400
	ST R4, BACKUP_R4_4400
	ST R5, BACKUP_R5_4400

; (2) Subroutine's Algorithm

	LD R0, BUSYNESS_VECT_4400				; Loads the address of BUSYNESS vector into R0
	LDR R1, R0, #0							; Loads the BUSYNESS vector into R1
	
	AND R2, R2, #0							; Sets value in R2 to #0
	
	AND R5, R5, #0							; Sets value in R5 to #0. This is the index of the machines.
	
	AND R3, R3, #0							; This part sets value of R3 to 1
	ADD R3, R3, #1
	
	LD R0, NUM_MACHINES_4400				; Loads #16 to R0
	
CHECK_FOR_FREE_4400:
	
	AND R4, R1, R3							; This determines whether the LSB is a 1 or 0. If it is a 0, then indexed machine is free.
	BRnp THIS_IS_FREE						; End loop if machine is free
	
	ADD R5, R5, #1							; Increments the index of the machines.
	ADD R3, R3, R3							; Left shifts the mask to determine whether the next machine is free or not.
	ADD R0, R0, #-1							; Subtracts from counter. If not found once counter reaches #0, we set R2 to #-1
	BRp CHECK_FOR_FREE_4400
	
	ADD R2, R2, #-1
	BRnzp NONE_FOUND 

THIS_IS_FREE:	
	
	AND R2, R5, #-1							; Copies index to R2

NONE_FOUND:
; (3) Restore registers 	

	LD R7, BACKUP_R7_4400
	LD R0, BACKUP_R0_4400
	LD R1, BACKUP_R1_4400
	LD R3, BACKUP_R3_4400
	LD R4, BACKUP_R4_4400
	LD R5, BACKUP_R5_4400

; (4) Return back to main	

	RET

	HALT
;----------------------------------------
; Subroutine Data
;----------------------------------------

	BACKUP_R7_4400		.BLKW		#1
	BACKUP_R0_4400		.BLKW		#1
	BACKUP_R1_4400		.BLKW		#1
	BACKUP_R3_4400		.BLKW		#1
	BACKUP_R4_4400		.BLKW		#1
	BACKUP_R5_4400		.BLKW		#1
	NUM_MACHINES_4400	.FILL		#16
	BUSYNESS_VECT_4400	.FILL		x5000

.end


;----------------------------------------
; Strings to use
;----------------------------------------
.orig x4600

	ALL_BUSY_3400		.STRINGZ		": All of the machines are busy (for some reason...)\n\n"
	NOT_BUSY_3400		.STRINGZ		": Not all of them are busy...quick! Use one!\n\n"
	WELCOME				.STRINGZ		"Welcome to the BUSYNESS SERVER program!\n\n"	
	ALL_FREE_3600		.STRINGZ		": All the machines are free! Yipee.\n\n"
	NOT_FREE_3600		.STRINGZ		": Sorry, some are busy, foo.\n\n"


;----------------------------------------
; Helper function for x4200 SUB_FIND_NUM_4800
;----------------------------------------
.orig x4800
;----------------------------------------
; Instructions
;----------------------------------------

	ST R7, BACKUP_R7_4800
	ST R0, BACKUP_R0_4800
	ST R2, BACKUP_R2_4800
	ST R3, BACKUP_R3_4800
	ST R4, BACKUP_R4_4800
	
IS_NOT_GOOD:
	
	LEA R0, CHOOSE_MACHINE					; Asks user to enter a machine number
	PUTS
	
	LD R2, MINUS_CHAR_OFFSET				; Loads character offet to R2 (-48)
	AND R1, R1, #0
	
	LD R4, COUNTER							; Sets counter (10) to R4
	AND R5, R5, #0
	ADD R5, R5, #1
	
GET_MACHINE_NUM:

	GETC									; Gets character from user
	OUT	
	
	ADD R3, R0, #-10						; Once user hits enter, loops quits
	BRz END_QUERY
		
	ADD R0, R0, R2							; Subtracts character offset to get binary value
	
	ADD R5, R5, #-1							; Subtracts 1 from R5. Will be #0 only once.
	BRz NO_TEN_LOOP
	
	AND R3, R1, #-1							; Subtracts from the counter
	
TEN_LOOP:	

		ADD R1, R1, R3						; Multiplies value in R1 by 10
		ADD R4, R4, #-1
		BRp TEN_LOOP

NO_TEN_LOOP:

		ADD R1, R1, R0						; Adds new character to R1
		
	BRnzp GET_MACHINE_NUM
	
END_QUERY:
	
	LD R4, CHECK_4800
	
	ADD R3, R4, R1
	BRnz IS_GOOD
	
		LEA R0, CHOOSE_AGAIN
		PUTS
		
		BRnzp IS_NOT_GOOD
	
IS_GOOD:	
	
	LD R7, BACKUP_R7_4800
	LD R0, BACKUP_R0_4800
	LD R2, BACKUP_R2_4800
	LD R3, BACKUP_R3_4800
	LD R4, BACKUP_R4_4800

	RET

	HALT
	
	BACKUP_R7_4800		.BLKW		#1
	BACKUP_R0_4800		.BLKW		#1
	BACKUP_R2_4800		.BLKW		#1
	BACKUP_R3_4800		.BLKW		#1
	BACKUP_R4_4800		.BLKW		#1
	CHOOSE_MACHINE		.STRINGZ	" Which machine do you want the status of (0 - 15)? Hit [ENTER] when done: "
	MINUS_CHAR_OFFSET	.FILL		#-48
	CHOOSE_AGAIN		.STRINGZ	 	"\n\nThis number seems to be out of range. Please choose again.\n\n"
	COUNTER				.FILL		#9
	CHECK_4800			.FILL		#-15
	

.end
;----------------------------------------
; BUSYNESS VECTOR
;----------------------------------------

.orig x5000
BUSYNESS		.FILL		x0010
