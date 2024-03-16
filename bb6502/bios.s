
.setcpu "65C02"
.debuginfo
.include "65c51.inc"

; Not yet implemented.
LOAD:
    rts

; Not yet implemented.
SAVE:
    rts

; Reserve some zero page addresses for pointers to our circular buffer.
.zeropage
.org ZP_START0
READ_PTR: .res 1
WRITE_PTR: .res 1

.segment "SERIAL_INPUT_BUFFER"
; A circular input buffer for the serial port.
SERIAL_INPUT_BUFFER: .res $100

.segment "BIOS"
; Initialise our circular serial input buffer.
; 
; Flags: modified
; A: modified
; X, Y: Unchanged
INIT_BUFFER:
    lda READ_PTR
    sta WRITE_PTR
    rts

; Write to the serial input buffer from A.
; Expects A to contain the character to write.
; Flags: modified
; X: modified
; A, Y: unchanged
WRITE_BUFFER:
    ldx WRITE_PTR
    sta SERIAL_INPUT_BUFFER,x
    inc WRITE_PTR
    rts

; Read from the input buffer.
; Flags: modified
; X: modified
; A: Updated with the character that was read.
; Y: unchanged.
READ_BUFFER:
    ldx READ_PTR
    lda SERIAL_INPUT_BUFFER,x
    inc READ_PTR
    rts


; Computes how many bytes are in the buffer and return this in A.
; Modifies: Flags, A
; Unchanged: X, Y
BUFFER_SIZE:
    lda WRITE_PTR
    sec
    sbc READ_PTR
    rts

; Determine whether or not a character is able to be read from the buffer.
; If a character is present, then it is loaded into A and the carry flag is set.
; Modifies: Flags, A.
; Unchanged: X, Y.
MONRDKEY:
CHRIN:
    phx
    jsr BUFFER_SIZE
    beq @nokeypress
    jsr READ_BUFFER
    jsr CHROUT
    plx
    sec
    rts
@nokeypress:
    plx
    clc
    rts

; Output a character from the accumulator.
; Modifies: flags.
; Unchanged: A, X, Y.
MONCOUT:
CHROUT:
    pha
    sta ACIA::DATA
    lda #$ff
@delay:
    dec
    bne @delay
    pla
    rts

; Interrupt request handler. Must leave A, X and Y untouched and call rti once finished.
IRQ:
    pha
    phx
    bit ACIA::STATUS  ; Acknowledge the interrupt by reading the status register.
    lda ACIA::DATA
    jsr WRITE_BUFFER
    plx
    pla
    rti

.include "wozmon.s"

    ; Interrupt Vectors

    .segment "RESETVECTORS"

    .WORD $0F00     ; NMI
    .WORD RESET     ; RESET
    .WORD IRQ       ; BRK/IRQ
