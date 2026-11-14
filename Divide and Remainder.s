.intel_syntax noprefix
.global itoa
itoa:
	mov rax, rdi
	mov rcx, 10
	
	xor edx, edx
	div rcx

	add rax, 0x30
	mov [rsi], rax
	
	add rdx, 0x30
	mov [rsi + 1], rdx

	mov rax, 2
	ret
