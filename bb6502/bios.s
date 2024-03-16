
.setcpu "65C02"
.debuginfo
.segment "BIOS"
.include "65c51.inc"

LOAD:
    rts


SAVE:
    rts



MONRDKEY:
CHRIN:
    lda ACIA::STATUS
    and #(RDRF)
    beq @nokeypress
    lda ACIA::DATA
    jsr CHROUT
    sec
    rts
@nokeypress:
    clc
    rts

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

.include "wozmon.s"

; Interrupt Vectors

    .segment "RESETVECTORS"

    .WORD $0F00     ; NMI
    .WORD RESET     ; RESET
    .WORD $0000     ; BRK/IRQ
