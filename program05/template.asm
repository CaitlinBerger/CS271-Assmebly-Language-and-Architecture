TITLE Program Template     (template.asm)

; Author: Caitlin Berger
; CS271 / Program 5                 Date: 11/13/2016
; Description: Generates, sorts and finds the median of an array of random numbers

INCLUDE Irvine32.inc

; min and max array size
MIN_SIZE = 10
MAX_SIZE = 200

; min and max array entry value
LO = 100
HI = 999


.data

; (insert variable definitions here)
intro1			BYTE	"Sorting Random Numbers		Programmed by Caitlin Berger", 0
intro2			BYTE	"This Program generates random numbers in the range [100 ... 999],", 10, 13,
						"displays the original list, sorts the list, and calculates the", 10, 13,
						"median value. Finally, it displays the list sorted in descending order.", 0
getDataPrompt	BYTE	"How many numbers should be generated? [10 ... 200]: ", 0
getDataError	BYTE	"Invalid Input", 0
unsortedTitle	BYTE	"The unsorted random numbers: ", 0
sortedTitle		BYTE	"They sorted list: ", 0
medianText		BYTE	"The median is ", 0
space			BYTE	"   "

newLnCt	DWORD	?
array	DWORD	MAX_SIZE	DUP(?)
request	DWORD	?

.code
main PROC

	; introduce program
	call intro

	; push paramaters for getData
	push OFFSET request
	; get user input
	call getData

	; push parameters for fillArray
	push OFFSET array
	push request
	; fill the array with 'request' random entries
	call fillArray

	; push parameters for displayList
	push OFFSET array
	push request
	push OFFSET unsortedTitle
	; display the unsorted list
	call displayList

	; push parameters for sortList
	push OFFSET array
	push request
	; sort the list
	call sortList

	; push parameters for displayMedian
	push OFFSET array
	push request
	; display the median
	call displayMedian

	; push parameters for displayList
	push OFFSET array
	push request
	push OFFSET sortedTitle
	; display sorted list
	call displayList


	exit	; exit to operating system
main ENDP

; DESCRIPTION: Prints an introduction to the program to the screen
; PARAMETERS: none
; PRE-CONDITIONS: text to be displayed is stored as "intro1" and "intro2"
; RETURNS: none
; REGISTERS CHANGED: none
intro PROC
	pushad
	mov edx, OFFSET intro1
	call writeString
	call crlf
	mov edx, OFFSET intro2
	call writeString
	call crlf
	call crlf
	popad
	RET
intro ENDP

; DESCRIPTION: prompts the user to enter a number between MIN_SIZE and MAX_SIZE
; PARAMETERS: "request" location is pushed onto the stack before the program to store user input
; PRE-CONDITIONS: getDataPrompt and getDataError are strings that contain a prompt and an error
; RETURNS: "request" in locaiton pushed onto the stack
; REGISTERS CHANGED: none
getData PROC
	pushad
	push ebp
	mov ebp, esp
	mov edi, ebp
	add edi, 8
L1:
	;print prompt
	mov edx, OFFSET getDataPrompt
	call WriteString
	;get user input
	call ReadInt

	;if out of range, jump to error
	cmp eax, MIN_SIZE
	jl error1
	cmp eax, MAX_SIZE
	jg error1
	;otherwise, go to end and save
	jmp end1

error1:
	;if error, print error and loop back to beginning
	mov edx, OFFSET getDataError
	call WriteString
	call crlf
	jmp L1
end1:
	mov [edi], eax
	pop ebp
	popad
	RET 4
getData ENDP

; DESCRIPTION: fills the array with 'request' random numbers,  from lecture 19
; PARAMETERS: 'array' location and 'requeset' value pushed to the stack (in that order)
; PRE-CONDITIONS: 'request' value has the number of random numbers to be printed
; RETURNS: an array full of 'request' random numbers in the range 100 to 999
; REGISTERS CHANGED: none
fillArray PROC
	pushad
	push ebp
	mov ebp, esp
	mov edi, [ebp + 12] ;address of array in edi (points to beginning of array)
	mov ecx, [ebp + 8] ;number of elements in ecx
	call Randomize ;initialize random number generator

Loop1:
	;move (hi - lo = 1) into eax, for random range call
	mov eax, HI
	sub eax, LO
	inc eax 
	call RandomRange
	add eax, LO
	;move the random integer into the array element, and increment edi
	mov [edi], eax
	add edi, 4
	loop Loop1
	
	pop ebp
	popad
	RET 8
fillArray ENDP

; DESCRIPTION: Sorts the list using a Selection Sort
; PARAMETERS:'array' location and 'requeset' value pushed to the stack (in that order)
; PRE-CONDITIONS: array has request elements in the array
; RETURNS: none
; REGISTERS CHANGED: none
sortList PROC
	pushad
	push ebp
	mov ebp, esp
	mov edi, [ebp + 12] ;memory address of first array element
	mov eax, [ebp + 8] ;number of elements

	popad
	RET 8
sortList ENDP

; DESCRIPTION: 
; PARAMETERS:
; PRE-CONDITIONS:
; RETURNS: 
; REGISTERS CHANGED:
exchangeElements PROC
	
	RET
exchangeElements ENDP

; DESCRIPTION: Displays the median of a list of sorted values
; PARAMETERS: 'array' location and 'requeset' value pushed to the stack (in that order)
; PRE-CONDITIONS: the array must be sorted
; RETURNS: none
; REGISTERS CHANGED: none
displayMedian PROC
	pushad
	push ebp
	mov ebp, esp
	mov edi, [ebp + 12] ;memory address of first array element
	mov eax, [ebp + 8] ;number of elements

	mov edx, OFFSET medianText
	call WriteString
	
	cdq ;sign extend eax to divide
	mov ebx, 2
	div ebx
	cmp edx, 0
	je even1 ; if even, skip to that section
	; else, odd, print array at half (eax)
	mov ebx, [edi+eax]
	mov eax, ebx
	call WriteDec
	call CrLf
	jmp end1

even1:
	mov ebx, [edi+eax] ; ebx = array @eax (half of 
	mov ecx, ebx 
	sub ecx, 4 ; ecx = array @eax - 1
	add ebx, ecx ;add together, then divide by 2 to average
	mov eax, ebx
	mov ebx, 2
	div ebx
	call WriteDec
	call CrLf

end1:
	pop ebp
	popad
	RET 8
displayMedian ENDP

; DESCRIPTION: prints the array to the screen in rows of 10
; PARAMETERS: 'array' location and 'requeset' value and 'title' pushed to the stack (in that order)
; PRE-CONDITIONS: array has request values in it
; RETURNS: none
; REGISTERS CHANGED: none
displayList PROC
	pushad
	push ebp
	mov ebp, esp
	mov edi, [ebp+16] ;move array start to edi
	mov ecx, [ebp+12] ;move request to ecx
	mov edx, [ebp+8] ; move offset of title to edx
	mov newLnCt, 1
	;print title
	call WriteString
	call CrLf

print1:
	mov eax, [edi]
	call WriteDec ;print current element
	mov edx, OFFSET space
	call WriteString ;print space between elements
	;increment new line counter, if 10, jump to newline, otherwise, jump to the end of the segment
	inc newLnCt
	cmp newLnCt, 10
	jne skip
	call crlf
skip:
	;increment edi
	add edi, 4;
	loop print1

	pop ebp
	popad
	RET 8
displayList ENDP

END main
