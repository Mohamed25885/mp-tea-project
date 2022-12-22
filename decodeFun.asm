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


  dec_loop:
	cmp byte [ebx], '='
	jne pad_length_found
	dec ebx
	inc ecx
	jmp dec_loop

  pad_length_found:
	mov dword [ebp - 8], ecx
	push dword [ebp - 4]
	call allocate_mem
	dec dword [ebp - 4]	
	pop ebx
	mov esi, [ebp + 12]
	mov edi, [mem_start]
	mov eax, dword [ebp -8]
	sub dword [ebp - 4], eax
	push dword [ebp-4]

	decoding_loop:
	cmp dword [esp], 0
	je decoded
	mov eax, 0
	mov ebx, eax
	mov ecx, ebx
	mov edx, ecx
	mov al, byte [esi]
	mov bl, byte [esi + 1]
	mov cl, byte [esi + 2]
	mov dl, byte [esi + 3]
	push eax
	push b64_chars
	call find_c_in_s
	add esp, 8
	push eax
	push ebx
	push b64_chars
	call find_c_in_s
	add esp, 8
	mov ebx, eax
	push ecx
	push b64_chars
	call find_c_in_s
	add esp, 8
	mov ecx, eax
	push edx
	push b64_chars
	call find_c_in_s
	add esp, 8
	mov edx, eax
	pop eax
	shl eax, 18
	shl ebx, 12
	shl ecx, 6
	or eax, ebx
	or eax, ecx
	or eax, edx
	mov ebx, eax
	shr ebx, 16
	mov byte [edi], bl
	inc edi
	dec dword [esp]
	cmp dword [esp], 0
	je decoded
	mov byte [edi], ah
	inc edi
	dec dword [esp]
	cmp dword [esp], 0
	je decoded
	mov byte [edi], al
	inc edi
	dec dword [esp]
	add esi, 4
	jmp decoding_loop
    
decoded:
	pop ebx
	inc dword [ebp - 4]
	mov byte [edi], 0Ah
	mov ebx, dword [ebp - 4]
	mov eax, dword [mem_start]
	leave
	ret