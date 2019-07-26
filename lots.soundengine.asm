SoundEngine:
	exx
	ld a, (_RAM_DE00)
	or a
	ex af, af'
	ld hl, _RAM_DE0C
	exx
	ld hl, _RAM_DE09
	ld a, (hl)
	or a
	jr z, _LABEL_C069
	xor a
	ld (hl), a
	call _LABEL_C0B4
	call _LABEL_C0CD
	call _LABEL_C10D
_LABEL_C01C:
	call _LABEL_C301
	ld a, (_RAM_DE00)
	or a
	jp z, +++
	ld ix, _RAM_DE0E
	ld b, $08
-:
	push bc
	bit 7, (ix+0)
	jr z, +
	call ++
	pop af
	push af
	cp $03
	call c, _LABEL_C494
+:
	ld de, $0020
	add ix, de
	pop bc
	djnz -
	ret

++:
	bit 3, (ix+7)
	ret z
	res 3, (ix+7)
	jp _LABEL_C59F

+++:
	ld ix, _RAM_DECE
	ld b, $02
-:
	push bc
	bit 7, (ix+0)
	call nz, _LABEL_CAD0
	ld de, $0020
	add ix, de
	pop bc
	djnz -
	ret

_LABEL_C069:
	inc (hl)
	ld a, (_RAM_DE00)
	or a
	jp z, +
	ld ix, _RAM_DE0E
	ld b, $05
-:
	push bc
	bit 7, (ix+0)
	call nz, _LABEL_C494
	ld de, $0020
	add ix, de
	pop bc
	djnz -
	bit 7, (ix+0)
	call nz, _LABEL_C43E
	ret

+:
	ld ix, _RAM_DE4E
	ld b, $04
--:
	push bc
	ld a, $01
	cp b
	jr z, +
	bit 7, (ix+0)
	call nz, _LABEL_CAD0
-:
	ld de, $0020
	add ix, de
	pop bc
	djnz --
	ret

+:
	bit 7, (ix+0)
	call nz, _LABEL_CA12
	jr -

_LABEL_C0B4:
	ld hl, _RAM_DE01
	ld a, (hl)
	or a
	ret z
	dec (hl)
	ret nz
	ld a, (_RAM_DE02)
	ld (hl), a
	ld hl, _RAM_DE18
	ld de, $0020
	ld b, $06
-:
	inc (hl)
	add hl, de
	djnz -
	ret

_LABEL_C0CD:
	ld de, _RAM_SOUND_TO_PLAY
	call +
	inc de
	call +
	inc de
	call +
	ret

+:
	ld a, (de)
	bit 7, a
	ret z
	and $7F
	ld hl, _DATA_C202
	dec a
	ld b, $00
	ld c, a
	add hl, bc
	bit 7, (hl)
	jr z, +
	ld a, (de)
	ld (_RAM_DE03), a
	xor a
	ld (de), a
	pop hl
	pop hl
	jp _LABEL_C01C

; Data from C0F9 to C0F9 (1 bytes)
.db $C9

+:
	ld a, (_RAM_DE07)
	cp (hl)
	jr z, +
	jr nc, ++
	+:
	ld a, (de)
	ld (_RAM_DE03), a
	ld a, (hl)
	ld (_RAM_DE07), a
	++:
	xor a
	ld (de), a
	ret

_LABEL_C10D:
	ld a, (_RAM_DE0A)
	or a
	ret z
	ld a, (_RAM_DE0B)
	dec a
	jr z, +
	ld (_RAM_DE0B), a
	ret

+:
	ld a, $06
	ld (_RAM_DE0B), a
	ld a, (_RAM_DE0A)
	dec a
	ld (_RAM_DE0A), a
	jp z, _LABEL_C989
	ld hl, _RAM_DE16
	ld de, $0020
	ld b, $05
-:
	ld a, (hl)
	inc a
	cp $10
	jr z, +
	ld (hl), a
+:
	add hl, de
	djnz -
	ex af, af'
	jr nz, +
	ex af, af'
	ret

+:
	ex af, af'
	ld hl, _RAM_DE15
	ld de, $001F
	ld bc, $0530
-:
	ld a, c
	out (Port_FMAddress), a
	inc c
	ld a, (hl)
	and $F0
	inc hl
	or (hl)
	add hl, de
	out (Port_FMData), a
	call _LABEL_CA0F
	djnz -
	ret

; 1st entry of Jump Table from C2FD (indexed by _RAM_DE03)
_LABEL_C15E:
	ld a, $0C
	ld (_RAM_DE0A), a
	ld a, $06
	ld (_RAM_DE0B), a
	xor a
	ld (_RAM_DEAE), a
	ld a, $FF
	out (Port_PSG), a
	ld a, (_RAM_DE00)
	or a
	jp z, _LABEL_C42F
	ld b, $03
	xor a
	ld c, Port_FMAddress
	ld d, $23
-:
	out (c), d
	inc d
	call _LABEL_CA0F
	out (Port_FMData), a
	call _LABEL_CA0F
	djnz -
	ld (_RAM_DEAE), a
	ld (_RAM_DECE), a
	ld (_RAM_DEEE), a
	jp _LABEL_C42F

; 2nd entry of Jump Table from C2FD (indexed by _RAM_DE03)
_LABEL_C197:
	xor a
	ld (_RAM_DE07), a
	ld (_RAM_DECE), a
	ld (_RAM_DEEE), a
	ld hl, _RAM_DE6E
	res 2, (hl)
	ld hl, _RAM_DE8E
	res 2, (hl)
	ld hl, _RAM_DEAE
	res 2, (hl)
	ld hl, _DATA_CA0C
	ld c, Port_PSG
	ld b, $03
	otir
	ld a, $24
	call _LABEL_C1CF
	ld hl, _DATA_CA0C
	ld c, Port_PSG
	ld b, $03
	otir
	ld a, $25
	call _LABEL_C1CF
	jp _LABEL_C42F

_LABEL_C1CF:
	out (Port_FMAddress), a
	call _LABEL_CA0F
	xor a
	out (Port_FMData), a
	ret

_LABEL_C1D8:
	push bc
	ld b, $12
	ld hl, _DATA_C1F0
	ld c, Port_FMData
-:
	dec c
	outi
	inc c
	call _LABEL_CA0F
	outi
	call _LABEL_CA0F
	jr nz, -
	pop bc
	ret

; Data from C1F0 to C201 (18 bytes)
_DATA_C1F0:
.db $16 $20 $17 $B0 $18 $01 $26 $05 $27 $01 $28 $01 $36 $02 $37 $73
.db $38 $38

; Data from C202 to C232 (49 bytes)
_DATA_C202:
.db $80 $80 $80 $80 $80 $80 $80 $80 $80 $00 $00 $00 $00 $00 $00 $30
.db $45 $30 $55 $60 $60 $55 $25 $40 $40 $25 $60 $60 $20 $30 $20 $25
.db $70 $25 $35 $30 $65 $40 $00 $00 $00 $00 $00 $00 $00 $00 $00 $80
.db $80

; Data from C233 to C240 (14 bytes)
_DATA_C233:
.db $00 $00 $00 $00 $00 $00 $00 $04 $00 $03 $00 $00 $00 $00

; Pointer Table from C241 to C25E (15 entries, indexed by _RAM_DE03)
_DATA_C241:
.dw _DATA_DDA7 _DATA_DE03 _DATA_DE5F _DATA_DEBB _DATA_DF17 _DATA_DF73 _DATA_DFCF _DATA_E02B
.dw _DATA_E07E _DATA_E0D1 _DATA_DDA7 _DATA_DDA7 _DATA_DDA7 _DATA_DDA7 _DATA_DDA7

; Pointer Table from C25F to C29E (32 entries, indexed by _RAM_DE03)
_DATA_C25F:
.dw _DATA_E54B _DATA_E572 _DATA_E599 _DATA_E5CD _DATA_E601 _DATA_E636 _DATA_E682 _DATA_E6BB
.dw _DATA_E6E7 _DATA_E70E _DATA_E72C _DATA_E75F _DATA_E779 _DATA_E795 _DATA_E7C2 _DATA_E7FB
.dw _DATA_E82A _DATA_E867 _DATA_E8A4 _DATA_E8CB _DATA_E8F2 _DATA_E919 _DATA_E970 _DATA_E970
.dw _DATA_E970 _DATA_E970 _DATA_E970 _DATA_E970 _DATA_E970 _DATA_E970 _DATA_E970 _DATA_E970

; Pointer Table from C29F to C2BC (15 entries, indexed by _RAM_DE03)
_DATA_C29F:
.dw _DATA_DD70 _DATA_DDCC _DATA_DE28 _DATA_DE84 _DATA_DEE0 _DATA_DF3C _DATA_DF98 _DATA_DFF4
.dw _DATA_E050 _DATA_E09A _DATA_DD70 _DATA_DD70 _DATA_DD70 _DATA_DD70 _DATA_DD70

; Pointer Table from C2BD to C2FC (32 entries, indexed by _RAM_DE03)
_DATA_C2BD:
.dw _DATA_E541 _DATA_E568 _DATA_E58F _DATA_E5BA _DATA_E5EE _DATA_E623 _DATA_E66F _DATA_E6B1
.dw _DATA_E6DD _DATA_E704 _DATA_E722 _DATA_E755 _DATA_E76F _DATA_E78B _DATA_E7B8 _DATA_E7F1
.dw _DATA_E820 _DATA_E854 _DATA_E89A _DATA_E8C1 _DATA_E8DF _DATA_E90F _DATA_E966 _DATA_E966
.dw _DATA_E966 _DATA_E966 _DATA_E966 _DATA_E966 _DATA_E966 _DATA_E966 _DATA_E966 _DATA_E966

; Jump Table from C2FD to C300 (2 entries, indexed by _RAM_DE03)
_DATA_C2FD:
.dw _LABEL_C15E _LABEL_C197

_LABEL_C301:
	ld a, (_RAM_DE03)
	bit 7, a
	ret z
	cp $90
	jp c, +
	cp $AE
	jp c, _LABEL_C35B
	cp $B0
	jp c, _LABEL_C35B
	cp $B2
	jp nc, _LABEL_C989
	sub $B0
	add a, a
	ld c, a
	ld b, $00
	ld hl, _DATA_C2FD
	add hl, bc
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	jp (hl)

+:
	sub $81
	ret m
	push af
	call _LABEL_C989
	call _LABEL_C1D8
	pop af
	ld b, $00
	ld c, a
	ld hl, _DATA_C233
	add hl, bc
	push af
	ld a, (hl)
	ld (_RAM_DE01), a
	ld (_RAM_DE02), a
	ld de, _RAM_DE4E
	ld hl, _DATA_C241
	ex af, af'
	jr z, +
	ld de, _RAM_DE0E
	ld hl, _DATA_C29F
+:
	ex af, af'
	pop af
	call _LABEL_C435
	jp _LABEL_C3EF

_LABEL_C35B:
	sub $90
	ld hl, _DATA_C25F
	ex af, af'
	jr z, +
	ld hl, _DATA_C2BD
+:
	ex af, af'
	call _LABEL_C435
	ld h, b
	ld l, c
	inc hl
	inc hl
	ld a, (hl)
	ex af, af'
	jr z, ++++
	ex af, af'
	cp $10
	jr z, +
	cp $14
	jr z, ++
	ld de, _RAM_DEEE
	jr +++

+:
	call _LABEL_C989
	ld de, _RAM_DE0E
	jr _LABEL_C3EF

++:
	ld de, _RAM_DECE
	ld a, $24
	call _LABEL_C1CF
	ld a, $14
	ld hl, _RAM_DE8E
	set 2, (hl)
+++:
	add a, $10
	call _LABEL_C1CF
	jr _LABEL_C3EF

++++:
	ex af, af'
	cp $C0
	jr z, ++
	cp $E0
	jr z, +
	cp $A0
	jr z, +++
	call _LABEL_C989
	ld de, _RAM_DE4E
	jr _LABEL_C3EF

+:
	ld a, $DF
	out (Port_PSG), a
	ld a, $E7
	out (Port_PSG), a
	ld hl, _RAM_DEAE
	set 2, (hl)
++:
	ld de, _RAM_DEEE
	jr ++++

+++:
	ld de, _RAM_DECE
	ld hl, _RAM_DE6E
	set 2, (hl)
++++:
	ld h, b
	ld l, c
	push de
	ld de, $000B
	add hl, de
	pop de
	ld a, (hl)
	cp $E0
	jr nz, +
	ld hl, _RAM_DEAE
	set 2, (hl)
+:
	ld a, $FF
	out (Port_PSG), a
	ld a, $C0
	out (Port_PSG), a
	xor a
	out (Port_PSG), a
	ld hl, _RAM_DE8E
	set 2, (hl)
_LABEL_C3EF:
	ld h, b
	ld l, c
	ld b, (hl)
	inc hl
-:
	push bc
	push hl
	pop ix
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ld a, $20
	ld (de), a
	inc de
	ld a, $01
	ld (de), a
	inc de
	xor a
	ld (de), a
	inc de
	ld (de), a
	inc de
	ld (de), a
	push hl
	ld hl, $0013
	add hl, de
	ex de, hl
	pop hl
	ld bc, +	; Overriding return address
	push bc
	ld a, (_RAM_DE00)
	or a
	jp nz, _LABEL_C589
	jp _LABEL_CBD7

+:
	pop bc
	djnz -
_LABEL_C42F:
	ld a, $80
	ld (_RAM_DE03), a
	ret

_LABEL_C435:
	add a, a
	ld b, $00
	ld c, a
	add hl, bc
	ld c, (hl)
	inc hl
	ld b, (hl)
	ret

_LABEL_C43E:
	inc (ix+11)
	ld a, (ix+10)
	sub (ix+11)
	jr nz, +
	call ++
	ld a, $0E
	out (Port_FMAddress), a
	ld a, (ix+16)
	or $20
	out (Port_FMData), a
	ret

+:
	cp $02
	ret nz
	ld a, $0E
	out (Port_FMAddress), a
	call _LABEL_CA0F
	xor a
	out (Port_FMData), a
	ret

++:
	ld e, (ix+3)
	ld d, (ix+4)
-:
	ld a, (de)
	inc de
	cp $E0
	jp nc, ++
	cp $7F
	jp c, _LABEL_C66F
	bit 5, a
	jr z, +
	or $01
+:
	bit 2, a
	jr z, +
	or $10
+:
	ld (ix+16), a
	jp _LABEL_C661

++:
	ld hl, +	; Overriding return address
	jp _LABEL_C715

+:
	inc de
	jp -

_LABEL_C494:
	inc (ix+11)
	ld a, (ix+10)
	sub (ix+11)
	call z, _LABEL_C607
	ld (_RAM_DE0C), a
	cp $80
	jp z, _LABEL_C4FD
	bit 5, (ix+0)
	jp z, _LABEL_C4FD
	exx
	ld (hl), $80
	exx
	bit 3, (ix+0)
	jp nz, ++
	ld a, (ix+17)
	bit 7, a
	jr z, +
	add a, (ix+14)
	jr c, ++++
	dec (ix+15)
	dec (ix+15)
	jp +++

+:
	add a, (ix+14)
	jr nc, ++++
	inc (ix+15)
	inc (ix+15)
	jp +++

++:
	ld a, (ix+17)
	bit 7, a
	jr z, +
	add a, (ix+14)
	jr c, ++++
	dec (ix+15)
	jr +++

+:
	add a, (ix+14)
	jr nc, ++++
	inc (ix+15)
+++:
	set 1, (ix+7)
++++:
	ld (ix+14), a
_LABEL_C4FD:
	bit 2, (ix+0)
	ret nz
	bit 0, (ix+0)
	jr z, +
	ld a, $03
	cp (ix+11)
	jp c, _LABEL_C59F
+:
	ld a, (ix+19)
	cp $1F
	ret z
	ld a, (_RAM_DE0C)
	bit 0, (ix+7)
	jr nz, +
	cp $02
	jp c, _LABEL_C5B4
+:
	or a
	jp m, +
	bit 7, (ix+20)
	ret nz
	ld a, (ix+6)
	dec a
	jp p, ++
	ret

+:
	ld a, (ix+6)
	dec a
++:
	ld l, (ix+14)
	ld h, (ix+15)
	jp m, +
	ex de, hl
	ld hl, _DATA_EA69
	call _LABEL_C5B9
	call _LABEL_C5C6
+:
	bit 3, (ix+0)
	call nz, _LABEL_C6BC
	ld c, Port_FMData
	ld a, (ix+1)
	out (Port_FMAddress), a
	add a, $10
	call _LABEL_CA0F
	call _LABEL_CA0F
	out (c), l
	call _LABEL_CA0F
	exx
	bit 7, (hl)
	exx
	out (Port_FMAddress), a
	jr nz, +
	bit 0, (ix+7)
	jr z, +
	bit 1, (ix+7)
	ret z
	res 1, (ix+7)
+:
	bit 2, (ix+7)
	jr z, +
	set 5, h
+:
	out (c), h
	ret

_LABEL_C589:
	ld a, (ix+1)
	add a, $20
	out (Port_FMAddress), a
	ld a, (ix+7)
	and $F0
	ld c, a
	ld a, (ix+8)
	and $0F
	or c
	out (Port_FMData), a
	ret

_LABEL_C59F:
	ld (ix+19), $1F
	ld a, (ix+1)
	add a, $10
	out (Port_FMAddress), a
	call _LABEL_CA0F
	call _LABEL_CA0F
	xor a
	out (Port_FMData), a
	ret

_LABEL_C5B4:
	set 3, (ix+7)
	ret

_LABEL_C5B9:
	ld c, a
	ld b, $00
	add hl, bc
	add hl, bc
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ret

-:
	ld (ix+13), a
_LABEL_C5C6:
	push hl
	ld c, (ix+13)
	ld b, $00
	add hl, bc
	ld c, l
	ld b, h
	pop hl
	ld a, (bc)
	bit 7, a
	jp z, +++
	cp $83
	jr z, +
	cp $80
	jr z, ++
	ld a, $FF
	ld (ix+20), a
	pop hl
	ret

+:
	inc bc
	ld a, (bc)
	jr -

++:
	xor a
	jr -

+++:
	inc (ix+13)
	ld l, a
	ld h, $00
	add hl, de
	ld a, (_RAM_DE00)
	or a
	jr z, +
	ld a, h
	cp (ix+16)
	jr z, +
	set 1, (ix+7)
+:
	ld (ix+16), a
	ret

_LABEL_C607:
	res 0, (ix+0)
	ld a, (ix+8)
	bit 7, a
	jr z, ++
	inc a
	bit 6, a
	jr nz, +
	inc a
+:
	and $3F
	ld (ix+8), a
++:
	ld e, (ix+3)
	ld d, (ix+4)
_LABEL_C623:
	ld a, (de)
	inc de
	cp $E0
	jp nc, _LABEL_C712
	bit 3, (ix+0)
	jp nz, _LABEL_C698
	cp $80
	jp c, _LABEL_C66F
	jr nz, +
+:
	call _LABEL_C6FB
	ld a, (hl)
	ld (ix+14), a
	inc hl
	ld a, (hl)
	ld (ix+15), a
_LABEL_C644:
	bit 5, (ix+0)
	jp z, _LABEL_C661
	ld a, (de)
	inc de
	ld (ix+18), a
	ld (ix+17), a
	bit 3, (ix+0)
	ld a, (de)
	jr nz, +
	ld (ix+17), a
	inc de
	ld a, (de)
	jr +

_LABEL_C661:
	ld a, (de)
	or a
	jp p, +
	ld a, (ix+21)
	ld (ix+10), a
	jr _LABEL_C67F

+:
	inc de
_LABEL_C66F:
	ld b, (ix+2)
	dec b
	jr z, +
	ld c, a
-:
	add a, c
	djnz -
+:
	ld (ix+10), a
	ld (ix+21), a
_LABEL_C67F:
	xor a
	ld (ix+12), a
	ld (ix+13), a
	ld (ix+11), a
	ld (ix+19), a
	ld (ix+20), a
	ld (ix+3), e
	ld (ix+4), d
	ld a, $80
	ret

_LABEL_C698:
	ld h, a
	ld a, (de)
	inc de
	ld l, a
	or h
	jr z, +++
	ld a, (ix+5)
	or a
	jr z, +++
	jp p, +
	add a, l
	jr c, ++
	dec h
	jr ++

+:
	add a, l
	jr nc, ++
	inc h
++:
	ld l, a
+++:
	ld (ix+14), l
	ld (ix+15), h
	jp _LABEL_C644

_LABEL_C6BC:
	push de
	ld a, h
	or a
	jr z, +
	cp $02
	ld a, $12
	jr c, ++
	srl h
	rr l
	ld a, $10
	jr ++

+:
	ld a, l
	or a
	jp z, +++
	ld bc, $0400
-:
	rlca
	inc c
	jr c, +
	djnz -
+:
	ld b, c
	ld a, $12
-:
	inc a
	inc a
	sla l
	rl h
	djnz -
++:
	ld de, $0757
	ex de, hl
	or a
	sbc hl, de
	bit 1, h
	jr z, +
	set 0, h
+:
	ld d, a
	ld e, $00
	add hl, de
+++:
	pop de
	ret

_LABEL_C6FB:
	sub $80
	jr z, +
	add a, (ix+5)
+:
	ld hl, $8BE4
	ex af, af'
	jr z, +
	ld hl, _DATA_CC76
+:
	ex af, af'
	ld c, a
	ld b, $00
	add hl, bc
	add hl, bc
	ret

_LABEL_C712:
	ld hl, +	; Overriding return address
_LABEL_C715:
	push hl
	sub $EC
	jp c, _LABEL_C7DC
	ld hl, _DATA_C72C
	add a, a
	ld c, a
	ld b, $00
	add hl, bc
	ld c, (hl)
	inc hl
	ld h, (hl)
	ld l, c
	jp (hl)

+:
	inc de
	jp _LABEL_C623

; Jump Table from C72C to C753 (20 entries, indexed by unknown)
_DATA_C72C:
.dw _LABEL_C7DD _LABEL_C853 _LABEL_C754 _LABEL_C766 _LABEL_C7A7 _LABEL_C7BF _LABEL_C8B3 _LABEL_C7F9
.dw _LABEL_C830 _LABEL_C812 _LABEL_C84D _LABEL_C971 _LABEL_C943 _LABEL_C95E _LABEL_C7D7 _LABEL_C7C5
.dw _LABEL_C895 _LABEL_C8A4 _LABEL_C793 _LABEL_C772

; 3rd entry of Jump Table from C72C (indexed by unknown)
_LABEL_C754:
	ex af, af'
	jr nz, +
	ex af, af'
	ld a, (de)
	inc de
	jr ++

+:
	ex af, af'
	inc de
	ld a, (de)
++:
	add a, (ix+2)
	ld (ix+2), a
	ret

; 4th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C766:
	ld a, (_RAM_DE0A)
	or a
	ret nz
	ld a, (de)
	add a, (ix+8)
	jp _LABEL_C7E3

; 20th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C772:
	ld a, (ix+1)
	add a, $10
	out (Port_FMAddress), a
	ld h, d
	ld l, e
	ld b, $08
	xor a
	ld c, Port_FMData
	out (c), a
-:
	call _LABEL_CA0F
	out (Port_FMAddress), a
	inc a
	call _LABEL_CA0F
	outi
	jr nz, -
	ld d, h
	ld e, l
	dec de
	ret

; 19th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C793:
	ld a, (_RAM_DE0A)
	or a
	ret nz
	ld a, (_RAM_DE00)
	or a
	ret z
	ld a, (de)
	add a, (ix+8)
	ld (ix+8), a
	jp _LABEL_C7ED

; 5th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C7A7:
	ld a, (_RAM_DE00)
	or a
	ret z
	ld a, (ix+1)
	cp $13
	jr z, +
	cp $14
	jr z, +
	ret

+:
	ld a, (de)
	ld (ix+7), a
	jp _LABEL_C589

; 6th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C7BF:
	set 0, (ix+0)
	dec de
	ret

; 16th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C7C5:
	ex af, af'
	jr nz, +
	ex af, af'
	ld a, (de)
	inc de
	jr ++

+:
	ex af, af'
	inc de
	ld a, (de)
++:
	add a, (ix+5)
	ld (ix+5), a
	ret

; 15th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C7D7:
	ld a, (de)
	ld (ix+2), a
	ret

_LABEL_C7DC:
	dec de
; 1st entry of Jump Table from C72C (indexed by unknown)
_LABEL_C7DD:
	ld a, (_RAM_DE0A)
	or a
	ret nz
	ld a, (de)
_LABEL_C7E3:
	and $0F
	ld (ix+8), a
	bit 2, (ix+0)
	ret nz
_LABEL_C7ED:
	ex af, af'
	jp nz, +
	ex af, af'
	jp _LABEL_CBD7

+:
	ex af, af'
	jp _LABEL_C589

; 8th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C7F9:
	ld a, (de)
	or $E0
	out (Port_PSG), a
	or $FC
	inc a
	jr nz, +
	res 6, (ix+0)
	ret

+:
	set 6, (ix+0)
	ld hl, _RAM_DE8E
	res 2, (hl)
	ret

; 10th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C812:
	ex af, af'
	jr nz, +
	ex af, af'
	ld a, (de)
	inc de
	cp $80
	ret z
	ld (ix+7), a
	ret

+:
	ex af, af'
	inc de
	ld a, (_RAM_DE0A)
	or a
	ret nz
	ld a, (de)
	cp $04
	ret z
	ld (ix+7), a
	jp _LABEL_C589

; 9th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C830:
	ld a, (de)
	ld (ix+6), a
	ret

; Data from C835 to C84C (24 bytes)
.db $06 $00 $0E $1C $DD $E5 $E1 $09 $7E $B7 $20 $06 $1A $3D $77 $13
.db $13 $C9 $13 $35 $28 $02 $13 $C9

; 11th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C84D:
	ex de, hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	dec de
	ret

; 2nd entry of Jump Table from C72C (indexed by unknown)
_LABEL_C853:
	ld a, (de)
	cp $01
	jr z, +
	ld a, (ix+23)
	ld (ix+5), a
	res 5, (ix+0)
	ld a, (_RAM_DE00)
	or a
	ret z
	ld a, (ix+22)
	ld (ix+7), a
	jp _LABEL_C589

+:
	set 5, (ix+0)
	ld a, (ix+5)
	ld (ix+23), a
	xor a
	ld (ix+5), a
	ld a, (_RAM_DE00)
	or a
	ret z
	ld a, $12
	ld (ix+5), a
	ld a, (ix+7)
	ld (ix+22), a
	ld (ix+7), $53
	jp _LABEL_C589

; 17th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C895:
	ld a, (de)
	cp $01
	jr nz, +
	set 5, (ix+0)
	ret

+:
	res 5, (ix+0)
	ret

; 18th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C8A4:
	ld a, (de)
	cp $01
	jr nz, +
	set 3, (ix+0)
	ret

+:
	res 3, (ix+0)
	ret

; 7th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C8B3:
	xor a
	ld (_RAM_DE07), a
	ld (ix+0), a
	ex af, af'
	jp nz, _LABEL_C900
	ex af, af'
	ld a, (ix+1)
	add a, $1F
	out (Port_PSG), a
	cp $DF
	jp nc, ++
	cp $9F
	jp nz, +
	ld hl, _RAM_DE4E
	res 2, (hl)
	ld hl, _RAM_DE61
	jr +++

+:
	ld hl, _RAM_DE6E
	res 2, (hl)
	ld hl, _RAM_DE81
	jr +++

++:
	ld hl, _RAM_DEAE
	res 2, (hl)
	ld a, $DF
	out (Port_PSG), a
	ld a, (_RAM_DE08)
	out (Port_PSG), a
	ld hl, _RAM_DE8E
	res 2, (hl)
	ld hl, _RAM_DEA1
+++:
	ld a, $1F
	ld (hl), a
--:
	pop hl
	pop hl
	ret

_LABEL_C900:
	ex af, af'
	ld a, (ix+1)
	add a, $10
	call _LABEL_C1CF
	ld a, (ix+1)
	cp $14
	jr nz, +
	ld hl, _RAM_DE8E
	ld a, (hl)
	or a
	jp p, --
	res 2, (hl)
	ld a, $34
	out (Port_FMAddress), a
	ld hl, _RAM_DE95
-:
	ld a, (hl)
	and $F0
	ld c, a
	inc hl
	ld a, (hl)
	and $0F
	or c
	out (Port_FMData), a
	jp --

+:
	ld hl, _RAM_DEAE
	ld a, (hl)
	or a
	jp p, --
	res 2, (hl)
	ld a, $35
	out (Port_FMAddress), a
	ld hl, _RAM_DEB5
	jp -

; 13th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C943:
	ld a, (de)
	ld c, a
	inc de
	ld a, (de)
	ld b, a
	push bc
	push ix
	pop hl
	dec (ix+9)
	ld c, (ix+9)
	dec (ix+9)
	ld b, $00
	add hl, bc
	ld (hl), d
	dec hl
	ld (hl), e
	pop de
	dec de
	ret

; 14th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C95E:
	push ix
	pop hl
	ld c, (ix+9)
	ld b, $00
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc (ix+9)
	inc (ix+9)
	ret

; 12th entry of Jump Table from C72C (indexed by unknown)
_LABEL_C971:
	ld a, (de)
	inc de
	add a, $18
	ld c, a
	ld b, $00
	push ix
	pop hl
	add hl, bc
	ld a, (hl)
	or a
	jr nz, +
	ld a, (de)
	ld (hl), a
+:
	inc de
	dec (hl)
	jp nz, _LABEL_C84D
	inc de
	ret

_LABEL_C989:
	push hl
	push de
	push bc
	ld hl, _RAM_DE03
	ld de, _RAM_SOUND_TO_PLAY
	ld (hl), $00
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ldi
	ld hl, _RAM_DE0E
	xor a
	ld b, $08
-:
	ld de, $0018
	ld (hl), a
	add hl, de
	ld (hl), a
	inc hl
	ld (hl), a
	inc hl
	ld (hl), a
	inc hl
	ld (hl), a
	ld de, $0005
	add hl, de
	djnz -
	ld a, $E4
	ld (_RAM_DE08), a
	pop bc
	pop de
	pop hl
_LABEL_C9C8:
	push hl
	push bc
	ld hl, _DATA_CA04
	ld c, Port_PSG
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	outi
	push de
	ld b, $06
	xor a
	ld c, Port_FMAddress
	ld d, $20
-:
	out (c), d
	inc d
	call _LABEL_CA0F
	call _LABEL_CA0F
	out (Port_FMData), a
	call _LABEL_CA0F
	call _LABEL_CA0F
	djnz -
	pop de
	pop bc
	pop hl
	ret

; Data from CA04 to CA0B (8 bytes)
_DATA_CA04:
.db $80 $00 $A0 $00 $C0 $00 $E4 $FF

; Data from CA0C to CA0E (3 bytes)
_DATA_CA0C:
.db $BF $DF $FF

_LABEL_CA0F:
	push hl
	pop hl
	ret

_LABEL_CA12:
	inc (ix+11)
	ld a, (ix+10)
	sub (ix+11)
	call z, +
	bit 2, (ix+0)
	ret nz
	bit 4, (ix+19)
	ret nz
	ld a, (ix+7)
	dec a
	ret m
	ld hl, _DATA_E995
	call _LABEL_C5B9
	call _LABEL_CB9F
	or $F0
	out (Port_PSG), a
	ret

+:
	ld e, (ix+3)
	ld d, (ix+4)
-:
	ld a, (de)
	inc de
	cp $E0
	jp nc, +
	cp $80
	jp c, _LABEL_C66F
	call ++
	ld a, (de)
	inc de
	cp $80
	jp c, _LABEL_C66F
	dec de
	ld a, (ix+21)
	ld (ix+10), a
	jp _LABEL_C67F

; Data from CA61 to CA64 (4 bytes)
.db $1B $C3 $7F $86

+:
	ld hl, +	; Overriding return address
	jp _LABEL_C715

+:
	inc de
	jp -

++:
	bit 3, a
	jr nz, +
	bit 5, a
	jr nz, ++
	bit 1, a
	jr nz, ++
	bit 0, a
	jr nz, +++
	bit 2, a
	jr nz, +++
	bit 2, (ix+0)
	ret nz
	ld (ix+7), $00
	ld a, $FF
	out (Port_PSG), a
	ret

+:
	ex af, af'
	ld a, $0D
	ld b, $06
	ld c, $E5
	jr ++++

++:
	ld c, $04
	bit 0, a
	jr nz, +
	ld c, $03
+:
	ex af, af'
	ld a, c
	ld b, $07
	ld c, $E4
	jr ++++

+++:
	ld c, $E4
	bit 2, a
	jr z, +
	ld c, $E6
+:
	ex af, af'
	ld a, $03
	ld b, $08
++++:
	ld (ix+7), a
	ex af, af'
	bit 2, a
	jr z, +
	dec b
	dec b
+:
	ld (ix+8), b
	ld a, c
	ld (_RAM_DE08), a
	bit 2, (ix+0)
	ret nz
	out (Port_PSG), a
	ret

_LABEL_CAD0:
	inc (ix+11)
	ld a, (ix+10)
	sub (ix+11)
	call z, _LABEL_C607
	ld (_RAM_DE0C), a
	cp $80
	jp z, +++
	bit 5, (ix+0)
	jp z, +++
	exx
	ld (hl), $80
	exx
	ld a, (ix+18)
	bit 7, a
	jr z, +
	add a, (ix+14)
	jr c, ++
	dec (ix+15)
	jr ++

+:
	add a, (ix+14)
	jr nc, ++
	inc (ix+15)
++:
	ld (ix+14), a
+++:
	bit 2, (ix+0)
	ret nz
	ld a, (ix+19)
	cp $1F
	ret z
	bit 0, (ix+0)
	jr z, +
	ld a, (_RAM_DE0C)
	cp $06
	jr nz, +
	res 0, (ix+0)
_LABEL_CB27:
	ld a, $1F
	ld (ix+19), a
	add a, (ix+1)
	out (Port_PSG), a
	ret

+:
	ld a, (ix+19)
	cp $FF
	jp z, +
	ld a, (ix+7)
	dec a
	jp m, +
	ld hl, _DATA_E995
	call _LABEL_C5B9
	call _LABEL_CB9F
	or (ix+1)
	add a, $10
	out (Port_PSG), a
+:
	ld a, (_RAM_DE0C)
	or a
	jp m, +
	bit 7, (ix+20)
	ret nz
	ld a, (ix+6)
	dec a
	jp p, ++
	ret

+:
	ld a, (ix+6)
	dec a
++:
	ld l, (ix+14)
	ld h, (ix+15)
	jp m, +
	ex de, hl
	ld hl, _DATA_EA69
	call _LABEL_C5B9
	call _LABEL_C5C6
+:
	bit 6, (ix+0)
	ret nz
	ld a, (ix+1)
	cp $E0
	jr nz, +
	ld a, $C0
+:
	ld c, a
	ld a, l
	and $0F
	or c
	out (Port_PSG), a
	ld a, l
	and $F0
	or h
	rrca
	rrca
	rrca
	rrca
	out (Port_PSG), a
	ret

-:
	ld (ix+12), a
_LABEL_CB9F:
	push hl
	ld c, (ix+12)
	ld b, $00
	add hl, bc
	ld c, l
	ld b, h
	pop hl
	ld a, (bc)
	bit 7, a
	jr z, ++++
	cp $82
	jr z, +
	cp $81
	jr z, +++
	cp $80
	jr z, ++
	inc bc
	ld a, (bc)
	jr -

+:
	pop hl
	jp _LABEL_CB27

++:
	xor a
	jr -

+++:
	ld (ix+19), $FF
	pop hl
	ret

++++:
	inc (ix+12)
	add a, (ix+8)
	bit 4, a
	ret z
	ld a, $0F
	ret

_LABEL_CBD7:
	ld a, (ix+8)
	and $0F
	or (ix+1)
	add a, $10
	out (Port_PSG), a
	ret

; Data from CBE4 to CC75 (146 bytes)
.db $00 $00 $FF $03 $C7 $03 $90 $03 $5D $03 $2D $03 $FF $02 $D4 $02
.db $AB $02 $85 $02 $61 $02 $3F $02 $1E $02 $00 $02 $E3 $01 $C8 $01
.db $AF $01 $96 $01 $80 $01 $6A $01 $56 $01 $43 $01 $30 $01 $1F $01
.db $0F $01 $00 $01 $F2 $00 $E4 $00 $D7 $00 $CB $00 $C0 $00 $B5 $00
.db $AB $00 $A1 $00 $98 $00 $90 $00 $88 $00 $80 $00 $79 $00 $72 $00
.db $6C $00 $66 $00 $60 $00 $5B $00 $55 $00 $51 $00 $4C $00 $48 $00
.db $44 $00 $40 $00 $3C $00 $39 $00 $36 $00 $33 $00 $30 $00 $2D $00
.db $2B $00 $28 $00 $26 $00 $24 $00 $22 $00 $20 $00 $1E $00 $1C $00
.db $1B $00 $19 $00 $18 $00 $16 $00 $15 $00 $14 $00 $13 $00 $12 $00
.db $11 $00

; Data from CC76 to CD0A (149 bytes)
_DATA_CC76:
.db $00 $00 $57 $11 $6B $11 $81 $11 $98 $11 $B0 $11 $CA $11 $E5 $11
.db $01 $13 $10 $13 $20 $13 $31 $13 $43 $13 $57 $13 $6B $13 $81 $13
.db $98 $13 $B0 $13 $CA $13 $E5 $13 $01 $15 $10 $15 $20 $15 $31 $15
.db $43 $15 $57 $15 $6B $15 $81 $15 $98 $15 $B0 $15 $CA $15 $E5 $15
.db $01 $17 $10 $17 $20 $17 $31 $17 $43 $17 $57 $17 $6B $17 $81 $17
.db $98 $17 $B0 $17 $CA $17 $E5 $17 $01 $19 $10 $19 $20 $19 $31 $19
.db $43 $19 $57 $19 $6B $19 $81 $19 $98 $19 $B0 $19 $CA $19 $E5 $19
.db $01 $1B $10 $1B $20 $1B $31 $1B $43 $1B $57 $1B $6B $1B $81 $1B
.db $98 $1B $B0 $1B $CA $1B $E5 $1B $01 $1D $10 $1D $20 $1D $31 $1D
.db $43 $1D $FF $FF $01

; Data from CD0B to CD2B (33 bytes)
_DATA_CD0B:
.db $B6 $2A $B5 $36 $B6 $18 $06 $B8 $0C $B5 $36 $AE $02 $B3 $B6 $2C
.db $AE $02 $AF $B3 $B6 $2A $BB $18 $B8 $08 $B5 $BA $B8 $06 $B6 $2A
.db $F2

; 1st entry of Pointer Table from DDB4 (indexed by unknown)
; Data from CD2C to CD7B (80 bytes)
_DATA_CD2C:
.db $9E $12 $06 $18 $99 $12 $06 $06 $12 $95 $12 $06 $18 $99 $12 $06
.db $06 $12 $9B $12 $06 $18 $12 $06 $06 $12 $97 $12 $06 $99 $12 $06
.db $9E $12 $06 $18 $F2 $AE $2A $AC $36 $AD $2A $AC $36 $AE $30 $AF
.db $B3 $18 $B1 $08 $B1 $AF $AE $30 $F2 $B1 $2A $36 $2A $36 $80 $02
.db $B3 $2E $80 $04 $B3 $2C $B6 $18 $B5 $08 $AC $B5 $B1 $30 $F2 $01

; Data from CD7C to CDDD (98 bytes)
_DATA_CD7C:
.db $F8 $B7 $8D $B8 $12 $BA $06 $BB $12 $BF $06 $BE $12 $C1 $06 $C2
.db $C1 $BF $BA $BB $12 $B8 $06 $B3 $08 $B2 $B3 $B5 $2A $F8 $B7 $8D
.db $B8 $12 $B3 $06 $B5 $12 $B1 $06 $B5 $12 $B0 $06 $B1 $12 $06 $B3
.db $12 $06 $B0 $08 $AE $AC $AE $2A $F6 $7C $8D $A9 $06 $AE $12 $A9
.db $06 $B0 $12 $A9 $06 $B1 $09 $B3 $03 $B1 $06 $B0 $AE $12 $06 $B3
.db $12 $AE $06 $B5 $12 $AE $06 $B6 $09 $B8 $03 $B6 $06 $B5 $B3 $12
.db $06 $F9

; 1st entry of Pointer Table from DE10 (indexed by unknown)
; Data from CDDE to CF9E (449 bytes)
_DATA_CDDE:
.db $80 $06 $F8 $22 $8E $F8 $4F $8E $9F $06 $AB $0C $06 $96 $A2 $0C
.db $06 $9B $A7 $99 $A5 $F8 $4F $8E $F8 $49 $8E $F8 $43 $8E $F8 $43
.db $8E $F8 $22 $8E $F8 $4F $8E $99 $06 $A5 $0C $06 $F8 $49 $8E $96
.db $06 $A2 $94 $A0 $9E $06 $AA $0C $06 $F8 $4F $8E $F8 $43 $8E $96
.db $12 $F6 $DE $8D $F8 $43 $8E $F8 $49 $8E $F8 $4F $8E $9E $06 $AA
.db $9D $A9 $9B $06 $A7 $0C $06 $9A $A6 $0C $06 $99 $06 $A5 $0C $06
.db $97 $A3 $96 $A2 $F9 $96 $06 $A2 $0C $06 $F9 $95 $06 $A1 $0C $06
.db $F9 $94 $06 $A0 $0C $06 $F9 $80 $06 $F8 $99 $8E $F8 $C6 $8E $93
.db $06 $9F $0C $06 $96 $A2 $0C $06 $9B $A7 $99 $A5 $F8 $C6 $8E $F8
.db $C0 $8E $F8 $BA $8E $F8 $BA $8E $F8 $99 $8E $F8 $C6 $8E $99 $06
.db $A5 $0C $06 $F8 $C0 $8E $96 $06 $A2 $94 $A0 $92 $06 $9E $0C $06
.db $F8 $C6 $8E $F8 $BA $8E $96 $12 $F6 $55 $8E $F8 $43 $8E $F8 $49
.db $8E $F8 $4F $8E $92 $06 $9E $91 $9D $8F $06 $9B $0C $06 $8E $9A
.db $0C $06 $8D $06 $99 $0C $06 $8B $97 $8A $96 $F9 $96 $06 $A2 $0C
.db $06 $F9 $95 $06 $A1 $0C $06 $F9 $94 $06 $A0 $0C $06 $F9 $80 $06
.db $F8 $15 $8F $AF $06 $AE $AC $0C $B3 $06 $B2 $B3 $0C $B5 $06 $B2
.db $AE $AC $AE $0C $AA $06 $A7 $AC $AB $AC $AF $AA $08 $A9 $AA $AE
.db $06 $AC $A9 $A6 $1E $F8 $15 $8F $AF $0C $AE $06 $AF $B1 $06 $AC
.db $A9 $0C $A9 $06 $A8 $A9 $AD $AE $AC $AA $A9 $AA $0C $A9 $A7 $08
.db $A5 $A4 $A5 $2A $F6 $CC $8E $A5 $12 $06 $A7 $12 $06 $A9 $12 $06
.db $AA $0C $A5 $AA $12 $06 $AC $12 $06 $AE $12 $06 $AA $12 $A9 $06
.db $F9 $80 $06 $F8 $6F $8F $F8 $98 $8F $F8 $98 $8F $F8 $8C $8F $80
.db $06 $A2 $80 $A2 $F8 $98 $8F $F8 $8C $8F $F8 $8C $8F $F8 $8C $8F
.db $F8 $6F $8F $F8 $98 $8F $80 $06 $A0 $0C $06 $F8 $8C $8F $80 $06
.db $9D $80 $9D $F8 $98 $8F $F8 $98 $8F $F8 $8C $8F $9D $12 $F6 $2F
.db $8F $F8 $8C $8F $F8 $8C $8F $F8 $8C $8F $80 $06 $99 $80 $99 $F8
.db $92 $8F $F8 $92 $8F $F8 $92 $8F $80 $06 $92 $80 $92 $F9 $80 $06
.db $9D $0C $06 $F9 $80 $06 $96 $0C $06 $F9 $80 $06 $9B $0C $06 $F9
.db $01

; Data from CF9F to D05C (190 bytes)
_DATA_CF9F:
.db $F8 $2B $90 $B7 $18 $B5 $12 $B8 $B7 $B5 $0C $B8 $F5 $02 $04 $80
.db $06 $BC $03 $03 $BF $06 $BA $03 $03 $BD $06 $B8 $03 $03 $BC $06
.db $B7 $03 $03 $F5 $08 $04 $F8 $2B $90 $B7 $0C $B8 $06 $BA $BC $0C
.db $BA $06 $B8 $B7 $0C $B8 $06 $BA $BC $0C $BA $06 $B8 $B7 $B8 $B7
.db $B5 $B7 $B5 $48 $F8 $47 $90 $F8 $56 $90 $B0 $3C $F8 $47 $90 $F8
.db $56 $90 $B0 $0C $F7 $00 $02 $EE $8F $F8 $56 $90 $B0 $18 $AC $0C
.db $AE $B0 $B1 $12 $AC $B1 $0C $80 $0C $B8 $BA $B8 $BC $12 $B8 $B3
.db $0C $80 $06 $B0 $B1 $B3 $B5 $B7 $B8 $BA $B8 $12 $B5 $BA $0C $B7
.db $12 $B3 $B0 $0C $B8 $06 $B7 $B5 $54 $F6 $9F $8F $80 $06 $F8 $36
.db $90 $A9 $0C $F8 $36 $90 $F9 $A9 $03 $03 $06 $AC $AE $B0 $0C $B3
.db $B0 $06 $AE $AC $AE $B0 $0C $F9 $80 $0C $A9 $06 $AC $B1 $B3 $0C
.db $B5 $B3 $06 $B1 $AC $1E $F9 $B3 $12 $B0 $0C $AE $06 $F9

; 1st entry of Pointer Table from DE6C (indexed by unknown)
; Data from D05D to D1B8 (348 bytes)
_DATA_D05D:
.db $F8 $D7 $90 $F8 $D7 $90 $F8 $E0 $90 $F8 $E0 $90 $F8 $E8 $90 $8E
.db $06 $9A $F7 $00 $04 $6C $90 $8C $98 $F7 $00 $04 $74 $90 $F8 $D7
.db $90 $F8 $D7 $90 $F8 $E8 $90 $F8 $E8 $90 $F8 $F0 $90 $F8 $E8 $90
.db $F8 $D7 $90 $F8 $D7 $90 $F8 $F0 $90 $F8 $F0 $90 $F8 $F8 $90 $94
.db $A0 $F7 $00 $03 $9C $90 $93 $9F $F8 $F0 $90 $F8 $F0 $90 $F8 $F8
.db $90 $93 $9F $F7 $00 $04 $AE $90 $92 $9E $F7 $00 $08 $B5 $90 $F8
.db $D7 $90 $F8 $E0 $90 $F8 $E8 $90 $F8 $E8 $90 $F8 $F0 $90 $F8 $E8
.db $90 $F8 $D7 $90 $F8 $D7 $90 $F6 $5D $90 $91 $06 $9D $F7 $00 $04
.db $D7 $90 $F9 $90 $9C $F7 $00 $04 $E0 $90 $F9 $8F $9B $F7 $00 $04
.db $E8 $90 $F9 $8D $99 $F7 $00 $04 $F0 $90 $F9 $94 $A0 $F7 $00 $04
.db $F8 $90 $F9 $F8 $A1 $91 $AE $18 $AC $12 $B0 $0C $A8 $12 $A7 $A5
.db $0C $F5 $02 $04 $A4 $06 $B0 $B3 $AE $B1 $AC $B0 $AB $F5 $05 $04
.db $F8 $A1 $91 $80 $06 $A9 $12 $AB $AC $0C $AE $06 $B0 $B1 $B3 $0C
.db $B1 $06 $B0 $0C $B0 $06 $AE $AC $AE $AC $18 $12 $0C $06 $AB $A9
.db $A5 $18 $A9 $AC $B1 $B0 $AC $A7 $A4 $0C $AC $06 $AB $AC $18 $A9
.db $AC $B1 $F5 $08 $04 $B0 $12 $AC $0C $AB $06 $AC $0C $F7 $00 $02
.db $4F $91 $B0 $12 $AC $0C $AE $06 $AC $0C $B3 $12 $B0 $0C $AE $06
.db $B0 $0C $F5 $05 $04 $A9 $12 $A5 $A9 $0C $A8 $A5 $A0 $A5 $A6 $12
.db $A7 $AC $0C $80 $06 $A7 $A9 $AB $AC $AE $B0 $B1 $80 $A9 $AB $AC
.db $0C $AE $06 $B0 $B1 $80 $A7 $A9 $AB $0C $06 $AC $AE $B0 $AE $AC
.db $54 $F6 $00 $91 $AC $12 $F8 $AC $91 $AC $18 $F8 $AC $91 $F9 $AB
.db $12 $A9 $0C $A9 $06 $AC $AB $A9 $AB $AC $0C $F9

; Data from D1B9 to D276 (190 bytes)
_DATA_D1B9:
.db $B0 $06 $B1 $B3 $B5 $0C $B3 $06 $B1 $B0 $0C $B1 $06 $B3 $B5 $0C
.db $B3 $06 $B1 $0C $B0 $06 $B2 $B3 $B5 $0C $B3 $06 $B2 $B0 $0C $B2
.db $06 $B3 $B5 $0C $B3 $06 $B2 $0C $F8 $5C $92 $F8 $61 $92 $B3 $12
.db $12 $0C $F8 $61 $92 $F8 $66 $92 $A7 $06 $A5 $0C $F8 $66 $92 $AA
.db $06 $AD $0C $F5 $08 $04 $B1 $12 $12 $B6 $0C $B4 $12 $B0 $B4 $0C
.db $B5 $12 $B0 $AC $0C $B6 $12 $B0 $AD $0C $B7 $12 $B2 $AE $0C $BA
.db $12 $B2 $BA $0C $B9 $12 $B6 $B9 $0C $BE $12 $B9 $B6 $0C $B7 $06
.db $B9 $BA $BC $0C $BE $06 $BF $BE $0C $BC $06 $BA $BC $0C $BA $06
.db $B9 $0C $F7 $00 $02 $27 $92 $B7 $06 $B2 $B7 $B8 $0C $B2 $06 $B8
.db $0C $F7 $00 $02 $40 $92 $B7 $12 $B2 $AF $0C $AB $30 $F5 $0A $04
.db $F6 $E1 $91 $B0 $12 $12 $0C $F9 $B1 $12 $12 $0C $F9 $A4 $06 $A5
.db $A7 $A9 $0C $A7 $06 $A5 $A4 $0C $A5 $06 $A7 $A9 $0C $F9

; 1st entry of Pointer Table from DEC8 (indexed by unknown)
; Data from D277 to D58B (789 bytes)
_DATA_D277:
.db $9D $06 $9E $A0 $A2 $0C $A0 $06 $9E $9D $0C $9E $06 $A0 $A2 $0C
.db $A0 $06 $9E $0C $9D $06 $9F $A0 $A2 $0C $A0 $06 $9F $9D $0C $9F
.db $06 $A0 $A2 $0C $A0 $06 $9F $0C $E3 $FB $00 $0C $91 $06 $9D $9D
.db $91 $9D $9D $91 $9D $F7 $00 $04 $A3 $92 $FB $00 $F4 $E5 $FE $FE
.db $91 $06 $9D $9D $91 $9D $9D $91 $9D $F7 $00 $04 $B7 $92 $F8 $3F
.db $93 $95 $A1 $A1 $95 $A1 $A1 $95 $A1 $94 $A0 $A0 $94 $A0 $A0 $94
.db $A0 $8F $9B $9B $8F $9B $9B $8F $9B $F8 $3F $93 $93 $9F $9F $93
.db $9F $9F $93 $9F $92 $9E $9E $92 $9E $9E $92 $9E $8E $9A $9A $8E
.db $9A $9A $8E $9A $93 $9F $9F $93 $92 $9E $9E $92 $91 $9D $9D $91
.db $90 $9C $9C $90 $8F $9B $9B $8F $8F $9B $9B $8F $8E $9A $9A $8E
.db $92 $9E $9E $92 $93 $9F $9F $93 $94 $A0 $A0 $94 $F7 $00 $02 $1B
.db $93 $93 $9F $9F $93 $9F $9F $93 $9F $FB $00 $0C $93 $9F $9F $93
.db $9D $9A $97 $93 $E3 $F6 $A3 $92 $96 $A2 $A2 $96 $A2 $A2 $96 $A2
.db $F9 $A4 $06 $A5 $A7 $A9 $0C $A7 $06 $A5 $A4 $0C $A5 $06 $A7 $A9
.db $0C $A7 $06 $A5 $0C $A4 $06 $A6 $A7 $A9 $0C $A7 $06 $A6 $A4 $0C
.db $A6 $06 $A7 $A9 $0C $A7 $06 $A6 $0C $AC $12 $12 $0C $F7 $00 $04
.db $70 $93 $E4 $F5 $08 $04 $B0 $12 $12 $0C $B1 $12 $12 $B5 $0C $B0
.db $12 $12 $AD $0C $B0 $30 $AE $12 $12 $0C $AD $12 $A9 $AD $0C $AC
.db $12 $AB $A9 $0C $A7 $12 $AA $A7 $0C $A6 $12 $AB $A6 $0C $B2 $12
.db $AE $AB $0C $AA $12 $AD $B2 $0C $B0 $12 $AE $AD $0C $F5 $0B $04
.db $AE $06 $B0 $B2 $B3 $0C $B5 $06 $B7 $B5 $0C $B3 $06 $B2 $B3 $0C
.db $B2 $06 $B0 $0C $AE $06 $B0 $B2 $B3 $0C $B2 $06 $B0 $AE $0C $B0
.db $06 $B2 $B3 $0C $B2 $06 $B0 $0C $A6 $06 $A2 $A6 $A7 $0C $A9 $06
.db $A7 $0C $F7 $00 $02 $DF $93 $A3 $12 $A9 $A7 $0C $A6 $30 $E5 $F5
.db $0A $04 $F6 $70 $93 $01 $B0 $06 $B1 $B3 $B5 $0C $B3 $06 $B1 $B0
.db $0C $B1 $06 $B3 $B5 $0C $B3 $06 $B1 $0C $B0 $06 $B2 $B3 $B5 $0C
.db $B3 $06 $B2 $B0 $0C $B2 $06 $B3 $B5 $0C $B3 $06 $B2 $0C $F8 $B2
.db $94 $F8 $B7 $94 $B3 $12 $12 $0C $F8 $B7 $94 $FB $00 $0C $F5 $80
.db $B0 $F8 $BC $94 $A7 $06 $A5 $0C $F8 $BC $94 $AA $06 $AD $0C $FB
.db $00 $F4 $F5 $80 $A0 $B1 $12 $12 $B6 $0C $B4 $12 $B0 $B4 $0C $B5
.db $12 $B0 $AC $0C $B6 $12 $B0 $AD $0C $B7 $12 $B2 $AE $0C $BA $12
.db $B2 $BA $0C $B9 $12 $B6 $B9 $0C $BE $12 $B9 $B6 $0C $FB $00 $0C
.db $F5 $80 $B0 $B7 $06 $B9 $BA $BC $0C $BE $06 $BF $BE $0C $BC $06
.db $BA $BC $0C $BA $06 $B9 $0C $F7 $00 $02 $7A $94 $B7 $06 $B2 $B7
.db $B8 $0C $B2 $06 $B8 $0C $F7 $00 $02 $93 $94 $B7 $12 $B2 $AF $0C
.db $AB $30 $F5 $80 $A0 $FB $00 $F4 $F6 $25 $94 $B0 $12 $12 $0C $F9
.db $B1 $12 $12 $0C $F9 $A4 $06 $A5 $A7 $A9 $0C $A7 $06 $A5 $A4 $0C
.db $A5 $06 $A7 $A9 $0C $F9 $A4 $06 $A5 $A7 $A9 $0C $A7 $06 $A5 $A4
.db $0C $A5 $06 $A7 $A9 $0C $A7 $06 $A5 $0C $A4 $06 $A6 $A7 $A9 $0C
.db $A7 $06 $A6 $A4 $0C $A6 $06 $A7 $A9 $0C $A7 $06 $A6 $0C $AC $12
.db $12 $0C $F7 $00 $04 $F5 $94 $FB $00 $0C $F5 $80 $A0 $B0 $12 $12
.db $0C $B1 $12 $12 $B5 $0C $B0 $12 $12 $AD $0C $B0 $30 $FB $00 $F4
.db $AE $12 $12 $0C $AD $12 $A9 $AD $0C $AC $12 $AB $A9 $0C $A7 $12
.db $AA $A7 $0C $A6 $12 $AB $A6 $0C $B2 $12 $AE $AB $0C $AA $12 $AD
.db $B2 $0C $B0 $12 $AE $AD $0C $FB $00 $0C $F5 $80 $A0 $AE $06 $B0
.db $B2 $B3 $0C $B5 $06 $B7 $B5 $0C $B3 $06 $B2 $B3 $0C $B2 $06 $B0
.db $0C $AE $06 $B0 $B2 $B3 $0C $B2 $06 $B0 $AE $0C $B0 $06 $B2 $B3
.db $0C $B2 $06 $B0 $0C $A6 $06 $A2 $A6 $A7 $0C $A9 $06 $A7 $0C $F7
.db $00 $02 $6C $95 $A3 $12 $A9 $A7 $0C $A6 $30 $F5 $80 $60 $FB $00
.db $F4 $F6 $F5 $94 $01

; Data from D58C to D5CF (68 bytes)
_DATA_D58C:
.db $AE $06 $A9 $AE $B0 $B2 $0C $B3 $06 $B5 $0C $B3 $B2 $1E $B3 $1E
.db $B2 $0C $B0 $36 $B0 $06 $A9 $B0 $B2 $0C $B3 $B5 $B7 $B5 $B3 $12
.db $B3 $1E $B2 $06 $B1 $B2 $36 $24 $B0 $0C $B5 $12 $B0 $B5 $0C $B3
.db $12 $B2 $B0 $0C $AE $12 $B0 $AE $0C $B2 $30 $12 $B7 $B5 $0C $B0
.db $60 $F6 $8C $95

; 1st entry of Pointer Table from DF24 (indexed by unknown)
; Data from D5D0 to D665 (150 bytes)
_DATA_D5D0:
.db $F8 $02 $96 $F8 $0D $96 $95 $12 $A1 $12 $0C $F7 $00 $02 $D6 $95
.db $F8 $02 $96 $F8 $0D $96 $93 $12 $9F $12 $0C $92 $12 $9E $12 $0C
.db $91 $12 $9D $12 $0C $F7 $00 $03 $F0 $95 $95 $12 $A1 $12 $0C $F6
.db $D0 $95 $96 $12 $A2 $12 $0C $F7 $00 $02 $02 $96 $F9 $94 $12 $A0
.db $12 $0C $F7 $00 $02 $0D $96 $F9 $01 $A6 $12 $A9 $AB $06 $AD $0C
.db $AB $0C $A9 $1E $A4 $1E $AB $0C $A7 $36 $A7 $12 $A4 $12 $A6 $0C
.db $A7 $A9 $AB $AD $AE $1E $06 $AD $AE $36 $AC $12 $AB $A9 $0C $AC
.db $12 $A7 $AC $0C $A2 $12 $A9 $A7 $0C $A5 $12 $A7 $A5 $0C $A9 $12
.db $A8 $A9 $0C $AE $12 $A7 $A6 $0C $A9 $12 $A8 $A9 $0C $9D $12 $A6
.db $A7 $0C $F6 $19 $96 $01

; Data from D666 to D6CA (101 bytes)
_DATA_D666:
.db $80 $18 $B3 $12 $BA $06 $B8 $B7 $0C $B6 $06 $B6 $03 $B5 $B3 $2A
.db $F7 $00 $02 $68 $96 $B8 $12 $BF $06 $BE $BD $0C $BB $06 $BB $03
.db $BA $B8 $2A $F7 $00 $02 $7B $96 $FB $F4 $00 $B8 $12 $B7 $0C $B8
.db $0C $BA $06 $B8 $03 $BA $B8 $B7 $B8 $BA $BB $BD $BF $C0 $BF $BD
.db $BF $BD $BB $BA $BD $12 $BB $0C $BD $06 $BF $C0 $FB $0C $00 $80
.db $06 $BF $C0 $BA $BE $BF $F7 $00 $02 $B5 $96 $80 $0C $BF $03 $BD
.db $BB $BA $F6 $68 $96

; 1st entry of Pointer Table from DF80 (indexed by unknown)
; Data from D6CB to D868 (414 bytes)
_DATA_D6CB:
.db $80 $06 $A1 $A2 $9E $9B $06 $03 $03 $F7 $00 $10 $D0 $96 $A0 $06
.db $03 $03 $F7 $00 $10 $D9 $96 $9F $06 $03 $03 $F7 $00 $04 $E2 $96
.db $9E $06 $03 $03 $F7 $00 $04 $EB $96 $9C $06 $03 $03 $F7 $00 $04
.db $F4 $96 $9B $06 $03 $03 $F7 $00 $08 $FD $96 $F6 $D0 $96 $80 $06
.db $AD $AE $AA $F8 $76 $97 $B1 $03 $AF $AE $0C $F8 $80 $97 $F8 $76
.db $97 $AE $03 $AC $AA $0C $F8 $80 $97 $F8 $86 $97 $B8 $03 $B6 $B3
.db $0C $F8 $90 $97 $F8 $86 $97 $B3 $03 $B1 $AF $0C $F8 $90 $97 $BB
.db $03 $BA $B8 $0C $F7 $00 $02 $3A $97 $BB $03 $BA $B8 $06 $F7 $01
.db $02 $3A $97 $BD $03 $BB $BA $0C $F7 $00 $02 $4E $97 $BD $03 $BB
.db $BA $06 $AB $03 $AE $B3 $06 $80 $06 $F7 $00 $02 $5D $97 $AB $03
.db $AE $B3 $06 $F7 $01 $02 $5D $97 $F6 $0E $97 $AE $12 $B1 $06 $B0
.db $AF $0C $AE $06 $F9 $C2 $03 $C1 $BF $18 $F9 $B3 $12 $B6 $06 $B5
.db $B4 $0C $B3 $06 $F9 $C7 $03 $C6 $C4 $18 $F9 $80 $06 $AD $AE $AA
.db $AE $12 $B1 $06 $B0 $AF $0C $AE $06 $AE $03 $AC $AA $2A $F7 $00
.db $02 $9B $97 $B3 $12 $B6 $06 $B5 $B4 $0C $B3 $06 $B3 $03 $B1 $AF
.db $2A $F7 $00 $02 $AE $97 $BB $03 $BA $B8 $0C $F7 $00 $02 $C1 $97
.db $BB $03 $BA $B8 $06 $F7 $01 $02 $C1 $97 $BD $03 $BB $BA $0C $F7
.db $00 $02 $D5 $97 $BD $03 $BB $BA $06 $AB $03 $AE $B3 $06 $80 $06
.db $F7 $00 $02 $E4 $97 $AB $03 $AE $B3 $06 $F7 $01 $02 $E4 $97 $F6
.db $9B $97 $80 $06 $B9 $BA $B6 $A7 $12 $AE $06 $AC $AB $0C $AA $06
.db $B1 $03 $AF $AE $0C $C2 $03 $C1 $BF $18 $F7 $00 $02 $02 $98 $AC
.db $12 $B3 $06 $B2 $B1 $0C $AF $06 $B8 $03 $B6 $B3 $0C $C7 $03 $C6
.db $C4 $18 $F7 $00 $02 $1A $98 $B3 $03 $B1 $AF $0C $F7 $00 $02 $32
.db $98 $B3 $03 $B1 $AF $06 $F7 $01 $02 $32 $98 $B4 $03 $B3 $B1 $0C
.db $F7 $00 $02 $46 $98 $B4 $03 $B3 $B1 $06 $80 $06 $B3 $0C $AE $06
.db $AB $A7 $80 $B3 $AE $AB $A7 $0C $80 $18 $F6 $02 $98 $01

; Data from D869 to D876 (14 bytes)
_DATA_D869:
.db $B1 $18 $B5 $B0 $B5 $AE $B1 $0C $B6 $B8 $B6 $B5 $B3 $F2

; 1st entry of Pointer Table from DFDC (indexed by unknown)
; Data from D877 to D88F (25 bytes)
_DATA_D877:
.db $96 $30 $94 $92 $F5 $0A $F0 $E4 $94 $0C $A0 $06 $94 $94 $94 $A0
.db $94 $F2 $01 $A9 $30 $A7 $A5 $B0 $F2

; 1st entry of Pointer Table from E02F (indexed by unknown)
; Data from D890 to D90F (128 bytes)
_DATA_D890:
.db $AE $18 $AF $08 $A7 $20 $A6 $10 $AE $AF $0B $AE $AC $0A $18 $AE
.db $08 $AA $30 $10 $AC $AE $AF $18 $B1 $08 $AC $30 $10 $AE $AF $B3
.db $30 $B5 $09 $B3 $0A $B1 $30 $F4 $00 $B8 $12 $B6 $1E $B8 $12 $B6
.db $1E $B8 $12 $B6 $2A $0C $B5 $B6 $BD $12 $BB $1E $BD $12 $BB $1E
.db $BD $12 $BB $0C $06 $BD $BF $C1 $0C $C4 $0D $C1 $08 $C2 $09 $C4
.db $0A $B8 $12 $B6 $1E $B8 $12 $B6 $1E $B8 $12 $B6 $2A $0C $B8 $BA
.db $BB $12 $BF $0C $06 $C1 $C2 $C1 $12 $C4 $0C $C1 $06 $C2 $07 $C4
.db $08 $C2 $0C $C1 $BF $C1 $C2 $C1 $BF $0D $C1 $16 $C2 $30 $B6 $F2

; 1st entry of Pointer Table from E038 (indexed by unknown)
; Data from D910 to DB67 (600 bytes)
_DATA_D910:
.db $9E $40 $9D $9B $99 $A0 $9F $9E $43 $99 $0C $A5 $06 $99 $99 $99
.db $A5 $99 $F5 $80 $20 $FB $00 $F4 $9E $0C $AA $06 $9E $9E $9E $AA
.db $9E $9D $0C $A9 $06 $9D $9D $9D $A9 $9D $9B $0C $A7 $06 $9B $9B
.db $9B $A7 $9B $99 $0C $A5 $06 $99 $99 $99 $A5 $99 $97 $0C $A3 $06
.db $97 $97 $97 $A3 $97 $96 $0C $A2 $06 $96 $96 $96 $A2 $96 $94 $0C
.db $A0 $06 $94 $94 $94 $A0 $94 $99 $0C $A5 $06 $99 $07 $99 $06 $99
.db $A5 $07 $99 $08 $FE $01 $9E $0C $AA $06 $9E $9E $9E $AA $9E $9D
.db $0C $A9 $06 $9D $9D $9D $A9 $9D $9B $0C $A7 $06 $9B $9B $9B $A7
.db $9B $99 $0C $A5 $06 $99 $99 $99 $A5 $99 $97 $0C $A3 $06 $97 $97
.db $97 $A3 $97 $99 $0C $A5 $06 $99 $99 $99 $A5 $07 $99 $08 $AA $0C
.db $A9 $A7 $A9 $AA $A9 $A7 $0D $A9 $16 $AA $30 $9E $F2 $A9 $30 $A3
.db $10 $A2 $20 $A0 $10 $A6 $A2 $20 $A7 $20 $80 $10 $A7 $30 $30 $A6
.db $10 $A7 $10 $20 $AC $10 $AF $20 $AA $10 $A7 $13 $A9 $1E $06 $AA
.db $AC $F4 $00 $F5 $08 $04 $AE $12 $1E $AE $12 $1E $AE $12 $2A $0C
.db $0C $0C $B3 $12 $1E $B3 $12 $1E $B3 $12 $0C $B6 $06 $BB $BB $B8
.db $0C $BB $0D $B8 $08 $BA $09 $BB $0A $F5 $09 $04 $FE $FF $AE $12
.db $0C $AA $06 $AE $B1 $AE $12 $0C $A9 $06 $AE $B1 $AE $12 $0C $A7
.db $06 $AA $AE $FE $01 $80 $A5 $AA $AE $80 $AE $AF $B1 $B3 $B2 $B3
.db $AF $AA $AF $B1 $B3 $B1 $AF $AC $A9 $A5 $AC $AF $07 $B1 $08 $F5
.db $80 $C3 $80 $03 $AE $B1 $B6 $F7 $00 $06 $42 $9A $80 $03 $AE $B1
.db $B6 $04 $80 $04 $AE $05 $B1 $06 $B5 $07 $F5 $80 $C0 $BA $30 $AE
.db $F2 $AE $18 $AF $08 $A7 $20 $A6 $10 $AE $AF $0B $AE $AC $0A $18
.db $AE $08 $AA $30 $10 $AC $AE $AF $18 $B1 $08 $AC $30 $10 $AE $AF
.db $B3 $30 $B5 $09 $B3 $0A $B1 $30 $F4 $00 $B8 $12 $B6 $1E $B8 $12
.db $B6 $1E $B8 $12 $B6 $2A $0C $B5 $B6 $BD $12 $BB $1E $BD $12 $BB
.db $1E $BD $12 $BB $0C $06 $BD $BF $C1 $0C $C4 $0D $C1 $08 $C2 $09
.db $C4 $0A $B8 $12 $B6 $1E $B8 $12 $B6 $1E $B8 $12 $B6 $2A $0C $B8
.db $BA $BB $12 $BF $0C $06 $C1 $C2 $C1 $12 $C4 $0C $C1 $06 $C2 $07
.db $C4 $08 $F5 $80 $C0 $C2 $0C $C1 $BF $C1 $C2 $C1 $BF $0D $C1 $16
.db $F5 $80 $B0 $C2 $30 $B6 $F2 $A9 $30 $A3 $10 $A2 $20 $A0 $10 $A6
.db $A2 $20 $A7 $20 $80 $10 $A7 $30 $30 $A6 $10 $A7 $10 $20 $AC $10
.db $AF $20 $AA $10 $A7 $13 $A9 $1E $06 $AA $AC $F4 $00 $E4 $B1 $12
.db $1E $B1 $12 $1E $B1 $12 $2A $0C $0C $0C $B6 $12 $1E $B6 $12 $1E
.db $B6 $12 $0C $B3 $06 $B6 $B6 $B1 $0C $0D $08 $09 $0A $B1 $12 $1E
.db $B1 $12 $1E $B1 $12 $1E $F5 $80 $C0 $E5 $80 $0C $AE $B1 $B6 $B6
.db $18 $BB $BD $C1 $1B $F5 $80 $B3 $80 $03 $AE $B1 $B6 $F7 $00 $06
.db $48 $9B $80 $03 $AE $B1 $B6 $04 $80 $04 $AE $05 $B1 $06 $B5 $07
.db $F5 $80 $B0 $AE $30 $A2 $F2 $01

; Data from DB68 to DB82 (27 bytes)
_DATA_DB68:
.db $80 $0C $B7 $B1 $B5 $B4 $18 $AD $0C $AE $80 $AE $B0 $AA $AD $18
.db $AE $0C $B0 $B1 $18 $B3 $0C $B1 $B0 $30 $F2

; 1st entry of Pointer Table from E08B (indexed by unknown)
; Data from DB83 to DB95 (19 bytes)
_DATA_DB83:
.db $A1 $30 $A0 $9E $9D $9C $9D $F2 $01 $A6 $30 $A5 $A7 $A5 $A2 $A5
.db $18 $A4 $F2

; Data from DB96 to DBEF (90 bytes)
_DATA_DB96:
.db $80 $0C $B3 $B5 $B6 $B5 $B1 $B3 $B5 $B3 $AF $B1 $B3 $B2 $AF $B2
.db $B5 $80 $0C $B3 $B5 $B6 $B5 $B1 $B5 $B8 $B6 $B1 $B6 $BA $B8 $06
.db $AF $B1 $B3 $B5 $B6 $B8 $B1 $F8 $D6 $9B $B5 $AC $B1 $B3 $B5 $B6
.db $B8 $B1 $F8 $D6 $9B $B5 $AE $AF $AE $B2 $AE $B5 $AE $F6 $96 $9B
.db $B6 $06 $AE $B1 $B5 $B6 $AE $B1 $B8 $B5 $AC $B1 $B3 $B5 $AC $B1
.db $B6 $B3 $AA $AF $B1 $B3 $AA $AF $B6 $F9

; 1st entry of Pointer Table from E0D5 (indexed by unknown)
; Data from DBF0 to DC94 (165 bytes)
_DATA_DBF0:
.db $F8 $6A $9C $E3 $B5 $E6 $AC $E3 $B1 $E6 $AC $E3 $B3 $E6 $AC $E3
.db $B5 $E6 $AC $E3 $B3 $E6 $AA $E3 $AF $E6 $AA $E3 $B1 $E6 $AA $E3
.db $B3 $E6 $AA $E3 $B2 $E6 $AE $E3 $AF $E6 $AE $E3 $B2 $E6 $AE $E3
.db $B5 $E6 $AE $F8 $6A $9C $E3 $B5 $E6 $AC $E3 $B1 $E6 $AC $E3 $B5
.db $E6 $B1 $E3 $B8 $E6 $B1 $E3 $B6 $E6 $AE $E3 $B1 $E6 $AE $E3 $B6
.db $E6 $B1 $E3 $AE $E6 $B1 $E3 $B8 $E6 $AF $B1 $B3 $E3 $B5 $B1 $B5
.db $B8 $F8 $7B $9C $B5 $AC $B1 $B3 $B5 $B6 $B8 $B1 $F8 $7B $9C $B5
.db $AE $AF $AE $B2 $AE $B5 $AE $F6 $F0 $9B $E6 $80 $06 $AE $E3 $B3
.db $E6 $AE $E3 $B5 $E6 $AE $E3 $B6 $E6 $AE $F9 $B6 $06 $AE $B1 $B5
.db $B6 $AE $B1 $B8 $B5 $AC $B1 $B3 $B5 $AC $B1 $B6 $B3 $AA $AF $B1
.db $B3 $AA $AF $B6 $F9

; 1st entry of Pointer Table from E0DE (indexed by unknown)
; Data from DC95 to DD6F (219 bytes)
_DATA_DC95:
.db $9B $30 $A5 $A3 $A2 $9B $A5 $A2 $99 $9E $A5 $A3 $A5 $9E $A5 $A3
.db $A2 $F6 $95 $9C $01 $B6 $18 $B8 $B8 $BA $BA $BB $0C $BA $BA $18
.db $B8 $08 $B6 $B5 $B6 $18 $B8 $BD $B8 $B1 $B1 $AF $0C $B5 $B8 $BB
.db $F5 $80 $10 $F0 $B0 $E5 $F8 $EA $9C $BD $18 $BA $08 $BB $BA $BA
.db $18 $B8 $F8 $EA $9C $BD $0C $BB $BA $BB $B8 $30 $F5 $80 $20 $F0
.db $B0 $E6 $F6 $AA $9C $BA $18 $08 $BB $BA $BA $18 $B8 $08 $BD $BF
.db $F9 $E4 $F8 $4D $9D $80 $06 $AC $F7 $00 $04 $FA $9C $80 $06 $AA
.db $F7 $00 $04 $02 $9D $F8 $4D $9D $F8 $4D $9D $80 $06 $AC $80 $AC
.db $80 $B1 $80 $B1 $80 $06 $AE $80 $AE $80 $B1 $80 $B1 $B8 $AF $B1
.db $B3 $B5 $B6 $B8 $B1 $80 $01 $FB $00 $0C $E6 $F8 $56 $9D $B5 $AC
.db $B1 $B3 $B5 $B6 $B8 $B1 $F8 $56 $9D $B5 $AE $AF $AE $B2 $AE $B5
.db $AE $05 $FB $00 $F4 $F6 $F6 $9C $80 $06 $AE $F7 $00 $04 $4D $9D
.db $F9 $B6 $06 $AE $B1 $B5 $B6 $AE $B1 $B8 $B5 $AC $B1 $B3 $B5 $AC
.db $B1 $B6 $B3 $AA $AF $B1 $B3 $AA $AF $B6 $F9

; 1st entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from DD70 to DD73 (4 bytes)
_DATA_DD70:
.db $06 $80 $10 $01

; Pointer Table from DD74 to DD75 (1 entries, indexed by unknown)
.dw _DATA_CD0B

; Data from DD76 to DDA6 (49 bytes)
.db $F8 $00 $70 $02 $80 $11 $01 $2C $8D $F8 $00 $F0 $03 $80 $12 $01
.db $51 $8D $F8 $00 $90 $03 $80 $13 $01 $65 $8D $F8 $00 $50 $03 $80
.db $14 $01 $0A $8D $F8 $00 $10 $01 $C0 $00 $01 $F6 $A0 $00 $00 $00
.db $0F

; 1st entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from DDA7 to DDAA (4 bytes)
_DATA_DDA7:
.db $04 $80 $80 $01

; Pointer Table from DDAB to DDAC (1 entries, indexed by unknown)
.dw _DATA_CD0B

; Data from DDAD to DDB3 (7 bytes)
.db $EC $00 $08 $03 $80 $A0 $01

; Pointer Table from DDB4 to DDB5 (1 entries, indexed by unknown)
.dw _DATA_CD2C

; Data from DDB6 to DDCB (22 bytes)
.db $EC $00 $0A $06 $80 $C0 $01 $51 $8D $EC $00 $05 $04 $C0 $E0 $01
.db $F6 $A0 $00 $00 $00 $0F

; 2nd entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from DDCC to DDCF (4 bytes)
_DATA_DDCC:
.db $06 $80 $10 $01

; Pointer Table from DDD0 to DDD1 (1 entries, indexed by unknown)
.dw _DATA_CD7C

; Data from DDD2 to DE02 (49 bytes)
.db $FA $00 $70 $02 $80 $11 $01 $55 $8E $FA $00 $E0 $03 $80 $12 $01
.db $CC $8E $06 $00 $70 $04 $80 $13 $01 $2F $8F $FA $00 $60 $05 $80
.db $14 $01 $7B $8D $FA $00 $10 $01 $C0 $00 $01 $38 $A1 $00 $00 $00
.db $0F

; 2nd entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from DE03 to DE06 (4 bytes)
_DATA_DE03:
.db $04 $80 $80 $01

; Pointer Table from DE07 to DE08 (1 entries, indexed by unknown)
.dw _DATA_CD7C

; Data from DE09 to DE0F (7 bytes)
.db $ED $00 $08 $02 $80 $A0 $01

; Pointer Table from DE10 to DE11 (1 entries, indexed by unknown)
.dw _DATA_CDDE

; Data from DE12 to DE27 (22 bytes)
.db $ED $00 $0B $05 $80 $C0 $01 $CC $8E $ED $00 $08 $05 $C0 $E0 $01
.db $38 $A1 $00 $00 $00 $0F

; 3rd entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from DE28 to DE2B (4 bytes)
_DATA_DE28:
.db $06 $80 $10 $01

; Pointer Table from DE2C to DE2D (1 entries, indexed by unknown)
.dw _DATA_CF9F

; Data from DE2E to DE5E (49 bytes)
.db $FA $00 $70 $03 $80 $11 $01 $5D $90 $FA $00 $E0 $04 $80 $12 $01
.db $00 $91 $FA $00 $70 $04 $80 $13 $01 $9E $8F $06 $00 $A0 $06 $80
.db $14 $01 $00 $91 $06 $00 $A0 $06 $C0 $00 $01 $B5 $A1 $00 $00 $00
.db $0F

; 3rd entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from DE5F to DE62 (4 bytes)
_DATA_DE5F:
.db $04 $80 $80 $01

; Pointer Table from DE63 to DE64 (1 entries, indexed by unknown)
.dw _DATA_CF9F

; Data from DE65 to DE6B (7 bytes)
.db $E9 $00 $08 $03 $80 $A0 $01

; Pointer Table from DE6C to DE6D (1 entries, indexed by unknown)
.dw _DATA_D05D

; Data from DE6E to DE83 (22 bytes)
.db $F5 $00 $0A $05 $80 $C0 $01 $00 $91 $E9 $00 $05 $05 $C0 $E0 $01
.db $97 $A2 $00 $00 $00 $0F

; 4th entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from DE84 to DE87 (4 bytes)
_DATA_DE84:
.db $06 $80 $10 $01

; Pointer Table from DE88 to DE89 (1 entries, indexed by unknown)
.dw _DATA_D1B9

; Data from DE8A to DEBA (49 bytes)
.db $F7 $00 $70 $03 $80 $11 $01 $77 $92 $F7 $00 $E0 $03 $80 $12 $01
.db $48 $93 $F7 $00 $70 $05 $80 $13 $01 $FC $93 $F7 $00 $A0 $05 $80
.db $14 $01 $CD $94 $F7 $00 $60 $06 $C0 $00 $01 $80 $A3 $00 $00 $00
.db $0F

; 4th entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from DEBB to DEBE (4 bytes)
_DATA_DEBB:
.db $04 $80 $80 $01

; Pointer Table from DEBF to DEC0 (1 entries, indexed by unknown)
.dw _DATA_D1B9

; Data from DEC1 to DEC7 (7 bytes)
.db $E7 $00 $0A $03 $80 $A0 $01

; Pointer Table from DEC8 to DEC9 (1 entries, indexed by unknown)
.dw _DATA_D277

; Data from DECA to DEDF (22 bytes)
.db $F3 $00 $0B $06 $80 $C0 $01 $48 $93 $E7 $00 $0A $05 $C0 $E0 $01
.db $80 $A3 $00 $00 $00 $0F

; 5th entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from DEE0 to DEE3 (4 bytes)
_DATA_DEE0:
.db $06 $80 $10 $01

; Pointer Table from DEE4 to DEE5 (1 entries, indexed by unknown)
.dw _DATA_D58C

; Data from DEE6 to DF16 (49 bytes)
.db $FD $00 $C0 $02 $80 $11 $01 $D0 $95 $FD $00 $20 $04 $80 $12 $01
.db $19 $96 $FD $00 $30 $06 $80 $13 $01 $8B $95 $09 $00 $30 $07 $80
.db $14 $01 $18 $96 $09 $00 $C0 $07 $C0 $00 $01 $3D $A4 $00 $00 $00
.db $0F

; 5th entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from DF17 to DF1A (4 bytes)
_DATA_DF17:
.db $04 $80 $80 $01

; Pointer Table from DF1B to DF1C (1 entries, indexed by unknown)
.dw _DATA_D58C

; Data from DF1D to DF23 (7 bytes)
.db $F0 $00 $08 $03 $80 $A0 $01

; Pointer Table from DF24 to DF25 (1 entries, indexed by unknown)
.dw _DATA_D5D0

; Data from DF26 to DF3B (22 bytes)
.db $F0 $00 $0B $06 $80 $C0 $01 $19 $96 $F0 $00 $09 $06 $C0 $E0 $01
.db $3D $A4 $00 $00 $00 $0F

; 6th entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from DF3C to DF3F (4 bytes)
_DATA_DF3C:
.db $06 $80 $10 $01

; Pointer Table from DF40 to DF41 (1 entries, indexed by unknown)
.dw _DATA_D666

; Data from DF42 to DF72 (49 bytes)
.db $F4 $00 $70 $03 $80 $11 $01 $CB $96 $F4 $00 $F0 $04 $80 $12 $01
.db $96 $97 $00 $00 $70 $05 $80 $13 $01 $FD $97 $F4 $00 $10 $02 $80
.db $14 $01 $65 $96 $F4 $00 $10 $02 $C0 $00 $01 $4A $A4 $00 $00 $00
.db $0F

; 6th entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from DF73 to DF76 (4 bytes)
_DATA_DF73:
.db $04 $80 $80 $01

; Pointer Table from DF77 to DF78 (1 entries, indexed by unknown)
.dw _DATA_D666

; Data from DF79 to DF7F (7 bytes)
.db $E7 $00 $08 $03 $80 $A0 $01

; Pointer Table from DF80 to DF81 (1 entries, indexed by unknown)
.dw _DATA_D6CB

; Data from DF82 to DF97 (22 bytes)
.db $E7 $00 $0A $04 $80 $C0 $01 $09 $97 $E7 $00 $09 $05 $C0 $E0 $01
.db $4A $A4 $00 $00 $00 $0F

; 7th entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from DF98 to DF9B (4 bytes)
_DATA_DF98:
.db $06 $80 $10 $01

; Pointer Table from DF9C to DF9D (1 entries, indexed by unknown)
.dw _DATA_D869

; Data from DF9E to DFCE (49 bytes)
.db $FA $00 $10 $02 $80 $11 $01 $77 $98 $FA $00 $E0 $04 $80 $12 $01
.db $8A $98 $FA $00 $10 $02 $80 $13 $01 $68 $98 $FA $00 $70 $06 $80
.db $14 $01 $89 $98 $FA $00 $70 $06 $C0 $00 $01 $B1 $A4 $00 $00 $00
.db $0F

; 7th entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from DFCF to DFD2 (4 bytes)
_DATA_DFCF:
.db $04 $80 $80 $01

; Pointer Table from DFD3 to DFD4 (1 entries, indexed by unknown)
.dw _DATA_D869

; Data from DFD5 to DFDB (7 bytes)
.db $E7 $00 $08 $03 $80 $A0 $01

; Pointer Table from DFDC to DFDD (1 entries, indexed by unknown)
.dw _DATA_D877

; Data from DFDE to DFF3 (22 bytes)
.db $F3 $00 $08 $04 $80 $C0 $01 $8A $98 $E7 $00 $08 $03 $C0 $E0 $01
.db $B1 $A4 $00 $00 $00 $0F

; 8th entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from DFF4 to DFF7 (4 bytes)
_DATA_DFF4:
.db $06 $80 $10 $01

; Pointer Table from DFF8 to DFFB (2 entries, indexed by unknown)
.dw _DATA_D890 $01F6

; Data from DFFC to E02A (47 bytes)
.db $C0 $03 $80 $11 $01 $10 $99 $02 $00 $10 $03 $80 $12 $01 $BD $99
.db $F6 $01 $C0 $05 $80 $13 $01 $61 $9A $02 $01 $B0 $05 $80 $14 $01
.db $E7 $9A $02 $01 $B0 $05 $C0 $00 $01 $C9 $A4 $00 $00 $00 $0F

; 8th entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from E02B to E02E (4 bytes)
_DATA_E02B:
.db $04 $80 $80 $01

; Pointer Table from E02F to E030 (1 entries, indexed by unknown)
.dw _DATA_D890

; Data from E031 to E037 (7 bytes)
.db $EF $00 $08 $04 $80 $A0 $01

; Pointer Table from E038 to E039 (1 entries, indexed by unknown)
.dw _DATA_D910

; Data from E03A to E04F (22 bytes)
.db $EF $00 $08 $06 $80 $C0 $01 $BD $99 $EF $00 $09 $06 $C0 $E0 $01
.db $C9 $A4 $00 $00 $00 $0F

; 9th entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from E050 to E053 (4 bytes)
_DATA_E050:
.db $06 $80 $10 $01

; Pointer Table from E054 to E055 (1 entries, indexed by unknown)
.dw _DATA_DB68

; Data from E056 to E07D (40 bytes)
.db $FA $00 $B0 $04 $80 $11 $01 $83 $9B $FA $00 $A0 $04 $80 $12 $01
.db $8C $9B $FA $00 $A0 $04 $80 $13 $01 $67 $9B $FA $00 $90 $05 $80
.db $14 $01 $8B $9B $FA $00 $90 $05

; 9th entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from E07E to E081 (4 bytes)
_DATA_E07E:
.db $04 $80 $80 $01

; Pointer Table from E082 to E083 (1 entries, indexed by unknown)
.dw _DATA_DB68

; Data from E084 to E08A (7 bytes)
.db $EF $00 $08 $03 $80 $A0 $01

; Pointer Table from E08B to E08C (1 entries, indexed by unknown)
.dw _DATA_DB83

; Data from E08D to E099 (13 bytes)
.db $EF $00 $05 $04 $80 $C0 $01 $8C $9B $EF $00 $09 $04

; 10th entry of Pointer Table from C29F (indexed by _RAM_DE03)
; Data from E09A to E09D (4 bytes)
_DATA_E09A:
.db $06 $80 $10 $01

; Pointer Table from E09E to E09F (1 entries, indexed by unknown)
.dw _DATA_DB96

; Data from E0A0 to E0D0 (49 bytes)
.db $F8 $00 $C0 $02 $80 $11 $01 $95 $9C $F8 $00 $E0 $04 $80 $12 $01
.db $AA $9C $F8 $00 $20 $06 $80 $13 $01 $F6 $9C $F8 $00 $C0 $04 $80
.db $14 $01 $A9 $9C $F8 $00 $B0 $06 $C0 $00 $01 $1B $A5 $00 $00 $00
.db $0F

; 10th entry of Pointer Table from C241 (indexed by _RAM_DE03)
; Data from E0D1 to E0D4 (4 bytes)
_DATA_E0D1:
.db $04 $80 $80 $01

; Pointer Table from E0D5 to E0D6 (1 entries, indexed by unknown)
.dw _DATA_DBF0

; Data from E0D7 to E0DD (7 bytes)
.db $EC $00 $08 $04 $80 $A0 $01

; Pointer Table from E0DE to E0DF (1 entries, indexed by unknown)
.dw _DATA_DC95

; Data from E0E0 to E540 (1121 bytes)
.incbin "banks\lots_DATA_E0E0.inc"

; 1st entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E541 to E54A (10 bytes)
_DATA_E541:
.db $01 $A8 $15 $01 $55 $A5 $D0 $00 $03 $00

; 1st entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E54B to E54E (4 bytes)
_DATA_E54B:
.db $01 $A8 $E0 $01

; Pointer Table from E54F to E550 (1 entries, indexed by unknown)
.dw _DATA_E563

; Data from E551 to E562 (18 bytes)
.db $FE $00 $00 $00 $FF $51 $33 $03 $06 $43 $30 $12 $FB $00 $B8 $30
.db $07 $F2

; Data from E563 to E567 (5 bytes)
_DATA_E563:
.db $00 $04 $02 $07 $F2

; 2nd entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E568 to E56D (6 bytes)
_DATA_E568:
.db $01 $A8 $15 $01 $7C $A5

; Pointer Table from E56E to E56F (1 entries, indexed by unknown)
.db $FB $03

; Data from E570 to E571 (2 bytes)
.db $03 $00

; 2nd entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E572 to E575 (4 bytes)
_DATA_E572:
.db $01 $A8 $E0 $01

; Pointer Table from E576 to E577 (1 entries, indexed by unknown)
.dw _DATA_E58A

; Data from E578 to E589 (18 bytes)
.db $00 $00 $00 $00 $FF $51 $31 $02 $05 $72 $60 $02 $FB $01 $B8 $30
.db $03 $F2

; Data from E58A to E58E (5 bytes)
_DATA_E58A:
.db $00 $3F $07 $04 $F2

; 3rd entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E58F to E598 (10 bytes)
_DATA_E58F:
.db $01 $A8 $15 $01 $A3 $A5 $00 $00 $03 $00

; 3rd entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E599 to E59C (4 bytes)
_DATA_E599:
.db $01 $A8 $E0 $01

; Pointer Table from E59D to E5A0 (2 entries, indexed by unknown)
.dw _DATA_E5B1 $01F6

; Data from E5A1 to E5B0 (16 bytes)
.db $00 $00 $FF $F7 $60 $02 $06 $83 $D3 $F1 $7A $00 $70 $2E $05 $F2

; Data from E5B1 to E5B9 (9 bytes)
_DATA_E5B1:
.db $00 $19 $00 $01 $00 $21 $FA $07 $F2

; 4th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E5BA to E5CC (19 bytes)
_DATA_E5BA:
.db $02 $80 $14 $01 $E0 $A5 $F2 $05 $53 $00 $80 $15 $01 $E0 $A5 $F0
.db $05 $53 $00

; 4th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E5CD to E5D0 (4 bytes)
_DATA_E5CD:
.db $02 $80 $A0 $01

; Pointer Table from E5D1 to E5D2 (1 entries, indexed by unknown)
.dw _DATA_E5E7

; Data from E5D3 to E5E6 (20 bytes)
.db $E0 $05 $00 $00 $80 $C0 $01 $E7 $A5 $DE $05 $00 $00 $BA $03 $BC
.db $BE $C3 $06 $F2

; Data from E5E7 to E5ED (7 bytes)
_DATA_E5E7:
.db $BA $03 $BC $BE $C3 $06 $F2

; 5th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E5EE to E5F3 (6 bytes)
_DATA_E5EE:
.db $02 $80 $14 $01 $14 $A6

; Pointer Table from E5F4 to E5F7 (2 entries, indexed by unknown)
.dw $0314 $0053

; Data from E5F8 to E600 (9 bytes)
.db $80 $15 $01 $14 $A6 $10 $03 $53 $00

; 5th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E601 to E604 (4 bytes)
_DATA_E601:
.db $02 $80 $A0 $01

; Pointer Table from E605 to E606 (1 entries, indexed by unknown)
.dw _DATA_E614

; Data from E607 to E613 (13 bytes)
.db $00 $00 $05 $00 $80 $C0 $01 $14 $A6 $FC $00 $05 $00

; Data from E614 to E622 (15 bytes)
_DATA_E614:
.db $A3 $02 $A2 $03 $A5 $02 $FB $02 $02 $F7 $00 $03 $14 $A6 $F2

; 6th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E623 to E635 (19 bytes)
_DATA_E623:
.db $02 $80 $14 $01 $49 $A6 $08 $01 $C3 $00 $80 $15 $01 $5B $A6 $08
.db $01 $C3 $00

; 6th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E636 to E639 (4 bytes)
_DATA_E636:
.db $02 $80 $A0 $01

; Pointer Table from E63A to E63B (1 entries, indexed by unknown)
.dw _DATA_E649

; Data from E63C to E648 (13 bytes)
.db $EC $00 $09 $00 $80 $C0 $01 $5B $A6 $EC $00 $09 $00

; Data from E649 to E66E (38 bytes)
_DATA_E649:
.db $A9 $03 $A5 $03 $F7 $00 $03 $49 $A6 $AC $03 $A9 $03 $B1 $03 $AC
.db $03 $F2 $80 $02 $A9 $03 $A5 $03 $F7 $00 $03 $5B $A6 $AC $03 $A9
.db $03 $B1 $03 $AC $03 $F2

; 7th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E66F to E674 (6 bytes)
_DATA_E66F:
.db $02 $88 $14 $01 $95 $A6

; Pointer Table from E675 to E676 (1 entries, indexed by unknown)
.dw $0009

; Data from E677 to E681 (11 bytes)
.db $A3 $00 $88 $15 $01 $9C $A6 $0E $00 $A3 $00

; 7th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E682 to E685 (4 bytes)
_DATA_E682:
.db $02 $88 $A0 $01

; Pointer Table from E686 to E687 (1 entries, indexed by unknown)
.dw _DATA_E6A3

; Data from E688 to E6A2 (27 bytes)
.db $F0 $00 $0E $00 $88 $C0 $01 $AA $A6 $F0 $00 $0E $00 $00 $C2 $03
.db $01 $29 $02 $F2 $00 $B6 $02 $01 $0B $03 $F2

; Data from E6A3 to E6B0 (14 bytes)
_DATA_E6A3:
.db $00 $E0 $03 $01 $19 $02 $F2 $00 $9A $02 $01 $4A $03 $F2

; 8th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E6B1 to E6BA (10 bytes)
_DATA_E6B1:
.db $01 $A8 $15 $01 $C5 $A6 $30 $01 $60 $00

; 8th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E6BB to E6BE (4 bytes)
_DATA_E6BB:
.db $01 $A8 $C0 $01

; Pointer Table from E6BF to E6C0 (1 entries, indexed by unknown)
.dw _DATA_E6D1

; Data from E6C1 to E6D0 (16 bytes)
.db $00 $00 $00 $00 $00 $B0 $60 $06 $EF $01 $F7 $00 $05 $C5 $A6 $F2

; Data from E6D1 to E6DC (12 bytes)
_DATA_E6D1:
.db $00 $B0 $60 $06 $EF $02 $F7 $00 $05 $D1 $A6 $F2

; 9th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E6DD to E6E6 (10 bytes)
_DATA_E6DD:
.db $01 $A8 $15 $01 $F1 $A6 $00 $00 $00 $00

; 9th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E6E7 to E6EA (4 bytes)
_DATA_E6E7:
.db $01 $A8 $E0 $01

; Pointer Table from E6EB to E6EC (1 entries, indexed by unknown)
.dw _DATA_E6FF

; Data from E6ED to E6FE (18 bytes)
.db $00 $01 $00 $00 $FF $31 $20 $06 $06 $90 $42 $46 $6F $01 $98 $E6
.db $07 $F2

; Data from E6FF to E703 (5 bytes)
_DATA_E6FF:
.db $00 $80 $E3 $07 $F2

; 10th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E704 to E70D (10 bytes)
_DATA_E704:
.db $01 $A0 $15 $01 $18 $A7 $14 $05 $B3 $00

; 10th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E70E to E711 (4 bytes)
_DATA_E70E:
.db $01 $A0 $C0 $01

; Pointer Table from E712 to E713 (1 entries, indexed by unknown)
.dw _DATA_E71D

; Data from E714 to E71C (9 bytes)
.db $11 $05 $06 $00 $81 $B0 $06 $10 $F2

; Data from E71D to E721 (5 bytes)
_DATA_E71D:
.db $81 $F9 $02 $10 $F2

; 11th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E722 to E727 (6 bytes)
_DATA_E722:
.db $01 $A8 $15 $01 $36 $A7

; Pointer Table from E728 to E729 (1 entries, indexed by unknown)
.dw $0030

; Data from E72A to E72B (2 bytes)
.db $03 $00

; 11th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E72C to E72F (4 bytes)
_DATA_E72C:
.db $01 $A8 $E0 $01

; Pointer Table from E730 to E733 (2 entries, indexed by unknown)
.dw _DATA_E748 $030E

; Data from E734 to E747 (20 bytes)
.db $01 $00 $FF $F6 $3A $02 $05 $A6 $42 $08 $3A $02 $38 $0B $02 $02
.db $98 $79 $02 $F2

; Data from E748 to E754 (13 bytes)
_DATA_E748:
.db $00 $10 $10 $01 $00 $12 $10 $01 $00 $17 $10 $01 $F2

; 12th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E755 to E75E (10 bytes)
_DATA_E755:
.db $01 $80 $15 $01 $69 $A7 $03 $00 $50 $00

; 12th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E75F to E762 (4 bytes)
_DATA_E75F:
.db $01 $80 $C0 $01

; Pointer Table from E763 to E764 (1 entries, indexed by unknown)
.dw _DATA_E76C

; Data from E765 to E76B (7 bytes)
.db $FA $00 $00 $00 $C1 $02 $F2

; Data from E76C to E76E (3 bytes)
_DATA_E76C:
.db $B5 $02 $F2

; 13th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E76F to E774 (6 bytes)
_DATA_E76F:
.db $01 $88 $15 $01 $83 $A7

; Pointer Table from E775 to E778 (2 entries, indexed by unknown)
.dw $0030 $0063

; 13th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E779 to E77C (4 bytes)
_DATA_E779:
.db $01 $88 $C0 $01

; Pointer Table from E77D to E780 (2 entries, indexed by unknown)
.dw _DATA_E787 $0008

; Data from E781 to E786 (6 bytes)
.db $00 $00 $03 $80 $05 $F2

; Data from E787 to E78A (4 bytes)
_DATA_E787:
.db $03 $00 $05 $F2

; 14th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E78B to E794 (10 bytes)
_DATA_E78B:
.db $01 $88 $15 $01 $9F $A7 $F0 $00 $00 $00

; 14th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E795 to E798 (4 bytes)
_DATA_E795:
.db $01 $88 $E0 $01

; Pointer Table from E799 to E79A (1 entries, indexed by unknown)
.dw _DATA_E7AF

; Data from E79B to E7AE (20 bytes)
.db $FF $00 $03 $00 $FF $6F $F0 $00 $05 $F3 $F6 $F5 $FF $01 $30 $03
.db $01 $60 $03 $F2

; Data from E7AF to E7B7 (9 bytes)
_DATA_E7AF:
.db $F3 $06 $00 $50 $03 $00 $80 $03 $F2

; 15th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E7B8 to E7C1 (10 bytes)
_DATA_E7B8:
.db $01 $A8 $15 $01 $CC $A7 $04 $00 $03 $00

; 15th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E7C2 to E7C5 (4 bytes)
_DATA_E7C2:
.db $01 $A8 $E0 $01

; Pointer Table from E7C6 to E7C9 (2 entries, indexed by unknown)
.dw _DATA_E7E5 $030E

; Data from E7CA to E7E4 (27 bytes)
.db $00 $00 $FF $30 $30 $00 $07 $35 $70 $3F $68 $00 $17 $63 $03 $03
.db $FF $00 $02 $EF $01 $F7 $00 $08 $CC $A7 $F2

; Data from E7E5 to E7F0 (12 bytes)
_DATA_E7E5:
.db $00 $2E $E1 $04 $EF $01 $F7 $00 $08 $E5 $A7 $F2

; 16th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E7F1 to E7F6 (6 bytes)
_DATA_E7F1:
.db $01 $A8 $15 $01 $05 $A8

; Pointer Table from E7F7 to E7F8 (1 entries, indexed by unknown)
.dw $0040

; Data from E7F9 to E7FA (2 bytes)
.db $00 $00

; 16th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E7FB to E7FE (4 bytes)
_DATA_E7FB:
.db $01 $A8 $E0 $01

; Pointer Table from E7FF to E800 (1 entries, indexed by unknown)
.dw _DATA_E817

; Data from E801 to E816 (22 bytes)
.db $F0 $00 $00 $00 $FF $60 $32 $01 $06 $90 $81 $76 $6F $03 $05 $7D
.db $03 $02 $01 $68 $03 $F2

; Data from E817 to E81F (9 bytes)
_DATA_E817:
.db $00 $44 $04 $02 $00 $13 $16 $03 $F2

; 17th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E820 to E825 (6 bytes)
_DATA_E820:
.db $01 $A8 $15 $01 $34 $A8

; Pointer Table from E826 to E827 (1 entries, indexed by unknown)
.dw $0015

; Data from E828 to E829 (2 bytes)
.db $00 $00

; 17th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E82A to E82D (4 bytes)
_DATA_E82A:
.db $01 $A0 $E0 $01

; Pointer Table from E82E to E82F (1 entries, indexed by unknown)
.dw _DATA_E84F

; Data from E830 to E84E (31 bytes)
.db $2E $05 $00 $00 $FF $21 $7A $04 $06 $61 $70 $B3 $F7 $00 $95 $80
.db $02 $00 $A2 $00 $01 $F7 $00 $03 $34 $A8 $00 $95 $10 $01 $F2

; Data from E84F to E853 (5 bytes)
_DATA_E84F:
.db $C8 $13 $26 $0B $F2

; 18th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E854 to E866 (19 bytes)
_DATA_E854:
.db $02 $80 $14 $01 $7A $A8 $02 $00 $30 $00 $80 $15 $01 $82 $A8 $02
.db $00 $30 $00

; 18th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E867 to E86A (4 bytes)
_DATA_E867:
.db $02 $80 $A0 $01

; Pointer Table from E86B to E86E (2 entries, indexed by unknown)
.dw _DATA_E88A $01F4

; Data from E86F to E889 (27 bytes)
.db $00 $00 $80 $C0 $01 $92 $A8 $F4 $01 $00 $00 $B6 $03 $B5 $B3 $B6
.db $B5 $05 $F2 $A7 $06 $A2 $AD $04 $A9 $A4 $F2

; Data from E88A to E899 (16 bytes)
_DATA_E88A:
.db $B6 $03 $B5 $B3 $B6 $B5 $05 $F2 $A7 $06 $A2 $AD $04 $A9 $A4 $F2

; 19th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E89A to E8A3 (10 bytes)
_DATA_E89A:
.db $01 $A8 $15 $01 $AE $A8 $00 $00 $03 $00

; 19th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E8A4 to E8A7 (4 bytes)
_DATA_E8A4:
.db $01 $A8 $E0 $01

; Pointer Table from E8A8 to E8AD (3 entries, indexed by unknown)
.dw _DATA_E8BC $030E $0010

; Data from E8AE to E8BB (14 bytes)
.db $FF $31 $31 $05 $06 $F2 $52 $0A $DF $01 $A0 $D0 $06 $F2

; Data from E8BC to E8C0 (5 bytes)
_DATA_E8BC:
.db $00 $1E $F8 $07 $F2

; 20th entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E8C1 to E8CA (10 bytes)
_DATA_E8C1:
.db $01 $A8 $15 $01 $D5 $A8 $00 $00 $B0 $00

; 20th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E8CB to E8CE (4 bytes)
_DATA_E8CB:
.db $01 $A8 $C0 $01

; Pointer Table from E8CF to E8D0 (1 entries, indexed by unknown)
.dw _DATA_E8DA

; Data from E8D1 to E8D9 (9 bytes)
.db $30 $09 $02 $00 $00 $D0 $60 $06 $F2

; Data from E8DA to E8DE (5 bytes)
_DATA_E8DA:
.db $00 $A0 $10 $06 $F2

; 21st entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E8DF to E8F1 (19 bytes)
_DATA_E8DF:
.db $02 $80 $14 $01 $05 $A9 $00 $03 $A3 $00 $80 $15 $01 $05 $A9 $FD
.db $03 $A3 $00

; 21st entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E8F2 to E8F5 (4 bytes)
_DATA_E8F2:
.db $02 $80 $A0 $01

; Pointer Table from E8F6 to E8F7 (1 entries, indexed by unknown)
.dw _DATA_E90A

; Data from E8F8 to E909 (18 bytes)
.db $EA $03 $00 $01 $80 $C0 $01 $0A $A9 $E7 $03 $00 $01 $A0 $02 $9C
.db $02 $F2

; Data from E90A to E90E (5 bytes)
_DATA_E90A:
.db $A0 $02 $9C $02 $F2

; 22nd entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E90F to E914 (6 bytes)
_DATA_E90F:
.db $01 $A8 $15 $01 $23 $A9

; Pointer Table from E915 to E916 (1 entries, indexed by unknown)
.dw $0010

; Data from E917 to E918 (2 bytes)
.db $00 $00

; 22nd entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E919 to E91C (4 bytes)
_DATA_E919:
.db $01 $A8 $E0 $01

; Pointer Table from E91D to E91E (1 entries, indexed by unknown)
.dw _DATA_E949

; Data from E91F to E948 (42 bytes)
.db $00 $05 $00 $00 $FF $A1 $C0 $04 $06 $F0 $F2 $FF $F6 $02 $30 $45
.db $04 $02 $03 $20 $04 $02 $80 $10 $04 $02 $50 $74 $04 $02 $60 $00
.db $04 $02 $40 $01 $04 $02 $20 $D0 $09 $F2

; Data from E949 to E965 (29 bytes)
_DATA_E949:
.db $00 $30 $45 $04 $00 $03 $20 $04 $00 $80 $10 $04 $00 $50 $74 $04
.db $00 $60 $00 $04 $00 $40 $01 $04 $00 $30 $E0 $07 $F2

; 23rd entry of Pointer Table from C2BD (indexed by _RAM_DE03)
; Data from E966 to E96B (6 bytes)
_DATA_E966:
.db $01 $A8 $15 $01 $7A $A9

; Pointer Table from E96C to E96D (1 entries, indexed by unknown)
.dw $0010

; Data from E96E to E96F (2 bytes)
.db $00 $00

; 23rd entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E970 to E973 (4 bytes)
_DATA_E970:
.db $01 $A8 $C0 $01

; Pointer Table from E974 to E977 (2 entries, indexed by unknown)
.dw _DATA_E98C $0010

; Data from E978 to E98B (20 bytes)
.db $00 $00 $FF $30 $31 $02 $05 $31 $30 $83 $8F $00 $60 $85 $03 $00
.db $D3 $55 $04 $F2

; Data from E98C to E994 (9 bytes)
_DATA_E98C:
.db $01 $40 $65 $03 $01 $B3 $35 $04 $F2

; Pointer Table from E995 to E9B4 (16 entries, indexed by _RAM_DE55)
_DATA_E995:
.dw _DATA_E9B5 _DATA_E9B8 _DATA_E9C5 _DATA_E9C8 _DATA_E9D1 _DATA_E9DC _DATA_E9FB _DATA_EA06
.dw _DATA_EA15 _DATA_EA21 _DATA_EA2A _DATA_EA33 _DATA_EA3C _DATA_EA3F _DATA_EA50 _DATA_EA5C

; 1st entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from E9B5 to E9B7 (3 bytes)
_DATA_E9B5:
.db $00 $02 $82

; 2nd entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from E9B8 to E9C4 (13 bytes)
_DATA_E9B8:
.db $00 $00 $01 $02 $03 $04 $05 $06 $07 $08 $09 $0A $82

; 3rd entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from E9C5 to E9C7 (3 bytes)
_DATA_E9C5:
.db $03 $00 $82

; 4th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from E9C8 to E9D0 (9 bytes)
_DATA_E9C8:
.db $01 $00 $00 $00 $00 $00 $01 $01 $82

; 5th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from E9D1 to E9DB (11 bytes)
_DATA_E9D1:
.db $02 $01 $00 $01 $02 $02 $03 $03 $04 $04 $81

; 6th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from E9DC to E9FA (31 bytes)
_DATA_E9DC:
.db $05 $02 $00 $00 $01 $01 $02 $02 $02 $02 $03 $03 $03 $03 $04 $04
.db $04 $04 $05 $05 $05 $05 $06 $06 $06 $06 $07 $07 $07 $08 $81

; 7th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from E9FB to EA05 (11 bytes)
_DATA_E9FB:
.db $04 $04 $03 $03 $02 $02 $01 $01 $02 $02 $81

; 8th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from EA06 to EA14 (15 bytes)
_DATA_EA06:
.db $00 $00 $01 $01 $02 $02 $02 $03 $03 $03 $03 $04 $04 $05 $81

; 9th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from EA15 to EA20 (12 bytes)
_DATA_EA15:
.db $00 $00 $01 $01 $01 $02 $04 $03 $02 $02 $83 $04

; 10th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from EA21 to EA29 (9 bytes)
_DATA_EA21:
.db $00 $01 $02 $04 $05 $06 $07 $0A $82

; 11th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from EA2A to EA32 (9 bytes)
_DATA_EA2A:
.db $01 $00 $01 $01 $03 $04 $07 $0A $82

; 12th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from EA33 to EA3B (9 bytes)
_DATA_EA33:
.db $02 $00 $00 $00 $01 $02 $03 $04 $82

; 13th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from EA3C to EA3E (3 bytes)
_DATA_EA3C:
.db $00 $00 $82

; 14th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from EA3F to EA4F (17 bytes)
_DATA_EA3F:
.db $00 $00 $00 $00 $00 $00 $04 $05 $06 $07 $08 $09 $0A $0B $0E $0F
.db $82

; 15th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from EA50 to EA5B (12 bytes)
_DATA_EA50:
.db $00 $00 $01 $01 $03 $03 $04 $05 $05 $05 $83 $04

; 16th entry of Pointer Table from E995 (indexed by _RAM_DE55)
; Data from EA5C to EA68 (13 bytes)
_DATA_EA5C:
.db $08 $06 $03 $00 $01 $03 $04 $05 $06 $07 $09 $0A $82

; Pointer Table from EA69 to EA7A (9 entries, indexed by _RAM_DE74)
_DATA_EA69:
.dw _DATA_EA7B _DATA_EA91 _DATA_EAAA _DATA_EAC2 _DATA_EACB _DATA_EAD2 _DATA_EAD6 _DATA_EADE
.dw _DATA_EAE1

; 1st entry of Pointer Table from EA69 (indexed by _RAM_DE74)
; Data from EA7B to EA90 (22 bytes)
_DATA_EA7B:
.db $01 $01 $01 $01 $01 $01 $01 $01 $01 $01 $00 $00 $01 $01 $01 $01
.db $01 $01 $00 $00 $01 $00

; 2nd entry of Pointer Table from EA69 (indexed by _RAM_DE74)
; Data from EA91 to EAA9 (25 bytes)
_DATA_EA91:
.db $00 $00 $01 $00 $03 $00 $01 $01 $01 $00 $00 $01 $02 $03 $02 $02
.db $02 $01 $00 $00 $00 $01 $03 $07 $02

; 3rd entry of Pointer Table from EA69 (indexed by _RAM_DE74)
; Data from EAAA to EAC1 (24 bytes)
_DATA_EAAA:
.db $00 $01 $02 $03 $05 $03 $01 $00 $01 $02 $04 $02 $01 $00 $01 $02
.db $03 $05 $03 $02 $01 $00 $83 $40

; 4th entry of Pointer Table from EA69 (indexed by _RAM_DE74)
; Data from EAC2 to EACA (9 bytes)
_DATA_EAC2:
.db $00 $50 $00 $01 $01 $00 $00 $83 $04

; 5th entry of Pointer Table from EA69 (indexed by _RAM_DE74)
; Data from EACB to EAD1 (7 bytes)
_DATA_EACB:
.db $57 $18 $11 $00 $3F $01 $80

; 6th entry of Pointer Table from EA69 (indexed by _RAM_DE74)
; Data from EAD2 to EAD5 (4 bytes)
_DATA_EAD2:
.db $01 $01 $0A $80

; 7th entry of Pointer Table from EA69 (indexed by _RAM_DE74)
; Data from EAD6 to EADD (8 bytes)
_DATA_EAD6:
.db $01 $0B $02 $0B $01 $0B $02 $0B

; 8th entry of Pointer Table from EA69 (indexed by _RAM_DE74)
; Data from EADE to EAE0 (3 bytes)
_DATA_EADE:
.db $02 $1B $80

; 9th entry of Pointer Table from EA69 (indexed by _RAM_DE74)
; Data from EAE1 to EAEC (12 bytes)
_DATA_EAE1:
.db $01 $51 $11 $53 $05 $53 $01 $50 $01 $52 $04 $82