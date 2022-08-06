%include "asm_io.inc"

segment .data	
	msg1	db	"Enter a character: ", 0
	msg2	db	"Enter an integer: ", 0
	msg3	db	"The transformed number is: '", 0
	msg4	db	"'", 0
	mask	dd	0FFFFFFFFh	; mask

segment .bss
	char		resd	1	; char from user
	integer		resd	1	; integer from user
	result		resd	1

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha
	mov	eax, msg1
	call 	print_string		; print msg1
	call 	read_char		; get char from user
	mov 	[char], eax		; store it in memory
	mov 	eax, msg2
	call	print_string		; print msg2
	call 	read_int		; get integer from user
	mov 	[integer], eax		; store it in memory
	mov 	eax, [integer]		; eax = integer
	sub 	eax, [char]		; eax = integer - char
	mov 	[result], eax		; store it in memory
	mov 	eax, msg3
	call 	print_string		; print msg3
	mov 	eax, [mask]		; eax = FF FF FF FF
	sub	eax, [result]		; eax = FF FF FF FF - result
	inc	eax			; eax = result + 1
	call	print_int		; print result
	mov	eax, msg4
	call	print_string		; print msg4
	call 	print_nl
	popa
	mov	eax, 0
	leave
	ret

