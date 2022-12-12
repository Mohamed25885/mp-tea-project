
;input fileName in r10
;return r11 count
_countFileChars:
    push r10
    push r9

    ; open the file
    mov rax, 2 ;sys_open(file_name, flags, mode)
    mov rdi, r10
    mov rsi, 0x400 ;O_APPEND
    mov rdx, 0644 ; rw-r--r--
    syscall

    cmp rax, 0
    jne continue
     
    ; error fd is null
    mov rax, 60
    mov rdi, 1
    syscall


    continue:

    push rax ;to pop it later while closing the fd
    xor r10, r10

    while:
        mov r9, rax
        mov rdi, rax ;copying fd (assuming it's opened) to rdi
        mov rsi, text_buffer
        mov rdx, 0x1 ; count
        xor rax, rax ;sys_read(rax, *buffer, count)
        syscall

        cmp  rax, 1
        jl endWhile
        inc r10 

        mov rax, r9
        jmp while

    endWhile:
    
    ; close file
    mov rax, 3
    pop rdi
    syscall


    mov r11, r10

    pop r9
    pop r10
    ret
   
   
