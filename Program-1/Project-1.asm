TITLE Program 1  -- Sums and Differences

; Author:						Adam Wright
; Last Modified:				1-14-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271--400
; Project Number:               1  
; Due Date:						1-19-2020
; Description:					Assembly program which prompts the user for
;								three integers in descending order and then
;								calculates the sum and difference of the sets
;								(A+B, A-B, A+C, A-C, B+C, B-C, A+B+C) and 
;								displays it to the user

INCLUDE Irvine32.inc


; Variable definitions

.data
intro		BYTE	"Adam Wright  --  Program-1 -- Sums and differences", 0
extCred1	BYTE	"**EC-1: Program repeats until the user chooses to quit", 0
extCred2	BYTE	"**EC-2: Program verifies the numbers are in descending order", 0
extCred3	BYTE	"**EC-3: Handles negative results and computes B-A, C-A, C-B, C-B-A", 0
instrctMsg	BYTE	"Enter 3 numbers A > B > C, and I'll show you the sums and differences!", 0
firPrompt	BYTE	"First number: ", 0
secPrompt	BYTE	"Second number: ", 0
thrdPrompt	BYTE	"Third number: ", 0
errPrompt	BYTE	"Error: The numbers must be in descending order", 0
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
addSym		BYTE	" + ", 0
subSym		BYTE	" - ", 0
eqlSym		BYTE	" = ", 0
goodBye		BYTE	"Good-bye !!!", 0
numA		SDWORD	?								; Integer A to be entered by user
numB		SDWORD	?								; Integer B to be entered by user
numC		SDWORD	?								; Integer C to be entered by user


; Executable instructions

.code  
main PROC

; Introduce programmer, title, and extra credit options
	call	CrLf
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extCred1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extCred2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extCred3
	call	WriteString
	call	CrLf
	call	CrLf

; Print the instructions
	mov		edx, OFFSET instrctMsg
	call	WriteString
	call	CrLf


START_LOOP:											; User can press 2 and continue with JMP From: line-271

; Prompt for first number							; Prompt for 3 numbers
	call	CrLf
	mov		edx, OFFSET firPrompt
	call	WriteString
	call	ReadInt
	mov		numA, eax

; Prompt for second number
	mov		edx, OFFSET secPrompt
	call	WriteString
	call	ReadInt
	mov		numB, eax

; Prompt for third number
	mov		edx, OFFSET thrdPrompt
	call	WriteString
	call	ReadInt
	mov		numC, eax
	call	CrLf

; Check for descending order						; Test for descending numbers
	mov		eax, numA
	cmp		eax, numB
	jbe		INPUT_ERROR
	mov		eax, numB
	cmp		eax, numC
	jbe		INPUT_ERROR
	jmp		MATH


INPUT_ERROR:										; JMP From: line-87 or 90

; Error Message										; Input numbers error message
	mov		edx, OFFSET	errPrompt
	call	WriteString
	call	CrLf
	Jmp		START_LOOP


MATH:												; JMP From: line-91 - Input tests pass  ---  Start Math section

; Add and print for A and B							; Calc and print A + B
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numA
	call	WriteInt
	call	CrLf

; Subtract and print for A and B					; Calc and print A - B
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numA
	sub		eax, numB
	call	WriteInt
	call	CrLf

; Add and print for A and C							; Calc and print A + C
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numA
	call	WriteInt
	call	CrLf

; Subtract and print for A and C					; Calc and print A - C
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numA
	sub		eax, numC
	call	WriteInt
	call	CrLf

; Add and print for B and C							; Calc and print B + C
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numB
	call	WriteInt
	call	CrLf

; Subtract and print for B and C					; Calc and print B - C
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numB
	sub		eax, numC
	call	WriteInt
	call	CrLf

; Add and print for A and B and C					; Calc and print A + B + C
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numA
	add		eax, numB
	call	WriteInt
	call	CrLf

; Subtract and print for B and A					; Calc and print B - A
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numB
	sub		eax, numA
	call	WriteInt
	call	CrLf

; Subtract and print for C and A					; Calc and print C - A
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numC
	sub		eax, numA
	call	WriteInt
	call	CrLf

; Subtract and print for C and B					; Calc and print C - B
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numC
	sub		eax, numB
	call	WriteInt
	call	CrLf

; Subtract and print for C and B and A				; Calc and print C - B - A
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numC
	sub		eax, numB
	sub		eax, numA
	call	WriteInt
	call	CrLf

; Prompt for quit									; Ask the user to quit
	call	CrLf
	mov		edx, OFFSET	quitPrompt
	call	WriteString
	call	CrLf
	call	ReadInt
	cmp		eax, 1
	je		CONTINUE
	jmp		START_LOOP
	

CONTINUE:											; JMP From: line-270

; Say "Good-bye"									; Print the final message when 1 entered
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit											; exit to operating system

main ENDP

END main
