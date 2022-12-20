

_countFileChars:
    push r10
    push r9

    xor r10, r10
    mov rax, qword[file_descriptor]


    _while_countFileChars:
        mov r9, rax
        mov rdi, rax ;copying fd (assuming it's opened) to rdi
        mov rsi, text_buffer
        mov rdx, 0x1 ; count
        xor rax, rax ;sys_read(rax, *buffer, count)
        syscall

        cmp  rax, 1
        jl _endWhile_countFileChars
        inc r10 

        mov rax, r9
        jmp _while_countFileChars

    _endWhile_countFileChars:
    

   mov qword[text_total], r10

    pop r9
    pop r10
    ret
   
   
_openFile:
    ; open the file
    mov rax, 2 ;sys_open(file_name, flags, mode)
    mov rdi, filename
    mov rsi, 2 ;O_APPEND
    mov rdx, 0666 ; rw-r--r--
    syscall
    mov qword[file_descriptor], rax
    cmp qword[file_descriptor], 0
    jne _return_openFile 
    exit 1
    _return_openFile:
    ret

_closeFile:
    ; close file
    mov rax, 3 ;sys_close(fd)
    mov rdi, qword[file_descriptor]
    syscall
    ret


_readFromToPosFile:
    push r11
    mov r11, qword[text_count]
    sub r11, qword[text_offset] ;char count = text_count - text_offset
    
    mov rdi, qword[file_descriptor] ;file_descriptor
    mov rsi, text_buffer
    mov rdx, r11 ; count
    mov r10, qword[text_offset] ;offset
    mov rax, 17 ;sys_pread64(fd, *buffer, count,offset)
    syscall
    pop r11
    ret

_writeFromToPosFile:
    push r11
    mov r11, qword[text_count]
    sub r11, qword[text_offset] ;char count = text_count - text_offset
    
    mov rdi, qword[file_descriptor] ;file_descriptor
    mov rsi, text_buffer
    mov rdx, r11 ; count
    mov r10, qword[text_offset] ;offset
    mov rax, 18 ;sys_pread64(fd, *buffer, count,offset)
    syscall
    pop r11
    ret