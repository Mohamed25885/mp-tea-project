enc_text:			; encoding routine if text is provided
	push dword [ebp + 16]			; base address of string
	call stringlen
	pop ecx
	push dword [ebp + 16]
	push eax
	call encodefunc
	add esp, 12

	mov [out_info], eax
	mov [count], ebx


	cmp dword [ebp + 20], 0
	je _print_output_to_screen_enc_text

	push out_param
	push dword [param_len]
	push dword [ebp + 20]
	call stringcmp
	cmp eax, 0			; checking if text param is provided
	je _pipe_output_enc_text

	_print_output_to_screen_enc_text:
	mov eax, [out_info]
	mov ebx, [count]
	
	push ebx
	push eax
	call print
	jmp _return_file_enc_text_fun
     ; close the file
    _pipe_output_enc_text:
		
		call _print_in_file
		

	_return_file_enc_text_fun:
	call exit
	ret


encodefunc:
	push ebp
	mov ebp, esp
	sub esp, 8		
	mov eax, [ebp + 8]	
	xor edx, edx
	mov ecx, 3
	div ecx			
	mov ebx, 3
	sub ebx, edx		
	cmp ebx, 3
	jne there		
	xor ebx, ebx
there:
	mov [ebp - 4], ebx		
	mov eax, [ebp + 8]
	add eax, [ebp - 4]		
	xor edx, edx
	div ecx				
	inc ecx				
	mul ecx
	cmp edx, 0
	jne stop
	add eax, 1			
	mov [ebp - 8], eax		
	push eax
	call allocate_mem		
	pop ecx
	mov esi, [ebp + 12]		
	mov edi, [mem_start]	

encode_loop:
	cmp dword [ebp + 8], 0		
	je padding_result			
	xor eax, eax
	mov ah, byte [esi]		
	inc esi
	shl eax, 8			
	mov ah, byte [esi]		
	mov al, byte [esi + 1]		
	add esi, 2
	mov ebx, eax			
	mov ecx, eax
	mov edx, eax
	shr eax, 18			
	shr ebx, 12			
	shr ecx, 6
	and eax, 63			
	and ebx, 63
	and ecx, 63
	and edx, 63			
	add eax, b64_chars		
	mov al , byte [eax]
	mov byte [edi], al
	inc edi
	mov eax, ebx
	add ebx, b64_chars		
	mov bl, byte [ebx]
	mov byte [edi], bl
	inc edi
	cmp dword [ebp + 8], 1		
	je padding_result
	add ecx, b64_chars		
	mov cl, byte [ecx]
	mov byte [edi], cl
	inc edi
	cmp dword [ebp + 8], 2		
	je padding_result
	add edx, b64_chars		
	mov dl, byte [edx]
	mov byte [edi], dl
	inc edi
	sub dword [ebp + 8], 3		
	jmp encode_loop			

padding_result:
	cmp dword [ebp - 4], 0
	je encoded
	mov byte [edi], '='		
	inc edi
	dec dword [ebp - 4]
	jmp padding_result

encoded:
	mov byte [edi], 0Ah
	mov eax, dword [mem_start]	
	mov ebx ,dword [ebp - 8]	
	leave
	ret



