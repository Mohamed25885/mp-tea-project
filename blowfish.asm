%include 'macros.inc'

global _start
section .data
    filename:  db  './dummy.bin',0
    msg:  db  ' ',10,0

section .bss
    text_buffer: resb 9
    text_count: resq 1
    file_descriptor: resq 1
section .text

_start:
    call _openFile
    call _countFileChars
    
    
    call _closeFile
    exit 0

%include 'file_handler.asm'