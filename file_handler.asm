
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
    mov ecx, info ;buffer pointer
    mov edx, 0xfff ;buffer length
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
	call decodeFun
	add esp, 8
	mov [out_info], eax
	mov [count], ebx


	cmp dword [ebp + 20], 0
	je _print_output_dec_to_screen

	push out_param
	push dword [param_len]
	push dword [ebp + 20]
	call stringcmp
	cmp eax, 0			; checking if text param is provided
	je _pipe_output_dec

	_print_output_dec_to_screen:
	mov eax, [out_info]
	mov ebx, [count]
	
	push ebx
	push eax
	call print
	jmp _return_file_dec_text
     ; close the file
    _pipe_output_dec:
		
		call _print_in_file
		

	_return_file_dec_text:
	call exit
	ret


file_enc_text:

    call _open_and_read_file
    push info  
    call stringlen
	pop ecx
	push info
	push eax
	call encodefunc
	add esp, 12

	
	mov [out_info], eax
	mov [count], ebx


	cmp dword [ebp + 20], 0
	je _print_output_to_screen_enc

	push out_param
	push dword [param_len]
	push dword [ebp + 20]
	call stringcmp
	cmp eax, 0			; checking if text param is provided
	je _pipe_output_enc

	_print_output_to_screen_enc:
	mov eax, [out_info]
	mov ebx, [count]
	
	push ebx
	push eax
	call print
	jmp _return_file_enc_text
     ; close the file
    _pipe_output_enc:
		
		call _print_in_file
		

	_return_file_enc_text:
	call exit
	ret



_print_in_file:
	
	    ; open the file
    mov eax, 5 ;sys_open(file_name, flags, mode)
    mov ebx, dword [ebp + 24]
    mov ecx, 577             ;(O_WRONLY | O_CREAT | O_TRUNC)
    mov edx, 438          ;read, write and execute by all
    int 80h
    ;add esp, 0
	
    mov  [fd_out], eax


    mov eax, 4 ;sys_write
    mov ebx, [fd_out]
    mov ecx, [out_info]
    mov edx, [count]
    int 80h


    ret