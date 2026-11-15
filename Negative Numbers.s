.intel_syntax noprefix
.global itoa
itoa:
	PUSH rbx
	PUSH r12
	mov rax, rdi
	mov r12, 0
	xor edx, edx
	xor ebx, ebx
	mov rcx, 10
	cmp rdi, 0
	jl is_negative

loop:
	div rcx
	PUSH rdx
	xor edx, edx
	inc rbx
	cmp rax, 0
	je reset
	jmp loop

is_negative:
	mov BYTE PTR [rsi], '-'
	inc rsi
	inc r12
	neg rax
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
	cmp r12, 1
	je adder
	mov rax, rbx
	POP r12
	POP rbx
	ret
	
adder:
	inc rbx
	dec r12
	jmp return
