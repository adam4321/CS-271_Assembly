TITLE Program 6                 Program6_wrighada.asm

; Author:						Adam Wright
; Last Modified:				3-13-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271-400
; Project Number:               6  
; Due Date:						3-15-2020
; Description:					Assembly program which requests 10 32 bit signed 
;								integers from the user and then prints the list,
;								the sum, and then the average of those numbers


INCLUDE Irvine32.inc

;  -------------------------------------------------------------------------------  ; CONSTANT DEFINITIONS

ARRAY_SIZE = 10 																	; Constant holding the number of values to gather
STR_SIZE = 31																		; Constant holding the input size

PARAM_1 EQU [ebp + 8]																; Explicit stack offset for parameter 1
PARAM_2 EQU [ebp + 12]																; Explicit stack offset for parameter 2
PARAM_3 EQU [ebp + 16]																; Explicit stack offset for parameter 3
PARAM_4 EQU [ebp + 20]																; Explicit stack offset for parameter 4
PARAM_5 EQU [ebp + 24]																; Explicit stack offset for parameter 5
PARAM_6 EQU [ebp + 28]																; Explicit stack offset for parameter 6
PARAM_7 EQU [ebp + 32]																; Explicit stack offset for parameter 7
PARAM_8 EQU [ebp + 36]																; Explicit stack offset for parameter 8


;  -------------------------------------------------------------------------------	; MACRO DEFINITIONS

;------------------------------------------------------------------------------
; displayString
;
; Description:        MACRO that prints a string while storing and restoring edx
; Pre-conditions:	  Parameter passed is the address of an array
; Post-conditions:	  String printed to the console
; Parameters:		  ptr_buffer
; Registers changed:  None
;------------------------------------------------------------------------------

displayString MACRO ptr_buffer
	push	edx
	mov		edx, ptr_buffer
	call	WriteString
	pop		edx
ENDM


;------------------------------------------------------------------------------
; getString
;
; Description:        MACRO that prompts the user for a string while 
;					  storing and restoring ecx and edx
; Pre-conditions:	  Parameter passed is a variable to hold the  
;					  address of a string
; Post-conditions:	  String stored in the chosen variable 
; Parameters:		  ptr_prompt, ptr_varName, VAR_SIZE
; Registers changed:  None
;------------------------------------------------------------------------------

getString MACRO ptr_prompt, ptr_varName, VAR_SIZE
    push    ecx
    push    edx
	displayString ptr_prompt
    mov     edx, ptr_varName
	mov		ecx, VAR_SIZE
	call	ReadString
	pop		edx
	pop		ecx
ENDM


;  -------------------------------------------------------------------------------  ; VARIABLE DEFINITIONS

.data																				
intro		BYTE	"** Program-6 -- Designing low-level I/O procedures **", 0
programmer	BYTE	"** Programmed by Adam Wright **", 0
instruct	BYTE	"Please provide 10 signed decimal integers.", 0dh, 0ah
			BYTE	"Each number needs to be small enough "
			BYTE	"to fit inside a 32 bit register.", 0dh, 0ah
			BYTE	"After you have finished inputting the raw numbers "
			BYTE	"I will display a list", 0dh, 0ah
			BYTE	"of the integers, their sum, "
			BYTE	"and their average value.", 0dh, 0ah, 0
userPrompt	BYTE	"Please enter a signed number: ", 0
errMsg		BYTE	"ERROR: You did not enter a signed number or "
			BYTE	"your number was too big.", 0dh, 0ah, 0
errPrompt	BYTE	"Please try again: ", 0
listMsg		BYTE	"You entered the following numbers: ", 0
sumMsg		BYTE	"The sum of these numbers is: ", 0
avgMsg		BYTE	"The rounded average is: ", 0
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
byePrompt	BYTE	"Good-bye, and thanks for using my program!", 0
quitVal		DWORD	1																; Integer holding 1 to quit or any other value to continue
numArray	SDWORD	ARRAY_SIZE DUP(?)												; Empty array for holding the entered and verified numbers
strTemp		BYTE	STR_SIZE DUP(?), 0												; Empty string for receiving user input
testedNum	SDWORD	0																; Variable for receiving a validated number
numSum		SDWORD	0																; Variable for receiving the sum of the entered numbers
numAvg		SDWORD	0																; Variable for receiving the average of the entered numbers


;  -------------------------------------------------------------------------------  ; EXECUTABLE INSTRUCTIONS

.code
main PROC

; Introduce title, programmer, and instructions
	push	OFFSET instruct
	push	OFFSET programmer
	push	OFFSET intro
	call	introduction

MAIN_LOOP:																			; Restart (quitVal == 1) JMP From: line-154

; Request 10 numbers from the user
	push	OFFSET testedNum
	push	OFFSET errPrompt
	push	OFFSET errMsg
	push	OFFSET userPrompt
	push	ARRAY_SIZE
	push	OFFSET numArray
	push	STR_SIZE
	push	OFFSET strTemp
	call	getValues

; Calculate sum and average
	push	OFFSET numAvg
	push	OFFSET numSum
	push	ARRAY_SIZE
	push	OFFSET numArray
	call	calculations

; Display the results
	push	STR_SIZE
    push    ARRAY_SIZE
	push	OFFSET strTemp
    push    OFFSET numAvg
	push	OFFSET avgMsg
    push    OFFSET numSum
	push	OFFSET sumMsg
    push    OFFSET numArray
	push	OFFSET listMsg
	call	printRslt

; Ask if the user wants to quit
	push	OFFSET quitPrompt
	call	quit																	; Returns quitVal bool in eax
	mov		quitVal, eax

; Check the value set in the quit procedure
	cmp		quitVal, 1
	jne		MAIN_LOOP																; Enter 1 to reset JMP To: line-115

; Function that says "Good-bye"
	push	OFFSET byePrompt
	call	farewell

; Exit to operating system
	exit							

main ENDP


;  -------------------------------------------------------------------------------  ; PROCEDURE DEFINITIONS

;------------------------------------------------------------------------------
; introduction
;
; Description:       Prints the Introductory message using displayString macro
; Pre-conditions:	 4 string pointers pushed onto stack
; Post-conditions:	 Introduction printed
; Parameters:		 PARAM_1: OFFSET intro, PARAM_2: OFFSET programmer
;					 PARAM_3: OFFSET instruct
; Registers changed: None
;------------------------------------------------------------------------------

introduction PROC

; Print the title message
	push	ebp
	mov		ebp, esp
    pushad
	call	CrLf
	displayString PARAM_1

; Print the programmer message
	call	CrLf
	displayString PARAM_2

; Print the instructions and finish
	call	CrLf
	call	CrLf
	displayString PARAM_3
	call	CrLf
    popad
	pop		ebp
	ret		3 * TYPE PARAM_1

introduction ENDP


;------------------------------------------------------------------------------
; readVal
;
; Description:       Converts a string from stdin into a 32 bit signed integer
;                    and loops until a valid number is entered
; Pre-conditions:	 Necessary parameters pushed onto the stack in order
; Post-conditions:	 Valid 32bit signed integer stored in testedNum
; Parameters:		 PARAM_1: OFFSET strTemp, PARAM_2: STR_SIZE (value)
;					 PARAM_3: OFFSET userPrompt, PARAM_4: OFFSET errMsg
;					 PARAM_5: OFFSET errPrompt, PARAM_6: OFFSET testedNum
; Registers changed: None
;------------------------------------------------------------------------------

readVal PROC

; Set up registers
	push	ebp
	mov		ebp, esp
	pushad
	mov		esi, PARAM_1

; Call macro to get user number
	getString PARAM_3, PARAM_1, PARAM_2
	mov		edx, 0
	mov		ebx, 10
	mov		ecx, eax
	mov		esi, [PARAM_1]
	cld
	jmp		VALIDATE																; First attempt at prompt JMP To: line-246

ERROR_PROMPT:																		; After invalid entry JMP From: line-279, 281, 303, 305, 320, 322

; Print error and request a valid number
	call	CrLf
	displayString PARAM_4
	getString PARAM_5, PARAM_1, PARAM_2
	mov		edx, 0
	mov		ebx, 10
	mov		ecx, eax
	mov		esi, [PARAM_1]
	cld

VALIDATE:																			; Check the leading byte JMP From: line-232

; Pull the first byte and check for negative
	lodsb
	cmp		al, 45
	je		REMOVE_MINUS															; Leading Minus JMP To: line-256
	cmp		al, 43
	je		REMOVE_PLUS																; Leading Plus JMP To: line-262
	jmp		NO_SIGN																	; No leading sign JMP To: line-268
	
REMOVE_MINUS:																		; Negative number JMP From: line-251

; Pull off the minus sign
	dec		ecx
	jmp		NEGATIVE

REMOVE_PLUS:																		; Positive number with '+' JMP From: line-253

; Pull off the plus sign
	dec		ecx
	jmp		POSITIVE

NO_SIGN:																			; No sign JMP From: line-254

; Pull off nothing and reload first byte
	dec		esi
	jmp		POSITIVE																; Process positive value JMP To: line-298

NEGATIVE:																			; Process negative value LOOP From: line-290

; Validate possible negative value
	lodsb
	cmp		al, 48
	jl		ERROR_PROMPT															; Invalid char JMP To: line-234
	cmp		al, 57
	jg		ERROR_PROMPT															; Invalid char JMP To: line-234
	
; Process valid negative digit
	sub		al, 48
	movzx	edi, al
	mov		eax, edx
	mul		ebx
	jo		ERROR_PROMPT															; Prevent overflow of edx JMP To: line-234
	add		eax, edi
	jo		ERROR_PROMPT															; Prevent overflow of eax JMP To: line-234
	mov		edx, eax
	loop	NEGATIVE																; LOOP through negative string To: line-274

; Mul by -1 to turn number negative
	mov		ebx, -1
	mul		ebx
	mov		edx, eax
	jmp		NUMBER_RANGE															; Negative number converted, now must check range JMP To: line-320

POSITIVE:																			; Process positive value LOOP From: line-318

; Validate possible positive value
	lodsb
	cmp		al, 48
	jl		ERROR_PROMPT															; Invalid char JMP To: line-234
	cmp		al, 57
	jg		ERROR_PROMPT															; Invalid char JMP To: line-234

; Process valid positive digit
	sub		al, 48
	movsx	edi, al
	mov		eax, edx
	mul		ebx
	jo		ERROR_PROMPT															; Prevent overflow of edx JMP To: line-234
	add		eax, edi
	jo		ERROR_PROMPT															; Prevent overflow of eax JMP To: line-234
	mov		edx, eax
	loop	POSITIVE																; LOOP To: line-300

NUMBER_RANGE:																		; Check converted number's range JMP From: line-298

; Check that the number is between min and max int size
	cmp		edx, 2147483647
	jg		ERROR_PROMPT															; Number above signed 32bit size JMP To: line-234
	cmp		edx, -2147483648
	jl		ERROR_PROMPT															; Number below signed 32bit size JMP To: line-234	
	
; Store validated number in testedNum
	mov		eax, [PARAM_6]
	mov		[eax], edx

; Clean up and return
	call	CrLf
	popad
	pop		ebp
	ret		6 * TYPE DWORD

readVal ENDP


;------------------------------------------------------------------------------
; getValues
;
; Description:       Gets 10 valid numbers and stores them in an array
; Pre-conditions:	 Necessary parameters pushed onto the stack in order
; Post-conditions:	 10 valid 32bit signed integers stored in numArray
; Parameters:		 PARAM_1: OFFSET strTemp, PARAM_2: STR_SIZE (value)
;					 PARAM_3: OFFSET numArray, PARAM_4: ARRAY_SIZE
;					 PARAM_5: OFFSET userPrompt, PARAM_6: OFFSET errMsg
;					 PARAM_7: OFFSET errPrompt, PARAM_8: OFFSET testedNum
; Registers changed: None
;------------------------------------------------------------------------------

getValues PROC

; Set up registers
	push	ebp
	mov		ebp, esp
	pushad
	mov		ecx, PARAM_4
	mov		edi, PARAM_3
	mov		esi, PARAM_1

FILL_LOOP:																			; For filling the array LOOP From: line-380

; Call proc to get string and return num in testedNum
	push	PARAM_8
	push	PARAM_7
	push	PARAM_6
	push	PARAM_5
	push	PARAM_2
	push	PARAM_1
	call	readVal

; Number passed validation so add it to the array
	mov		eax, [PARAM_8]
	mov		ebx, [eax]
	mov		[edi], ebx
	add		edi, 4
	loop	FILL_LOOP																; LOOP To: line-364

; Clean up and return
	popad
	pop		ebp
	ret		8 * TYPE DWORD

getValues ENDP


;------------------------------------------------------------------------------
; calculations
;
; Description:        Calculates the sum and average of numArray
; Pre-conditions:	  Necessary parameters pushed onto the stack in order
; Post-conditions:	  Sum stored in numSum and rounded average stored in numAvg
; Parameters:		  PARAM_1: OFFSET numArray, PARAM_2: ARRAY_SIZE (value)
;					  PARAM_3: OFFSET numSum, PARAM_4: OFFSET numAvg
; Registers changed:  None
;------------------------------------------------------------------------------

calculations PROC

; Set up registers
	push	ebp
	mov		ebp, esp
	pushad
	mov		edi, [PARAM_1]
	mov		ecx, PARAM_2
	mov		eax, 0

SUM_lOOP:																			; LOOP through array From: line-417

; Sum up the values in the array
	mov		ebx, [edi]
	add		eax, ebx
	add		edi, 4
	loop	SUM_LOOP																; LOOP To: line-411

; Store sum in numSum
	mov		ebx, [PARAM_3]
	mov		[ebx], eax

; Calculate the average
	mov		ebx, PARAM_2
	cdq
	idiv	ebx
	cmp		eax, 0
	jl		ROUND_NEGATIVE															; If negative JMP To: line-436

; Round >= 0.5 up to next integer
	cmp		edx, 5
	jl		AVERAGE_FINISHED														; If positive remainder < 0.5 JMP To: line-444
	inc		eax
	jmp		AVERAGE_FINISHED														; After rounding JMP To: line-444

ROUND_NEGATIVE:																		; JMP From: line-428

; Round <= 0.5 down to next lower integer
	neg		edx
	cmp		edx, 5
	jl		AVERAGE_FINISHED														; If negative remainder < 0.5 JMP To: line-444
	dec		eax

AVERAGE_FINISHED:																	; JMP From: line-432, 434, 441

; Store the average in numAvg
	mov		ebx, [PARAM_4]
	mov		[ebx], eax

; Clean up and return
	popad
	pop		ebp
	ret		4 * TYPE DWORD

calculations ENDP


;------------------------------------------------------------------------------
; writeVal
;
; Description:        Converts a 32bit signed integer to a string and prints
;					  it to the console using displayString
; Pre-conditions:	  Necessary parameters pushed onto the stack in order
; Post-conditions:	  Numbers converted to string and printed to console
; Parameters:		  PARAM_1: number (value), PARAM_2: OFFSET strTemp
; Registers changed:  None
;------------------------------------------------------------------------------

writeVal PROC

; Set up registers
	push	ebp
	mov		ebp, esp
	pushad
	mov		eax, [PARAM_1]
	mov		edi, [PARAM_2]
	mov		ebx, 10
	push	0

; Check for sign of number
	cmp		eax, 0
	jl		NEGATIVE_INT															; If int < 0, then JMP To: line-505

POSITIVE_INT:																		; Loop to create positive number byte JMP From: line-494

; Process a positive signed int digit
	cdq
	idiv	ebx
	add		edx, 48
	push	edx

; Quotient == 0, then digit is finished
	cmp		eax, 0
	jne		POSITIVE_INT															; More positive bytes to process JMP To: line-484

FILL_POSITIVE:																		; Fill positive number string JMP From: line-502

; Pop the positive numbers from the stack
	pop		eax
	stosb
	cmp		eax, 0
	jne		FILL_POSITIVE															; More positive bytes JMP To: line-496
	jmp		FINISH_CONVERT															; Positive string created JMP To: line-532

NEGATIVE_INT:																		; Loop to create negative number bytes JMP From: line-516

; Process a negative signed int to string
	cdq
	idiv	ebx
	neg		edx
	add		edx, 48
	push	edx

; Quotient == 0, then digit is finished
	cmp		eax, 0
	jne		NEGATIVE_INT															; More negative bytes to process JMP To: line-505

; Add minus sign to negative number string
	mov		al, 45
	mov		[edi], al
	inc		edi

FILL_NEGATIVE:																		; Fill negative number string JMP From: line-529

; Pop the positive numbers from the stack
	pop		eax
	stosb
	cmp		eax, 0
	jne		FILL_NEGATIVE															; More negative bytes JMP To: line-523
	jmp		FINISH_CONVERT															; Negative number string created JMP To: line-532

FINISH_CONVERT:																		; Number string created JMP From: line-503, 530

; Print the string to the console
	displayString PARAM_2

; Clean up and return
	cld
	popad
	pop		ebp
	ret		2 * TYPE DWORD

writeVal ENDP


;------------------------------------------------------------------------------
; printRslt
;
; Description:       Print the array, sum, and average with their accompanying
;					 messages. It calls writeVal to convert the numbers to strings
; Pre-conditions:	 Necessary parameters pushed onto the stack in order
; Post-conditions:	 The array, sum, and average are printed to the console
; Parameters:		 PARAM_1: OFFSET listMsg, PARAM_2: OFFSET numArray
;					 PARAM_3: OFFSET sumMsg, PARAM_4: OFFSET numSum
;					 PARAM_5: OFFSET avgMsg, PARAM_6: OFFSET numAvg
;					 PARAM_7: OFFSET strTemp, PARAM_8: ARRAY_SIZE (value)
; Registers changed: None
;------------------------------------------------------------------------------

printRslt PROC

; Set up registers
	push	ebp
	mov		ebp, esp
	pushad

; Display entered numbers
	displayString PARAM_1
	call	CrLf

; Set up array printing
    mov		ecx, PARAM_8
    mov     edi, [PARAM_2]     

PRINT_LOOP:																			; LOOP through number array From: line-590

; Convert and print each array value
	push	PARAM_7
	push	[edi]
	call	writeVal

; Print a comma after the first 9 numbers
	cmp		ecx, 1
	je		ARRAY_FINISHED															; After 9th comma JMP To: line-592
	mov		al, 44
	call	writeChar
	mov		al, 32
	call	writeChar
	add		edi, 4
	loop	PRINT_LOOP																; LOOP To: line-575

ARRAY_FINISHED:																		; After the array is printed JMP From: line-584

; Display the sum
	call	CrLf
    displayString PARAM_3
	mov		edi, [PARAM_4]
	push	PARAM_7
	push	[edi]
	call	writeVal

; Display the average
	call	CrLf
    displayString PARAM_5
	mov		edi, [PARAM_6]
	push	PARAM_7
	push	[edi]
	call	writeVal

; Clean up and return
	call	CrLf
	call	CrLf
	popad
	pop		ebp
	ret		8 * TYPE DWORD

printRslt ENDP


;------------------------------------------------------------------------------
; quit
;
; Description:        Prints the quit dialog
;					  quitVal == 1 to quit or any other value to continue
; Pre-conditions:	  quitPrompt pushed onto stack
; Post-conditions:	  quitVal stored in eax upon return
; Parameters:		  PARAM_1: OFFSET quitPrompt
; Registers changed:  eax
;------------------------------------------------------------------------------

quit PROC

; Set up message in edx
	push	ebp
	mov		ebp, esp
	push	edx
	displayString PARAM_1

; Prompt the user and return bool in eax
	call	ReadInt
	call	CrLf
	pop		edx
	pop		ebp
	ret		1 * TYPE PARAM_1

quit ENDP


;------------------------------------------------------------------------------
; finish
;
; Description:        Prints the Goodbye message
; Pre-conditions:	  byePrompt pushed onto stack
; Post-conditions:	  Goodbye printed
; Parameters:		  PARAM_1: OFFSET byePrompt
; Registers changed:  None
;------------------------------------------------------------------------------

farewell PROC															

; Set up message in edx
	push	ebp
	mov		ebp, esp
	pushad
	displayString PARAM_1

; Print the Goodbye message
	call	CrLf
	popad
	pop		ebp
	ret		1 * TYPE PARAM_1

farewell ENDP


END main
