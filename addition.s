.intel_syntax noprefix
.global _start

_start:
    mov r12, [rsp] # argc
    lea rbx, [rsp + 16]

    xor r14d, r14d # Sum_result

    mov r14, [rbx + 8]
    cmp BYTE PTR [r14], '+' 
    jne exit

    xor r14d, r14d

sum:
    mov rdi, [rbx]
    call atoi

    add r14, rax

    mov rdi, [rbx + 16]
    call atoi
    
    add r14, rax

convert_total:
    sub rsp, 32

    # itoa(number, buffer)
    mov rdi, r14
    mov rsi, rsp
    call itoa

    mov rdx, rax

    # write(1, buffer, length)
    mov eax, 1
    mov edi, 1
    mov rsi, rsp
    syscall

    # exit(0)
    mov eax, 60
    xor edi, edi
    syscall


exit:
    mov rdi, 1
    mov rax, 60
    syscall

atoi:
    xor eax, eax        
    xor r8d, r8d       

    cmp byte ptr [rdi], '-'
    jne atoi_loop

    mov r8d, 1
    inc rdi

atoi_loop:
    movzx edx, byte ptr [rdi]

    test dl, dl
    jz atoi_done

    sub edx, '0'

    # total = total * 10 + digit
    imul rax, rax, 10
    add rax, rdx

    inc rdi
    jmp atoi_loop

atoi_done:
    test r8d, r8d
    jz atoi_return

    neg rax

atoi_return:
    ret



itoa:
    xor r8d, r8d        
    xor r9d, r9d        
    mov rax, rdi
    mov ecx, 10

    test rax, rax
    jns itoa_divide

    mov byte ptr [rsi], '-'
    inc rsi
    mov r8d, 1
    neg rax

itoa_divide:
    xor edx, edx
    div rcx

    push rdx
    inc r9

    test rax, rax
    jnz itoa_divide

    xor eax, eax

itoa_write:
    pop rdx
    add dl, '0'
    mov byte ptr [rsi + rax], dl

    inc rax
    cmp rax, r9
    jb itoa_write

    add rax, r8
    ret