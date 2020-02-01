TITLE Program 3                 Program3_wrighada.asm

; Author:						Adam Wright
; Last Modified:				2-1-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271-400
; Project Number:               3  
; Due Date:						2-9-2020
; Description:					Assembly program which prompts the user to enter
;								numbers repeatedly within the ranges of 
;								[-88, -55] or [-40, -1], and then terminates on
;								a positive number and then displays the average
;								rounded to the nearest integer.


INCLUDE Irvine32.inc


; Constant definitions

LIMIT_NEG_88 = -88																	; Constant holding the lowest possbie value for input
LIMIT_NEG_55 = -55																	; Constant holding the highest possible value for lower range
LIMIT_NEG_40 = -40																	; Constant holding the lowest possible value for higher range
LIMIT_NEG_1 = -1																	; Constant holding the highest possible value for input


; Variable definitions

.data
intro		BYTE	"Program-3 -- Average of negative numbers", 0
programmer	BYTE	"Programmed by Adam Wright", 0
extCred1	BYTE	"**EC-1: Number the lines during user input.", 0
userPrompt	BYTE	"What's your name? ", 0
userGreet	BYTE	"Hello, ", 0
instr1		BYTE	"Please enter numbers in [-88, -55] or [-40, -1].", 0
instr2		BYTE	"Enter a non-negative number ", 0
instr3		BYTE	"when you are finished to see results.", 0
numPrompt	BYTE	" - Enter a number: ", 0
errPrompt	BYTE	"Number Invalid!", 0
noPrompt	BYTE	"No numbers entered!", 0
validPmt1	BYTE	"You entered ", 0
validPmt2	BYTE	" valid numbers.", 0
maxPrompt	BYTE	"The maximum valid number is ", 0
minPrompt	BYTE	"The minimum valid number is ", 0
sumPrompt	BYTE	"The sum of your valid numbers is ", 0
avgPrompt	BYTE	"The rounded average is ", 0
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
bangSym		BYTE	"!", 0
space		BYTE	" ", 0
byePrompt1	BYTE	"Results certified by Adam Wright.", 0
byePrompt2	BYTE	"Good-bye, ", 0
userName	BYTE	33 DUP(0)														; String variable holding user name 33 bytes initialized to 0
numInput	SDWORD	?																; Signed integer holding the current input number
validCount	DWORD	0																; Integer holding the number of valid inputs
numLowest	SDWORD	-1																; Signed integer holding the lowest number entered - initialized to most opposite value
numHighest	SDWORD	-88																; Signed integer holding the highest number entered - initialized to most opposite value
numSum		SDWORD	0																; Signed integer holding the sum of the entered numbers
numAvg		SDWORD	0																; Signed integer holding the average of the entered numbers


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
	call	CrLf
	mov		edx, OFFSET instr2
	call	WriteString
	mov		edx, OFFSET instr3
	call	WriteString
	call	CrLf


MAIN_LOOP:														; User can press 2 and continue with JMP From: line-294

; Prompt for a number from user
	call	CrLf
	mov		eax, validCount
	call	WriteDec
	mov		edx, OFFSET numPrompt
	call	WriteString
	call	ReadInt
	mov		numInput, eax
	jns		NO_PRINT											; Non-negative integer JMP To: line-224

; Error test for int between [-88, -55] or [-40, -1]			; Success JMP To: line-161 or Fail JMP To: line-151
	mov		eax, numInput
	cmp		eax, LIMIT_NEG_88
	jl		INPUT_ERROR
	cmp		eax, LIMIT_NEG_1
	jg		INPUT_ERROR
	cmp		eax, LIMIT_NEG_40
	jl		LOWER_RANGE_TEST
	cmp		eax, LIMIT_NEG_55
	jg		HIGHER_RANGE_TEST
	jmp		MATH


LOWER_RANGE_TEST:

; Second test to invalidate (-56 -> -41)
	mov		eax, numInput
	cmp		eax, LIMIT_NEG_55
	jg		INPUT_ERROR
	jmp		MATH


HIGHER_RANGE_TEST:

; Second test to invalidate (-56 -> -41)
	mov		eax, numInput
	cmp		eax, LIMIT_NEG_40
	jl		INPUT_ERROR
	jmp		MATH


INPUT_ERROR:													; Input numbers not in range JMP From: line-123,125,138,147 

; Error Message for num outside [-88, -55] or [-40, -1]
	call	CrLf
	mov		edx, OFFSET	errPrompt
	call	WriteString
	call	CrLf
	Jmp		MAIN_LOOP											; After error message JMP To: line-108 to request numbers again


MATH:															; JMP From: line-130,139,148 - Input tests pass  ---  Start Math section

; Increment valid count and create sum
	inc		validCount
	mov		eax, numInput
	add		eax, numSum
	mov		numSum, eax

; Process lowest number
	mov		eax, numInput
	cmp		eax, numLowest
	jl		MIN_NUM												; New min detected JMP To: line-203


MATH_HI_CHK:

; Process highest number
	cmp		eax, numHighest
	jg		MAX_NUM												; New max detected JMP To: line-210


CONTINUE_MATH:

; Process the average of the numbers
	mov		eax, numSum
	cdq
	mov		ebx, validCount
	idiv	ebx
	mov		numAvg, eax

; Quotient / 2 and compared to remainder
	shr		ebx, 1
	neg		edx
	cmp		edx, ebx
 	jg		ROUND_UP											; Remainder > .5 JMP To: line-217


RETURN_ROUND:
; Current rounded avg created
	jmp		MAIN_LOOP											; Request the next number JMP To: line-108


MIN_NUM:

; Swap current number to lowest entered value
	mov		numLowest, eax
	jmp		MATH_HI_CHK											; Return to processing JMP To: line-175


MAX_NUM:

; Swap current number to highest entered value
	mov		numHighest, eax
	jmp		CONTINUE_MATH										; Return to processing JMP To: line-182


ROUND_UP:

; Round up > 0.5 remainder
	dec		numAvg
	jmp		RETURN_ROUND


NO_PRINT:														; Test for any valid entries JMP From: line-118

; If end before any entries
	mov		eax, validCount 
	cmp		eax, 0
	jg		PRINT												; Valid entries JMP To: line-232
	call	CrLf
	mov		edx, OFFSET noPrompt
	call	WriteString
	call	CrLf
	jmp		QUIT												; No valid input JMP To: line-273


PRINT: 

; Print the number of valid numbers
	call	CrLf
	mov		edx, OFFSET validPmt1
	call	WriteString
	mov		eax, validCount
	call	WriteDec
	mov		edx, OFFSET validPmt2
	call	WriteString

; Print the lowest number
	call	CrLf
	mov		edx, OFFSET minPrompt
	call	WriteString
	mov		eax, numLowest
	call	WriteInt

; Print the highest number
	call	CrLf
	mov		edx, OFFSET maxPrompt
	call	WriteString
	mov		eax, numHighest
	call	WriteInt

; Print the sum valid numbers
	call	CrLf
	mov		edx, OFFSET sumPrompt
	call	WriteString
	mov		eax, numSum
	call	WriteInt

; Print the average of numbers
	call	CrLf
	mov		edx, OFFSET avgPrompt
	call	WriteString
	mov		eax, numAvg
	call	WriteInt
	call	CrLf


QUIT:

; Prompt the user to press 1 to quit or 2 to restart			; Quit JMP To: line-292 or Restart JMP To: line-108
	call	CrLf
	mov		edx, OFFSET	quitPrompt
	call	WriteString
	call	ReadInt
	cmp		eax, 1
	je		FINISH

; If restarting then variables are reset
	mov		validCount, 0
	mov		numSum, 0
	mov		numAvg, 0
	mov		numLowest, LIMIT_NEG_1
	mov		numHighest, LIMIT_NEG_88
	jmp		MAIN_LOOP
	

FINISH:															; JMP From: line-282 to finish

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
