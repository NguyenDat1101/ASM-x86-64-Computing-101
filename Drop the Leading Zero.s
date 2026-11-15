.intel_syntax noprefix
.global itoa
itoa:
	mov rax, rdi
	mov rcx, 10
	
	xor edx, edx
	div rcx
	cmp rax, 0
	je return

	add rax, 0x30
	mov [rsi], al
	
	add rdx, 0x30	
	mov [rsi + 1], dl

	mov rax, 2
	ret
return:
	add rdx, 0x30
	mov [rsi], dl
	mov rax, 1
	ret
