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
extCred1	BYTE	"**EC: Program repeats until the user chooses to quit", 0
extCred2	BYTE	"**EC: Program verifies the numbers are in descending order", 0
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
numA		DWORD	?								; Integer A to be entered by user
numB		DWORD	?								; Integer B to be entered by user
numC		DWORD	?								; Integer C to be entered by user

; Executable instructions
.code  
main PROC

; Introduce programmer and title
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
	call	CrLf

; Print the instructions
	mov		edx, OFFSET instrctMsg
	call	WriteString
	call	CrLf

START_LOOP:											; Start of program loop

; Prompt for first number							; Numbers prompts
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

INPUT_ERROR:										; Input numbers error message

; Error Message
	mov		edx, OFFSET	errPrompt
	call	WriteString
	call	CrLf
	Jmp		START_LOOP

MATH:												; Input tests pass  ---  Start Math section

; Add and print for A and B							; Calc and print A and B
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numA
	call	WriteDec
	call	CrLf

; Subtract and print for A and B
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numA
	sub		eax, numB
	call	WriteDec
	call	CrLf

; Add and print for A and C							; Calc and print A and C
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numA
	call	WriteDec
	call	CrLf

; Subtract and print for A and C
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numA
	sub		eax, numC
	call	WriteDec
	call	CrLf

; Add and print for B and C							; Calc and print B and C
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numB
	call	WriteDec
	call	CrLf

; Subtract and print for B and C
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET subSym
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET eqlSym
	call	WriteString
	mov		eax, numB
	sub		eax, numC
	call	WriteDec
	call	CrLf

; Add and print for A and B and C					; Calc and print A B C
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numA
	add		eax, numB
	call	WriteDec
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
	

CONTINUE:											; Print the final message when 1 entered

; Say "Good-bye"
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit											; exit to operating system

main ENDP

END main
