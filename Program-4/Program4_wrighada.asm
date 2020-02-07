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
space		BYTE	"   ", 0
byePrompt1	BYTE	"Results certified by Adam Wright.", 0
byePrompt2	BYTE	"Good-bye!", 0
quitVal	DWORD	1																	; Integer holding 1 to quit or any other value to continue
numCheck	DWORD	0																; Integer representing a bool for whether the user number is in range (1 is in range)
compCheck	DWORD	1																; Integer representing a bool for whether a number is a composite (1 is in range)
numInput	DWORD	?																; Integer holding the user's input number
curVal		DWORD	4																; Integer holding the composite to be checked and printed
colNum		DWORD	0																; Integer counting the current column number


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
; Pre-conditions:	  ColNum = 0, 
; Post-conditions:
; Registers changed:  eax, ecx, edx
;------------------------------------------------------------------------------

showComposites PROC

; Loop from 1 - the user entered number
	call	CrLf
	mov		colNum, 0
	mov		ecx, numInput

LOOP_UNTIL_NUM:																		; 

COMPOSITE_LOOP:

; Call isComposite on current num
	mov		eax, curVal
	mov		compCheck, 0
	call	isComposite

; Check if isComposite passed
	cmp		compCheck, 1
	jne		COMPOSITE_LOOP															; JMP

; Print valid numbers
	mov		eax, curVal
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString

; Print 10 columns per line
	inc		colNum
	cmp		colNum, 10
	je		LAST_COLUMN																; 

CONTINUE:

; Complete an iteration or end loop
	inc		curVal
	loop	LOOP_UNTIL_NUM
	jmp		AFTER_LOOP																; 														

LAST_COLUMN:

; Don't add line after last line
	cmp		eax, numInput
	je		AFTER_LOOP																; 

LOOP_COLUMNS:

; Add a new line after 10 columns
	call	CrLf
	mov		colNum, 0
	jmp		CONTINUE																; 

AFTER_LOOP:																			

	ret

showComposites ENDP


;------------------------------------------------------------------------------
; isComposite
;
; Description:        Determines if a value is a composite number
; Pre-conditions:	  eax contains
; Post-conditions:
; Registers changed:  
;------------------------------------------------------------------------------

isComposite PROC

CHECK_1:

; Check n % (2 to n-1) == 0 (return true)
	mov		ebx, 2

CHECK_1_LOOP:

; Loop from 2 to n-1
	mov		eax, curVal
	sub		eax, 1
	cmp		ebx, eax
	jge		CHECK_2																	; 

	mov		eax, curVal
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	je		PASS																	; 
	inc		ebx
	jmp		CHECK_1_LOOP															; 

PASS:

; Passed composite test 
	mov		compCheck, 1

	ret

CHECK_2:

; Number is prime (return false)

	inc		curVal
	ret

isComposite ENDP


;------------------------------------------------------------------------------
; quit
;
; Description:        Prints the quit dialog
; Pre-conditions:
; Post-conditions:
; Registers changed:  edx, eax
;------------------------------------------------------------------------------

quit PROC

; Prompt the user to press 1 to quit or 2 to restart
	call	CrLf
	call	CrLf
	mov		edx, OFFSET	quitPrompt
	call	WriteString
	call	ReadInt
	mov		quitVal, eax
	mov		curVal, 4

	ret

quit ENDP


;------------------------------------------------------------------------------
; finish
;
; Description:        Prints the Goodbye message
; Pre-conditions:
; Post-conditions:
; Registers changed:  edx
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
