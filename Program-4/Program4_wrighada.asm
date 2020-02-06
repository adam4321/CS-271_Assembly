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
bangSym		BYTE	"!", 0
space		BYTE	" ", 0
byePrompt1	BYTE	"Results certified by Adam Wright.", 0
byePrompt2	BYTE	"Good-bye!", 0
quit_val	DWORD	1																; Integer holding 1 to quit or any other value to continue
numInput	DWORD	?																; Integer holding the current input number
print_val	DWORD	?																; Integer holding the lowest number entered - initialized to most opposite value


; Executable instructions

.code  
main PROC


; Introduce title, programmer, and extra credit options
	call	introduction


MAIN_LOOP:																			; Restart if chosen from quit proc


; Ask if the user wants to quit
	call	quit


; Check the value set in the quit procedure
	cmp		quit_val, 1
	jne		MAIN_LOOP


; Function that says "Good-bye"	
	call	farewell


; Exit to operating system
	exit							


main ENDP


; Procedure definitions

;------------------------------------------------------------
; introduction
;
; Prints the Introductory message
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
	call	CrLf
	mov		edx, OFFSET instr2
	call	WriteString
	mov		edx, OFFSET instr3
	call	WriteString
	call	CrLf

	ret

introduction ENDP

;------------------------------------------------------------
; getUserData
;
; Gets the number of composites to be displayed
;------------------------------------------------------------

getUserData PROC


	ret

getUserData ENDP


;------------------------------------------------------------
; validate
;
; Validates the user's entered value to be in range 1-400
;------------------------------------------------------------

validate PROC


	ret

validate ENDP


;------------------------------------------------------------
; showComposites
;
; Prints the composite numbers for the selected range
;------------------------------------------------------------

showComposites PROC


	ret

showComposites ENDP


;------------------------------------------------------------
; isComposite
;
; Determines if a value is a composite number
;------------------------------------------------------------

isComposite PROC


	ret

isComposite ENDP


;------------------------------------------------------------
; quit
;
; Prints the quit dialog
;------------------------------------------------------------

quit PROC

; Prompt the user to press 1 to quit or 2 to restart
	call	CrLf
	mov		edx, OFFSET	quitPrompt
	call	WriteString
	call	ReadInt
	mov		quit_val, eax

	ret

quit ENDP


;------------------------------------------------------------
; finish
;
; Prints the Goodbye message
;------------------------------------------------------------

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
