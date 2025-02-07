TITLE Program 5                 Program5_wrighada.asm

; Author:						Adam Wright
; Last Modified:				2-23-2020
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
COUNT_LIST_SIZE = 20																; Constant holding the size of the occurance list

PARAM_1 EQU [ebp + 8]																; Explicit stack offset for parameter 1
PARAM_2 EQU [ebp + 12]																; Explicit stack offset for parameter 2
PARAM_3 EQU [ebp + 16]																; Explicit stack offset for parameter 3
PARAM_4 EQU [ebp + 20]																; Explicit stack offset for parameter 4


;  -------------------------------------------------------------------------------  ; VARIABLE DEFINITIONS

.data																				
intro		BYTE	"** Program-5 -- Array Sorting **", 0
programmer	BYTE	"** Programmed by Adam Wright  **", 0
instruct	BYTE	"This program generates 200 random numbers in the range "
			BYTE	"[10 ... 29], displays the original list, ", 0dh, 0ah
			BYTE	"sorts the list, displays the median value, displays "
			BYTE	"the list sorted in ascending order, then ", 0dh, 0ah
			BYTE	"displays the number of instances of each generated "
			BYTE	"value.", 0
unsortMsg	BYTE	"Your unsorted random numbers:", 0
medianMsg	BYTE	"List Median: ", 0
sortMsg		BYTE	"Your sorted random numbers:", 0
listMsg		BYTE	"Your list of instances of each generated number, "
			BYTE	"starting with the number of 10s:", 0
quitPrompt	BYTE	"Press 1 to quit and 2 to continue: ", 0
byePrompt	BYTE	"Good-bye, and thanks for using my program!", 0
array		DWORD	ARRAY_SIZE DUP(?)												; Empty array of DWORDS to hold the number array
numCounts	DWORD	20 DUP(?)														; Empty array
quitVal		DWORD	1																; Integer holding 1 to quit or any other value to continue


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
	push	ARRAY_SIZE
	push	OFFSET array
	call	sortList

; Calculate and print the median value
	push	OFFSET medianMsg
	push	ARRAY_SIZE
	push	OFFSET array
	call	displayMedian

; Print the sorted array
	push	OFFSET sortMsg
	push	ARRAY_SIZE
	push	OFFSET array
	call	displayList

; Calculate number occurances 10-19
	push	RANGE_LO
	push	OFFSET numCounts
	push	ARRAY_SIZE
	push	OFFSET array
	call	countList

; Print the number counts 10-29
	push	OFFSET listMsg
	push	COUNT_LIST_SIZE
	push	OFFSET numCounts
	call	displayList

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
	mov		edx, PARAM_1
	call	WriteString

; Print the programmer message
	call	CrLf
	mov		edx, PARAM_2
	call	WriteString

; Print the instructions and finish
	call	CrLf
	call	CrLf
	mov		edx, PARAM_3
	call	WriteString
	call	CrLf
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
; Registers changed: eax, ecx, esi
;------------------------------------------------------------------------------

fillArray PROC

; Set up array filling loop
	push	ebp
	mov		ebp, esp
	mov		esi, PARAM_1
	mov		ecx, PARAM_4

ARRAY_FILL:																			; Next number Loop From: line-205

; Generate number between 10-29
	mov		eax, PARAM_3
	sub		eax, PARAM_2
	inc		eax
	call	RandomRange
	add		eax, PARAM_2

; Enter number into array
	mov		[esi], eax
	add		esi, TYPE DWORD
	loop	ARRAY_FILL																; Loop until 200 JMP To: line-193

; Exit when array length is reached
	pop		ebp
	ret		4 * TYPE PARAM_1

fillArray ENDP


;------------------------------------------------------------------------------
; displayList
;
; Description:        Print the array 20 numbers per line and two space columns
; Pre-conditions:	  OFFSET array, ARRAY_SIZE, unsortMsg on stack
; Post-conditions:	  array printed to console
; Parameters:		  PARAM_1: OFFSET array, PARAM_2: ARRAY_SIZE 
;					  PARAM_3: printing message (unsortMsg, sortMsg or listMsg)
; Registers changed:  eax, ebx, ecx, edx, esi
;------------------------------------------------------------------------------

displayList PROC

; Set up array pointer and loops
	push	ebp
	mov		ebp, esp
	mov		esi, PARAM_1
	mov		ecx, PARAM_2
	mov		ebx, 1

; Print the unsortMsg
	call	CrLf
	mov		edx, PARAM_3
	call	WriteString
	call	CrLf

PRINT_ARR_1:																		; After number printed JMP From: line-256

; Print a row of 20 numbers with two white spaces between
	mov		eax, [esi]
	call	WriteDec
	mov		al, ' '
	call	WriteChar
	call	WriteChar
	cmp		ebx, 20
	je		PRINT_CRLF																; After 20 numbers in current row JMP To: line-259
	inc		ebx

PRINT_ARR_2:																		; After newline continue From: line-264

; Increment counters and check loop counter
	add		esi, TYPE DWORD
	loop	PRINT_ARR_1																; After number printed LOOP To: line-240
	jmp		FINISH_PRINT															; After entire array printed JMP To: line-266

PRINT_CRLF:																			; After 20 nums JMP From line-249
 
; Add a newline after 20 numbers
	call	CrLf
	mov		ebx, 1
	jmp		PRINT_ARR_2																; After newline JMP To: line-252

FINISH_PRINT:																		; Printing finished JMP From: line-257

; Exit after array printed
	call	CrLf
	pop		ebp
	ret		3 * TYPE PARAM_1

displayList ENDP


;------------------------------------------------------------------------------
; sortList
;
; Description:        Sorts array of DWORD from low to high
; Pre-conditions:	  OFFSET array and ARRAY_SIZE on stack
; Post-conditions:	  array sorted from low to high
; Parameters:		  PARAM_1: OFFSET array, PARAM_2: ARRAY_SIZE
; Registers changed:  eax, ecx, esi
;------------------------------------------------------------------------------

sortList PROC

; Set array loop to array address
	push	ebp
	mov		ebp, esp
	mov		ecx, PARAM_2
	dec		ecx

OUTER_LOOP:																			; Beginning of array Loop From: line-320 

; Store ARRAY_SIZE -1 on the stack
	push	ecx
	mov		esi, PARAM_1

INNER_LOOP:																			; Continue iteration Loop From: line-318

; Compare and swap or branch
	mov		eax, [esi]
	cmp		[esi + TYPE DWORD], eax
	jg		INCREMENT																; No swap JMP To: line-314

; Call swap function
	add		esi, TYPE DWORD
	push	esi
	sub		esi, TYPE DWORD
	push	esi
	call	exchangeElements

INCREMENT:																			; No swap JMP From: line-305

; Increment esi and loop and outer
	add		esi, TYPE DWORD
	loop	INNER_LOOP																; Continue sorting pass Loop To: line-300
	pop		ecx
	loop	OUTER_LOOP																; Next array pass Loop To: line-294

; Exit when array is sorted
	pop		ebp
	ret		2 * TYPE PARAM_1

sortList ENDP


;------------------------------------------------------------------------------
; exchangeElements
;
; Description:        Swaps two values by reference
; Pre-conditions:	  Two array addresses pushed onto stack. 2 * TYPE PARAM_1
;					  not working in return. Alternative must be used!
; Post-conditions:	  Paramater 1 and 2 are swapped
; Parameters:		  PARAM_1: index 1, PARAM_2: index 2  
; Registers changed:  eax, ebx, edx
;------------------------------------------------------------------------------

exchangeElements PROC

; Set up the stack frame
	push	ebp
	mov		ebp, esp
	pushad

; Swap the elements passed by reference
	mov		eax, [PARAM_1]
	mov		ebx, [PARAM_2]
	mov		edx, [eax]
	mov		eax, [ebx]
	mov		ebx, edx

; Insert the swapped numbers
	mov		[esi], eax
	mov		[esi + TYPE DWORD], ebx
	
; Exit after swap
	popad
	pop		ebp
	ret		2 * TYPE DWORD

exchangeElements ENDP


;------------------------------------------------------------------------------
; displayMedian
;
; Description:        Calculates and prints the median value of the array
; Pre-conditions:	  curVal contains 4, compCheck contains 0
; Post-conditions:	  Median printed to console
; Parameters:		  PARAM_1: OFFSET array, PARAM_2: ARRAY_SIZE (value) 
;					  PARAM_3: OFFSET medianMsg 
; Registers changed:  eax, ebx, edx
;------------------------------------------------------------------------------

displayMedian PROC
	push	ebp
	mov		ebp, esp

; Print the median message
	mov		edx, PARAM_3
	call	WriteString

; Get index of middle elements
	mov		edx, 0
	mov		eax, [PARAM_2]
	mov		ebx, 2
	div		ebx

; Jump to even or odd calculation
	cmp		edx, 0
	jne		ODD_MEDIAN																; If edx != 0 (Not Possible!) JMP To: line-412

EVEN_MEDIAN:																		; No need to jump, this will always be hit

; Get middle 2 elements (100 and 99)
	mov		eax, PARAM_1
	add		eax, 99 * TYPE DWORD
	mov		ebx, [eax]
	add		eax, TYPE DWORD
	mov		eax, [eax]

; Calculate the median (.5 rounds up)
	add		eax, ebx
	mov		ebx, 2
	div		ebx
	add		eax, edx
	call	WriteDec
	jmp		FINISH_MEDIAN															; If odd container were possible, this must be implemented

ODD_MEDIAN:																			; The container is fixed as even, so this won't be reached

FINISH_MEDIAN:																		; Even container size JMP From: line-410

; Exit after median created
	pop		ebp
	ret		3 * TYPE PARAM_1

displayMedian ENDP


;------------------------------------------------------------------------------
; countList
;
; Description:        Counts occurances of each number and prints them
; Pre-conditions:	  OFFSET array, ARRAY_SIZE, OFFSET numCounts, RANGE_LO
;					  pushed onto the stack
; Post-conditions:	  The 20 current number occurances in array stored in numCounts
; Parameters:		  PARAM_1: OFFSET array, PARAM_2: ARRAY_SIZE (value) 
;					  PARAM_3: OFFSET numCounts, PARAM_4: RANGE_LO (value)
; Registers changed:  eax, ebx, ecx, edx, esi, edi
;------------------------------------------------------------------------------

countList PROC

; Set up stack frame
	push	ebp
	mov		ebp, esp
	mov		ebx, PARAM_4
	mov		edi, [PARAM_3]

START_LOOP:																			; Iterate through array for each num 10-29 LOOP From: line-477

; Initialize the outer loop
	mov		esi, [PARAM_1]
	mov		ecx, PARAM_2
	mov		eax, 0
	
COUNT_LOOP:																			; Array not iterated through yet LOOP From: line-456 or 464

; Check for number and branch if found
	cmp		ebx, [esi]
	je		NUM_FOUND																; Searched num found JMP To: line-459
	add		esi, TYPE DWORD
	loop	COUNT_LOOP																; Iterate through entire array LOOP To: line-450
	jmp		NEXT_NUMBER																; Array iterated through JMP To: line-467

NUM_FOUND:																			; Searched num found JMP From: line-454

; Loop through each value and count occurance
	inc		eax
	add		esi, TYPE DWORD
	loop	COUNT_LOOP																; Iterate through whole array LOOP To: line-450
	jmp		NEXT_NUMBER																; Full interation of array JMP To: line-467

NEXT_NUMBER:																		; Increment num to check JMP From: line-457 or 465

; Enter the count into occurance list
	mov		[edi], eax
	add		edi, TYPE DWORD

; Increment the number to check for
	inc		ebx
	cmp		ebx, 30
	je		FINISH_COUNT															; After counting 29 JMP To: line-479
	jmp		START_LOOP																; 29 not yet counted JMP To: line-443

FINISH_COUNT:																		; Count array filled JMP From: line-476

; Exit after counts created
	pop		ebp
	ret		4 * TYPE PARAM_1

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
	push	ebp
	mov		ebp, esp
	mov		edx, PARAM_1

; Prompt the user and return bool in eax
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
	ret		1 * TYPE PARAM_1

farewell ENDP


END main
