TITLE Program 6                 Program6_wrighada.asm

; Author:						Adam Wright
; Last Modified:				3-10-2020
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
; Description:        MACRO that prompts the user for a string while storing 
;					  and restoring ecx and edx
; Pre-conditions:	  Parameter passed is a variable to hold the address of a 
;					  string
; Post-conditions:	  String stored in the chosen variable 
; Parameters:		  varName
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
avgMsg		BYTE	"The rounded average is: "
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
byePrompt	BYTE	"Good-bye, and thanks for using my program!", 0
quitVal		DWORD	1																; Integer holding 1 to quit or any other value to continue
numArray	SDWORD	ARRAY_SIZE DUP(?)												; Empty array for holding the entered and verified numbers
strTest		BYTE	31 DUP(?), 0													; Empty string for receiving user input
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

MAIN_LOOP:																			; Restart (quitVal == 1) JMP From: line-123

; Request 10 numbers from the user
	push	OFFSET testedNum
	push	OFFSET errPrompt
	push	OFFSET errMsg
	push	OFFSET userPrompt
	push	ARRAY_SIZE
	push	OFFSET numArray
	push	STR_SIZE
	push	OFFSET strTest
	call	getValues

; Calculate sum and average
	call	calculations

; Display the results
	push	OFFSET avgMsg
	push	
	push	OFFSET listMsg
	call	printRslt

; Ask if the user wants to quit
	push	OFFSET quitPrompt
	call	quit																	; Returns quitVal bool in eax
	mov		quitVal, eax

; Check the value set in the quit procedure
	cmp		quitVal, 1
	jne		MAIN_LOOP																; Enter 1 to reset JMP To: line-71

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
; Description:       Prints the Introductory message
; Pre-conditions:	 4 string pointers pushed onto stack
; Post-conditions:	 none
; Parameters:		 PARAM_1: OFFSET intro, PARAM_2: OFFSET programmer
;					 PARAM_3: OFFSET instruct
; Registers changed: edx
;------------------------------------------------------------------------------

introduction PROC

; Print the title message
	push	ebp
	mov		ebp, esp
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
	pop		ebp
	ret		3 * TYPE PARAM_1

introduction ENDP


;------------------------------------------------------------------------------
; readVal
;
; Description:       
; Pre-conditions:	 
; Post-conditions:	 
; Parameters:		 PARAM_1: OFFSET strTest, PARAM_2: STR_SIZE (value)
;					 PARAM_3: OFFSET userPrompt, PARAM_4: OFFSET errMsg
;					 PARAM_5: OFFSET errPrompt, PARAM_6: OFFSET testedNum
; Registers changed: 
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
	jmp		VALIDATE

ERROR_PROMPT:																		; jmp

; Print error and request a valid number
	call	CrLf
	displayString PARAM_4
	getString PARAM_5, PARAM_1, PARAM_2
	mov		edx, 0
	mov		ebx, 10
	mov		ecx, eax
	mov		esi, [PARAM_1]
	cld

VALIDATE:																			; jmp

; Pull the first byte and check for negative
	lodsb
	cmp		al, 45
	je		REMOVE_MINUS															; jmp
	cmp		al, 43
	je		REMOVE_PLUS
	jmp		NO_SIGN																	; jmp
	
REMOVE_MINUS:																		; jmp

; Pull off the minus sign
	dec		ecx
	jmp		NEGATIVE

REMOVE_PLUS:																		; jmp

; Pull off the plus sign
	dec		ecx
	jmp		POSITIVE

NO_SIGN:																			; jmp

; Pull off nothing and reload first byte
	dec		esi
	jmp		POSITIVE

NEGATIVE:																			; jmp

; Validate possible negative value
	lodsb
	cmp		al, 48
	jl		ERROR_PROMPT
	cmp		al, 57
	jg		ERROR_PROMPT
	
; Process valid negative digit
	sub		al, 48
	movzx	edi, al
	mov		eax, edx
	mul		ebx
	add		eax, edi
	mov		edx, eax
	loop	NEGATIVE

; Mul by -1 to turn number negative
	mov		ebx, -1
	mul		ebx
	mov		edx, eax
	jmp		NUMBER_RANGE

POSITIVE:																			; jmp

; Validate possible positive value
	lodsb
	cmp		al, 48
	jl		ERROR_PROMPT
	cmp		al, 57
	jg		ERROR_PROMPT

; Process valid positive digit
	sub		al, 48
	movsx	edi, al
	mov		eax, edx
	mul		ebx
	add		eax, edi
	mov		edx, eax
	loop	POSITIVE

NUMBER_RANGE:																		; jmp

; Check that the number is between min and max int size
	cmp		edx, 2147483647
	jg		ERROR_PROMPT
	cmp		edx, -2147483648
	jl		ERROR_PROMPT
	
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
; Pre-conditions:	 
; Post-conditions:	 
; Parameters:		 PARAM_1: OFFSET strTest, PARAM_2: STR_SIZE (value)
;					 PARAM_3: OFFSET numArray, PARAM_4: ARRAY_SIZE
;					 PARAM_5: OFFSET userPrompt, PARAM_6: OFFSET errMsg
;					 PARAM_7: OFFSET errPrompt, PARAM_8: OFFSET testedNum
; Registers changed: 
;------------------------------------------------------------------------------

getValues PROC

; Set up registers
	push	ebp
	mov		ebp, esp
	mov		ecx, PARAM_4
	mov		edi, PARAM_3
	mov		esi, PARAM_1

FILL_LOOP:																			; Loop From: line-

; Call proc to get string and return value in eax
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
	loop	FILL_LOOP

; Clean up and return
	pop		ebp
	ret		8 * TYPE DWORD

getValues ENDP


;------------------------------------------------------------------------------
; calculations
;
; Description:        
; Pre-conditions:	  
; Post-conditions:	  
; Parameters:		  PARAM_1: , PARAM_2: 
;					  PARAM_3: 
; Registers changed:  
;------------------------------------------------------------------------------

calculations PROC

; Set up registers
	push	ebp
	mov		ebp, esp

	

; Clean up and return
	pop		ebp
	ret		

calculations ENDP


;------------------------------------------------------------------------------
; writeVal
;
; Description:        
; Pre-conditions:	  
; Post-conditions:	  
; Parameters:		  PARAM_1: , PARAM_2: 
;					  PARAM_3: 
; Registers changed:  
;------------------------------------------------------------------------------

writeVal PROC

; Set up registers
	push	ebp
	mov		ebp, esp

	

; Clean up and return
	pop		ebp
	ret		

writeVal ENDP


;------------------------------------------------------------------------------
; printRslt
;
; Description:        
; Pre-conditions:	  
; Post-conditions:	  
; Parameters:		  PARAM_1: , PARAM_2: 
;					  PARAM_3: 
; Registers changed:  
;------------------------------------------------------------------------------

printRslt PROC

; Set up registers
	push	ebp
	mov		ebp, esp

; Display entered numbers
		

; Display the sum


; Display the average


; Clean up and return
	pop		ebp
	ret		

printRslt ENDP


;------------------------------------------------------------------------------
; quit
;
; Description:        Prints the quit dialog
;					  quitVal == 1 to quit or any other value to continue
; Pre-conditions:	  quitPrompt pushed onto stack
; Post-conditions:	  quitVal stored in eax upon return
; Parameters:		  PARAM_1: OFFSET quitPrompt
; Registers changed:  edx, eax
;------------------------------------------------------------------------------

quit PROC

; Set up message in edx
	push	ebp
	mov		ebp, esp
	displayString PARAM_1

; Reset variables for potential next running
	mov		numSum, 0
	mov		numAvg, 0

; Prompt the user and return bool in eax
	call	ReadInt
	pop		ebp
	ret		1 * TYPE PARAM_1

quit ENDP


;------------------------------------------------------------------------------
; finish
;
; Description:        Prints the Goodbye message
; Pre-conditions:	  byePrompt pushed onto stack
; Post-conditions:	  none
; Parameters:		  PARAM_1: OFFSET byePrompt
; Registers changed:  edx
;------------------------------------------------------------------------------

farewell PROC															

; Set up message in edx
	call	CrLf
	push	ebp
	mov		ebp, esp
	displayString PARAM_1

; Print the Goodbye message
	call	CrLf
	pop		ebp
	ret		1 * TYPE PARAM_1

farewell ENDP


END main
