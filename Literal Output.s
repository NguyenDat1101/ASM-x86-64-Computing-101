.intel_syntax noprefix
.global _start

_start:
    mov r12, [rsp + 16]
    xor edi, edi

String_loop:
    cmp BYTE PTR [r12], 0
    je exit

    call write
    add r12, 1

    jmp String_loop

write: # write(buffer)
    mov eax, 1
    mov rsi, r12
    mov edi, 1
    mov edx, 1
    syscall
    ret

exit:
    mov edi, 0
    mov eax, 60
    syscall