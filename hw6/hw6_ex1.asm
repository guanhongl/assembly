%include "asm_io.inc"

segment .data	
	msg1	db      "Enter an integer: ", 0
	msg2    db      "Binary representation: ", 0
    	msg3    db      "Semantic: ", 0
    	msg4    db      "YNGR/IPHN/HULU/SWRS count: ", 0
    	msg5    db      "*/ANDR/*/STRK count: ", 0
    	codes   db      "YNGR", 0, "OLDR", 0, "ANDR", 0, "IPHN", 0, "NFLX", 0, "HULU", 0, "SWRS", 0, "STRK", 0
    	four_spaces db  "    ",0

segment .bss
	input	resd  1     ; only 4 bytes! 

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha

	; Q1 binary conversion

	mov	eax, msg1
	call	print_string		; print msg1
	call	read_int		; get 32-bit integer
	mov	[input], eax		; input value = integer
	mov	eax, msg2
	call	print_string		; print msg2

	mov	ecx, 32			; ecx = loop index
	mov	ebx, [input]		; ebx = input value
	mov	dl, 0			; dl = 0
to_binary:
	xor	eax, eax		; clear eax
	rol	ebx, 1			; shift left
	adc	eax, 0			; add the carry to eax
	call	print_int		; print binary digit
	inc	dl			; dl++
	cmp	dl, 4
	jnz	no_space		; jump if dl != 4
	mov	al, 32			; al = " "
	call	print_char		; print " "
	sub	dl, 4			; dl = 0
no_space:
	loop	to_binary
	call	print_nl

	; Q2 semantic

	mov	eax, msg3
	call	print_string		; print msg3

	mov	ecx, 32			; ecx = 32
	mov	dl, 0			; dl = 0
semantic:
	cmp	dl, 0
	jnz	semantic_same		; jump if dl != 0
	call	print_nl
	mov	eax, four_spaces
	call	print_string		; print "    "
	mov	esi, codes		; esi = codes
	add	dl, 4			; dl += 4
semantic_same:
	rol	ebx, 1			; shift left
	jc	else			; jump if CF == 1
	mov	eax, esi		; eax = esi
	call	print_string		; print code
	add	esi, 10			; esi += 10
	jmp	end_if
else:
	add	esi, 5			; esi += 5
	mov	eax, esi		; eax = esi
	call	print_string		; print code
	add	esi, 5			; esi += 5
end_if:
	mov	eax, 32			; eax = " "
	call	print_char		; print " "
	dec	dl			; dl--
	loop	semantic
	call	print_nl

	; Q3

	mov	ecx, 32			; ecx = the loop index
	mov	dl, 0			; dl = 0
	mov	dh, 0			; dh = 0
	xor	ebx, ebx		; ebx = 0 = counter
	mov	esi, [input]		; esi = value at input
	xor	esi, 066666666h		; XOR esi w/ 0110 0110 ... 0110
					; 0110 --> 0000 = match
particular:
	rol	esi, 1			; shift left
	adc	dh, 0			; dh += CF
	inc	dl			; dl++
	cmp	dl, 4
	jnz	particular_same		; jump if dl != 4
	cmp	dh, 0
	jnz	no_match		; jump if dh != 0
	inc	bl			; bl++	
no_match:
	xor	dh, dh			; dh = 0
	xor	dl, dl			; dl = 0
particular_same:
	loop	particular
	mov	eax, msg4
	call	print_string		; print msg4
	mov	eax, ebx		; eax = ebx
	call	print_int		; print bl
	call	print_nl

	; Q4

	mov	ecx, 32			; ecx = loop index
	mov	dl, 0			; dl = 0
	mov	dh, 0			; dh = 0
	xor	ebx, ebx		; ebx = 0 the counter
	mov	esi, [input]		; esi = value at input
	and	esi, 055555555h		; turn off 1 and 3 bits
	xor	esi, 011111111h		; 0001 --> 0000 = match
less_specific:
	rol	esi, 1			; shift left
	adc	dh, 0			; dh += CF
	inc	dl			; dl++
	cmp	dl, 4
	jnz	less_same		; jump if dl != 4
	cmp	dh, 0
	jnz	less_no_match		; jump if dh != 0
	inc	bl			; bl++
less_no_match:
	xor	dh, dh			; dh = 0
	xor	dl, dl			; dl = 0
less_same:
	loop less_specific
	mov	eax, msg5
	call	print_string		; print msg5
	mov	eax, ebx
	call	print_int		; print bl
	call	print_nl

	popa
	mov	eax, 0
	leave
	ret
