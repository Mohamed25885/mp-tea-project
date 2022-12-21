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
