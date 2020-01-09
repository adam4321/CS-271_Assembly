TITLE Program 1  -- Sums and Differences

; Author:						Adam Wright
; Last Modified:				1-8-2020
; OSU email address:			wrighada@oregonstate.edu
; Course number/section:		cs271--400
; Project Number:               1  
; Due Date:						1-19-2020
; Description:					Assembly program which prompts the user for
;								three integers in descending order and then
;								calculates the sum and difference of the sets
;								(A+B, A-B, A+C, A-C, B+C, B-C, A+B+C) and 
;								displays it to the user

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data  ; variable definitions
intro		BYTE	"Adam Wright  --  Program-1 -- Sums and differences", 0
instrctMsg	BYTE	"Enter 3 numbers A > B > C, and I'll show you the sums and differences!", 0
firPrompt	BYTE	"First number: ", 0
secPrompt	BYTE	"Second number: ", 0
thrdPrompt	BYTE	"Third number: ", 0
addSym		BYTE	" + ", 0
subSym		BYTE	" - ", 0
goodBye		BYTE	"Good-bye !!!", 0

.code  ; executable instructions
main PROC

; Introduce programmer and title
	call	CrLf
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf

; Print the instructions
	mov		edx, OFFSET instrctMsg
	call	WriteString
	call	CrLf
	call	CrLf

; Prompt for first number

; Say "Good-bye"
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
