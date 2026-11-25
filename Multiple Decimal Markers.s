.intel_syntax noprefix
.global _start

_start:
    mov r12, [rsp + 16]
    lea r13, [rsp + 24]
    mov r14, [rsp]


String_loop:
    cmp BYTE PTR [r12], 0x5c
    je Escapes

    cmp BYTE PTR [r12], 0x25
    je Specification

    cmp BYTE PTR [r12], 0
    je exit

    mov rdi, r12
    call write
    add r12, 1

    jmp String_loop

Escapes:
    cmp BYTE PTR [r12 + 1], 'n'
    je Newline

    cmp BYTE PTR [r12 + 1], 0x5c
    je Backslash

    jmp exit

Specification:
    cmp BYTE PTR [r12 + 1], 0x25
    je Percent

    cmp BYTE PTR [r12 + 1], 'd'
    je Decimal

    jmp exit

Decimal:
    cmp r14, 2
    jle String_loop
    add r12, 2

    mov rdi, [r13] 
    call atoi

    sub rsp, 32

    mov rdi, rax
    mov rsi, rsp
    call itoa

    mov rdx, rax
    mov rsi, rsp
    mov edi, 1
    mov eax, 1
    syscall

    add rsp, 32

    add r13, 8
    dec r14

    jmp String_loop

Newline:
    add r12, 2
    sub rsp, 1

    mov BYTE PTR [rsp], 0x0a
    mov rdi, rsp
    call write
    add rsp, 1

    jmp String_loop

Backslash:
    add r12, 2
    sub rsp, 1

    mov BYTE PTR [rsp], 0x5c
    mov rdi, rsp
    call write
    add rsp, 1

    jmp String_loop

Percent:
    add r12, 2
    dec rsp

    mov BYTE PTR [rsp], 0x25
    mov rdi, rsp
    call write
    inc rsp

    jmp String_loop

# atoi(string)
atoi:
    xor eax, eax
    xor ecx, ecx

    cmp BYTE PTR [rdi], '-'
    jne atoi_plus

    mov ecx, 1
    inc rdi
    jmp atoi_loop

atoi_plus:
    cmp BYTE PTR [rdi], '+'
    jne atoi_loop
    inc rdi

atoi_loop:
    movzx edx, BYTE PTR [rdi]

    cmp edx, '0'
    jb atoi_done

    cmp edx, '9'
    ja atoi_done

    sub edx, '0'
    imul rax, rax, 10
    add rax, rdx

    inc rdi
    jmp atoi_loop

atoi_done:
    test ecx, ecx
    jz atoi_return

    neg rax

atoi_return:
    ret

# itoa(number, buffer)
itoa:
    mov rax, rdi
    xor r8d, r8d
    xor r9d, r9d

    test rax, rax
    jns itoa_convert

    mov BYTE PTR [rsi], '-'
    inc rsi
    inc r9
    neg rax

itoa_convert:
    mov ecx, 10

itoa_divide:
    xor edx, edx
    div rcx

    add dl, '0'
    push rdx
    inc r8

    test rax, rax
    jnz itoa_divide

itoa_reverse:
    pop rdx
    mov BYTE PTR [rsi], dl

    inc rsi
    inc r9
    dec r8

    jnz itoa_reverse

    mov BYTE PTR [rsi], 0
    mov rax, r9
    ret

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