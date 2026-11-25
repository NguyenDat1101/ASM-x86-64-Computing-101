.intel_syntax noprefix
.global _start

_start:
    mov r12, [rsp + 16]
    xor edi, edi

String_loop:
    cmp BYTE PTR [r12], 0x5c
    je Escapes

    cmp BYTE PTR [r12], 0
    je exit

    mov rdi, r12
    call write
    add r12, 1

    jmp String_loop

Escapes:
    cmp BYTE PTR [r12 + 1], 'n'
    je Newline
    jne String_loop

Newline:
    add r12, 2
    sub rsp, 1

    mov BYTE PTR [rsp], 0x0a
    mov rdi, rsp
    call write
    add rsp, 1

    jmp String_loop

write: # write(buffer)
    mov eax, 1
    mov rsi, rdi
    mov edi, 1
    mov edx, 1
    syscall

    ret

exit:
    mov edi, 0
    mov eax, 60
    syscall