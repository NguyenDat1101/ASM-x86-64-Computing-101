.intel_syntax noprefix
.global itoa
itoa:
	PUSH rbx
	mov rax, rdi
	xor edx, edx
	xor ebx, ebx
	mov rcx, 10
	
loop:
	div rcx
	PUSH rdx
	xor edx, edx
	inc rbx

	cmp rax, 0
	je reset	
	jmp loop

reset:
	xor eax, eax

Write:
	cmp rax, rbx
	je return

	POP rdx
	add rdx, 0x30
	mov [rsi + rax], dl

	inc rax
	jmp Write

return:
	mov rax, rbx
	POP rbx
	ret
