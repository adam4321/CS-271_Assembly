TITLE Program 5                 Program5_wrighada.asm

; Author:						Adam Wright
; Last Modified:				2-17-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271-400
; Project Number:               5  
; Due Date:						3-1-2020
; Description:					Assembly program which 


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
space1		BYTE	"     ", 0
space2		BYTE	"    ", 0
space3		BYTE	"   ", 0
byePrompt1	BYTE	"Results certified by Adam Wright.", 0
byePrompt2	BYTE	"Good-bye!", 0
quitVal		DWORD	1																; Integer holding 1 to quit or any other value to continue
numCheck	DWORD	0																; Integer representing a bool for whether the user number is in range (1 is in range)
compCheck	DWORD	1																; Integer representing a bool for whether a number is a composite (1 is composite)
numInput	DWORD	?																; Integer holding the user's input number
curVal		DWORD	4																; Integer holding the composite to be checked and printed
colNum		DWORD	0																; Integer counting the current column number
numPrinted	DWORD	0																; Integer counting the amount of printed numbers


; Executable instructions

.code  
main PROC

; Introduce title, programmer, and extra credit options
	call	introduction

MAIN_LOOP:																			; Restart (quitVal == 1) JMP From: line-73

; Prompt for the number of composites
	call	getUserData

; Calculate and print composites
	call	showComposites

; Ask if the user wants to quit
	call	quit

; Check the value set in the quit procedure
	cmp		quitVal, 1
	jne		MAIN_LOOP																; Enter 1 to reset JMP To: line-60

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

; Prompt for user value and call validate proc
	call	CrLf
	mov		edx, OFFSET numPrompt
	call	WriteString
	call	ReadInt
	mov		numInput, eax
	call	validate

; Check the bool and pass or print error message
	cmp		numCheck, 1
	je		TEST_EXIT																; User num passes validation JE To: line-156
	call	CrLf
	mov		edx, OFFSET errPrompt
	call	WriteString
	call	CrLf
	jmp		RE_RUN																	; Retry when user num fails validation JMP To: line-137

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
	jge		HIGH_CHECK																; Pass low range move to high test JGE To: line-181
	jmp		TEST_EXIT																; Failed low range JMP To: line-193

HIGH_CHECK:
	
; Check the value against max of range
	cmp		eax, MAX_NUM
	jle		TEST_PASS																; High range passed JLE To: line-188
	jmp		TEST_EXIT																; Test failed JMP To: line-193

TEST_PASS:																			; Both tests passed JLE From: line-185

; Set numCheck to 1 because it passed, else it stays 0 for fail
	mov		numCheck, 1

TEST_EXIT:

	ret

validate ENDP


;------------------------------------------------------------------------------
; showComposites
;
; Description:        Prints the composite numbers for the selected range
; Pre-conditions:	  ColNum == 0, curVal == 4, numInput in range
; Post-conditions:	  all composite numbers in user's range are printed
; Registers changed:  eax, ecx, edx
;------------------------------------------------------------------------------

showComposites PROC

; Loop from 1 - the user entered number
	call	CrLf
	mov		colNum, 0
	mov		ecx, numInput

LOOP_UNTIL_NUM:																		; Loop using LOOP instruction until inputNum reached From: line-272

COMPOSITE_LOOP:

; Call isComposite on current num
	mov		eax, curVal
	mov		compCheck, 0
	call	isComposite

; Check if isComposite passed
	cmp		compCheck, 1
	jne		COMPOSITE_LOOP															; Not a composite then skip JMP To: line-218

; Print valid number and check length for spaces
	inc		numPrinted
	mov		eax, curVal
	call	WriteDec
	cmp		eax, 9
	jle		SPACE_1                                                                 ; 1 digit number JLE To: line-239
	cmp		eax, 99
	jle		SPACE_2                                                                 ; 2 digit number JLE To: line-246
	jmp		SPACE_3                                                                 ; 3 digit number JMP To: line-253

SPACE_1:

; Print spaces (1 digit 5 spaces)
	mov		edx, OFFSET space1
	call	WriteString
	jmp		COLUMN_CHECK                                                            ; Space added JMP To: line-260

SPACE_2:

; Print spaces (2 digit 4 spaces)
	mov		edx, OFFSET space2
	call	WriteString
	jmp		COLUMN_CHECK                                                            ; Space added JMP To: line-260

SPACE_3:

; Print spaces (3 digit 3 spaces)
	mov		edx, OFFSET space3
	call	WriteString
	jmp		COLUMN_CHECK                                                            ; Space added JMP To: line-260

COLUMN_CHECK:


; Print 10 columns per line
	inc		colNum
	cmp		colNum, 10
	je		LAST_COLUMN																; Check for last row before adding newline JE To: line-275 

CONTINUE:

; Complete an iteration or end loop
	inc		curVal
	loop	LOOP_UNTIL_NUM
	jmp		AFTER_LOOP																; Loop completed JMP To: line-289													

LAST_COLUMN:

; Check for last row to skip newline
	mov		eax, numInput
	cmp		eax, numPrinted
	je		CONTINUE																; Loop completed JMP To: line-289

LOOP_COLUMNS:

; Add a new line after 10 columns
	call	CrLf
	mov		colNum, 0
	jmp		CONTINUE																; Continue after newline JMP To: line-268

AFTER_LOOP:																			

	ret

showComposites ENDP


;------------------------------------------------------------------------------
; isComposite
;
; Description:        Determines if a value is a composite number
; Pre-conditions:	  curVal contains 4, compCheck contains 0
; Post-conditions:	  compCheck remains 0 for fail or set to 1 for pass
; Registers changed:  eax, ebx, edx
;------------------------------------------------------------------------------

isComposite PROC

CHECK_1:

; Check n % (2 to i-1) == 0 (composite number)
	mov		ebx, 2

CHECK_1_LOOP:

; Loop from 2 to n-1
	mov		eax, curVal
	sub		eax, 1
	cmp		ebx, eax
	jge		CHECK_2																	; Exit when loop reaches n-1 JGE To: line-336

; Div and check remainder == 0 to pass
	mov		eax, curVal
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	je		PASS																	; Number is composite JE To: line-329
	inc		ebx
	jmp		CHECK_1_LOOP															; Loop again JMP To: line-312

PASS:

; Passed composite test (return true)
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
; Pre-conditions:	  composite loop complete
; Post-conditions:	  quitVal == 1 to quit or any other value to continue
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

; Reset variables for possible next running
	mov		numPrinted, 0
	mov		curVal, 4

	ret

quit ENDP


;------------------------------------------------------------------------------
; finish
;
; Description:        Prints the Goodbye message
; Pre-conditions:	  quitVal == 1
; Post-conditions:	  none
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
