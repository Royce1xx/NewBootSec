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
    mov al, [Hello + si] ; rand
    int 0x10
    add si, 1
    cmp [Hello + si], 0
    jne print

jmp $


mov ax, 0x1000
mov es, ax
xor bx, bx

mov ah, 0x02       ;Bios read sector to read in the kernel
mov al, 0x01
mov ch, 0x00       ; cylinder
mov cl, 0x02       ; sector (start at sector 2)
mov dh, 0x00       ; head
mov dl, 0x00       ; drive
int 0x13           ; This reads the data from the disk

jc .disk_error
jmp 0x1000:0000    ; This jumps back to the kernel


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

.disk_error:
    cli         ; Stop the interrupts




.disk_hang:
    hlt             ;Stops the cpu 
    jmp .disk_hang


; welcome to the bootloader
Hello:
    db "Royce's 2nd Bootloader", 0

; Makes sure that 
times 510 -($-$$) db 0
dw 0xAA55