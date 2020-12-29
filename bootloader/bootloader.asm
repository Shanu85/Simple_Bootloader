;Shanu Verma
;2019104

bits 16
org 0x7c00

os_boot:
	mov ax, 0x2401
	int 0x15
	mov ax, 0x3
	int 0x10
	cli
	lgdt [gdt_pointer]
	mov eax, cr0
	or eax,0x1
	mov cr0, eax
	jmp CODE_SEG:boot_segment_32
gdt_start:
	dq 0x0
gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
boot_segment_32:
	mov esi,hello_world
    mov edx, cr0
    mov ecx, 32          
    mov ebx,0xb8000 

.cr0_label:
    mov eax, 00000f30h
    shl edx, 1         ; shift edx left by 1 bit  
    adc eax, 0         ; add 0 in eax with carry bit 
    mov [ebx], ax
    add ebx, 2    
    dec ecx      ; decrement the count register (CX store the loop count in iterative operations )
    jne .cr0_label

loop:
	lodsb 			;lodsb to load the next byte from SI
	or al,al
	jz done
	or eax,0x0f00
	mov word [ebx], ax
	add ebx,2
	jmp loop

done:
	ret
hello_world: db " Hello world ",0

times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
dw 0xAA55		; The standard PC boot signature
