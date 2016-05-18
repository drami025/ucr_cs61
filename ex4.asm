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

	LD R0, VAL_ONE		; R0 <-- x61  (#97/ 'a')
	LD R1, VAL_TWO		; R1 <-- x1A (#26)

	DO_WHILE_LOOP		; Beginning of my loop
		OUT		; Outputs R0
		ADD R0, R0, #1	; Increments value in R0
		ADD R1, R1, #-1	; Decrements value in R1
		BRp DO_WHILE_LOOP ; Loop continues if R1 > 0
	END_DO_WHILE_LOOP	; End of the loop

	HALT

;----------------
; Local Data
;----------------


	VAL_ONE	 .FILL   x61	; Puts x61 ('a') in memory here
	VAL_TWO  .FILL   x1A	; Puts x1A (#26) in memory here
.end
