TITLE Program Template     (template.asm)

; Author: Caitlin Berger
; CS 271 Program 02              Date: 10/09/2016
; Description: Asks for user's name, and number of Fibonacci terms to 
;	be displayed. Validates input, then prints n numbers of Fibonaccci 
;	numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)
STRING_SIZE = 42
LOWER_LIMIT = 1
UPPER_LIMIT = 46

.data

line1	BYTE	"Fionacci Numers", 13, 10, "Programmed by Caitlin Berger", 0
prompt1 BYTE	"What's your name? ", 0
line2	BYTE	"Hello, ", 0
line3	BYTE	"Enter the number of Fibonacci terms to be displayed", 13, 10, 
					"Give the number of an integer between 1 and 46", 0
prompt2	BYTE	"How many Fibonacci terms do you want? ", 0
error1	BYTE	"Out of range. Enter an integer between 1 and 46", 0
spaces	BYTE	"      ", 0
line4a	BYTE	"See you next time, ", 0
line4b	BYTE	"!!", 13, 10, 0

input1	BYTE	STRING_SIZE dup(0)
n		DWORD	?
prev	DWORD	?
count	DWORD	?


.code
main PROC

; PROGRAM INTRODUCTION
mov edx, OFFSET line1
call WriteString
call crlf
call crlf

; USER INPUT NAME
mov edx, OFFSET prompt1
call WriteString

mov edx, OFFSET input1
mov ecx, STRING_SIZE
call ReadString

; GREET USER
mov edx, OFFSET line2
call WriteString

mov edx, OFFSET input1
call WriteString
call crlf

; DISPLAY INSTRUCTIONS
mov edx, OFFSET line3
call WriteString
call crlf

; USER INPUT NUMBER OF FIBONACCI NUMBERS TO DISPLAY
getInput:

mov edx, OFFSET prompt2 ;display prompt
call WriteString

call ReadInt ;get user input


; VALIDATE USER INPUT
cmp eax, LOWER_LIMIT ;if input is less than 1 or greater than 46, jump to inupt error
jl inputError
cmp eax, UPPER_LIMIT
jg inputError
jmp endError ;otherwise, move past this block, and store user input

inputError:
call crlf
mov edx, OFFSET error1 ;print error message
call WriteString
call crlf
;jump to user input section again
jmp getInput

endError:
mov n, eax ;otherwise, input is valid, store in n

; LOOP WHICH PRINTS n TERMS OF FIBONACCI SEQUENCE
mov eax, 1 ;initialize Fibonacci sequence and counter variable
mov prev, 0
mov ecx, n
dec ecx

call crlf
call WriteDec ;print first number
mov edx, OFFSET spaces
call WriteString
mov prev, 0
mov count, 2 ;initialize count for newline


LoopA:

;calculate new fibonacci number
mov ebx, prev ;move previous number into ebx
mov prev, eax ;increment previous to the next number
add eax, ebx ;add eax and ebx to calculate new number

;print new fibonacci number, and spaces
call WriteDec
call WriteString

;if it's the fifth #, print a newline
cmp count, 5
je NewLine ;if count = 5, print a new line and reset count to 1
inc count ;else, increment by 1
jmp endNewLine

NewLine:
call crlf
mov count, 1

endNewLine:

;loop (decrement ecx, go back to LoopA while ecx != 0)
loop LoopA

; PRINT EXIT MESSAGE
call crlf
call crlf
mov edx, OFFSET line4a
call WriteString
mov edx, OFFSET input1
call WriteString
mov edx, OFFSET line4b
call WriteString

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
