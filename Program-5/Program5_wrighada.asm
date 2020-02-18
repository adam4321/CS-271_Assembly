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
PARAM_5 EQU [ebp + 24]																; Explicit stack offset for parameter 5
PARAM_6 EQU [ebp + 28]																; Explicit stack offset for parameter 6
PARAM_7 EQU [ebp + 32]																; Explicit stack offset for parameter 7


.data																				; VARIABLE DEFINITIONS
intro		BYTE	"** Program-5 -- Array Sorting **", 0
programmer	BYTE	"** Programmed by Adam Wright  **", 0
instr1		BYTE	"This program generates 200 random numbers in the range ", 0 
instr2		BYTE	"[10 ... 29], displays the original list, ", 0
instr3		BYTE	"sorts the list, displays the median value, displays ", 0 
instr4		BYTE	"the list sorted in ascending order, then ", 0
instr5		BYTE	"displays the number of instances of each generated value.", 0
numPrompt	BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
errPrompt	BYTE	"Number Invalid!", 0
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
byePrompt	BYTE	"Good-bye, and thanks for using my program!", 0
array		DWORD	200 DUP(?)														; Empty array of DWORDS to hold the number array
numCounts	DWORD	20 DUP(?)														; Empty array 
quitVal		DWORD	1																; Integer holding 1 to quit or any other value to continue
curRand		DWORD	?																; Integer holding the current random number
curVal		DWORD	4																; Integer holding the composite to be checked and printed
median		DWORD	0																; Integer to receive the calculated median

																					
.code																				; EXECUTABLE INSTRUCTIONS
main PROC

; Seed the Irvine library random function
	call	Randomize

; Introduce title, programmer, and instructions
	push	OFFSET instr5
	push	OFFSET instr4
	push	OFFSET instr3
	push	OFFSET instr2
	push	OFFSET instr1
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
	call	displayList

; Sort the array from low to high
	call	sortList

; Calculate and print the median value
	call	displayMedian

; Print the sorted array
	call	displayList

; Calculate number occurances 10-19
	call	countList

; Print the number counts 10-29
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
;					 PARAM_3: OFFSET instr1, PARAM_4: OFFSET instr2
;					 PARAM_5: OFFSET instr3, PARAM_6: OFFSET instr4
;					 PARAM_7: OFFSET instr5
; Registers changed: edx
;------------------------------------------------------------------------

introduction PROC

; Introduce title, programmer
	call	CrLf
	push	ebp
	mov		ebp, esp
	mov		edx, PARAM_1
	call	WriteString
	call	CrLf
	mov		edx, PARAM_2
	call	WriteString
	call	CrLf
	call	CrLf

; Print the instructions with formatting for MSVS window width
	mov		edx, PARAM_3
	call	WriteString
	mov		edx, PARAM_4
	call	WriteString
	call	CrLf
	mov		edx, PARAM_5
	call	WriteString
	mov		edx, PARAM_6
	call	WriteString
	call	CrLf
	mov		edx, PARAM_7
	call	WriteString
	call	CrLf
	pop		ebp
	ret		28

introduction ENDP


;------------------------------------------------------------------------------
; fillArray
;
; Description:       Fill 200 numbers each between 10-29
; Pre-conditions:	 array, LO range, HI range, and ARRAY_SIZE on stack
; Post-conditions:	 array filled with 200 values in range 10-29
; Parameters:		 PARAM_1: OFFSET array, PARAM_2: RANGE_LO (value)
;					 PARAM_3: RANGE_HI (value) PARAM_4: ARRAY_SIZE (value)
; Registers changed: edx, eax
;------------------------------------------------------------------------------

fillArray PROC

; Set up
	push	ebp
	mov		ebp, esp


	pop		ebp
	ret		16

fillArray ENDP


;------------------------------------------------------------------------------
; sortList
;
; Description:        Sorts array from low to high
; Pre-conditions:	  array and ARRAY_SIZE on stack
; Post-conditions:	  array sorted from low to high
; Parameters:		  
; Registers changed:  eax
;------------------------------------------------------------------------------

sortList PROC

	call	exchangeElements

	ret

sortList ENDP


;------------------------------------------------------------------------------
; exchangeElements
;
; Description:        Swaps two values by reference
; Pre-conditions:	  Two array indexes on stack
; Post-conditions:	  Paramater 1 and 2 are swapped
; Parameters:		  
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
; Parameters:		  
; Registers changed:  eax, ebx, edx
;------------------------------------------------------------------------------

displayMedian PROC



	ret

displayMedian ENDP


;------------------------------------------------------------------------------
; displayList
;
; Description:        Print the array 20 numbers per line and two space columns
; Pre-conditions:	  array and ARRAY_SIZE on stack
; Post-conditions:	  array printed to console
; Parameters:		  PARAM_1: OFFSET array, PARAM_2: ARRAY_SIZE
; Registers changed:  eax, edx
;------------------------------------------------------------------------------

displayList PROC



	ret

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
; Registers changed:  edx, eax
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
	ret		4

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
	mov		edx, PARAM_1

; Print the Goodbye message
	call	WriteString
	call	CrLf
	pop		ebp
	ret		4

farewell ENDP


END main
