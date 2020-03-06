TITLE Program 6                 Program6_wrighada.asm

; Author:						Adam Wright
; Last Modified:				3-5-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271-400
; Project Number:               6  
; Due Date:						3-15-2020
; Description:					Assembly program which requests 10 32 bit signed 
;								integers from the user and then prints the list,
;								the sum, and then the average of the numbers


INCLUDE Irvine32.inc


;  -------------------------------------------------------------------------------  ; CONSTANT DEFINITIONS

ARRAY_SIZE = 10 																	; Constant holding the highest possible value for input

PARAM_1 EQU [ebp + 8]																; Explicit stack offset for parameter 1
PARAM_2 EQU [ebp + 12]																; Explicit stack offset for parameter 2
PARAM_3 EQU [ebp + 16]																; Explicit stack offset for parameter 3
PARAM_4 EQU [ebp + 20]																; Explicit stack offset for parameter 4


;  -------------------------------------------------------------------------------	; MACRO DEFINITIONS

;------------------------------------------------------------------------------
; getString
;
; Description:        MACRO that prompts the user for a string while storing 
;					  and restoring edx
; Pre-conditions:	  Parameter passed is a variable to hold the address of a 
;					  string
; Post-conditions:	  String stored in the chosen variable 
; Parameters:		  varName
; Registers changed:  None
;------------------------------------------------------------------------------

getString MACRO ptr_varName, ptr_prompt
    push    ecx
    push    edx
	mov		edx, ptr_prompt
	call	WriteString
    mov     edx, ptr_varName
	mov		ecx, (SIZEOF ptr_varName) - 1
	call	ReadString
	pop		edx
	pop		ecx
ENDM


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
errPrompt	BYTE	"ERROR: You did not enter a signed number or "
			BYTE	"your number was too big.", 0dh, 0ah
			BYTE	"Please try again: ", 0dh, 0ah, 0
listMsg		BYTE	"You entered the following numbers: ", 0
sumMsg		BYTE	"The sum of these numbers is: ", 0
avgMsg		BYTE	"The rounded average is: "
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
byePrompt	BYTE	"Good-bye, and thanks for using my program!", 0
quitVal		DWORD	1																; Integer holding 1 to quit or any other value to continue
numArray	DWORD	ARRAY_SIZE DUP(?)												; Empty array for holding the entered and verified numbers
strTest		BYTE	30 DUP(?), 0													; Empty string for receiving user input
numSum		DWORD	0																; Variable for receiving the sum of the entered numbers
numAvg		DWORD	0																; Variable for receiving the average of the entered numbers
numCount	DWORD	0																; Variable holding the current number of valid entries


;  -------------------------------------------------------------------------------  ; EXECUTABLE INSTRUCTIONS

.code
main PROC

; Seed the Irvine library random function
	call	Randomize

; Introduce title, programmer, and instructions
	push	OFFSET instruct
	push	OFFSET programmer
	push	OFFSET intro
	call	introduction

MAIN_LOOP:																			; Restart (quitVal == 1) JMP From: line-123

; Request 10 numbers from the user
	push	OFFSET errPrompt
	push	OFFSET userPrompt
	push	ARRAY_SIZE
	push	OFFSET strTest
	call	readVal

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
; Parameters:		 PARAM_1: , PARAM_2: 
;					 PARAM_3: , PARAM_4: 
; Registers changed: 
;------------------------------------------------------------------------------

readVal PROC

; Set up registers
	push	ebp
	mov		ebp, esp

; Call macro to get user value
	;getString PARAM_1, PARAM_3


	pop		ebp
	ret		4 * TYPE PARAM_1

readVal ENDP


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

; 
	push	ebp
	mov		ebp, esp

	pop		ebp
	ret		

writeVal ENDP


;------------------------------------------------------------------------------
; displayResults
;
; Description:        
; Pre-conditions:	  
; Post-conditions:	  
; Parameters:		  PARAM_1: , PARAM_2: 
; Registers changed:  
;------------------------------------------------------------------------------

displayResults PROC

; 
	push	ebp
	mov		ebp, esp

	pop		ebp
	ret		

displayResults ENDP


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
	mov		numCount, 0

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
