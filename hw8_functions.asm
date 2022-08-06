;; function printArray
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment .data
	comma	db	", ", 0

segment .text

printArray:
	enter	0, 0
	push	ecx						; save ecx
	push	esi						; save esi	

	mov	esi, [ebp+8]					; esi = A
	mov	ecx, [ebp+12]					; ecx = n
	sub	ecx, 1						; ecx = n - 1

printnums:
	mov	eax, [esi]					; eax = value at esi
	call	print_int					; print int
	add	esi, 4						; esi += 4
	mov	eax, comma
	call	print_string					; print ,
	loop	printnums

	mov	eax, [esi]
	call	print_int					; print last int
	call	print_nl

	pop	esi						; restore esi
	pop	ecx						; restore ecx
	leave
	ret		


;; function transformedSum
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment .data

segment .text

transformedSum:
	enter	0, 0
	push	ecx						; save ecx
	push	edx						; save edx
	push	esi						; save esi

	xor	edx, edx					; edx = sum 0
	mov	esi, [ebp+8]					; esi = A
	mov	ecx, [ebp+12]					; ecx = n

sum:
	push	dword	[esi]					; push A[i] on the stack
	call	[ebp+16]					; call func
	add	esp, 4						; remove A[i] on the stack
	add	edx, eax					; edx += ret val
	add	esi, 4						; esi += 4
	loop	sum

	mov	eax, edx					; eax = sum

	pop	esi						; restore esi
	pop	edx						; restore edx
	pop	ecx						; restore ecx
	leave
	ret	



;; function transformValue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment .data

segment .text

transformValue:
	enter	0, 0
	push	esi						; save esi

	mov	esi, [ebp+8]					; esi = A
	push	dword	[esi]					; push *A on the stack
	call	[ebp+12]					; call func
	add	esp, 4						; remove *A on the stack
	mov	[esi], eax					; value at A = ret val

	pop	esi						; restore esi
	leave
	ret	
