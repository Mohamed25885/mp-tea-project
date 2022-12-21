
_open_and_read_file:
    ; open the file
    mov eax, 5 ;sys_open(file_name, flags, mode)
    mov ebx, dword [ebp + 16]
    mov ecx, 0             ;for read only access
    mov edx, 0777          ;read, write and execute by all
    int 80h
    ;add esp, 8

    mov  [fd_in], eax

    mov eax, 3
    mov ebx, [fd_in]
    mov ecx, info
    mov edx, 0xfff
    int 0x80
    ret
_closeFile:
    mov eax, 6
    mov ebx, [fd_in]
    int  0x80 
    ret

file_dec_text:

    call _open_and_read_file
    push info  
    call stringlen
	pop ecx
	push info
	push eax
	call decode_b64
	add esp, 8
	push ebx
	push eax
	call print

   call _closeFile 

	call exit
	ret