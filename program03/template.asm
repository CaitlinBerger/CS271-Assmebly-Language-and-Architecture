TITLE ASsignemnt 03     (template.asm)

; Author: Caitlin Berger
; CS 271 Assignment 03                 Date: 10/16/2016
; Description: Prompts user to repeatedly enter negative numbers, then displays
;	how many numbers are entered, the sum of the numbers, and the rounded average

INCLUDE Irvine32.inc

LOWER_LIMIT = -100
UPPER_LIMIT = -1
STRING_SIZE = 42

.data

; string variables
line1	BYTE	"Integer Accumulator by Caitlin Berger", 0
prompt1	BYTE	"What is your name? ", 0
line2	BYTE	"Hello, ", 0
line3	BYTE	"Please enter numbers in the range [-100, -1].", 13, 10,
				"Enter a non-negative number when you are finished to see results.", 0
prompt2	BYTE	"Enter a number: ", 0
line4a	BYTE	"You have entered ", 0
line4b	BYTE	" valid numbers.", 0
line5	BYTE	"The sum of you valid numbers is ", 0
line6	BYTE	"The rounded average is ", 0
line7a	BYTE	"Thank you for playing Integer Accumulator! See you next time, ", 0
line7b	BYTE	"!!", 0
error1	BYTE	"You have entered no valid numbers!", 0

;user input variables
name1	BYTE	STRING_SIZE dup(0)

;calculated variables
count	DWORD	?
sum1	SDWORD	?
avg1	SDWORD	?


.code
main PROC

; INTRODUCTION
mov edx, OFFSET line1
call WriteString
call crlf
call crlf

; GET USER NAME
mov edx, OFFSET prompt1 ;print prompt
call WriteString

mov edx, OFFSET name1 ;get input
mov ecX, STRING_SIZE
call ReadString

mov edx, OFFSET line2 ;greet user
call WriteString
mov edx, OFFSET name1
call WriteString
call crlf
call crlf

; DISPLAY INSTRUCTIONS
mov edx, OFFSET line3
call WriteString
call crlf

; REPEATED LOOP TO ENTER NEGATIVE NUMBERS:  repeats while user input is in range
mov sum1, 0 ;inialize sum
mov count, 0 ;initialize count
Loop1:
mov edx, OFFSET prompt2 ;prompt user input
call WriteString
call ReadInt ;user input number

; CHECK IF INPUT IS IN RANGE:  if not, end the loop
cmp eax, LOWER_LIMIT ;check lower limit
jl endLoop
cmp eax, UPPER_LIMIT ;check upper limit
jg endLoop
; if it is, add to the sum, increase count, and repeat the loop 
mov ebx, sum1
add ebx, eax
mov sum1, ebx
inc count

jmp Loop1

endLoop:


; CALCULATE AVERAGE
cmp count, 0; if the count is 0, skip this section
je end1

mov eax, sum1 ; move sum into eax, and sign extend to a qword
cdq
mov ebx, count
idiv ebx
mov avg1, eax

end1:

; PRINT RESULTS
; display the number of negative numbers entered
mov eax, count ;check if count is 0
cmp eax, 0
je count0

mov edx, OFFSET line4a
call WriteString
call WriteDec
mov edx, OFFSET line4b
call WriteString
call crlf

jmp end2
count0: ;if there are 0, tell them and jump to parting message
mov edx, OFFSET error1
call WriteString
call crlf
jmp parting

end2:
; display the sum
mov edx, OFFSET line5
call WriteString
mov eax, sum1
call WriteInt
call crlf

; display the average (rounded)
mov edx, OFFSET line6
call WriteString
mov eax, avg1
call WriteInt
call crlf

; PARTING MESSAGE
parting:
mov edx, OFFSET line7a
call WriteString
mov edx, OFFSET name1
call WriteString
mov edx, OFFSET line7b
call WriteString
call crlf
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
