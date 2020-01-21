TITLE Program 2                 Program2_wrighada.asm

; Author:						Adam Wright
; Last Modified:				1-19-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271-400
; Project Number:               1  
; Due Date:						1-26-2020
; Description:					Assembly program which 

INCLUDE Irvine32.inc


; Variable definitions

.data
intro		BYTE	"Adam Wright  --  Program-2 -- Fibonacci numbers", 0
extCred1	BYTE	"**EC-1: Display the numbers in alligned columns", 0
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
numA		SDWORD	?																					; Integer A to be entered by user
numB		SDWORD	?																					; Integer B to be entered by user
numC		SDWORD	?																					; Integer C to be entered by user
resAPlusB	SDWORD	?																					; Result of A Plus B
resAMinB	SDWORD	?																					; Result of A Minus B
resAPlusC	SDWORD	?																					; Result of A Plus C
resAMinC	SDWORD	?																					; Result of A Minus B
resBPlusC	SDWORD	?																					; Result of B Plus C
resBMinC	SDWORD	?																					; Result of B Minus C
resABC		SDWORD	?																					; Result of A Plus B Plus C
resBMinA	SDWORD	?																					; Result of B Minus A
resCMinA	SDWORD	?																					; Result of C Minus A
resCMinB	SDWORD	?																					; Result of C Minus B
resCBA		SDWORD	?																					; Result of C Minus B Minus A


; Executable instructions

.code  
main PROC

; Introduce programmer, title, and extra credit options
	call	CrLf
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET extCred1
	call	WriteString
	call	CrLf
	call	CrLf

; Print the instructions
	mov		edx, OFFSET instrctMsg
	call	WriteString
	call	CrLf


START_LOOP:														; User can press 2 and continue with JMP From: line-310

; Prompt for first number										; Prompt for 3 numbers
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

; Check for descending order									; Success JMP To: line-120 or Fail JMP To: line-111
	mov		eax, numA
	cmp		eax, numB
	jbe		INPUT_ERROR
	mov		eax, numB
	cmp		eax, numC
	jbe		INPUT_ERROR
	jmp		MATH


INPUT_ERROR:													; JMP From: line-104 or 107 if the input numbers aren't in descending order

; Non-descending input numbers Error Message
	mov		edx, OFFSET	errPrompt
	call	WriteString
	call	CrLf
	Jmp		START_LOOP											; After error message JMP To: line-79 to request numbers again


MATH:															; JMP From: line-108 - Input tests pass  ---  Start Math section

; Add numA numB and store result in resAPlusB and Display		; A + B
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numA
	mov		resAPlusB, eax
	mov		eax, resAPlusB
	call	WriteInt
	call	CrLf

; Sub numA numB and store result in resAMinB and Display		; A - B
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
	mov		resAMinB, eax
	mov		eax, resAMinB
	call	WriteInt
	call	CrLf

; Add numA numC and store result in resAPlusC and Display		; A + C
	mov		eax, numA
	call	WriteInt
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numA
	mov		resAPlusC, eax
	mov		eax, resAPlusC
	call	WriteInt
	call	CrLf

; Sub numA numC and store result in resAMinC and Display		; A - C
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
	mov		resAMinC, eax
	mov		eax, resAMinC
	call	WriteInt
	call	CrLf

; Add numB numC and store result in resBPlusC and Display		; B + C
	mov		eax, numB
	call	WriteInt
	mov		edx, OFFSET addSym
	call	WriteString
	mov		eax, numC
	call	WriteInt
	mov		edx, OFFSET eqlSym
	call	WriteString
	add		eax, numB
	mov		resBPlusC, eax
	mov		eax, resBPlusC
	call	WriteInt
	call	CrLf

; Sub numB numC and store result in resBMinC and Display		; B - C
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
	mov		resBMinC, eax
	mov		eax, resBMinC
	call	WriteInt
	call	CrLf

; Add numC resAPlusB store result in resABC and Display			; A + B + C
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
	add		eax, resAPlusB
	mov		resABC, eax
	mov		eax, resABC
	call	WriteInt
	call	CrLf

; Sub numB numA and store result in resBMinA and Display		; B - A
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
	mov		resBMinA, eax
	mov		eax, resBMinA
	call	WriteInt
	call	CrLf

; Sub numC numA and store result in resCMinA and Display		; C - A
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
	mov		resCMinA, eax
	mov		eax, resCMinA
	call	WriteInt
	call	CrLf

; Sub numC numB and store result in resCMinB and Display		; C - B
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
	mov		resCMinB, eax
	mov		eax, resCMinB
	call	WriteInt
	call	CrLf

; Sub numC resBMinA and store result in resCBA and Display		; C - B - A
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
	mov		eax, resCMinB
	sub		eax, numA
	mov		resCBA, eax
	mov		eax, resCBA
	call	WriteInt
	call	CrLf

; Prompt the user to press 1 to quit or 2 to restart			; Quit JMP To: line-313 or Restart JMP To: line-79
	call	CrLf
	mov		edx, OFFSET	quitPrompt
	call	WriteString
	call	CrLf
	call	ReadInt
	cmp		eax, 1
	je		CONTINUE
	jmp		START_LOOP
	

CONTINUE:														; JMP From: line-309 to finish

; Say "Good-bye"												; Print the final message when 1 entered
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf
	exit														; Exit to operating system

main ENDP

END main
