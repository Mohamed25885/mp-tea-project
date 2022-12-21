 .data


.text

global _start

_start:


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

stop:		
	call exit
	ret

