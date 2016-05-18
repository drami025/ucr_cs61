;===============================================================
; Ramirez, Daniel
; Login: drami025 (drami025@ucr.edu)
; Section: 022
; TA: Aditya Tammewar
; Assignment 07
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;===============================================================

.orig x3000
;----------------------------------------------------------
; Instructions
;----------------------------------------------------------

	LEA R0, ASK_SENTENCES
	PUTS
	
	LD R1, ARRAY_SENTENCES
	LD R2, INPUT_SENTENCES_3200
	JSRR R2

	LD R0, FIND_LONGEST_WORD_3400
	JSRR R0
	
	LD R0, NEWLINE
	OUT
	OUT
	
	LD R3, PRINT_ANALYSIS_3600
	JSRR R3

	HALT
	
	ASK_SENTENCES		.STRINGZ	"Please enter a sentence: "
	ARRAY_SENTENCES		.FILL		x4001
	INPUT_SENTENCES_3200	.FILL	x3200
	FIND_LONGEST_WORD_3400 .FILL	x3400
	PRINT_ANALYSIS_3600		.FILL	x3600
	NEWLINE					.FILL	#10
	
	
.end

;----------------------------------------------------------
; Array to be stored at
;----------------------------------------------------------

.orig x4000

	HALT
	
.end

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: INPUT_SENTENCE_3200
; Input (R1): The address of where to store the array of words
; Postcondition: The subroutine has collected an ENTER-terminated string of words from
; the user and stored them in consecutive memory locations, starting at (R1).
; Return Value: None
;-----------------------------------------------------------------------------------------------------------------

.orig x3200
;----------------------------------------------------------
;Subroutine Instructions
;----------------------------------------------------------

	ST R0, BACKUP_R0_3200
	ST R1, BACKUP_R1_3200
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R7, BACKUP_R7_3200
	
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	
	LD R3, SPACE_OFFSET_3200
	
GET_WORD_3200:
WAS_SPACE_3200:

	GETC
	OUT
	
	ADD R4, R0, #-10
	BRz END_ARRAY_3200
	
	ADD R4, R0, R3
	BRnp NOT_SPACE_3200
		AND R0, R0, #0
		STR R0, R1, #0
		ADD R1, R1, #1
		BRnzp WAS_SPACE_3200
		
NOT_SPACE_3200:
	
	STR R0, R1, #0
	ADD R1, R1, #1
	BRnzp GET_WORD_3200
	
END_ARRAY_3200:

	AND R0, R0, #0
	STR R0, R1, #0

	LD R0, BACKUP_R0_3200
	LD R1, BACKUP_R1_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R7, BACKUP_R7_3200
	
	RET

	HALT
	
;--------------------------------------------
; Subroutine Data
;--------------------------------------------
	
	BACKUP_R0_3200		.BLKW			#1
	BACKUP_R1_3200		.BLKW			#1
	BACKUP_R2_3200		.BLKW			#1
	BACKUP_R3_3200		.BLKW			#1
	BACKUP_R4_3200		.BLKW			#1
	BACKUP_R7_3200		.BLKW			#1
	SPACE_OFFSET_3200	.FILL			#-32
	
.end

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIND_LONGEST_WORD_3400
; Input (R1): The address of the array of words
; Postcondition: The subroutine has located the longest word in the array of words
; Return value (R2): The address of the beginning of the longest word
;-----------------------------------------------------------------------------------------------------------------

.orig x3400
;-------------------------------------------------
; Subroutine Instructions
;-------------------------------------------------

	ST R7, BACKUP_R7_3400
	ST R0, BACKUP_R0_3400
	ST R1, BACKUP_R1_3400
	ST R3, BACKUP_R3_3400
	ST R4, BACKUP_R4_3400
	ST R5, BACKUP_R5_3400
	
	AND R0, R0, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R5, R1, #-1
	
	ST R1, LONGEST_3400
	LDR R4, R1, #0
	
FIND_LONGEST_WORD:

	ADD R4, R4, #0
	BRz NEXT_WORD

NEXT_LETTER: 
	ADD R3, R3, #1
	ADD R1, R1, #1
	LDR R4, R1, #0
	ADD R4, R4, #0
	BRnp NEXT_LETTER
	
	NOT R3, R3
	ADD R3, R3, #1
	ADD R0, R2, R3
	BRzp NOT_BIGGER
	
		ST R5, LONGEST_3400
		NOT R3, R3
		ADD R3, R3, #1
		AND R2, R3, #-1
		
NOT_BIGGER:
NEXT_WORD: 

	AND R3, R3, #0
	ADD R1, R1, #1
	AND R5, R1, #-1
	LDR R4, R1, #0
	ADD R4, R4, #0
	BRnp FIND_LONGEST_WORD
	
	LD R2, LONGEST_3400
	
	
	LD R7, BACKUP_R7_3400
	LD R0, BACKUP_R0_3400
	LD R1, BACKUP_R1_3400
	LD R3, BACKUP_R3_3400
	LD R4, BACKUP_R4_3400
	LD R5, BACKUP_R5_3400
	
	RET
	
	HALT
;--------------------------------------------
; Subroutine Data
;--------------------------------------------	
	
	BACKUP_R7_3400		.BLKW			#1
	BACKUP_R0_3400		.BLKW			#1
	BACKUP_R1_3400		.BLKW			#1
	BACKUP_R3_3400		.BLKW			#1
	BACKUP_R4_3400		.BLKW			#1
	BACKUP_R5_3400		.BLKW			#1
	LONGEST_3400		.FILL			#0
	
.end

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_ANALYSIS
; Input (R1): The address of the beginning of the array of words
; Input (R2): The address of the longest word
; Postcondition: The subroutine has printed out a list of all the words entered as well as the
; longest word in the sentence.
; Return Value: None
;-----------------------------------------------------------------------------------------------------------------

.orig x3600
;--------------------------------------------
; Subroutine Instructions
;--------------------------------------------
	ST R0, BACKUP_R0_3600
	ST R1, BACKUP_R1_3600
	ST R7, BACKUP_R7_3600
	
	LEA R0, WORDS_IN_SENTENCE
	ADD R0, R0, #1
	PUTS
	
	LDR R0, R1, #0

PRINT_WORDS_3600:

	ADD R0, R0, #0
	BRz PRINT_NEXT_WORD

PRINT_NEXT_LETTER:

	OUT
	ADD R1, R1, #1
	LDR R0, R1, #0
	ADD R0, R0, #0
	BRnp PRINT_NEXT_LETTER

PRINT_NEXT_WORD:
	
	ADD R1, R1, #1
	LDR R0, R1, #0
	ADD R0, R0, #0
	BRz END_PRINT_3600
	
	LEA R0, COMMA_SPACE
	PUTS
	
	LDR R0, R1, #0
	BRnzp PRINT_WORDS_3600
	
END_PRINT_3600: 

	LEA R0, END_BRACKET
	PUTS
	LEA R0, LONGEST_IN_SENT
	PUTS
	AND R0, R2, #-1
	PUTS
	LD R0, END_PARENT
	OUT

	LD R0, BACKUP_R0_3600
	LD R1, BACKUP_R1_3600
	LD R7, BACKUP_R7_3600
	
	RET
	
	
	HALT
	
;--------------------------------------------
; Subroutine Data
;--------------------------------------------

	BACKUP_R0_3600
	BACKUP_R1_3600
	BACKUP_R7_3600
	WORDS_IN_SENTENCE	.STRINGZ	" The words in the sentence include: {\""
	COMMA_SPACE			.STRINGZ 	"\", \""
	END_BRACKET			.STRINGZ	"\"} \n\n"
	LONGEST_IN_SENT		.STRINGZ	"The longest word is: \""
	END_PARENT			.FILL		#34
