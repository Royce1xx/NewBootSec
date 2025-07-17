16 bits
org 0x7c00

; Setup segments and stack 
cli
xor ax, ax
mov ds, ax
mov ss, ax
mov es, ax
mov sp, 0x7BFF
sti

; Calls the Enable_20 function
call activate 

; print boot message
mov si, 0

; prints hello to the screen
print:
    mov ah, 0x0e
    mov al, [Hello + si]
    int 0x10
    add si, 1
    cmp [Hello + si], 0
    jne print

jmp $

; This enables the A_20 so we can get into protected mode
activate:
    mov ax, 0x2401
    int 0x15
    jc .fail
    ret

; if it fails this turns off interupts
.fail:
    cli

; this stalls are cpu if things go wrong
.hang:
    hlt
    jmp .hang

; welcome to the bootloader
Hello:
    db "Royce's 2nd Bootloader", 0

; Makes sure that 
times 510 -($-$$) db 0
dw 0xAA55