ISCNTC:
    jsr MONRDKEY
    bcc @notcntc
    cmp #$03
    beq @iscntc
@notcntc:
    rts
@iscntc:
    ; Fall through to STOP