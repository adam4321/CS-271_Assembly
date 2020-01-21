TITLE Program 2                 Program2_wrighada.asm

; Author:						Adam Wright
; Last Modified:				1-21-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271-400
; Project Number:               2  
; Due Date:						1-26-2020
; Description:					Assembly program which 

INCLUDE Irvine32.inc


; Variable definitions

.data
intro		BYTE	"Program-2 -- Fibonacci sequence", 0
programmer	BYTE	"Programmed by Adam Wright.", 0
extCred1	BYTE	"**EC-1: Display the numbers in alligned columns.", 0
userPrompt	BYTE	"What's your name? ", 0
userGreet	BYTE	"Hello, ", 0
instr1		BYTE	"Enter the number of Fibonacci terms to be displayed.", 0
instr2		BYTE	"Give the number as an integer in the range [1 .. 46]. ", 0
fibPrompt	BYTE	"How many Fibonacci terms do you want? ", 0
errPrompt	BYTE	"Out of range.  Enter a number in [1 .. 46]", 0
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
space		BYTE	"            ", 0
periodSym	BYTE	".", 0
byePrompt1	BYTE	"Results certified by Adam Wright.", 0
byePrompt2	BYTE	"Good-bye, ", 0
userName	BYTE	33 DUP(0)															; String variable holding user name
fibCount	SDWORD	?																	; Integer which holds user entered Fibonacci terms count
fibPrev		SDWORD	0																	; Integer which holds Fibonacci of n-1
fibOut		SDWORD	1																	; Integer which holds the current output value n


; Executable instructions

.code  
main PROC

; Introduce programmer, title, and extra credit options
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

; Prompt for the user's name
	mov		edx, OFFSET userPrompt
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

; Greet the user
	mov		edx, OFFSET userGreet
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET	periodSym
	call	WriteString
	call	CrLf
	call	CrLf

; Print the instructions
	mov		edx, OFFSET instr1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instr2
	call	WriteString
	call	CrLf


START_FIB:														; User can press 2 and continue with JMP From: line-

; Prompt for number of Fibonacci terms							; Prompt for Fibonacci terms count
	call	CrLf
	mov		edx, OFFSET fibPrompt
	call	WriteString
	call	ReadInt
	mov		fibCount, eax

; Error test for int between 1-46								; Success JMP To: line-107 or Fail JMP To: line-98
	mov		eax, fibCount
	cmp		eax, 1
	jl		INPUT_ERROR
	cmp		eax, 46
	jg		INPUT_ERROR
	jmp		MATH


INPUT_ERROR:													; JMP From: line-93 or 95 if the input numbers aren't in descending order

; Non-descending input numbers Error Message
	mov		edx, OFFSET	errPrompt
	call	WriteString
	call	CrLf
	Jmp		START_FIB											; After error message JMP To: line-81 to request numbers again


MATH:															; JMP From: line-108 - Input tests pass  ---  Start Math section

; Print base case of fibCount = 1								; Fibonacci sequence from 1 - fibCount
	call	CrLf
	mov		fibPrev, 0
	mov		fibOut, 1
	mov		eax, fibOut
	mov		ecx, fibCount
	call	WriteDec


FIB_LOOP:

; Print space between terms
	xor		edx, edx	
	mov		edx, OFFSET space
	call	WriteString


; Loop for values above fibCopunt = 1
	mov		eax, fibPrev
	mov		ebx, fibOut
	mov		fibPrev, ebx
	add		eax, ebx
	mov		fibOut, eax
	call	WriteDec
	cmp		ecx, fibCount
	Loop	FIB_LOOP
	call	CrLf


; Prompt the user to press 1 to quit or 2 to restart			; Quit JMP To: line- or Restart JMP To: line-79
	call	CrLf
	mov		edx, OFFSET	quitPrompt
	call	WriteString
	call	CrLf
	call	ReadInt
	cmp		eax, 1
	je		CONTINUE
	jmp		START_FIB
	

CONTINUE:														; JMP From: line- to finish

; Say "Good-bye"												; Print the final message when 1 entered
	call	CrLf
	mov		edx, OFFSET byePrompt1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET byePrompt2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET	periodSym
	call	WriteString
	call	CrLf
	exit														; Exit to operating system

main ENDP

END main
