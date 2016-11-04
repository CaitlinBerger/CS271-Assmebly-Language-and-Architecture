TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

LOWER_LIMIT EQU 0
UPPER_LIMIT EQU 400

.data

line1	BYTE "Composite Numbers   Programmed by Caitlin Berger", 0
line2	BYTE "Enter the number of composite numbers you would like to see.", 13, 10, 
				"I will acccept numbers between 0 and 400", 0
prompt1	BYTE "Enter the number of composites to display [0...400] ", 0
error1	BYTE "Out of range. Try again.", 0
line3	BYTE "Thanks for playing!", 0
space1	BYTE "     ", 0

input1	DWORD ?
current	DWORD ?
result1 BYTE ?
newLnCt BYTE ?


.code
main PROC

	call DispIntro ;display the title and instructions
	call getInput ;gather user input
	call showComposites ;display user inputted number of composite numbers in increasing order
	call farewell ;display leaving message

	exit	; exit to operating system
main ENDP

; displays the introduction of the program
; preconditions: none
; postconditions: introduction and instructions printed to the screen
; registers changed: edx 
dispIntro PROC
	mov edx, OFFSET line1
	call WriteString
	call CrLf
	mov edx, OFFSET line2
	call WriteString
	call CrLf 
	RET
dispIntro ENDP

; gets and validates user input. Repeats until input is valid
; preconditions: none
; postconditions: user input stored in input1
; registers changed: eax, edx
getInput PROC
	check1:
		;print prompt
		mov edx, OFFSET prompt1
		call WriteString
		;get user input (read into eax)
		call ReadInt 

		;check if in range. If not, jump back to check 1
		cmp eax, LOWER_LIMIT 
		jl e1
		cmp eax, UPPER_LIMIT
		jg e1
		jmp endLoop
	e1:
		mov edx, OFFSET error1 ;print error message
		call WriteString
		call CrLf
		jmp check1 ;repeat loop
	endLoop: ;input is valid, save result and end the procedure
		mov input1, eax
		RET
getInput ENDP

; loop showing input1 composite numbers implemeted using MASM loop call. Calls isComposite 
;	to check if current is a composite number
; preconditions: the number of composite numbers to be displayed must be in input1
; postconditions: prints input1 composite numbers to the screen
; registers changed: ecx, eax and edx are changed in isComposite call
showComposites PROC
	call CrLf

	mov current, 3 ;initialize the current composite number to be printed (first composite is 4)
	mov ecx, input1 ;initialize the counter 
	mov newLnCt, 0 ;initialize new line count
	L1:
		inc current ;increment current
		push ecx ; save the count on the stack
		call isComposite ;check if current is composite
		pop ecx ;recover the count from the stack
		;if it's not composite, go back to L1 (inc current and check if composite)
		cmp result1, 0
		je L1
		;if it is, print it to the screen
		mov eax, current
		call WriteDec
		mov edx, OFFSET space1
		call WriteString
		;increment newLnCt, if 10, print a new line and reset
		inc newLnCt
		cmp newLnCt, 10
		jne noNewLn ;if no new line, skip this part
		mov newLnCt, 0
		call CrLf
	noNewLn:
	loop L1 ;loop through input1 times
	call CrLf ;print a new line
	call CrLf

	RET
showComposites ENDP

; checks if a number is a composite number. 
; Returns: number of factors, not including 1. So if 0, it's prime
; preconditions: number to be checked must be stored in "current" variable
; postconditions: 1 will be in result if the number is composite, otherwise 0 will be returned in result1
; registers changed: eax, [ecx], edx
isComposite PROC
	
	; MOVE CURRENT/2 TO ECX
	mov eax, current ;move current number to eax
	cdq ;sign extend to divide
	mov ebx, 2
	idiv ebx ;divide by 2
	mov ecx, eax ;move to counter

	L2:
		cmp ecx, 1 ;if trying to check 1, exit the loop
		je endLoop
		mov eax, current ;move the current number into eax
		cdq
		idiv ecx ;divide by factor we're currently checking
		cmp edx, 0 ;check if remainder is 0
		je posExit ;if it is, jumt to positive return loop (posExit)
		loop L2 ;otherwise, loop again
	endLoop:
	; if through the entire loop w/o factor, result is 0
	mov result1, 0
	jmp endIsComposite ;jump to the end of the procedure

	posExit:
		mov result1, 1 ;change the result to 1

	endIsComposite:
	RET
isComposite ENDP

;prints a farewell message to the screen
;registers changed: edx
farewell PROC
	mov edx, OFFSET line3
	call WriteString
	call CrLf
	call CrLf
	RET
farewell ENDP


END main
