section .bss
    fd_out resb 1
    fd_in  resb 1
    info resb  1024

SECTION .text

global _start

_start:
	mov ebp, esp
	cmp dword [ebp], 4		; checking the number of arguements passed to the application
	je args_correct
	cmp dword [ebp], 2
	je help_func

invalid:				; executed if invalid arguements are passed to the application
	push dword [inv_args_len]	; length of data to print
	push inv_args			; base address of string to print
	call print
	add esp, 8
	call exit

print:
	mov edx, dword [esp + 8]	; implementation of print function which uses write syscall (eax = 4)
	mov ecx, dword [esp + 4]	; function accepts two params, 1st is the base address of string to be printed
	mov ebx, 1			; and 2nd param is the length of the string
	mov eax, 4			; save values in registers before calling this if those values are needed
	int 80h         ; write syscall
	ret

exit:
	mov ebx, 0
	mov eax, 1
	int 80h		; exit syscall
	ret

; stringcmp related labels begin here
stringcmp:
	push ebp			; strcmp like implementation in asm
	mov ebp, esp			; function accepts three arguements
	mov edi, ebp			; first is the address of string and 2nd is the length of this string
	add edi, 12			; third is the address of the string to be compared
	mov eax, dword [ebp + 16]
	mov ebx, dword [ebp + 8]		; If strings are equal eax contains 0 and 1 if they aren't
	xor ecx, ecx
	xor edx, edx
	
stringcmp_loop:
	mov cl, byte [eax]
	mov dl, byte [ebx]
	dec dword [edi]
	inc eax
	inc ebx
	cmp cl, dl
	jne string_not_eq
	cmp dword [edi], 0
	je string_eq
	jmp stringcmp_loop

string_eq:
	mov eax, 0
	pop ebp
	ret

string_not_eq:
	mov eax, 1
	pop ebp
	ret

; stringcmp related labels end here

; stringlen related labels begin here
stringlen:
	mov ebx, [esp + 4]	; implementation like strlen function

stringlen_loop:
	cmp byte [ebx], 0	; traverses through the string byte 0 is encountered and subtracts the base from that address
	je len_found		; the returned length is in eax register
	inc ebx
	jmp stringlen_loop

len_found:
	sub ebx, [esp + 4]
	mov eax, ebx
	ret

; stringlen related labels end here


find_c_in_s:
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx
	xor eax, eax
	mov ebx, dword [ebp + 8]
	mov ecx, dword [ebp + 12]
find_c_in_s_loop:
	cmp byte [ebx], cl
	je found_pos
	inc eax
	cmp eax, 65
	je find_not_found
	inc ebx
	jmp find_c_in_s_loop
find_not_found:
	xor eax, eax
found_pos:
	pop edx
	pop ecx
	pop ebx
	leave
	ret


allocate_mem:			; Need to improve this to allocate multiple buffers otherwise can't operate on files as it requires 2 buffers
	xor ebx, ebx
	mov eax, 45 		; syscall number for sys_brk
	int 0x80		; first syscall gets the address of break point
	mov [mem_start], eax
	mov ebx, [mem_start]
	add ebx, [esp + 4]
	mov eax, 45
	int 0x80		; second allocates the required amount memory after the first break point
	ret

args_correct:
	push encod_param		; base address of first string
	push dword [param_len]		; length of first string
	push dword [ebp + 8]			; base address of 2nd string to be compared
	call stringcmp
	add esp, 12			; pop args from stack
	cmp eax, 0			; checking wheather to encode here
	je enc_routine
	push decod_param
	push dword [param_len]
	push dword [ebp + 8]
	call stringcmp
	add esp, 12
	cmp eax, 0			; checking here to see if to decode
	je dec_routine
	jmp invalid
stop:
	call exit
	ret
