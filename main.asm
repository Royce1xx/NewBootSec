16 bits
org 0x7c00


cli
xor ax, ax
mov ds, ax
mov ss, ax
mov es, ax
mov sp, 0x7BFF
sti

call activate

mov si, 0

print:
    mov ah, 0x0e
    mov al, [Hello + si]
    int 0x10
    add si, 1
    cmp [Hello + si], 0
    jne print

jmp $

activate:
    mov ax, 0x2401
    int 0x15
    jc .fail
    ret


.fail:
    cli

.hang:
    hlt
    jmp .hang

Hello:
    db "Royce's 2nd Bootloader", 0


times 510 -($-$$) db 0
dw 0xAA55