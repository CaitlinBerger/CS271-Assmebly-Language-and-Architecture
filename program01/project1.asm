TITLE Program Template     (template.asm)

; Author: Caitlin Berger
; CS 271 / Project 1              Date: 10/2/2016
; Description: User input 2 integers, calculate and print sum, difference, 
;	product, quotient and remainder

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; STRINGS TO PRINT DIRECTIONS AND RESULTS
line0		BYTE	"Elementary Arithmetic by Caitlin Berger", 0
line1		BYTE	"Enter two numbers, and this program will display the", 0
line2		BYTE	"sum, difference, product, quotient, and remainder", 0
goodbye		BYTE	"Exiting program, goodbye!", 0
num1		BYTE	"First number: ", 0
num2		BYTE	"Second number: ", 0
plus		BYTE	" + ", 0
minus		BYTE	" - ", 0
multiply	BYTE	" x ", 0
divide		BYTE	" / ", 0
rem			BYTE	" remainder ", 0
equal		BYTE	" = ", 0

; VARIABLES FOR USER INPUT
a			DWORD	?
b			DWORD	?

; VARIBLES TO STORE RESULTS
summation	DWORD	?
difference	DWORD	?
product		DWORD	?
quotient	DWORD	?
remainder	DWORD	?

.code
main PROC

	; PRINT INTRODUCTION AND DIRECTIONS
	mov		edx, OFFSET line0
	call	WriteString
	call	crlf

	mov		edx, OFFSET line1
	call	WriteString
	call	crlf

	mov		edx, OFFSET line2
	call	WriteString
	call	crlf
	call	crlf
	
	; GET DATA FROM USER
	;	prompt user for first value
	mov		edx, OFFSET num1
	call	WriteString
	;	save user input
	call	ReadInt
	mov		a, eax

	;	prompt user for second value
	mov edx, OFFSET num2
	call WriteString
	;	save user input
	call ReadInt
	mov b, eax	
	call crlf

	; CALCULATE REQUIRED VALUES
	;	calculate and store the sum
	mov eax, a
	add eax, b
	mov summation, eax

	;	calcuate and store the difference
	mov eax, a
	sub eax, b
	mov difference, eax

	;	calculate and store the product
	mov ebx, a
	mov eax, b
	mul ebx
	mov product, eax

	;	calcuate and store the quotient and remainder
	mov eax, 0 ;clear dividend registers
	mov edx, 0
	mov eax, a
	mov ebx, b
	div ebx
	mov quotient, eax ;save quotient from eax
	mov remainder, edx ;save remainder form edx


	; DISPLAY RESULTS
	;	display a + b = summation
	mov eax, 
	call WriteDec

	mov edx, OFFSET plus
	call WriteString

	mov eax, b
	call WriteDec

	mov edx, OFFSET equal
	call WriteString
	
	mov eax, summation
	call WriteDec
	call crlf
	

	;	display a - b = quotient
	mov eax, a
	call WriteDec

	mov edx, OFFSET minus
	call WriteString

	mov eax, b
	call WriteDec

	mov edx, OFFSET equal
	call WriteString
	
	mov eax, difference
	call WriteDec
	call crlf

	;	display a x b = product
	mov eax, a
	call WriteDec

	mov edx, OFFSET multiply
	call WriteString

	mov eax, b
	call WriteDec

	mov edx, OFFSET equal
	call WriteString
	
	mov eax, product
	call WriteDec
	call crlf

	;	display a / b = quotient remainder: rem
	mov eax, a
	call WriteDec

	mov edx, OFFSET divide
	call WriteString

	mov eax, b
	call WriteDec

	mov edx, OFFSET equal
	call WriteString
	
	mov eax, quotient
	call WriteDec

	mov edx, OFFSET rem
	call WriteString
	
	mov eax, remainder
	call WriteDec
	
	call crlf
	call crlf

	; DISPLAY LEAVING MESSAGE 
	mov edx, OFFSET goodbye
	call WriteString
	call crlf
	call crlf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
