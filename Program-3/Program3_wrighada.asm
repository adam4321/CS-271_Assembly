TITLE Program 3                 Program3_wrighada.asm

; Author:						Adam Wright
; Last Modified:				1-27-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271-400
; Project Number:               3  
; Due Date:						2-9-2020
; Description:					Assembly program which 

INCLUDE Irvine32.inc


; Constant definitions

LOWER_LIMIT = 1																			; Constant holding the lowest possbie value for fibCount
UPPER_LIMIT = 46																		; Constant holding the highest possible value for fibCount
SPACING = 9																				; Constant holding the ascii key code for a tab

; Variable definitions

.data
intro		BYTE	"Program-3 -- Fibonacci Sequence", 0
programmer	BYTE	"Programmed by Adam Wright", 0
extCred1	BYTE	"**EC-1: Display the numbers in alligned columns.", 0
extCred2	BYTE	"**EC-2: Program repeats until the user quits.", 0
userPrompt	BYTE	"What's your name? ", 0
userGreet	BYTE	"Hello, ", 0
instr1		BYTE	"This program displays the Fibonacci sequence. ", 0
instr2		BYTE	"Enter the number of terms to be displayed.", 0
instr3		BYTE	"Give the number as an integer in the range [1 .. 46]. ", 0
fibPrompt	BYTE	"How many Fibonacci terms do you want? ", 0
errPrompt	BYTE	"Out of range.  Enter a number in [1 .. 46]", 0
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
bangSym		BYTE	"!", 0
byePrompt1	BYTE	"Results certified by Adam Wright.", 0
byePrompt2	BYTE	"Good-bye, ", 0
userName	BYTE	33 DUP(0)															; String variable holding user name 33 bytes initialized to 0
fibCount	DWORD	?																	; Integer which holds user entered Fibonacci terms count
fibPrev		DWORD	0																	; Integer which holds Fibonacci of n-1
fibOut		DWORD	1																	; Integer which holds the current output value n
colCount	DWORD	0																	; Integer holding the current column to print
rowCount	DWORD	0																	; Integer holding the current printing row


; Executable instructions

.code  
main PROC

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
	mov		edx, OFFSET	extCred2
	call	WriteString
	call	CrLf
	call	CrLf

; Prompt for the user's name
	mov		edx, OFFSET userPrompt
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString

; Greet the user using userName
	mov		edx, OFFSET userGreet
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET	bangSym
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


START_FIB:														; User can press 2 and continue with JMP From: line-195

; Prompt for number of Fibonacci terms
	call	CrLf
	mov		edx, OFFSET fibPrompt
	call	WriteString
	call	ReadInt
	mov		fibCount, eax

; Error test for int between 1-46								; Success JMP To: line-126 or Fail JMP To: line-117
	mov		eax, fibCount
	cmp		eax, LOWER_LIMIT
	jl		INPUT_ERROR
	cmp		eax, UPPER_LIMIT
	jg		INPUT_ERROR
	jmp		MATH


INPUT_ERROR:													; Input numbers not in range JMP From: line-111 or 113

; Error Message for num outside 1-46
	mov		edx, OFFSET	errPrompt
	call	WriteString
	call	CrLf
	Jmp		START_FIB											; After error message JMP To: line-99 to request numbers again


MATH:															; JMP From: line-114 - Input tests pass  ---  Start Math section

; Print base case of fibCount = 1
	call	CrLf
	mov		fibPrev, 0
	mov		fibOut, 1
	mov		eax, fibOut
	mov		ecx, fibCount
	mov		[colCount], 0
	mov		[rowCount], 0
	dec		ecx
	call	WriteDec
	cmp		fibCount, 1
	je		QUIT												; Base case of fibCount = 1 to quit prompt JMP To: line-185


FIB_LOOP:														; JMP From: line-172 to loop through Fib sequence

; Use spacing constant to format Fib output						; Print spacing between terms
	mov		al, SPACING
	call	WriteChar
	call	WriteChar
	cmp		rowCount, 7											; Only print 2 tabs for rowCount 7+ (format columns)
	jge		COL_FORMAT
	call	WriteChar											; Print 3 tabs for rowCount 0-6 (format columns)


COL_FORMAT:														; JMP From: line-149 for 2 tab rows 7 and above (formatting columns)

; Loop for values above fibCount = 1
	mov		eax, fibPrev
	mov		ebx, fibOut
	mov		fibPrev, ebx
	add		eax, ebx
	mov		fibOut, eax
	inc		[colCount]
	cmp		colCount, 5
	je		NEW_LINE


PRINT:															; JMP From: line-182 after newline added

; Print Fib term and loop until fibCount reached
	mov		eax, fibOut
	call	WriteDec
	cmp		ecx, fibCount
	Loop	FIB_LOOP
	jmp		QUIT


NEW_LINE:														; JMP From: line-163 for newline

; Newline and incement rowcount and rezero colCount
	call	CrLf
	inc		[rowCount]
	mov		colCount, 0
	jmp		PRINT												; JMP To: line-166 to continue printing


QUIT:

; Prompt the user to press 1 to quit or 2 to restart			; Quit JMP To: line-198 or Restart JMP To: line-99
	call	CrLf
	call	CrLf
	mov		edx, OFFSET	quitPrompt
	call	WriteString
	call	ReadInt
	cmp		eax, 1
	je		FINISH
	jmp		START_FIB
	

FINISH:															; JMP From: line-194 to finish

; Say "Good-bye"												; Print the final message when 1 entered
	call	CrLf
	mov		edx, OFFSET byePrompt1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET byePrompt2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET	bangSym
	call	WriteString
	call	CrLf
	exit														; Exit to operating system

main ENDP

END main
