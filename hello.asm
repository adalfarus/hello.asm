bits 64
default rel

section .bss
	buffer: resb 100
	npCharRead: resb 1

section .data
    msg: db "Hello, World!", 10, 0
	input: db "Please Input a str:", 0

section .text
    global main
	    
    extern WriteConsoleA
    extern GetStdHandle
    extern ExitProcess
	extern ReadConsoleA
    
_strlen:
	; Inputs:
	; - rcx, pointer to str
	; - rdx, max str length, defaults to 128 (if rdx is set to 0)
	; Returns:
	; - rax, the string length if len(str) <= max str length
	; Uses:
	; - bl, as a temp store
	push rcx
	push rdx
	push rbx
	cmp rdx, 0
	xor rax, rax
	je .setdefault
	
	.loop:
	mov bl, [rcx + rax]
	cmp bl, 0
	je .end
	inc rax
	cmp rax, rdx
	jbe .loop
	
	.end:
	pop rbx
	pop rdx
	pop rcx
	ret
	
	.setdefault:
	mov rdx, 128
	jmp .loop

_printf:
	; Inputs:
	; - rcx, pointer to str
	; - rdx, max str length, 0 is interpreted as 128
	; Returns:
	; Uses:
	; - rcx, to call a sub-routine
	; - rdx, to call a sub-routine
	; - r8, to call a sub-routine
	; - r9, to call a sub-routine
	push rcx
	push rdx
	push r8
	push r9
	push rcx
    mov rcx, -11 ; STD_OUTPUT_HANDLE
    call GetStdHandle
	pop rcx
	mov r10, rax
	
	call _strlen
	
	mov r9, 0
	mov r8, rax ; Length to Write
	mov rdx, rcx ; Pointer to string
	mov rcx, r10 ; Restore handle
	
	call WriteConsoleA
	
	pop r9
	pop r8
	pop rdx
	pop rcx
	ret
	
_inputf:
	; Inputs:
	; - rcx, pointer to str for the input message
	; - rdx, pointer to a str buffer, for the input received
	; - r8, number of max chars read, if set to 0 defaults to 128
	; - r9, pointer to an int buffer for number of chars gotten
	; Returns:
	; Uses:
	; - rcx, to call a sub-routine
	; - rdx, to call a sub-routine
	; - r8, to call a sub-routine
	; - r9, to call a sub-routine
	push rcx
	push rdx
	push r8
	push r9
	
	push rdx
	xor rdx, rdx
	call _printf
	pop rdx
	
    mov rcx, -10 ; STD_INPUT_HANDLE
    call GetStdHandle
	
    mov rcx, rax
    call ReadConsoleA
	
	pop r9
	pop r8
	pop rdx
	pop rcx
	ret
	
main:
	xor rdx, rdx
	call _printf
	
	mov rcx, msg
	xor rdx, rdx
	call _printf
	call _printf
	
	mov rcx, input
	mov rdx, buffer
	mov r8, 100
	mov r9, npCharRead
	call _inputf
	
	mov rcx, buffer
	; xor rdx, rdx
	mov rdx, npCharRead
	call _printf
	
	mov rcx, input ; Input so it doesn't exit
	mov rdx, buffer
	mov r8, 100
	mov r9, npCharRead
	call _inputf
	
    xor rcx, rcx ; Exit code 0
    call ExitProcess
	ret
