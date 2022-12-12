%include 'macros.inc'
%include 'file_handler.asm'
global _start
section .data
    filename:  db  './dummy.bin',0
    msg:  db  ' ',10,0

section .bss
    text_buffer: resb 9
    text_count: resb 1024
section .text

_start:
    
    mov r10, filename
    call _countFileChars
    ; exit
    exit 0

