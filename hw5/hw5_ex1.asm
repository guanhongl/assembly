%include "asm_io.inc"

segment .data	
	msg		db	"Enter a string written in some language: ", 0
	counters	times 26 dd	0	; array of 26 counters
	result		times 183 db	0	; result string
	english		db	"etaoinshrdlcumwfgypbvkjxqz"
	score		db	0		; english score
	continue	db	1		; continue = true
	msg2		db	"The English-ness score is: ", 0

segment .bss
	index		resb		1	; index

segment .text
	global asm_main
asm_main:
	enter	0,0
	pusha	
	;code here
	mov	eax, msg
	call	print_string			; print msg
while_input:					; while loop to get input
	call	read_char			; get a char
	cmp	eax, 10
	jz	end_while_input			; end while loop if char == newline
	cmp	eax, 97
	jae	else				; jump to else if char >= 'a'
	add	eax, 32				; capital to lowercase
else:
	cmp	eax, 97
	jb	while_input			; jump to loop start if char < 'a'
	cmp	eax, 122
	ja	while_input			; jump to loop start if char > 'z'
	sub	eax, 97				; eax = eax - 97
	shl	eax, 2				; eax = eax * 4 = the index
	mov	ebx, counters			; ebx = pointer to counters
	add	ebx, eax			; ebx = pointer to (counters + eax)
	mov	eax, [ebx]			; eax = value at (counters + eax)
	inc	eax				; eax ++
	mov	[ebx], eax			; increment value at counter
	jmp 	while_input
end_while_input:
	call	print_nl
	mov	cl, 97				; cl = 'a' = the loop index
	mov	ebx, counters			; ebx = pointer to counters
for_counts:					; for loop to print counts
	cmp	cl, 122
	ja	end_for_counts			; end for loop if char > 'z'
	mov	al, cl
	call	print_char			; print char at cl
	mov	al, 58
	call	print_char			; print ':'
	mov	eax, [ebx]
	call	print_int			; print value at counter
	add	ebx, 4				; increment counter
	mov	al, 32
	call	print_char			; print ' '
	inc	cl				; cl ++
	jmp	for_counts
end_for_counts:
	call	print_nl
	mov	ecx, 0				; ecx = 0 = outer loop index
for_sort:					; for loop to print sorted occurrences
	cmp	ecx, 25
	ja	end_for_sort			; end for loop if ecx > 25
	mov	ebx, counters			; ebx = pointer to counters
	mov	dl, 0				; dl = 0 = inner loop index
	mov	eax, 0FFFFFFFFh			; eax = -1 = max
find_max:					; for loop to find max
	cmp	dl, 100
	ja	find_max_end			; end for loop if dl > 100
	cmp	eax, [ebx]
	jge	not_max				; jump if eax >= max
	mov	eax, [ebx]			; eax = value at ebx
	mov	[index], dl			; index of max = dl
not_max:
	add	dl, 4				; increment dl
	add	ebx, 4				; increment ebx
	jmp	find_max
find_max_end:
	mov	ebx, counters			; ebx = pointer to counters
	add	ebx, [index]			; ebx = ebx + index
	mov	dword [ebx], 0FFFFFFFFh		; set value at index of max = -1
	xor	eax, eax			; eax = 0
	mov	al, [index]			; eax = index of max
	shr	eax, 2				; eax = eax / 4
	add	eax, 97				; al = letter
	call	print_char			; print letter
	mov	bl, [continue]
	cmp	bl, 1
	jnz	prefix_done			; jump if continue != 1
	mov	ebx, english			; ebx = pointer to english
	add	ebx, ecx			; ebx = pointer to ith letter
	cmp	[ebx], al
	jnz	no_add				; jump if value at ebx != al
	mov	dl, [score]
	inc	dl
	mov	[score], dl			; score ++
	jmp	prefix_done
no_add:
	mov	dl, [continue]
	xor	dl, dl
	mov	[continue], dl			; set continue = 0 = false
prefix_done:
	inc	ecx				; ecx ++
	jmp	for_sort
end_for_sort:
	call	print_nl
	mov	eax, msg2
	call	print_string			; print msg2
	xor	eax, eax			; eax = 0
	mov	al, [score]			; al = value at score
	call	print_int			; print the english score
	call	print_nl
	;code here
	popa
	mov	eax, 0
	leave
	ret

