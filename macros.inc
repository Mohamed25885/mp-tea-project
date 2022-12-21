%macro exit 1
    mov rax, 60 ;system_exit(code)
    mov rdi, %1
    syscall
%endmacro