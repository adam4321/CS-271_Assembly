TITLE Program 1  -- Sums and Differences

; Author:						Adam Wright
; Last Modified:				1-11-2020
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

; (insert constant definitions here)

; Variable definitions
.data
intro		BYTE	"Adam Wright  --  Program-1 -- Sums and differences", 0
instrctMsg	BYTE	"Enter 3 numbers A > B > C, and I'll show you the sums and differences!", 0
firPrompt	BYTE	"First number: ", 0
secPrompt	BYTE	"Second number: ", 0
thrdPrompt	BYTE	"Third number: ", 0
numA		DWORD	?								; Integer A to be entered by user
numB		DWORD	?								; Integer B to be entered by user
numC		DWORD	?								; Integer C to be entered by user
addSym		BYTE	" + ", 0
subSym		BYTE	" - ", 0
eqlSym		BYTE	" = ", 0
goodBye		BYTE	"Good-bye !!!", 0

; Executable instructions
.code  
main PROC

; Introduce programmer and title
	call	CrLf
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf

; Print the instructions
	mov		edx, OFFSET instrctMsg
	call	WriteString
	call	CrLf
	call	CrLf

; Prompt for first number
	mov		edx, OFFSET firPrompt
	call	WriteString
	call	ReadInt
	mov		numA, eax

; Prompt for second number
	mov		edx, OFFSET secPrompt
	call	WriteString
	call	ReadInt
	mov		numB, eax

; Prompt for thrid number
	mov		edx, OFFSET thrdPrompt
	call	WriteString
	call	ReadInt
	mov		numC, eax
	call	CrLf

; Add and print for A and B
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

; Add and print for A and C
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

; Add and print for B and C
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

; Add and print for A and B and C
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

; Say "Good-bye"
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit								; exit to operating system
main ENDP

END main
