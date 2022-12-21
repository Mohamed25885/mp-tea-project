

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
