TITLE Program 4                 Program4_wrighada.asm

; Author:						Adam Wright
; Last Modified:				2-6-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271-400
; Project Number:               4  
; Due Date:						2-16-2020
; Description:					Assembly program which prompts the user to enter
;								the amount of composite numbers to be displayed
;								in the range of 1-400 and then calculates and 
;								displays the numbers.


INCLUDE Irvine32.inc


; Constant definitions


MIN_NUM = 1																			; Constant holding the lowest possbie value for input
MAX_NUM = 400																		; Constant holding the highest possible value for input


; Variable definitions

.data
intro		BYTE	"Program-4 -- Composite Numbers", 0
programmer	BYTE	"Programmed by Adam Wright", 0
extCred1	BYTE	"**EC-1: Align the output columns.", 0
userPrompt	BYTE	"What's your name? ", 0
userGreet	BYTE	"Hello, ", 0
instr1		BYTE	"Enter the number of composite numbers ", 0
instr2		BYTE	"you would like to see.", 0
instr3		BYTE	"I can print up to 400 composites.", 0
numPrompt	BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
errPrompt	BYTE	"Number Invalid!", 0
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
space		BYTE	" ", 0
byePrompt1	BYTE	"Results certified by Adam Wright.", 0
byePrompt2	BYTE	"Good-bye!", 0
quitVal	DWORD	1																	; Integer holding 1 to quit or any other value to continue
numCheck	DWORD	0																; Integer representing a bool for whether the user number is in range (1 is in range)
compCheck	DWORD	1																; Integer representing a bool for whether a number is a composite (1 is in range)
numInput	DWORD	?																; Integer holding the user's input number
printVal	DWORD	?																; Integer holding the composite to be printed


; Executable instructions

.code  
main PROC

; Introduce title, programmer, and extra credit options
	call	introduction


MAIN_LOOP:																			; Restart if chosen from quit proc

; Prompt for the number of composites
	call	getUserData

; Calculate and print composites
	call	showComposites

; Ask if the user wants to quit
	call	quit

; Check the value set in the quit procedure
	cmp		quitVal, 1
	jne		MAIN_LOOP																; Jmp to reset

; Function that says "Good-bye"	
	call	farewell


; Exit to operating system
	exit							

main ENDP


; Procedure definitions

;------------------------------------------------------------
; introduction
;
; Description:       Prints the Introductory message
; Pre-conditions:	 none
; Post-conditions:	 none
; Registers changed: edx
;------------------------------------------------------------

introduction PROC

; Introduce title, programmer, and extra credit options
	call	CrLf
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET programmer
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET extCred1
	call	WriteString
	call	CrLf
	call	CrLf

; Print the instructions
	mov		edx, OFFSET instr1
	call	WriteString
	mov		edx, OFFSET instr2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instr3
	call	WriteString
	call	CrLf

	ret

introduction ENDP


;------------------------------------------------------------------------------
; getUserData
;
; Description:       Gets the number of composites to be displayed
; Pre-conditions:	 none
; Post-conditions:	 validated number of composites stored in numInput
; Registers changed: edx, eax
;------------------------------------------------------------------------------

getUserData PROC

RE_RUN:

; Prompt and receive the user value
	call	CrLf
	mov		edx, OFFSET numPrompt
	call	WriteString
	call	ReadInt
	mov		numInput, eax
	call	validate

; Check the bool and pass or print error message
	cmp		numCheck, 1
	je		TEST_EXIT																; JE
	call	CrLf
	mov		edx, OFFSET errPrompt
	call	WriteString
	call	CrLf
	jmp		RE_RUN																	; JMP

TEST_EXIT:

	ret

getUserData ENDP


;------------------------------------------------------------------------------
; validate
;
; Description:        Validates the user's entered value to be in range 1-400
; Pre-conditions:	  potentially in range number of composites in numInput
; Post-conditions:	  numCheck set to 1 for passing or 0 for failure
; Registers changed:  eax
;------------------------------------------------------------------------------

validate PROC

; Test that the numInput is between 1-400 inclusive
	mov		numCheck, 0
	mov		eax, numInput
	cmp		eax, MIN_NUM
	jge		HIGH_CHECK																; Pass low range
	jmp		TEST_EXIT																; Failed low range

HIGH_CHECK:
	
; Check the value against max of range
	cmp		eax, MAX_NUM
	jle		TEST_PASS																; High range passed
	jmp		TEST_EXIT																; Test failed

TEST_PASS:																			; Both tests pass

; Set numCheck to 1 because it passed
	mov		numCheck, 1

TEST_EXIT:

	ret

validate ENDP


;------------------------------------------------------------------------------
; showComposites
;
; Description:        Prints the composite numbers for the selected range
; Pre-conditions:
; Post-conditions:
; Registers changed:
;------------------------------------------------------------------------------

showComposites PROC

; Loop from 1 - the user entered number
	mov		eax, MIN_NUM
	mov		ecx, numInput

L1:

	call	CrLf
	call	WriteDec
	call	CrLf
	inc		eax
	loop	L1

	ret

showComposites ENDP


;------------------------------------------------------------------------------
; isComposite
;
; Description:        Determines if a value is a composite number
; Pre-conditions:
; Post-conditions:
; Registers changed:
;------------------------------------------------------------------------------

isComposite PROC


	ret

isComposite ENDP


;------------------------------------------------------------------------------
; quit
;
; Description:        Prints the quit dialog
; Pre-conditions:
; Post-conditions:
; Registers changed:
;------------------------------------------------------------------------------

quit PROC

; Prompt the user to press 1 to quit or 2 to restart
	call	CrLf
	mov		edx, OFFSET	quitPrompt
	call	WriteString
	call	ReadInt
	mov		quitVal, eax

	ret

quit ENDP


;------------------------------------------------------------------------------
; finish
;
; Description:        Prints the Goodbye message
; Pre-conditions:
; Post-conditions:
; Registers changed:
;------------------------------------------------------------------------------

farewell PROC															

; Say "Good-bye""
	call	CrLf
	mov		edx, OFFSET byePrompt1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET byePrompt2
	call	WriteString
	call	CrLf

	ret

farewell ENDP


END main
