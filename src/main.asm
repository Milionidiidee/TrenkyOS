org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
    jmp main

;
;   Prints a string to the screen
;   Params: 
;       ds:si points to string
;
puts:
    ; save register we will modify
    push si
    push ax

.loop:
    lodsb                       ; loads next caracter (this instruction loads a byte from ds:si and puts it in al then increment si)
    or al, al                   ; performs bitwise or and store in the leftside operand
    ; the or operation doesn't modify anything but if the result is zero it will modify the zero flag
    jz .done                    ; conditional jump if the zero flag is set

    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp .loop

.done:
    pop ax
    pop si
    ret

main:

    ; setup data segments
    mov ax, 0                   ; we cannot write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00              ; stack grows downwards (we set this here so it doesn't override code)

    ; print msg
    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello w!', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h