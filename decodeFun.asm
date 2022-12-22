dec_text:
        push dword [ebp + 16]                   ; base address of string
        call stringlen
        pop ecx
	push dword [ebp + 16]
	push eax
	call decode_b64
	add esp, 8
	mov [out_info], eax
	mov [count], ebx


	cmp dword [ebp + 20], 0
	je _print_output_to_screen_dec_text

	push out_param
	push dword [param_len]
	push dword [ebp + 20]
	call stringcmp
	cmp eax, 0			; checking if text param is provided
	je _pipe_output_dec_text

	_print_output_to_screen_dec_text:
	mov eax, [out_info]
	mov ebx, [count]
	
	push ebx
	push eax
	call print
	jmp _return_file_dec_text_fun
     ; close the file
    _pipe_output_dec_text:
		
		call _print_in_file
		

	_return_file_dec_text_fun:
	call exit
	ret


decodeFun:

    push ebp		
	mov ebp, esp
	sub esp, 8
	mov eax, [ebp + 8]	
	xor edx, edx
	mov ecx, 4
	div ecx			
	dec ecx
	mul ecx			
	cmp edx, 0
	jne stop
	inc eax			
	mov [ebp - 4], eax	
	mov ebx, dword [ebp + 12]
	add ebx, [ebp + 8]	
	xor ecx, ecx
	dec ebx	

stop:
	call exit
	ret

