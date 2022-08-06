%include "asm_io.inc"

segment .data
	msg1	db		"Enter a 3-character lower-case string: ", 0
	msg2	db		"Enter a 4-character string: ", 0
	msg3	db		"The encoded string is: "
	result	times 11 db	0	; the result

segment .bss

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha
	mov	eax, msg1
	call 	print_string		; print msg1
	mov	ebx, result		; ebx = result
	inc	ebx			; ebx = result + 1
	call 	read_char		; get first lower-case char
	sub	eax, 32			; lowercase to uppercase
	mov	[ebx], al		; store first lower-case char once
	inc	ebx			; ebx = result + 2
	mov	[ebx], al		; store first lower-case char twice
	add	ebx, 2			; ebx = result + 4
	call 	read_char		; get second lower-case char
	sub	eax, 32			; lowercase to uppercase
	mov	[ebx], al		; store second lower-case char once
	inc	ebx			; ebx = result + 5
	mov	[ebx], al		; store second lower-case char twice
	add	ebx, 2			; ebx = result + 7
	call 	read_char		; get third lower-case char
	sub	eax, 32			; lowercase to uppercase
	mov	[ebx], al		; store third lower-case char once
	inc	ebx			; ebx = result + 8
	mov	[ebx], al		; store third lower-case char twice
	call	read_char		; get newline
	mov	eax, msg2
	call	print_string		; print msg2
	inc	ebx			; ebx = result + 9
	call	read_char		; get first char
	mov	[ebx], al		; store first char
	sub	ebx, 3			; ebx = result + 6
	call	read_char		; get second char
	mov	[ebx], al		; store second char
	sub	ebx, 3			; ebx = result + 3
	call	read_char		; get third char
	mov	[ebx], al		; store third char
	sub	ebx, 3			; ebx = result
	call	read_char		; get fourth char
	mov	[ebx], al		; store fourth char
	add	ebx, 10			; ebx = result + 10
	mov	byte [ebx], 0		; null terminate result
	call	read_char		; get newline
	mov	eax, msg3
	call	print_string		; print msg3
	call	print_nl
	popa
	mov	eax, 0
	leave
	ret

