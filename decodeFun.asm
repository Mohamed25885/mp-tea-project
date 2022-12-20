SECTION .data


SECTION .text

global _start

_start:

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

exit:
	mov ebx, 0
	mov eax, 1
	int 80h		; exit syscall
	ret
