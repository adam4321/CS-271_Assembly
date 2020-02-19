TITLE Program 5                 Program5_wrighada.asm

; Author:						Adam Wright
; Last Modified:				2-18-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271-400
; Project Number:               5  
; Due Date:						3-1-2020
; Description:					Assembly program which creates an array of 
;								200 random numbers between 10 - 29 and then
;								prints the array. Then, it sorts the array,
;								it calculates and prints the median value, 
;								it prints the sorted array, it calculates
;								the occurance of the 20 numbers in the array,
;								and it prints the array of number counts.


INCLUDE Irvine32.inc


;  -------------------------------------------------------------------------------  ; CONSTANT DEFINITIONS

ARRAY_SIZE = 200																	; Constant holding the highest possible value for input
RANGE_LO = 10																		; Constant holding the lowest possible random num in array
RANGE_HI = 29																		; Constant holding the highest possible random num in array

PARAM_1 EQU [ebp + 8]																; Explicit stack offset for parameter 1
PARAM_2 EQU [ebp + 12]																; Explicit stack offset for parameter 2
PARAM_3 EQU [ebp + 16]																; Explicit stack offset for parameter 3
PARAM_4 EQU [ebp + 20]																; Explicit stack offset for parameter 4


.data																				; VARIABLE DEFINITIONS
intro		BYTE	"** Program-5 -- Array Sorting **", 0dh, 0ah, 0
programmer	BYTE	"** Programmed by Adam Wright  **", 0dh, 0ah, 0
instruct	BYTE	"This program generates 200 random numbers in the range "
			BYTE	"[10 ... 29], displays the original list, ", 0dh, 0ah
			BYTE	"sorts the list, displays the median value, displays "
			BYTE	"the list sorted in ascending order, then ", 0dh, 0ah
			BYTE	"displays the number of instances of each generated "
			BYTE	"value.", 0dh, 0ah, 0
unsortMsg	BYTE	"Your unsorted random numbers:", 0
medianMsg	BYTE	"List Median:", 0
sortMsg		BYTE	"Your sorted random numbers:", 0
listMsg		BYTE	"Your list of instances of each generated number, "
			BYTE	"starting with the number of 10s:", 0
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
byePrompt	BYTE	"Good-bye, and thanks for using my program!", 0
array		DWORD	200 DUP(?)														; Empty array of DWORDS to hold the number array
numCounts	DWORD	20 DUP(?)														; Empty array
median		DWORD	0																; Integer to receive the calculated median
quitVal		DWORD	1																; Integer holding 1 to quit or any other value to continue

																					
.code																				; EXECUTABLE INSTRUCTIONS
main PROC

; Seed the Irvine library random function
	call	Randomize

; Introduce title, programmer, and instructions
	push	OFFSET instruct
	push	OFFSET programmer
	push	OFFSET intro
	call	introduction

MAIN_LOOP:																			; Restart (quitVal == 1) JMP From: line-

; Fill the array with random numbers between 10-29
	push	ARRAY_SIZE
	push	RANGE_HI
	push	RANGE_LO
	push	OFFSET array
	call	fillArray

; Print the unsorted array
	push	OFFSET unsortMsg
	push	ARRAY_SIZE
	push	OFFSET array
	call	displayList

; Sort the array from low to high
	call	sortList

; Calculate and print the median value
	call	displayMedian

; Print the sorted array
	push	OFFSET sortMsg
	push	ARRAY_SIZE
	push	OFFSET array
	call	displayList

; Calculate number occurances 10-19
	call	countList

; Print the number counts 10-29
	push	OFFSET listMsg
	push	ARRAY_SIZE
	push	OFFSET array
	call	displayList

; Ask if the user wants to quit
	push	OFFSET quitPrompt
	call	quit																	; Returns quitVal in eax
	mov		quitVal, eax

; Reset variables for potential next running
;	mov		median, 0

; Check the value set in the quit procedure
	cmp		quitVal, 1
	jne		MAIN_LOOP																; Enter 1 to reset JMP To: line-

; Function that says "Good-bye"
	push	OFFSET byePrompt
	call	farewell

; Exit to operating system
	exit							

main ENDP

																					
;------------------------------------------------------------------------			; PROCEDURE DEFINITIONS
; introduction
;
; Description:       Prints the Introductory message
; Pre-conditions:	 4 string pointers pushed onto stack
; Post-conditions:	 none
; Parameters:		 PARAM_1: OFFSET intro, PARAM_2: OFFSET programmer
;					 PARAM_3: OFFSET instruct
; Registers changed: edx, ebp, esp
;------------------------------------------------------------------------

introduction PROC

; Print the title message
	push	ebp
	mov		ebp, esp
	call	CrLf
	mov		edx, PARAM_1
	call	WriteString

; Print the programmer message
	mov		edx, PARAM_2
	call	WriteString
	call	CrLf

; Print the instructions and finish
	mov		edx, PARAM_3
	call	WriteString
	pop		ebp
	ret		3 * TYPE PARAM_1

introduction ENDP


;------------------------------------------------------------------------------
; fillArray
;
; Description:       Fill 200 numbers each between 10-29
; Pre-conditions:	 array, LO range, HI range, and ARRAY_SIZE on stack
; Post-conditions:	 array filled with 200 values in range 10-29
; Parameters:		 PARAM_1: OFFSET array, PARAM_2: RANGE_LO (value)
;					 PARAM_3: RANGE_HI (value) PARAM_4: ARRAY_SIZE (value)
; Registers changed: eax, esi, ebp, esp
;------------------------------------------------------------------------------

fillArray PROC

; Set up array filling loop
	push	ebp
	mov		ebp, esp
	mov		edi, PARAM_1
	mov		ecx, PARAM_4

ARRAY_FILL:

; Generate number between 10-29
	mov		eax, PARAM_3
	sub		eax, PARAM_2
	inc		eax
	call	RandomRange
	add		eax, PARAM_2

; Enter number into array
	mov		[edi], eax
	add		edi, TYPE array
	loop	ARRAY_FILL

; Exit when array length is reached
	pop		ebp
	ret		4 * TYPE PARAM_1

fillArray ENDP


;--------------------------------------------------------------------------------
; sortList
;
; Description:        Sorts array of 32 bit ints from low to high with bubblesort
;					  from pg.375 of ed.7 Intel Assembly by Irvine
; Pre-conditions:	  OFFSET array and ARRAY_SIZE on stack
; Post-conditions:	  array sorted from low to high
; Parameters:		  PARAM_1: OFFSET array, PARAM_2: ARRAY_SIZE
; Registers changed:  eax, ecx, ebp, esi
;--------------------------------------------------------------------------------

sortList PROC

; Set array loop to array address
;	push	ebp
;	mov		ebp, esp
;	mov		ecx, PARAM_2
;	dec		ecx						; decrement count by 1

L1:

;	push	ecx						; save outer loop count
;	mov		esi, PARAM_1			; point to first value

L2:

;	mov		eax, [esi]				; get array value
;	cmp		[esi+4], eax			; compare a pair of values
;	jg		L3						; if [ESI] <= [ESI+4], no exchange

; Call swap function
;	push	
;	xchg	eax, [esi+4]			; exchange the pair
;	mov		[esi], eax

L3:

;	add		esi, 4					; move both pointers forward
;	loop	L2						; inner loop
;	pop		ecx						; retrieve outer loop count
;	loop	L1						; else repeat outer loop

L4:

;	pop		ebp
;	ret		2 * TYPE PARAM_1

sortList ENDP


;------------------------------------------------------------------------------
; exchangeElements
;
; Description:        Swaps two values by reference
; Pre-conditions:	  Two array indexes on stack
; Post-conditions:	  Paramater 1 and 2 are swapped
; Parameters:		  PARAM_1: , PARM_2: 
; Registers changed:  eax, ebx
;------------------------------------------------------------------------------

exchangeElements PROC

															

	ret

exchangeElements ENDP


;------------------------------------------------------------------------------
; displayMedian
;
; Description:        Calculates and prints the median value of the array
; Pre-conditions:	  curVal contains 4, compCheck contains 0
; Post-conditions:	  Median printed to console
; Parameters:		  PARAM_1: , PARM_2: 
; Registers changed:  eax, ebx, edx
;------------------------------------------------------------------------------

displayMedian PROC



	ret

displayMedian ENDP


;--------------------------------------------------------------------------------
; displayList
;
; Description:        Print the array 20 numbers per line and two space columns
; Pre-conditions:	  OFFSET array, ARRAY_SIZE, unsortMsg on stack
; Post-conditions:	  array printed to console
; Parameters:		  PARAM_1: OFFSET array, PARAM_2: ARRAY_SIZE 
;					  PARAM_3: printing message (unsortMsg, sortMsg, or listMsg)
; Registers changed:  eax, edx
;--------------------------------------------------------------------------------

displayList PROC

; Set up
	call	CrLf
	push	ebp
	mov		ebp, esp

; Print the unsortMsg
	mov		edx, PARAM_3
	call	WriteString
	call	CrLf

; Exit after array printed
	pop		ebp
	ret		3 * TYPE PARAM_1

displayList ENDP


;------------------------------------------------------------------------------
; countList
;
; Description:        Counts occurances of each number and prints them
; Pre-conditions:	  
; Post-conditions:	  20 number counts printed to console using displayList
; Parameters:		  
; Registers changed:  eax, ebx, edx
;------------------------------------------------------------------------------

countList PROC



	ret

countList ENDP


;------------------------------------------------------------------------------
; quit
;
; Description:        Prints the quit dialog
;					  quitVal == 1 to quit or any other value to continue
; Pre-conditions:	  quitPrompt pushed onto stack
; Post-conditions:	  quitVal stored in eax upon return
; Parameters:		  PARAM_1: OFFSET quitPrompt
; Registers changed:  edx, eax, epb, esp
;------------------------------------------------------------------------------

quit PROC

; Set up message in edx
	call	CrLf
	push	ebp
	mov		ebp, esp
	mov		edx, PARAM_1

; Prompt the user and return in eax
	call	WriteString
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
; Registers changed:  edx, ebp, esp
;------------------------------------------------------------------------------

farewell PROC															

; Set up message in edx
	call	CrLf
	push	ebp
	mov		ebp, esp
	mov		edx, PARAM_1

; Print the Goodbye message
	call	WriteString
	call	CrLf
	pop		ebp
	ret		1 * TYPE PARAM_1

farewell ENDP


END main
