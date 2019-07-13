; This disassembly was created using Emulicious (http://www.emulicious.net)
.MEMORYMAP
SLOTSIZE $7FF0
SLOT 0 $0000
SLOTSIZE $10
SLOT 1 $7FF0
SLOTSIZE $4000
SLOT 2 $8000
DEFAULTSLOT 2
.ENDME

.ROMBANKMAP
BANKSTOTAL 16
BANKSIZE $7FF0
BANKS 1
BANKSIZE $10
BANKS 1
BANKSIZE $4000
BANKS 14
.ENDRO

.EMPTYFILL $FF

.include "lots.constants.asm"
.include "lots.ramlayout.asm"

.BANK 0 SLOT 0
.ORG $0000

_LABEL_0:
	di
	ld sp, $C07F
	im 1
	jr _LABEL_82

; Data from 8 to 8 (1 bytes)
_DATA_8:
.db $FF

; Data from 9 to A (2 bytes)
_DATA_9:
.db $FF $FF

; Data from B to F (5 bytes)
_DATA_B:
.db $FF $FF $FF $FF $FF

; Data from 10 to 14 (5 bytes)
_DATA_10:
.db $FF $FF $FF $FF $FF

; Data from 15 to 2F (27 bytes)
_DATA_15:
.db $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF
.db $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF

; Data from 30 to 37 (8 bytes)
_DATA_30:
.db $FF $FF $FF $FF $FF $FF $FF $FF

_IRQ_HANDLER:
	jp HandleIRQ

; Data from 3B to 3F (5 bytes)
.db $FF $FF $FF $FF $FF

; Data from 40 to 52 (19 bytes)
_DATA_40:
.db $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF
.db $FF $FF $FF

; Data from 53 to 62 (16 bytes)
_DATA_53:
.db $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF

; Data from 63 to 65 (3 bytes)
_DATA_63:
.db $FF $FF $FF

_NMI_HANDLER:
	push af
	ld a, (_RAM_C118)
	cp $07
	jr nz, +
	ld a, (_RAM_C13F)
	or a
	jr nz, +
	ld a, (_RAM_C0A7)
	cpl
	ld (_RAM_C0A7), a
	ld a, Building_Status_Map_Screen
	ld (_RAM_BUILDING_STATUS), a
+:
	pop af
	ret

_LABEL_82:
	ld a, (_RAM_C000)
	ld (_RAM_C000), a
	ld a, $00
	ld (_RAM_FFFB), a
	ld a, $80
	ld (_RAM_FFFC), a
	ld a, $00
	ld (_RAM_FFFD), a
	ld a, $01
	ld (_RAM_FFFE), a
	ld a, :Bank2
	ld (_RAM_FFFF), a
	ld hl, _RAM_C000
	ld de, _RAM_C000 + 1
	ld bc, $2000
	ld (hl), $00
	ldir
	call _LABEL_3AA
	ld a, $92
	out (_PORT_DF), a
	ld a, $01
	ld (_RAM_SWORD_DAMAGE), a
	ld (_RAM_BOW_DAMAGE), a
	ld a, $5E ; Harfoot (L)
	ld (_RAM_CONTINUE_MAP), a
_LABEL_C2:
	ld bc, $8001
	call SendVDPCommand
	call _LABEL_38E
	ld a, :Bank3
	ld (_RAM_FFFF), a
	call _LABEL_C989
	call _LABEL_209
	ld hl, _RAM_MAP_STATUS
	ld de, _RAM_MAP_STATUS + 1
	ld bc, $0B5F
	ld (hl), $00
	ldir
	call _LABEL_3CE
	call _LABEL_3C2
	call _LABEL_3B7
	ld bc, $E001
	call SendVDPCommand
	ld a, $03
	ld (_RAM_MAP_STATUS), a
_LABEL_F7:
	ld a, $01
	ld (_RAM_GAME_LOOP_IS_RUNNING), a
-:
	ei
	ld a, (_RAM_GAME_LOOP_IS_RUNNING)
	or a
	jp nz, -
	ld a, (_RAM_MAP_STATUS)
	ld hl, _DATA_114
CallFunctionFromPointerTable:
	add a, a
	ld e, a
	ld d, $00
	add hl, de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	jp (hl)

; Jump Table from 114 to 121 (7 entries, indexed by _RAM_MAP_STATUS)
_DATA_114:
.dw Handle_Map_Status_Reset
.dw Handle_Map_Status_Map
.dw Handle_Map_Status_Sega_Logo
.dw Handle_Map_Status_Title_Screen
.dw Handle_Map_Status_Demo
.dw Handle_Map_Status_Start_Game
.dw Handle_Map_Status_Story

; 1st entry of Jump Table from 114 (indexed by _RAM_MAP_STATUS)
Handle_Map_Status_Reset:
	jp _LABEL_C2

HandleIRQ:
	di
	push af
	in a, (Port_VDPStatus)
	rlca
	jp nc, _LABEL_1BC
	push hl
	push bc
	push de
	push ix
	push iy
	ld a, (_RAM_GAME_LOOP_IS_RUNNING)
	or a
	jr z, _LABEL_1B2
	ld a, (_RAM_C0A2)
	or a
	jr z, +
	ld a, $FF
	ld (_RAM_C134), a
	ld bc, $4F0A
	call SendVDPCommand
	ld a, (_RAM_BACKGROUND_SCROLL_X)
	out (Port_VDPAddress), a
	ld a, $88
	out (Port_VDPAddress), a
+:
	in a, (Port_IOPort2)
	bit 4, a
	jp nz, +
	xor a ; Map_Status_Reset
	ld (_RAM_MAP_STATUS), a
	jp _LABEL_1A6

+:
	ld a, (_RAM_C0A7)
	or a
	jr nz, _LABEL_1A6
	ld a, (_RAM_C0A2)
	or a
	jp nz, +
	ld a, (_RAM_C111)
	out (Port_VDPAddress), a
	ld a, $88
	out (Port_VDPAddress), a
+:
	call _LABEL_1A12
	call _LABEL_40C
	ld a, (_RAM_C420)
	or a
	jp z, +
	call _LABEL_A2D
	jp _LABEL_1A6

+:
	call _LABEL_2AA
	call UpdateScoreCounter
	call DrawHealthBar
	call _LABEL_14F8
	call _LABEL_543A
	call _LABEL_69D4
	call _LABEL_20A2
	call _LABEL_218C
	call _LABEL_60B
_LABEL_1A6:
	xor a
	ld (_RAM_GAME_LOOP_IS_RUNNING), a
	ld a, :Bank3
	ld (_RAM_FFFF), a
	call SoundEngine
_LABEL_1B2:
	pop iy
	pop ix
	pop de
	pop bc
	pop hl
	pop af
	ei
	ret

_LABEL_1BC:
	push bc
	ld a, (_RAM_C134)
	or a
	jr z, ++
	xor a
	ld (_RAM_C134), a
	ld a, (_RAM_C111)
	ld c, a
	ld a, (_RAM_C114)
	or a
	jp nz, +
	inc c
+:
	ld a, c
	out (Port_VDPAddress), a
	ld a, $88
	out (Port_VDPAddress), a
	ld a, $FF
	out (Port_VDPAddress), a
	ld a, $8A
	out (Port_VDPAddress), a
++:
	pop bc
	pop af
	ei
	ret

; Data from 1E6 to 1F3 (14 bytes)
.db $AF $32 $BE $C0 $3E $F5 $D3 $3F $DB $DD $E6 $C0 $FE $C0

; Data from 1F4 to 1F5 (2 bytes)
_DATA_1F4:
.db $C0 $3E

; Data from 1F6 to 208 (19 bytes)
_DATA_1F6:
.db $55 $D3 $3F $DB $DD $E6 $C0 $B7 $C0 $3E $FF $D3 $DE $3E $01 $32
.db $BE $C0 $C9

_LABEL_209:
	ld a, (_RAM_C000)
	cpl
	and $E8
	cp $20
	jp z, +
	cp $40
	jp z, +
	cp $80
	jp z, +
	ld a, $A8
	ld (_RAM_C000), a
+:
	ld a, (_RAM_C000)
	or $04
	out (Port_MemoryControl), a
	ld bc, $0700
-:
	ld a, b
	and $01
	out (Port_AudioControl), a
	ld e, a
	in a, (Port_AudioControl)
	and $07
	cp e
	jr nz, +
	inc c
+:
	djnz -
	ld a, c
	cp $07
	jr z, +
	xor a
+:
	and $01
	out (Port_AudioControl), a
	ld (_RAM_DE00), a
	ld a, (_RAM_C000)
	out (Port_MemoryControl), a
	ret

; 2nd entry of Jump Table from 114 (indexed by _RAM_MAP_STATUS)
Handle_Map_Status_Map:
	ld a, (_RAM_BUILDING_STATUS)
	or a
	jr nz, +
	call ProcessObjects
	call UpdateLandauGraphics
	call _LABEL_540B
	call ProcessWarpsAndDoors
	call _LABEL_467
	jp _LABEL_F7

+:
	ld hl, _DATA_26E - 2
	jp CallFunctionFromPointerTable

; Jump Table from 26E to 279 (6 entries, indexed by _RAM_BUILDING_STATUS)
_DATA_26E:
.dw Handle_Building_Status_Load_Map
.dw Handle_Building_Status_Building
.dw Handle_Building_Status_Boss_Fight
.dw Handle_Building_Status_Map_Screen
.dw Handle_Building_Status_Ending
.dw Handle_Building_Status_Death

; 1st entry of Jump Table from 26E (indexed by _RAM_BUILDING_STATUS)
Handle_Building_Status_Load_Map:
	call _LABEL_52BC
	jp _LABEL_F7

; 2nd entry of Jump Table from 26E (indexed by _RAM_BUILDING_STATUS)
Handle_Building_Status_Building:
	call _LABEL_1F39
	jp _LABEL_F7

; 3rd entry of Jump Table from 26E (indexed by _RAM_BUILDING_STATUS)
Handle_Building_Status_Boss_Fight:
	call ProcessObjects
	call UpdateLandauGraphics
	call _LABEL_59CF
	call _LABEL_467
	jp _LABEL_F7

; 4th entry of Jump Table from 26E (indexed by _RAM_BUILDING_STATUS)
Handle_Building_Status_Map_Screen:
	call _LABEL_58B7
	jp _LABEL_F7

; 5th entry of Jump Table from 26E (indexed by _RAM_BUILDING_STATUS)
Handle_Building_Status_Ending:
	call _LABEL_6E95
	jp _LABEL_F7

; 6th entry of Jump Table from 26E (indexed by _RAM_BUILDING_STATUS)
Handle_Building_Status_Death:
	call _LABEL_2E5
	call _LABEL_467
	jp _LABEL_F7

_LABEL_2AA:
	ld a, (_RAM_MAP_STATUS)
	cp Map_Status_Demo
	jr z, +
	ld hl, _RAM_CONTROLLER_INPUT
	in a, (Port_IOPort1)
	or $C0
-:
	cpl
	ld c, a
	xor (hl)
	ld (hl), c
	inc hl
	and c
	ld (hl), a
	ret

+:
	ld a, (_RAM_C17B)
	cpl
	ld (_RAM_C17B), a
	or a
	ret z
	ld hl, (_RAM_C17C)
	inc hl
	ld (_RAM_C17C), hl
	ld a, h
	cp $02
	jr nz, +
	ld hl, $0000
	ld (_RAM_C17C), hl
+:
	ld de, _DATA_6C95
	add hl, de
	ld a, (hl)
	ld hl, _RAM_CONTROLLER_INPUT
	jr -

_LABEL_2E5:
	ld a, (_RAM_C108)
	cp $02
	jr z, +
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	and Button_1_Mask|Button_2_Mask
	jr nz, ++
+:
	ld hl, (_RAM_C107)
	dec hl
	ld (_RAM_C107), hl
	ld a, h
	or l
	ret nz
++:
	xor a ; Map_Status_Reset
	ld (_RAM_MAP_STATUS), a
	ret

SendVDPCommand:
	ld a, b
	out (Port_VDPAddress), a
	ld a, c
	or $80
	out (Port_VDPAddress), a
	ret

; Data from 30B to 30D (3 bytes)
.db $7B $D3 $BF

; Data from 30E to 313 (6 bytes)
_DATA_30E:
.db $7A $D3 $BF $F5 $F1 $DB

; Data from 314 to 315 (2 bytes)
_DATA_314:
.db $BE $C9

_LABEL_316:
	push af
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	pop af
	out (Port_VDPData), a
	ret

_LABEL_321:
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
-:
	ld a, h
	out (Port_VDPData), a
	dec bc
	ld a, b
	or c
	jp nz, -
	ret

_LABEL_331:
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
-:
	ld a, h
	out (Port_VDPData), a
	push af
	pop af
	ld a, l
	out (Port_VDPData), a
	dec bc
	ld a, b
	or c
	jp nz, -
	ret

LoadVDPData:
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
-:
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	dec bc
	ld a, c
	or b
	jp nz, -
	ret

; Data from 357 to 357 (1 bytes)
.db $7B

; 5th entry of Pointer Table from 3C13A (indexed by unknown)
; Data from 358 to 358 (1 bytes)
_DATA_358:
.db $D3

; 4th entry of Pointer Table from 3C13A (indexed by unknown)
; Data from 359 to 359 (1 bytes)
_DATA_359:
.db $BF

; 1st entry of Pointer Table from 3C146 (indexed by unknown)
; Data from 35A to 35A (1 bytes)
_DATA_35A:
.db $7A

; 6th entry of Pointer Table from 3C13A (indexed by unknown)
; Data from 35B to 35B (1 bytes)
_DATA_35B:
.db $D3

; 3rd entry of Pointer Table from 3C13A (indexed by unknown)
; Data from 35C to 35C (1 bytes)
_DATA_35C:
.db $BF

; 1st entry of Pointer Table from 3C152 (indexed by unknown)
; Data from 35D to 35E (2 bytes)
_DATA_35D:
.db $5E $23

; 3rd entry of Pointer Table from 3C152 (indexed by unknown)
; Data from 35F to 35F (1 bytes)
_DATA_35F:
.db $7E

; 2nd entry of Pointer Table from 3C152 (indexed by unknown)
; Data from 360 to 36C (13 bytes)
_DATA_360:
.db $D3 $BE $7B $F5 $F1 $D3 $BE $0B $79 $B0 $C2 $5E $03

; 1st entry of Pointer Table from 3C1BE (indexed by unknown)
; Data from 36D to 36D (1 bytes)
_DATA_36D:
.db $C9

_LABEL_36E:
	push bc
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	ld b, c
	ld c, Port_VDPData
-:
	outi
	nop
	jr nz, -
	ex de, hl
	ld bc, $0040
	add hl, bc
	ex de, hl
	pop bc
	djnz _LABEL_36E
	ret

_LABEL_387:
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	ret

_LABEL_38E:
	ld hl, _DATA_39F
	ld e, $0B
	ld c, $00
-:
	ld b, (hl)
	call SendVDPCommand
	inc hl
	inc c
	dec e
	jr nz, -
	ret

; Data from 39F to 3A9 (11 bytes)
_DATA_39F:
.db $06 $80 $FF $FF $FF $FF $FB $00 $00 $00 $FF

_LABEL_3AA:
	ld b, $02
--:
	ld de, $FFFF
-:
	dec de
	ld a, d
	or e
	jr nz, -
	djnz --
	ret

_LABEL_3B7:
	ld de, $7F00
	ld bc, $0040
	ld h, $E0
	jp _LABEL_321

_LABEL_3C2:
	ld de, $7800
	ld bc, $0380
	ld hl, $0000
	jp _LABEL_331

_LABEL_3CE:
	ld hl, _DATA_3EC
_LABEL_3D1:
	ld de, $C000
	ld bc, $0020
	jp LoadVDPData

_LABEL_3DA:
	ld de, $C000
	ld bc, $0010
	jp LoadVDPData

_LABEL_3E3:
	ld de, $C010
	ld bc, $0010
	jp LoadVDPData

; Data from 3EC to 3FA (32 bytes)
_DATA_3EC:
.db $00 $3F $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
.db $00 $3F $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

_LABEL_40C:
	ld c, Port_VDPData
	ld hl, _RAM_C300
	ld de, $7F00
	ld b, $40
	call +
	ld hl, _RAM_C360
	ld de, $7F80
	ld b, $80
+:
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	otir
	ret

; Data from 42A to 466 (61 bytes)
.db $06 $10 $AF $29 $17 $BB $38 $03 $93 $CB $C5 $10 $F6 $C9 $3E $10
.db $CB $23 $CB $12 $ED $6A $38 $09 $ED $42 $30 $08 $09 $3D $20 $F0
.db $C9 $B7 $ED $42 $1C $3D $20 $E8 $C9 $21 $00 $00 $3E $10 $29 $EB
.db $ED $6A $EB $30 $04 $09 $30 $01 $13 $3D $20 $F2 $C9

_LABEL_467:
	ld a, :Bank2
	ld (_RAM_FFFF), a
	ld hl, _RAM_C300
	ld (_RAM_C0A8), hl
	ld hl, _RAM_C360
	ld (_RAM_C0AA), hl
	ld b, $18
	ld iy, _RAM_C400
	ld de, $0040
	ld a, (_RAM_C106)
	cpl
	ld (_RAM_C106), a
	or a
	jr z, _LABEL_492
	ld iy, _RAM_C9C0
	ld de, $FFC0
_LABEL_492:
	push bc
	push de
	ld a, (iy+3)
	or a
	call nz, +
	pop de
	add iy, de
	pop bc
	djnz _LABEL_492
	ld hl, (_RAM_C0A8)
	ld (hl), $D0
	ret

+:
	ld a, (iy+11)
	dec a
	jp z, +
	inc a
	jp z, +
	inc a
	ret nz
+:
	ld a, (iy+14)
	add a, a
	ld e, a
	ld d, $00
	ld h, (iy+5)
	ld l, (iy+4)
	add hl, de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld b, (hl)
	inc hl
	ld (_RAM_C0AC), hl
-:
	ld a, (hl)
	add a, (iy+7)
	dec a
	ld c, a
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld h, (iy+11)
	ld l, (iy+10)
	add hl, de
	ld a, h
	or a
	jr nz, +
	ld a, l
	ld hl, (_RAM_C0A8)
	ld (hl), c
	inc hl
	ld (_RAM_C0A8), hl
	ld hl, (_RAM_C0AC)
	ld de, $0003
	add hl, de
	ld c, (hl)
	ld hl, (_RAM_C0AA)
	ld (hl), a
	inc hl
	ld (hl), c
	inc hl
	ld (_RAM_C0AA), hl
+:
	ld hl, (_RAM_C0AC)
	ld de, $0004
	add hl, de
	ld (_RAM_C0AC), hl
	djnz -
	ret

; 4th entry of Jump Table from 114 (indexed by _RAM_MAP_STATUS)
Handle_Map_Status_Title_Screen:
	ld a, (_RAM_C100)
	or a
	jp nz, _LABEL_56F
	ld bc, $8001
	call SendVDPCommand
	ld a, $01
	ld (_RAM_C100), a
	ld hl, $0340
	ld (_RAM_DEMO_TIMER), hl
	ld a, :Bank5
	ld (_RAM_FFFF), a
	ld hl, _DATA_COMPRESSED_TITLE_SCREEN_TILES_
	ld de, $4000
	call _LABEL_1DC8
	ld hl, _DATA_152F8
	ld de, $7800
	ld a, $20
	call _LABEL_1E9A
	ld hl, _DATA_15539
	call _LABEL_3DA
	ld de, $C010
	ld bc, $0010
	ld h, $00
	call _LABEL_321
	ld a, $01
	ld (_RAM_C16F), a
	ld c, $00
	ld a, (_RAM_CONTINUES_USED)
	cp $0A
	jr z, +
	or a
	jr z, +
	ld c, $01
+:
	ld a, c
	ld (_RAM_C170), a
	ld a, $81
	ld (_RAM_SOUND_TO_PLAY), a
	ld bc, $E001
	call SendVDPCommand
	jp _LABEL_F7

_LABEL_56F:
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	and Button_1_Mask|Button_2_Mask
	jr nz, ++
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	ld c, a
	bit ButtonUp, c
	call nz, _LABEL_5F8
	bit ButtonDown, c
	call nz, _LABEL_602
	ld hl, (_RAM_DEMO_TIMER)
	dec hl
	ld (_RAM_DEMO_TIMER), hl
	ld a, h
	or l
	jr z, +
	jp _LABEL_F7

+:
	ld a, Map_Status_Demo
	ld (_RAM_MAP_STATUS), a
	jp _LABEL_F7

++:
	ld a, Map_Status_Story
	ld (_RAM_MAP_STATUS), a
	ld a, (_RAM_C170)
	or a
	jr z, +
	ld hl, _RAM_CONTINUES_USED
	inc (hl)
	ld a, (hl)
	cp $0B
	jp c, _LABEL_F7
	call ++
	xor a
	ld a, $01
	ld (_RAM_CONTINUES_USED), a
	jp _LABEL_F7

+:
	call ++
	ld a, $01
	ld (_RAM_CONTINUES_USED), a
	jp _LABEL_F7

++:
	ld bc, $C001
	call SendVDPCommand
	ld a, :Bank3
	ld (_RAM_FFFF), a
	call _LABEL_C989
	ld hl, _RAM_FLAG_TREE_SPIRIT_DEFEATED
	ld de, _RAM_FLAG_TREE_SPIRIT_DEFEATED + 1
	ld bc, $03FF
	ld (hl), $00
	ldir
	xor a
	ld (_RAM_C170), a
	ld a, $01
	ld (_RAM_SWORD_DAMAGE), a
	ld (_RAM_BOW_DAMAGE), a
	ld a, $5E ; Harfoot (L)
	ld (_RAM_CONTINUE_MAP), a
	ld bc, $E001
	jp SendVDPCommand

_LABEL_5F8:
	ld a, $01
	ld (_RAM_C16F), a
	xor a
	ld (_RAM_C170), a
	ret

_LABEL_602:
	ld a, $01
	ld (_RAM_C16F), a
	ld (_RAM_C170), a
	ret

_LABEL_60B:
	ld a, (_RAM_MAP_STATUS)
	cp Map_Status_Title_Screen
	ret nz
	ld hl, _RAM_C16F
	ld a, (hl)
	or a
	ret z
	ld (hl), $00
	inc hl
	ld a, (hl)
	ld hl, _DATA_62D
	or a
	jr z, +
	ld hl, _DATA_631
+:
	ld de, $7D54
	ld bc, $0202
	jp _LABEL_36E

; Data from 62D to 630 (4 bytes)
_DATA_62D:
.db $AC $00 $B3 $00

; Data from 631 to 634 (4 bytes)
_DATA_631:
.db $A9 $00 $E1 $00

; 3rd entry of Jump Table from 114 (indexed by _RAM_MAP_STATUS)
Handle_Map_Status_Sega_Logo:
	ld a, (_RAM_C176)
	or a
	jr nz, +
	ld bc, $8001
	call SendVDPCommand
	ld a, $01
	ld (_RAM_C176), a
	ld a, :Bank2
	ld (_RAM_FFFF), a
	call _LABEL_3C2
	ld hl, _DATA_COMPRESSED_SEGA_LOGO_TILES_
	ld de, $4000
	call _LABEL_1DC8
	ld hl, _DATA_B801
	ld de, $7A96
	ld a, $0A
	call _LABEL_1E9A
	ld hl, _DATA_68C
	call _LABEL_3D1
	ld a, $40
	ld (_RAM_C177), a
	ld bc, $E001
	call SendVDPCommand
	jp _LABEL_F7

+:
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	and Button_1_Mask|Button_2_Mask
	jr nz, +
	ld hl, _RAM_C177
	dec (hl)
	jp nz, _LABEL_F7
+:
	ld a, Map_Status_Title_Screen
	ld (_RAM_MAP_STATUS), a
	jp _LABEL_F7

; Data from 68C to 6AB (32 bytes)
_DATA_68C:
.db $00 $3F $30 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
.db $00 $3F $30 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

ProcessObjects:
	ld iy, _RAM_C400
	ld b, $18
-:
	ld a, (iy+object.type)
	or a
	push bc
	push iy
	call nz, +
	pop iy
	pop bc
	ld de, $0040
	add iy, de
	djnz -
	ret

+:
	ld a, (iy+object.type)
	cp $10 ; Slime (Dungeon)
	jp c, +
	cp $29 ; Projectile (Straw Fly)
	jp nc, +
	ld a, (iy+object.x_position_major)
	or a
	jp nz, _LABEL_51F3
+:
	ld a, (iy+object.type)
	ld hl, _DATA_6E4 - 2
	jp CallFunctionFromPointerTable

; Jump Table from 6E4 to 767 (66 entries, indexed by _RAM_C400)
; Object Behaviour Handlers, Collision?
_DATA_6E4:
.dw _LABEL_F55 ; Landau
.dw _LABEL_168E ; Arrow
.dw _LABEL_769 ; Sword Upgrade
.dw _LABEL_7C3 ; Bow Upgrade
.dw _LABEL_7E3 ; Sign
.dw _LABEL_768 ; Null
.dw _LABEL_768 ; Null
.dw _LABEL_768 ; Null
.dw _LABEL_768 ; Null
.dw _LABEL_768 ; Null
.dw _LABEL_768 ; Null
.dw _LABEL_768 ; Null
.dw _LABEL_768 ; Null
.dw _LABEL_768 ; Null
.dw _LABEL_768 ; Null
.dw _LABEL_2555 ; Slime
.dw _LABEL_3853 ; Eye Part
.dw _LABEL_2621 ; Giant Bat
.dw _LABEL_2915 ; Bird
.dw _LABEL_2A4E ; Killer Fish
.dw _LABEL_3C17 ; Clown
.dw _LABEL_2B31 ; Knight
.dw _LABEL_2CB1 ; Scorpion
.dw _LABEL_2FB0 ; Spider
.dw _LABEL_321C ; White Wolf
.dw _LABEL_3D54 ; Caterpillar
.dw _LABEL_3912 ; Eye Part
.dw _LABEL_3092 ; Skeleton
.dw _LABEL_2E6D ; Demon (Red Flying Thingy)
.dw _LABEL_2D88 ; Snake
.dw _LABEL_2F55 ; Giant Bat
.dw _LABEL_3B86 ; Straw Fly
.dw _LABEL_3389 ; Book Thief
.dw _LABEL_3A85 ; Dragon Enemy (Unused?)
.dw _LABEL_34F0 ; Dark Shunaida
.dw _LABEL_3930 ; Lizard Man
.dw _LABEL_3635 ; Dagon
.dw _LABEL_3785 ; Zombie
.dw _LABEL_3DF2 ; Damaged (0x27)
.dw _LABEL_3CD8 ; Snake
.dw _LABEL_26DD ; Projectile (Straw Fly)
.dw _LABEL_3ECB ; Damaged (0x2A)
.dw _LABEL_3EFC ; Tree Spirit (Boss)
.dw _LABEL_412D ; Projectile (Tree Spirit)
.dw _LABEL_41AB ; Projectile (Tree Spirit)
.dw _LABEL_4226 ; Necromancer (Boss)
.dw _LABEL_5FD6 ; Stone Hammer (Boss)
.dw _LABEL_4A85 ; Dark Suma (Boss)
.dw _LABEL_435A ; Necromancer's Clone (Boss)
.dw _LABEL_6194 ; Golden Guard (Boss)
.dw _LABEL_663B ; Paradin (Boss)
.dw _LABEL_483F ; Pirate (Boss)
.dw _LABEL_49FC ; Projecile (Pirate's Sword)
.dw _LABEL_6787 ; Medusa (Boss)
.dw _LABEL_4576 ; Baruga (Boss)
.dw _LABEL_768 ; Null
.dw _LABEL_643D ; Court Jester (Boss)
.dw _LABEL_5E7D ; The Ripper (Boss)
.dw _LABEL_47D9 ; Projectile (Baruga)
.dw _LABEL_6612 ; Projectile (Court Jester)
.dw _LABEL_4CAB ; Skull (Dark Suma)
.dw _LABEL_4DFE ; Projectile (Dark Suma)
.dw _LABEL_50CB ; Shield (Ra Goan)
.dw _LABEL_503F ; Projectile (Ra Goan)
.dw _LABEL_508B ; Projectile (Ra Goan)
.dw _LABEL_4E7A ; Ra Goan (Boss)

; 6th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_768:
	ret

; 3rd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_769:
	ld a, (_RAM_C483)
	or a
	jr nz, +
	ld hl, $FC00
	ld (_RAM_C490), hl
_LABEL_775:
	ld hl, $85E7
	ld (_RAM_C484), hl
	ld (iy+3), $01
	ld (iy+22), $E0
	ld (iy+23), $20
	ld (iy+24), $F8
	ld (iy+25), $10
	ld (iy+1), $00
	ret

+:
	ld a, (_RAM_C481)
	or a
	jr nz, +
	ld a, (_RAM_C487)
	cp $B0
	ld de, $0040
	jp c, _LABEL_869
	ld (iy+1), $01
	ld (iy+object.y_position_minor), $B0
	ret

+:
	ld ix, _RAM_C400
	call _LABEL_1C59
	ret nc
	ld a, $02
	ld (_RAM_SWORD_DAMAGE), a
	ld a, $95
	ld (_RAM_SOUND_TO_PLAY), a
	jp _LABEL_8AC

; 4th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_7C3:
	ld a, (_RAM_C483)
	or a
	jr z, _LABEL_775
	ld a, (_RAM_C48B)
	or a
	ret nz
	ld ix, _RAM_C400
	call _LABEL_1C59
	ret nc
	ld a, $03
	ld (_RAM_BOW_DAMAGE), a
	ld a, $95
	ld (_RAM_SOUND_TO_PLAY), a
	jp _LABEL_8AC

; 5th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_7E3:
	ld a, (_RAM_C4C3)
	or a
	jr nz, +
	ld (iy+object.y_position_minor), $38
	ld (iy+object.x_position_minor), $80
	ld (iy+3), $01
	ld hl, $B37A
	ld (_RAM_C4C4), hl
	ld (iy+15), $00
	ret

+:
	ld (iy+object.y_position_minor), $38
	ld (iy+object.x_position_minor), $80
	ld (iy+9), $00
	dec (iy+15)
	ret nz
	jp _LABEL_8AC

ApplyObjectYVelocity:
	ld d, (iy+object.y_velocity_minor)
	ld e, (iy+object.y_velocity_sub)
_LABEL_819:
	ld h, (iy+object.y_position_minor)
	ld l, (iy+object.y_position_sub)
	add hl, de
	ld (iy+object.y_position_minor), h
	ld (iy+object.y_position_sub), l
	ret

ApplyObjectXVelocity:
	ld c, $00
	bit 7, (iy+object.x_velocity_minor)
	jp z, +
	ld c, $FF
+:
	ld a, (iy+object.x_velocity_sub)
	add a, (iy+object.x_position_sub)
	ld (iy+object.x_position_sub), a
	ld a, (iy+object.x_velocity_minor)
	adc a, (iy+object.x_position_minor)
	ld (iy+object.x_position_minor), a
	ld a, c
	adc a, (iy+object.x_position_major)
	ld (iy+object.x_position_major), a
	ret

_LABEL_84C:
	inc (iy+15)
	ld a, (iy+15)
	cp (iy+13)
	ret c
	ld (iy+15), $00
	inc (iy+14)
	ld a, (iy+14)
	cp (iy+12)
	ret c
	ld (iy+14), $00
	ret

_LABEL_869:
	ld h, (iy+object.y_velocity_minor)
	ld l, (iy+object.y_velocity_sub)
	add hl, de
	ld a, h
	cp $06
	jp z, ApplyObjectYVelocity
	ld (iy+object.y_velocity_minor), h
	ld (iy+object.y_velocity_sub), l
	ex de, hl
	jp _LABEL_819

_LABEL_880:
	ld e, (iy+48)
	ld d, (iy+49)
	call _LABEL_869
	dec (iy+50)
	ret nz
	ld a, (iy+51)
	ld (iy+50), a
	ld hl, $0000
	ld e, (iy+48)
	ld d, (iy+49)
	xor a
	sbc hl, de
	ld (iy+48), l
	ld (iy+49), h
	ret

_LABEL_8A6:
	push ix
	pop hl
	jp +

_LABEL_8AC:
	push iy
	pop hl
+:
	ld d, h
	ld e, l
	inc de
	ld bc, $0037
	ld (hl), $00
	ldir
	ret

; Data from 8BA to 8C7 (14 bytes)
.db $21 $00 $C3 $11 $01 $C3 $01 $FF $06 $36 $00 $ED $B0 $C9

_LABEL_8C8:
	call +
	xor a
	bit 7, b
	ret z
	ld a, $FF
	ret

+:
	ld c, $00
	ld a, $E0
	add a, (ix+7)
	sub (iy+7)
	jr nz, +
	inc a
+:
	jr nc, +
	ld c, $01
	neg
+:
	ld l, a
	ld a, (ix+10)
	sub (iy+10)
	jr nz, +
	inc a
+:
	jr nc, +
	set 1, c
	neg
+:
	ld h, a
	ld a, l
	cp h
	jr nc, +
	set 2, c
	ld l, h
	ld h, a
+:
	ld e, l
	ld l, $00
	call ++
	ld h, $00
	ld de, $0100
	bit 2, c
	jr z, +
	ex de, hl
+:
	ld a, c
	push af
	ld b, h
	ld c, l
	bit 0, a
	jr z, +
	xor a
	ld hl, $0000
	sbc hl, de
	ex de, hl
+:
	pop af
	bit 1, a
	ret z
	xor a
	ld hl, $0000
	sbc hl, bc
	ld b, h
	ld c, l
	ret

++:
	ld b, $08
	xor a
-:
	adc hl, hl
	ld a, h
	jp c, +
	cp e
	jp c, ++
+:
	sub e
	ld h, a
	xor a
++:
	ccf
	djnz -
	rl l
	sla h
	ld a, h
	sub e
	ret c
	inc l
	ret

; 6th entry of Jump Table from 114 (indexed by _RAM_MAP_STATUS)
Handle_Map_Status_Start_Game:
	ld bc, $8201
	call SendVDPCommand
	ld a, Map_Status_Map
	ld (_RAM_MAP_STATUS), a
	xor a
	ld (_RAM_C093), a
	ld (_RAM_SCORE_RIGHT_DIGIT), a
	ld (_RAM_SCORE_MIDDLE_DIGIT), a
	ld (_RAM_SCORE_LEFT_DIGIT), a
	ld (_RAM_CURRENT_MAP), a
	call _LABEL_3C2
	ld a, $01
	ld (_RAM_C400), a
	ld a, $A0
	ld (_RAM_Y_POSITION_MINOR), a
	ld a, $80
	ld (_RAM_X_POSITION_MINOR), a
	ld de, $4000
	ld bc, $0040
	ld h, $00
	call _LABEL_321
	ld a, $30
	ld (_RAM_HEALTH), a
	ld a, $01
	ld (_RAM_C12A), a
	ld a, $01
	ld (_RAM_FLAG_GAME_STARTED), a
	call _LABEL_9DC
	ld hl, _PALETTE_9BC
	call _LABEL_3D1
	ld a, Building_Status_Load_Map
	ld (_RAM_BUILDING_STATUS), a
	call +
	ld bc, $E201
	call SendVDPCommand
	jp _LABEL_F7

+:
	ld c, $5E ; Harfoot (L)
	ld a, (_RAM_C170)
	or a
	jr z, +
	xor a
	ld (_RAM_C170), a
	ld a, (_RAM_CONTINUE_MAP)
	ld c, a
+:
	ld a, c
	ld (_RAM_CURRENT_MAP), a
	ret

; Data from 9BC to 9DB (32 bytes)
_PALETTE_9BC:
.db $00 $3F $00 $0B $17 $2A $24 $02 $00 $00 $00 $00 $00 $00 $00 $00
.db $00 $2A $25 $0B $17 $09 $05 $02 $00 $00 $00 $00 $00 $00 $00 $00

_LABEL_9DC:
	ld a, :Bank3
	ld (_RAM_FFFF), a
	ld hl, _DATA_ED05
	ld de, $42C0
	call _LABEL_1DC8
	ld hl, _DATA_COMPRESSED_HUD_TILES_
	ld de, $6000
	call _LABEL_1DC8
_LABEL_9F3:
	ld a, :Bank3
	ld (_RAM_FFFF), a
	ld hl, _DATA_EEA2
	ld de, $7800
	ld bc, $0080
	jp LoadVDPData

UpdateLandauGraphics:
	ld a, (_RAM_C420)
	or a
	ret z
	ld a, :Bank5
	ld (_RAM_FFFF), a
	ld hl, _DATA_14000
	ld a, (_RAM_MOVEMENT_STATE)
	add a, a
	ld e, a
	ld d, $00
	add hl, de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld a, (_RAM_C40E)
	add a, a
	ld e, a
	add hl, de
	ld a, (hl)
	ld (_RAM_C14A), a
	inc hl
	ld a, (hl)
	ld (_RAM_C14B), a
	ret

_LABEL_A2D:
	ld a, (_RAM_C420)
	or a
	ret z
	xor a
	ld (_RAM_C420), a
	ld a, (_RAM_MOVEMENT_STATE)
	ld b, $04
	cp Movement_Death
	jp c, +
	ld b, $05
+:
	ld hl, (_RAM_C14A)
	ld a, $40
	out (Port_VDPAddress), a
	ld a, $40
	out (Port_VDPAddress), a
	ld a, b
	ld (_RAM_FFFF), a
	ld c, Port_VDPData
	xor a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	outi
	outi
	outi
	out (Port_VDPData), a
	ret

; 1st entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_F55:
	ld a, (_RAM_C403)
	or a
	jp nz, +
	ld hl, _DATA_8000
	ld (_RAM_C404), hl
	ld (iy+3), $01
	ld (iy+22), $E0
	ld (iy+23), $20
	ld (iy+24), $FC
	ld (iy+25), $08
	ld (iy+1), $00
	ld a, (_RAM_X_POSITION_MINOR)
	cp $80
	ret nc
	ld (iy+1), $01
	ret

+:
	call _LABEL_13A2
	ld hl, MovementStateHandlers
	ld a, (_RAM_MOVEMENT_STATE)
	jp CallFunctionFromPointerTable

; Jump Table from F91 to FB8 (20 entries, indexed by _RAM_MOVEMENT_STATE)
MovementStateHandlers:
.dw Handle_Movement_Walking_Left
.dw Handle_Movement_Walking_Right
.dw Handle_Movement_Jumping_Left
.dw Handle_Movement_Jumping_Right
.dw Handle_Movement_Falling_Left
.dw Handle_Movement_Falling_Right
.dw Handle_Movement_Crouching_Left
.dw Handle_Movement_Crouching_Right
.dw Handle_Movement_Sword_Left
.dw Handle_Movement_Sword_Right
.dw Handle_Movement_Bow_Left
.dw Handle_Movement_Bow_Right
.dw Handle_Movement_Bow_Left
.dw Handle_Movement_Bow_Right
.dw Handle_Movement_Death
.dw Handle_Movement_Death_0F
.dw Handle_Movement_Damaged
.dw Handle_Movement_Damaged
.dw Handle_Movement_Sword_Left
.dw Handle_Movement_Sword_Right

-:
	ld hl, $800D
	ld c, $00
	jp _LABEL_109E

; 1st entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Walking_Left:
	ld a, (_RAM_C402)
	or a
	jr z, -
	call +
	ret c
	ld hl, $FF00
	ld (_RAM_X_VELOCITY_SUB), hl
	ld (iy+object.x_velocity_major), h
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonLeft, a
	jp nz, _LABEL_1071
	bit ButtonRight, a
	jp z, _LABEL_1077
	ld c, Movement_Walking_Right
	jp SetMovementState

+:
	call _LABEL_15CA
	ld c, Movement_Falling_Left
	jr nc, +
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	ld c, Movement_Bow_Left
	bit Button_1, a
	jr nz, +
	ld c, Movement_Sword_Left
	bit Button_2, a
	jr nz, +
	ld c, Movement_Jumping_Left
	rrca
	jr c, +
	ld c, Movement_Crouching_Left
	rrca
	jr c, +
	xor a
	ret

+:
	call SetMovementState
	ld (iy+33), $00
	ld (iy+35), $00
	scf
	ret

-:
	ld hl, _DATA_804F
	ld c, $01
	jp _LABEL_109E

; 2nd entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Walking_Right:
	ld a, (_RAM_C402)
	or a
	jr z, -
	call +
	ret c
	ld hl, $0100
	ld (_RAM_X_VELOCITY_SUB), hl
	ld (iy+object.x_velocity_major), l
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonRight, a
	jp nz, _LABEL_1071
	bit ButtonLeft, a
	jp z, _LABEL_1077
	ld c, Movement_Walking_Left
	jp SetMovementState

+:
	call _LABEL_15CA
	ld c, Movement_Falling_Right
	jr nc, +
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	ld c, Movement_Bow_Right
	bit Button_1, a
	jr nz, +
	ld c, Movement_Sword_Right
	bit Button_2, a
	jr nz, +
	ld c, Movement_Jumping_Right
	rrca
	jr c, +
	ld c, Movement_Crouching_Right
	rrca
	jr c, +
	xor a
	ret

+:
	call SetMovementState
	ld (iy+33), $01
	ld (iy+35), $00
	scf
	ret

_LABEL_1071:
	call _LABEL_14D8
	jp _LABEL_1569

_LABEL_1077:
	xor a
	ld (_RAM_Y_VELOCITY_SUB), a
	ld (_RAM_Y_VELOCITY_MINOR), a
	ld (_RAM_X_VELOCITY_SUB), a
	ld (_RAM_X_VELOCITY_MINOR), a
	ld (_RAM_X_VELOCITY_MAJOR), a
	ld a, (_RAM_C40E)
	cp $02
	ret z
	ld (iy+32), $01
	ld (iy+14), $02
	ret

SetMovementState:
	ld (iy+1), c
	ld (iy+2), $00
	ret

_LABEL_109E:
	call _LABEL_14CC
	call _LABEL_13DF
	ld (iy+33), c
	ld (iy+13), $06
	ld (iy+14), $02
	ret

-:
	ld hl, _DATA_8091
	jp _LABEL_1387

; 3rd entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Jumping_Left:
	ld a, (_RAM_C402)
	or a
	jr z, -
	ld c, Movement_Sword_Left
	call SetMovementStateIfButton2NewlyPressed
	ret c
	ld c, Movement_Jumping_Right
	jp _LABEL_1521

-:
	ld hl, _DATA_80B0
	jp _LABEL_1387

; 4th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Jumping_Right:
	ld a, (_RAM_C402)
	or a
	jr z, -
	ld c, Movement_Sword_Right
	call SetMovementStateIfButton2NewlyPressed
	ret c
	ld c, Movement_Jumping_Left
	jp _LABEL_1545

-:
	ld hl, _DATA_80CF
	jp _LABEL_1413

; 5th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Falling_Left:
	ld a, (_RAM_C402)
	or a
	jr z, -
	ld c, Movement_Sword_Right
	call SetMovementStateIfButton2NewlyPressed
	ret c
	ld c, Movement_Falling_Right
	jp _LABEL_1521

-:
	ld hl, $80D1
	jp _LABEL_1413

; 6th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Falling_Right:
	ld a, (_RAM_C402)
	or a
	jr z, -
	ld c, Movement_Sword_Right
	call SetMovementStateIfButton2NewlyPressed
	ret c
	ld c, Movement_Falling_Left
	jp _LABEL_1545

-:
	ld hl, _DATA_80D3
	jp _LABEL_1429

; 7th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Crouching_Left:
	ld a, (_RAM_C402)
	or a
	jr z, -
	ld c, Movement_Walking_Left
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonDown, a
	jp z, SetMovementState
	ld c, Movement_Crouching_Right
	bit ButtonRight, a
	jp nz, SetMovementState
	ld c, Movement_Crouching_Bow_Left
	ld b, Movement_Crouching_Sword_Left
	jp +

-:
	ld hl, _DATA_80EE
	jp _LABEL_1429

; 8th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Crouching_Right:
	ld a, (_RAM_C402)
	or a
	jr z, -
	ld c, Movement_Walking_Right
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonDown, a
	jp z, SetMovementState
	ld c, Movement_Crouching_Left
	bit ButtonLeft, a
	jp nz, SetMovementState
	ld c, Movement_Crouching_Bow_Right
	ld b, Movement_Crouching_Sword_Right
+:
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	bit Button_1, a
	jp nz, +
	bit Button_2, a
	ret z
	ld c, b
+:
	ld (iy+35), $01
	ld a, (_RAM_MOVEMENT_STATE)
	ld (_RAM_C421), a
	jp SetMovementState

; 9th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Sword_Left:
	ld a, (_RAM_C402)
	or a
	jp nz, +
	ld de, _DATA_8109
	ld hl, _DATA_84D9
	ld a, $00
	ld bc, $0408
	jp _LABEL_1441

; 10th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Sword_Right:
	ld a, (_RAM_C402)
	or a
	jp nz, +
	ld de, _DATA_819D
	ld hl, $8555
	ld a, $01
	ld bc, $0408
	jp _LABEL_1441

+:
	call +
	call _LABEL_1569
	ld a, (_RAM_C40E)
	cp $03
	jp c, _LABEL_14D8
	call ++
	ret c
	call _LABEL_1222
	ret c
	dec (iy+object.boss_flash_timer)
	ret nz
	ld c, (iy+33)
	jp SetMovementState

+:
	ld (iy+37), $00
	ld a, (_RAM_C40E)
	cp $02
	ret nz
	ld (iy+37), $01
	ld (iy+22), $D0
	ld a, (_RAM_MOVEMENT_STATE)
	cp Movement_Bow_Left
	ret c
	ld (iy+22), $E8
	ret

++:
	ld a, (_RAM_CONTROLLER_INPUT)
	bit Button_2, a
	jr z, _LABEL_1220
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonDown, a
	jp nz, +
	ld a, (_RAM_C423)
	or a
	jr z, _LABEL_1220
	ld hl, $8109
	ld de, _DATA_819D
	ld bc, $0800
	xor a
	jp ++

+:
	ld a, (_RAM_C423)
	or a
	jr nz, _LABEL_1220
	ld hl, _DATA_84D9
	ld de, _DATA_8555
	ld bc, $1206
	ld a, $01
++:
	bit 0, (iy+33)
	jp z, +
	ex de, hl
	inc b
	inc c
+:
	ld (_RAM_C404), hl
	ld (iy+1), b
	ld (iy+33), c
	ld (iy+32), $01
	ld (_RAM_C423), a
	scf
	ret

_LABEL_1220:
	xor a
	ret

_LABEL_1222:
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	bit Button_2, a
	jr z, +++
	ld (iy+38), $01
	ld a, (_RAM_CONTROLLER_INPUT)
	ld bc, $1208
	bit ButtonLeft, a
	jr nz, +
	ld bc, $1309
	bit ButtonRight, a
	jr z, ++
+:
	ld a, (_RAM_C423)
	or a
	jr z, +
	ld c, b
+:
	call SetMovementState
++:
	scf
	ret

+++:
	xor a
	ret

; 11th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Bow_Left:
	ld bc, $0A0C
	ld de, $0006
	ld a, (_RAM_C402)
	or a
	jp nz, +
	ld hl, $8231
	ld de, $8359
	ld bc, $0810
	jp _LABEL_1486

; 12th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Bow_Right:
	ld bc, $0B0D
	ld de, $0107
	ld a, (_RAM_C402)
	or a
	jp nz, +
	ld hl, $82C5
	ld de, $83C0
	ld bc, $0810
	jp _LABEL_1486

+:
	call ++
	call _LABEL_12DE
	call ApplyObjectXVelocity
	ld a, (_RAM_C40E)
	cp $03
	jr c, +
	call _LABEL_161E
	dec (iy+object.boss_flash_timer)
	ret nz
	ld (iy+40), $00
	ld c, (iy+33)
	jp SetMovementState

+:
	cp $02
	jp c, _LABEL_14D8
	ld a, (_RAM_C427)
	or a
	jp z, _LABEL_14D8
	ld a, (_RAM_CONTROLLER_INPUT)
	bit Button_1, a
	ret nz
	ld (iy+39), $00
	ret

++:
	bit 0, (iy+35)
	jp nz, +
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonDown, a
	ret z
	set 0, (iy+35)
	ld (iy+33), e
	jp SetMovementState

+:
	ld c, b
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonDown, a
	ret nz
	res 0, (iy+35)
	ld (iy+33), d
	jp SetMovementState

_LABEL_12DE:
	ld c, (iy+1)
	bit 0, c
	jp nz, +
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonRight, a
	ret z
	inc (iy+33)
	inc c
	jp SetMovementState

+:
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonLeft, a
	ret z
	dec (iy+33)
	dec c
	jp SetMovementState

; 15th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Death:
	ld a, (_RAM_C402)
	or a
	jp nz, +
	ld hl, _DATA_8427
	jp _LABEL_14AE

; 16th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Death_0F:
	ld a, (_RAM_C402)
	or a
	jp nz, +
	ld hl, _DATA_8480
	jp _LABEL_14AE

+:
	ld a, (_RAM_C40E)
	cp $02
	jp c, _LABEL_14D8
	ld a, Building_Status_Death
	ld (_RAM_BUILDING_STATUS), a
	ret

; 17th entry of Jump Table from F91 (indexed by _RAM_MOVEMENT_STATE)
Handle_Movement_Damaged:
	call _LABEL_1569
	dec (iy+42)
	ret nz
	ld a, (_RAM_PRE_DAMAGE_MOVEMENT_STATE)
	ld (_RAM_MOVEMENT_STATE), a
	xor a
	ld (_RAM_PRE_DAMAGE_MOVEMENT_STATE), a
	ld (_RAM_C42A), a
	ld (_RAM_X_VELOCITY_SUB), a
	ld (_RAM_X_VELOCITY_MINOR), a
	ld (_RAM_X_VELOCITY_MAJOR), a
	ld c, (iy+43)
	call ApplyLandauHealOrDamageFromC
	ret nc
	ld (iy+44), $01
	xor a
	ld (_RAM_RECOVERY_STATUS), a
	ld (_RAM_C402), a
	ld (iy+1), $0E
	bit 0, (iy+1)
	ret z
	ld (iy+1), $0F
	ret

; Data from 1365 to 1386 (34 bytes)
.db $3A $A6 $C0 $CB $47 $28 $19 $0E $02 $FD $CB $01 $46 $28 $02 $0E
.db $03 $3A $01 $C4 $32 $21 $C4 $FD $71 $01 $FD $36 $02 $00 $37 $C9
.db $AF $C9

_LABEL_1387:
	call _LABEL_14CC
	call _LABEL_13DF
	ld a, (_RAM_LANDAU_IN_AIR)
	or a
	ret nz
	ld (iy+object.boss_teleport_timer), $01
	ld hl, $FB00
	ld (_RAM_Y_VELOCITY_SUB), hl
	ld a, $A2
	ld (_RAM_SOUND_TO_PLAY), a
	ret

_LABEL_13A2:
	ld a, (_RAM_LANDAU_IN_AIR)
	or a
	ret z
	ld de, $0040
	call _LABEL_869
	bit 7, (iy+object.y_velocity_minor)
	ret nz
	call _LABEL_15CA
	ret nc
	ld c, $00
	bit 0, (iy+1)
	jr z, +
	ld c, $01
+:
	ld a, (_RAM_C42C)
	or a
	jr nz, +
	ld (iy+1), c
	ld (iy+2), $00
	ld a, (_RAM_Y_POSITION_MINOR)
	and $F8
	ld (_RAM_Y_POSITION_MINOR), a
	xor a
	ld (_RAM_LANDAU_IN_AIR), a
	ld (_RAM_Y_POSITION_SUB), a
	ld (_RAM_C425), a
_LABEL_13DF:
	xor a
	ld (_RAM_C40E), a
	ld (_RAM_C40C), a
	ld (_RAM_C40F), a
	ld (_RAM_C40D), a
	ret

+:
	ld a, (_RAM_Y_POSITION_MINOR)
	and $F8
	ld (_RAM_Y_POSITION_MINOR), a
	xor a
	ld (_RAM_LANDAU_IN_AIR), a
	ld (_RAM_Y_POSITION_SUB), a
	ret

_LABEL_13FD:
	ld a, (_RAM_X_VELOCITY_SUB)
	add a, l
	ld (_RAM_X_VELOCITY_SUB), a
	ld a, (_RAM_X_VELOCITY_MINOR)
	adc a, h
	ld (_RAM_X_VELOCITY_MINOR), a
	ld a, (_RAM_X_VELOCITY_MAJOR)
	adc a, h
	ld (_RAM_X_VELOCITY_MAJOR), a
	ret

_LABEL_1413:
	call _LABEL_14CC
	call _LABEL_13DF
	ld a, (_RAM_LANDAU_IN_AIR)
	or a
	ret nz
	ld (iy+object.boss_teleport_timer), $01
	ld hl, $0000
	ld (_RAM_Y_VELOCITY_SUB), hl
	ret

_LABEL_1429:
	call _LABEL_14CC
	jp _LABEL_13DF

SetMovementStateIfButton2NewlyPressed:
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	bit Button_2, a
	jr nz, +
	xor a
	ret

+:
	call SetMovementState
	ld (iy+35), $00
	scf
	ret

_LABEL_1441:
	bit 0, (iy+35)
	jp nz, +
	ld (_RAM_C421), a
	ex de, hl
+:
	ld (iy+22), $00
	ld (iy+37), $00
	call _LABEL_146A
	ld a, $92
	ld (_RAM_SOUND_TO_PLAY), a
	ld a, (_RAM_C426)
	or a
	ret z
	ld (iy+38), $00
	ld (iy+14), $01
	ret

_LABEL_146A:
	call _LABEL_14CC
	call _LABEL_13DF
	ld (iy+13), b
	ld (iy+object.boss_flash_timer), c
	ld a, (_RAM_LANDAU_IN_AIR)
	or a
	ret nz
	xor a
	ld (_RAM_X_VELOCITY_SUB), a
	ld (_RAM_X_VELOCITY_MINOR), a
	ld (_RAM_X_VELOCITY_MAJOR), a
	ret

_LABEL_1486:
	xor a
	ld (_RAM_LANDAU_IN_AIR), a
	bit 0, (iy+35)
	jr z, +
	ex de, hl
+:
	ld e, (iy+14)
	call _LABEL_146A
	ld a, (_RAM_C428)
	or a
	jr nz, +
	ld (iy+39), $01
	ld (iy+40), $01
	set 7, (iy+35)
	ret

+:
	ld (iy+14), e
	ret

_LABEL_14AE:
	call _LABEL_14CC
	call _LABEL_13DF
	ld (iy+12), $03
	ld (iy+13), $10
	ld (iy+44), $01
	ld hl, $0280
	ld (_RAM_C107), hl
	ld a, $89
	ld (_RAM_SOUND_TO_PLAY), a
	ret

_LABEL_14CC:
	ld (_RAM_C404), hl
	ld a, $01
	ld (_RAM_C420), a
	ld (_RAM_C402), a
	ret

_LABEL_14D8:
	inc (iy+15)
	ld a, (iy+15)
	cp (iy+13)
	ret c
	ld (iy+15), $00
	ld (iy+32), $01
	inc (iy+14)
	ld a, (iy+14)
	cp $06
	ret c
	ld (iy+14), $00
	ret

_LABEL_14F8:
	ld a, (_RAM_RECOVERY_STATUS)
	or a
	ret z
	ld de, $C015
	ld hl, (_RAM_RECOVERY_TIMER)
	dec hl
	ld (_RAM_RECOVERY_TIMER), hl
	ld a, h
	or l
	jp nz, +
	xor a
	ld (_RAM_RECOVERY_STATUS), a
	ld a, $09
	jp _LABEL_316

+:
	ld a, $09
	bit 0, l
	jp nz, _LABEL_316
	ld a, $3F
	jp _LABEL_316

_LABEL_1521:
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonLeft, a
	jr nz, +
	bit ButtonRight, a
	jr z, ++
	jp SetMovementState

+:
	ld a, (_RAM_X_VELOCITY_SUB)
	or a
	jr nz, +
	ld a, (_RAM_X_VELOCITY_MINOR)
	cp $FF
	jr z, ++
+:
	ld hl, $FFF8
	call _LABEL_13FD
++:
	jp _LABEL_1569

_LABEL_1545:
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonRight, a
	jr nz, +
	bit ButtonLeft, a
	jr z, ++
	jp SetMovementState

+:
	ld a, (_RAM_X_VELOCITY_SUB)
	or a
	jr nz, +
	ld a, (_RAM_X_VELOCITY_MINOR)
	cp $01
	jr z, ++
+:
	ld hl, $0008
	call _LABEL_13FD
++:
	jp _LABEL_1569

_LABEL_1569:
	bit 7, (iy+object.x_velocity_minor)
	jp z, ++
	ld de, $FFF7
	call _LABEL_15E5
	bit 6, l
	ret nz
	ld a, (_RAM_BOSS_FIGHT_INITIALIZED)
	or a
	jr nz, +
	ld a, (_RAM_SCREEN_X_TILE)
	ld c, a
	ld a, (_RAM_C115)
	cp c
	jr z, +
	ld a, (_RAM_X_POSITION_MINOR)
	cp $61
	jp nc, ApplyObjectXVelocity
	jp _LABEL_1914

+:
	ld a, (_RAM_X_POSITION_MINOR)
	cp $10
	jp nc, ApplyObjectXVelocity
	ret

++:
	ld de, $FF08
	call _LABEL_15E5
	bit 6, l
	ret nz
	ld a, (_RAM_BOSS_FIGHT_INITIALIZED)
	or a
	jr nz, +
	ld a, (_RAM_SCREEN_X_TILE)
	ld c, a
	ld a, (_RAM_C116)
	cp c
	jr z, +
	ld a, (_RAM_X_POSITION_MINOR)
	cp $A0
	jp c, ApplyObjectXVelocity
	jp _LABEL_1914

+:
	ld a, (_RAM_X_POSITION_MINOR)
	cp $F0
	jp c, ApplyObjectXVelocity
	ret

_LABEL_15CA:
	ld a, (_RAM_Y_POSITION_MINOR)
	cp $BF
	jr nc, +
	ld de, $00F8
	call _LABEL_15E5
	jr nz, ++
	ld de, $0007
	call _LABEL_15E5
	jr nz, ++
+:
	xor a
	ret

++:
	scf
	ret

_LABEL_15E5:
	ld a, (iy+object.y_position_minor)
	add a, d
	ld d, a
	ld a, (iy+object.x_position_minor)
	add a, e
	ld e, a
	ld a, d
	and $F8
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, $3800
	add hl, bc
	ld a, (_RAM_C111)
	neg
	add a, e
	and $F8
	rrca
	rrca
	ld e, a
	ld d, $00
	add hl, de
	ex de, hl
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	push af
	pop af
	in a, (Port_VDPData)
	ld h, a
	push af
	pop af
	in a, (Port_VDPData)
	ld l, a
	bit 5, a
	ret

_LABEL_161E:
	bit 7, (iy+35)
	ret z
	res 7, (iy+35)
	ld hl, $FC00
	ld bc, $FFF8
	ld e, $00
	bit 0, (iy+1)
	jp z, +
	ld hl, $0400
	ld bc, $0008
	ld e, $01
+:
	ld ix, _RAM_C440
	ld (_RAM_C453), hl
	ld (ix+21), b
	ld a, (_RAM_X_POSITION_MINOR)
	add a, c
	ld (_RAM_C44A), a
	ld (ix+14), e
	ld a, $DB
	bit 0, (iy+35)
	jp z, +
	ld a, $E8
+:
	add a, (iy+object.y_position_minor)
	ld (_RAM_C447), a
	ld hl, _DATA_85D1
	ld (_RAM_C444), hl
	ld (ix+0), $02
	ld (ix+3), $01
	xor a
	ld (_RAM_C460), a
	ld (_RAM_C461), a
	ld (ix+22), $FC
	ld (ix+23), $04
	ld (ix+24), $F9
	ld (ix+25), $0E
	ld a, $90
	ld (_RAM_SOUND_TO_PLAY), a
	ret

; 2nd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_168E:
	ld a, (_RAM_C460)
	or a
	jp nz, ++
	ld a, (_RAM_C44B)
	or a
	jp nz, _LABEL_8AC
	call ApplyObjectXVelocity
	ld a, (_RAM_C44A)
	cp $10
	ret c
	cp $F0
	ret nc
	call _LABEL_1720
	ret c
	ld de, $FEF8
	bit 7, (iy+object.x_velocity_minor)
	jp nz, +
	ld de, $FE08
+:
	call _LABEL_15E5
	ret z
	ld (iy+32), $01
	ret

++:
	ld a, (_RAM_C461)
	or a
	jr z, ++
	ld a, (_RAM_C461)
	dec a
	jr nz, +
	call ApplyObjectXVelocity
	ld de, $0040
	call _LABEL_869
	ld a, (_RAM_C447)
	cp $C0
	jp nc, _LABEL_8AC
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld (iy+33), $02
	ret

+:
	dec (iy+object.boss_teleport_timer)
	ret nz
	jp _LABEL_8AC

++:
	ld hl, $0080
	bit 7, (iy+object.x_velocity_minor)
	jp nz, +
	ld hl, $FF80
+:
	ld (_RAM_C453), hl
	ld (iy+object.x_velocity_major), h
	ld a, $A4
	ld (_RAM_SOUND_TO_PLAY), a
	ld (iy+33), $01
	ld (iy+object.boss_teleport_timer), $08
	ld a, (_RAM_C500)
	cp $2B
	ret c
	cp $43
	ret nc
	xor a
	ld (_RAM_C52F), a
	ret

_LABEL_1720:
	ld a, (_RAM_C500)
	cp $2B
	jp c, +
	cp $43
	jp nc, +
	ld ix, _RAM_C500
	call _LABEL_1C59
	ret nc
	ld (ix+47), $01
	ld (iy+32), $01
	ret

_LABEL_173E:
	ld a, (iy+object.type)
	cp $27 ; Damaged (Knight)
	jr z, +
	ld ix, _RAM_C440
	call _LABEL_1C59
	jr nc, +
	ld a, $01
	ld (_RAM_C460), a
	ld (iy+object.type), $27 ; Damaged (Knight)
	ld (iy+26), $01
	scf
	ret

+:
	xor a
	ret

_LABEL_175F:
	ld de, _RAM_C093
	ld a, $01
	ld (de), a
	ld a, (_RAM_MAP_STATUS)
	cp Map_Status_Demo
	ret z
	inc de
	ld hl, _DATA_1787
	ld a, c
	add a, a
	add a, c
	ld c, a
	ld b, $00
	add hl, bc
	ld a, (de)
	add a, (hl)
	daa
	ld (de), a
	inc hl
	inc de
	ld a, (de)
	adc a, (hl)
	daa
	ld (de), a
	inc hl
	inc de
	ld a, (de)
	adc a, (hl)
	daa
	ld (de), a
	ret

; Data from 1787 to 17AA (36 bytes)
_DATA_1787:
.db $00 $00 $00 $00 $01 $00 $00 $02 $00 $00 $03 $00 $00 $10 $00 $00
.db $20 $00 $00 $30 $00 $00 $40 $00 $00 $50 $00 $00 $60 $00 $00 $70
.db $00 $00 $80 $00

UpdateScoreCounter:
	ld a, (_RAM_C093)
	or a
	ret z
	xor a
	ld (_RAM_C093), a
	ld hl, _RAM_SCORE_LEFT_DIGIT
	ld de, $7846
	ld bc, $0601
	jp +

; Data from 17C0 to 17DB (28 bytes)
.db $21 $90 $C0 $11 $94 $C0 $06 $03 $AF $1A $9E $23 $13 $10 $FA $D8
.db $11 $90 $C0 $21 $94 $C0 $01 $03 $00 $ED $B0 $C9

+:
	xor a
	ex af, af'
	ex de, hl
	srl b
	jr nc, _LABEL_17E6
	inc b
	jr +

_LABEL_17E6:
	ld a, (de)
	rrca
	rrca
	rrca
	rrca
	call ++
+:
	ld a, (de)
	call ++
	dec de
	djnz _LABEL_17E6
	ex af, af'
	ex de, hl
	ld b, $03
-:
	ld a, (hl)
	or a
	ret nz
	inc hl
	djnz -
	dec de
	dec de
	ld a, $01
	call _LABEL_316
	ld a, c
	out (Port_VDPData), a
	ret

++:
	and $0F
	push bc
	ld c, a
	ex af, af'
	or c
	pop bc
	jr z, +
	ex af, af'
	add a, $01
	ex de, hl
	call _LABEL_316
	push af
	pop af
	ld a, c
	out (Port_VDPData), a
	ex de, hl
	inc hl
	inc hl
	ret

+:
	ex af, af'
	push af
	ld a, $01
	ex de, hl
	call _LABEL_316
	push af
	pop af
	ld a, c
	out (Port_VDPData), a
	ex de, hl
	inc hl
	inc hl
	pop af
	ret

; Data from 1835 to 1868 (52 bytes)
.db $CD $87 $03 $79 $FE $63 $DA $41 $18 $3E $63 $4F $06 $FF $0E $0A
.db $91 $04 $30 $FC $81 $4F $78 $A7 $20 $02 $3E $00 $C6 $01 $D3 $BE
.db $F5 $F1 $3E $09 $D3 $BE $F5 $F1 $79 $C6 $01 $D3 $BE $F5 $F1 $3E
.db $09 $D3 $BE $C9

ApplyLandauHealOrDamageFromC:
	ld a, $01
	ld (_RAM_C12A), a
	ld a, (_RAM_HEALTH)
	add a, c
	ld (_RAM_HEALTH), a
	or a
	jr z, ++
	bit 7, a
	jr nz, ++
	cp $30
	jr c, +
	ld a, $2F
	ld (_RAM_HEALTH), a
+:
	xor a
	ret

++:
	xor a
	ld (_RAM_HEALTH), a
	scf
	ret

DrawHealthBar:
	ld a, (_RAM_C12A)
	or a
	ret z
	xor a
	ld (_RAM_C12A), a
	ld de, $785A
	ld a, (_RAM_HEALTH)
	or a
	jr z, _LABEL_18E5
	cp $30
	jr nc, _LABEL_18EB
	and $38
	rrca
	rrca
	rrca
	cpl
	add a, $06
	add a, a
	ld hl, _DATA_18FC
	ld c, a
	ld b, $00
	add hl, bc
	ld bc, $000C
	call LoadVDPData
	ld de, $6228
	ld a, (_RAM_HEALTH)
	and $07
	ld c, a
	ld b, $00
	ld hl, _DATA_18F4
	add hl, bc
	ld h, (hl)
	ld l, $01
	ld b, $04
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
--:
	push bc
	ld b, $04
	ld c, l
-:
	xor a
	rr c
	jr nc, +
	ld a, h
+:
	out (Port_VDPData), a
	djnz -
	pop bc
	djnz --
	ret

_LABEL_18E5:
	ld hl, _DATA_1908
	jp +

_LABEL_18EB:
	ld hl, _DATA_18FC
+:
	ld bc, $000C
	jp LoadVDPData

; Data from 18F4 to 18FB (8 bytes)
_DATA_18F4:
.db $00 $80 $C0 $E0 $F0 $F8 $FC $FE

; Data from 18FC to 18FF (4 bytes)
_DATA_18FC:
.db $10 $09 $10 $09

; 7th entry of Pointer Table from 8000 (indexed by unknown)
; Data from 1900 to 1907 (8 bytes)
_DATA_1900:
.db $10 $09 $10 $09 $10 $09 $11 $09

; Data from 1908 to 1913 (12 bytes)
_DATA_1908:
.db $12 $09 $12 $09 $12 $09 $12 $09 $12 $09 $12 $09

_LABEL_1914:
	push ix
	call _LABEL_1AB3
	pop ix
	call _LABEL_1A5C
	ld hl, $0000
	ld de, (_RAM_X_VELOCITY_SUB)
	xor a
	sbc hl, de
	ex de, hl
	ld hl, (_RAM_C110)
	add hl, de
	ld (_RAM_C110), hl
	ld hl, (_RAM_C10E)
	add hl, de
	ld (_RAM_C10E), hl
	bit 7, d
	jp nz, ++
	ld a, h
	cp $08
	ret c
	and $07
	ld (_RAM_SCREEN_X_PIXEL), a
	ld a, $01
	ld (_RAM_C109), a
	ld a, $01
	ld (_RAM_C114), a
	ld hl, _RAM_SCREEN_X_TILE
	dec (hl)
	ld a, (hl)
	ld (_RAM_C10B), a
	ld hl, _RAM_C112
	dec (hl)
	dec (hl)
	ld a, (hl)
	cp $80
	jp nc, +
	add a, $40
	ld (hl), a
+:
	ld hl, _RAM_C113
	dec (hl)
	dec (hl)
	ld a, (hl)
	cp $80
	jp nc, _LABEL_19AF
	add a, $40
	ld (hl), a
	jp _LABEL_19AF

++:
	bit 7, h
	ret z
	ld a, h
	and $07
	ld (_RAM_SCREEN_X_PIXEL), a
	ld a, $01
	ld (_RAM_C109), a
	ld a, $00
	ld (_RAM_C114), a
	ld hl, _RAM_SCREEN_X_TILE
	inc (hl)
	ld a, (hl)
	add a, $1F
	ld (_RAM_C10B), a
	ld hl, _RAM_C112
	inc (hl)
	inc (hl)
	ld a, (hl)
	cp $C0
	jp c, +
	add a, $C0
	ld (hl), a
+:
	ld hl, _RAM_C113
	inc (hl)
	inc (hl)
	ld a, (hl)
	cp $C0
	jp c, _LABEL_19AF
	add a, $C0
	ld (hl), a
_LABEL_19AF:
	push iy
	call +
	pop iy
	ret

+:
	ld ix, _RAM_D420
	ld a, :Bank15
	ld (_RAM_FFFF), a
	ld a, (_RAM_C10B)
	srl a
	ld l, a
	ld h, $00
	ld c, a
	ld b, h
	add hl, hl
	ld e, l
	ld d, h
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, de
	ld de, _RAM_LEVEL_LAYOUT
	add hl, de
	push hl
	pop iy
	ld b, $0B
-:
	ld l, (iy+0)
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	ex de, hl
	ld hl, (_RAM_C10C)
	add hl, de
	ld a, (_RAM_C10B)
	rrca
	jp nc, +
	inc hl
	inc hl
+:
	ld a, (hl)
	ld (ix+0), a
	inc hl
	inc ix
	ld a, (hl)
	ld (ix+0), a
	inc hl
	inc hl
	inc hl
	inc ix
	ld a, (hl)
	ld (ix+0), a
	inc hl
	inc ix
	ld a, (hl)
	ld (ix+0), a
	inc ix
	inc iy
	djnz -
	ret

_LABEL_1A12:
	ld a, (_RAM_C109)
	or a
	ret z
	ld a, (_RAM_C11D)
	or a
	ret nz
	xor a
	ld (_RAM_C109), a
	ld a, (_RAM_C112)
	ld l, a
	ld a, (_RAM_C114)
	or a
	jp z, +
	ld a, (_RAM_C113)
	ld l, a
+:
	ld h, $7A
	ld bc, $0E40
	ld de, _RAM_D430
	ld a, (_RAM_C0A2)
	or a
	jp nz, _LABEL_1A46
	ld h, $78
	ld bc, $1640
	ld de, _RAM_D420
_LABEL_1A46:
	ld a, l
	out (Port_VDPAddress), a
	ld a, h
	out (Port_VDPAddress), a
	ld a, (de)
	out (Port_VDPData), a
	inc de
	ld a, (de)
	out (Port_VDPData), a
	inc de
	push bc
	ld b, $00
	add hl, bc
	pop bc
	djnz _LABEL_1A46
	ret

_LABEL_1A5C:
	ld a, (_RAM_C0A2)
	or a
	ret z
	call ++
	ld hl, $0000
	xor a
	sbc hl, de
	ex de, hl
	ld hl, (_RAM_C146)
	add hl, de
	ld (_RAM_C146), hl
	ld hl, (_RAM_C148)
	add hl, de
	ld (_RAM_C148), hl
	bit 7, d
	jp nz, +
	ld a, h
	cp $08
	ret c
	and $07
	ld (_RAM_C149), a
	ret

+:
	bit 7, h
	ret z
	ld a, h
	and $07
	ld (_RAM_C149), a
	ret

++:
	ld de, (_RAM_X_VELOCITY_SUB)
	bit 7, d
	jp nz, +
	srl d
	rr e
	ret

+:
	xor a
	ld hl, $0000
	sbc hl, de
	srl h
	rr l
	ex de, hl
	xor a
	ld hl, $0000
	sbc hl, de
	ex de, hl
	ret

_LABEL_1AB3:
	ld a, (_RAM_X_VELOCITY_SUB)
	cpl
	add a, $01
	ld (_RAM_C12E), a
	ld a, (_RAM_X_VELOCITY_MINOR)
	cpl
	adc a, $00
	ld (_RAM_C12F), a
	ld a, (_RAM_X_VELOCITY_MAJOR)
	cpl
	adc a, $00
	ld (_RAM_C130), a
	ld hl, _RAM_C131
	call ++
	ld ix, _RAM_C440
	ld b, $18
-:
	ld a, (ix+0)
	or a
	call nz, +
	ld de, $0040
	add ix, de
	djnz -
	ret

+:
	ld a, (ix+3)
	cp $02
	ret z
	ld a, (_RAM_C12E)
	add a, (ix+9)
	ld (ix+9), a
	ld a, (_RAM_C12F)
	adc a, (ix+10)
	ld (ix+10), a
	ld a, (_RAM_C130)
	adc a, (ix+11)
	ld (ix+11), a
	ret

++:
	ld a, (_RAM_C12E)
	add a, (hl)
	ld (hl), a
	inc hl
	ld a, (_RAM_C12F)
	adc a, (hl)
	ld (hl), a
	inc hl
	ld a, (_RAM_C130)
	adc a, (hl)
	ld (hl), a
	ret

_LABEL_1B1D:
	ld a, (_RAM_C0A2)
	or a
	jr z, +
	ld a, (_RAM_C117)
	or a
	jp nz, _LABEL_1BBD
+:
	ld de, $7880
	ld b, $20
	ld a, (_RAM_C117)
_LABEL_1B32:
	ld (_RAM_SCREEN_X_TILE), a
	ld (_RAM_C10B), a
	push bc
	push de
	call +
	pop de
	pop bc
	inc de
	inc de
	ld a, (_RAM_SCREEN_X_TILE)
	inc a
	djnz _LABEL_1B32
	ld a, (_RAM_C117)
	ld (_RAM_SCREEN_X_TILE), a
	ld (_RAM_C10B), a
	ret

+:
	ld a, :Bank15
	ld (_RAM_FFFF), a
	push de
	ld a, (_RAM_C10B)
	srl a
	ld c, a
	ld b, $00
	ld l, a
	ld h, b
	add hl, hl
	ld e, l
	ld d, h
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, de
	ld bc, _RAM_LEVEL_LAYOUT
	add hl, bc
	push hl
	pop iy
	pop de
	ld b, $0B
_LABEL_1B72:
	ld l, (iy+0)
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	push bc
	ld c, l
	ld b, h
	ld hl, (_RAM_C10C)
	add hl, bc
	pop bc
	ld a, (_RAM_C10B)
	rrca
	jp nc, +
	inc hl
	inc hl
+:
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	ld a, (hl)
	out (Port_VDPData), a
	push bc
	ld bc, $0040
	ex de, hl
	add hl, bc
	ex de, hl
	pop bc
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	inc hl
	inc hl
	inc hl
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	ld a, (hl)
	out (Port_VDPData), a
	push bc
	ld bc, $0040
	ex de, hl
	add hl, bc
	ex de, hl
	pop bc
	inc iy
	djnz _LABEL_1B72
	ret

_LABEL_1BBD:
	ld de, $7880
	ld b, $20
	xor a
	call _LABEL_1B32
	ld de, $7A80
	ld b, $20
	ld a, (_RAM_C117)
-:
	ld (_RAM_SCREEN_X_TILE), a
	ld (_RAM_C10B), a
	push bc
	push de
	call +
	pop de
	pop bc
	inc de
	inc de
	ld a, (_RAM_SCREEN_X_TILE)
	inc a
	djnz -
	ld a, (_RAM_C117)
	ld (_RAM_SCREEN_X_TILE), a
	ld (_RAM_C10B), a
	ret

+:
	ld a, :Bank15
	ld (_RAM_FFFF), a
	push de
	ld a, (_RAM_C10B)
	srl a
	ld c, a
	ld b, $00
	ld l, a
	ld h, b
	add hl, hl
	ld e, l
	ld d, h
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, de
	ld bc, _RAM_D004
	add hl, bc
	push hl
	pop iy
	pop de
	ld b, $07
_LABEL_1C0E:
	ld l, (iy+0)
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	push bc
	ld c, l
	ld b, h
	ld hl, (_RAM_C10C)
	add hl, bc
	pop bc
	ld a, (_RAM_C10B)
	rrca
	jp nc, +
	inc hl
	inc hl
+:
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	ld a, (hl)
	out (Port_VDPData), a
	push bc
	ld bc, $0040
	ex de, hl
	add hl, bc
	ex de, hl
	pop bc
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	inc hl
	inc hl
	inc hl
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	ld a, (hl)
	out (Port_VDPData), a
	push bc
	ld bc, $0040
	ex de, hl
	add hl, bc
	ex de, hl
	pop bc
	inc iy
	djnz _LABEL_1C0E
	ret

_LABEL_1C59:
	ld a, (iy+7)
	add a, (iy+22)
	ld h, a
	add a, (iy+23)
	ld l, a
	ld a, (ix+7)
	add a, (ix+22)
	ld d, a
	add a, (ix+23)
	ld e, a
	call _LABEL_1DBE
	ret nc
	ld a, (iy+10)
	add a, (iy+24)
	ld h, a
	add a, (iy+25)
	ld l, a
	ld a, (ix+10)
	add a, (ix+24)
	ld d, a
	add a, (ix+25)
	ld e, a
	jp _LABEL_1DBE

_LABEL_1C8C:
	ld ix, _RAM_C400
	ld b, $00
	call +
	ld a, b
	rrca
	ret

+:
	ld a, (_RAM_C42C)
	or a
	ret nz
	ld a, (iy+object.x_position_major)
	or a
	ret nz
	ld a, (_RAM_C425)
	or a
	jp z, _LABEL_1D0B
	ld a, (_RAM_MOVEMENT_STATE)
	ld c, a
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jp c, +
	bit 0, c
	jp nz, _LABEL_1D0B
	ld c, $E0
	jp ++

+:
	bit 0, c
	jp z, _LABEL_1D0B
	ld c, $00
++:
	ld a, (iy+object.y_position_minor)
	add a, (iy+22)
	ld h, a
	add a, (iy+23)
	ld l, a
	ld a, (_RAM_Y_POSITION_MINOR)
	add a, (ix+22)
	ld d, a
	add a, $18
	ld e, a
	call _LABEL_1DBE
	ret nc
	ld a, (iy+object.x_position_minor)
	add a, (iy+24)
	ld h, a
	add a, (iy+25)
	ld l, a
	ld a, (_RAM_X_POSITION_MINOR)
	add a, c
	ld d, a
	add a, $20
	ld e, a
	call _LABEL_1DBE
	ret nc
	ld a, (iy+object.type)
	cp $10 ; Slime (Dungeon)
	jp c, +
	cp $29 ; Projectile (Straw Fly)
	jp nc, +
	ld (iy+object.type), $27 ; Damaged (Knight)
+:
	ld b, $01
	ret

_LABEL_1D0B:
	ld a, (_RAM_RECOVERY_STATUS)
	or a
	ret nz
	ld a, (iy+object.y_position_minor)
	add a, (iy+22)
	ld h, a
	add a, (iy+23)
	ld l, a
	ld a, (_RAM_Y_POSITION_MINOR)
	add a, $E0
	ld d, a
	add a, $20
	ld e, a
	call _LABEL_1DBE
	ret nc
	ld a, (iy+object.x_position_minor)
	add a, (iy+24)
	ld h, a
	add a, (iy+25)
	ld l, a
	ld a, (_RAM_X_POSITION_MINOR)
	add a, $F8
	ld d, a
	add a, $10
	ld e, a
	call _LABEL_1DBE
	ret nc
	ld b, $02
	ld a, (_RAM_C420)
	or a
	ret nz
	ld hl, $FE00
	ld c, $FF
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jp c, +
	ld hl, $0200
	ld c, $00
+:
	ld (_RAM_X_VELOCITY_SUB), hl
	ld a, c
	ld (_RAM_X_VELOCITY_MAJOR), a
	ld a, (_RAM_MOVEMENT_STATE)
	ld (_RAM_PRE_DAMAGE_MOVEMENT_STATE), a
	ld a, $08
	ld (_RAM_C42A), a
	ld a, Movement_Damaged
	ld (_RAM_MOVEMENT_STATE), a
	ld a, $01
	ld (_RAM_RECOVERY_STATUS), a
	ld hl, $0080
	ld (_RAM_RECOVERY_TIMER), hl
	ld a, (iy+27)
	and $0F
	ld c, a
	ld a, (_RAM_BOSS_FIGHT_INITIALIZED)
	or a
	jr z, +
	ld c, (iy+56)
+:
	ld a, c
	neg
	ld (_RAM_INCOMING_LANDAU_DAMAGE), a
	ld a, $91
	ld (_RAM_SOUND_TO_PLAY), a
	ld a, (iy+object.type)
	cp $21 ; Book Thief
	ret nz
	ld a, (iy+56)
	or a
	ret z
	ld a, (_RAM_INVENTORY_BOOK)
	or a
	ret z
	ld a, $01
	ld (iy+29), a
	ld (_RAM_C16D), a
	xor a
	ld (_RAM_INVENTORY_BOOK), a
	ld (_RAM_CCAD), a
	ld (_RAM_C178), a
	ld a, $93
	ld (_RAM_SOUND_TO_PLAY), a
	ret

_LABEL_1DBE:
	ld a, h
	cp d
	jr nc, +
	ld a, l
	cp d
	ccf
	ret

+:
	cp e
	ret

_LABEL_1DC8:
	ex de, hl
	ld (_RAM_C0B0), hl
	call +
	ld hl, (_RAM_C0B0)
	inc hl
	ld (_RAM_C0B0), hl
	call +
	ld hl, (_RAM_C0B0)
	inc hl
	ld (_RAM_C0B0), hl
	call +
	ld hl, (_RAM_C0B0)
	inc hl
	ld (_RAM_C0B0), hl
	call +
	ret

+:
	ex de, hl
	call _LABEL_1DF5
	inc hl
	ex de, hl
	ret

_LABEL_1DF5:
	ld a, (hl)
	or a
	ret z
	bit 7, a
	jr nz, +
	ld b, a
	inc hl
-:
	call ++
	djnz -
	inc hl
	jp _LABEL_1DF5

+:
	and $7F
	ld b, a
	inc hl
-:
	call ++
	inc hl
	djnz -
	jp _LABEL_1DF5

++:
	ld a, e
	out (Port_VDPAddress), a
	push af
	pop af
	ld a, d
	out (Port_VDPAddress), a
	nop
	ld a, (hl)
	out (Port_VDPData), a
	inc de
	inc de
	inc de
	inc de
	ret

_LABEL_1E25:
	ld a, (hl)
	or a
	ret z
	bit 7, a
	jr nz, +
	ld b, a
	inc hl
-:
	call ++
	djnz -
	inc hl
	jp _LABEL_1E25

+:
	and $7F
	ld b, a
	inc hl
-:
	call ++
	inc hl
	djnz -
	jp _LABEL_1E25

++:
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	nop
	ld a, (hl)
	out (Port_VDPData), a
	inc de
	ret

_LABEL_1E50:
	ld de, _RAM_LEVEL_LAYOUT
--:
	ld a, (hl)
	or a
	ret z
	bit 7, a
	jr nz, +
	ld b, a
	inc hl
	ld a, (hl)
-:
	ld (de), a
	inc de
	djnz -
	inc hl
	jp --

+:
	and $7F
	ld b, a
	inc hl
-:
	ld a, (hl)
	ld (de), a
	inc hl
	inc de
	djnz -
	jp --

_LABEL_1E72:
	ld iy, _RAM_C0BC
	ld (iy+0), a
	ld (iy+1), a
	ex de, hl
	ld (_RAM_C0BA), hl
	ex de, hl
	call _LABEL_1EB8
	ld hl, _DATA_1E95
	ld de, (_RAM_C0BA)
	inc de
	ld a, (iy+1)
	ld (iy+0), a
	jp _LABEL_1EB8

; Data from 1E95 to 1E99 (5 bytes)
_DATA_1E95:
.db $3C $00 $3C $00 $00

_LABEL_1E9A: ; Something to do with drawing building backgrounds, also title screen
	ld iy, _RAM_C0BC
	ld (iy+0), a
	ld (iy+1), a
	ex de, hl
	ld (_RAM_C0BA), hl
	ex de, hl
	call _LABEL_1EB8
	inc hl
	ld de, (_RAM_C0BA)
	inc de
	ld a, (iy+1)
	ld (iy+0), a
_LABEL_1EB8:
	ld a, (hl)
	or a
	ret z
	bit 7, a
	jr nz, +
	ld b, a
	inc hl
-:
	call ++
	djnz -
	inc hl
	jp _LABEL_1EB8

+:
	and $7F
	ld b, a
	inc hl
-:
	call ++
	inc hl
	djnz -
	jp _LABEL_1EB8

++:
	ld a, e
	out (Port_VDPAddress), a
	ld a, d
	out (Port_VDPAddress), a
	push af
	pop af
	ld a, (hl)
	out (Port_VDPData), a
	inc de
	inc de
	dec (iy+0)
	ret nz
	ld a, (iy+1)
	ld (iy+0), a
	push hl
	add a, a
	ld l, a
	ld a, $40
	sub l
	ld l, a
	ld h, $00
	add hl, de
	ex de, hl
	pop hl
	ret

_LABEL_1EFB:
	call +
	jp ++

+:
	ld hl, (_RAM_C0B4)
	ex de, hl
	call _LABEL_387
	ld hl, (_RAM_C0B6)
	ex de, hl
	ld hl, _RAM_LEVEL_LAYOUT
--:
	in a, (Port_VDPData)
	ld bc, $0800
-:
	rlca
	rr c
	djnz -
	ld (hl), c
	inc hl
	dec de
	ld a, d
	or e
	jr nz, --
++:
	ld hl, (_RAM_C0B8)
	ex de, hl
	ld hl, (_RAM_C0B6)
	ld b, h
	ld c, l
	ld hl, _RAM_LEVEL_LAYOUT
	call _LABEL_387
-:
	ld a, (hl)
	out (Port_VDPData), a
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, -
	ret

_LABEL_1F39:
	ld a, (_RAM_C13F)
	or a
	jp nz, _LABEL_1FEA
	ld bc, $0600
	call SendVDPCommand
	ld bc, $8201
	call SendVDPCommand
	ld bc, $0008
	call SendVDPCommand
	ld bc, $FF0A
	call SendVDPCommand
	ld a, :Bank3
	ld (_RAM_FFFF), a
	call _LABEL_C989
	ld a, $8A
	ld (_RAM_SOUND_TO_PLAY), a
	ld de, $7F00
	ld a, $D0
	ld (_RAM_C300), a
	call _LABEL_316
	ld a, :Bank6
	ld (_RAM_FFFF), a
	ld a, $01
	ld (_RAM_C13F), a
	xor a
	ld (_RAM_C0A2), a
	ld (_RAM_C109), a
	ld (_RAM_C111), a
	ld iy, _RAM_C400
	call _LABEL_8AC
	ld a, $D0
	ld (_RAM_C300), a
	ld de, $7880
	ld hl, $2000
	ld bc, $0300
	call _LABEL_331
	ld hl, _DATA_COMPRESSED_FONT_TILES_
	ld de, $4400
	call _LABEL_1E25
	ld hl, _DATA_19F31
	ld de, $788E
	ld a, $12
	call _LABEL_1E9A
	ld hl, _DATA_19F97
	ld de, $7BC8
	ld a, $18
	call _LABEL_1E9A
	ld a, (_RAM_C118)
	cp $07
	jp z, _LABEL_21CB
	ld a, (_RAM_C152)
	and $7F
	cp $01
	jp z, _LABEL_21CB
	cp $07
	jp z, _LABEL_240D
	cp $03
	jp z, _LABEL_2424
	cp $06
	jp z, _LABEL_2444
	ld a, (_RAM_BUILDING_INDEX)
	cp Building_Varlin
	jp z, _LABEL_247F
_LABEL_1FE4:
	ld bc, $E201
	jp SendVDPCommand

_LABEL_1FEA:
	ld a, (_RAM_C135)
	dec a
	jr z, +
	cp $03
	ret nz
	jp ++

+:
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	and Button_1_Mask|Button_2_Mask
	ret z
	ld a, $02
	ld (_RAM_C135), a
	ret

++:
	ld a, (_RAM_BUILDING_INDEX)
	cp Building_Varlin
	jp z, _LABEL_2077
	ld a, (_RAM_C118)
	cp $07
	jr nz, +
	ld hl, $18A8
	ld a, (_RAM_C141)
	call _LABEL_201D
	jp _LABEL_22DA ; Handle building extra effects (heals, flags, etc)

_LABEL_201D:
	ld (_RAM_CURRENT_MAP), a
	ld a, $01
	ld (_RAM_BUILDING_STATUS), a ; Building_Status_Load_Map
	ld (_RAM_C400), a
	ld (_RAM_C161), a
	ld a, h
	ld (_RAM_C163), a
	ld a, $80
	ld (_RAM_C164), a
	ld a, l
	ld (_RAM_C165), a
	xor a
	ld (_RAM_C13F), a
	ld (_RAM_C140), a
	ld (_RAM_C141), a
	ret

+:
	ld a, Building_Status_Boss_Fight
	ld (_RAM_BUILDING_STATUS), a
	ld a, $01
	ld (_RAM_C155), a
	xor a
	ld (_RAM_BOSS_FIGHT_INITIALIZED), a
	ld (_RAM_C13F), a
	ld (_RAM_C140), a
	ld (_RAM_C141), a
	ld (_RAM_C162), a
	ld a, (_RAM_C152)
	and $7F
	cp $01
	jp z, _LABEL_22DA
	cp $07
	jp z, _LABEL_2419
	cp $03
	jp z, _LABEL_2430
	cp $06
	jp z, _LABEL_2459
	ret

_LABEL_2077:
	ld hl, $1498
	ld a, $7C
	call _LABEL_201D
	jp _LABEL_2494

_LABEL_2082:
	ld a, $03
	ld (_RAM_C135), a
	xor a
	ld (_RAM_C136), a
	ld (_RAM_C13D), a
	ld (_RAM_C137), hl
	ld a, $20
	ld (_RAM_C139), a
	ld a, $08
	ld (_RAM_C13A), a
	ld hl, $0100
	ld (_RAM_C13B), hl
	ret

_LABEL_20A2:
	ld a, (_RAM_C13F)
	or a
	ret z
	ld a, :Bank6
	ld (_RAM_FFFF), a
	ld a, (_RAM_C135)
	or a
	jp z, +
	dec a
	ret z
	dec a
	jp z, _LABEL_2102
	dec a
	jp z, _LABEL_2151
	ret

+:
	ld hl, _RAM_C139
	dec (hl)
	ret nz
	ld a, (_RAM_C13A)
	ld (hl), a
	ld hl, _RAM_C13D
	inc (hl)
	call _LABEL_213B
	ld a, (_RAM_C13D)
	cp $04
	ret nz
	ld a, $01
	ld (_RAM_C135), a
	ld a, (_RAM_C179)
	cp $02
	jr z, +
	cp $13
	ret nz
	ld a, $01
	ld (_RAM_INVENTORY_HERB), a
	ld (_RAM_C16D), a
	ld a, $93
	ld (_RAM_SOUND_TO_PLAY), a
	ret

+:
	ld a, $01
	ld (_RAM_INVENTORY_BOOK), a
	ld (_RAM_CCAD), a
	ld (_RAM_C16D), a
	ld a, $93
	ld (_RAM_SOUND_TO_PLAY), a
	ret

_LABEL_2102:
	ld hl, _RAM_C139
	dec (hl)
	ret nz
	ld a, (_RAM_C13A)
	ld (hl), a
	ld hl, _RAM_C13D
	dec (hl)
	call _LABEL_213B
	ld a, (_RAM_C13D)
	or a
	ret nz
	ld a, $03
	ld (_RAM_C135), a
	ld a, $20
	ld (_RAM_C139), a
	ld hl, _RAM_C136
	inc (hl)
	ld e, (hl)
	ld d, $00
	ld hl, (_RAM_C137)
	add hl, de
	ld a, (hl)
	cp $FF
	ret nz
	ld a, $B0
	ld (_RAM_SOUND_TO_PLAY), a
	ld a, $40
	ld (_RAM_C139), a
	ret

_LABEL_213B:
	ld a, (_RAM_C13D)
	ld e, a
	ld d, $00
	ld hl, _DATA_214C
	add hl, de
	ld a, (hl)
	ld de, $C00F
	jp _LABEL_316

; Data from 214C to 2150 (5 bytes)
_DATA_214C:
.db $00 $15 $2A $3F $2A

_LABEL_2151:
	ld hl, _RAM_C139
	dec (hl)
	ret nz
	ld a, (_RAM_C13A)
	ld (hl), a
	ld a, (_RAM_C136)
	ld e, a
	ld d, $00
	ld hl, (_RAM_C137)
	add hl, de
	ld a, (hl)
	cp $FF
	jp z, +
	ld (_RAM_C179), a
	ld de, $7FFE
	ld l, a
	ld h, $00
	add hl, hl
	add hl, de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld de, $7C0C
	ld a, $14
	call _LABEL_1E72
	xor a
	ld (_RAM_C135), a
	ret

+:
	ld a, $04
	ld (_RAM_C135), a
	ret

_LABEL_218C:
	ld a, (_RAM_C16D)
	or a
	ret z
	xor a
	ld (_RAM_C16D), a
	ld a, :Bank3
	ld (_RAM_FFFF), a
	ld hl, _DATA_EF2B
	ld de, $782C
	ld a, (_RAM_INVENTORY_BOOK)
	call +
	ld hl, _DATA_EF3D
	ld de, $7832
	ld a, (_RAM_INVENTORY_TREE_LIMB)
	call +
	ld hl, _DATA_EF34
	ld de, $7838
	ld a, (_RAM_INVENTORY_HERB)
+:
	or a
	jr z, +
	ld a, $02
	jp _LABEL_1E9A

+:
	ld hl, _DATA_EF22
	ld a, $02
	jp _LABEL_1E9A

_LABEL_21CB:
	ld a, (_RAM_CURRENT_MAP)
	ld (_RAM_C141), a
	call _LABEL_21DA
	call _LABEL_223B
	jp _LABEL_1FE4

_LABEL_21DA:
	ld hl, _DATA_19FE6 - 2
	call +
	call _LABEL_3DA
	ld hl, _DATA_19FFE - 2
	call +
	ld de, $5400
	call _LABEL_1DC8
	ld hl, _DATA_1A016 - 2
	call +
	ld de, $78D0
	ld a, $10
	jp _LABEL_1E9A

+:
	ld a, (_RAM_BUILDING_INDEX)
	cp Building_Lindon
	jr z, +
-:
	add a, a
	ld e, a
	ld d, $00
	add hl, de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ret

+:
	ld c, $07
	ld a, (_RAM_FLAG_MAYORS_DAUGHTER_RETURNED)
	or a
	jr z, +
	ld c, $09
+:
	ld a, c
	jr -

; Pointer Table from 221B to 223A (16 entries, indexed by _RAM_BUILDING_INDEX)
_DATA_221B:
.dw _DATA_1ABC7 _RAM_CC21 ; Harfoot Text(?) & Flags
.dw _DATA_1ABFF _RAM_CC31 ; Amon Text(?) & Flags
.dw _DATA_1AC38 _RAM_CC41 ; Dwarle Text(?) & Flags
.dw _DATA_1AC71 _RAM_CC51 ; Ithile Text(?) & Flags
.dw _DATA_1ACAA _RAM_CC61 ; Pharazon Text(?) & Flags
.dw _DATA_1ACE8 _RAM_CC71 ; ??? Text(?) & Flags
.dw _DATA_1AD20 _RAM_CC81 ; Lindon Text(?) & Flags
.dw _DATA_1AD59 _RAM_CC91 ; Ulmo Text(?) & Flags

_LABEL_223B:
	ld a, (_RAM_BUILDING_INDEX)
	add a, a
	add a, a ; Multiply by 4 (compensation for two 16 bit pointers in the table above)
	ld hl, _DATA_221B - 4
	ld e, a
	ld d, $00
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	push de
	pop iy
	ld b, $0E
	ld c, $00
	ld de, _RAM_FLAG_GAME_STARTED
----:
	ld a, (de)
	or a
	jr nz, +
---:
	inc c
	inc hl
	inc de
	djnz ----
	dec hl
	dec de
	dec c
	ld b, $0E
--:
	ld a, (de)
	or a
	jr nz, ++
-:
	dec c
	dec hl
	dec de
	djnz --
	inc c
	inc de
	inc de
	jp +++

+:
	ld a, (hl)
	or a
	jp nz, ---
	set 0, (hl)
	jp +++

++:
	bit 7, (hl)
	jp nz, -
+++:
	ld e, c
	ld a, c
	add a, a
	ld c, a
	ld b, $00
	push iy
	pop hl
	add hl, bc
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld (_RAM_C137), hl
	inc e
	ld a, e
	ld (_RAM_BUILDING_FLAG_PROGRESS), a
	ld a, (_RAM_BUILDING_INDEX)
	cp Building_Amon
	jp nz, _LABEL_2082
	ld a, (_RAM_CCAD)
	or a
	jp nz, _LABEL_2082
	ld a, e
	cp $01
	jp z, _LABEL_2082
	cp $04
	jp z, _LABEL_2082
	cp $07
	jp z, _LABEL_2082
	cp $08
	jp z, _LABEL_2082
	ld hl, _DATA_22D6
	ld a, (_RAM_C178)
	or a
	jr z, +
	ld hl, _DATA_22D6 + 2
+:
	ld (_RAM_C137), hl
	ld a, $01
	ld (_RAM_C178), a
	jp _LABEL_2082

; Data from 22D6 to 22D9 (4 bytes)
_DATA_22D6:
.db $25 $FF $26 $FF

_LABEL_22DA:
	ld a, (_RAM_BUILDING_INDEX)
	ld hl, _DATA_22E3 - 2
	jp CallFunctionFromPointerTable

; Jump Table from 22E3 to 22F2 (8 entries, indexed by _RAM_BUILDING_INDEX)
_DATA_22E3:
.dw _LABEL_22F3 ; Harfoot
.dw _LABEL_230B ; Amon
.dw _LABEL_2355 ; Dwarle
.dw _LABEL_2370 ; Ithile
.dw _LABEL_2394 ; Pharazon
.dw _LABEL_23C3 ; Unused 0x06
.dw _LABEL_23C4 ; Lindon
.dw _LABEL_23F0 ; Ulmo

; 1st entry of Jump Table from 22E3 (indexed by _RAM_BUILDING_INDEX)
_LABEL_22F3:
	call _LABEL_2408
	ld c, $30
	ld a, (_RAM_BUILDING_FLAG_PROGRESS)
	cp $07
	jp nz, ApplyLandauHealOrDamageFromC
	ld a, $01
	ld (_RAM_FLAG_MEDUSA_SPAWNED), a
	ld hl, _RAM_CC27
	set 7, (hl)
	ret

; 2nd entry of Jump Table from 22E3 (indexed by _RAM_BUILDING_INDEX)
_LABEL_230B:
	call _LABEL_2408
	ld a, (_RAM_BUILDING_FLAG_PROGRESS)
	cp $01
	jr z, +
	cp $07
	jr z, ++
	cp $0C
	jr z, +++
	ret

+:
	ld a, $01
	ld (_RAM_FLAG_ULMO_BUILDING_ENABLED), a
	ld (_RAM_INVENTORY_BOOK), a
	ld (_RAM_CCAD), a
	ld (_RAM_C16D), a
	ld b, $08
	ld hl, _RAM_CC21
	ld de, $0010
-:
	ld (hl), $01
	add hl, de
	djnz -
	ret

++:
	ld hl, _RAM_CC37
	set 7, (hl)
	ld a, (_RAM_CC67)
	or a
	ret z
	ld a, $01
	ld (_RAM_CCA3), a
	ret

+++:
	ld a, (_RAM_CCAD)
	or a
	ret z
	ld a, $03
	ld (_RAM_SWORD_DAMAGE), a
	ret

; 3rd entry of Jump Table from 22E3 (indexed by _RAM_BUILDING_INDEX)
_LABEL_2355:
	call _LABEL_2408
	ld a, (_RAM_BUILDING_FLAG_PROGRESS)
	cp $01
	jr z, +
	cp $06
	jr z, ++
	cp $0C
	jr z, +++
	ret

+:
	ret

++:
	ld a, $01
	ld (_RAM_CCA0), a
	ret

+++:
	ret

; 4th entry of Jump Table from 22E3 (indexed by _RAM_BUILDING_INDEX)
_LABEL_2370:
	call _LABEL_2408
	ld a, (_RAM_BUILDING_FLAG_PROGRESS)
	cp $04
	jr z, +
	cp $05
	jr z, ++
	cp $06
	jr nc, +++
	ret

+:
	ld a, $01
	ld (_RAM_CCA1), a
	ret

++:
	ld a, $02
	ld (_RAM_BOW_DAMAGE), a
	ret

+++:
	ld c, $30
	jp ApplyLandauHealOrDamageFromC

; 5th entry of Jump Table from 22E3 (indexed by _RAM_BUILDING_INDEX)
_LABEL_2394:
	call _LABEL_2408
	ld a, (_RAM_BUILDING_FLAG_PROGRESS)
	cp $01
	jr z, +
	cp $03
	jr z, ++
	cp $04
	jr z, +++
	cp $07
	jr z, ++++
	cp $08
	jr z, +++++
	ret

+:
	ret

++:
	ret

+++:
	ret

++++:
	ld a, (_RAM_CC37)
	or a
	ret z
	ld a, $01
	ld (_RAM_CCA3), a
	ret

+++++:
	ld a, $01
	ld (_RAM_CC1A), a
	ret

; 6th entry of Jump Table from 22E3 (indexed by _RAM_BUILDING_INDEX)
_LABEL_23C3:
	ret

; 7th entry of Jump Table from 22E3 (indexed by _RAM_BUILDING_INDEX)
_LABEL_23C4:
	call _LABEL_2408
	ld a, (_RAM_BUILDING_FLAG_PROGRESS)
	cp $05
	jr z, +
	cp $0A
	jr z, ++
	cp $06
	jr nc, +++
	ret

+:
	ld a, $01
	ld (_RAM_FLAG_PIRATE_PATH_OPEN), a
	ret

++:
	ld a, $01
	ld (_RAM_CC1B), a
	ld (_RAM_CCA4), a
	ld hl, _RAM_CC8A
	set 7, (hl)
	ret

+++:
	ld c, $30
	jp ApplyLandauHealOrDamageFromC

; 8th entry of Jump Table from 22E3 (indexed by _RAM_BUILDING_INDEX)
_LABEL_23F0:
	ld a, (_RAM_BUILDING_FLAG_PROGRESS)
	cp $02
	jr z, +
	cp $03
	jr z, ++
	ret

+:
	ld a, $01
	ld (_RAM_FLAG_TREE_SPIRIT_SPAWNED), a
	ret

++:
	ld hl, _RAM_CC93
	set 7, (hl)
	ret

_LABEL_2408:
	ld c, $08
	jp ApplyLandauHealOrDamageFromC

_LABEL_240D:
	call _LABEL_21DA
	ld hl, _DATA_1AD92
	call _LABEL_2082
	jp _LABEL_1FE4

_LABEL_2419:
	ld a, $08
	ld (_RAM_C152), a
	ld a, $01
	ld (_RAM_FLAG_MAYORS_DAUGHTER_RETURNED), a
	ret

_LABEL_2424:
	call _LABEL_21DA
	ld hl, _DATA_1AD95
	call _LABEL_2082
	jp _LABEL_1FE4

_LABEL_2430:
	ld a, $03
	ld (_RAM_C152), a
	ld a, $01
	ld (_RAM_C16D), a
	ld a, $02
	ld (_RAM_CCAD), a
	xor a
	ld (_RAM_INVENTORY_BOOK), a
	ret

_LABEL_2444:
	call _LABEL_21DA
	ld hl, _DATA_1AD95 + 2
	ld a, (_RAM_FLAG_DUELS_DEFEATED)
	or a
	jr z, +
	ld hl, _DATA_1AD99
+:
	call _LABEL_2082
	jp _LABEL_1FE4

_LABEL_2459:
	ld a, (_RAM_FLAG_DUELS_DEFEATED)
	or a
	jr nz, +
	ld a, $06
	ld (_RAM_C152), a
	ret

+:
	ld a, Building_Status_Load_Map
	ld (_RAM_BUILDING_STATUS), a
	ld a, $78 ; Castle Elder
	ld (_RAM_CURRENT_MAP), a
	xor a
	ld (_RAM_C155), a
	ld a, $01
	ld (_RAM_CC17), a
	ld (_RAM_C16D), a
	ld (_RAM_INVENTORY_HERB), a
	ret

_LABEL_247F:
	call _LABEL_21DA
	ld hl, _DATA_1AD9F - 2
	ld a, (_RAM_CC1E)
	or a
	jr nz, +
	ld hl, _DATA_1AD99 + 2
+:
	call _LABEL_2082
	jp _LABEL_1FE4

_LABEL_2494:
	ld a, (_RAM_CC1E)
	or a
	ret z
	ld a, Building_Status_Ending
	ld (_RAM_BUILDING_STATUS), a
	ret

_LABEL_249F:
	ld (iy+3), $01
_LABEL_24A3:
	ld (iy+4), l
	ld (iy+5), h
	ld (iy+54), $01
	ret

_LABEL_24AE:
	ld (iy+12), $02
	jr +

_LABEL_24B4:
	ld (iy+12), $03
+:
	ld (iy+13), $08
	ret

_LABEL_24BD:
	ld a, (_RAM_X_POSITION_MINOR)
	sub (iy+object.x_position_minor)
	bit 7, a
	ld (iy+41), $00
	ret z
	ld (iy+41), $01
	neg
	ret

_LABEL_24D1:
	inc (iy+40)
	ld a, (iy+40)
	cp (iy+39)
	ret nz
	ld (iy+40), $00
	ret

_LABEL_24E0:
	ld a, (iy+object.x_velocity_sub)
	cpl
	ld l, a
	ld a, (iy+object.x_velocity_minor)
	cpl
	ld h, a
	inc hl
	ld (iy+object.x_velocity_sub), l
	ld (iy+object.x_velocity_minor), h
	scf
	ret

_LABEL_24F3:
	ld a, (iy+object.y_velocity_sub)
	cpl
	ld l, a
	ld a, (iy+object.y_velocity_minor)
	cpl
	ld h, a
	inc hl
	ld (iy+object.y_velocity_sub), l
	ld (iy+object.y_velocity_minor), h
	ret

_LABEL_2505:
	ld b, $04
	ld hl, _RAM_C900
-:
	ld a, (hl)
	or a
	jr z, +
	ld de, $0040
	add hl, de
	djnz -
	ret

+:
	ld (hl), $29
	ld a, (iy+object.y_position_minor)
	ld de, $0007
	add hl, de
	ld (hl), a
	ld de, $0003
	add hl, de
	ld a, (iy+object.x_position_minor)
	ld (hl), a
	ld de, $0024
	add hl, de
	ld (hl), c
	scf
	ret

_LABEL_252E:
	bit 7, (iy+object.x_velocity_minor)
	jr nz, +
	ld (iy+4), e
	ld (iy+5), d
	ret

+:
	ld (iy+4), l
	ld (iy+5), h
	ret

_LABEL_2542:
	ld de, $F808
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld de, $F8F8
+:
	call _LABEL_15E5
	ret z
	jp _LABEL_24E0

; 16th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2555:
	ld a, (iy+3)
	or a
	jp nz, +
	ld (iy+24), $FA
	ld (iy+25), $0C
	ld (iy+22), $F0
	ld (iy+23), $0C
	ld hl, _DATA_85F2
	ld (iy+12), $03
	ld (iy+13), $08
	jp _LABEL_249F

+:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	dec a
	jp z, ++
	dec a
	jp z, _LABEL_25DC
	ld a, (iy+39)
	or a
	jp nz, +
	call _LABEL_24BD
	cp $24
	ret nc
	ld (iy+39), $01
	ret

+:
	call _LABEL_84C
	ld a, (iy+14)
	cp $02
	ret nz
	ld a, (iy+15)
	cp $07
	ret nz
	inc (iy+14)
	ld (iy+1), $01
	ld (iy+object.y_velocity_sub), $80
	ld (iy+object.y_velocity_minor), $02
	ret

++:
	call ApplyObjectYVelocity
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ld (iy+1), $02
	inc (iy+14)
	ld (iy+15), $08
	ret

_LABEL_25DC:
	ld a, (iy+2)
	or a
	jp nz, +
	dec (iy+15)
	ret nz
	ld (iy+2), $01
	ld (iy+14), $00
	ld (iy+40), $30
	call _LABEL_24AE
	ld hl, _DATA_85FC
	ld de, $FE80
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, 1
	ld de, $0180
	ld (iy+object.x_velocity_minor), d
	ld (iy+object.x_velocity_sub), e
	jp _LABEL_24A3

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	dec (iy+40)
	ret nz
	ld (iy+40), $30
	jp _LABEL_24E0

; 18th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2621:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F8
	ld (iy+25), $10
	ld (iy+22), $F0
	ld (iy+23), $10
	call _LABEL_24B4
	ld hl, _DATA_8690
	ld de, $FE80
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_86B1
	ld de, $0180
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call ApplyObjectXVelocity
	call _LABEL_84C
	ld a, (iy+1)
	dec a
	jp z, +++
	ld a, (iy+object.x_position_minor)
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	cp $20
	ret nc
	jr ++

+:
	cp $E0
	ret c
++:
	ld (iy+1), $01
	ret

+++:
	ld a, (iy+2)
	or a
	jp nz, ++
	ld (iy+2), $01
	ld de, $FF00
	ld hl, _DATA_8690
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld de, $0100
	ld hl, _DATA_86B1
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $03
	jp _LABEL_24A3

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+38)
	or a
	ret nz
	call ApplyObjectYVelocity
	ld a, (_RAM_Y_POSITION_MINOR)
	ld b, a
	ld a, (iy+object.y_position_minor)
	add a, $18
	cp b
	ret c
	ld (iy+38), $01
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $00
	ld (iy+object.x_velocity_sub), $00
	ld a, (iy+object.x_velocity_minor)
	add a, a
	add a, a
	ld (iy+object.x_velocity_minor), a
	ret

; 41st entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_26DD:
	ld a, (iy+3)
	or a
	jp nz, _LABEL_286D
	ld (iy+27), $01
	ld a, (iy+46)
	cp $01
	jp z, _LABEL_2758
	cp $03
	jp z, _LABEL_2764
	cp $04
	jp z, _LABEL_2779
	cp $05
	jp z, _LABEL_27C3
	cp $06
	jp z, _LABEL_27F8
	cp $07
	jp z, _LABEL_27F8
	cp $08
	jp z, _LABEL_2834
	cp $09
	jp z, _LABEL_2834
	cp $0A
	jp z, _LABEL_2834
	cp $0B
	jp z, _LABEL_2834
	ld a, (iy+object.y_position_minor)
	add a, $FE
	ld (iy+object.y_position_minor), a
	ld de, $FC00
	ld hl, _DATA_9466
	ld b, $F0
	ld a, (iy+object.x_position_minor)
	cp $80
	jr nc, +
	ld de, $0400
	ld hl, _DATA_9493
	ld b, $10
+:
	ld a, (iy+object.x_position_minor)
	add a, b
	ld (iy+object.x_position_minor), a
	ld (iy+object.x_velocity_minor), d
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.y_velocity_sub), $F0
	ld (iy+object.y_velocity_minor), $FF
	ld (iy+14), $02
	jp _LABEL_249F

_LABEL_2758:
	call _LABEL_2C9A
	call _LABEL_24B4
	ld hl, _DATA_94C0
	jp _LABEL_249F

_LABEL_2764:
	ld (iy+15), $08
	ld (iy+39), $00
	ld (iy+40), $00
	call _LABEL_2C9A
	ld hl, _DATA_85F2
	jp _LABEL_249F

_LABEL_2779:
	ld (iy+24), $FC
	ld (iy+25), $08
	ld (iy+22), $F0
	ld (iy+23), $10
	ld a, (iy+object.y_position_minor)
	ld b, $F0
	add a, b
	ld (iy+object.y_position_minor), a
	ld (iy+39), $00
	ld (iy+40), $00
	ld (iy+3), $01
	ld hl, _DATA_94C0
	ld de, $0400
	ld b, $0C
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld de, $FC00
	ld b, $F4
+:
	ld a, (iy+object.x_position_minor)
	add a, b
	ld (iy+object.x_position_minor), a
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_24A3

_LABEL_27C3:
	ld (iy+24), $FC
	ld (iy+25), $08
	ld (iy+22), $F4
	ld (iy+23), $04
	ld a, (iy+object.y_position_minor)
	add a, $E7
	ld (iy+object.y_position_minor), a
	ld de, $0400
	ld hl, _DATA_94E0
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld de, $FC00
	ld hl, _DATA_94D9
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

_LABEL_27F8:
	ld (iy+24), $FC
	ld (iy+25), $08
	ld (iy+22), $F0
	ld (iy+23), $10
	ld (iy+15), $10
	ld b, $EC
	ld hl, _DATA_94E7
	cp $06
	jr z, +
	ld b, $14
	ld hl, _DATA_9503
+:
	ld (iy+4), l
	ld (iy+5), h
	ld a, (iy+object.x_position_minor)
	add a, b
	ld (iy+object.x_position_minor), a
	ld a, (iy+object.y_position_minor)
	add a, $E0
	ld (iy+object.y_position_minor), a
	ld (iy+3), $02
	ret

_LABEL_2834:
	call _LABEL_24AE
	ld (iy+24), $FC
	ld (iy+25), $08
	ld (iy+22), $F0
	ld (iy+23), $10
	ld (iy+3), $01
	ld a, (iy+46)
	add a, a
	ld e, a
	ld d, $00
	ld hl, $2855
	add hl, de
	ld a, (hl)
	ld (iy+object.y_velocity_minor), a
	inc hl
	ld a, (hl)
	ld (iy+object.x_velocity_minor), a
	ld hl, _DATA_93CC
	jp _LABEL_24A3

; Data from 2865 to 286C (8 bytes)
.db $FD $FE $FE $FF $FE $01 $FD $02

_LABEL_286D:
	call _LABEL_1C8C
	ret c
	ld a, (iy+object.x_position_major)
	or a
	jp nz, _LABEL_8AC
	ld a, (iy+46)
	cp $06
	jp z, _LABEL_28DA
	cp $07
	jp z, _LABEL_28DA
	ld de, $0000
	call _LABEL_15E5
	jp nz, _LABEL_8AC
	ld de, $F808
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld de, $F8F8
+:
	call _LABEL_15E5
	jp nz, _LABEL_8AC
	ld a, (iy+46)
	cp $08
	jp z, _LABEL_2909
	cp $09
	jp z, _LABEL_2909
	cp $0A
	jp z, _LABEL_2909
	cp $0B
	jp z, _LABEL_2909
	cp $03
	jr nz, +
	ld a, (iy+14)
	cp $03
	jr z, +
	dec (iy+15)
	jr nz, +
	ld (iy+15), $08
	inc (iy+14)
+:
	ld e, (iy+39)
	ld d, (iy+40)
	call _LABEL_869
	jp ApplyObjectXVelocity

_LABEL_28DA:
	ld a, (iy+14)
	cp $03
	jr z, +
	dec (iy+15)
	ret nz
	ld (iy+15), $10
	inc (iy+14)
	ret

+:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+2), $01
	call _LABEL_2C9A
+:
	ld a, (iy+object.y_position_minor)
	cp $C0
	jp nc, _LABEL_8AC
	call ApplyObjectYVelocity
	jp ApplyObjectXVelocity

_LABEL_2909:
	call ApplyObjectXVelocity
	ld de, $0040
	call _LABEL_3084
	jp ApplyObjectYVelocity

; 19th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2915:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld a, r
	and $03
	ld (iy+56), a
	and $01
	ld (iy+1), a
	ld (iy+24), $F1
	ld (iy+25), $1E
	ld (iy+22), $E0
	ld (iy+23), $1C
	call _LABEL_24AE
	ld hl, _DATA_93DA
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_9420
+:
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+2)
	or a
	jp z, +
	call _LABEL_84C
	ld a, (iy+1)
	or a
	jp z, ++
	dec a
	jp z, _LABEL_2A05
	jp _LABEL_2A20

+:
	ld (iy+2), $01
	ld de, $FE00
	ld hl, _DATA_93DA
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_9420
	ld de, $0200
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	call _LABEL_24A3
	ld a, (iy+1)
	dec a
	jp z, _LABEL_2C9A
	ld a, r
	and $1F
	or $20
	ld (iy+40), a
	ld (iy+42), $03
	ret

++:
	ld a, (iy+39)
	or a
	jp nz, _LABEL_29F3
	call ApplyObjectXVelocity
	dec (iy+40)
	jr z, +++
	ld a, (iy+42)
	or a
	ret z
	ld a, (iy+object.x_position_minor)
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	cp $10
	ret nc
	jr ++

+:
	cp $F0
	ret c
++:
	ld a, (iy+56)
	or a
	jr z, +
	ld (iy+1), $02
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $03
	jr ++

+:
	dec (iy+42)
++:
	call _LABEL_24E0
	ld de, _DATA_9420
	ld hl, _DATA_93DA
	jp _LABEL_252E

+++:
	ld (iy+39), $01
	ld (iy+41), $30
	ld c, $01
	jp _LABEL_2505

_LABEL_29F3:
	dec (iy+41)
	ret nz
	ld (iy+39), $00
	ld a, r
	and $1F
	or $20
	ld (iy+40), a
	ret

_LABEL_2A05:
	call ApplyObjectXVelocity
	call ApplyObjectYVelocity
	ld a, (iy+39)
	or a
	ret nz
	ld a, (_RAM_Y_POSITION_MINOR)
	add a, $E8
	cp (iy+object.y_position_minor)
	ret nc
	ld (iy+39), $01
	jp _LABEL_24F3

_LABEL_2A20:
	call ApplyObjectXVelocity
	call ApplyObjectYVelocity
	ld a, (iy+43)
	or a
	ret nz
	ld a, (_RAM_Y_POSITION_MINOR)
	add a, $E8
	cp (iy+object.y_position_minor)
	ret nc
	ld (iy+43), $01
	ld l, (iy+object.x_velocity_sub)
	ld h, (iy+object.x_velocity_minor)
	add hl, hl
	ld (iy+object.x_velocity_sub), l
	ld (iy+object.x_velocity_minor), h
	ld (iy+object.y_velocity_sub), $C0
	ld (iy+object.y_velocity_minor), $FF
	ret

; 20th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2A4E:
	ld a, (iy+3)
	or a
	jr nz, ++
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $F0
	ld (iy+23), $10
	ld hl, _DATA_86D2
	ld de, $FF00
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_86FF
	ld de, $0100
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	ld (iy+14), $02
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FA
	call _LABEL_24AE
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	dec a
	jp z, _LABEL_2AE2
	ld a, (iy+38)
	or a
	jp nz, +
	call _LABEL_24BD
	cp $50
	ret nc
	ld (iy+38), $01
+:
	ld de, $0030
	call _LABEL_869
	call ApplyObjectXVelocity
	bit 7, (iy+object.y_velocity_minor)
	ret nz
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ld (iy+1), $01
	ld (iy+38), $00
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FA
	ld (iy+14), $00
	jp _LABEL_24AE

_LABEL_2AE2:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld de, $F80C
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld de, $F8F4
+:
	call _LABEL_15E5
	jp nz, ++
	ld de, $0000
	call _LABEL_15E5
	ret nz
	ld (iy+14), $02
	ld (iy+1), $00
	ld hl, $86D2
	ld de, $FF00
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld hl, $86FF
	ld de, $0100
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jr +++

++:
	call _LABEL_24E0
+++:
	ld de, _DATA_86FF
	ld hl, $86D2
	jp _LABEL_252E

; 22nd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2B31:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld hl, _DATA_87A8
	ld de, $FE80
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_881D
	ld de, $0180
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	call _LABEL_24AE
	ld (iy+22), $D0
	ld (iy+23), $30
	ld (iy+24), $F4
	ld (iy+25), $18
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	or a
	jp z, +
	jp _LABEL_2BF0

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld a, (iy+38)
	or a
	jp z, +
	ld de, $0040
	call _LABEL_3084
	call ApplyObjectYVelocity
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld (iy+object.y_velocity_minor), $00
	ld (iy+38), $00
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ret

+:
	ld de, $F8F4
	bit 7, (iy+object.x_velocity_minor)
	jr nz, +
	ld de, $F80C
+:
	call _LABEL_15E5
	jp nz, +++
	ld de, $0000
	call _LABEL_15E5
	jr z, +
	ld (iy+object.y_velocity_minor), $00
	ld (iy+object.y_velocity_sub), $00
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	jr ++

+:
	ld de, $0040
	call _LABEL_869
++:
	call _LABEL_24BD
	cp $20
	ret nc
	ld (iy+1), $01
	ret

+++:
	ld (iy+38), $01
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FB
	ret

_LABEL_2BF0:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+14), $02
	ld (iy+39), $10
	ld (iy+2), $01
	ld (iy+22), $D0
	ld (iy+23), $30
	ld (iy+24), $EC
	ld (iy+25), $20
	ret

+:
	ld a, (iy+38)
	or a
	jp nz, +
	call _LABEL_2C82
	dec (iy+39)
	ret nz
	ld (iy+38), $01
	ld (iy+14), $00
	ld (iy+object.y_velocity_minor), $FA
	ret

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld de, $0040
	call _LABEL_3084
	call ApplyObjectYVelocity
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld (iy+22), $D0
	ld (iy+23), $30
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+1), $00
	ld (iy+2), $00
	ld (iy+38), $00
	ld (iy+object.y_velocity_minor), $00
	ld hl, _DATA_87A8
	ld de, $FE80
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld hl, _DATA_881D
	ld de, $0180
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_24A3

_LABEL_2C82:
	ld de, $0000
	call _LABEL_15E5
	ret nz
	ld de, $0040
	jp _LABEL_869

-:
	ld h, d
	ld l, e
	add hl, de
	ld d, h
	ld e, l
	ld h, b
	ld l, c
	add hl, bc
	ld b, h
	ld c, l
	ret

_LABEL_2C9A:
	ld ix, _RAM_C400
	call _LABEL_8C8
	call -
	ld (iy+object.x_velocity_sub), c
	ld (iy+object.x_velocity_minor), b
	ld (iy+object.y_velocity_sub), e
	ld (iy+object.y_velocity_minor), d
	ret

; 23rd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2CB1:
	ld a, (iy+3)
	or a
	jp nz, ++
	call _LABEL_24B4
	ld (iy+object.x_velocity_sub), $80
	ld (iy+object.x_velocity_minor), $FF
	ld (iy+24), $F0
	ld (iy+25), $20
	ld (iy+22), $F0
	ld (iy+23), $10
	ld de, $0100
	ld hl, _DATA_88EF
	ld a, (iy+55)
	or a
	jr nz, +
	ld de, $FF00
	ld hl, _DATA_8892
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	call ApplyObjectXVelocity
	call _LABEL_84C
	ld a, (iy+object.x_position_minor)
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld hl, $0100
	cp $20
	jr nc, +++
	jp ++

+:
	ld hl, $FF00
	cp $E0
	jr c, +++
++:
	ld (iy+object.x_velocity_sub), l
	ld (iy+object.x_velocity_minor), h
	ld de, _DATA_88EF
	ld hl, $8892
	call _LABEL_252E
	ld (iy+39), $00
+++:
	ld a, (iy+39)
	or a
	jp nz, +
	call _LABEL_24BD
	cp $30
	jp nc, +
	ld hl, _DATA_2D84
	ld a, r
	and $03
	add a, a
	ld e, a
	ld d, $00
	add hl, de
	ld a, (hl)
	ld (iy+object.x_velocity_minor), a
	ld (iy+39), $01
+:
	call _LABEL_2C82
	call _LABEL_2542
	jr c, ++
	ld a, (iy+object.x_position_minor)
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	sub $20
	ret nc
	jr ++

+:
	sub $E0
	ret c
++:
	ld de, $0100
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld de, $FF00
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	ld (iy+39), $00
	ld hl, $8892
	ld de, _DATA_88EF
	jp _LABEL_252E

; Data from 2D84 to 2D87 (4 bytes)
_DATA_2D84:
.db $01 $01 $02 $02

; 30th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2D88:
	ld a, (iy+3)
	or a
	jr nz, ++
	call _LABEL_24AE
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $FA
	ld (iy+23), $06
	ld hl, _DATA_8D5A
	ld a, (iy+55)
	or a
	jr nz, +
	ld hl, _DATA_8D2D
+:
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld b, a
	ld a, (iy+2)
	or a
	jr nz, ++
	call _LABEL_84C
	ld de, $0200
	ld hl, _DATA_8D5A
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld de, $FE00
	ld hl, _DATA_8D2D
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	ld (iy+4), l
	ld (iy+5), h
	call _LABEL_24BD
	cp $30
	ret nc
	ld (iy+2), $01
	ld (iy+14), $02
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FC
	ret

++:
	ld a, (iy+1)
	or a
	jr nz, ++
	rrc b
	jr nc, +
	ld (iy+1), $01
	ld (iy+14), $00
	ret

+:
	ld de, $0040
	call _LABEL_869
	call ApplyObjectXVelocity
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld (iy+2), $00
	ld (iy+14), $00
	ret

++:
	call _LABEL_84C
	ld a, (_RAM_X_POSITION_MINOR)
	ld b, a
	ld c, $0C
	ld hl, _DATA_8D2D
	ld a, (_RAM_MOVEMENT_STATE)
	ld d, a
	bit 0, a
	jr nz, +
	ld c, $F4
	ld hl, _DATA_8D5A
+:
	ld (iy+4), l
	ld (iy+5), h
	ld a, c
	add a, b
	ld (iy+object.x_position_minor), a
	ld a, (_RAM_LANDAU_IN_AIR)
	or a
	jr nz, +
	ld a, (_RAM_CONTROLLER_INPUT)
	ld b, $F4
	bit ButtonDown, a
	jr nz, ++
+:
	ld b, $F8
	ld a, d
	cp $12
	jr z, ++
	cp $13
	jr z, ++
	ld b, $E8
++:
	ld a, (_RAM_Y_POSITION_MINOR)
	add a, b
	ld (iy+object.y_position_minor), a
	ret

; 29th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2E6D:
	ld a, (iy+3)
	or a
	jp nz, ++
	call _LABEL_24AE
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $D8
	ld (iy+23), $28
	ld hl, _DATA_8C05
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_8C4F
+:
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	call _LABEL_84C
	ld a, (iy+1)
	dec a
	jp z, _LABEL_2EE9
	ld hl, _DATA_8C4F
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld hl, _DATA_8C05
+:
	ld (iy+4), l
	ld (iy+5), h
	ld a, (iy+1)
	cp $02
	jr nz, +
	dec (iy+40)
	ret nz
	ld (iy+1), $00
	ret

+:
	call _LABEL_24BD
	sub $40
	ret nc
	ld a, (iy+56)
	or a
	jr nz, +
	bit 0, (iy+41)
	ret nz
	jr ++

+:
	bit 0, (iy+41)
	ret z
++:
	ld (iy+1), $01
	ret

_LABEL_2EE9:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+2), $01
	ld (iy+38), $38
	ld (iy+39), $02
	ld (iy+43), $00
	call _LABEL_2C9A
	ld de, _DATA_8CE3
	ld hl, $8C99
	jp _LABEL_252E

+:
	call ApplyObjectXVelocity
	call ApplyObjectYVelocity
	ld a, (iy+42)
	or a
	jr nz, ++
	inc (iy+43)
	ld de, $0000
	call _LABEL_15E5
	jr nz, +
	dec (iy+38)
	ret nz
+:
	ld (iy+42), $01
-:
	call _LABEL_24E0
	call _LABEL_24F3
	ld (iy+38), $38
	dec (iy+39)
	ret nz
	ld (iy+42), $00
	ld (iy+43), $00
	ld (iy+1), $02
	ld (iy+2), $00
	ld (iy+40), $20
	ret

++:
	dec (iy+43)
	ret nz
	jp -

; 31st entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2F55:
	ld a, (iy+3)
	or a
	jp nz, _LABEL_2F9F
	ld (iy+24), $F8
	ld (iy+25), $10
	ld (iy+22), $F0
	ld (iy+23), $10
	ld de, $0120
	ld a, (iy+55)
	or a
	jr nz, +
	ld de, $FEE0
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	call _LABEL_24AE
	ld (iy+object.respawn_timer_minor), $08
	ld (iy+object.respawn_timer_major), $00
	ld (iy+50), $20
	ld (iy+51), $20
	ld (iy+object.y_velocity_sub), $80
	ld (iy+object.y_velocity_minor), $FF
	ld hl, _DATA_8D87
	jp _LABEL_249F

_LABEL_2F9F:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	call _LABEL_84C
	call _LABEL_880
	jp ApplyObjectXVelocity

; 24th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_2FB0:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F8
	ld (iy+25), $10
	ld (iy+22), $E8
	ld (iy+23), $10
	ld hl, _DATA_894C
	ld de, $FEC0
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_89B5
	ld de, $0140
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	call _LABEL_24B4
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	or a
	jp nz, _LABEL_3051
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+2), $01
	jp _LABEL_3072

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld de, $0020
	call _LABEL_869
	ld de, $0000
	call _LABEL_15E5
	ret z
	dec (iy+39)
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FD
	ret nz
	ld a, (iy+object.x_position_minor)
	and $F8
	ld (iy+object.x_position_minor), a
	ld (iy+1), $01
	ld (iy+2), $00
	ld a, (_RAM_X_POSITION_MINOR)
	ld hl, _DATA_894C
	ld de, $FEC0
	sub (iy+object.x_position_minor)
	jr c, +
	ld hl, _DATA_89B5
	ld de, $0140
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	call _LABEL_3072
	jp _LABEL_24A3

_LABEL_3051:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+2), $01
	ld (iy+40), $C0
	ld c, $04
	jp _LABEL_2505

+:
	dec (iy+40)
	ret nz
	ld (iy+2), $00
	ld (iy+1), $00
	ret

_LABEL_3072:
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FD
	ld a, r
	and $03
	or $01
	ld (iy+39), a
	ret

_LABEL_3084:
	ld h, (iy+object.y_velocity_minor)
	ld l, (iy+object.y_velocity_sub)
	add hl, de
	ld (iy+object.y_velocity_sub), l
	ld (iy+object.y_velocity_minor), h
	ret

; 28th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3092:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F8
	ld (iy+25), $10
	ld (iy+22), $D4
	ld (iy+23), $2C
	call _LABEL_24AE
	ld hl, _DATA_8B33
	ld de, $FED0
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_8B9C
	ld de, $0120
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	or a
	jp nz, _LABEL_31AE
	ld a, (iy+38)
	dec a
	jp z, _LABEL_3152
	dec a
	jp z, _LABEL_313E
	call _LABEL_24BD
	cp $20
	jr nc, +
	ld (iy+38), $01
	ret

+:
	ld a, (_RAM_C440)
	or a
	jp z, ++
	ld a, (_RAM_C44A)
	sub (iy+object.x_position_minor)
	bit 7, a
	jp z, +
	neg
+:
	cp $08
	jp nc, ++
	ld (iy+14), $00
	ret

++:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld de, $F80C
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld de, $F8F4
+:
	call _LABEL_15E5
	jr z, +
	ld (iy+38), $02
	ret

+:
	ld de, $0000
	call _LABEL_15E5
	jr z, +
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $00
	ret

+:
	ld de, $0060
	jp _LABEL_869

_LABEL_313E:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+2), $01
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FB
	ret

_LABEL_3152:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+2), $01
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FA
	call _LABEL_24B4
	ld (iy+24), $E8
	ld (iy+25), $1C
	ret

+:
	call ApplyObjectXVelocity
	call _LABEL_84C
	ld de, $0040
	call _LABEL_3084
	call ApplyObjectYVelocity
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ld (iy+2), $00
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $00
	ld a, (iy+38)
	ld (iy+38), $00
	cp $01
	ret nz
	ld (iy+1), $01
	ld (iy+2), $00
	ret

_LABEL_31AE:
	ld a, (iy+2)
	or a
	jp nz, ++
	ld (iy+24), $F4
	ld (iy+25), $14
	ld (iy+42), $20
	ld (iy+2), $01
	ld (iy+14), $00
	ld (iy+12), $02
	ld de, $0120
	ld hl, _DATA_8B33
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld de, $FED0
	ld hl, _DATA_8B9C
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_24A3

++:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld a, (_RAM_X_POSITION_MINOR)
	cp $30
	jp nc, +
	ld (iy+38), $01
	call _LABEL_24E0
	jp ++

+:
	dec (iy+42)
	jp nz, +
	call _LABEL_24E0
	jr ++

+:
	call _LABEL_2542
	jp nc, _LABEL_2C82
++:
	ld (iy+1), $00
	ld (iy+2), $00
	ret

; 25th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_321C:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F4
	ld (iy+25), $0C
	ld (iy+22), $F0
	ld (iy+23), $08
	ld (iy+12), $04
	ld (iy+13), $08
	ld hl, _DATA_8A1E
	ld de, $FE80
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_8A6C
	ld de, $0180
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	dec a
	jp z, _LABEL_3303
	dec a
	jp z, _LABEL_3349
	ld a, (iy+38)
	or a
	jp nz, ++
	ld a, (iy+40)
	cp $03
	jp z, +
	call _LABEL_24BD
	cp $40
	jr nc, +
	ld (iy+1), $01
	ret

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld de, $F820
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld de, $F8E0
+:
	call _LABEL_15E5
	jr z, +
	ld (iy+38), $01
	ret

+:
	ld de, $0000
	call _LABEL_15E5
	ret nz
	ld (iy+38), $02
	ret

++:
	ld a, (iy+2)
	or a
	jp nz, ++
	ld (iy+2), $01
	ld (iy+14), $04
	ld a, (iy+38)
	dec a
	jr z, +
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $00
	ret

+:
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FB
	ret

++:
	call ApplyObjectXVelocity
	ld de, $0040
	call _LABEL_3084
	call ApplyObjectYVelocity
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld (iy+2), $00
	ld (iy+14), $00
	ld (iy+38), $00
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $00
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ret

_LABEL_3303:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+2), $01
	ld (iy+14), $04
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FE
	ld h, (iy+object.x_velocity_minor)
	ld l, (iy+object.x_velocity_sub)
	add hl, hl
	ld (iy+object.x_velocity_sub), l
	ld (iy+object.x_velocity_minor), h
	ret

+:
	call ApplyObjectXVelocity
	ld de, $0020
	call _LABEL_869
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld (iy+2), $00
	ld (iy+1), $02
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $00
	ret

_LABEL_3349:
	ld a, (iy+2)
	or a
	jp nz, ++
	inc (iy+40)
	ld (iy+14), $00
	ld (iy+2), $01
	ld (iy+39), $10
	ld de, $FE80
	ld hl, _DATA_8A1E
	ld a, (_RAM_X_POSITION_MINOR)
	sub (iy+object.x_position_minor)
	jr c, +
	ld de, $0180
	ld hl, _DATA_8A6C
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_24A3

++:
	dec (iy+39)
	ret nz
	ld (iy+1), $00
	ld (iy+2), $00
	ret

; 33rd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3389:
	ld a, (iy+3)
	or a
	jp nz, ++
	call _LABEL_24AE
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $D0
	ld (iy+23), $30
	ld de, $0120
	ld hl, _DATA_8DFC
	ld a, (iy+55)
	or a
	jr nz, +
	ld de, $FEE0
	ld hl, _DATA_8DB3
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	or a
	jp nz, _LABEL_344D
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld de, $F80C
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld de, $F8F4
+:
	call _LABEL_15E5
	jr z, +
	ld a, r
	and $01
	jp nz, +++
	ld (iy+39), $00
	call _LABEL_24E0
	ld de, _DATA_8DFC
	ld hl, $8DB3
	jp _LABEL_252E

+:
	ld a, (iy+39)
	or a
	jr z, +
	dec (iy+40)
	jr nz, ++
	ld (iy+39), $00
+:
	call _LABEL_24BD
	cp $28
	jr c, +++
++:
	ld de, $0000
	call _LABEL_15E5
	jr z, +
	ld (iy+object.y_velocity_minor), $00
	ret

+:
	ld de, $0040
	jp _LABEL_869

+++:
	ld (iy+38), $28
	ld (iy+1), $01
	ld (iy+14), $02
	ld (iy+3), $02
	ld (iy+24), $FC
	ld (iy+25), $08
	ld (iy+22), $F0
	ld (iy+23), $10
	ld (iy+object.x_position_minor), $00
	ld (iy+object.y_position_minor), $00
	ret

_LABEL_344D:
	ld a, (iy+2)
	or a
	jp nz, _LABEL_3493
	dec (iy+38)
	ret nz
	ld (iy+3), $01
	ld (iy+2), $01
	ld (iy+14), $00
	ld (iy+24), $F0
	ld (iy+25), $20
	ld (iy+22), $D0
	ld (iy+23), $30
	ld hl, _DATA_8E40
	ld b, $0C
	ld a, (_RAM_MOVEMENT_STATE)
	bit 0, a
	jr z, +
	ld hl, _DATA_8E8E
	ld b, $F4
+:
	ld a, (_RAM_X_POSITION_MINOR)
	add a, b
	ld (iy+object.x_position_minor), a
	ld (iy+object.y_position_minor), $30
	jp _LABEL_24A3

_LABEL_3493:
	call _LABEL_84C
	ld de, $0030
	call _LABEL_869
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ld (iy+2), $00
	ld (iy+1), $00
	ld (iy+39), $01
	ld (iy+40), $40
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $00
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $D0
	ld (iy+23), $30
	ld hl, _DATA_8DB3
	ld de, $FEE0
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld hl, _DATA_8DFC
	ld de, $0120
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_24A3

; 35th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_34F0:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F0
	ld (iy+25), $20
	ld (iy+22), $E0
	ld (iy+23), $20
	ld (iy+12), $02
	ld (iy+13), $08
	ld (iy+1), $01
	ld hl, _DATA_8FC2
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_904A
+:
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	call ApplyObjectXVelocity
	ld a, (iy+1)
	dec a
	jp z, +
	jp _LABEL_3593

+:
	ld a, (iy+2)
	or a
	jp nz, ++
	ld (iy+2), $01
	ld (iy+22), $D0
	ld (iy+23), $30
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+14), $00
	ld (iy+12), $02
	ld de, $FE80
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld de, $0180
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
-:
	ld de, _DATA_904A
	ld hl, $8FC2
	jp _LABEL_252E

++:
	call _LABEL_84C
	call _LABEL_24BD
	cp $14
	jr nc, +
	ld (iy+1), $02
	ld (iy+2), $00
	ret

+:
	call _LABEL_2542
	call c, -
	jp _LABEL_2C82

_LABEL_3593:
	ld a, (iy+2)
	or a
	jp nz, _LABEL_35F9
	ld (iy+2), $01
	ld a, r
	and $03
	ld (iy+39), a
	ld (iy+object.y_velocity_sub), $00
	ld c, $00
	ld b, $FB
	ld d, $40
	or a
	jr z, +
	ld c, $02
	ld b, $00
	ld d, $00
	dec a
	jr z, +
	ld c, $03
	dec a
	jr z, +
	ld b, $FC
	ld d, $40
+:
	ld (iy+42), d
	ld (iy+14), c
	ld (iy+object.y_velocity_minor), b
	ld a, (iy+39)
	ld b, a
	or a
	jr z, +
	cp $03
	jr z, +
	ld (iy+40), $10
	ld (iy+object.x_velocity_sub), $00
	ld (iy+object.x_velocity_minor), $00
+:
	or a
	ret z
	dec a
	ret z
	ld (iy+24), $F0
	ld (iy+25), $20
	ld (iy+22), $F0
	ld (iy+23), $10
	ret

_LABEL_35F9:
	ld a, (iy+39)
	dec a
	jp z, ++
	dec a
	jp z, ++
	dec a
	jp z, +
	call _LABEL_84C
+:
	ld e, (iy+42)
	ld d, $00
	call _LABEL_3084
	call ApplyObjectYVelocity
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	jp +++

++:
	dec (iy+40)
	ret nz
+++:
	ld (iy+1), $01
	ld (iy+2), $00
	ret

; 37th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3635:
	ld a, (iy+3)
	or a
	jp nz, ++
	call _LABEL_24AE
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $F8
	ld (iy+23), $08
	ld hl, _DATA_91CC
	ld de, $FEE0
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_925B
	ld de, $0120
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	ld (iy+39), $40
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	dec a
	jp z, _LABEL_36BB
	dec a
	jp z, _LABEL_3732
	dec a
	jp z, _LABEL_3778
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld a, (_RAM_X_POSITION_MINOR)
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	sub (iy+object.x_position_minor)
	jr nc, +++
	neg
	jr ++

+:
	sub (iy+object.x_position_minor)
	jr c, +++
++:
	cp $40
	jr nc, +++
	ld (iy+1), $01
	ret

+++:
	call _LABEL_24D1
	ret nz
	call _LABEL_24E0
	ld de, _DATA_925B
	ld hl, $91CC
	jp _LABEL_252E

_LABEL_36BB:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+2), $01
	ld (iy+14), $00
	ld (iy+22), $D0
	ld (iy+23), $28
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $F9
_LABEL_36DA:
	ld de, _DATA_9279
	ld hl, $91EA
	jp _LABEL_252E

+:
	call ApplyObjectXVelocity
	ld de, $0040
	call _LABEL_869
	bit 7, (iy+object.y_velocity_minor)
	ret nz
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld a, (iy+object.y_position_minor)
	cp $B0
	jp c, +
	ld (iy+22), $F8
	ld (iy+23), $08
	ld (iy+1), $00
	ld (iy+2), $00
	ld (iy+14), $00
	ld (iy+object.y_position_minor), $B0
	ld (iy+39), $40
	ld de, _DATA_925B
	ld hl, $91CC
	jp _LABEL_252E

+:
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ld (iy+1), $02
	ret

_LABEL_3732:
	call _LABEL_24BD
	cp $18
	jr nc, +
	ld (iy+1), $03
	ld (iy+14), $02
	ld (iy+42), $10
	ret

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld de, $0000
	call _LABEL_15E5
	ret nz
	ld a, (_RAM_X_POSITION_MINOR)
	bit 7, (iy+object.x_velocity_minor)
	jp z, +
	sub (iy+object.x_position_minor)
	jr nc, +++
	jr ++

+:
	sub (iy+object.x_position_minor)
	jr c, +++
++:
	ld (iy+1), $01
	ld (iy+2), $00
	ret

+++:
	call _LABEL_24E0
	jp _LABEL_36DA

_LABEL_3778:
	dec (iy+42)
	ret nz
	ld (iy+14), $00
	ld (iy+1), $02
	ret

; 38th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3785:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $D0
	ld (iy+23), $30
	ld (iy+42), $40
	ld (iy+12), $02
	ld (iy+13), $10
	ld hl, _DATA_92EA
	ld de, $FF40
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_935B
	ld de, $00C0
+:
	ld (iy+object.x_velocity_minor), e ; BUG?
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	dec a
	jp z, ++
	dec (iy+42)
	jr nz, +
	ld a, r
	and $3F
	or $0F
	ld (iy+42), a
	ld (iy+1), $01
	ret

+:
	call ApplyObjectXVelocity
	call _LABEL_84C
	call _LABEL_2C82
	ld de, $F8F8
	bit 7, (iy+object.x_velocity_minor)
	jr nz, +
	ld de, $F808
+:
	call _LABEL_15E5
	ret z
	call _LABEL_24E0
	ld de, _DATA_935B
	ld hl, $92EA
	jp _LABEL_252E

++:
	ld a, (iy+2)
	or a
	jp nz, ++
	ld (iy+2), $01
	ld (iy+14), $02
	ld (iy+43), $10
	ld de, $00C0
	ld hl, _DATA_935B
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld de, $FF40
	ld hl, _DATA_92EA
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	ld (iy+4), l
	ld (iy+5), h
	ld c, $05
	jp _LABEL_2505

++:
	dec (iy+43)
	ret nz
	ld (iy+2), $00
	ld (iy+1), $00
	ld (iy+14), $00
	ret

; 17th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3853:
	ld a, (iy+3)
	or a
	jp nz, _LABEL_38A5
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $E0
	ld (iy+23), $20
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FF
	ld (iy+39), $02
	ld (iy+40), $10
	ld (iy+object.respawn_timer_minor), $04
	ld (iy+object.respawn_timer_major), $00
	ld (iy+50), $80
	ld (iy+51), $80
	call _LABEL_24B4
	ld hl, _DATA_863F
	ld de, $FFD0
	ld a, (iy+55)
	or a
	jr z, +
	ld de, $0030
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

_LABEL_38A5:
	call _LABEL_173E
	jr c, +
	call _LABEL_1C8C
	jp nc, ++
+:
	push iy
	ld de, $FFC0
	add iy, de
	ld (iy+object.type), $27 ; Damaged (Knight)
	pop iy
	ret

++:
	call ++
	call ApplyObjectXVelocity
	call +
	call _LABEL_84C
	jp _LABEL_880

+:
	dec (iy+39)
	ret nz
	ld (iy+39), $02
	push iy
	pop hl
	ld de, $FFC7
	add hl, de
	ld a, (iy+object.y_position_minor)
	add a, $F3
	ld (hl), a
	ld de, $0003
	add hl, de
	ld a, (iy+object.x_position_minor)
	ld (hl), a
	inc hl
	ld a, (iy+object.x_position_major)
	ld (hl), a
	ret

++:
	dec (iy+40)
	ret nz
	ld a, r
	and $3F
	or $07
	ld (iy+40), a
	ld de, $0030
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld de, $FFD0
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	ret

; 27th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3912:
	ld a, (iy+3)
	or a
	jp nz, +
	ld hl, _DATA_8B2C
	jp _LABEL_249F

+:
	push iy
	pop hl
	ld de, $0043
	add hl, de
	ld a, (hl)
	or a
	ret nz
	ld (iy+object.type), $27 ; Damaged (Knight)
	jp _LABEL_3EA3

; 36th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3930:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F0
	ld (iy+25), $20
	ld (iy+22), $D0
	ld (iy+23), $30
	call _LABEL_24AE
	ld hl, _DATA_90D2
	ld de, $FF00
	ld a, (iy+55)
	or a
	jr z, +
	ld de, $0100
	ld hl, _DATA_914F
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	call ApplyObjectXVelocity
	ld a, (iy+1)
	dec a
	jp z, _LABEL_3A0E
	ld a, (iy+38)
	or a
	jp nz, _LABEL_39E5
	ld a, (iy+39)
	or a
	jp nz, +
	call _LABEL_24BD
	cp $40
	jr nc, ++
	ld (iy+1), $01
	ret

+:
	dec (iy+40)
	jr nz, ++
	ld (iy+39), $00
++:
	call _LABEL_84C
	ld de, $F808
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld de, $F8F8
+:
	call _LABEL_15E5
	jr z, ++
	ld (iy+38), $01
	ld a, r
	and $01
	ld de, $0100
	ld hl, _DATA_914F
	or a
	jr z, +
	ld de, $FF00
	ld hl, _DATA_90D2
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_24A3

++:
	ld de, $0000
	call _LABEL_15E5
	jr z, +
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ret

+:
	ld de, $0040
	jp _LABEL_869

_LABEL_39E5:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+2), $01
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FC
+:
	ld de, $0040
	call _LABEL_869
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld (iy+38), $00
	ld (iy+2), $00
	ret

_LABEL_3A0E:
	ld a, (iy+2)
	or a
	jp nz, ++
	ld (iy+2), $01
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FB
	ld (iy+14), $02
	ld de, $0200
	ld hl, _DATA_914F
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld de, $FE00
	ld hl, _DATA_90D2
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	ld (iy+4), l
	ld (iy+5), h
++:
	ld de, $0040
	call _LABEL_869
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ld (iy+1), $00
	ld (iy+2), $00
	ld (iy+39), $01
	ld (iy+40), $30
	ld de, $0100
	ld hl, _DATA_914F
	bit 7, (iy+object.x_velocity_minor)
	jr nz, +
	ld de, $FF00
	ld hl, _DATA_90D2
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_24A3

; 34th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3A85:
	ld a, (iy+3)
	or a
	jp nz, _LABEL_3ADD
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $C0
	ld (iy+23), $30
	call _LABEL_24AE
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FF
	ld (iy+object.respawn_timer_minor), $10
	ld (iy+object.respawn_timer_major), $00
	ld (iy+50), $20
	ld (iy+51), $20
	ld a, r
	or $1F
	ld (iy+38), a
	ld (iy+40), $C0
	ld hl, _DATA_8EDC
	ld de, $FE00
	ld a, (iy+55)
	or a
	jr z, +
	ld de, $0200
	ld hl, _DATA_8F4A
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

_LABEL_3ADD:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	call _LABEL_84C
	ld a, (iy+1)
	dec a
	jp z, _LABEL_3B39
	dec (iy+40)
	jr nz, +
	ld (iy+1), $01
	ret

+:
	call _LABEL_880
	call ++
	dec (iy+38)
	ret nz
	ld a, r
	or $1F
	ld (iy+38), a
	ld c, $06
	bit 7, (iy+object.x_velocity_minor)
	jr nz, +
	ld c, $07
+:
	jp _LABEL_2505

++:
	ld a, (iy+39)
	or a
	ret nz
	call ApplyObjectXVelocity
	ld a, (iy+object.x_position_minor)
	bit 7, (iy+object.x_velocity_minor)
	jr nz, +
	cp $20
	ret c
	jr ++

+:
	cp $E0
	ret nc
++:
	ld (iy+39), $01
	ld (iy+3), $02
	ret

_LABEL_3B39:
	ld a, (iy+2)
	or a
	jp nz, +
	ld (iy+object.respawn_timer_minor), $60
	ld (iy+2), $01
+:
	call ApplyObjectXVelocity
	dec (iy+object.respawn_timer_minor)
	ret nz
	call _LABEL_24E0
	ld (iy+2), $00
	ld (iy+1), $00
	ld a, r
	or $1F
	ld (iy+38), a
	ld (iy+40), $C0
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FF
	ld (iy+object.respawn_timer_minor), $10
	ld (iy+object.respawn_timer_major), $00
	ld (iy+50), $20
	ld (iy+51), $20
	ld de, _DATA_8F4A
	ld hl, $8EDC
	jp _LABEL_252E

; 32nd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3B86:
	ld a, (iy+3)
	or a
	jp nz, +
	ld (iy+24), $F8
	ld (iy+25), $10
	ld (iy+22), $F0
	ld (iy+23), $10
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $01
	ld (iy+object.respawn_timer_minor), $F8
	ld (iy+object.respawn_timer_major), $FF
	ld (iy+50), $40
	ld (iy+51), $40
	ld a, r
	ld (iy+38), a
	ld (iy+39), $00
	ld hl, _DATA_8D9D
	jp _LABEL_249F

+:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	dec a
	jp z, ++
	call _LABEL_880
	ld l, (iy+38)
	ld h, (iy+39)
	dec hl
	ld a, l
	or a
	jr z, +
	ld (iy+38), l
	ld (iy+39), h
	ret

+:
	ld (iy+1), $01
	ld (iy+14), $01
	ld (iy+40), $40
	ld b, $04
	ld c, $08
-:
	push bc
	call _LABEL_2505
	pop bc
	inc c
	djnz -
	ret

++:
	dec (iy+40)
	ret nz
	ld (iy+1), $00
	ld (iy+14), $00
	ld a, r
	ld (iy+38), a
	ld (iy+39), $01
	ret

; 21st entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3C17:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F4
	ld (iy+25), $10
	ld (iy+22), $E0
	ld (iy+23), $20
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FB
	ld (iy+14), $01
	ld hl, _DATA_872C
	ld de, $FE80
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_876A
	ld de, $0180
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+1)
	or a
	jp z, +
	dec (iy+39)
	ret nz
	ld (iy+1), $00
	ld (iy+14), $01
	ret

+:
	call ApplyObjectXVelocity
	ld de, $0040
	call _LABEL_869
	ld de, $F810
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	ld de, $F8F0
+:
	call _LABEL_15E5
	jp z, +
	call _LABEL_24E0
	ld de, _DATA_876A
	ld hl, $872C
	jp _LABEL_252E

+:
	ld de, $0000
	call _LABEL_15E5
	ret z
	ld a, (iy+object.y_position_minor)
	and $F8
	ld (iy+object.y_position_minor), a
	ld (iy+14), $00
	ld (iy+39), $20
	ld (iy+1), $01
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FB
	ld hl, _DATA_872C
	ld de, $FE80
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld hl, _DATA_876A
	ld de, $0180
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_24A3

; 40th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3CD8:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F0
	ld (iy+25), $20
	ld (iy+22), $F8
	ld (iy+23), $08
	call _LABEL_24AE
	ld hl, _DATA_9466
	ld de, $FE00
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_9493
	ld de, $0200
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+38)
	or a
	jr z, +
	dec (iy+39)
	ret nz
	ld (iy+38), $00
	ret

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld a, (iy+object.x_position_minor)
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	cp $30
	ret nc
	jr ++

+:
	cp $D0
	ret c
++:
	ld c, $00
	call _LABEL_2505
	ld (iy+38), $01
	ld (iy+39), $40
	call _LABEL_24E0
	ld de, _DATA_9493
	ld hl, $9466
	jp _LABEL_252E

; 26th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3D54:
	ld a, (iy+3)
	or a
	jp nz, ++
	ld (iy+24), $F0
	ld (iy+25), $20
	ld (iy+22), $F8
	ld (iy+23), $08
	ld (iy+12), $03
	ld (iy+13), $04
	ld hl, _DATA_8ABA
	ld de, $FE80
	ld a, (iy+55)
	or a
	jr z, +
	ld hl, _DATA_8AF3
	ld de, $0180
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

++:
	call _LABEL_1C8C
	ret c
	call _LABEL_173E
	ret c
	ld a, (iy+38)
	dec a
	jp z, ++
	dec a
	jr nz, +
	dec (iy+39)
	ret nz
	ld (iy+38), $00
	ret

+:
	call _LABEL_24BD
	cp $40
	ret nc
	ld (iy+38), $01
	ld (iy+40), $38
	ret

++:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld a, (iy+41)
	or a
	jr nz, +
	ld a, (iy+object.y_position_minor)
	cp (iy+60)
	jr c, +
	ld (iy+41), $01
	ld a, (iy+60)
	ld (iy+object.y_position_minor), a
+:
	dec (iy+40)
	ret nz
	ld (iy+41), $00
	ld (iy+39), $20
	call _LABEL_24E0
	ld (iy+38), $02
	ld de, _DATA_8AF3
	ld hl, $8ABA
	jp _LABEL_252E

; 39th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3DF2:
	ld a, (iy+object.boss_hp)
	or a
	jp nz, ++
	ld b, $A6
	ld hl, _RAM_SWORD_DAMAGE
	ld a, (iy+26)
	or a
	jr z, +
	ld hl, _RAM_BOW_DAMAGE
+:
	ld c, (hl)
	ld a, (iy+object.current_hp)
	sub c
	jr c, +
	jr z, +
	ld b, $A3
+:
	ld a, b
	ld (_RAM_SOUND_TO_PLAY), a
	ld (iy+53), $20
	ld a, (iy+4)
	ld (iy+8), a
	ld a, (iy+5)
	ld (iy+18), a
++:
	inc (iy+object.boss_hp)
	bit 0, (iy+object.boss_hp)
	jr z, +
	ld (iy+4), <_DATA_8FB8
	ld (iy+5), >_DATA_8FB8
	jp ++

+:
	call _LABEL_3EBE
++:
	dec (iy+53)
	ret nz
	ld (iy+53), $40
	ld a, (iy+59)
	ld (iy+object.type), a
	ld (iy+object.boss_hp), $00
	call _LABEL_3EBE
	call _LABEL_5268
	jr z, +
	ret nc
+:
	ld a, (iy+object.type)
	cp $21 ; Book Thief
	jr nz, +
	ld a, (iy+29)
	or a
	jr z, +
	ld a, $01
	ld (_RAM_INVENTORY_BOOK), a
	ld (_RAM_CCAD), a
	ld (_RAM_C16D), a
	ld a, $93
	ld (_RAM_SOUND_TO_PLAY), a
+:
	ld a, (iy+27)
	and $F0
	rrca
	rrca
	rrca
	rrca
	ld c, a
	call _LABEL_175F
	dec (iy+63)
	jp nz, _LABEL_3EA3
	ld a, (iy+object.type)
	cp $11 ; Eye Part
	jp z, +
	jp _LABEL_8AC

+:
	push iy
	pop hl
	ld de, $FFC0
	add hl, de
	ld b, $40
-:
	ld (hl), $00
	djnz -
	jp _LABEL_8AC

_LABEL_3EA3:
	call _LABEL_524C
	call _LABEL_5241
	ld (iy+object.type), $2A ; Damaged
	ld (iy+object.respawn_timer_minor), $00
	ld (iy+object.respawn_timer_major), $01
	ld (iy+4), <_DATA_8FB8
	ld (iy+5), >_DATA_8FB8
	ret

_LABEL_3EBE:
	ld a, (iy+8)
	ld (iy+4), a
	ld a, (iy+18)
	ld (iy+5), a
	ret

; 42nd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3ECB:
	ld l, (iy+object.respawn_timer_minor)
	ld h, (iy+object.respawn_timer_major)
	dec hl
	ld (iy+object.respawn_timer_minor), l
	ld (iy+object.respawn_timer_major), h
	ld a, l
	or h
	ret nz
	call _LABEL_51FB
	ld a, (iy+object.x_position_major)
	or a
	jr z, +
	jp _LABEL_524C

+:
	ld (iy+object.respawn_timer_minor), $01
	ld (iy+object.respawn_timer_major), $00
	ld (iy+4), <_DATA_8FB8
	ld (iy+5), >_DATA_8FB8
	ld (iy+object.type), $2A ; Damaged
	ret

; 43rd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_3EFC:
	ld a, (iy+3)
	or a
	jp nz, +
	ld a, $A8
	ld (_RAM_C507), a
	ld a, $20
	ld (_RAM_C50A), a
	ld hl, $50B0
	ld (_RAM_C516), hl
	ld hl, $20F0
	ld (_RAM_C518), hl
	ld hl, $FF80
	ld (_RAM_C513), hl
	ld hl, $951F
	ld (_RAM_C504), hl
	ld a, $01
	ld (_RAM_C503), a
	ld a, $06
	ld (_RAM_C538), a
	ld a, $14 ; TREE BOSS NAMO HEALTH
	ld (_RAM_BOSS_HP), a
	ret

+:
	ld a, (_RAM_C501)
	or a
	jp z, _LABEL_40AB
	dec a
	jp z, _LABEL_407B
	call _LABEL_1C8C
	jp nc, _LABEL_3FB9
_LABEL_3F46:
	call _LABEL_5268
	jp c, +
	ld (iy+31), $20
-:
	ld a, (iy+1)
	ld (iy+29), a
	ld a, (iy+14)
	ld (iy+30), a
	ld a, (iy+4)
	ld (iy+8), a
	ld a, (iy+5)
	ld (iy+18), a
	ld (iy+1), $01
	ld (iy+47), $00
	ret

+:
	ld a, (iy+object.type)
	cp $2B ; Tree Spirit
	jr z, +
	cp $34 ; Pirate
	jr z, +
	cp $37 ; Baruga
	jp nz, _LABEL_8AC
+:
	ld (iy+object.boss_defeated), $01
	ld a, $A5
	ld (_RAM_SOUND_TO_PLAY), a
	ld (iy+31), $60
	jp -

_LABEL_3F91:
	ld a, (_RAM_C51B)
	dec a
	ld (_RAM_C51B), a
	cp $01
	jr z, +
	cp $05
	jp c, _LABEL_8AC
	push iy
	pop hl
	inc hl
	ld b, $3A
-:
	ld (hl), $00
	inc hl
	djnz -
	ret

+:
	ld a, $01
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	jp _LABEL_8AC

_LABEL_3FB9:
	ld a, (_RAM_C52F)
	or a
	jp nz, _LABEL_3F46
	ld a, (_RAM_C501)
	cp $02
	jp z, _LABEL_40B7
	ld a, (_RAM_C502)
	or a
	jp nz, _LABEL_400F
	ld b, $03
	ld c, $00
	ld hl, _RAM_C640
-:
	ld (hl), $2C
	ld de, $0007
	add hl, de
	ld a, (_RAM_C507)
	add a, $B8
	ld (hl), a
	ld de, $0003
	add hl, de
	ld a, (_RAM_C50A)
	add a, $F0
	ld (hl), a
	ld de, $0035
	add hl, de
	ld (hl), c
	inc c
	inc hl
	djnz -
	ld a, r
	and $7F
	or $20
	ld (_RAM_C520), a
	ld (_RAM_C521), a
	ld a, $01
	ld (_RAM_C502), a
	ld hl, $960C
	ld (_RAM_C504), hl
	jp _LABEL_24E0

_LABEL_400F:
	ld a, (_RAM_C522)
	or a
	jp z, +
	dec a
	jp z, _LABEL_406B
	call _LABEL_84C
	call ApplyObjectXVelocity
	dec (iy+33)
	ret nz
	xor a
	ld (_RAM_C502), a
	ld (_RAM_C522), a
	ld a, $02
	ld (_RAM_C501), a
	ld hl, $951F
	ld (_RAM_C504), hl
	ret

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld hl, _RAM_C64A
	ld b, $03
	ld a, (_RAM_C50A)
	add a, $F0
-:
	ld (hl), a
	ld de, $0040
	add hl, de
	djnz -
	dec (iy+32)
	ret nz
	ld hl, $2001
	ld (_RAM_C522), hl
	ld a, $02
	ld (_RAM_C50E), a
	ld hl, _RAM_C641
	ld b, $03
-:
	ld (hl), $01
	ld de, $0040
	add hl, de
	djnz -
	ret

_LABEL_406B:
	dec (iy+35)
	ret nz
	ld a, $02
	ld (_RAM_C522), a
	xor a
	ld (_RAM_C50E), a
	jp _LABEL_24E0

_LABEL_407B:
	inc (iy+object.boss_flash_timer)
	bit 0, (iy+object.boss_flash_timer)
	jr z, +
	ld (iy+4), <_DATA_8FB8
	ld (iy+5), >_DATA_8FB8
	jr ++

+:
	call _LABEL_3EBE
++:
	dec (iy+31)
	ret nz
	ld a, (iy+object.boss_defeated)
	or a
	jp nz, _LABEL_6A47
	ld a, (iy+29)
	ld (iy+1), a
	ld a, (iy+30)
	ld (iy+14), a
	jp _LABEL_3EBE

_LABEL_40AB:
	ld a, (_RAM_X_POSITION_MINOR)
	cp $A0
	ret nc
	ld a, $02
	ld (_RAM_C501), a
	ret

_LABEL_40B7:
	ld a, (_RAM_C502)
	or a
	jp nz, +
	ld a, $01
	ld (_RAM_C502), a
	ld a, $02
	ld (_RAM_C50C), a
	ld a, $08
	ld (_RAM_C50D), a
	ld a, r
	and $0F
	or $10
	ld (_RAM_C51A), a
+:
	ld a, (_RAM_C51B)
	or a
	jp z, +
	dec (iy+28)
	ret nz
	ld a, $03
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ld (_RAM_C51B), a
	ld (_RAM_C50E), a
	ret

+:
	call _LABEL_84C
	dec (iy+26)
	ret nz
	ld b, $04
	ld c, $00
	ld hl, _RAM_C540
-:
	ld (hl), $2D
	ld a, (_RAM_C507)
	add a, $E0
	ld de, $0007
	add hl, de
	ld (hl), a
	ld a, (_RAM_C50A)
	add a, $10
	ld de, $0003
	add hl, de
	ld (hl), a
	ld de, $0035
	add hl, de
	ld (hl), c
	ld de, $0001
	add hl, de
	inc c
	djnz -
	ld a, $02
	ld (_RAM_C50E), a
	ld hl, $4001
	ld (_RAM_C51B), hl
	ret

; 44th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_412D:
	ld a, (iy+3)
	or a
	jp nz, _LABEL_4178
	ld (iy+56), $08
	ld l, (iy+63)
	ld h, $00
	add hl, hl
	add hl, hl
	ld de, _DATA_416C
	add hl, de
	ld a, (hl)
	ld (iy+object.x_velocity_minor), a
	inc hl
	ld a, (hl)
	ld (iy+object.x_velocity_sub), a
	inc hl
	ld a, (hl)
	ld (iy+object.y_velocity_minor), a
	inc hl
	ld a, (hl)
	ld (iy+object.y_velocity_sub), a
	ld (iy+24), $FA
	ld (iy+25), $0C
	ld (iy+22), $F2
	ld (iy+23), $0C
	ld hl, _DATA_975E
	jp _LABEL_249F

; Data from 416C to 4177 (12 bytes)
_DATA_416C:
.db $01 $40 $FE $80 $02 $00 $FE $60 $02 $80 $FE $40

_LABEL_4178:
	ld a, (iy+1)
	or a
	ret z
	cp $02
	jr nz, +
	dec (iy+26)
	ret nz
	jp _LABEL_8AC

+:
	call _LABEL_1C8C
	jp c, _LABEL_8AC
	ld a, (iy+object.y_position_minor)
	cp $A8
	jr c, +
	ld (iy+1), $02
	ld (iy+26), $20
	ld (iy+14), $01
	ret

+:
	call ApplyObjectXVelocity
	ld de, $0010
	jp _LABEL_869

; 45th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_41AB:
	ld a, (iy+3)
	or a
	jp nz, _LABEL_41FE
	ld (iy+56), $04
	ld a, (iy+63)
	add a, a
	add a, a
	ld e, a
	ld d, $00
	ld hl, $41EA
	add hl, de
	ld a, (hl)
	ld (iy+object.y_velocity_sub), a
	inc hl
	ld a, (hl)
	ld (iy+object.y_velocity_minor), a
	inc hl
	ld a, (hl)
	ld (iy+object.x_velocity_sub), a
	inc hl
	ld a, (hl)
	ld (iy+object.x_velocity_minor), a
	ld (iy+24), $FC
	ld (iy+25), $08
	ld (iy+22), $F8
	ld (iy+23), $08
	call _LABEL_24AE
	ld hl, _DATA_9774
	jp _LABEL_249F

; Data from 41EE to 41FD (16 bytes)
.db $00 $02 $40 $02 $80 $01 $00 $02 $00 $01 $80 $01 $80 $00 $00 $01

_LABEL_41FE:
	call _LABEL_1C8C
	jp c, _LABEL_8AC
	call _LABEL_84C
	ld a, (iy+1)
	or a
	jp z, +
	ld a, (iy+object.x_position_major)
	or a
	jp nz, _LABEL_8AC
	jp ApplyObjectXVelocity

+:
	call ApplyObjectYVelocity
	ld a, (iy+object.y_position_minor)
	cp $A8
	ret c
	ld (iy+1), $01
	ret

; 46th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_4226:
	ld a, (_RAM_C503)
	or a
	jp nz, _LABEL_4278
	ld a, $30
	ld (_RAM_C50A), a
	ld a, $80
	ld (_RAM_C507), a
	ld hl, $0BF9
	ld (_RAM_C518), hl
	ld hl, $20D8
	ld (_RAM_C516), hl
	ld hl, $FF40
	ld (_RAM_C510), hl
	ld hl, $00C0
	ld (_RAM_C513), hl
	ld hl, $0004
	ld (_RAM_C530), hl
	ld hl, $6060
	ld (_RAM_C532), hl
	ld a, $FF
	ld (_RAM_C51A), a
	ld a, $1D
	ld (_RAM_C51D), a
	ld a, $08
	ld (_RAM_BOSS_HP), a
	ld a, $04
	ld (_RAM_C538), a
	call _LABEL_24AE
	ld hl, _DATA_9850
	jp _LABEL_249F

_LABEL_4278:
	ld a, (_RAM_C51F)
	or a
	jp nz, _LABEL_44E0
	call _LABEL_1C8C
	ld a, (_RAM_C52F)
	or a
	jp z, +
	ld a, (_RAM_C501)
	dec a
	jp nz, +
	ld a, (_RAM_C50E)
	cp $02
	jp z, _LABEL_450F
	cp $03
	jp z, _LABEL_450F
	cp $04
	jp z, _LABEL_450F
	xor a
	ld (_RAM_C52F), a
+:
	call _LABEL_84C
	ld a, (_RAM_C501)
	dec a
	jp z, _LABEL_42FD
	dec a
	jp z, +
	dec (iy+26)
	jr nz, +
	ld a, $01
	ld (_RAM_C501), a
	ret

+:
	call ApplyObjectXVelocity
	call _LABEL_880
	dec (iy+29)
	jr z, +++
	ld a, (_RAM_C50A)
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	cp $08
	ret nc
	jr ++

+:
	cp $E8
	ret c
++:
	call _LABEL_24E0
	jr ++++

+++:
	ld hl, $00C0
	ld a, r
	and $01
	jr z, +
	ld hl, $FF40
+:
	ld (_RAM_C513), hl
	ld a, $40
	ld (_RAM_C51D), a
++++:
	ld de, _DATA_9850
	ld hl, $9782
	jp _LABEL_252E

_LABEL_42FD:
	ld a, (_RAM_C502)
	or a
	jp nz, ++
	ld a, $06
	ld (_RAM_C50C), a
	xor a
	ld (_RAM_C50E), a
	ld a, $0A
	ld (_RAM_C50D), a
	ld hl, $97C0
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld hl, $988E
+:
	ld (_RAM_C504), hl
	ld a, $01
	ld (_RAM_C502), a
	ld hl, $0280
	ld (_RAM_C51B), hl
	ld hl, _RAM_C580
	ld (hl), $31
++:
	ld hl, (_RAM_C51B)
	dec hl
	ld a, h
	or l
	jr z, +
	ld (_RAM_C51B), hl
	ret

+:
	xor a
	ld (_RAM_C501), a
	ld (_RAM_C502), a
	ld (_RAM_C50E), a
	ld a, $FF
	ld (_RAM_C51A), a
	call _LABEL_24AE
	ld de, _DATA_9850
	ld hl, $9782
	jp _LABEL_252E

; 49th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_435A:
	ld a, (iy+3)
	or a
	jp nz, _LABEL_43A8
	ld (iy+object.y_position_minor), $A0
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+22), $D0
	ld (iy+23), $30
	ld (iy+26), $02
	ld (iy+27), $40
	ld (iy+28), $10
	ld (iy+12), $01
	ld (iy+13), $08
	ld b, $28
	ld hl, _DATA_99B7
	ld a, (_RAM_X_POSITION_MINOR)
	cp $80
	jr nc, +
	ld b, $D8
	ld hl, _DATA_9926
+:
	ld (iy+object.x_position_minor), b
	ld (iy+56), $06
	ld (iy+object.boss_hp), $05
	jp _LABEL_249F

_LABEL_43A8:
	ld a, (iy+31)
	or a
	jp nz, _LABEL_44E0
	call _LABEL_1C8C
	jp c, _LABEL_450F
	ld a, (iy+47)
	or a
	jp nz, _LABEL_450F
	ld a, (iy+1)
	or a
	jp z, _LABEL_4498
	call _LABEL_84C
	ld h, (iy+26)
	ld l, (iy+27)
	dec hl
	ld (iy+26), h
	ld (iy+27), l
	ld a, h
	or l
	jp z, _LABEL_4477
	call ApplyObjectXVelocity
	ld a, (iy+object.x_position_minor)
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	cp $08
	jr nc, +++
	ld hl, _DATA_99EE
	ld de, $0100
	jr ++

+:
	cp $F8
	jr c, +++
	ld hl, _DATA_995D
	ld de, $FF00
++:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_24A3

+++:
	ld de, $0030
	ld l, (iy+object.y_velocity_sub)
	ld h, (iy+object.y_velocity_minor)
	add hl, de
	ld (iy+object.y_velocity_sub), l
	ld (iy+object.y_velocity_minor), h
	call ApplyObjectYVelocity
	ld a, (iy+object.y_position_minor)
	cp $9F
	ret c
	ld a, (iy+26)
	or a
	jr nz, +
	ld a, (iy+27)
	cp $20
	jp c, _LABEL_4477
+:
	ld (iy+object.y_position_minor), $A0
	ld hl, _DATA_456E
	ld a, r
	and $03
	add a, a
	ld e, a
	ld d, $00
	add hl, de
	ld a, (hl)
	ld (iy+object.y_velocity_sub), a
	inc hl
	ld a, (hl)
	ld (iy+object.y_velocity_minor), a
	ld (iy+12), $01
	call _LABEL_24BD
	cp $20
	jr nc, +
	ld (iy+12), $02
+:
	inc (iy+30)
	bit 0, (iy+30)
	ret nz
	ld hl, _DATA_995D
	ld de, $FF00
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld hl, _DATA_99EE
	ld de, $0100
+:
	ld (iy+object.x_velocity_sub), e
	ld (iy+object.x_velocity_minor), d
	jp _LABEL_249F

_LABEL_4477:
	ld (iy+1), $00
	ld (iy+29), $01
	ld (iy+28), $10
	ld (iy+14), $00
	ld hl, _DATA_99AF
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld hl, _DATA_991E
+:
	jp _LABEL_24A3

_LABEL_4498:
	dec (iy+28)
	ret nz
	inc (iy+14)
	ld (iy+28), $10
	ld a, (iy+14)
	cp $04
	ret nz
	ld a, (iy+29)
	or a
	jp nz, _LABEL_8AC
	ld (iy+1), $01
	ld (iy+14), $00
	ld hl, _DATA_995D
	ld de, $FF00
	ld a, (iy+object.x_position_minor)
	cp $80
	jr nc, +
	ld hl, _DATA_99EE
	ld de, $0100
+:
	ld (iy+4), l
	ld (iy+5), h
	ld (iy+object.x_velocity_minor), e ; BUG?
	ld (iy+object.x_velocity_minor), d
	ld (iy+object.y_velocity_sub), $00
	ld (iy+object.y_velocity_minor), $FC
	ret

_LABEL_44E0:
	ld a, (iy+31)
	dec (iy+53)
	jr nz, +
	cp $03
	jp z, _LABEL_6A47
	ld (iy+31), $00
	ret

+:
	cp $03
	jp z, _LABEL_4552
	ld b, $04
	bit 0, (iy+31)
	jr nz, +
	ld b, $FC
+:
	ld a, (iy+object.x_position_minor)
	add a, b
	cp $08
	ret c
	cp $F8
	ret nc
	ld (iy+object.x_position_minor), a
	ret

_LABEL_450F:
	ld (iy+47), $00
	ld (iy+53), $08
	ld b, $01
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld b, $02
+:
	ld (iy+31), b
	call _LABEL_5268
	ret nc
	ld (iy+31), $03
	ld a, (iy+4)
	ld (iy+8), a
	ld a, (iy+5)
	ld (iy+18), a
	ld (iy+53), $80
	ld a, (iy+object.type)
	cp $2E ; Necromancer
	jr z, +
	cp $30 ; Dark Suma
	jr z, +
	cp $42 ; Ra Goan
	ret nz
+:
	ld a, $A5
	ld (_RAM_SOUND_TO_PLAY), a
	ret

_LABEL_4552:
	bit 0, (iy+53)
	jr z, +
	ld a, (iy+8)
	ld (iy+4), a
	ld a, (iy+18)
	ld (iy+5), a
	ret

+:
	ld (iy+4), <_DATA_8FB8
	ld (iy+5), >_DATA_8FB8
	ret

; Data from 456E to 4575 (8 bytes)
_DATA_456E:
.db $00 $FC $80 $FB $40 $FB $80 $FC

; 55th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_4576:
	ld a, (_RAM_C503)
	or a
	jp nz, +
	ld a, $A0
	ld (_RAM_C50A), a
	ld a, $70
	ld (_RAM_C507), a
	ld hl, $14F4
	ld (_RAM_C518), hl
	ld hl, $28F0
	ld (_RAM_C516), hl
	call _LABEL_24AE
	ld a, $08
	ld (_RAM_C538), a
	ld a, $32
	ld (_RAM_BOSS_HP), a
	ld hl, _DATA_A4DD
	jp _LABEL_249F

+:
	ld a, (_RAM_C501)
	dec a
	jp z, _LABEL_407B
	ld a, (_RAM_C52F)
	or a
	jp nz, _LABEL_3F46
	ld a, (_RAM_C501)
	cp $04
	jp z, +
	call _LABEL_1C8C
	jp c, _LABEL_3F46
	ld a, (_RAM_C501)
	or a
	jp z, ++
	dec a
	dec a
	jp z, _LABEL_46AC
	jp _LABEL_4741

+:
	ld a, (_RAM_C507)
	add a, $01
	ld (_RAM_C507), a
	inc (iy+38)
	cp $70
	ret c
	ld a, $03
	ld (_RAM_C501), a
	ret

++:
	ld a, (_RAM_C502)
	or a
	jp nz, +
	ld hl, $A4DD
	ld (_RAM_C504), hl
	ld a, $50
	ld (_RAM_C532), a
	ld (_RAM_C533), a
	ld hl, $0004
	ld (_RAM_C530), hl
	ld hl, $FF60
	ld (_RAM_C510), hl
	ld hl, $FF80
	ld (_RAM_C513), hl
	ld a, $01
	ld (_RAM_C502), a
	ld a, r
	ld (_RAM_C520), a
+:
	ld a, (_RAM_C520)
	dec a
	ld (_RAM_C520), a
	jr nz, +
_LABEL_461F:
	ld a, (_RAM_C501)
	ld (_RAM_C522), a
	ld a, (_RAM_C502)
	ld (_RAM_C523), a
	ld a, $02
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ret

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	call _LABEL_880
	ld a, (_RAM_C532)
	cp $40
	ret nz
	ld a, (_RAM_C502)
	dec a
	jr z, _LABEL_4698
	dec a
	jr z, ++
	dec a
	jr z, +
	ld a, $01
	ld (_RAM_C502), a
	ld hl, $FF60
	ld (_RAM_C510), hl
	ld hl, $0004
	ld (_RAM_C530), hl
	ret

+:
	ld a, $04
	ld (_RAM_C502), a
	ld hl, $00A0
	ld (_RAM_C510), hl
	ld hl, $FFFC
	ld (_RAM_C530), hl
	call _LABEL_24E0
	ld a, (_RAM_X_POSITION_MINOR)
	cp $B0
	ret c
	ld a, $04
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ret

++:
	ld a, $03
	ld (_RAM_C502), a
	ld hl, $FF60
	ld (_RAM_C510), hl
	ld hl, $0004
	ld (_RAM_C530), hl
	ret

_LABEL_4698:
	ld a, $02
	ld (_RAM_C502), a
	ld hl, $00A0
	ld (_RAM_C510), hl
	ld hl, $FFFC
	ld (_RAM_C530), hl
	jp _LABEL_24E0

_LABEL_46AC:
	ld a, (_RAM_C502)
	or a
	jp nz, _LABEL_471A
	xor a
	ld (_RAM_C50E), a
	ld ix, _RAM_C400
	call _LABEL_8C8
	ld h, b
	ld l, c
	add hl, bc
	add hl, bc
	ld a, h
	ld c, l
	ld l, e
	ld h, d
	add hl, de
	add hl, de
	ld b, $08
	ld ix, _RAM_C540
	ld de, $0040
-:
	ld (ix+0), $3B
	ld (ix+16), l
	ld (ix+17), h
	ld (ix+19), c
	ld (ix+20), a
	add ix, de
	djnz -
	ld b, $04
	ld ix, _RAM_C540
	ld hl, _DATA_47C9
-:
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (ix+4), e
	ld (ix+5), d
	ld (ix+68), e
	ld (ix+69), d
	inc hl
	ld c, (hl)
	ld (ix+26), c
	inc hl
	ld c, (hl)
	ld (ix+90), c
	inc hl
	ld de, $0080
	add ix, de
	djnz -
	ld a, $01
	ld (_RAM_C502), a
	ld hl, $A577
	ld (_RAM_C504), hl
_LABEL_471A:
	ld a, $01
	ld (_RAM_C50E), a
	ld a, (_RAM_C540)
	or a
	ret nz
	ld a, (_RAM_C522)
	ld (_RAM_C501), a
	ld a, (_RAM_C523)
	ld (_RAM_C502), a
	ld hl, $A4DD
	ld (_RAM_C504), hl
	ld a, $01
	ld (_RAM_C521), a
	ld a, r
	ld (_RAM_C520), a
	ret

_LABEL_4741:
	ld a, (_RAM_C502)
	or a
	jp nz, ++
	ld a, $01
	ld (_RAM_C502), a
	ld a, (_RAM_X_POSITION_MINOR)
	cp $C8
	jr nc, +
	ld a, $01
	ld (_RAM_C528), a
	jp _LABEL_461F

+:
	ld hl, $A611
	ld (_RAM_C504), hl
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C528), a
	ld a, $08
	ld (_RAM_C50F), a
	ld a, $02
	ld (_RAM_C527), a
++:
	ld a, (_RAM_C525)
	or a
	jp nz, ++
	ld a, (_RAM_C528)
	or a
	jp nz, +
	dec (iy+15)
	ret nz
	ld a, $08
	ld (_RAM_C50F), a
	ld a, (_RAM_C50E)
	inc (iy+14)
	cp $03
	ret nz
	dec (iy+39)
	jr z, +
	xor a
	ld (_RAM_C50E), a
	ret

+:
	ld a, $01
	ld (_RAM_C525), a
	ld hl, $A4DD
	ld (_RAM_C504), hl
	xor a
	ld (_RAM_C50E), a
	ret

++:
	call _LABEL_84C
	ld a, (_RAM_C507)
	add a, $FF
	ld (_RAM_C507), a
	dec (iy+38)
	ret nz
	xor a
	ld (_RAM_C525), a
	ld (_RAM_C501), a
	ld a, $04
	ld (_RAM_C502), a
	ret

; Data from 47C9 to 47D8 (16 bytes)
_DATA_47C9:
.db $C8 $A6 $08 $0A $D5 $A6 $0C $0E $E2 $A6 $10 $12 $EF $A6 $14 $16

; 59th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_47D9:
	ld a, (iy+3)
	or a
	jp nz, +
	ld a, (_RAM_C50A)
	add a, $F4
	ld (iy+object.x_position_minor), a
	ld a, (_RAM_C507)
	add a, $10
	ld (iy+object.y_position_minor), a
	ld (iy+24), $FC
	ld (iy+25), $08
	ld (iy+22), $FC
	ld (iy+23), $08
	ld (iy+3), $01
	ld (iy+56), $02
+:
	ld a, (iy+1)
	or a
	jp z, ++
	dec a
	jp z, +
	dec (iy+26)
	ret nz
	jp _LABEL_8AC

+:
	call _LABEL_1C8C
	call ApplyObjectXVelocity
	call ApplyObjectYVelocity
	ld a, (iy+object.y_position_minor)
	cp $A0
	ret c
	ld (iy+1), $02
	ld (iy+26), $0A
	ret

++:
	dec (iy+26)
	ret nz
	ld (iy+1), $01
	ld (iy+14), $01
	ret

; 52nd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_483F:
	ld a, (_RAM_C503)
	or a
	jp nz, +
	ld a, $F0
	ld (_RAM_C50A), a
	ld a, $88
	ld (_RAM_C507), a
	ld hl, $10FC
	ld (_RAM_C518), hl
	ld hl, $38B0
	ld (_RAM_C516), hl
	ld a, $1E
	ld (_RAM_BOSS_HP), a
	ld a, $08
	ld (_RAM_C538), a
	ld hl, _DATA_9F02
	jp _LABEL_249F

+:
	ld a, (_RAM_C501)
	dec a
	jp z, _LABEL_407B
	call _LABEL_1C8C
	jp c, _LABEL_3F46
	ld a, (_RAM_C52F)
	or a
	jp nz, _LABEL_3F46
	ld a, (_RAM_C501)
	or a
	jp z, _LABEL_4998
	dec a
	dec a
	jp z, _LABEL_48D4
	ld a, (_RAM_C502)
	or a
	jp nz, +
	ld a, $01
	ld (_RAM_C502), a
	ld hl, $A054
	ld (_RAM_C504), hl
	xor a
	ld (_RAM_C50E), a
	ld a, $08
	ld (_RAM_C50F), a
	ret

+:
	ld a, (_RAM_C51C)
	or a
	ret nz
	dec (iy+15)
	ret nz
	inc (iy+14)
	ld (iy+15), $08
	ld a, (_RAM_C50E)
	cp $02
	jr z, +
	cp $05
	ret nz
	xor a
	ld (_RAM_C50E), a
	jp _LABEL_4990

+:
	ld a, $01
	ld (_RAM_C51C), a
	ld a, $35
	ld (_RAM_C540), a
	ret

_LABEL_48D4:
	ld a, (_RAM_C502)
	or a
	jp nz, _LABEL_493A
	ld a, (_RAM_X_POSITION_MINOR)
	ld b, a
	ld a, (_RAM_C50A)
	sub b
	jr c, +
	sub $20
	jr nc, ++
	ld hl, $9FA0
	ld (_RAM_C504), hl
	ld a, $02
	ld (_RAM_C51B), a
	ld a, $01
	ld (_RAM_C502), a
	ld a, $08
	ld (_RAM_C50F), a
	ret

+:
	ld hl, $0100
	ld (_RAM_C513), hl
	ld a, $03
	ld (_RAM_C502), a
	ret

++:
	ld c, $00
	cp $30
	jr nc, +
	inc c
	cp $20
	jr nc, +
	inc c
+:
	ld a, c
	add a, a
	ld e, a
	ld d, $00
	ld hl, _DATA_4934
	add hl, de
	ld a, (hl)
	ld (_RAM_C510), a
	inc hl
	ld a, (hl)
	ld (_RAM_C511), a
	ld a, $FF
	ld (_RAM_C514), a
	ld a, $02
	ld (_RAM_C502), a
	ret

; Data from 4934 to 4939 (6 bytes)
_DATA_4934:
.db $00 $FC $00 $FD $00 $FE

_LABEL_493A:
	dec a
	jr z, ++
	dec a
	jr z, +
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld a, (_RAM_X_POSITION_MINOR)
	add a, $08
	cp (iy+object.x_position_minor)
	ret nc
	jp _LABEL_4990

+:
	call ApplyObjectXVelocity
	ld de, $0020
	call _LABEL_869
	ld a, (_RAM_C507)
	cp $88
	ret c
	ld a, $88
	ld (_RAM_C507), a
	jp _LABEL_4990

++:
	dec (iy+15)
	ret nz
	ld a, $08
	ld (_RAM_C50F), a
	inc (iy+14)
	ld hl, $20F0
	ld a, (_RAM_C50E)
	cp $02
	jr nz, +
	ld hl, $38E0
	ld (_RAM_C518), hl
+:
	cp $05
	ret nz
	xor a
	ld (_RAM_C50E), a
	dec (iy+27)
	ret nz
_LABEL_4990:
	xor a
	ld (_RAM_C501), a
	ld (_RAM_C502), a
	ret

_LABEL_4998:
	ld a, (_RAM_C502)
	or a
	jr nz, +
	ld a, $02
	ld (_RAM_C50C), a
	ld a, $10
	ld (_RAM_C50D), a
	ld hl, $9F02
	ld (_RAM_C504), hl
	ld hl, $FF40
	ld (_RAM_C513), hl
	ld a, $01
	ld (_RAM_C502), a
	ld a, r
	and $3F
	or $40
	ld (_RAM_C51A), a
+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	ld a, (_RAM_X_POSITION_MINOR)
	cp $88
	jr c, +
	ld a, $02
-:
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ret

+:
	dec (iy+26)
	jr nz, +
	ld a, $03
	jp -

+:
	ld a, (_RAM_C50A)
	ld b, a
	ld a, (_RAM_C514)
	bit 7, a
	jr z, +
	ld a, $A0
	cp b
	ret c
	jp _LABEL_24E0

+:
	ld a, $F8
	cp b
	ret nc
	jp _LABEL_24E0

; 53rd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_49FC:
	ld a, (_RAM_C543)
	or a
	jp nz, +
	ld a, $04
	ld (_RAM_C578), a
	ld a, (_RAM_C50A)
	add a, $F8
	ld (_RAM_C54A), a
	ld a, (_RAM_C507)
	add a, $D8
	ld (_RAM_C547), a
	call _LABEL_2C9A
	ld a, $06
	ld (_RAM_C54C), a
	ld a, $06
	ld (_RAM_C54D), a
	ld hl, $18F4
	ld (_RAM_C558), hl
	ld hl, $10F0
	ld (_RAM_C556), hl
	ld hl, _DATA_A0B3
	jp _LABEL_249F

+:
	call _LABEL_1C8C
	ld b, a
	ld a, (_RAM_C55A)
	or a
	jr nz, +
	rrc b
	jp c, ++
+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	call ApplyObjectYVelocity
	ld a, (_RAM_C55A)
	or a
	jp nz, +++
	ld a, (_RAM_C54B)
	or a
	jr nz, ++
	ld a, (_RAM_C547)
	cp $B0
	jr nc, ++
	inc (iy+27)
	ret

++:
	ld a, $01
	ld (_RAM_C55A), a
	ld a, (_RAM_C55B)
	add a, $F8
	ld (_RAM_C55B), a
	call _LABEL_24E0
	jp _LABEL_24F3

+++:
	dec (iy+27)
	ret nz
	xor a
	ld (_RAM_C51C), a
	jp _LABEL_8AC

; 48th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_4A85:
	ld a, (_RAM_C503)
	or a
	jp nz, +
	ld a, $18
	ld (_RAM_C50A), a
	ld a, $A0
	ld (_RAM_C507), a
	ld hl, $18F4
	ld (_RAM_C518), hl
	ld hl, $30D0
	ld (_RAM_C516), hl
	ld a, $08
	ld (_RAM_C51A), a
	ld a, $14
	ld (_RAM_BOSS_HP), a
	ld a, $04
	ld (_RAM_C538), a
	ld hl, _DATA_ADE8
	jp _LABEL_249F

+:
	ld a, (_RAM_C51F)
	or a
	jp nz, _LABEL_44E0
	ld a, (_RAM_C52F)
	or a
	jp nz, _LABEL_450F
	ld a, (_RAM_C501)
	cp $03
	jp z, _LABEL_4B44
	call _LABEL_1C8C
	jp c, _LABEL_450F
	ld a, (_RAM_C501)
	or a
	jp z, _LABEL_4C7F
	dec a
	jp z, _LABEL_4BA0
	dec a
	jp z, _LABEL_4BD3
	ld a, (_RAM_C502)
	or a
	jp nz, ++
	ld hl, $AEC5
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld hl, $AFF6
+:
	ld (_RAM_C504), hl
	ld a, $08
	ld (_RAM_C502), a
	ld (_RAM_C50F), a
	xor a
	ld (_RAM_C50E), a
	ld a, $02
	ld (_RAM_C523), a
	ret

++:
	dec (iy+15)
	ret nz
	inc (iy+14)
	ld a, $08
	ld (_RAM_C50F), a
	ld a, (_RAM_C50E)
	cp $02
	jr nz, +
	ld a, $18
	ld (_RAM_C50F), a
	ld a, $3E
	ld (_RAM_C540), a
	ret

+:
	cp $03
	ret nz
	dec (iy+35)
	jr z, +
	xor a
	ld (_RAM_C50E), a
	ret

+:
	ld a, $03
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ld (_RAM_C50E), a
	ret

_LABEL_4B44:
	ld a, (_RAM_C502)
	or a
	jp nz, ++
	ld a, $01
	ld (_RAM_C502), a
	call _LABEL_24AE
_LABEL_4B53:
	ld hl, $AE3A
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld hl, $AE3E
+:
	ld (_RAM_C504), hl
	ld a, $30
	ld (_RAM_C522), a
	ret

++:
	call _LABEL_84C
	dec (iy+object.boss_teleport_timer)
	ret nz
	ld a, (_RAM_C523)
	or a
	jr z, +
	ld a, $04
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ld (_RAM_C523), a
	ret

+:
	ld a, $20
	ld (_RAM_C523), a
	ld a, (_RAM_X_POSITION_MINOR)
	cp $80
	jr nc, +
	ld a, r
	or $80
	jr ++

+:
	ld a, r
	and $7F
++:
	ld (_RAM_C50A), a
	jp _LABEL_4B53

_LABEL_4BA0:
	ld a, (_RAM_C502)
	or a
	jp nz, ++
	ld hl, $ADE8
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr nc, +
	ld hl, $AF21
+:
	ld (_RAM_C504), hl
	ld a, $01
	ld (_RAM_C50E), a
	ld (_RAM_C502), a
++:
	inc (iy+object.y_position_minor)
	ld a, (_RAM_C507)
	cp $B0
	ret c
	ld a, $03
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ret

_LABEL_4BD3:
	ld a, (_RAM_C502)
	or a
	jp nz, _LABEL_4C2A
	ld b, $04
	ld c, $00
	ld hl, _RAM_C540
-:
	ld (hl), $3D
	ld de, $003C
	add hl, de
	ld (hl), c
	inc c
	ld de, $0004
	add hl, de
	djnz -
	ld a, $10
	ld (_RAM_C51B), a
	ld a, $04
	ld (_RAM_C530), a
	ld (_RAM_C502), a
	xor a
	ld (_RAM_C531), a
	ld (_RAM_C50E), a
	ld a, $60
	ld (_RAM_C51A), a
	ld (_RAM_C532), a
	ld (_RAM_C533), a
	ld hl, $0080
	ld (_RAM_C513), hl
	ld hl, $FF40
	ld (_RAM_C510), hl
	ld hl, $AE42
	ld (_RAM_C504), hl
	ld a, $04
	ld (_RAM_C50C), a
	ld a, $08
	ld (_RAM_C50D), a
_LABEL_4C2A:
	ld a, (_RAM_C51B)
	or a
	jr nz, +
	xor a
	ld (_RAM_C502), a
	ld a, $01
	ld (_RAM_C501), a
	ret

+:
	call _LABEL_84C
	call ApplyObjectXVelocity
	call _LABEL_880
	ld a, (_RAM_C50A)
	cp $04
	jr c, +
	cp $FC
	jr c, ++
+:
	call _LABEL_24E0
	ld hl, $AF73
	ld de, _DATA_AE42
	call _LABEL_252E
++:
	dec (iy+26)
	ret nz
	ld a, r
	and $3F
	or $C0
	ld (_RAM_C51A), a
	ld hl, $AF73
	ld de, $FF80
	bit 0, a
	jr z, +
	ld hl, $AE42
	ld de, $0080
+:
	ld (_RAM_C504), hl
	ld (_RAM_C513), de
	ret

_LABEL_4C7F:
	ld a, (_RAM_C502)
	or a
	jp nz, +
	dec (iy+26)
	ret nz
	ld a, $01
	ld (_RAM_C502), a
	ld hl, $FE80
	ld (_RAM_C510), hl
	inc (iy+14)
+:
	call ApplyObjectYVelocity
	ld a, (_RAM_C507)
	cp $50
	ret nc
	ld a, $02
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ret

; 61st entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_4CAB:
	ld a, (iy+3)
	or a
	jp nz, _LABEL_4D71
	ld (iy+22), $F0
	ld (iy+23), $10
	ld (iy+24), $F8
	ld (iy+25), $10
	ld (iy+object.respawn_timer_minor), $FC
	ld (iy+object.respawn_timer_major), $FF
	ld a, (iy+60)
	ld b, a
	add a, a
	ld c, a
	add a, a
	add a, c
	add a, b
	ld e, a
	ld d, $00
	ld hl, _DATA_4D12
	add hl, de
	ld a, (hl)
	ld (iy+object.x_position_minor), a
	inc hl
	ld a, (hl)
	ld (iy+object.y_velocity_sub), a
	inc hl
	ld a, (hl)
	ld (iy+object.y_velocity_minor), a
	inc hl
	ld a, (hl)
	ld (iy+object.x_velocity_sub), a
	inc hl
	ld a, (hl)
	ld (iy+object.x_velocity_minor), a
	inc hl
	ld a, (hl)
	ld (iy+26), a
	inc hl
	ld a, (hl)
	ld (iy+50), a
	ld (iy+51), a
	ld a, $B0
	ld (iy+object.y_position_minor), a
	ld (iy+56), $02
	ld (iy+object.boss_hp), $01
	ld hl, _DATA_B073
	jp _LABEL_249F

; Data from 4D12 to 4D2D (28 bytes)
_DATA_4D12:
.db $10 $C0 $00 $00 $02 $90 $60 $40 $80 $00 $80 $01 $80 $40 $C0 $80
.db $00 $80 $FE $80 $40 $F0 $C0 $00 $00 $FE $90 $60

_LABEL_4D2E:
	ld (iy+47), $00
	ld (iy+1), $01
	ld a, (iy+4)
	ld (iy+8), a
	ld a, (iy+5)
	ld (iy+18), a
	ld a, (iy+1)
	ld (iy+29), a
	ld (iy+31), $0A
	ret

-:
	bit 0, (iy+31)
	jp z, +
	ld (iy+4), <_DATA_8FB8
	ld (iy+5), >_DATA_8FB8
	jr ++

+:
	ld a, (iy+8)
	ld (iy+4), a
	ld a, (iy+18)
	ld (iy+5), a
++:
	dec (iy+31)
	ret nz
	jp _LABEL_3F91

_LABEL_4D71:
	ld a, (iy+1)
	dec a
	jp z, -
	call _LABEL_1C8C
	jp c, _LABEL_4D2E
	ld a, (iy+47)
	or a
	jp nz, _LABEL_4D2E
	ld a, (iy+1)
	or a
	jp z, _LABEL_4DE8
	dec a
	dec a
	jp z, +
	ld (iy+4), <_DATA_B073
	ld (iy+5), >_DATA_B073
	dec (iy+32)
	ret nz
	ld (iy+1), $02
	ld (iy+2), $00
	ld (iy+14), $00
	ret

+:
	ld a, (iy+2)
	or a
	jp nz, ++
	ld hl, _DATA_B07E
	bit 7, (iy+object.x_velocity_minor)
	jr nz, +
	ld hl, _DATA_B05D
+:
	ld (iy+4), l
	ld (iy+5), h
	ld (iy+2), $01
	jp _LABEL_24AE

++:
	call _LABEL_84C
	call ApplyObjectXVelocity
	call _LABEL_880
	ld a, (iy+50)
	cp (iy+51)
	ret nz
	ld a, r
	and $3F
	ld (iy+32), a
	ld (iy+1), $03
	jp _LABEL_24E0

_LABEL_4DE8:
	dec (iy+object.y_position_minor)
	ld a, (iy+object.y_position_minor)
	cp (iy+26)
	ret nc
	ld a, r
	and $3F
	ld (iy+32), a
	ld (iy+1), $03
	ret

; 62nd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_4DFE:
	ld a, (_RAM_C543)
	or a
	jp nz, _LABEL_4E4B
	ld a, $06
	ld (_RAM_C578), a
	ld a, $B0
	add a, $E8
	ld (_RAM_C547), a
	ld c, $E8
	ld hl, $B0B0
	ld d, $FD
	ld a, (_RAM_C50A)
	ld b, a
	ld a, (_RAM_X_POSITION_MINOR)
	cp b
	jr c, +
	ld c, $18
	ld hl, $B094
	ld d, $03
+:
	ld a, b
	add a, c
	ld (_RAM_C54A), a
	ld (_RAM_C544), hl
	ld a, d
	ld (_RAM_C554), a
	ld hl, $06FD
	ld (_RAM_C558), hl
	ld hl, $0AF3
	ld (_RAM_C556), hl
	ld a, $0A
	ld (_RAM_C54F), a
	ld a, $01
	ld (_RAM_C543), a
_LABEL_4E4B:
	call _LABEL_1C8C
	call ApplyObjectXVelocity
	ld a, (_RAM_C54B)
	or a
	jp nz, _LABEL_8AC
	ld a, (_RAM_C55A)
	or a
	ret nz
	dec (iy+15)
	ret nz
	inc (iy+14)
	ld a, $0A
	ld (_RAM_C54F), a
	ld a, (_RAM_C54E)
	cp $04
	ret nz
	ld a, $03
	ld (_RAM_C54E), a
	ld a, $01
	ld (_RAM_C55A), a
	ret

; 66th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_4E7A:
	ld a, (_RAM_C503)
	or a
	jp nz, +
	ld a, $B0
	ld (_RAM_C50A), a
	ld a, $A0
	ld (_RAM_C507), a
	ld hl, $20F0
	ld (_RAM_C518), hl
	ld hl, $50B0
	ld (_RAM_C516), hl
	ld a, $01
	ld (_RAM_C50C), a
	ld a, $04
	ld (_RAM_C538), a
	ld a, $3C
	ld (_RAM_BOSS_HP), a
	ld hl, _DATA_B0CC
	jp _LABEL_249F

+:
	ld a, (_RAM_C51F)
	or a
	jp nz, _LABEL_44E0
	call _LABEL_1C8C
	rlc a
	ld b, a
	ld a, (_RAM_C52F)
	or a
	jp nz, _LABEL_44E0
	ld a, (_RAM_C440)
	or a
	jr z, +
	ld a, (_RAM_C501)
	cp $03
	jr z, +
	ld a, (_RAM_C44A)
	cp $30
	jr c, +
	cp $E0
	jr nc, +
	ld a, $03
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ld a, $3F
	ld (_RAM_C580), a
+:
	ld a, (_RAM_C501)
	or a
	jp z, _LABEL_4FE4
	dec a
	jp z, _LABEL_4F7E
	dec a
	jp z, ++
	ld a, (_RAM_C502)
	or a
	jp nz, +++
	ld a, $01
	ld (_RAM_C502), a
	ld hl, $B1F9
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld hl, $B2B8
+:
	ld (_RAM_C504), hl
	ld a, $08
	ld (_RAM_C40F), a
	ret

++:
	ld a, (_RAM_C502)
	or a
	jp nz, +++
	ld hl, $B2BE
	ld a, (_RAM_C51C)
	or a
	jr nz, +
	ld hl, $B185
+:
	ld (_RAM_C504), hl
	ld a, $10
	ld (_RAM_C50F), a
	ld (_RAM_C502), a
+++:
	dec (iy+15)
	ret nz
	ld a, $08
	ld (_RAM_C50F), a
	ld a, (_RAM_C50E)
	inc a
	ld (_RAM_C50E), a
	cp $02
	jr z, +
	cp $03
	ret nz
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C501), a
	ld (_RAM_C502), a
	ret

+:
	ld a, (_RAM_C501)
	cp $03
	jr z, ++
	ld b, $40
	ld a, (_RAM_C51C)
	or a
	jr z, +
	ld b, $41
+:
	ld a, b
	ld (_RAM_C540), a
	ld a, $20
	ld (_RAM_C50F), a
	ret

++:
	ld a, $3F
	ld (_RAM_C580), a
	ld a, $20
	ld (_RAM_C50F), a
	ret

_LABEL_4F7E:
	ld a, (_RAM_C502)
	or a
	jp nz, _LABEL_4FC8
	ld a, $02
	ld (_RAM_C50C), a
	ld (_RAM_C502), a
	ld a, $08
	ld (_RAM_C50D), a
	ld a, $30
	ld (_RAM_C51A), a
	ld a, (_RAM_C51B)
	or a
	jr nz, ++
	ld hl, $B10F
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld hl, $B242
+:
	ld (_RAM_C504), hl
	ret

++:
	ld hl, $B10F
	ld b, $C8
	ld a, (_RAM_X_POSITION_MINOR)
	cp $80
	jr c, +
	ld hl, $B242
	ld b, $38
+:
	ld (_RAM_C504), hl
	ld a, b
	ld (_RAM_C50A), a
	ret

_LABEL_4FC8:
	call _LABEL_84C
	dec (iy+26)
	ret nz
	inc (iy+27)
	xor a
	ld (_RAM_C502), a
	ld a, (_RAM_C51B)
	cp $02
	ret nz
	xor a
	ld (_RAM_C51B), a
	ld (_RAM_C501), a
	ret

_LABEL_4FE4:
	ld a, (_RAM_C502)
	or a
	jp nz, _LABEL_502B
	ld a, $10
	ld (_RAM_C51A), a
	ld (_RAM_C502), a
	ld a, (_RAM_X_POSITION_MINOR)
	cp $20
	jr c, +++
	cp $EF
	jr nc, +++
	sub (iy+object.x_position_minor)
	bit 7, a
	jr z, +
	cp $D0
	jr c, +++
	jr ++

+:
	cp $40
	jr nc, +++
++:
	ld a, $01
	ld (_RAM_C51E), a
	ret

+++:
	ld b, $00
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	jr c, +
	ld b, $01
+:
	ld a, $02
	ld (_RAM_C51E), a
	ld a, b
	ld (_RAM_C51C), a
	ret

_LABEL_502B:
	rrc b
	call c, _LABEL_450F
	dec (iy+26)
	ret nz
	ld a, (_RAM_C51E)
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C502), a
	ret

; 64th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_503F:
	ld a, (_RAM_C543)
	or a
	jp nz, _LABEL_5072
	ld a, $01
	ld (_RAM_C578), a
	ld a, (_RAM_C50A)
	add a, $F4
	ld (_RAM_C54A), a
	ld a, $A0
	add a, $CC
	ld (_RAM_C547), a
	call _LABEL_2C9A
	call _LABEL_50BE
	ld hl, $10F8
	ld (_RAM_C558), hl
	ld hl, $10F0
	ld (_RAM_C556), hl
	ld hl, _DATA_B35C
	jp _LABEL_249F

_LABEL_5072:
	call _LABEL_1C8C
	call ApplyObjectXVelocity
	call ApplyObjectYVelocity
	ld a, (_RAM_C54B)
	or a
	jp nz, _LABEL_8AC
	ld a, (_RAM_C547)
	cp $A0
	ret c
	jp _LABEL_8AC

; 65th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_508B:
	ld a, (_RAM_C543)
	or a
	jp nz, _LABEL_5072
	ld a, $01
	ld (_RAM_C578), a
	ld a, (_RAM_C50A)
	add a, $10
	ld (_RAM_C54A), a
	ld a, $A0
	add a, $DC
	ld (_RAM_C547), a
	call _LABEL_2C9A
	call _LABEL_50BE
	ld hl, $20E0
	ld (_RAM_C556), hl
	ld hl, $10F8
	ld (_RAM_C558), hl
	ld hl, _DATA_B367
	jp _LABEL_249F

_LABEL_50BE:
	ld l, e
	ld h, d
	add hl, de
	ld (_RAM_C550), hl
	ld l, c
	ld h, b
	add hl, bc
	ld (_RAM_C553), hl
	ret

; 63rd entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_50CB:
	ld a, (_RAM_C583)
	or a
	jp nz, ++
	ld a, $02
	ld (_RAM_C5B8), a
	ld hl, $08F8
	ld (_RAM_C598), hl
	ld hl, $30D0
	ld (_RAM_C596), hl
	ld a, $A0
	ld (_RAM_C587), a
	ld a, (_RAM_X_POSITION_MINOR)
	ld b, a
	ld c, $F8
	ld hl, _DATA_B336
	ld a, (_RAM_C50A)
	cp b
	jr nc, +
	ld c, $08
	ld hl, _DATA_B34D
+:
	add a, c
	ld (_RAM_C58A), a
	ld a, $28
	ld (_RAM_C59A), a
	jp _LABEL_249F

++:
	call _LABEL_173E
	call _LABEL_1C8C
	dec (iy+26)
	ret nz
	jp _LABEL_8AC

LoadMapEnemies:
	ld a, :Bank10
	ld (_RAM_FFFF), a
	ld a, (_RAM_CURRENT_MAP)
	ld l, a
	ld h, $00
	add hl, hl
	ld de, MapEnemySpawnArrayPointers
	add hl, de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld b, (hl)
	ld iy, _RAM_C500
-:
	inc hl
	ld a, (hl)
	ld (iy+object.type), a
	ld (iy+59), a
	inc hl
	ld a, (hl)
	ld (iy+object.y_position_minor), a
	ld (iy+60), a
	inc hl
	ld a, (hl)
	ld (iy+object.x_position_minor), a
	ld (iy+61), a
	inc hl
	ld a, (hl)
	ld (iy+object.x_position_major), a
	ld (iy+object.boss_defeated), a
	inc hl
	ld a, (hl)
	ld (iy+56), a
	ld (iy+63), $03
	call _LABEL_524C
	call _LABEL_5223
	ld de, $0040
	add iy, de
	djnz -
	inc hl
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld b, (hl)
_LABEL_516A:
	push bc
	push hl
	ld de, $0005
	add hl, de
	ld b, $09
	ld a, (hl)
	cp $09
	jr z, +
	ld b, $07
	cp $07
	jr z, +
	ld b, $0A
	cp $0A
	jr z, +
	ld b, $08
+:
	pop hl
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld a, (hl)
	inc hl
	push hl
	ld h, (hl)
	ld l, a
	ld a, b
	ld (_RAM_FFFF), a
	call _LABEL_1DC8
	pop hl
	inc hl
	ld a, :Bank10
	ld (_RAM_FFFF), a
	ld a, (hl)
	or a
	jp z, _LABEL_51EC
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (_RAM_C0B4), de
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (_RAM_C0B6), de
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (_RAM_C0B8), de
	push hl
	call _LABEL_1EFB
	pop hl
-:
	pop bc
	djnz _LABEL_516A
	ld a, :Bank8
	ld (_RAM_FFFF), a
	ld hl, _DATA_21268
	ld bc, $0008
	ld de, $C018
	call LoadVDPData
	ld a, (_RAM_C500)
	cp $2B
	ret nc
	ld de, $4400
	ld hl, _DATA_21178
	call _LABEL_1DC8
	ld de, $5F00
	ld hl, _DATA_204F4
	jp _LABEL_1DC8

_LABEL_51EC:
	ld de, $0006
	add hl, de
	jp -

_LABEL_51F3:
	ld a, (iy+54)
	or a
	ret z
	jp _LABEL_3EA3

_LABEL_51FB:
	ld hl, _RAM_C131
	xor a
	add a, (hl)
	ld (iy+9), a
	inc hl
	ld a, (iy+61)
	adc a, (hl)
	ld (iy+object.x_position_minor), a
	inc hl
	ld a, (iy+object.boss_defeated)
	adc a, (hl)
	ld (iy+object.x_position_major), a
	ld a, (iy+59)
	ld (iy+object.type), a
	ld a, (iy+60)
	ld (iy+object.y_position_minor), a
	ld (iy+54), $00
_LABEL_5223:
	bit 7, (iy+object.x_position_major)
	jr z, +
-:
	ld (iy+55), $01
	ret

+:
	ld a, (iy+object.x_position_major)
	or a
	jr nz, +
	ld a, (iy+object.x_position_minor)
	cp $80
	jp c, -
+:
	ld (iy+55), $00
	ret

_LABEL_5241:
	ld b, $35
	push iy
	pop hl
-:
	inc hl
	ld (hl), $00
	djnz -
	ret

_LABEL_524C:
	push hl
	ld a, (iy+59)
	add a, $F0
	ld e, a
	ld d, $00
	ld hl, _DATA_52A2
	add hl, de
	ld a, (hl)
	ld (iy+27), a
	and $F0
	rrca
	rrca
	rrca
	rrca
	ld (iy+object.current_hp), a
	pop hl
	ret

_LABEL_5268:
	ld hl, _RAM_SWORD_DAMAGE
	ld a, (iy+object.type)
	cp $2A ; Damaged
	jp nc, ++
	ld a, (iy+26)
	or a
	jr z, +
	ld hl, _RAM_BOW_DAMAGE
+:
	ld (iy+26), $00
	ld b, (hl)
	ld a, (iy+object.current_hp)
	sub b
	ld (iy+object.current_hp), a ; Apply Sword/Bow Damage To Enemy
	ret

++:
	ld a, (iy+63)
	or a
	jr z, +
	ld hl, _RAM_BOW_DAMAGE
+:
	ld (iy+63), $00
	ld b, (hl)
	ld a, (iy+object.boss_hp)
	sub b
	ld (iy+object.boss_hp), a ; Apply Sword/Bow Damage To Boss
	ret c
	ret nz
	scf
	ret

; Data from 52A2 to 52BB (26 bytes)
_DATA_52A2:
.db $23 $28 $14 $38 $13 $14 $26 $24 $23 $26 $12 $28 $24 $13 $13 $12
.db $13 $14 $23 $36 $26 $24 $33 $11 $23 $13

_LABEL_52BC:
	ld bc, $8201
	call SendVDPCommand
	ld bc, $0008
	call SendVDPCommand
	ld bc, $FF0A
	call SendVDPCommand
	ld a, a
	ld a, :Bank3
	ld (_RAM_FFFF), a
	call _LABEL_C9C8
	ld de, $7F00
	ld a, $D0
	ld (_RAM_C300), a
	call _LABEL_316
	ld hl, _RAM_C109
	ld de, _RAM_C109 + 1
	ld bc, $001F
	ld (hl), b
	ldir
	xor a
	ld hl, _RAM_C440
	ld de, _RAM_C440 + 1
	ld bc, $05BF
	ld (hl), a
	ldir
	ld (_RAM_C14C), a
	ld (_RAM_C0A7), a
	ld iy, _RAM_C400
	ld a, (_RAM_C161)
	or a
	call z, _LABEL_8AC
	call _LABEL_595A
	call CheckVarlinDoor
	call LoadMapEnemies
	call _LABEL_535B ; Load Map Metadata (Warps, Starting Position etc.)?
	call _LABEL_53D3 ; Load Map Layout?
	call _LABEL_5808
	call _LABEL_1B1D
	call _LABEL_5820
	call CheckPirateSpawned
	xor a ; Building_Status_Map
	ld (_RAM_BUILDING_STATUS), a
	call _LABEL_54AB
	call _LABEL_54D5
	call _LABEL_9F3
	ld a, $01
	ld (_RAM_C12A), a
	ld (_RAM_C16D), a
	ld (_RAM_C093), a
	call _LABEL_5483
	call _LABEL_586E
	call _LABEL_544F
	call _LABEL_550F
	xor a
	ld (_RAM_C0A7), a
	ld bc, $7600
	call SendVDPCommand
	ld bc, $E201
	jp SendVDPCommand

_LABEL_535B:
	ld c, :Bank11
	ld a, (_RAM_CURRENT_MAP)
	cp $44 ; Mountains (Amon +2UL) (Pharazon +2R) (L)
	jp c, +
	ld c, :Bank12
+:
	ld a, c
	ld (_RAM_FFFF), a
	ld a, (_RAM_CURRENT_MAP)
	ld de, _DATA_5546
	ld l, a
	ld h, $00
	add hl, hl
	add hl, de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld a, $01
	ld (_RAM_C400), a
	ld a, (hl)
	ld (_RAM_Y_POSITION_MINOR), a
	inc hl
	ld a, (hl)
	ld (_RAM_X_POSITION_MINOR), a
	inc hl
	ld a, (hl)
	ld (_RAM_C10C), a
	inc hl
	ld a, (hl)
	ld (_RAM_C10D), a
	inc hl
	ld a, (hl)
	ld (_RAM_C117), a
	inc hl
	ld a, (hl)
	ld (_RAM_C118), a
	inc hl
	ld a, (hl)
	ld (_RAM_C115), a
	inc hl
	ld a, (hl)
	ld (_RAM_C116), a
	inc hl
	ld a, (hl)
	ld (_RAM_WARP_DESTINATION_TOP_RIGHT), a
	inc hl
	ld a, (hl)
	ld (_RAM_WARP_DESTINATION_BOTTOM_RIGHT), a
	inc hl
	ld a, (hl)
	ld (_RAM_WARP_DESTINATION_TOP_LEFT), a
	inc hl
	ld a, (hl)
	ld (_RAM_WARP_DESTINATION_BOTTOM_LEFT), a
	ld hl, $C07E
	ld (_RAM_C112), hl
	ld a, $01
	ld (_RAM_C0A2), a
	ld a, (_RAM_C118)
	cp $01
	ret z
	cp $03
	ret z
	xor a
	ld (_RAM_C0A2), a
	ret

_LABEL_53D3:
	ld hl, (_RAM_C10C)
	call _LABEL_1E50
	ld c, :Bank13
	ld a, (_RAM_C118)
	cp $06
	jr c, +
	ld c, :Bank14
+:
	ld a, c
	ld (_RAM_FFFF), a
	ld hl, $551C
	ld a, (_RAM_C118)
	add a, a
	add a, a
	ld e, a
	ld d, $00
	add hl, de
	ld a, (hl)
	ld (_RAM_C10C), a
	inc hl
	ld a, (hl)
	ld (_RAM_C10D), a
	inc hl
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	call _LABEL_3DA
	ld de, $6400
	jp _LABEL_1DC8

_LABEL_540B:
	ld a, (_RAM_C118)
	cp $03
	ret nz
	ld hl, _RAM_C14D
	inc (hl)
	ld a, (hl)
	cp $08
	ret c
	ld (hl), $00
	inc hl
	inc (hl)
	ld a, (hl)
	cp $03
	jp c, +
	xor a
	ld (hl), a
+:
	ld e, a
	ld d, $00
	ld hl, _DATA_5435
	add hl, de
	ld (_RAM_C14F), hl
	ld a, $01
	ld (_RAM_C14C), a
	ret

; Data from 5435 to 5439 (5 bytes)
_DATA_5435:
.db $3C $38 $34 $3C $38

_LABEL_543A:
	ld a, (_RAM_C14C)
	or a
	ret z
	xor a
	ld (_RAM_C14C), a
	ld hl, (_RAM_C14F)
	ld bc, $0003
	ld de, $C00D
	jp LoadVDPData

_LABEL_544F:
	ld a, :Bank3
	ld (_RAM_FFFF), a
	ld c, $85
	ld a, (_RAM_C118)
	cp $07
	jr z, _LABEL_5467
	cp $09
	jr z, +
	cp $0A
	jr z, +
	ld c, $83
_LABEL_5467:
	push bc
	call _LABEL_C989
	pop bc
	ld a, c
	ld (_RAM_SOUND_TO_PLAY), a
	ret

+:
	ld c, $84
	ld a, (_RAM_CURRENT_MAP)
	cp $7E ; Dark Suma's Dungeon 1F (DL)
	jp z, _LABEL_5467
	cp $82 ; Ra Goan's Dungeon Entrance
	jp z, _LABEL_5467
	jp _LABEL_C9C8

_LABEL_5483:
	ld a, (_RAM_CURRENT_MAP)
	cp $82 ; Ra Goan's Dungeon Entrance
	ret nz
	ld a, $04
	ld (_RAM_C480), a
	ld a, $40
	ld (_RAM_C487), a
	ld a, $10
	ld (_RAM_C48A), a
	ld a, $FF
	ld (_RAM_C48B), a
	ld a, :Bank3
	ld (_RAM_FFFF), a
	ld hl, _DATA_EE5B
	ld de, $5F80
	jp _LABEL_1DC8

_LABEL_54AB:
	ld a, (_RAM_C118)
	cp $09
	jr z, +
	cp $0A
	jr nz, ++
+:
	ld a, (_RAM_CURRENT_MAP)
	cp $7E ; Dark Suma's Dungeon 1F (DL)
	jr z, ++
	cp $82 ; Ra Goan's Dungeon Entrance
	jr z, ++
	ld a, $01
	ld (_RAM_C16E), a
	ret

++:
	xor a
	ld (_RAM_C16E), a
	ld (_RAM_C131), a
	ld (_RAM_C132), a
	ld (_RAM_C133), a
	ret

_LABEL_54D5:
	ld a, (_RAM_C16E)
	or a
	ret z
	xor a
	ld (_RAM_C16E), a
	ld a, (_RAM_C132)
	and $F8
	ld (_RAM_C132), a
	ld b, $10
	ld de, $0040
	ld iy, _RAM_C500
-:
	ld a, (_RAM_C131)
	add a, (iy+9)
	ld (iy+9), a
	ld a, (_RAM_C132)
	adc a, (iy+object.x_position_minor)
	ld (iy+object.x_position_minor), a
	ld a, (_RAM_C133)
	adc a, (iy+object.x_position_major)
	ld (iy+object.x_position_major), a
	add iy, de
	djnz -
	ret

_LABEL_550F:
	ld a, :Bank4
	ld (_RAM_FFFF), a
	ld hl, _DATA_137E0
	ld de, $43C0
	ld bc, $0040
	jp LoadVDPData

; Pointer Table from 5520 to 5545 (19 entries, indexed by _RAM_C118)
_DATA_5520:
.dw _DATA_34000 _DATA_34000 _DATA_34288 _DATA_34CDD _DATA_34578 _DATA_35C42 _DATA_346C8 _DATA_3649D
.dw _DATA_34988 _DATA_36C9B _DATA_34C28 _DATA_34000 _DATA_34D80 _DATA_34D4C _DATA_34F80 _DATA_35832
.dw _DATA_35120 _DATA_35DCA _DATA_351B0

; Pointer Table from 5546 to 5653 (135 entries, indexed by _RAM_CURRENT_MAP)
_DATA_5546:
.dw _DATA_2E1B2 _DATA_2C000 _DATA_2C00C _DATA_2C018 _DATA_2C024 _DATA_2C030 _DATA_2C03C _DATA_2C048
.dw _DATA_2C054 _DATA_2C060 _DATA_2C06C _DATA_2C078 _DATA_2C084 _DATA_2C090 _DATA_2C09C _DATA_2C0A8
.dw _DATA_2C0B4 _DATA_2C0C0 _DATA_2C0CC _DATA_2C0D8 _DATA_2C0E4 _DATA_2C0F0 _DATA_2C0FC _DATA_2C108
.dw _DATA_2C114 _DATA_2C120 _DATA_2C12C _DATA_2C138 _DATA_2C144 _DATA_2C150 _DATA_2C15C _DATA_2C168
.dw _DATA_2C174 _DATA_2C180 _DATA_2C18C _DATA_2C198 _DATA_2C1A4 _DATA_2C1B0 _DATA_2C1BC _DATA_2C1C8
.dw _DATA_2C1D4 _DATA_2C1E0 _DATA_2C1EC _DATA_2C1F8 _DATA_2C204 _DATA_2C210 _DATA_2C21C _DATA_2C228
.dw _DATA_2C234 _DATA_2C240 _DATA_2C24C _DATA_2C258 _DATA_2C264 _DATA_2C270 _DATA_2C27C _DATA_2C288
.dw _DATA_2C294 _DATA_2C2A0 _DATA_2C2AC _DATA_2C2B8 _DATA_2C2C4 _DATA_2C2D0 _DATA_2C2DC _DATA_2C2E8
.dw _DATA_2C2F4 _DATA_2C300 _DATA_2C30C _DATA_2C318 _DATA_2C000 _DATA_2C00C _DATA_2C030 _DATA_2C03C
.dw _DATA_2C048 _DATA_2C054 _DATA_2C018 _DATA_2C024 _DATA_2C060 _DATA_2C06C _DATA_2C078 _DATA_2C084
.dw _DATA_2C090 _DATA_2C09C _DATA_2C0A8 _DATA_2C0B4 _DATA_2C0C0 _DATA_2C0CC _DATA_2C0D8 _DATA_2C0E4
.dw _DATA_2C0F0 _DATA_2C0FC _DATA_2C108 _DATA_2C114 _DATA_2C120 _DATA_2C12C _DATA_2C138 _DATA_2C144
.dw _DATA_2C150 _DATA_2C15C _DATA_2C168 _DATA_2C174 _DATA_2C180 _DATA_2C18C _DATA_2C198 _DATA_2C1A4
.dw _DATA_2C1B0 _DATA_2C1BC _DATA_2C1C8 _DATA_2C1D4 _DATA_2C1E0 _DATA_2C1EC _DATA_2C1F8 _DATA_2C204
.dw _DATA_2C210 _DATA_2C21C _DATA_2C228 _DATA_2C234 _DATA_2C240 _DATA_2C24C _DATA_2C258 _DATA_2C264
.dw _DATA_2C270 _DATA_2C27C _DATA_2C288 _DATA_2C294 _DATA_2C2A0 _DATA_2C2AC _DATA_2C2C4 _DATA_2C2B8
.dw _DATA_2C2D0 _DATA_2C2DC _DATA_2C2E8 _DATA_2C2F4 _DATA_2C300 _DATA_2C30C _DATA_2C318

ProcessWarpsAndDoors:
	ld a, (_RAM_C118)
	cp $07
	jp nz, +
	ld a, (_RAM_CONTROLLER_INPUT)
	bit ButtonUp, a ; Enter Door
	jr z, +
	ld iy, _RAM_C400
	ld de, $F000
	call _LABEL_15E5
	rlca
	jp c, _LABEL_57B1
+:
	ld a, (_RAM_CURRENT_MAP)
	cp $7E ; Dark Suma's Dungeon 1F (DL)
	jp nc, _LABEL_56E5
	cp $78 ; Castle Elder
	jp z, _LABEL_57DF
	cp $7C ; Castle Varlin (DL, Open)
	jp z, _LABEL_57C7
	cp $7D ; Castle Varlin (UL, Open)
	jp z, _LABEL_57C7
	ld hl, (_RAM_C115)
	ld a, (_RAM_SCREEN_X_TILE)
	cp h
	jr z, +
	cp l
	jr z, _LABEL_5695
	ret

_LABEL_5695:
	ld a, (_RAM_X_POSITION_MINOR)
	cp $14
	ret nc
	ld a, (_RAM_MOVEMENT_STATE)
	or a
	ret nz
	ld hl, (_RAM_WARP_DESTINATION_TOP_LEFT)
	jp ++

+:
	ld a, (_RAM_X_POSITION_MINOR)
	cp $EC
	ret c
	ld a, (_RAM_MOVEMENT_STATE)
	dec a
	ret nz
	ld hl, (_RAM_WARP_DESTINATION_TOP_RIGHT)
++:
	ld a, l
	cp $FF
	jr z, +
	ld c, l
	ld a, (_RAM_Y_POSITION_MINOR)
	cp $78
	jp c, _LABEL_56C3
	ld c, h
_LABEL_56C3:
	ld a, c
	or a
	ret z
	ld a, c
	ld (_RAM_CURRENT_MAP), a
	ld a, Building_Status_Load_Map
	ld (_RAM_BUILDING_STATUS), a
	xor a
	ld (_RAM_C161), a
	ret

+:
	ld a, h
	ld (_RAM_C152), a
	ld a, Building_Status_Boss_Fight
	ld (_RAM_BUILDING_STATUS), a
	xor a
	ld (_RAM_C162), a
	ld (_RAM_C143), a
	ret

_LABEL_56E5:
	ld a, (_RAM_Y_POSITION_MINOR)
	cp $08
	jp c, +
	cp $B8
	jp nc, ++
	ld a, (_RAM_CURRENT_MAP)
	cp $81 ; Dark Suma's Dungeon 3F
	jp z, _LABEL_5740
	cp $7F ; Dark Suma's Dungeon 1F (UL)
	jp z, _LABEL_575F
	cp $7E ; Dark Suma's Dungeon 1F (DL)
	jp z, _LABEL_575F
	cp $83 ; Ra Goan's Dungeon Boss Room
	jp z, _LABEL_577D
	cp $82 ; Ra Goan's Dungeon Entrance
	jp z, _LABEL_577D
	ret

+:
	ld b, $B8
	ld a, (_RAM_WARP_DESTINATION_TOP_RIGHT)
	jp +++

++:
	ld b, $08
	ld a, (_RAM_WARP_DESTINATION_BOTTOM_RIGHT)
+++:
	ld c, a
	or a
	ret z
	ld a, c
	ld (_RAM_CURRENT_MAP), a
	ld a, $01
	ld (_RAM_C161), a
	ld (_RAM_BUILDING_STATUS), a ; Building_Status_Load_Map
	ld a, (_RAM_SCREEN_X_TILE)
	ld (_RAM_C163), a
	ld a, (_RAM_X_POSITION_MINOR)
	ld (_RAM_C164), a
	xor a
	ld (_RAM_X_POSITION_SUB), a
	ld a, b
	ld (_RAM_C165), a
	ret

_LABEL_5740:
	ld c, $8B
	ld a, (_RAM_SCREEN_X_TILE)
	or a
	ret nz
	ld a, (_RAM_FLAG_DARK_SUMA_DEFEATED)
	or a
	ret nz
--:
	ld a, c
	ld (_RAM_C152), a
	ld a, Building_Status_Boss_Fight
	ld (_RAM_BUILDING_STATUS), a
	ld a, $01
	ld (_RAM_C162), a
	xor a
	ld (_RAM_C143), a
	ret

_LABEL_575F:
	ld a, (_RAM_X_POSITION_MINOR)
	cp $14
	ret nc
	ld a, (_RAM_WARP_DESTINATION_TOP_LEFT)
	ld (_RAM_CURRENT_MAP), a
	ld a, Building_Status_Load_Map
	ld (_RAM_BUILDING_STATUS), a
	xor a
	ld (_RAM_C161), a
	ret

-:
	ld a, (_RAM_FLAG_RA_GOAN_DEFEATED)
	or a
	ret nz
	jp --

_LABEL_577D:
	ld c, $8C
	ld a, (_RAM_SCREEN_X_TILE)
	or a
	jr z, -
	cp $40
	ret nz
	ld a, (_RAM_Y_POSITION_MINOR)
	cp $51
	ret nc
	ld a, (_RAM_X_POSITION_MINOR)
	cp $EC
	ret c
	ld a, $74 ; Shagart (Open) (L)
	ld (_RAM_CURRENT_MAP), a
	ld a, Building_Status_Load_Map
	ld (_RAM_BUILDING_STATUS), a
	ld (_RAM_C161), a
	ld a, $18
	ld (_RAM_C163), a
	ld a, $80
	ld (_RAM_C164), a
	ld a, $A8
	ld (_RAM_C165), a
	ret

_LABEL_57B1:
	ld a, (_RAM_CURRENT_MAP)
	cp $74 ; Shagart (Open) (L)
	jr z, +
	cp $75 ; Shagart (Open) (Door)
	jr z, +
	ld a, Building_Status_Building
	ld (_RAM_BUILDING_STATUS), a
	ret

+:
	ld c, $82
	jp _LABEL_56C3

_LABEL_57C7:
	ld a, (_RAM_SCREEN_X_TILE)
	cp $14
	jp c, _LABEL_5695
	ld a, (_RAM_X_POSITION_MINOR)
	cp $98
	jp c, _LABEL_5695
	xor a
	ld (_RAM_C152), a
	ld a, $0C
	jr +

_LABEL_57DF:
	ld c, $1E
	ld a, (_RAM_X_POSITION_MINOR)
	cp $14
	jp c, _LABEL_56C3
	cp $7C
	ret c
	ld a, (_RAM_FLAG_DUELS_DEFEATED)
	or a
	ret nz
	ld a, $06
	ld (_RAM_C152), a
	ld a, $0B
+:
	ld (_RAM_BUILDING_INDEX), a
	ld a, Building_Status_Building
	ld (_RAM_BUILDING_STATUS), a
	xor a
	ld (_RAM_C162), a
	ld (_RAM_C143), a
	ret

_LABEL_5808:
	ld a, (_RAM_C161)
	or a
	ret z
	ld a, (_RAM_C163)
	ld (_RAM_C117), a
	ld a, (_RAM_C164)
	ld (_RAM_X_POSITION_MINOR), a
	ld a, (_RAM_C165)
	ld (_RAM_Y_POSITION_MINOR), a
	ret

_LABEL_5820:
	ld a, (_RAM_CURRENT_MAP)
	ld (_RAM_CONTINUE_MAP), a
	ld c, $7E ; Dark Suma's Dungeon 1F (DL)
	ld a, (_RAM_C118)
	cp $09
	jr z, +
	ld c, $82 ; Ra Goan's Dungeon Entrance
	cp $0A
	jr nz, ++
+:
	ld a, c
	ld (_RAM_CONTINUE_MAP), a
++:
	xor a
	ld (_RAM_BUILDING_INDEX), a
	ld a, (_RAM_C118)
	cp $07
	ret nz
	ld a, (_RAM_CURRENT_MAP)
	sub $5E ; Harfoot (L)
	ld e, a
	ld d, $00
	ld hl, _DATA_5854
	add hl, de
	ld a, (hl)
	ld (_RAM_BUILDING_INDEX), a
	ret

; Data from 5854 to 586D (26 bytes)
_DATA_5854:
.db $01 $01 $04 $04 $02 $02 $02 $02 $02 $02 $03 $03 $03 $05 $05 $05
.db $05 $05 $05 $05 $06 $06 $06 $06 $07 $07

_LABEL_586E:
	ld a, (_RAM_BUILDING_INDEX)
	ld c, a
	ld a, (_RAM_C118)
	cp $07
	jr z, +
	cp $08
	ret nz
	ld c, $09
	ld a, (_RAM_CURRENT_MAP)
	cp $78 ; Castle Elder
	jr z, +
	ld c, $08
+:
	dec c
	ld a, c
	ld (_RAM_SIGN_INDEX), a
	ld a, $05 ; Sign
	ld (_RAM_SIGN_OBJECT_BASE), a
	ld a, :Bank6
	ld (_RAM_FFFF), a
	ld hl, _DATA_1AD9F
	ld de, $4400
	jp _LABEL_1DC8

_LABEL_589F:
	dec c
	ld a, c
	ld (_RAM_SIGN_INDEX), a
	ld a, $05 ; Sign
	ld (_RAM_SIGN_OBJECT_BASE), a
	ld a, :Bank6
	ld (_RAM_FFFF), a
	ld hl, _DATA_1B418
	ld de, $5A00
	jp _LABEL_1DC8

_LABEL_58B7:
	ld a, (_RAM_C16A)
	or a
	jp nz, _LABEL_5935
	ld bc, $0600
	call SendVDPCommand
	ld bc, $8201
	call SendVDPCommand
	ld bc, $0008
	call SendVDPCommand
	ld bc, $FF0A
	call SendVDPCommand
	ld a, :Bank3
	ld (_RAM_FFFF), a
	call _LABEL_C989
	ld a, $01
	ld (_RAM_C16A), a
	xor a
	ld (_RAM_C0A2), a
	ld (_RAM_C109), a
	ld (_RAM_C111), a
	ld iy, _RAM_C400
	call _LABEL_8AC
	ld de, $7800
	ld hl, $2000
	ld bc, $0300
	call _LABEL_331
	ld de, $7F00
	ld a, $D0
	ld (_RAM_C300), a
	call _LABEL_316
	ld a, :Bank14
	ld (_RAM_FFFF), a
	ld hl, _DATA_3ADF1
	ld de, $4400
	call _LABEL_1DC8
	ld hl, _DATA_3AABC
	ld a, $20
	ld de, $78C0
	call _LABEL_1E9A
	ld hl, _DATA_3ADE1
	call _LABEL_3DA
	ld a, $A1
	ld (_RAM_SOUND_TO_PLAY), a
	ld bc, $E201
	jp SendVDPCommand

_LABEL_5935:
	ld a, (_RAM_C0A7)
	or a
	ret nz
	ld a, Building_Status_Load_Map
	ld (_RAM_BUILDING_STATUS), a
	ld (_RAM_C400), a
	ld (_RAM_C161), a
	ld a, (_RAM_SCREEN_X_TILE)
	ld (_RAM_C163), a
	ld a, $80
	ld (_RAM_C164), a
	ld a, $A8
	ld (_RAM_C165), a
	xor a
	ld (_RAM_C16A), a
	ret

_LABEL_595A:
	ld hl, _DATA_5983
	ld b, $09
	ld a, (_RAM_CURRENT_MAP)
-:
	cp (hl)
	jr z, +
	inc hl
	inc hl
	inc hl
	djnz -
	ret

+:
	inc hl
	bit 0, (hl)
	jp nz, +
	ld a, (_RAM_CCA3)
	or a
	ret z
	jr ++

+:
	ld a, (_RAM_CCA4)
	or a
	ret z
++:
	inc hl
	ld a, (hl)
	ld (_RAM_CURRENT_MAP), a
	ret

; Data from 5983 to 599D (27 bytes)
_DATA_5983:
.db $6B $00 $6E $6C $00 $6F $6D $00 $70 $25 $00 $31 $26 $00 $32 $48
.db $01 $4C $49 $01 $4D $72 $01 $74 $73 $01 $75

CheckPirateSpawned:
	ld a, (_RAM_CURRENT_MAP)
	cp $76 ; Lindon (L)
	jr z, +
	cp $77 ; Lindon (R)
	ret nz
+:
	ld a, (_RAM_FLAG_PIRATE_PATH_OPEN)
	or a
	ret z
	ld a, $19 ; Swamp (Lindon +1R) (Pirate +2L) (L)
	ld (_RAM_WARP_DESTINATION_TOP_RIGHT), a
	ld (_RAM_WARP_DESTINATION_BOTTOM_RIGHT), a
	ret

CheckVarlinDoor:
	ld a, (_RAM_CURRENT_MAP)
	ld c, $7C ; Varlin (DL, Open)
	cp $7A ; Varlin (DL, Closed)
	jr z, +
	ld c, $7D ; Varlin (UL, Open)
	cp $7B ; Varlin (UL, Closed)
	ret nz
+:
	ld hl, (_RAM_FLAG_VARLIN_OPEN)
	ld a, h
	or l
	ret z
	ld a, c
	ld (_RAM_CURRENT_MAP), a
	ret

_LABEL_59CF:
	ld a, (_RAM_BOSS_FIGHT_INITIALIZED)
	or a
	jp nz, _LABEL_5C2B
	ld a, $01
	ld (_RAM_BOSS_FIGHT_INITIALIZED), a
	ld bc, $8201
	call SendVDPCommand
	ld bc, $4600
	call SendVDPCommand
	ld de, $7F00
	ld a, $D0
	ld (_RAM_C300), a
	call _LABEL_316
	ld a, :Bank3
	ld (_RAM_FFFF), a
	call _LABEL_C989
	ld a, $86
	ld (_RAM_SOUND_TO_PLAY), a
	ld a, (_RAM_C162)
	or a
	jr nz, +
	ld bc, $0008
	call SendVDPCommand
	ld bc, $FF0A
	call SendVDPCommand
	xor a
	ld (_RAM_C0A2), a
	ld hl, _RAM_C109
	ld de, _RAM_C109 + 1
	ld bc, $001F
	ld (hl), b
	ldir
	ld iy, _RAM_C400
	call _LABEL_8AC
+:
	xor a
	ld hl, _RAM_C440
	ld de, _RAM_C440 + 1
	ld bc, $05BF
	ld (hl), a
	ldir
	ld (_RAM_C154), a
	call +
	call _LABEL_5A9D
	ld bc, $E201
	jp SendVDPCommand

+:
	ld a, (_RAM_C162)
	or a
	ret nz
	ld a, $01
	ld (_RAM_C400), a
	ld a, (_RAM_C152)
	and $7F
	ld l, a
	ld h, $00
	ld e, l
	ld d, h
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, $5E08
	add hl, de
	ld a, (hl)
	ld (_RAM_Y_POSITION_MINOR), a
	inc hl
	ld a, (hl)
	ld (_RAM_X_POSITION_MINOR), a
	inc hl
	ld a, (hl)
	ld (_RAM_C154), a
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld c, (hl)
	inc hl
	ld b, (hl)
	inc hl
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld a, :Bank15
	ld (_RAM_FFFF), a
	push bc
	push de
	call _LABEL_3DA
	pop de
	ex de, hl
	ld de, $6800
	call _LABEL_1DC8
	pop bc
	ld a, :Bank12
	ld (_RAM_FFFF), a
	ld h, b
	ld l, c
	ld de, $7880
	ld a, $20
	jp _LABEL_1E9A

_LABEL_5A9D:
	xor a
	ld (_RAM_C153), a
	ld hl, _DATA_5AAC - 2
	ld a, (_RAM_C152)
	and $7F
	jp CallFunctionFromPointerTable

; Jump Table from 5AAC to 5AC3 (12 entries, indexed by _RAM_C152)
_DATA_5AAC:
.dw _LABEL_5AD0
.dw _LABEL_5ADA
.dw _LABEL_5AFA
.dw _LABEL_5B1C
.dw _LABEL_5B59
.dw _LABEL_5B74
.dw _LABEL_5B8F
.dw _LABEL_5ACF
.dw _LABEL_5ACF
.dw _LABEL_5ACF
.dw _LABEL_5BA8
.dw _LABEL_5BE2

_LABEL_5AC4:
	ld a, $01
	ld (_RAM_C153), a
	ld a, $83
	ld (_RAM_SOUND_TO_PLAY), a
	ret

; 8th entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5ACF:
	ret

; 1st entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5AD0:
	ld a, $83
	ld (_RAM_SOUND_TO_PLAY), a
	ld c, $0A
	jp _LABEL_589F

; 2nd entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5ADA:
	ld c, $0B
	call _LABEL_589F
	ld a, (_RAM_FLAG_TREE_SPIRIT_DEFEATED)
	or a
	jp nz, _LABEL_5AC4
	ld a, (_RAM_FLAG_TREE_SPIRIT_SPAWNED)
	or a
	jp z, _LABEL_5AC4
	ld hl, _DATA_2624D
	ld bc, $0000
	ld a, :Bank9
	ld e, $2B
	jp _LABEL_5BF6

; 3rd entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5AFA:
	ld hl, _RAM_C16B
	ld (hl), $00
	ld a, (_RAM_FLAG_BARUGA_DEFEATED)
	or a
	jp nz, _LABEL_5AC4
	ld a, (_RAM_CCA0)
	or a
	jp z, _LABEL_5AC4
	ld (hl), $01
	ld hl, _DATA_26E3E
	ld bc, $0000
	ld a, :Bank9
	ld e, $37
	jp _LABEL_5BF6

; 4th entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5B1C:
	ld a, (_RAM_FLAG_MEDUSA_DEFEATED)
	or a
	jp nz, _LABEL_5AC4
	ld hl, _DATA_1C000
	ld bc, $0000
	ld a, :Bank7
	ld e, $36
	call _LABEL_5BF6
	ld hl, _DATA_5B54
	ld de, $C018
	ld bc, $0005
	call LoadVDPData
	ld a, $02
	ld (_RAM_C502), a
	ld a, (_RAM_FLAG_MEDUSA_SPAWNED)
	or a
	jp z, _LABEL_5AC4
	ld a, (_RAM_INVENTORY_HERB)
	or a
	jp z, _LABEL_5AC4
	xor a
	ld (_RAM_C502), a
	ret

; Data from 5B54 to 5B58 (5 bytes)
_DATA_5B54:
.db $15 $25 $2A $2F $3F

; 5th entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5B59:
	ld a, (_RAM_FLAG_NECROMANCER_DEFEATED)
	or a
	jp nz, _LABEL_5AC4
	ld a, (_RAM_CCA1)
	or a
	jp z, _LABEL_5AC4
	ld hl, _DATA_1D1AC
	ld bc, $6484
	ld a, :Bank7
	ld e, $2E
	jp _LABEL_5BF6

; 6th entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5B74:
	ld a, (_RAM_FLAG_DUELS_DEFEATED)
	or a
	jp nz, _LABEL_5AC4
	ld a, (_RAM_FLAG_MAYORS_DAUGHTER_RETURNED)
	or a
	jp z, _LABEL_5AC4
	ld hl, _DATA_25AF3
	ld bc, $4E6E
	ld a, :Bank9
	ld e, $3A
	jp _LABEL_5BF6

; 7th entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5B8F:
	ld a, (_RAM_FLAG_PIRATE_DEFEATED)
	or a
	jr nz, +
	ld hl, _DATA_24717
	ld bc, $0000
	ld a, :Bank9
	ld e, $34
	jp _LABEL_5BF6

+:
	ld a, $89
	ld (_RAM_C152), a
	ret

; 11th entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5BA8:
	ld a, (_RAM_FLAG_DARK_SUMA_DEFEATED)
	or a
	jp nz, _LABEL_5AC4
	ld a, (_RAM_CCA3)
	or a
	jp z, _LABEL_5AC4
	ld hl, _DATA_5BDD
	ld de, $C018
	ld bc, $0005
	call LoadVDPData
	ld a, :Bank3
	ld (_RAM_FFFF), a
	ld hl, _DATA_EDAC
	ld de, $5F80
	call _LABEL_1DC8
	ld hl, _DATA_29FDA
	ld bc, $5C7C
	ld a, :Bank10
	ld e, $30
	jp _LABEL_5BF6

; Data from 5BDD to 5BE1 (5 bytes)
_DATA_5BDD:
.db $04 $08 $03 $0C $23

; 12th entry of Jump Table from 5AAC (indexed by _RAM_C152)
_LABEL_5BE2:
	ld a, (_RAM_FLAG_RA_GOAN_DEFEATED)
	or a
	jp nz, _LABEL_5AC4
	ld hl, _DATA_2AF80
	ld bc, $609E
	ld a, :Bank10
	ld e, $42
	jp _LABEL_5BF6

_LABEL_5BF6:
	ld (_RAM_FFFF), a
	ld a, e
	ld (_RAM_C500), a
	push bc
	ld de, $4400
	call _LABEL_1DC8
	pop bc
	ld a, b
	or a
	ret z
	ld hl, $0400
	ld (_RAM_C0B4), hl
	ld l, b
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld (_RAM_C0B6), hl
	ld l, c
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, $4000
	add hl, de
	ld (_RAM_C0B8), hl
	jp _LABEL_1EFB

_LABEL_5C2B:
	ld hl, _DATA_5C36 - 2
	ld a, (_RAM_C152)
	and $7F
	jp CallFunctionFromPointerTable

; Jump Table from 5C36 to 5C4D (12 entries, indexed by _RAM_C152)
_DATA_5C36:
.dw _LABEL_5C4E
.dw _LABEL_5C6F
.dw _LABEL_5C72
.dw _LABEL_5C9B
.dw _LABEL_5C9E
.dw _LABEL_5CA1
.dw _LABEL_5CC5
.dw _LABEL_5D14
.dw _LABEL_5CEE
.dw _LABEL_5D14
.dw _LABEL_5D34
.dw _LABEL_5D37

; 1st entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5C4E:
	ld a, (_RAM_C155)
	or a
	jp nz, _LABEL_5D42
	ld a, (_RAM_CCAD)
	or a
	jp z, _LABEL_5D42
	ld a, (_RAM_X_POSITION_MINOR)
	cp $68
	jp nc, _LABEL_5D42
	ld a, Building_Status_Building
	ld (_RAM_BUILDING_STATUS), a
	ld a, $08
	ld (_RAM_BUILDING_INDEX), a
	ret

; 2nd entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5C6F:
	jp _LABEL_5D3A

; 3rd entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5C72:
	ld a, (_RAM_C16B)
	or a
	jp z, _LABEL_5D42
	ld a, (_RAM_FLAG_BARUGA_DEFEATED)
	or a
	ret z
	ld a, $01
	ld (_RAM_CC1C), a
	ld (_RAM_CC48), a
	ld (_RAM_CC49), a
	ld (_RAM_CC4A), a
	ld (_RAM_CC4B), a
	ld a, (_RAM_INVENTORY_BOOK)
	or a
	jp z, _LABEL_5D42
	ld a, $0A
	jp +

; 4th entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5C9B:
	jp _LABEL_5D3A

; 5th entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5C9E:
	jp _LABEL_5D3A

; 6th entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5CA1:
	ld a, (_RAM_C153)
	or a
	jp nz, _LABEL_5DA6
	ld a, (_RAM_FLAG_DUELS_DEFEATED)
	or a
	ret z
	ld a, $0B
+:
	ld (_RAM_BUILDING_INDEX), a
	xor a
	ld (_RAM_BOSS_FIGHT_INITIALIZED), a
	ld (_RAM_C153), a
	ld (_RAM_C155), a
	ld (_RAM_C140), a
	ld a, Building_Status_Building
	ld (_RAM_BUILDING_STATUS), a
	ret

; 7th entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5CC5:
	ld a, (_RAM_C153)
	or a
	ret z
	ld a, (_RAM_X_POSITION_MINOR)
	cp $E0
	ret c
	ld a, (_RAM_Y_POSITION_MINOR)
	cp $8C
	ret nc
	xor a
	ld (_RAM_BOSS_FIGHT_INITIALIZED), a
	ld (_RAM_C153), a
	ld (_RAM_C155), a
	ld (_RAM_C140), a
	ld a, Building_Status_Building
	ld (_RAM_BUILDING_STATUS), a
	ld a, $09
	ld (_RAM_BUILDING_INDEX), a
	ret

; 9th entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5CEE:
	ld a, $5D
	ld (_RAM_C154), a
	ld a, (_RAM_X_POSITION_MINOR)
	cp $14
	jp c, _LABEL_5D59
	cp $E0
	ret c
	ld a, (_RAM_Y_POSITION_MINOR)
	cp $8C
	ret nc
	ld a, $08
	ld (_RAM_C152), a
	xor a
	ld (_RAM_BOSS_FIGHT_INITIALIZED), a
	ld (_RAM_C153), a
	ld (_RAM_C155), a
	ret

; 8th entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5D14:
	ld a, $1D
	ld (_RAM_C154), a
	ld a, (_RAM_X_POSITION_MINOR)
	cp $EC
	jp nc, _LABEL_5D59
	cp $14
	ret nc
	ld a, $89
	ld (_RAM_C152), a
	xor a
	ld (_RAM_BOSS_FIGHT_INITIALIZED), a
	ld (_RAM_C153), a
	ld (_RAM_C155), a
	ret

; 11th entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5D34:
	jp _LABEL_5D3A

; 12th entry of Jump Table from 5C36 (indexed by _RAM_C152)
_LABEL_5D37:
	jp _LABEL_5D3A

_LABEL_5D3A:
	ld a, (_RAM_C153)
	or a
	jp nz, _LABEL_5D42
	ret

_LABEL_5D42:
	ld a, (_RAM_C152)
	bit 7, a
	jp nz, +
	ld a, (_RAM_X_POSITION_MINOR)
	cp $14
	ret nc
	jp _LABEL_5D59

+:
	ld a, (_RAM_X_POSITION_MINOR)
	cp $EC
	ret c
_LABEL_5D59:
	xor a
	ld (_RAM_BOSS_FIGHT_INITIALIZED), a
	ld (_RAM_C152), a
	ld (_RAM_C153), a
	ld (_RAM_C155), a
	ld a, Building_Status_Load_Map
	ld (_RAM_BUILDING_STATUS), a
	ld a, (_RAM_CURRENT_MAP)
	cp $81 ; Dark Suma's Dungeon 3F
	jr z, +
	cp $83 ; Ra Goan's Dungeon Boss Room
	jr z, ++
	ld a, (_RAM_C154)
	ld (_RAM_CURRENT_MAP), a
	ret

+:
	ld a, $81 ; Dark Suma's Dungeon 3F
	jp +++

++:
	ld a, $83 ; Ra Goan's Dungeon Boss Room
+++:
	ld (_RAM_CURRENT_MAP), a
	ld a, (_RAM_X_POSITION_MINOR)
	ld (_RAM_C164), a
	xor a
	ld (_RAM_X_POSITION_SUB), a
	ld a, (_RAM_Y_POSITION_MINOR)
	ld (_RAM_C165), a
	ld a, $01
	ld (_RAM_C161), a
	xor a
	ld (_RAM_C163), a
	ld a, $84
	ld (_RAM_SOUND_TO_PLAY), a
	ret

_LABEL_5DA6:
	ld bc, $8201
	call SendVDPCommand
	ld a, :Bank3
	ld (_RAM_FFFF), a
	call _LABEL_C9C8
	ld iy, _RAM_C400
	call _LABEL_8AC
	ld a, $01
	ld (_RAM_C400), a
	ld a, $A0
	ld (_RAM_Y_POSITION_MINOR), a
	ld a, $40
	ld (_RAM_X_POSITION_MINOR), a
	ld a, (_RAM_C153)
	ld d, a
	xor a
	ld (_RAM_C153), a
	ld hl, _DATA_1DBAF
	ld bc, $7090
	ld a, $07
	ld e, $2F
	dec d
	jr z, +
	ld hl, _DATA_25328
	ld bc, $4868
	ld a, $09
	ld e, $32
	dec d
	jr z, +
	ld hl, _DATA_294FD
	ld bc, $6C8E
	ld a, $0A
	ld e, $39
	dec d
	jr z, +
	ld hl, _DATA_2A731
	ld bc, $5676
	ld a, :Bank10
	ld e, $33
+:
	call _LABEL_5BF6
	ld a, $86
	ld (_RAM_SOUND_TO_PLAY), a
	ld bc, $E201
	jp SendVDPCommand

; Data from 5E11 to 5E7C (108 bytes)
.db $A8 $C0 $29 $1A $99 $37 $AC $0A $99 $A8 $C0 $27 $1A $99 $E6 $AE
.db $0A $99 $A8 $40 $49 $D8 $92 $89 $A9 $C8 $92 $A8 $C0 $54 $D8 $92
.db $89 $A9 $C8 $92 $98 $C0 $42 $60 $9E $94 $B1 $50 $9E $A0 $40 $79
.db $60 $A6 $E5 $B4 $50 $A6 $B0 $40 $5D $CB $AB $B3 $B6 $BB $AB $B0
.db $40 $1D $CB $AB $C8 $B8 $BB $AB $88 $C0 $5D $CB $AB $B3 $B6 $BB
.db $AB $88 $C0 $1D $CB $AB $C8 $B8 $BB $AB $00 $00 $81 $CB $AB $C8
.db $B8 $BB $AB $00 $00 $83 $CB $AB $C8 $B8 $BB $AB

; 58th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_5E7D:
	ld a, (_RAM_C503)
	or a
	jr nz, +
	ld a, $10
	ld c, $04
	call _LABEL_6417
	call _LABEL_5E92
	ld (iy+32), $80
	ret

_LABEL_5E92:
	xor a
	ld (_RAM_C501), a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ld hl, $A90B
	ld (_RAM_C504), hl
	ld (iy+32), $40
	ld (iy+12), $02
	ld (iy+13), $10
	ld hl, $20D8
	ld de, $18F4
	jp _LABEL_642E

+:
	bit 7, (iy+1)
	jp nz, _LABEL_5FB9
	ld a, (_RAM_C524)
	or a
	jp nz, _LABEL_63B5
	call _LABEL_6384
	ret c
	ld a, (_RAM_C52F)
	or a
	jp nz, _LABEL_6388
	ld a, (_RAM_C501)
	dec a
	jr z, ++
	dec a
	jp z, _LABEL_5F2A
	dec a
	jp z, _LABEL_5F9D
	call _LABEL_84C
	dec (iy+32)
	ret nz
	ld (iy+1), $01
	call _LABEL_6378
	ld hl, $FE00
	ld de, $A90F
	rlc c
	jr nc, +
	ld hl, $0200
	ld de, $AA2F
+:
	ld (_RAM_C513), hl
	ex de, hl
	ld (_RAM_C504), hl
	ld (iy+33), c
	ld (iy+13), $04
	ret

++:
	call _LABEL_84C
	call ApplyObjectXVelocity
	call _LABEL_634B
	ld hl, $D060
	call _LABEL_632F
	ret c
	ld (iy+1), $02
	ld (iy+14), $01
	ld hl, $FA00
	ld (_RAM_C510), hl
	ret

_LABEL_5F2A:
	call ApplyObjectXVelocity
	call _LABEL_634B
	ld de, $0058
	call _LABEL_869
	ld a, (_RAM_C507)
	cp $A0
	ret c
	ld hl, $A000
	ld (_RAM_C506), hl
	ld (iy+1), $03
	inc (iy+object.boss_teleport_timer)
	ld hl, $A961
	ld de, $AA81
	ld bc, $0804
	ld a, (_RAM_C522)
	or a
	jr z, +
	ld hl, $A959
	ld de, $AA79
	ld bc, $0504
	bit 0, a
	jr z, +
	ld hl, $A971
	ld de, $AA91
	ld bc, $0210
+:
	cp $05
	jr c, +
	ld (iy+object.boss_teleport_timer), $FF
+:
	ld (iy+12), b
	ld (iy+13), c
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ld b, $E0
	call _LABEL_6378
	rlc c
	jr nc, +
	ex de, hl
	ld b, $08
+:
	ld (_RAM_C504), hl
	ld (iy+33), c
	ld (iy+35), $40
	ld (iy+24), b
	ret

_LABEL_5F9D:
	call _LABEL_84C
	ld a, (_RAM_C50C)
	cp $08
	jr z, +
	ld a, (_RAM_C50E)
	inc a
	cp (iy+12)
	jp z, _LABEL_5E92
	ret

+:
	dec (iy+35)
	ret nz
	jp _LABEL_5E92

_LABEL_5FB9:
	ld a, (_RAM_C502)
	or a
	jp z, _LABEL_63D7
	call _LABEL_63F2
	ret nc
	ld a, $01
	ld (_RAM_C153), a
	ld c, $10
	call ApplyLandauHealOrDamageFromC
	ld c, $07
	call _LABEL_175F
	jp _LABEL_8AC

; 47th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_5FD6:
	ld a, (_RAM_C503)
	or a
	jr nz, +
	ld a, $10
	ld c, $0A
	call _LABEL_6417
	xor a
	ld (_RAM_C501), a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ld hl, $9A40
	ld (_RAM_C504), hl
	ld hl, $FF80
	ld (_RAM_C513), hl
	ld (iy+12), $04
	ld (iy+13), $0C
	ld hl, $20D8
	ld de, $18F4
	jp _LABEL_642E

+:
	bit 7, (iy+1)
	jp nz, _LABEL_6177
	ld a, (_RAM_C524)
	or a
	jp nz, _LABEL_63B5
	call _LABEL_6384
	ret c
	ld a, (_RAM_C522)
	or a
	jp nz, _LABEL_6162
	ld a, (_RAM_C52F)
	or a
	jp nz, _LABEL_612F
	ld a, (_RAM_C501)
	dec a
	jr z, +
	dec a
	jp z, _LABEL_60A8
	dec a
	jp z, _LABEL_60ED
	call _LABEL_84C
	call ApplyObjectXVelocity
	call _LABEL_634B
	ld hl, $D060
	call _LABEL_632F
	ret c
	ld (iy+1), $01
	ld (iy+14), $01
	ld hl, $FA00
	ld (_RAM_C510), hl
	ld hl, (_RAM_C513)
	add hl, hl
	ld (_RAM_C513), hl
	ret

+:
	call ApplyObjectXVelocity
	call _LABEL_634B
	ld de, $0060
	call _LABEL_869
	ld a, (_RAM_C507)
	cp $A0
	ret c
	ld hl, $A000
	ld (_RAM_C506), hl
	call _LABEL_6378
	ld hl, $9AD7
	ld d, $E8
	rlc c
	jr nc, +
	ld hl, $9C66
	ld d, $00
+:
	ld (_RAM_C504), hl
	ld (iy+24), d
	ld (iy+25), $18
	ld (iy+33), c
	ld (iy+13), $04
	ld (iy+12), $05
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ld (iy+1), $02
	ret

_LABEL_60A8:
	call _LABEL_84C
	ld a, (_RAM_C50E)
	inc a
	cp $05
	ret nz
	call _LABEL_6378
	ld b, $00
	ld hl, $9A40
	ld de, $FF00
	rlc c
	jr c, +
	ld hl, $9BCF
	ld de, $0100
	ld b, $01
+:
	ld (iy+33), b
	ld (_RAM_C504), hl
	ex de, hl
	ld (_RAM_C513), hl
	ld hl, $FC00
	ld (_RAM_C510), hl
	ld (iy+1), $03
	ld (iy+13), $08
	ld (iy+12), $04
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ret

_LABEL_60ED:
	call ApplyObjectXVelocity
	call _LABEL_634B
	ld de, $0020
	call _LABEL_869
	ld a, (_RAM_C507)
	cp $A0
	ret c
	ld hl, $A000
	ld (_RAM_C506), hl
	call _LABEL_6378
	ld hl, $9A40
	ld de, $FF80
	rlc c
	jr nc, +
	ld hl, $9BCF
	ld de, $0080
+:
	ld (_RAM_C504), hl
	ex de, hl
	ld (_RAM_C513), hl
	ld (iy+24), $F4
	ld (iy+25), $18
	ld (iy+33), c
	ld (iy+1), $00
	ret

_LABEL_612F:
	ld (iy+47), $00
	ld a, (_RAM_C501)
	cp $02
	ret z
	ld (iy+object.boss_teleport_timer), $01
	ld a, (_RAM_C50E)
	ld (_RAM_C527), a
	ld (iy+14), $01
	ld (iy+35), $08
	ld hl, (_RAM_C504)
	ld (_RAM_C528), hl
	call _LABEL_6378
	ld hl, $9AD3
	rlc c
	jr nc, +
	ld hl, $9C62
+:
	ld (_RAM_C504), hl
	ret

_LABEL_6162:
	dec (iy+35)
	ret nz
	ld a, (_RAM_C527)
	ld (_RAM_C50E), a
	ld hl, (_RAM_C528)
	ld (_RAM_C504), hl
	ld (iy+object.boss_teleport_timer), $00
	ret

_LABEL_6177:
	ld a, (_RAM_C502)
	or a
	jp z, _LABEL_63D7
	call _LABEL_63F2
	ret nc
	ld a, $02
	ld (_RAM_C153), a
	ld c, $10
	call ApplyLandauHealOrDamageFromC
	ld c, $07
	call _LABEL_175F
	jp _LABEL_8AC

; 50th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_6194:
	ld a, (_RAM_C503)
	or a
	jr nz, +
	ld a, $10
	ld c, $04
	call _LABEL_6417
	ld hl, $9E30
	ld (_RAM_C504), hl
	ld hl, $FF00
	ld (_RAM_C513), hl
_LABEL_61AD:
	xor a
	ld (_RAM_C501), a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ld (iy+12), $02
	ld (iy+13), $0C
	ld hl, $28D0
	ld de, $18F4
	jp _LABEL_642E

-:
	ld a, (_RAM_C501)
	cp $04
	jp z, _LABEL_6388
	jr ++

+:
	bit 7, (iy+1)
	jp nz, _LABEL_6312
	ld a, (_RAM_C524)
	or a
	jp nz, _LABEL_63B5
	call _LABEL_1C8C
	jr c, -
++:
	ld a, (_RAM_C501)
	dec a
	jp z, ++
	dec a
	jp z, _LABEL_6245
	dec a
	jp z, _LABEL_6291
	dec a
	jp z, _LABEL_62C7
	call _LABEL_62D9
	ld hl, $D060
	call _LABEL_632F
	ret c
	ld (iy+1), $01
	ld (iy+14), $00
	ld hl, $FC00
	ld (_RAM_C510), hl
	ld hl, $9E97
	bit 7, (iy+object.x_velocity_minor)
	jr nz, +
	ld hl, $9DC5
+:
	ld (_RAM_C504), hl
	ret

++:
	call ApplyObjectXVelocity
	call _LABEL_634B
	ld de, $0020
	call _LABEL_869
	ld a, (_RAM_C507)
	cp $A0
	jr nc, +
	ld hl, $FC08
	call _LABEL_632F
	ret c
+:
	ld hl, $0000
	ld (_RAM_C510), hl
	ld (iy+1), $02
	ret

_LABEL_6245:
	call ApplyObjectXVelocity
	call _LABEL_634B
	ld de, $0040
	call _LABEL_869
	ld a, (_RAM_C507)
	cp $A0
	ret c
	ld (iy+object.y_position_minor), $A0
	ld (iy+object.y_position_sub), $00
	call _LABEL_6378
	ld hl, $9E99
	ld d, $F0
	rlc c
	jr nc, +
	ld hl, $9DC7
	ld d, $00
+:
	ld (_RAM_C504), hl
	ld (iy+24), d
	ld (iy+25), $10
	ld (iy+33), c
	ld (iy+13), $06
	ld (iy+12), $04
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ld (iy+1), $03
	ret

_LABEL_6291:
	call _LABEL_84C
	ld a, (_RAM_C50E)
	cp $03
	ret nz
	call _LABEL_6378
	ld b, $00
	ld hl, $9E30
	ld de, $FF80
	rlc c
	jr c, +
	ld hl, $9D5E
	ld de, $0080
	ld b, $01
+:
	ld (_RAM_C504), hl
	ex de, hl
	ld (_RAM_C513), hl
	ld (iy+33), c
	call _LABEL_61AD
	ld (iy+1), $04
	ld (iy+object.boss_teleport_timer), $40
	ret

_LABEL_62C7:
	dec (iy+object.boss_teleport_timer)
	jr nz, _LABEL_62D9
	call _LABEL_61AD
	bit 7, (iy+object.x_velocity_minor)
	jp nz, +
	jp +++

_LABEL_62D9:
	call ApplyObjectXVelocity
	call _LABEL_84C
	ld a, (_RAM_C50A)
	bit 7, (iy+object.x_velocity_minor)
	jr z, ++
	cp $10
	ret nc
+:
	ld hl, $9D5E
	ld de, $0100
	ld bc, $1001
	jp ++++

++:
	cp $F0
	ret c
+++:
	ld hl, $9E30
	ld de, $FF00
	ld bc, $F000
++++:
	ld (_RAM_C504), hl
	ld (iy+9), $00
	ld (iy+33), c
	ex de, hl
	ld (_RAM_C513), hl
	ret

_LABEL_6312:
	ld a, (_RAM_C502)
	or a
	jp z, _LABEL_63D7
	call _LABEL_63F2
	ret nc
	ld a, $03
	ld (_RAM_C153), a
	ld c, $10
	call ApplyLandauHealOrDamageFromC
	ld c, $07
	call _LABEL_175F
	jp _LABEL_8AC

_LABEL_632F:
	ld a, (_RAM_C50A)
	add a, h
	cp $E8
	jr c, +
	xor a
+:
	ld h, a
	add a, l
	jr nc, +
	ld a, $FF
+:
	ld l, a
	ld a, (_RAM_X_POSITION_MINOR)
	cp h
	ret c
	cp l
	jr c, +
	scf
	ret

+:
	xor a
	ret

_LABEL_634B:
	ld a, (_RAM_C50A)
	bit 7, (iy+object.x_velocity_minor)
	jr z, +
	cp $10
	ret nc
	ld (iy+object.x_position_minor), $10
	ld (iy+9), $00
	ld (iy+33), $01
	jp _LABEL_24E0

+:
	cp $F0
	ret c
	ld (iy+object.x_position_minor), $F0
	ld (iy+9), $00
	ld (iy+33), $00
	jp _LABEL_24E0

_LABEL_6378:
	ld c, $00
	ld a, (_RAM_X_POSITION_MINOR)
	cp (iy+object.x_position_minor)
	ret c
	ld c, $FF
	ret

_LABEL_6384:
	call _LABEL_1C8C
	ret nc
_LABEL_6388:
	call _LABEL_6378
	ld b, $00
	ld de, $FC00
	rlc c
	jr c, +
	ld de, $0400
	ld b, $01
+:
	ld hl, (_RAM_C513)
	ld (_RAM_C525), hl
	ex de, hl
	ld (_RAM_C513), hl
	ld (iy+object.boss_flash_timer), $01
	ld (iy+33), b
	ld (iy+53), $08
	ld a, $A3
	ld (_RAM_SOUND_TO_PLAY), a
	scf
	ret

_LABEL_63B5:
	call ApplyObjectXVelocity
	call _LABEL_634B
	dec (iy+53)
	ret nz
	ld (iy+object.boss_flash_timer), $00
	ld hl, (_RAM_C525)
	ld (_RAM_C513), hl
	call _LABEL_5268
	ret nc
	ld a, $A5
	ld (_RAM_SOUND_TO_PLAY), a
	ld (iy+1), $FF
	ret

_LABEL_63D7:
	ld (iy+2), $01
	ld (iy+14), $00
	ld (iy+12), $00
	ld (iy+15), $02
	ld (iy+13), $60
	ld hl, (_RAM_C504)
	ld (_RAM_C520), hl
	ret

_LABEL_63F2:
	dec (iy+13)
	jr z, +++
	dec (iy+15)
	jr nz, ++
	ld (iy+15), $02
	ld hl, $6436
	ld a, (_RAM_C50C)
	cpl
	ld (_RAM_C50C), a
	or a
	jr z, +
	ld hl, (_RAM_C520)
+:
	ld (_RAM_C504), hl
++:
	xor a
	ret

+++:
	scf
	ret

_LABEL_6417:
	ld (_RAM_BOSS_HP), a
	ld (iy+56), c
	ld (iy+3), $01
	ld (iy+object.y_position_minor), $A0
	ld (iy+object.x_position_minor), $D0
	ld (iy+2), $00
	ret

_LABEL_642E:
	ld (_RAM_C516), hl
	ex de, hl
	ld (_RAM_C518), hl
	ret

; Data from 6436 to 643C (7 bytes)
.db $38 $64 $01 $F0 $FC $FF $00

; 57th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_643D:
	ld a, (_RAM_C503)
	or a
	jr nz, +
	ld a, $10
	ld c, $04
	call _LABEL_6417
	ld hl, $A720
	ld (_RAM_C504), hl
	ld hl, $20E0
	ld de, $18F4
	call _LABEL_642E
_LABEL_6459:
	ld (iy+12), $02
	ld (iy+13), $08
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ld (_RAM_C501), a
	ret

+:
	bit 7, (iy+1)
	jp nz, _LABEL_65F5
	ld a, (_RAM_C524)
	or a
	jp nz, _LABEL_6543
	ld a, (_RAM_C501)
	dec a
	jp z, _LABEL_64E2
	dec a
	jp z, _LABEL_65C4
	call _LABEL_6384
	ret c
	ld a, (_RAM_C52F)
	or a
	jp nz, _LABEL_6388
	call _LABEL_65E4
	call ApplyObjectXVelocity
	call _LABEL_84C
	ld a, (_RAM_C50A)
	ld bc, $18FF
	cp b
	jr c, +
	ld bc, $E800
	cp b
	ret c
+:
	ld (iy+object.x_position_minor), b
	ld (iy+9), $00
	ld (iy+32), c
	ld (iy+1), $01
	ld hl, $A8AC
	ld de, $FF80
	rlc c
	jr nc, +
	ld hl, $A7B3
	ld de, $0080
+:
	ld (_RAM_C504), hl
	ex de, hl
	ld (_RAM_C513), hl
	ld hl, $FE00
	ld (_RAM_C510), hl
	ld (iy+12), $04
	ld (iy+13), $06
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ret

_LABEL_64E2:
	ld de, $0018
	ld a, (_RAM_C50E)
	cp $02
	call nc, _LABEL_869
	ld a, (_RAM_C50E)
	cp $02
	call nc, ApplyObjectXVelocity
	ld a, (_RAM_C50E)
	cp $03
	jr nc, ++
	call _LABEL_84C
	ld a, (_RAM_C50E)
	cp $03
	jr z, +
	cp $02
	ret nz
	ld (iy+13), $0A
	ret

+:
	ld a, (_RAM_C507)
	add a, $E8
	ld (_RAM_C507), a
	ld a, $C8
	bit 7, (iy+object.x_velocity_minor)
	jr nz, +
	ld a, $38
+:
	add a, (iy+object.x_position_minor)
	ld (_RAM_C50A), a
	ret

++:
	ld a, (_RAM_C507)
	cp $A0
	ret c
	ld (iy+object.y_position_minor), $A0
_LABEL_6531:
	ld hl, $A720
	bit 7, (iy+32)
	jr z, +
	ld hl, $A819
+:
	ld (_RAM_C504), hl
	jp _LABEL_6459

_LABEL_6543:
	call ApplyObjectXVelocity
	call _LABEL_634B
	dec (iy+53)
	ret nz
	ld (iy+object.boss_flash_timer), $00
	call _LABEL_5268
	jr nc, +
	ld a, $A5
	ld (_RAM_SOUND_TO_PLAY), a
	ld (iy+1), $FF
	ret

+:
	call _LABEL_6378
	ld de, $FC00
	ld hl, $A75E
	rlc c
	jr nc, +
	ld de, $0400
	ld hl, $A857
+:
	ld (_RAM_C504), hl
	ld (iy+12), $04
	ld (iy+13), $10
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ld (_RAM_C513), a
	ld (_RAM_C514), a
	ld (iy+1), $02
	ld (iy+47), $00
	ex de, hl
	ld (_RAM_C553), hl
	ld hl, $A812
	ld (_RAM_C544), hl
	ld a, (_RAM_C50A)
	ld (_RAM_C54A), a
	ld a, (_RAM_C507)
	add a, $EC
	ld (_RAM_C547), a
	ld ix, _RAM_C540
	ld (ix+22), $F4
	ld (ix+23), $08
	ld (ix+24), $FC
	ld (ix+25), $08
	ld (ix+56), $04
	ret

_LABEL_65C4:
	call _LABEL_84C
	ld a, (_RAM_C50E)
	cp $02
	jr z, +
	cp $03
	ret c
	jp _LABEL_6531

+:
	ld a, (_RAM_C540)
	or a
	ret nz
	ld a, $3C
	ld (_RAM_C540), a
	ld a, $01
	ld (_RAM_C543), a
	ret

_LABEL_65E4:
	ld hl, $FE00
	bit 7, (iy+32)
	jp z, +
	ld hl, $0200
+:
	ld (_RAM_C513), hl
	ret

_LABEL_65F5:
	ld a, (_RAM_C502)
	or a
	jp z, _LABEL_63D7
	call _LABEL_63F2
	ret nc
	ld a, $04
	ld (_RAM_C153), a
	ld c, $10
	call ApplyLandauHealOrDamageFromC
	ld c, $07
	call _LABEL_175F
	jp _LABEL_8AC

; 60th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_6612:
	ld a, (iy+object.y_velocity_minor)
	or a
	call nz, +
	call ApplyObjectXVelocity
	call _LABEL_1C8C
	ld a, (iy+object.x_position_major)
	or a
	jp nz, _LABEL_8AC
	ld a, (iy+object.y_position_minor)
	cp $C0
	jp nc, _LABEL_8AC
	ret

+:
	call ApplyObjectYVelocity
	ld a, (iy+14)
	cp $02
	jp c, _LABEL_84C
	ret

; 51st entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_663B:
	ld a, (_RAM_C503)
	or a
	jr nz, +
	ld a, $0A
	ld c, $04
	call _LABEL_6417
	ld hl, $FE80
	ld (_RAM_C513), hl
	ld (iy+22), $DC
	ld (iy+23), $20
	ld de, $F810
	ld bc, $0406
	ld hl, $A105
	xor a
_LABEL_6660:
	ld (_RAM_C504), hl
	ld (iy+24), d
	ld (iy+25), e
	ld (_RAM_C501), a
	ld (iy+12), b
	ld (iy+13), c
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ret

+:
	bit 7, (iy+1)
	jp nz, _LABEL_674A
	ld a, (_RAM_C524)
	or a
	jp nz, _LABEL_676B
	ld a, (_RAM_C501)
	dec a
	jp z, _LABEL_66EE
	call _LABEL_84C
	call ApplyObjectXVelocity
	call _LABEL_671A
	ld a, (_RAM_Y_POSITION_MINOR)
	cp $9C
	jp c, _LABEL_6384
	ld a, (_RAM_C522)
	or a
	ret nz
	call _LABEL_1C8C
	ld a, (_RAM_C50A)
	cp $40
	ret c
	cp $C0
	ret nc
	ld hl, $0018
	ld d, $00
	bit 0, (iy+32)
	jp nz, +
	ld hl, $E818
	ld d, $E8
+:
	call _LABEL_632F
	ret c
	ld e, $18
	ld bc, $0408
	push de
	ld hl, $A1F1
	ld de, $A1F7
	bit 0, (iy+32)
	jr z, +
	ld hl, $A3DD
	ld de, $A3E3
+:
	ld a, r
	bit 0, a
	jr z, +
	ex de, hl
+:
	pop de
	ld a, $01
	ld (_RAM_C522), a
	jp _LABEL_6660

_LABEL_66EE:
	call _LABEL_1C8C
	call _LABEL_84C
	ld a, (_RAM_C50E)
	cp $03
	ret c
_LABEL_66FA:
	ld de, $A105
	ld hl, $FE80
	bit 0, (iy+32)
	jr z, +
	ld de, $A2F1
	ld hl, $0180
+:
	ld (_RAM_C513), hl
	ex de, hl
	ld de, $F810
	ld bc, $0406
	xor a
	jp _LABEL_6660

_LABEL_671A:
	ld a, (_RAM_C50A)
	bit 0, (iy+32)
	jr nz, +
	cp $10
	ret nc
	ld hl, $A2F1
	ld c, $FF
	ld de, $0180
	jr ++

+:
	cp $F0
	ret c
	ld hl, $A105
	ld c, $00
	ld de, $FE80
++:
	ld (_RAM_C504), hl
	ex de, hl
	ld (_RAM_C513), hl
	ld (iy+32), c
	ld (iy+object.boss_teleport_timer), $00
	ret

_LABEL_674A:
	ld a, (_RAM_C502)
	or a
	jp z, _LABEL_63D7
	call _LABEL_63F2
	ret nc
	xor a
	ld (_RAM_C153), a
	ld a, $01
	ld (_RAM_FLAG_DUELS_DEFEATED), a
	ld c, $10
	call ApplyLandauHealOrDamageFromC
	ld c, $07
	call _LABEL_175F
	jp _LABEL_8AC

_LABEL_676B:
	call _LABEL_63B5
	ld a, (_RAM_C524)
	or a
	ret nz
	ld a, (_RAM_C501)
	or a
	ret nz
	ld a, r
	and $03
	ret z
	ld a, (_RAM_C520)
	cpl
	ld (_RAM_C520), a
	jp _LABEL_66FA

; 54th entry of Jump Table from 6E4 (indexed by _RAM_C400)
_LABEL_6787:
	ld a, (_RAM_C503)
	or a
	jr nz, _LABEL_67F5
	xor a
	ld (_RAM_C175), a
	ld (iy+object.boss_teleport_timer), $01
	ld (iy+35), $03
	ld (iy+object.boss_flash_timer), $20
	ld (iy+object.boss_hp), $64
	ld (iy+56), $04
	ld (iy+3), $01
	ld (iy+object.y_position_minor), $A8
	ld (iy+object.x_position_minor), $30
	ld hl, $30D0
	ld de, $18F4
	call _LABEL_642E
	ld hl, $0000
	ld (_RAM_C510), hl
	ld hl, $FFFC
	ld (_RAM_C530), hl
	ld (iy+50), $40
	ld (iy+51), $80
	ld hl, $0010
	ld (_RAM_C528), hl
	ld hl, $0080
	ld (_RAM_C52A), hl
_LABEL_67DA:
	ld hl, $AB4F
	ld de, $0408
	xor a
_LABEL_67E1:
	ld (_RAM_C504), hl
	ld (iy+12), d
	ld (iy+13), e
	ld (_RAM_C501), a
	xor a
	ld (_RAM_C50E), a
	ld (_RAM_C50F), a
	ret

_LABEL_67F5:
	ld a, (_RAM_C502)
	cp $02
	ret z
	ld a, (_RAM_C522)
	or a
	ret nz
	bit 7, (iy+1)
	jp nz, _LABEL_69B2
	ld a, (_RAM_C520)
	or a
	jp nz, _LABEL_698C
	ld a, (_RAM_C52F)
	or a
	jp nz, _LABEL_6960
	call _LABEL_695C
	ret c
	ld a, (_RAM_C501)
	dec a
	jp z, _LABEL_687E
	dec a
	jp z, _LABEL_6893
	dec a
	jp z, _LABEL_68E7
	call _LABEL_880
	call _LABEL_6947
	ld hl, (_RAM_C52A)
	ld a, h
	or l
	jr z, ++
	ld hl, (_RAM_C52A)
	dec hl
	ld (_RAM_C52A), hl
	ld hl, (_RAM_C528)
	ld a, h
	or l
	jr z, +
	ld hl, (_RAM_C528)
	dec hl
	ld (_RAM_C528), hl
	ret

+:
	ld a, (_RAM_C507)
	cp $A4
	ret c
	ld hl, $AB4F
	ld de, $0408
	ld a, $01
	call _LABEL_67E1
	ld hl, $0100
	ld (_RAM_C513), hl
	ld (iy+44), $20
	ld hl, $00D8
	ld (_RAM_C528), hl
	ret

++:
	ld hl, $00A0
	ld (_RAM_C52A), hl
	ld hl, $AD22
	ld de, $0310
	ld a, $03
	jp _LABEL_67E1

_LABEL_687E:
	call ApplyObjectXVelocity
	call _LABEL_84C
	dec (iy+44)
	ret nz
	ld hl, $AC0A
	ld de, $0510
	ld a, $02
	jp _LABEL_67E1

_LABEL_6893:
	call _LABEL_84C
	ld a, (_RAM_C50E)
	cp $03
	jr z, +
	cp $04
	ret nz
	jp _LABEL_67DA

+:
	ld a, (_RAM_C540)
	or a
	ret nz
	ld a, $3C
	ld (_RAM_C540), a
	ld a, $01
	ld (_RAM_C543), a
	ld hl, $0400
	ld (_RAM_C553), hl
	ld hl, $ADD9
	ld (_RAM_C544), hl
	ld a, (_RAM_C50A)
	add a, $10
	ld (_RAM_C54A), a
	ld a, (_RAM_C507)
	add a, $E8
	ld (_RAM_C547), a
	ld ix, _RAM_C540
	ld (ix+22), $F8
	ld (ix+23), $08
	ld (ix+24), $FC
	ld (ix+25), $08
	ld (ix+56), $03
	ret

_LABEL_68E7:
	call _LABEL_84C
	ld a, (_RAM_C50E)
	dec a
	jr z, +
	dec a
	ret nz
	jp _LABEL_67DA

+:
	ld a, (_RAM_C580)
	or a
	ret nz
	ld a, $3C
	ld (_RAM_C580), a
	ld a, $01
	ld (_RAM_C583), a
	ld hl, $ADA0
	ld (_RAM_C584), hl
	ld a, (_RAM_C50A)
	add a, $10
	ld (_RAM_C58A), a
	ld a, (_RAM_C507)
	add a, $D8
	ld (_RAM_C587), a
	ld ix, _RAM_C580
	ld (ix+22), $F0
	ld (ix+23), $08
	ld (ix+24), $E8
	ld (ix+25), $10
	ld hl, $0400
	ld (_RAM_C593), hl
	ld hl, $0200
	ld (_RAM_C590), hl
	ld (ix+12), $04
	ld (ix+13), $08
	ld (ix+56), $06
	ret

_LABEL_6947:
	ld a, (_RAM_C50A)
	cp $30
	ret z
	ld hl, $FF80
	jp nc, +
	ld hl, $0080
+:
	ld (_RAM_C513), hl
	jp ApplyObjectXVelocity

_LABEL_695C:
	call _LABEL_1C8C
	ret nc
_LABEL_6960:
	ld (iy+47), $00
	ld hl, $FC00
	ld (_RAM_C513), hl
	ld (iy+32), $01
	ld (iy+33), $08
	ld a, $A3
	ld (_RAM_SOUND_TO_PLAY), a
	call _LABEL_5268
	jr nc, +
	ld a, $A5
	ld (_RAM_SOUND_TO_PLAY), a
	ld (iy+1), $FF
	ld c, $10
	call ApplyLandauHealOrDamageFromC
+:
	scf
	ret

_LABEL_698C:
	call ApplyObjectXVelocity
	dec (iy+33)
	jr z, +
	ld a, (_RAM_C50A)
	cp $10
	ret nc
	ld hl, $1000
	ld (_RAM_C509), hl
+:
	xor a
	ld (_RAM_C520), a
	ld (_RAM_C521), a
	ld (iy+44), $01
	ld hl, $0000
	ld (_RAM_C513), hl
	ret

_LABEL_69B2:
	ld a, (_RAM_C502)
	or a
	jp z, _LABEL_63D7
	call _LABEL_63F2
	ret nc
	ld a, $01
	ld (_RAM_C153), a
	ld (_RAM_FLAG_MEDUSA_DEFEATED), a
	ld (_RAM_FLAG_VARLIN_OPEN), a
	ld c, $0A
	call _LABEL_175F
	xor a
	ld (_RAM_INVENTORY_HERB), a
	jp _LABEL_8AC

_LABEL_69D4:
	ld a, (_RAM_C500)
	cp $36
	ret nz
	ld a, (_RAM_C502)
	or a
	ret nz
	ld a, (_RAM_C522)
	or a
	ret z
	ld a, (_RAM_C175)
	or a
	jr nz, +
	ld a, (_RAM_X_POSITION_MINOR)
	cp $80
	ret nc
	ld a, $01
	ld (_RAM_C175), a
	ld a, $93
	ld (_RAM_SOUND_TO_PLAY), a
	ld a, :Bank3
	ld (_RAM_FFFF), a
	ld hl, _DATA_EF22
	ld de, $7838
	ld a, $02
	jp _LABEL_1E9A

+:
	ld hl, _RAM_C524
	dec (hl)
	ret nz
	ld (hl), $20
	ld a, (_RAM_C523)
	ld c, a
	add a, a
	add a, a
	add a, c
	ld e, a
	ld d, $00
	ld hl, $6A33
	add hl, de
	ld de, $C018
	ld bc, $0005
	call LoadVDPData
	ld hl, _RAM_C523
	dec (hl)
	ret nz
	xor a
	ld (_RAM_C522), a
	ld (_RAM_C523), a
	ld (_RAM_C524), a
	ret

; Data from 6A38 to 6A46 (15 bytes)
.db $01 $02 $03 $07 $0F $11 $12 $13 $17 $1F $21 $22 $23 $27 $2F

_LABEL_6A47:
	call +
	jp _LABEL_8AC

+:
	ld a, (iy+object.type)
	cp $2B ; Tree Spirit
	jr z, ++
	cp $37 ; Baruga
	jr z, +++
	cp $2E ; Necromancer
	jr z, ++++
	cp $34 ; Pirate
	jr z, _LABEL_6A9E
	cp $30 ; Dark Suma
	jr z, _LABEL_6AA5
	cp $42 ; Ra Goan
	jr z, +
	ret

+:
	ld a, $01
	ld (_RAM_CC1E), a
	ld hl, _RAM_FLAG_RA_GOAN_DEFEATED
	ld c, $0B
	call _LABEL_6AC2
	jp _LABEL_6B01

++:
	ld a, $01
	ld (_RAM_CC14), a
	ld (_RAM_C16D), a
	ld (_RAM_INVENTORY_TREE_LIMB), a
	ld hl, _RAM_FLAG_TREE_SPIRIT_DEFEATED
	ld c, $04
	jr _LABEL_6AC2

+++:
	ld hl, _RAM_FLAG_BARUGA_DEFEATED
	ld c, $09
	jr _LABEL_6AC2

++++:
	ld a, $01
	ld (_RAM_CC15), a
	ld hl, _RAM_FLAG_NECROMANCER_DEFEATED
	ld c, $05
	jr _LABEL_6AC2

_LABEL_6A9E:
	ld hl, _RAM_FLAG_PIRATE_DEFEATED
	ld c, $06
	jr _LABEL_6AC2

_LABEL_6AA5:
	ld a, (_RAM_C507)
	add a, $E0
	ld (_RAM_C487), a
	ld a, (_RAM_C50A)
	ld (_RAM_C48A), a
	ld a, $03
	ld (_RAM_C480), a
	ld a, $01
	ld (_RAM_CC18), a
	ld hl, _RAM_FLAG_DARK_SUMA_DEFEATED
	ld c, $08
_LABEL_6AC2:
	ld a, $01
	ld (hl), a
	ld (_RAM_C153), a
	call _LABEL_175F
	ld c, $10
	call ApplyLandauHealOrDamageFromC
	ld ix, _RAM_C540
	call _LABEL_8A6
	ld ix, _RAM_C580
	call _LABEL_8A6
	ld ix, _RAM_C5C0
	call _LABEL_8A6
	ld ix, _RAM_C600
	call _LABEL_8A6
	ld ix, _RAM_C640
	call _LABEL_8A6
	ld ix, _RAM_C680
	call _LABEL_8A6
	ld ix, _RAM_C6C0
	jp _LABEL_8A6

_LABEL_6B01:
	ld hl, _RAM_FLAG_GAME_STARTED
	ld c, $09
	ld a, $01
--:
	ld b, $0D
-:
	ld (hl), $01
	inc hl
	djnz -
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, --
	ld a, $01
	ld (_RAM_FLAG_TREE_SPIRIT_DEFEATED), a
	ld (_RAM_FLAG_BARUGA_DEFEATED), a
	ld (_RAM_FLAG_MEDUSA_DEFEATED), a
	ld (_RAM_FLAG_NECROMANCER_DEFEATED), a
	ld (_RAM_FLAG_DUELS_DEFEATED), a
	ld (_RAM_FLAG_PIRATE_DEFEATED), a
	ld (_RAM_FLAG_DARK_SUMA_DEFEATED), a
	ld (_RAM_FLAG_RA_GOAN_DEFEATED), a
	ld (_RAM_CCA0), a
	ld (_RAM_CCA1), a
	ld (_RAM_FLAG_PIRATE_PATH_OPEN), a
	ld (_RAM_CCA3), a
	ld (_RAM_CCA4), a
	ret

; 7th entry of Jump Table from 114 (indexed by _RAM_MAP_STATUS)
Handle_Map_Status_Story:
	call +
	jp _LABEL_F7

+:
	ld a, (_RAM_C171)
	or a
	jp nz, _LABEL_6C0B
	ld bc, $8201
	call SendVDPCommand
	ld a, $01
	ld (_RAM_C171), a
	ld hl, $0C00
	ld (_RAM_C173), hl
	ld a, (_RAM_C172)
	or a
	jp nz, _LABEL_6BDA
	ld a, $01
	ld (_RAM_C172), a
	ld a, $82
	ld (_RAM_SOUND_TO_PLAY), a
	ld a, :Bank6
	ld (_RAM_FFFF), a
	ld hl, _DATA_COMPRESSED_FONT_TILES_
	ld de, $4400
	call _LABEL_1E25
	ld a, :Bank15
	ld (_RAM_FFFF), a
	ld hl, _DATA_3FF8F
	ld de, $53E0
	call _LABEL_1DC8
	ld hl, _DATA_3F49C
	ld de, $6000
	call _LABEL_1DC8
	ld hl, _DATA_3FC2D
	ld de, $7800
	ld a, $20
	call _LABEL_1E9A
	ld a, :Bank5
	ld (_RAM_FFFF), a
	ld hl, _DATA_16A89
	ld de, $78CA
	ld a, $18
	call _LABEL_1E9A
	ld hl, _DATA_6BBA
	call _LABEL_3D1
	ld bc, $E201
	jp SendVDPCommand

; Data from 6BBA to 6BD9 (32 bytes)
_DATA_6BBA:
.db $2F $1A $05 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

_LABEL_6BDA:
	ld a, $02
	ld (_RAM_C172), a
	ld a, :Bank5
	ld (_RAM_FFFF), a
	ld hl, _DATA_16C23
	ld de, $78CA
	ld a, $18
	call _LABEL_1E9A
	ld hl, _DATA_16CC3
	ld de, $794A
	ld a, $18
	call _LABEL_1E9A
	ld hl, _DATA_16C48
	ld de, $7C0A
	ld a, $18
	call _LABEL_1E9A
	ld bc, $E201
	jp SendVDPCommand

_LABEL_6C0B:
	ld a, (_RAM_NEW_CONTROLLER_INPUT)
	and Button_1_Mask|Button_2_Mask
	jp nz, +
	ld hl, (_RAM_C173)
	dec hl
	ld (_RAM_C173), hl
	ld a, l
	or h
	ret nz
+:
	ld a, (_RAM_C172)
	cp $02
	jr z, +
	xor a
	ld (_RAM_C171), a
	ret

+:
	ld a, Map_Status_Start_Game
	ld (_RAM_MAP_STATUS), a
	ret

; 5th entry of Jump Table from 114 (indexed by _RAM_MAP_STATUS)
Handle_Map_Status_Demo:
	ld a, (_RAM_C17A)
	or a
	jp nz, _LABEL_6C7B
	ld bc, $8201
	call SendVDPCommand
	ld a, $01
	ld (_RAM_C17A), a
	call _LABEL_3C2
	ld de, $4000
	ld bc, $0040
	ld h, $00
	call _LABEL_321
	ld a, $30
	ld (_RAM_HEALTH), a
	ld a, $01
	ld (_RAM_C12A), a
	call _LABEL_9DC
	ld hl, _PALETTE_9BC
	call _LABEL_3D1
	ld a, Building_Status_Load_Map
	ld (_RAM_BUILDING_STATUS), a
	ld hl, $0480
	ld (_RAM_C17E), hl
	ld a, $07 ; Swamp (Harfoot +1R) (Amon +2L) (L) (Demo)
	ld (_RAM_CURRENT_MAP), a
	ld bc, $E201
	call SendVDPCommand
	jp _LABEL_F7

_LABEL_6C7B:
	in a, (Port_IOPort1)
	cpl
	and Button_1_Mask|Button_2_Mask
	jr nz, +
	ld hl, (_RAM_C17E)
	dec hl
	ld (_RAM_C17E), hl
	ld a, h
	or l
	jp nz, Handle_Map_Status_Map
+:
	xor a
	ld (_RAM_MAP_STATUS), a
	jp _LABEL_F7

; Data from 6C95 to 6E94 (512 bytes)
_DATA_6C95:
.db $00 $00 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $FF
.db $FB $DB $DB $DB $DB $DB $DB $FB $FB $FF $FF $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $FF $FF $FB $FB $FB $DB $DB $DB $DB $DB $DB $DB $DB $DB
.db $FB $DB $DB $DB $FB $FB $FB $FB $FB $FB $FB $FF $FF $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $FF $FF $FF $FF $FF $FF $FF $FF
.db $FF $DF $DF $DF $DF $FF $FF $FF $FF $FF $FF $FF $FF $F7 $F7 $F7
.db $F7 $F7 $E7 $E7 $E7 $E7 $E7 $E7 $E7 $E7 $E7 $E7 $E7 $E7 $E7 $E7
.db $E7 $E7 $E7 $E7 $EF $EF $EB $EB $EB $EB $EB $EB $EB $EB $EB $EB
.db $EB $FB $FB $FB $FB $FB $FB $FB $FF $FF $FF $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7
.db $FF $FF $FF $FF $FF $FF $FF $F7 $F7 $F7 $FF $FF $FF $FF $FF $FF
.db $DF $DF $FF $FF $FF $DF $DF $DF $DF $DF $FF $FF $FF $FF $FF $FF
.db $FF $FF $FE $FE $FE $F6 $F6 $F6 $F6 $F6 $F7 $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $FF $FF $FF $FF
.db $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $DF $DF $DF
.db $DF $DF $DF $DF $DF $FF $FF $FF $FF $FF $FF $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $FF $FF $FF $FF $FF $F7 $F6 $F6 $F6 $F6 $F6 $F6 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F6 $F6 $F6
.db $F6 $F6 $F6 $F6 $F6 $F6 $F6 $F6 $F6 $F6 $F6 $F6 $F6 $F6 $F6 $F6
.db $F6 $F6 $F6 $F6 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $FB $DB $DB $DB
.db $DB $DB $DB $DB $DB $DB $DB $DB $DB $FB $FB $FB $FB $FB $FB $FB
.db $FB $FB $FB $FB $FB $FB $EB $EB $EB $EB $EB $EB $EB $EB $EB $EB
.db $EB $EB $EB $EB $EB $EB $EB $EB $EB $EB $FB $FB $FB $FB $FB $FB
.db $FB $FB $FB $FB $FB $FB $FB $FB $FB $FB $FB $FF $FF $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7
.db $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7 $F7

_LABEL_6E95:
	ld a, (_RAM_C180)
	or a
	jp nz, _LABEL_6F08
	ld bc, $8201
	call SendVDPCommand
	ld a, $01
	ld (_RAM_C180), a
	ld a, $88
	ld (_RAM_SOUND_TO_PLAY), a
	ld a, :Bank15
	ld (_RAM_FFFF), a
	ld hl, _DATA_3F49C
	ld de, $53E0
	call _LABEL_1DC8
	ld a, :Bank11
	ld (_RAM_FFFF), a
	ld hl, _DATA_2FA57
	ld de, $7800
	ld a, $20
	call _LABEL_1E9A
	ld a, :Bank6
	ld (_RAM_FFFF), a
	ld hl, _DATA_COMPRESSED_FONT_TILES_
	ld de, $4400
	call _LABEL_1E25
	ld a, :Bank11
	ld (_RAM_FFFF), a
	ld hl, _DATA_2F83D
	ld de, $4000
	call _LABEL_1DC8
	ld hl, _DATA_2F964
	ld de, $78CC
	ld a, $14
	call _LABEL_1E9A
	ld hl, _DATA_2F9D6
	ld de, $7A8C
	ld a, $14
	call _LABEL_1E9A
	ld hl, _DATA_70B3
	call _LABEL_3DA
	ld bc, $E201
	jp SendVDPCommand

_LABEL_6F08:
	ld a, (_RAM_C181)
	or a
	jp nz, _LABEL_700F
	ld a, $01
	ld (_RAM_C181), a
	ld a, (_RAM_C184)
	or a
	jp z, +
	ld bc, $8001
	call SendVDPCommand
	ld a, :Bank11
	ld (_RAM_FFFF), a
	ld hl, _DATA_70D3
	ld de, $7C4C
	ld a, $14
	call _LABEL_1E9A
	ld hl, _DATA_2FBB1
	ld de, $4400
	call _LABEL_1DC8
	ld hl, _DATA_2FCA3
	ld de, $7CA0
	ld a, $0B
	call _LABEL_1E9A
	ld bc, $E001
	jp SendVDPCommand

+:
	ld a, (_RAM_C183)
	or a
	jp z, +
	ld hl, $0010
	ld (_RAM_ENDING_SCREEN_TRANSITION_TIMER), hl
	xor a
	ld (_RAM_C183), a
	ld hl, _DATA_70C3
	jp _LABEL_3E3

+:
	ld bc, $8001
	call SendVDPCommand
	ld hl, $0100
	ld (_RAM_ENDING_SCREEN_TRANSITION_TIMER), hl
	ld hl, _RAM_C182
	ld a, (hl)
	cp $0A
	jr nz, ++
	inc (hl)
	ld b, a
	ld a, (_RAM_CONTINUES_USED)
	cp $0B
	jr c, +
	inc b
+:
	ld a, b
	jr +++

++:
	cp $07
	jr nz, +++
	inc (hl)
	ld b, a
	ld a, r
	and $01
	add a, b
+++:
	inc (hl)
	ld c, a
	add a, a
	ld b, a
	add a, a
	add a, a
	add a, b
	add a, c
	ld e, a
	ld d, $00
	ld hl, _DATA_702F
	add hl, de
	ld a, :Bank5
	ld (_RAM_FFFF), a
	ld a, (hl)
	inc hl
	push hl
	ld h, (hl)
	ld l, a
	ld de, $7C4C
	ld a, $14
	call _LABEL_1E9A
	pop hl
	inc hl
	ld a, (hl)
	ld (_RAM_FFFF), a
	inc hl
	ld a, (hl)
	inc hl
	push hl
	ld h, (hl)
	ld l, a
	ld de, $6000
	ld a, (_RAM_C182)
	cp $0A
	jp z, ++
	cp $0B
	jr c, +
	ld de, $6C80
+:
	call _LABEL_1DC8
++:
	pop hl
	inc hl
	ld a, (hl)
	ld (_RAM_FFFF), a
	inc hl
	ld a, (hl)
	inc hl
	push hl
	ld h, (hl)
	ld l, a
	ld de, $7950
	ld b, $10
	ld a, (_RAM_C182)
	cp $0A
	jp z, ++
	cp $0B
	jr c, +
	ld de, $7A22
	ld b, $07
+:
	ld a, b
	call _LABEL_1E9A
++:
	pop hl
	inc hl
	ld a, (hl)
	ld (_RAM_FFFF), a
	inc hl
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld a, $01
	ld (_RAM_C183), a
	call _LABEL_3E3
	ld bc, $E001
	jp SendVDPCommand

_LABEL_700F:
	ld a, (_RAM_C184)
	or a
	ret nz
	ld hl, (_RAM_ENDING_SCREEN_TRANSITION_TIMER)
	dec hl
	ld (_RAM_ENDING_SCREEN_TRANSITION_TIMER), hl
	ld a, l
	or h
	ret nz
	ld a, (_RAM_C182)
	cp $0C
	jr nz, +
	ld a, $01
	ld (_RAM_C184), a
+:
	xor a
	ld (_RAM_C181), a
	ret

; Pointer Table from 702F to 7032 (2 entries, indexed by _RAM_C182)
_DATA_702F:
.dw _DATA_16DC2 _RAM_D70D

; Data from 7033 to 704F (29 bytes)
.db $B3 $0D $09 $B9 $0D $D0 $B9 $06 $AE $06 $E2 $86 $06 $FB $B5 $06
.db $81 $9E $3A $AE $06 $E2 $86 $06 $FB $B5 $06 $A1 $9E

; 1st entry of Pointer Table from 3E1B4 (indexed by unknown)
; Data from 7050 to 70B2 (99 bytes)
_DATA_7050:
.db $64 $AE $06 $E2 $86 $06 $FB $B5 $06 $91 $9E $9A $AE $06 $15 $8B
.db $06 $B0 $B6 $06 $D1 $9E $D4 $AE $06 $9C $92 $06 $7A $B7 $06 $F1
.db $9E $14 $AF $06 $E4 $8E $06 $60 $B8 $06 $E1 $9E $56 $AF $07 $03
.db $A8 $0D $E0 $B9 $0D $AB $BA $93 $AF $07 $03 $A8 $0D $E0 $B9 $0D
.db $AB $BA $D4 $AF $0D $03 $A8 $0D $E0 $B9 $0D $C3 $70 $ED $AF $0D
.db $04 $BB $0D $BB $BA $0D $AB $BA $2B $B0 $0C $A6 $BA $0C $64 $BA
.db $0D $AB $BA

; Data from 70B3 to 70C2 (16 bytes)
_DATA_70B3:
.db $2F $1A $05 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00

; Data from 70C3 to 70D2 (16 bytes)
_DATA_70C3:
.db $00 $2F $2F $2F $2F $2F $2F $2F $2F $2F $2F $2F $2F $2F $2F $2F

; Data from 70D3 to 7814 (1858 bytes)
_DATA_70D3:
.db $50 $00 $00 $50 $00 $00

.BANK 1 SLOT 1
.ORG $0000

; Data from 7FF0 to 7FFF (16 bytes)
.db $54 $4D $52 $20 $53 $45 $47 $41 $00 $00 $18 $AB $16 $70 $00 $40

.BANK 2
.ORG $0000
Bank2:

; Pointer Table from 8000 to 800D (7 entries, indexed by unknown)
_DATA_8000:
.dw _DATA_18008 _DATA_18008 _DATA_18008 _DATA_18008 $F801 _RAM_FFFC _DATA_1900

; Data from 800E to 804E (65 bytes)
.db $80 $36 $80 $36 $80 $19 $80 $36 $80 $36 $80 $07 $D0 $FC $FF $02
.db $D0 $04 $00 $04 $E0 $FC $FF $06 $E0 $04 $00 $08 $F0 $F4 $FF $0A
.db $F0 $FC $FF $0C $F0 $04 $00 $0E $06 $D0 $FC $FF $02 $D0 $04 $00
.db $04 $E0 $FC $FF $06 $E0 $04 $00 $08 $F0 $FC $FF $0A $F0 $04 $00
.db $0C

; Data from 804F to 8090 (66 bytes)
_DATA_804F:
.db $5B $80 $78 $80 $78 $80 $5B $80 $78 $80 $78 $80 $07 $D0 $F4 $FF
.db $0C $D0 $FC $FF $0E $E0 $F4 $FF $08 $E0 $FC $FF $0A $F0 $F4 $FF
.db $02 $F0 $FC $FF $04 $F0 $04 $00 $06 $06 $D0 $F4 $FF $0A $D0 $FC
.db $FF $0C $E0 $F4 $FF $06 $E0 $FC $FF $08 $F0 $F4 $FF $02 $F0 $FC
.db $FF $04

; Data from 8091 to 80AF (31 bytes)
_DATA_8091:
.db $93 $80 $07 $D0 $F3 $FF $02 $D0 $FB $FF $04 $D0 $03 $00 $06 $E0
.db $F8 $FF $08 $E0 $00 $00 $0A $F0 $F8 $FF $0C $F0 $00 $00 $0E

; Data from 80B0 to 80CE (31 bytes)
_DATA_80B0:
.db $B2 $80 $07 $D0 $F5 $FF $0A $D0 $FD $FF $0C $D0 $05 $00 $0E $E0
.db $F8 $FF $06 $E0 $00 $00 $08 $F0 $F8 $FF $02 $F0 $00 $00 $04

; Data from 80CF to 80D2 (4 bytes)
_DATA_80CF:
.db $93 $80 $B2 $80

; Data from 80D3 to 80ED (27 bytes)
_DATA_80D3:
.db $D5 $80 $06 $D0 $FC $FF $02 $E0 $FC $FF $04 $E0 $04 $00 $06 $F0
.db $F4 $FF $08 $F0 $FC $FF $0A $F0 $04 $00 $0C

; Data from 80EE to 8108 (27 bytes)
_DATA_80EE:
.db $F0 $80 $06 $D0 $FC $FF $0C $E0 $F4 $FF $08 $E0 $FC $FF $0A $F0
.db $F4 $FF $02 $F0 $FC $FF $04 $F0 $04 $00 $06

; Data from 8109 to 819C (148 bytes)
_DATA_8109:
.db $11 $81 $2E $81 $4F $81 $78 $81 $07 $D4 $EE $FF $02 $D0 $F6 $FF
.db $04 $D0 $FE $FF $06 $E0 $F6 $FF $08 $E0 $FE $FF $0A $F0 $F6 $FF
.db $0C $F0 $FE $FF $0E $08 $C0 $EF $FF $02 $D0 $EE $FF $04 $D0 $F6
.db $FF $06 $D0 $FE $FF $08 $E0 $F6 $FF $0A $E0 $FE $FF $0C $F0 $F6
.db $FF $0E $F0 $FE $FF $10 $0A $D8 $DE $FF $02 $D8 $E6 $FF $04 $E0
.db $EE $FF $06 $D0 $F2 $FF $08 $D0 $FA $FF $0A $E0 $F6 $FF $0C $E0
.db $FE $FF $0E $F0 $EE $FF $10 $F0 $F6 $FF $12 $F0 $FE $FF $14 $09
.db $E8 $E4 $FF $02 $E8 $EC $FF $04 $D8 $EC $FF $06 $D8 $F4 $FF $08
.db $D8 $FC $FF $0A $E8 $F4 $FF $0C $E8 $FC $FF $0E $F8 $F4 $FF $10
.db $F8 $FC $FF $12

; Data from 819D to 8426 (650 bytes)
_DATA_819D:
.db $A5 $81 $C2 $81 $E3 $81 $0C $82 $07 $D4 $0A $00 $0E $D0 $FA $FF
.db $0A $D0 $02 $00 $0C $E0 $FA $FF $06 $E0 $02 $00 $08 $F0 $FA $FF
.db $02 $F0 $02 $00 $04 $08 $C0 $09 $00 $10 $D0 $FA $FF $0A $D0 $02
.db $00 $0C $D0 $0A $00 $0E $E0 $FA $FF $06 $E0 $02 $00 $08 $F0 $FA
.db $FF $02 $F0 $02 $00 $04 $0A $D8 $12 $00 $12 $D8 $1A $00 $1E $E0
.db $0A $00 $10 $D0 $FE $FF $0C $D0 $06 $00 $0E $E0 $FA $FF $08 $E0
.db $02 $00 $0A $F0 $FA $FF $02 $F0 $02 $00 $04 $F0 $0A $00 $06 $09
.db $E8 $0C $00 $10 $E8 $14 $00 $12 $D8 $FC $FF $0A $D8 $04 $00 $0C
.db $D8 $0C $00 $0E $E8 $FC $FF $06 $E8 $04 $00 $08 $F8 $FC $FF $02
.db $F8 $04 $00 $04 $39 $82 $52 $82 $77 $82 $9C $82 $06 $D0 $FB $FF
.db $02 $D0 $03 $00 $04 $E0 $FD $FF $06 $E0 $05 $00 $08 $F0 $FD $FF
.db $0A $F0 $05 $00 $0C $09 $D0 $F0 $FF $02 $D0 $F8 $FF $04 $D0 $00
.db $00 $06 $E0 $EE $FF $08 $E0 $F6 $FF $0A $E0 $FE $FF $0C $E0 $06
.db $00 $0E $F0 $F6 $FF $10 $F0 $FE $FF $12 $09 $D0 $EE $FF $02 $D0
.db $F6 $FF $04 $D0 $FE $FF $06 $D0 $06 $00 $08 $E0 $F2 $FF $0A $E0
.db $FA $FF $0C $E0 $02 $00 $0E $F0 $F6 $FF $10 $F0 $FE $FF $12 $0A
.db $D0 $EE $FF $02 $D0 $F6 $FF $04 $D0 $FE $FF $06 $D0 $06 $00 $08
.db $E0 $F4 $FF $0A $E0 $FC $FF $0C $E0 $04 $00 $0E $F0 $F6 $FF $10
.db $F0 $FE $FF $12 $F0 $06 $00 $14 $CD $82 $E6 $82 $0B $83 $30 $83
.db $06 $D0 $F7 $FF $0A $D0 $FD $FF $0C $E0 $F5 $FF $06 $E0 $FB $FF
.db $08 $F0 $F5 $FF $02 $F0 $FB $FF $04 $09 $D0 $F8 $FF $0E $D0 $00
.db $00 $10 $D0 $08 $00 $12 $E0 $F2 $FF $06 $E0 $FA $FF $08 $E0 $02
.db $00 $0A $E0 $0A $00 $0C $F0 $FA $FF $02 $F0 $02 $00 $04 $09 $D0
.db $F2 $FF $0C $D0 $FA $FF $0E $D0 $02 $00 $10 $D0 $0A $00 $12 $E0
.db $F6 $FF $06 $E0 $FE $FF $08 $E0 $06 $00 $0A $F0 $FA $FF $02 $F0
.db $02 $00 $04 $0A $D0 $F2 $FF $0E $D0 $FA $FF $10 $D0 $02 $00 $12
.db $D0 $0A $00 $14 $E0 $F4 $FF $08 $E0 $FC $FF $0A $E0 $04 $00 $0C
.db $F0 $F2 $FF $02 $F0 $FA $FF $04 $F0 $02 $00 $06 $61 $83 $7E $83
.db $9B $83 $9B $83 $07 $D0 $FD $FF $04 $E0 $FC $FF $06 $E0 $04 $00
.db $08 $E0 $0C $00 $0A $F0 $F4 $FF $0C $F0 $FC $FF $0E $F0 $04 $00
.db $10 $07 $D0 $FC $FF $04 $E0 $F8 $FF $06 $E0 $00 $00 $08 $E0 $08
.db $00 $0A $F0 $F4 $FF $0C $F0 $FC $FF $0E $F0 $04 $00 $10 $09 $D0
.db $FB $FF $04 $D0 $03 $00 $06 $E0 $F4 $FF $08 $E0 $FC $FF $0A $E0
.db $04 $00 $0C $E0 $0C $00 $0E $F0 $F4 $FF $10 $F0 $FC $FF $12 $F0
.db $04 $00 $14 $C8 $83 $E5 $83 $02 $84 $02 $84 $07 $D0 $FB $FF $0E
.db $E0 $EC $FF $08 $E0 $F4 $FF $0A $E0 $FC $FF $0C $F0 $F4 $FF $02
.db $F0 $FC $FF $04 $F0 $04 $00 $06 $07 $D0 $FC $FF $0E $E0 $F0 $FF
.db $08 $E0 $F8 $FF $0A $E0 $00 $00 $0C $F0 $F4 $FF $02 $F0 $FC $FF
.db $04 $F0 $04 $00 $06 $09 $D0 $F5 $FF $10 $D0 $FD $FF $12 $E0 $EC
.db $FF $08 $E0 $F4 $FF $0A $E0 $FC $FF $0C $E0 $04 $00 $0E $F0 $F4
.db $FF $02 $F0 $FC $FF $04 $F0 $04 $00 $06

; Data from 8427 to 847F (89 bytes)
_DATA_8427:
.db $2D $84 $4A $84 $67 $84 $07 $D0 $EC $FF $02 $E0 $EA $FF $04 $E0
.db $F2 $FF $06 $E0 $FA $FF $08 $F0 $E8 $FF $0A $F0 $F4 $FF $0C $F0
.db $FC $FF $0E $07 $F0 $DC $FF $02 $F0 $E4 $FF $04 $E0 $EC $FF $06
.db $E0 $F4 $FF $08 $F0 $EC $FF $0A $F0 $F4 $FF $0C $F0 $FC $FF $0E
.db $06 $F0 $D4 $FF $02 $F0 $DC $FF $04 $F0 $E4 $FF $06 $F0 $EC $FF
.db $08 $F0 $F4 $FF $0A $F0 $FC $FF $0C

; Data from 8480 to 84D8 (89 bytes)
_DATA_8480:
.db $86 $84 $A3 $84 $C0 $84 $07 $D0 $0C $00 $0E $E0 $FE $FF $08 $E0
.db $06 $00 $0A $E0 $0E $00 $0C $F0 $FC $FF $02 $F0 $04 $00 $04 $F0
.db $10 $00 $06 $07 $F0 $14 $00 $0C $F0 $1C $00 $0E $E0 $04 $00 $08
.db $E0 $0C $00 $0A $F0 $FC $FF $02 $F0 $04 $00 $04 $F0 $0C $00 $06
.db $06 $F0 $FC $FF $02 $F0 $04 $00 $04 $F0 $0C $00 $06 $F0 $14 $00
.db $08 $F0 $1C $00 $0A $F0 $24 $00 $0C

; Data from 84D9 to 8554 (124 bytes)
_DATA_84D9:
.db $E1 $84 $FA $84 $17 $85 $38 $85 $06 $D0 $FC $FF $02 $E0 $FC $FF
.db $04 $E0 $04 $00 $06 $F0 $F4 $FF $08 $F0 $FC $FF $0A $F0 $04 $00
.db $0C $07 $D0 $FA $FF $02 $E0 $F4 $FF $04 $E0 $FC $FF $06 $E0 $04
.db $00 $08 $F0 $F4 $FF $0A $F0 $FC $FF $0C $F0 $04 $00 $0E $08 $F0
.db $E4 $FF $02 $F0 $EC $FF $04 $E0 $F4 $FF $06 $E0 $FC $FF $08 $E0
.db $04 $00 $0A $F0 $F4 $FF $0C $F0 $FC $FF $0E $F0 $04 $00 $10 $07
.db $E0 $EB $FF $02 $E0 $F3 $FF $04 $E0 $FB $FF $06 $E0 $03 $00 $08
.db $F0 $F4 $FF $0A $F0 $FC $FF $0C $F0 $04 $00 $0E

; Data from 8555 to 85D0 (124 bytes)
_DATA_8555:
.db $5D $85 $76 $85 $93 $85 $B4 $85 $06 $D0 $FC $FF $02 $E0 $F4 $FF
.db $04 $E0 $FC $FF $06 $F0 $F4 $FF $08 $F0 $FC $FF $0A $F0 $04 $00
.db $0C $07 $D0 $FE $FF $02 $E0 $F4 $FF $04 $E0 $FC $FF $06 $E0 $04
.db $00 $08 $F0 $F4 $FF $0A $F0 $FC $FF $0C $F0 $04 $00 $0E $08 $E8
.db $0C $00 $02 $E8 $14 $00 $04 $E0 $F4 $FF $06 $E0 $FC $FF $08 $E0
.db $04 $00 $0A $F0 $F4 $FF $0C $F0 $FC $FF $0E $F0 $04 $00 $10 $07
.db $E0 $F5 $FF $02 $E0 $FD $FF $04 $E0 $05 $00 $06 $E0 $0D $00 $08
.db $F0 $F4 $FF $0A $F0 $FC $FF $0C $F0 $04 $00 $0E

; Data from 85D1 to 85F1 (33 bytes)
_DATA_85D1:
.db $D5 $85 $DE $85 $02 $F0 $F8 $FF $16 $F0 $00 $00 $18 $02 $F0 $F8
.db $FF $1A $F0 $00 $00 $1C $E9 $85 $02 $F0 $F8 $FF $FC $F0 $00 $00
.db $FE

; Data from 85F2 to 85FB (10 bytes)
_DATA_85F2:
.db $00 $86 $09 $86 $12 $86 $1B $86 $24 $86

; Data from 85FC to 863E (67 bytes)
_DATA_85FC:
.db $2D $86 $36 $86 $02 $F0 $F8 $FF $BC $F0 $00 $00 $BE $02 $F0 $F8
.db $FF $C0 $F0 $00 $00 $C2 $02 $F0 $F8 $FF $C4 $F0 $00 $00 $C6 $02
.db $F0 $F8 $FF $C8 $F0 $00 $00 $CA $02 $F0 $F8 $FF $CC $F0 $00 $00
.db $CE $02 $F0 $F8 $FF $D0 $F0 $00 $00 $D2 $02 $F0 $F8 $FF $D4 $F0
.db $00 $00 $D6

; Data from 863F to 868F (81 bytes)
_DATA_863F:
.db $45 $86 $5E $86 $77 $86 $06 $E0 $F4 $FF $8C $E0 $FC $FF $8E $E0
.db $04 $00 $90 $F0 $F4 $FF $92 $F0 $FC $FF $94 $F0 $04 $00 $96 $06
.db $E0 $F4 $FF $8C $E0 $FC $FF $8E $E0 $04 $00 $90 $F0 $F4 $FF $98
.db $F0 $FC $FF $9A $F0 $04 $00 $9C $06 $E0 $F4 $FF $8C $E0 $FC $FF
.db $8E $E0 $04 $00 $90 $F0 $F4 $FF $9E $F0 $FC $FF $A0 $F0 $04 $00
.db $A2

; Data from 8690 to 86B0 (33 bytes)
_DATA_8690:
.db $96 $86 $9F $86 $A8 $86 $02 $F0 $F8 $FF $BC $F0 $00 $00 $BE $02
.db $F0 $F8 $FF $C0 $F0 $00 $00 $C2 $02 $F0 $F8 $FF $C4 $F0 $00 $00
.db $C6

; Data from 86B1 to 86D1 (33 bytes)
_DATA_86B1:
.db $B7 $86 $C0 $86 $C9 $86 $02 $F0 $F8 $FF $CA $F0 $00 $00 $C8 $02
.db $F0 $F8 $FF $CE $F0 $00 $00 $CC $02 $F0 $F8 $FF $D2 $F0 $00 $00
.db $D0

; Data from 86D2 to 86FE (45 bytes)
_DATA_86D2:
.db $D8 $86 $E5 $86 $F2 $86 $03 $F0 $F4 $FF $D4 $F0 $FC $FF $D6 $F0
.db $04 $00 $D8 $03 $F0 $F4 $FF $DA $F0 $FC $FF $DC $F0 $04 $00 $DE
.db $03 $F0 $F4 $FF $E0 $F0 $FC $FF $E2 $F0 $04 $00 $E4

; Data from 86FF to 872B (45 bytes)
_DATA_86FF:
.db $05 $87 $12 $87 $1F $87 $03 $F0 $F4 $FF $EA $F0 $FC $FF $E8 $F0
.db $04 $00 $E6 $03 $F0 $F4 $FF $F0 $F0 $FC $FF $EE $F0 $04 $00 $EC
.db $03 $F0 $F4 $FF $F6 $F0 $FC $FF $F4 $F0 $04 $00 $F2

; Data from 872C to 8769 (62 bytes)
_DATA_872C:
.db $30 $87 $49 $87 $06 $E0 $F4 $FF $D0 $E0 $FC $FF $D2 $E0 $04 $00
.db $D4 $F0 $F4 $FF $D6 $F0 $FC $FF $D8 $F0 $04 $00 $DA $08 $D0 $F4
.db $FF $D0 $D0 $FC $FF $D2 $D0 $04 $00 $D4 $E0 $F4 $FF $D6 $E0 $FC
.db $FF $DC $E0 $04 $00 $DE $F0 $FC $FF $E0 $F0 $04 $00 $E2

; Data from 876A to 87A7 (62 bytes)
_DATA_876A:
.db $6E $87 $87 $87 $06 $E0 $F4 $FF $E8 $E0 $FC $FF $E6 $E0 $04 $00
.db $E4 $F0 $F4 $FF $EE $F0 $FC $FF $EC $F0 $04 $00 $EA $08 $D0 $F4
.db $FF $E8 $D0 $FC $FF $E6 $D0 $04 $00 $E4 $E0 $F4 $FF $F2 $E0 $FC
.db $FF $F0 $E0 $04 $00 $EA $F0 $F4 $FF $F6 $F0 $FC $FF $F4

; Data from 87A8 to 881C (117 bytes)
_DATA_87A8:
.db $AE $87 $CF $87 $F4 $87 $08 $D0 $F4 $FF $28 $D0 $FC $FF $2A $D0
.db $04 $00 $2C $E0 $F4 $FF $2E $E0 $FC $FF $30 $E0 $04 $00 $32 $F0
.db $FC $FF $34 $F0 $04 $00 $36 $09 $D0 $F4 $FF $28 $D0 $FC $FF $2A
.db $D0 $04 $00 $2C $E0 $F4 $FF $38 $E0 $FC $FF $3A $E0 $04 $00 $3C
.db $F0 $F4 $FF $3E $F0 $FC $FF $40 $F0 $04 $00 $42 $0A $D0 $FC $FF
.db $4A $D0 $04 $00 $4C $D8 $E4 $FF $44 $D8 $EC $FF $46 $D8 $F4 $FF
.db $48 $E0 $FC $FF $4E $E0 $04 $00 $50 $F0 $F4 $FF $3E $F0 $FC $FF
.db $40 $F0 $04 $00 $42

; Data from 881D to 8891 (117 bytes)
_DATA_881D:
.db $23 $88 $44 $88 $69 $88 $08 $D0 $F4 $FF $56 $D0 $FC $FF $54 $D0
.db $04 $00 $52 $E0 $F4 $FF $5C $E0 $FC $FF $5A $E0 $04 $00 $58 $F0
.db $F4 $FF $60 $F0 $FC $FF $5E $09 $D0 $F4 $FF $56 $D0 $FC $FF $54
.db $D0 $04 $00 $52 $E0 $F4 $FF $66 $E0 $FC $FF $64 $E0 $04 $00 $62
.db $F0 $F4 $FF $6C $F0 $FC $FF $6A $F0 $04 $00 $68 $0A $D0 $F4 $FF
.db $76 $D0 $FC $FF $74 $D8 $04 $00 $72 $D8 $0C $00 $70 $D8 $14 $00
.db $6E $E0 $F4 $FF $7A $E0 $FC $FF $78 $F0 $F4 $FF $6C $F0 $FC $FF
.db $6A $F0 $04 $00 $68

; Data from 8892 to 88EE (93 bytes)
_DATA_8892:
.db $98 $88 $B5 $88 $D2 $88 $07 $E0 $F8 $FF $8A $E0 $00 $00 $8C $E0
.db $08 $00 $8E $ED $F0 $FF $88 $F0 $F8 $FF $90 $F0 $00 $00 $92 $F0
.db $08 $00 $94 $07 $E0 $F8 $FF $8A $E0 $00 $00 $8C $E0 $08 $00 $8E
.db $ED $F0 $FF $88 $F0 $F8 $FF $96 $F0 $00 $00 $98 $F0 $08 $00 $9A
.db $07 $E0 $F8 $FF $8A $E0 $00 $00 $8C $E0 $08 $00 $8E $ED $F0 $FF
.db $88 $F0 $F8 $FF $9C $F0 $00 $00 $9E $F0 $08 $00 $A0

; Data from 88EF to 894B (93 bytes)
_DATA_88EF:
.db $F5 $88 $12 $89 $2F $89 $07 $E0 $F0 $FF $A8 $E0 $F8 $FF $A6 $E0
.db $00 $00 $A4 $F0 $F0 $FF $AE $F0 $F8 $FF $AC $F0 $00 $00 $AA $ED
.db $08 $00 $A2 $07 $E0 $F0 $FF $A8 $E0 $F8 $FF $A6 $E0 $00 $00 $A4
.db $F0 $F0 $FF $B4 $F0 $F8 $FF $B2 $F0 $00 $00 $B0 $ED $08 $00 $A2
.db $07 $E0 $F0 $FF $A8 $E0 $F8 $FF $A6 $E0 $00 $00 $A4 $F0 $F0 $FF
.db $BA $F0 $F8 $FF $B8 $F0 $00 $00 $B6 $ED $08 $00 $A2

; Data from 894C to 89B4 (105 bytes)
_DATA_894C:
.db $52 $89 $73 $89 $94 $89 $08 $E0 $F0 $FF $28 $E0 $F8 $FF $2A $E0
.db $00 $00 $2C $E0 $08 $00 $2E $F0 $F0 $FF $30 $F0 $F8 $FF $32 $F0
.db $00 $00 $34 $F0 $08 $00 $36 $08 $E0 $F0 $FF $38 $E0 $F8 $FF $3A
.db $E0 $00 $00 $3C $E0 $08 $00 $3E $F0 $F0 $FF $40 $F0 $F8 $FF $42
.db $F0 $00 $00 $44 $F0 $08 $00 $46 $08 $E0 $F0 $FF $48 $E0 $F8 $FF
.db $4A $E0 $00 $00 $4C $E0 $08 $00 $4E $F0 $F0 $FF $50 $F0 $F8 $FF
.db $52 $F0 $00 $00 $54 $F0 $08 $00 $56

; Data from 89B5 to 8A1D (105 bytes)
_DATA_89B5:
.db $BB $89 $DC $89 $FD $89 $08 $E0 $F0 $FF $5E $E0 $F8 $FF $5C $E0
.db $00 $00 $5A $E0 $08 $00 $58 $F0 $F0 $FF $66 $F0 $F8 $FF $64 $F0
.db $00 $00 $62 $F0 $08 $00 $60 $08 $E0 $F0 $FF $6E $E0 $F8 $FF $6C
.db $E0 $00 $00 $6A $E0 $08 $00 $68 $F0 $F0 $FF $76 $F0 $F8 $FF $74
.db $F0 $00 $00 $72 $F0 $08 $00 $70 $08 $E0 $F0 $FF $7E $E0 $F8 $FF
.db $7C $E0 $00 $00 $7A $E0 $08 $00 $78 $F0 $F0 $FF $86 $F0 $F8 $FF
.db $84 $F0 $00 $00 $82 $F0 $08 $00 $80

; Data from 8A1E to 8A6B (78 bytes)
_DATA_8A1E:
.db $28 $8A $39 $8A $4A $8A $39 $8A $5B $8A $04 $EC $F0 $FF $8E $F0
.db $F8 $FF $88 $F0 $00 $00 $8A $F0 $08 $00 $8C $04 $EC $F0 $FF $8E
.db $F0 $F8 $FF $90 $F0 $00 $00 $92 $F0 $08 $00 $94 $04 $EC $F0 $FF
.db $8E $F0 $F8 $FF $96 $F0 $00 $00 $98 $F0 $08 $00 $9A $04 $EE $F0
.db $FF $9C $EE $F8 $FF $9E $F0 $00 $00 $A0 $F0 $08 $00 $A2

; Data from 8A6C to 8AB9 (78 bytes)
_DATA_8A6C:
.db $76 $8A $87 $8A $98 $8A $87 $8A $A9 $8A $04 $F0 $F0 $FF $A8 $F0
.db $F8 $FF $A6 $F0 $00 $00 $A4 $EC $08 $00 $AA $04 $F0 $F0 $FF $B0
.db $F0 $F8 $FF $AE $F0 $00 $00 $AC $EC $08 $00 $AA $04 $F0 $F0 $FF
.db $B6 $F0 $F8 $FF $B4 $F0 $00 $00 $B2 $EC $08 $00 $AA $04 $F0 $F0
.db $FF $BE $F0 $F8 $FF $BC $EE $00 $00 $BA $EE $08 $00 $B8

; Data from 8ABA to 8AF2 (57 bytes)
_DATA_8ABA:
.db $C0 $8A $D1 $8A $E2 $8A $04 $F0 $F0 $FF $D4 $F0 $F8 $FF $E0 $F0
.db $00 $00 $E2 $F0 $08 $00 $D6 $04 $F0 $F0 $FF $D8 $F0 $F8 $FF $E4
.db $F0 $00 $00 $E6 $F0 $08 $00 $DA $04 $F0 $F0 $FF $DC $F0 $F8 $FF
.db $E8 $F0 $00 $00 $EA $F0 $08 $00 $DE

; Data from 8AF3 to 8B2B (57 bytes)
_DATA_8AF3:
.db $F9 $8A $0A $8B $1B $8B $04 $F0 $F0 $FF $EE $F0 $F8 $FF $E2 $F0
.db $00 $00 $E0 $F0 $08 $00 $EC $04 $F0 $F0 $FF $F2 $F0 $F8 $FF $E6
.db $F0 $00 $00 $E4 $F0 $08 $00 $F0 $04 $F0 $F0 $FF $F6 $F0 $F8 $FF
.db $EA $F0 $00 $00 $E8 $F0 $08 $00 $F4

; Data from 8B2C to 8B32 (7 bytes)
_DATA_8B2C:
.db $2E $8B $01 $F0 $FC $FF $A4

; Data from 8B33 to 8B9B (105 bytes)
_DATA_8B33:
.db $39 $8B $56 $8B $77 $8B $07 $D0 $FC $FF $28 $D0 $04 $00 $2A $D8
.db $F4 $FF $2C $E0 $FC $FF $2E $E0 $04 $00 $30 $F0 $FC $FF $32 $F0
.db $04 $00 $34 $08 $D0 $FC $FF $36 $D0 $04 $00 $2A $D8 $F4 $FF $2C
.db $E0 $FC $FF $2E $E0 $04 $00 $30 $F0 $F4 $FF $38 $F0 $FC $FF $3A
.db $F0 $04 $00 $3C $09 $D0 $00 $00 $3E $D0 $08 $00 $2A $E0 $F0 $FF
.db $40 $E0 $F8 $FF $42 $E0 $00 $00 $44 $E0 $08 $00 $46 $F0 $F8 $FF
.db $38 $F0 $00 $00 $3A $F0 $08 $00 $3C

; Data from 8B9C to 8C04 (105 bytes)
_DATA_8B9C:
.db $A2 $8B $BF $8B $E0 $8B $07 $D0 $FC $FF $48 $D0 $F4 $FF $4A $D8
.db $04 $00 $4C $E0 $FC $FF $4E $E0 $F4 $FF $50 $F0 $FC $FF $52 $F0
.db $F4 $FF $54 $08 $D0 $FC $FF $56 $D0 $F4 $FF $4A $D8 $04 $00 $4C
.db $E0 $FC $FF $4E $E0 $F4 $FF $50 $F0 $04 $00 $58 $F0 $FC $FF $5A
.db $F0 $F4 $FF $5C $09 $D0 $F8 $FF $5E $D0 $F0 $FF $4A $E0 $08 $00
.db $60 $E0 $00 $00 $62 $E0 $F8 $FF $64 $E0 $F0 $FF $66 $F0 $00 $00
.db $58 $F0 $F8 $FF $5A $F0 $F0 $FF $5C

; Data from 8C05 to 8C4E (74 bytes)
_DATA_8C05:
.db $09 $8C $2E $8C $09 $D0 $F4 $FF $90 $D0 $FC $FF $92 $D0 $04 $00
.db $94 $E0 $F4 $FF $96 $E0 $FC $FF $98 $E0 $04 $00 $9A $F0 $F4 $FF
.db $9C $F0 $FC $FF $9E $F0 $04 $00 $A0 $08 $D0 $F4 $FF $A2 $D0 $FC
.db $FF $A4 $E0 $F4 $FF $96 $E0 $FC $FF $A6 $E0 $04 $00 $A8 $F0 $F4
.db $FF $9C $F0 $FC $FF $9E $F0 $04 $00 $A0

; Data from 8C4F to 8CE2 (148 bytes)
_DATA_8C4F:
.db $53 $8C $78 $8C $09 $D0 $F4 $FF $B4 $D0 $FC $FF $B2 $D0 $04 $00
.db $B0 $E0 $F4 $FF $BA $E0 $FC $FF $B8 $E0 $04 $00 $B6 $F0 $F4 $FF
.db $C0 $F0 $FC $FF $BE $F0 $04 $00 $BC $08 $D0 $F4 $FF $C4 $D0 $04
.db $00 $C2 $E0 $F4 $FF $C8 $E0 $FC $FF $C6 $E0 $04 $00 $B6 $F0 $F4
.db $FF $C0 $F0 $FC $FF $BE $F0 $04 $00 $BC $9D $8C $C2 $8C $09 $D0
.db $F4 $FF $90 $D0 $FC $FF $92 $D0 $04 $00 $94 $E0 $F4 $FF $96 $E0
.db $FC $FF $98 $E0 $04 $00 $9A $F0 $F4 $FF $AA $F0 $FC $FF $AC $F0
.db $04 $00 $AE $08 $D0 $F4 $FF $A2 $D0 $FC $FF $A4 $E0 $F4 $FF $96
.db $E0 $FC $FF $A6 $E0 $04 $00 $A8 $F0 $F4 $FF $AA $F0 $FC $FF $AC
.db $F0 $04 $00 $AE

; Data from 8CE3 to 8D2C (74 bytes)
_DATA_8CE3:
.db $E7 $8C $0C $8D $09 $D0 $F4 $FF $B4 $D0 $FC $FF $B2 $D0 $04 $00
.db $B0 $E0 $F4 $FF $BA $E0 $FC $FF $B8 $E0 $04 $00 $B6 $F0 $F4 $FF
.db $CE $F0 $FC $FF $CC $F0 $04 $00 $CA $08 $D0 $F4 $FF $C2 $D0 $04
.db $00 $C4 $E0 $F4 $FF $C8 $E0 $FC $FF $C6 $E0 $04 $00 $B6 $F0 $F4
.db $FF $CE $F0 $FC $FF $CC $F0 $04 $00 $CA

; Data from 8D2D to 8D59 (45 bytes)
_DATA_8D2D:
.db $33 $8D $40 $8D $4D $8D $03 $F0 $F4 $FF $6E $F0 $FC $FF $70 $F0
.db $04 $00 $72 $03 $F0 $F4 $FF $74 $F0 $FC $FF $76 $F0 $04 $00 $78
.db $03 $F0 $F4 $FF $68 $F0 $FC $FF $6A $F0 $04 $00 $6C

; Data from 8D5A to 8D86 (45 bytes)
_DATA_8D5A:
.db $60 $8D $6D $8D $7A $8D $03 $F0 $F4 $FF $84 $F0 $FC $FF $82 $F0
.db $04 $00 $80 $03 $F0 $F4 $FF $8A $F0 $FC $FF $88 $F0 $04 $00 $86
.db $03 $F0 $F4 $FF $7E $F0 $FC $FF $7C $F0 $04 $00 $7A

; Data from 8D87 to 8D9C (22 bytes)
_DATA_8D87:
.db $8B $8D $94 $8D $02 $F0 $F8 $FF $F8 $F0 $00 $00 $FA $02 $F0 $F8
.db $FF $FC $F0 $00 $00 $FE

; Data from 8D9D to 8DB2 (22 bytes)
_DATA_8D9D:
.db $A1 $8D $AA $8D $02 $F0 $F8 $FF $A6 $F0 $00 $00 $A8 $02 $F0 $F8
.db $FF $AA $F0 $00 $00 $AC

; Data from 8DB3 to 8DFB (73 bytes)
_DATA_8DB3:
.db $B9 $8D $DA $8D $F7 $8D $08 $D0 $F4 $FF $28 $D0 $FC $FF $2A $D0
.db $04 $00 $2C $E0 $FC $FF $2E $E0 $04 $00 $30 $F0 $F4 $FF $32 $F0
.db $FC $FF $34 $F0 $04 $00 $36 $07 $D0 $F4 $FF $28 $D0 $FC $FF $2A
.db $D0 $04 $00 $2C $E0 $FC $FF $38 $E0 $04 $00 $3A $F0 $FC $FF $3C
.db $F0 $04 $00 $3E $01 $F0 $FC $FF $00

; Data from 8DFC to 8E3F (68 bytes)
_DATA_8DFC:
.db $02 $8E $23 $8E $F7 $8D $08 $D0 $F4 $FF $5C $D0 $FC $FF $5A $D0
.db $04 $00 $58 $E0 $F4 $FF $60 $E0 $FC $FF $5E $F0 $F4 $FF $66 $F0
.db $FC $FF $64 $F0 $04 $00 $62 $07 $D0 $F4 $FF $5C $D0 $FC $FF $5A
.db $D0 $04 $00 $58 $E0 $F4 $FF $6A $E0 $FC $FF $68 $F0 $F4 $FF $6E
.db $F0 $FC $FF $6C

; Data from 8E40 to 8E8D (78 bytes)
_DATA_8E40:
.db $44 $8E $69 $8E $09 $C0 $FC $FF $40 $C9 $F4 $FF $42 $D0 $FC $FF
.db $44 $D0 $04 $00 $46 $E0 $FC $FF $48 $E0 $04 $00 $4A $F0 $F4 $FF
.db $32 $F0 $FC $FF $34 $F0 $04 $00 $36 $09 $D0 $FD $FF $4C $D0 $05
.db $00 $4E $E0 $F0 $FF $50 $E0 $F8 $FF $52 $E0 $00 $00 $54 $E0 $08
.db $00 $56 $F0 $F8 $FF $32 $F0 $00 $00 $34 $F0 $08 $00 $36

; Data from 8E8E to 8EDB (78 bytes)
_DATA_8E8E:
.db $92 $8E $B7 $8E $09 $C0 $FC $FF $70 $C9 $04 $00 $72 $D0 $F4 $FF
.db $76 $D0 $FC $FF $74 $E0 $F4 $FF $7A $E0 $FC $FF $78 $F0 $F4 $FF
.db $66 $F0 $FC $FF $64 $F0 $04 $00 $62 $09 $D0 $FB $FF $7C $D0 $F3
.db $FF $7E $E0 $F0 $FF $86 $E0 $F8 $FF $84 $E0 $00 $00 $82 $E0 $08
.db $00 $80 $F0 $F0 $FF $66 $F0 $F8 $FF $64 $F0 $00 $00 $62

; Data from 8EDC to 8F49 (110 bytes)
_DATA_8EDC:
.db $E0 $8E $15 $8F $0D $C0 $F0 $FF $28 $C0 $F8 $FF $2A $C0 $00 $00
.db $2C $C0 $08 $00 $2E $D0 $F0 $FF $30 $D0 $F8 $FF $32 $D0 $00 $00
.db $34 $D0 $08 $00 $36 $E0 $F0 $FF $38 $E0 $F8 $FF $3A $E0 $00 $00
.db $3C $F0 $F4 $FF $3E $F0 $FC $FF $40 $0D $C0 $F0 $FF $28 $C0 $F8
.db $FF $2A $C0 $00 $00 $42 $C0 $08 $00 $44 $D0 $F0 $FF $30 $D0 $F8
.db $FF $32 $D0 $00 $00 $46 $D0 $08 $00 $48 $E0 $F0 $FF $38 $E0 $F8
.db $FF $3A $E0 $00 $00 $3C $F0 $F4 $FF $3E $F0 $FC $FF $40

; Data from 8F4A to 8FB7 (110 bytes)
_DATA_8F4A:
.db $4E $8F $83 $8F $0D $C0 $F0 $FF $58 $C0 $F8 $FF $56 $C0 $00 $00
.db $54 $C0 $08 $00 $52 $D0 $F0 $FF $60 $D0 $F8 $FF $5E $D0 $00 $00
.db $5C $D0 $08 $00 $5A $E0 $F8 $FF $66 $E0 $00 $00 $64 $E0 $08 $00
.db $62 $F0 $FC $FF $6A $F0 $04 $00 $68 $0D $C0 $F0 $FF $6E $C0 $F8
.db $FF $6C $C0 $00 $00 $54 $C0 $08 $00 $52 $D0 $F0 $FF $72 $D0 $F8
.db $FF $70 $D0 $00 $00 $5C $D0 $08 $00 $5A $E0 $F8 $FF $66 $E0 $00
.db $00 $64 $E0 $08 $00 $62 $F0 $FC $FF $6A $F0 $04 $00 $68

; Data from 8FB8 to 8FC1 (10 bytes)
_DATA_8FB8:
.db $F7 $8D $F7 $8D $F7 $8D $F7 $8D $F7 $8D

; Data from 8FC2 to 9049 (136 bytes)
_DATA_8FC2:
.db $CA $8F $EF $8F $10 $90 $31 $90 $09 $D0 $F4 $FF $28 $D0 $FC $FF
.db $2A $D0 $04 $00 $2C $E0 $F4 $FF $2E $E0 $FC $FF $30 $E0 $04 $00
.db $32 $F0 $F4 $FF $34 $F0 $FC $FF $36 $F0 $04 $00 $38 $08 $D0 $F4
.db $FF $28 $D0 $FC $FF $2A $D0 $04 $00 $2C $E0 $F4 $FF $3A $E0 $FC
.db $FF $3C $E0 $04 $00 $3E $F0 $F8 $FF $40 $F0 $00 $00 $42 $08 $D0
.db $F4 $FF $44 $D0 $FC $FF $46 $D0 $04 $00 $48 $E0 $F4 $FF $4A $E0
.db $FC $FF $4C $E0 $04 $00 $4E $F0 $F8 $FF $50 $F0 $00 $00 $52 $06
.db $E0 $00 $00 $54 $E0 $08 $00 $56 $F0 $F0 $FF $58 $F0 $F8 $FF $5A
.db $F0 $00 $00 $5C $F0 $08 $00 $5E

; Data from 904A to 90D1 (136 bytes)
_DATA_904A:
.db $52 $90 $77 $90 $98 $90 $B9 $90 $09 $D0 $F4 $FF $64 $D0 $FC $FF
.db $62 $D0 $04 $00 $60 $E0 $F4 $FF $6A $E0 $FC $FF $68 $E0 $04 $00
.db $66 $F0 $F4 $FF $70 $F0 $FC $FF $6E $F0 $04 $00 $6C $08 $D0 $F4
.db $FF $64 $D0 $FC $FF $62 $D0 $04 $00 $60 $E0 $F4 $FF $76 $E0 $FC
.db $FF $74 $E0 $04 $00 $72 $F0 $F8 $FF $7A $F0 $00 $00 $78 $08 $D0
.db $F4 $FF $80 $D0 $FC $FF $7E $D0 $04 $00 $7C $E0 $F4 $FF $86 $E0
.db $FC $FF $84 $E0 $04 $00 $82 $F0 $F8 $FF $8A $F0 $00 $00 $88 $06
.db $E0 $F0 $FF $8E $E0 $F8 $FF $8C $F0 $F0 $FF $96 $F0 $F8 $FF $94
.db $F0 $00 $00 $92 $F0 $08 $00 $90

; Data from 90D2 to 914E (125 bytes)
_DATA_90D2:
.db $D8 $90 $FD $90 $26 $91 $09 $D0 $F0 $FF $28 $D0 $F8 $FF $2A $D0
.db $00 $00 $2C $E0 $F1 $FF $2E $E0 $F9 $FF $30 $E0 $01 $00 $32 $F0
.db $FA $FF $34 $F0 $FE $FF $36 $F0 $06 $00 $38 $0A $D0 $F0 $FF $28
.db $D0 $F8 $FF $2A $D0 $00 $00 $2C $E0 $F2 $FF $3A $E0 $FA $FF $3C
.db $E0 $02 $00 $3E $F0 $F0 $FF $40 $F0 $FA $FF $42 $F0 $02 $00 $44
.db $F0 $0A $00 $46 $0A $D8 $E8 $FF $28 $D8 $F0 $FF $48 $D8 $F8 $FF
.db $4A $D9 $00 $00 $4C $E0 $08 $00 $4E $E0 $10 $00 $50 $E8 $F0 $FF
.db $52 $E8 $F8 $FF $54 $E9 $00 $00 $56 $F0 $08 $00 $58

; Data from 914F to 91CB (125 bytes)
_DATA_914F:
.db $55 $91 $7A $91 $A3 $91 $09 $D0 $F8 $FF $5E $D0 $00 $00 $5C $D0
.db $08 $00 $5A $E0 $F7 $FF $64 $E0 $FF $FF $62 $E0 $07 $00 $60 $F0
.db $F2 $FF $6A $F0 $FA $FF $68 $F0 $02 $00 $66 $0A $D0 $F8 $FF $5E
.db $D0 $00 $00 $5C $D0 $08 $00 $5A $E0 $F6 $FF $70 $E0 $FE $FF $6E
.db $E0 $06 $00 $6C $F0 $F0 $FF $78 $F0 $F6 $FF $76 $F0 $FE $FF $74
.db $F0 $06 $00 $72 $0A $D8 $00 $00 $7C $D8 $08 $00 $7A $D8 $10 $00
.db $5A $D9 $F8 $FF $7E $E0 $E8 $FF $82 $E0 $F0 $FF $80 $E8 $00 $00
.db $86 $E8 $08 $00 $84 $E9 $F8 $FF $88 $F0 $F0 $FF $8A

; Data from 91CC to 925A (143 bytes)
_DATA_91CC:
.db $D0 $91 $DD $91 $03 $F0 $F4 $FF $50 $F0 $FC $FF $52 $F0 $04 $00
.db $54 $03 $F0 $F4 $FF $56 $F0 $FC $FF $58 $F0 $04 $00 $5A $F0 $91
.db $11 $92 $36 $92 $08 $D0 $F4 $FF $28 $D0 $FC $FF $2A $D0 $04 $00
.db $2C $E0 $F4 $FF $2E $E0 $FC $FF $30 $E0 $04 $00 $32 $F0 $F8 $FF
.db $34 $F0 $00 $00 $36 $09 $D0 $F4 $FF $28 $D0 $FC $FF $2A $D0 $04
.db $00 $2C $E0 $F4 $FF $38 $E0 $FC $FF $3A $E0 $04 $00 $3C $F0 $F4
.db $FF $3E $F0 $FC $FF $40 $F0 $04 $00 $42 $09 $D0 $F4 $FF $44 $D0
.db $FC $FF $46 $D0 $04 $00 $48 $E0 $F4 $FF $4A $E0 $FC $FF $4C $E0
.db $04 $00 $4E $F0 $F4 $FF $3E $F0 $FC $FF $40 $F0 $04 $00 $42

; Data from 925B to 9278 (30 bytes)
_DATA_925B:
.db $5F $92 $6C $92 $03 $F0 $F4 $FF $88 $F0 $FC $FF $86 $F0 $04 $00
.db $84 $03 $F0 $F4 $FF $8E $F0 $FC $FF $8C $F0 $04 $00 $8A

; Data from 9279 to 92E9 (113 bytes)
_DATA_9279:
.db $7F $92 $A0 $92 $C5 $92 $08 $D0 $F4 $FF $60 $D0 $FC $FF $5E $D0
.db $04 $00 $5C $E0 $F4 $FF $66 $E0 $FC $FF $64 $E0 $04 $00 $62 $F0
.db $F8 $FF $6A $F0 $00 $00 $68 $09 $D0 $F4 $FF $60 $D0 $FC $FF $5E
.db $D0 $04 $00 $5C $E0 $F4 $FF $70 $E0 $FC $FF $6E $E0 $04 $00 $6C
.db $F0 $F4 $FF $76 $F0 $FC $FF $74 $F0 $04 $00 $72 $09 $D0 $F4 $FF
.db $7C $D0 $FC $FF $7A $D0 $04 $00 $78 $E0 $F4 $FF $82 $E0 $FC $FF
.db $80 $E0 $04 $00 $7E $F0 $F4 $FF $76 $F0 $FC $FF $74 $F0 $04 $00
.db $72

; Data from 92EA to 935A (113 bytes)
_DATA_92EA:
.db $F0 $92 $15 $93 $36 $93 $09 $D0 $F4 $FF $7C $D0 $FC $FF $7E $D0
.db $04 $00 $80 $E0 $F4 $FF $82 $E0 $FC $FF $84 $E0 $04 $00 $86 $F0
.db $F4 $FF $88 $F0 $FC $FF $8A $F0 $04 $00 $8C $08 $D0 $F4 $FF $7C
.db $D0 $FC $FF $7E $D0 $04 $00 $80 $E0 $F4 $FF $8E $E0 $FC $FF $90
.db $E0 $04 $00 $92 $F0 $F8 $FF $94 $F0 $00 $00 $96 $09 $D0 $F4 $FF
.db $7C $D0 $FC $FF $7E $D0 $04 $00 $80 $E0 $F4 $FF $82 $E0 $FC $FF
.db $98 $E0 $04 $00 $86 $F0 $F4 $FF $88 $F0 $FC $FF $8A $F0 $04 $00
.db $8C

; Data from 935B to 93CB (113 bytes)
_DATA_935B:
.db $61 $93 $86 $93 $A7 $93 $09 $D0 $F4 $FF $A0 $D0 $FC $FF $9E $D0
.db $04 $00 $9C $E0 $F4 $FF $A6 $E0 $FC $FF $A4 $E0 $04 $00 $A2 $F0
.db $F4 $FF $AC $F0 $FC $FF $AA $F0 $04 $00 $A8 $08 $D0 $F4 $FF $A0
.db $D0 $FC $FF $9E $D0 $04 $00 $9C $E0 $F4 $FF $B2 $E0 $FC $FF $B0
.db $E0 $04 $00 $AE $F0 $F8 $FF $B6 $F0 $00 $00 $B4 $09 $D0 $F4 $FF
.db $A0 $D0 $FC $FF $9E $D0 $04 $00 $9C $E0 $F4 $FF $A6 $E0 $FC $FF
.db $B8 $E0 $04 $00 $A2 $F0 $F4 $FF $AC $F0 $FC $FF $AA $F0 $04 $00
.db $A8

; Data from 93CC to 93D9 (14 bytes)
_DATA_93CC:
.db $D0 $93 $D5 $93 $01 $F0 $FC $FF $AE $01 $F0 $FC $FF $B0

; Data from 93DA to 941F (70 bytes)
_DATA_93DA:
.db $DE $93 $FF $93 $08 $E0 $F0 $FF $90 $E0 $F8 $FF $92 $E0 $00 $00
.db $94 $E0 $08 $00 $96 $F0 $F0 $FF $A0 $F0 $F8 $FF $A2 $F0 $00 $00
.db $A4 $F0 $08 $00 $A6 $08 $E0 $F0 $FF $98 $E0 $F8 $FF $9A $E0 $00
.db $00 $9C $E0 $08 $00 $9E $F0 $F0 $FF $A0 $F0 $F8 $FF $A2 $F0 $00
.db $00 $A8 $F0 $08 $00 $AA

; Data from 9420 to 9465 (70 bytes)
_DATA_9420:
.db $24 $94 $45 $94 $08 $E0 $F0 $FF $B2 $E0 $F8 $FF $B0 $E0 $00 $00
.db $AE $E0 $08 $00 $AC $F0 $F0 $FF $C2 $F0 $F8 $FF $C0 $F0 $00 $00
.db $BE $F0 $08 $00 $BC $08 $E0 $F0 $FF $BA $E0 $F8 $FF $B8 $E0 $00
.db $00 $B6 $E0 $08 $00 $B4 $F0 $F0 $FF $C6 $F0 $F8 $FF $C4 $F0 $00
.db $00 $BE $F0 $08 $00 $BC

; Data from 9466 to 9492 (45 bytes)
_DATA_9466:
.db $6C $94 $7D $94 $8E $94 $04 $F0 $F0 $FF $D8 $F0 $F8 $FF $DA $F0
.db $00 $00 $DC $F0 $08 $00 $DE $04 $F0 $F0 $FF $E0 $F0 $F8 $FF $E2
.db $F0 $00 $00 $DE $F0 $08 $00 $E4 $01 $F0 $FC $FF $E6

; Data from 9493 to 94BF (45 bytes)
_DATA_9493:
.db $99 $94 $AA $94 $BB $94 $04 $F0 $F0 $FF $EE $F0 $F8 $FF $EC $F0
.db $00 $00 $EA $F0 $08 $00 $E8 $04 $F0 $F0 $FF $F4 $F0 $F8 $FF $EE
.db $F0 $00 $00 $F2 $F0 $08 $00 $F0 $01 $F0 $FC $FF $F6

; Data from 94C0 to 94D8 (25 bytes)
_DATA_94C0:
.db $C6 $94 $CB $94 $D0 $94 $01 $F0 $FC $FF $20 $01 $F0 $FC $FF $22
.db $02 $F0 $F8 $FF $24 $F0 $00 $00 $26

; Data from 94D9 to 94DF (7 bytes)
_DATA_94D9:
.db $DB $94 $01 $F0 $FC $FF $9A

; Data from 94E0 to 94E6 (7 bytes)
_DATA_94E0:
.db $E2 $94 $01 $F0 $FC $FF $BA

; Data from 94E7 to 9502 (28 bytes)
_DATA_94E7:
.db $EF $94 $F4 $94 $F9 $94 $FE $94 $01 $F0 $FC $FF $4A $01 $F0 $FC
.db $FF $4C $01 $F0 $FC $FF $4E $01 $F0 $FC $FF $50

; Data from 9503 to 975D (603 bytes)
_DATA_9503:
.db $0B $95 $10 $95 $15 $95 $1A $95 $01 $F0 $FC $FF $74 $01 $F0 $FC
.db $FF $76 $01 $F0 $FC $FF $78 $01 $F0 $FC $FF $7A $25 $95 $72 $95
.db $BF $95 $13 $B0 $F4 $FF $20 $B0 $FC $FF $22 $B0 $04 $00 $24 $C0
.db $F0 $FF $26 $C0 $F8 $FF $28 $C0 $00 $00 $2A $C0 $08 $00 $2C $D0
.db $F0 $FF $2E $D0 $F8 $FF $30 $D0 $00 $00 $7E $D0 $08 $00 $80 $E0
.db $F0 $FF $36 $E0 $F8 $FF $38 $E0 $00 $00 $3A $E0 $08 $00 $3C $F0
.db $EF $FF $3E $F0 $F7 $FF $40 $F0 $FF $FF $42 $F0 $07 $00 $44 $13
.db $B0 $F4 $FF $20 $B0 $FC $FF $22 $B0 $04 $00 $24 $C0 $F0 $FF $26
.db $C0 $F8 $FF $28 $C0 $00 $00 $2A $C0 $08 $00 $2C $D0 $F0 $FF $2E
.db $D0 $F8 $FF $30 $D0 $00 $00 $32 $D0 $08 $00 $34 $E0 $F0 $FF $36
.db $E0 $F8 $FF $38 $E0 $00 $00 $3A $E0 $08 $00 $3C $F0 $EF $FF $3E
.db $F0 $F7 $FF $40 $F0 $FF $FF $42 $F0 $07 $00 $44 $13 $B0 $F4 $FF
.db $20 $B0 $FC $FF $22 $B0 $04 $00 $24 $C0 $F0 $FF $26 $C0 $F8 $FF
.db $28 $C0 $00 $00 $2A $C0 $08 $00 $2C $D0 $F0 $FF $2E $D0 $F8 $FF
.db $30 $D0 $00 $00 $7A $D0 $08 $00 $78 $E0 $F0 $FF $36 $E0 $F8 $FF
.db $38 $E0 $00 $00 $7E $E0 $08 $00 $7C $F0 $EF $FF $3E $F0 $F7 $FF
.db $40 $F0 $FF $FF $42 $F0 $07 $00 $44 $12 $96 $63 $96 $B4 $96 $14
.db $B0 $EC $FF $5E $B0 $F4 $FF $60 $B0 $FC $FF $22 $B0 $04 $00 $24
.db $C0 $F0 $FF $62 $C0 $F8 $FF $64 $C0 $00 $00 $2A $C0 $08 $00 $2C
.db $D0 $F0 $FF $66 $D0 $F8 $FF $68 $D0 $00 $00 $32 $D0 $08 $00 $34
.db $E0 $F0 $FF $58 $E0 $F8 $FF $5A $E0 $00 $00 $3A $E0 $08 $00 $3C
.db $F0 $EF $FF $6A $F0 $F7 $FF $72 $F0 $FF $FF $74 $F0 $07 $00 $76
.db $14 $B0 $EC $FF $5E $B0 $F4 $FF $60 $B0 $FC $FF $22 $B0 $04 $00
.db $24 $C0 $F0 $FF $62 $C0 $F8 $FF $64 $C0 $00 $00 $2A $C0 $08 $00
.db $2C $D0 $F0 $FF $66 $D0 $F8 $FF $68 $D0 $00 $00 $32 $D0 $08 $00
.db $34 $E0 $F0 $FF $58 $E0 $F8 $FF $5A $E0 $00 $00 $3A $E0 $08 $00
.db $3C $F0 $EF $FF $6A $F0 $F7 $FF $6C $F0 $FF $FF $6E $F0 $07 $00
.db $70 $15 $B0 $F4 $FF $20 $B0 $FC $FF $22 $B0 $04 $00 $24 $C0 $F0
.db $FF $26 $C0 $F8 $FF $46 $C0 $00 $00 $48 $C0 $08 $00 $4A $C2 $10
.db $00 $4C $C2 $18 $00 $4E $D0 $F0 $FF $50 $D0 $F8 $FF $52 $D0 $00
.db $00 $54 $D0 $08 $00 $56 $E0 $F0 $FF $58 $E0 $F8 $FF $5A $E0 $00
.db $00 $5C $E0 $08 $00 $3C $F0 $EF $FF $6A $F0 $F7 $FF $72 $F0 $FF
.db $FF $74 $F0 $07 $00 $76 $15 $B0 $F4 $FF $20 $B0 $FC $FF $22 $B0
.db $04 $00 $24 $C0 $F0 $FF $26 $C0 $F8 $FF $46 $C0 $00 $00 $48 $C0
.db $08 $00 $4A $C2 $10 $00 $4C $C2 $18 $00 $4E $D0 $F0 $FF $50 $D0
.db $F8 $FF $52 $D0 $00 $00 $54 $D0 $08 $00 $56 $E0 $F0 $FF $58 $E0
.db $F8 $FF $5A $E0 $00 $00 $5C $E0 $08 $00 $3C $F0 $EF $FF $6A $F0
.db $F7 $FF $6C $F0 $FF $FF $6E $F0 $07 $00 $70

; Data from 975E to 9773 (22 bytes)
_DATA_975E:
.db $62 $97 $6B $97 $02 $F0 $F8 $FF $82 $F0 $00 $00 $84 $02 $F0 $F8
.db $FF $86 $F0 $00 $00 $88

; Data from 9774 to 984F (220 bytes)
_DATA_9774:
.db $78 $97 $7D $97 $01 $F0 $F8 $FF $8A $01 $F0 $F8 $FF $8C $86 $97
.db $A3 $97 $07 $D0 $F7 $FF $20 $D0 $FF $FF $22 $E0 $F8 $FF $24 $E0
.db $00 $00 $26 $F0 $F4 $FF $28 $F0 $FC $FF $2A $F0 $04 $00 $2C $07
.db $D0 $F7 $FF $2E $D0 $FF $FF $30 $E0 $F8 $FF $32 $E0 $00 $00 $34
.db $F0 $F4 $FF $36 $F0 $FC $FF $38 $F0 $04 $00 $3A $CC $97 $ED $97
.db $0E $98 $2F $98 $0E $98 $ED $97 $08 $D8 $F4 $FF $3C $D8 $FC $FF
.db $3E $E0 $04 $00 $48 $E8 $F4 $FF $40 $E8 $FC $FF $42 $F0 $04 $00
.db $4A $F8 $F4 $FF $44 $F8 $FC $FF $46 $08 $D8 $F4 $FF $3C $D8 $FC
.db $FF $3E $E0 $04 $00 $48 $E8 $F4 $FF $40 $E8 $FC $FF $4C $F0 $04
.db $00 $4A $F8 $F4 $FF $44 $F8 $FC $FF $46 $08 $D8 $F4 $FF $3C $D8
.db $FC $FF $3E $E0 $04 $00 $52 $E8 $F4 $FF $4E $E8 $FC $FF $50 $F0
.db $04 $00 $54 $F8 $F4 $FF $44 $F8 $FC $FF $46 $08 $D8 $F4 $FF $3C
.db $D8 $FC $FF $3E $E0 $04 $00 $5A $E8 $F4 $FF $56 $E8 $FC $FF $58
.db $F0 $04 $00 $5C $F8 $F4 $FF $44 $F8 $FC $FF $46

; Data from 9850 to 991D (206 bytes)
_DATA_9850:
.db $54 $98 $71 $98 $07 $D0 $F9 $FF $86 $D0 $01 $00 $84 $E0 $F8 $FF
.db $8A $E0 $00 $00 $88 $F0 $F4 $FF $90 $F0 $FC $FF $8E $F0 $04 $00
.db $8C $07 $D0 $F9 $FF $94 $D0 $01 $00 $92 $E0 $F8 $FF $98 $E0 $00
.db $00 $96 $F0 $F4 $FF $9E $F0 $FC $FF $9C $F0 $04 $00 $9A $9A $98
.db $BB $98 $DC $98 $FD $98 $DC $98 $BB $98 $08 $D8 $FC $FF $A2 $D8
.db $04 $00 $A0 $E0 $F4 $FF $AC $E8 $FC $FF $A6 $E8 $04 $00 $A4 $F0
.db $F4 $FF $AE $F8 $FC $FF $AA $F8 $04 $00 $A8 $08 $D8 $FC $FF $A2
.db $D8 $04 $00 $A0 $E0 $F4 $FF $AC $E8 $FC $FF $B0 $E8 $04 $00 $A4
.db $F0 $F4 $FF $AE $F8 $FC $FF $AA $F8 $04 $00 $A8 $08 $D8 $FC $FF
.db $A2 $D8 $04 $00 $A0 $E0 $F4 $FF $B6 $E8 $FC $FF $B4 $E8 $04 $00
.db $B2 $F0 $F4 $FF $B8 $F8 $FC $FF $AA $F8 $04 $00 $A8 $08 $D8 $FC
.db $FF $A2 $D8 $04 $00 $A0 $E0 $F4 $FF $BE $E8 $FC $FF $BC $E8 $04
.db $00 $BA $F0 $F4 $FF $C0 $F8 $FC $FF $AA $F8 $04 $00 $A8

; Data from 991E to 9925 (8 bytes)
_DATA_991E:
.db $61 $99 $44 $99 $33 $99 $2E $99

; Data from 9926 to 995C (55 bytes)
_DATA_9926:
.db $2E $99 $33 $99 $44 $99 $61 $99 $01 $F0 $F8 $FF $5E $04 $E0 $F8
.db $FF $5E $F0 $F4 $FF $60 $F0 $FC $FF $62 $F0 $04 $00 $64 $06 $D0
.db $F8 $FF $5E $E0 $F4 $FF $60 $E0 $FC $FF $62 $E0 $04 $00 $64 $F0
.db $FC $FF $66 $F0 $04 $00 $68

; Data from 995D to 99AE (82 bytes)
_DATA_995D:
.db $61 $99 $82 $99 $08 $C0 $F8 $FF $5E $D0 $F4 $FF $60 $D0 $FC $FF
.db $62 $D0 $04 $00 $64 $E0 $FC $FF $66 $E0 $04 $00 $68 $F0 $FC $FF
.db $6A $F0 $04 $00 $6C $0B $D0 $F4 $FF $72 $D0 $FC $FF $74 $D0 $04
.db $00 $76 $D8 $E4 $FF $6E $D8 $EC $FF $70 $E0 $F4 $FF $78 $E0 $FC
.db $FF $7A $E0 $04 $00 $7C $F0 $F4 $FF $7E $F0 $FC $FF $80 $F0 $04
.db $00 $82

; Data from 99AF to 99B6 (8 bytes)
_DATA_99AF:
.db $F2 $99 $D5 $99 $C4 $99 $BF $99

; Data from 99B7 to 99ED (55 bytes)
_DATA_99B7:
.db $BF $99 $C4 $99 $D5 $99 $F2 $99 $01 $F0 $00 $00 $C2 $04 $E0 $00
.db $00 $C2 $F0 $F4 $FF $C8 $F0 $FC $FF $C6 $F0 $04 $00 $C4 $06 $D0
.db $00 $00 $C2 $E0 $F4 $FF $C8 $E0 $FC $FF $C6 $E0 $04 $00 $C4 $F0
.db $F4 $FF $CC $F0 $FC $FF $CA

; Data from 99EE to 9F01 (1300 bytes)
_DATA_99EE:
.incbin "banks\lots_DATA_99EE.inc"

; Data from 9F02 to A0B2 (433 bytes)
_DATA_9F02:
.db $06 $9F $57 $9F $14 $B0 $EE $FF $20 $B0 $F6 $FF $22 $B0 $FE $FF
.db $24 $B0 $06 $00 $26 $C0 $EE $FF $28 $C0 $F6 $FF $2A $C0 $FE $FF
.db $2C $C0 $06 $00 $2E $D0 $EE $FF $30 $D0 $F6 $FF $32 $D0 $FE $FF
.db $34 $D0 $06 $00 $36 $E0 $F0 $FF $5C $E0 $F8 $FF $5E $E0 $00 $00
.db $60 $E0 $08 $00 $62 $F0 $F0 $FF $64 $F0 $F8 $FF $66 $F0 $00 $00
.db $68 $F0 $08 $00 $6A $12 $B0 $F0 $FF $20 $B0 $F8 $FF $22 $B0 $00
.db $00 $24 $B0 $08 $00 $26 $C0 $F0 $FF $28 $C0 $F8 $FF $2A $C0 $00
.db $00 $2C $C0 $08 $00 $2E $D0 $F0 $FF $30 $D0 $F8 $FF $32 $D0 $00
.db $00 $34 $D0 $08 $00 $36 $E0 $F8 $FF $6C $E0 $00 $00 $6E $E0 $08
.db $00 $70 $F0 $F8 $FF $72 $F0 $00 $00 $74 $F0 $08 $00 $76 $57 $9F
.db $AA $9F $F7 $9F $AA $9F $57 $9F $13 $B0 $F4 $FF $20 $B0 $FC $FF
.db $38 $B0 $04 $00 $3A $B0 $0C $00 $3C $C0 $EC $FF $3E $C0 $F4 $FF
.db $40 $C0 $FC $FF $42 $C0 $04 $00 $44 $C0 $0C $00 $2E $D0 $F4 $FF
.db $46 $D0 $FC $FF $48 $D0 $04 $00 $34 $D0 $0C $00 $36 $E0 $FC $FF
.db $6C $E0 $04 $00 $6E $E0 $0C $00 $70 $F0 $FC $FF $72 $F0 $04 $00
.db $74 $F0 $0C $00 $76 $17 $B0 $F4 $FF $20 $B0 $FC $FF $22 $B0 $04
.db $00 $3A $B0 $0C $00 $3C $C0 $EC $FF $4A $C0 $F4 $FF $4C $C0 $FC
.db $FF $4E $C0 $04 $00 $44 $C0 $0C $00 $2E $D6 $E4 $FF $56 $D0 $EC
.db $FF $50 $D0 $F4 $FF $52 $D0 $FC $FF $48 $D0 $04 $00 $34 $D0 $0C
.db $00 $36 $E6 $DC $FF $58 $E0 $FC $FF $6C $E0 $04 $00 $6E $E0 $0C
.db $00 $70 $E6 $E4 $FF $5A $F0 $FC $FF $72 $F0 $04 $00 $74 $F0 $0C
.db $00 $76 $57 $9F $AA $9F $5E $A0 $AA $9F $57 $9F $15 $B0 $F4 $FF
.db $20 $B0 $FC $FF $22 $B0 $04 $00 $3A $B0 $0C $00 $3C $C0 $EC $FF
.db $4A $C0 $F4 $FF $4C $C0 $FC $FF $4E $C0 $04 $00 $44 $C0 $0C $00
.db $2E $D0 $E4 $FF $54 $D0 $EC $FF $50 $D0 $F4 $FF $52 $D0 $FC $FF
.db $48 $D0 $04 $00 $34 $D0 $0C $00 $36 $E0 $FC $FF $6C $E0 $04 $00
.db $6E $E0 $0C $00 $70 $F0 $FC $FF $72 $F0 $04 $00 $74 $F0 $0C $00
.db $76

; Data from A0B3 to A4DC (1066 bytes)
_DATA_A0B3:
.incbin "banks\lots_DATA_A0B3.inc"

; Data from A4DD to ADE7 (2315 bytes)
_DATA_A4DD:
.incbin "banks\lots_DATA_A4DD.inc"

; Data from ADE8 to AE41 (90 bytes)
_DATA_ADE8:
.db $EC $AD $15 $AE $0A $D0 $F4 $FF $20 $D0 $FC $FF $22 $D0 $04 $00
.db $24 $E0 $F4 $FF $26 $E0 $FC $FF $28 $E0 $04 $00 $2A $E0 $0C $00
.db $2C $F0 $F4 $FF $2E $F0 $FC $FF $30 $F0 $04 $00 $32 $09 $D0 $F4
.db $FF $4C $D0 $FC $FF $4E $D0 $04 $00 $50 $D0 $0C $00 $52 $E0 $F8
.db $FF $54 $E0 $00 $00 $56 $F0 $F4 $FF $2E $F0 $FC $FF $30 $F0 $04
.db $00 $32 $EC $AD $F7 $8D $25 $AF $F7 $8D

; Data from AE42 to B05C (539 bytes)
_DATA_AE42:
.db $EC $AD $4A $AE $73 $AE $9C $AE $0A $D0 $F4 $FF $20 $D0 $FC $FF
.db $22 $D0 $04 $00 $24 $E0 $F4 $FF $34 $E0 $FC $FF $36 $E0 $04 $00
.db $38 $E0 $0C $00 $3A $F0 $F4 $FF $2E $F0 $FC $FF $30 $F0 $04 $00
.db $32 $0A $D0 $F4 $FF $20 $D0 $FC $FF $22 $D0 $04 $00 $24 $E0 $F4
.db $FF $3C $E0 $FC $FF $3E $E0 $04 $00 $40 $E0 $0C $00 $42 $F0 $F4
.db $FF $2E $F0 $FC $FF $30 $F0 $04 $00 $32 $0A $D0 $F4 $FF $20 $D0
.db $FC $FF $22 $D0 $04 $00 $24 $E0 $F8 $FF $44 $E0 $00 $00 $46 $E0
.db $08 $00 $48 $E0 $10 $00 $4A $F0 $F4 $FF $2E $F0 $FC $FF $30 $F0
.db $04 $00 $32 $EC $AD $CB $AE $F4 $AE $0A $D0 $F4 $FF $20 $D0 $FC
.db $FF $22 $D0 $04 $00 $24 $E0 $F4 $FF $3C $E0 $FC $FF $3E $E0 $04
.db $00 $58 $E0 $0C $00 $5A $F0 $F4 $FF $2E $F0 $FC $FF $30 $F0 $04
.db $00 $5C $0B $D0 $F4 $FF $20 $D0 $FC $FF $22 $D0 $04 $00 $24 $E0
.db $F4 $FF $5E $E0 $FC $FF $60 $E0 $04 $00 $62 $E0 $0C $00 $64 $E0
.db $14 $00 $66 $F0 $F4 $FF $2E $F0 $FC $FF $30 $F0 $04 $00 $32 $25
.db $AF $4E $AF $0A $D0 $F4 $FF $80 $D0 $FC $FF $7E $D0 $04 $00 $7C
.db $E0 $EC $FF $88 $E0 $F4 $FF $86 $E0 $FC $FF $84 $E0 $04 $00 $82
.db $F0 $F4 $FF $8E $F0 $FC $FF $8C $F0 $04 $00 $8A $09 $D0 $EC $FF
.db $AE $D0 $F4 $FF $AC $D0 $FC $FF $AA $D0 $04 $00 $A8 $E0 $F8 $FF
.db $B2 $E0 $00 $00 $B0 $F0 $F4 $FF $8E $F0 $FC $FF $8C $F0 $04 $00
.db $8A $25 $AF $7B $AF $A4 $AF $CD $AF $0A $D0 $F4 $FF $80 $D0 $FC
.db $FF $7E $D0 $04 $00 $7C $E0 $EC $FF $96 $E0 $F4 $FF $94 $E0 $FC
.db $FF $92 $E0 $04 $00 $90 $F0 $F4 $FF $8E $F0 $FC $FF $8C $F0 $04
.db $00 $8A $0A $D0 $F4 $FF $80 $D0 $FC $FF $7E $D0 $04 $00 $7C $E0
.db $EC $FF $9E $E0 $F4 $FF $9C $E0 $FC $FF $9A $E0 $04 $00 $98 $F0
.db $F4 $FF $8E $F0 $FC $FF $8C $F0 $04 $00 $8A $0A $D0 $F4 $FF $80
.db $D0 $FC $FF $7E $D0 $04 $00 $7C $E0 $EC $FF $A6 $E0 $F0 $FF $A4
.db $E0 $F8 $FF $A2 $E0 $00 $00 $A0 $F0 $F4 $FF $8E $F0 $FC $FF $8C
.db $F0 $04 $00 $8A $25 $AF $FC $AF $25 $B0 $0A $D0 $F4 $FF $80 $D0
.db $FC $FF $7E $D0 $04 $00 $7C $E0 $EC $FF $B6 $E0 $F4 $FF $B4 $E0
.db $FC $FF $9A $E0 $04 $00 $98 $F0 $F4 $FF $B8 $F0 $FC $FF $8C $F0
.db $04 $00 $8A $0B $D0 $F4 $FF $80 $D0 $FC $FF $7E $D0 $04 $00 $7C
.db $E0 $E4 $FF $C2 $E0 $EC $FF $C0 $E0 $F4 $FF $BE $E0 $FC $FF $BC
.db $E0 $04 $00 $BA $F0 $F4 $FF $8E $F0 $FC $FF $8C $F0 $04 $00 $8A
.db $54 $B0 $02 $F0 $F8 $FF $68 $F0 $00 $00 $6A

; Data from B05D to B072 (22 bytes)
_DATA_B05D:
.db $61 $B0 $6A $B0 $02 $F0 $F8 $FF $6C $F0 $00 $00 $6E $02 $F0 $F8
.db $FF $70 $F0 $00 $00 $72

; Data from B073 to B07D (11 bytes)
_DATA_B073:
.db $75 $B0 $02 $F0 $F8 $FF $C6 $F0 $00 $00 $C4

; Data from B07E to B0CB (78 bytes)
_DATA_B07E:
.db $82 $B0 $8B $B0 $02 $F0 $F8 $FF $CA $F0 $00 $00 $C8 $02 $F0 $F8
.db $FF $CE $F0 $00 $00 $CC $9C $B0 $A1 $B0 $A6 $B0 $AB $B0 $01 $F0
.db $FC $FF $74 $01 $F0 $FC $FF $76 $01 $F0 $FC $FF $78 $01 $F0 $FC
.db $FF $7A $B8 $B0 $BD $B0 $C2 $B0 $C7 $B0 $01 $F0 $FC $FF $D0 $01
.db $F0 $FC $FF $D2 $01 $F0 $FC $FF $D4 $01 $F0 $FC $FF $D6

; Data from B0CC to B335 (618 bytes)
_DATA_B0CC:
.db $CE $B0 $10 $B0 $F6 $FF $20 $B0 $FE $FF $22 $C0 $F0 $FF $24 $C0
.db $F8 $FF $26 $C0 $00 $00 $28 $C0 $08 $00 $2A $D0 $F0 $FF $2C $D0
.db $F8 $FF $2E $D0 $00 $00 $30 $D0 $08 $00 $32 $E0 $F4 $FF $34 $E0
.db $FC $FF $36 $E0 $04 $00 $38 $F0 $F4 $FF $3A $F0 $FC $FF $3C $F0
.db $04 $00 $3E $13 $B1 $4C $B1 $0E $B0 $F4 $FF $5C $B0 $FC $FF $5E
.db $C0 $F4 $FF $60 $C0 $FC $FF $62 $C0 $04 $00 $64 $D0 $F4 $FF $66
.db $D0 $FC $FF $68 $D0 $04 $00 $6A $E0 $F4 $FF $6C $E0 $FC $FF $6E
.db $E0 $04 $00 $70 $F0 $F4 $FF $72 $F0 $FC $FF $74 $F0 $04 $00 $76
.db $0E $B0 $F4 $FF $40 $B0 $FC $FF $42 $C0 $F4 $FF $44 $C0 $FC $FF
.db $46 $C0 $04 $00 $48 $D0 $F4 $FF $4A $D0 $FC $FF $4C $D0 $04 $00
.db $4E $E0 $F4 $FF $50 $E0 $FC $FF $52 $E0 $04 $00 $54 $F0 $F4 $FF
.db $56 $F0 $FC $FF $58 $F0 $04 $00 $5A $CE $B0 $8B $B1 $C0 $B1 $0D
.db $B0 $F6 $FF $20 $B0 $FE $FF $22 $C0 $F0 $FF $78 $C0 $F8 $FF $7A
.db $C0 $00 $00 $7C $D0 $F8 $FF $2E $D0 $00 $00 $30 $E0 $F4 $FF $34
.db $E0 $FC $FF $36 $E0 $04 $00 $38 $F0 $F4 $FF $3A $F0 $FC $FF $3C
.db $F0 $04 $00 $3E $0E $B0 $F6 $FF $20 $B0 $FE $FF $22 $C0 $E8 $FF
.db $8A $C0 $F0 $FF $8C $C0 $F8 $FF $8E $C0 $00 $00 $90 $D0 $F8 $FF
.db $2E $D0 $00 $00 $30 $E0 $F4 $FF $34 $E0 $FC $FF $36 $E0 $04 $00
.db $38 $F0 $F4 $FF $3A $F0 $FC $FF $3C $F0 $04 $00 $3E $CE $B0 $C0
.db $B1 $8B $B1 $01 $B2 $10 $B0 $FA $FF $A0 $B0 $02 $00 $9E $C0 $F0
.db $FF $A8 $C0 $F8 $FF $A6 $C0 $00 $00 $A4 $C0 $08 $00 $A2 $D0 $F0
.db $FF $B0 $D0 $F8 $FF $AE $D0 $00 $00 $AC $D0 $08 $00 $AA $E0 $F4
.db $FF $B6 $E0 $FC $FF $B4 $E0 $04 $00 $B2 $F0 $F4 $FF $BC $F0 $FC
.db $FF $BA $F0 $04 $00 $B8 $46 $B2 $7F $B2 $0E $B0 $FC $FF $DC $B0
.db $04 $00 $DA $C0 $F4 $FF $E2 $C0 $FC $FF $E0 $C0 $04 $00 $DE $D0
.db $F4 $FF $E8 $D0 $FC $FF $E6 $D0 $04 $00 $E4 $E0 $F4 $FF $EE $E0
.db $FC $FF $EC $E0 $04 $00 $EA $F0 $F4 $FF $F4 $F0 $FC $FF $F2 $F0
.db $04 $00 $F0 $0E $B0 $FC $FF $C0 $B0 $04 $00 $BE $C0 $F4 $FF $C6
.db $C0 $FC $FF $C4 $C0 $04 $00 $C2 $D0 $F4 $FF $CC $D0 $FC $FF $CA
.db $D0 $04 $00 $C8 $E0 $F4 $FF $D2 $E0 $FC $FF $D0 $E0 $04 $00 $CE
.db $F0 $F4 $FF $D8 $F0 $FC $FF $D6 $F0 $04 $00 $D4 $01 $B2 $F9 $B2
.db $C4 $B2 $01 $B2 $C4 $B2 $F9 $B2 $0D $B0 $FA $FF $A0 $B0 $02 $00
.db $9E $C0 $F8 $FF $FA $C0 $00 $00 $F8 $C0 $08 $00 $F6 $D0 $F8 $FF
.db $AE $D0 $00 $00 $AC $E0 $F4 $FF $B6 $E0 $FC $FF $B4 $E0 $04 $00
.db $B2 $F0 $F4 $FF $BC $F0 $FC $FF $BA $F0 $04 $00 $B8 $0F $B0 $FA
.db $FF $A0 $B0 $02 $00 $9E $C0 $F0 $FF $80 $C0 $F8 $FF $82 $C0 $00
.db $00 $84 $C0 $08 $00 $86 $C0 $10 $00 $88 $D0 $F8 $FF $AE $D0 $00
.db $00 $AC $E0 $F4 $FF $B6 $E0 $FC $FF $B4 $E0 $04 $00 $B2 $F0 $F4
.db $FF $BC $F0 $FC $FF $BA $F0 $04 $00 $B8

; Data from B336 to B34C (23 bytes)
_DATA_B336:
.db $38 $B3 $05 $B0 $E8 $FF $7E $C0 $E8 $FF $7E $D0 $E8 $FF $7E $E0
.db $E8 $FF $7E $F0 $E8 $FF $7E

; Data from B34D to B35B (15 bytes)
_DATA_B34D:
.db $4F $B3 $03 $C0 $18 $00 $FC $D0 $18 $00 $FC $E0 $18 $00 $FC

; Data from B35C to B366 (11 bytes)
_DATA_B35C:
.db $5E $B3 $02 $F0 $F8 $FF $9A $F0 $00 $00 $9C

; Data from B367 to B602 (668 bytes)
_DATA_B367:
.db $69 $B3 $04 $E0 $F8 $FF $92 $E0 $00 $00 $94 $F0 $F8 $FF $96 $F0
.db $00 $00 $98 $90 $B3 $C9 $B3 $02 $B4 $3B $B4 $74 $B4 $AD $B4 $E6
.db $B4 $1F $B5 $58 $B5 $91 $B5 $CA $B5 $0E $E0 $E0 $FF $20 $E0 $E8
.db $FF $22 $E0 $F0 $FF $24 $E0 $F8 $FF $26 $E0 $00 $00 $28 $E0 $08
.db $00 $2A $E0 $10 $00 $2C $F0 $E0 $FF $2E $F0 $E8 $FF $30 $F0 $F0
.db $FF $32 $F0 $F8 $FF $34 $F0 $00 $00 $36 $F0 $08 $00 $38 $F0 $10
.db $00 $3A $0E $E0 $E0 $FF $20 $E0 $E8 $FF $22 $E0 $F0 $FF $24 $E0
.db $F8 $FF $26 $E0 $00 $00 $28 $E0 $08 $00 $2A $E0 $10 $00 $2C $F0
.db $E0 $FF $2E $F0 $E8 $FF $3C $F0 $F0 $FF $3E $F0 $F8 $FF $40 $F0
.db $00 $00 $42 $F0 $08 $00 $44 $F0 $10 $00 $3A $0E $E0 $E0 $FF $20
.db $E0 $E8 $FF $22 $E0 $F0 $FF $24 $E0 $F8 $FF $26 $E0 $00 $00 $28
.db $E0 $08 $00 $2A $E0 $10 $00 $2C $F0 $E0 $FF $2E $F0 $E8 $FF $46
.db $F0 $F0 $FF $48 $F0 $F8 $FF $4A $F0 $00 $00 $4C $F0 $08 $00 $4E
.db $F0 $10 $00 $3A $0E $E0 $E0 $FF $20 $E0 $E8 $FF $22 $E0 $F0 $FF
.db $24 $E0 $F8 $FF $26 $E0 $00 $00 $28 $E0 $08 $00 $2A $E0 $10 $00
.db $2C $F0 $E0 $FF $2E $F0 $E8 $FF $50 $F0 $F0 $FF $52 $F0 $F8 $FF
.db $54 $F0 $00 $00 $56 $F0 $08 $00 $58 $F0 $10 $00 $3A $0E $E0 $E0
.db $FF $20 $E0 $E8 $FF $5A $E0 $F0 $FF $5C $E0 $F8 $FF $5E $E0 $00
.db $00 $60 $E0 $08 $00 $5A $E0 $10 $00 $2C $F0 $E0 $FF $62 $F0 $E8
.db $FF $64 $F0 $F0 $FF $4A $F0 $F8 $FF $66 $F0 $00 $00 $68 $F0 $08
.db $00 $6A $F0 $10 $00 $6C $0E $E0 $E0 $FF $20 $E0 $E8 $FF $5A $E0
.db $F0 $FF $5C $E0 $F8 $FF $5E $E0 $00 $00 $60 $E0 $08 $00 $5A $E0
.db $10 $00 $2C $F0 $E0 $FF $6E $F0 $E8 $FF $70 $F0 $F0 $FF $72 $F0
.db $F8 $FF $74 $F0 $00 $00 $4A $F0 $08 $00 $76 $F0 $10 $00 $78 $0E
.db $E0 $E0 $FF $20 $E0 $E8 $FF $5A $E0 $F0 $FF $5C $E0 $F8 $FF $5E
.db $E0 $00 $00 $60 $E0 $08 $00 $5A $E0 $10 $00 $2C $F0 $E0 $FF $2E
.db $F0 $E8 $FF $7A $F0 $F0 $FF $7C $F0 $F8 $FF $7E $F0 $00 $00 $6A
.db $F0 $08 $00 $80 $F0 $10 $00 $3A $0E $E0 $E0 $FF $20 $E0 $E8 $FF
.db $82 $E0 $F0 $FF $84 $E0 $F8 $FF $86 $E0 $00 $00 $88 $E0 $08 $00
.db $2A $E0 $10 $00 $2C $F0 $E0 $FF $2E $F0 $E8 $FF $8A $F0 $F0 $FF
.db $8C $F0 $F8 $FF $8E $F0 $00 $00 $90 $F0 $08 $00 $92 $F0 $10 $00
.db $3A $0E $E0 $E0 $FF $20 $E0 $E8 $FF $82 $E0 $F0 $FF $84 $E0 $F8
.db $FF $86 $E0 $00 $00 $88 $E0 $08 $00 $2A $E0 $10 $00 $2C $F0 $E0
.db $FF $2E $F0 $E8 $FF $50 $F0 $F0 $FF $94 $F0 $F8 $FF $96 $F0 $00
.db $00 $98 $F0 $08 $00 $9A $F0 $10 $00 $3A $0E $E0 $E0 $FF $D0 $E0
.db $E8 $FF $D2 $E0 $F0 $FF $D4 $E0 $F8 $FF $D6 $E0 $00 $00 $D8 $E0
.db $08 $00 $DA $E0 $10 $00 $DC $F0 $E0 $FF $DE $F0 $E8 $FF $E0 $F0
.db $F0 $FF $E2 $F0 $F8 $FF $E4 $F0 $00 $00 $E6 $F0 $08 $00 $E0 $F0
.db $10 $00 $E8 $0E $E0 $E0 $FF $D0 $E0 $E8 $FF $D2 $E0 $F0 $FF $D4
.db $E0 $F8 $FF $D6 $E0 $00 $00 $D8 $E0 $08 $00 $DA $E0 $10 $00 $DC
.db $F0 $E0 $FF $DE $F0 $E8 $FF $EA $F0 $F0 $FF $EC $F0 $F8 $FF $EE
.db $F0 $00 $00 $F0 $F0 $08 $00 $F2 $F0 $10 $00 $E8

; Data from B603 to B800 (510 bytes)
_DATA_COMPRESSED_SEGA_LOGO_TILES_:
.db $08 $00 $89 $07 $1C $30 $60 $41 $C6 $84 $88 $FF $03 $00 $81 $FF
.db $03 $00 $89 $E1 $26 $2C $30 $F0 $21 $21 $22 $FF $03 $00 $95 $7F
.db $80 $00 $00 $F8 $09 $0B $0E $FC $0C $08 $08 $7F $C0 $00 $00 $1F
.db $60 $40 $80 $FE $03 $02 $81 $FE $03 $02 $A8 $03 $0E $08 $18 $11
.db $31 $22 $22 $F0 $3D $0F $0E $C6 $46 $22 $23 $78 $86 $7B $8D $B5
.db $8D $B5 $7A $88 $88 $84 $C6 $41 $60 $30 $0C $FF $07 $01 $00 $F0
.db $0C $04 $02 $04 $E2 $85 $63 $62 $22 $22 $1F $03 $00 $81 $FF $03
.db $00 $81 $F8 $03 $18 $81 $F8 $03 $18 $81 $8F $03 $88 $81 $8F $03
.db $88 $81 $FE $03 $02 $88 $E2 $22 $23 $23 $62 $44 $44 $C4 $03 $88
.db $82 $11 $23 $03 $11 $03 $88 $84 $C4 $86 $78 $00 $03 $80 $83 $C0
.db $40 $FF $03 $80 $81 $FF $03 $80 $95 $F2 $02 $04 $0C $F0 $00 $01
.db $07 $22 $22 $21 $71 $70 $D8 $8C $07 $1F $00 $00 $80 $7F $03 $00
.db $90 $F8 $08 $08 $0C $FC $0E $0B $09 $8E $80 $40 $60 $1F $00 $00
.db $C0 $02 $23 $02 $22 $81 $E0 $03 $00 $85 $11 $10 $20 $20 $3F $03
.db $60 $85 $C4 $04 $02 $02 $FE $03 $00 $02 $40 $81 $60 $05 $20 $81
.db $FF $07 $00 $81 $F8 $07 $00 $81 $01 $07 $00 $81 $7F $07 $00 $81
.db $E0 $07 $00 $00 $09 $00 $88 $03 $0F $1F $3E $39 $7B $77 $00 $03
.db $FF $81 $00 $03 $FF $89 $00 $C1 $C3 $CF $0F $DE $DE $DD $00 $03
.db $FF $95 $80 $7F $FF $FF $00 $F0 $F0 $F1 $03 $F3 $F7 $F7 $00 $3F
.db $FF $FF $E0 $9F $BF $7F $00 $03 $FC $81 $00 $03 $FC $82 $00 $01
.db $02 $07 $02 $0E $02 $1D $A0 $00 $C0 $F0 $F1 $39 $B9 $DD $DC $00
.db $78 $84 $72 $4A $72 $4A $84 $77 $77 $7B $39 $3E $1F $0F $03 $00
.db $F8 $FE $FF $0F $F3 $FB $FD $04 $1D $85 $9C $9D $DD $DD $E0 $03
.db $FF $81 $00 $03 $FF $81 $07 $03 $E7 $81 $07 $03 $E7 $81 $70 $03
.db $77 $81 $70 $03 $77 $81 $00 $03 $FC $81 $1C $03 $DC $81 $1D $03
.db $3B $03 $77 $82 $EE $DC $03 $EE $03 $77 $82 $3B $78 $06 $00 $82
.db $80 $00 $03 $7F $81 $00 $03 $7F $95 $0D $FD $FB $F3 $0F $FF $FE
.db $F8 $DD $DD $DE $8E $8F $07 $03 $00 $E0 $FF $FF $7F $80 $03 $FF
.db $90 $07 $F7 $F7 $F3 $03 $F1 $F0 $F0 $71 $7F $BF $9F $E0 $FF $FF
.db $3F $02 $DC $02 $DD $81 $1F $03 $FF $85 $EE $EF $DF $DF $C0 $03
.db $9F $85 $3B $FB $FD $FD $01 $03 $FF $03 $80 $05 $C0 $28 $00 $00
.db $7F $00 $7F $00 $22 $00 $00 $7F $00 $7F $00 $22 $00 $00

; Data from B801 to BFFF (2047 bytes)
_DATA_B801:
.db $A4 $01 $02 $03 $04 $05 $06 $07 $08 $09 $0A $0B $0C $0D $0E $0F
.db $10 $11 $12 $13 $14 $15 $16 $17 $18 $19 $1A $1B $1C $1D $1E $1F
.db $20 $21 $1F $20 $22 $03 $1F $81 $23 $00 $28 $00 $00

.BANK 3
.ORG $0000
Bank3:

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
	ld de, _DATA_B
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
.dw _DATA_D890 _DATA_1F6

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
.dw _DATA_E5B1 _DATA_1F6

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
.dw _DATA_314 _DATA_53

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
.dw _DATA_9

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
.dw _DATA_30

; Data from E72A to E72B (2 bytes)
.db $03 $00

; 11th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E72C to E72F (4 bytes)
_DATA_E72C:
.db $01 $A8 $E0 $01

; Pointer Table from E730 to E733 (2 entries, indexed by unknown)
.dw _DATA_E748 _DATA_30E

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
.dw _DATA_30 _DATA_63

; 13th entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E779 to E77C (4 bytes)
_DATA_E779:
.db $01 $88 $C0 $01

; Pointer Table from E77D to E780 (2 entries, indexed by unknown)
.dw _DATA_E787 _DATA_8

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
.dw _DATA_E7E5 _DATA_30E

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
.dw _DATA_40

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
.dw _DATA_15

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
.dw _DATA_E88A _DATA_1F4

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
.dw _DATA_E8BC _DATA_30E _DATA_10

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
.dw _DATA_10

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
.dw _DATA_10

; Data from E96E to E96F (2 bytes)
.db $00 $00

; 23rd entry of Pointer Table from C25F (indexed by _RAM_DE03)
; Data from E970 to E973 (4 bytes)
_DATA_E970:
.db $01 $A8 $C0 $01

; Pointer Table from E974 to E977 (2 entries, indexed by unknown)
.dw _DATA_E98C _DATA_10

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

; Data from EAED to ED04 (536 bytes)
_DATA_COMPRESSED_HUD_TILES_:
.db $09 $00 $81 $3C $04 $66 $85 $3C $00 $00 $18 $38 $03 $18 $AE $3C
.db $00 $00 $3C $66 $66 $0C $30 $7E $00 $00 $3C $66 $0C $06 $66 $3C
.db $00 $00 $0C $1C $2C $4C $7E $0C $00 $00 $7C $60 $7C $06 $66 $3C
.db $00 $00 $3C $60 $7C $66 $66 $3C $00 $00 $7E $66 $08 $03 $18 $02
.db $00 $A1 $3C $66 $3C $66 $66 $3C $00 $00 $3C $66 $66 $3E $06 $3C
.db $00 $00 $3C $62 $38 $04 $62 $3C $00 $00 $3C $66 $60 $60 $66 $3C
.db $00 $00 $3C $04 $62 $94 $3C $00 $00 $7C $62 $62 $7C $64 $62 $00
.db $00 $7E $60 $7C $60 $60 $7E $00 $FF $00 $04 $FF $84 $00 $FF $FF
.db $00 $04 $FF $81 $00 $02 $FF $06 $00 $02 $FF $B7 $80 $9F $90 $9F
.db $90 $97 $90 $FF $01 $F1 $19 $DD $1D $9D $1D $90 $97 $90 $8F $90
.db $8F $80 $FF $1D $9D $1D $FD $0D $FD $01 $FF $FF $81 $9B $89 $88
.db $9B $B4 $A8 $FF $81 $D9 $91 $11 $19 $0D $05 $A8 $A8 $A0 $A8 $A4
.db $B0 $9F $FF $05 $05 $82 $0D $F9 $02 $FF $07 $80 $81 $FF $07 $01
.db $07 $80 $81 $FF $07 $01 $02 $FF $07 $80 $00 $09 $FF $81 $C3 $04
.db $99 $85 $C3 $FF $FF $E7 $C7 $03 $E7 $AE $C3 $FF $FF $C3 $99 $99
.db $F3 $CF $81 $FF $FF $C3 $99 $F3 $F9 $99 $C3 $FF $FF $F3 $E3 $D3
.db $B3 $81 $F3 $FF $FF $83 $9F $83 $F9 $99 $C3 $FF $FF $C3 $9F $83
.db $99 $99 $C3 $FF $FF $81 $99 $F7 $03 $E7 $02 $FF $A1 $C3 $99 $C3
.db $99 $99 $C3 $FF $FF $C3 $99 $99 $C1 $F9 $C3 $FF $FF $C3 $9D $C7
.db $FB $9D $C3 $FF $FF $C3 $99 $9F $9F $99 $C3 $FF $FF $C3 $04 $9D
.db $92 $C3 $FF $FF $83 $9D $9D $83 $9B $9D $FF $FF $81 $9F $83 $9F
.db $9F $81 $FF $18 $00 $B8 $FF $80 $9F $90 $95 $90 $92 $90 $FF $01
.db $F1 $11 $55 $15 $95 $15 $90 $92 $90 $8F $9F $8F $80 $FF $15 $95
.db $15 $F5 $F5 $FD $01 $FF $FF $81 $83 $81 $80 $80 $8B $97 $FF $81
.db $C1 $81 $01 $01 $F1 $F9 $97 $97 $9F $97 $9B $8F $80 $FF $05 $F9
.db $8C $F1 $01 $FF $FF $B8 $FE $FE $FF $BF $9F $87 $FF $03 $01 $85
.db $1D $BF $FF $FF $81 $04 $80 $8A $81 $86 $FF $FF $F1 $C1 $81 $81
.db $C1 $B1 $02 $FF $07 $80 $00 $7F $00 $1C $00 $9B $0F $00 $0F $08
.db $0F $00 $00 $10 $F0 $34 $F4 $74 $F4 $0F $08 $0F $1F $10 $0F $00
.db $00 $F4 $74 $F4 $F4 $04 $FC $03 $00 $83 $06 $04 $06 $05 $00 $83
.db $60 $20 $60 $15 $00 $87 $38 $7E $7E $7F $3F $1F $07 $04 $00 $85
.db $1C $BE $FE $FE $01 $04 $00 $8A $01 $06 $00 $FE $F0 $C0 $80 $80
.db $C0 $B0 $09 $00 $00 $7F $00 $1D $00 $83 $0A $00 $05 $05 $00 $81
.db $80 $04 $00 $81 $05 $56 $00 $00

; Data from ED05 to EDAB (167 bytes)
_DATA_ED05:
.db $0D $00 $83 $20 $FD $20 $0D $00 $83 $04 $75 $04 $0D $00 $83 $20
.db $AE $20 $0D $00 $83 $04 $BF $04 $00 $0E $00 $81 $3D $0E $00 $83
.db $04 $57 $04 $0D $00 $83 $20 $EA $20 $0E $00 $81 $BC $81 $00 $00
.db $0E $00 $81 $0F $0E $00 $83 $04 $8D $04 $0D $00 $83 $20 $B1 $20
.db $0E $00 $81 $F0 $81 $00 $00 $40 $00 $00 $81 $FF $04 $80 $02 $81
.db $93 $83 $82 $A5 $AA $94 $A8 $96 $C0 $FF $FF $01 $05 $19 $29 $51
.db $A1 $41 $E1 $81 $05 $01 $81 $FF $00 $08 $00 $87 $01 $02 $24 $18
.db $28 $14 $40 $05 $00 $84 $10 $20 $40 $80 $08 $00 $00 $09 $00 $02
.db $40 $84 $20 $30 $18 $46 $11 $00 $00 $81 $FF $04 $80 $94 $81 $80
.db $82 $80 $A4 $88 $80 $80 $E2 $A0 $FF $FF $01 $05 $19 $21 $41 $81
.db $01 $21 $06 $01 $81 $FF $00

; Data from EDAC to EE5A (175 bytes)
_DATA_EDAC:
.db $81 $FF $05 $80 $94 $81 $B3 $A6 $BD $9B $8E $B6 $F3 $A0 $FF $FF
.db $03 $05 $19 $29 $51 $A1 $41 $C1 $81 $02 $01 $02 $81 $82 $01 $FF
.db $00 $08 $00 $87 $01 $02 $04 $30 $48 $08 $50 $05 $00 $84 $10 $20
.db $40 $80 $08 $00 $00 $07 $00 $02 $20 $86 $30 $18 $3C $6E $7B $70
.db $0E $00 $81 $80 $02 $00 $00 $81 $FF $05 $80 $87 $81 $92 $84 $88
.db $80 $80 $90 $02 $80 $02 $FF $86 $03 $05 $19 $21 $41 $81 $05 $01
.db $84 $81 $01 $01 $FF $00 $81 $FF $07 $80 $90 $81 $82 $84 $A8 $90
.db $A8 $80 $FF $FF $01 $1D $35 $0D $29 $41 $81 $07 $01 $81 $FF $00
.db $08 $00 $86 $01 $02 $04 $28 $10 $28 $05 $00 $85 $08 $10 $20 $40
.db $80 $08 $00 $00 $0B $00 $83 $30 $28 $18 $12 $00 $00 $81 $FF $0B
.db $80 $88 $C0 $80 $90 $FF $FF $01 $1D $21 $0B $01 $81 $FF $00

; Data from EE5B to EEA1 (71 bytes)
_DATA_EE5B:
.db $81 $FF $08 $80 $8E $82 $84 $88 $90 $A0 $80 $FF $FF $01 $05 $19
.db $39 $51 $21 $08 $01 $81 $FF $00 $08 $00 $86 $01 $02 $04 $08 $10
.db $20 $07 $00 $83 $20 $40 $80 $08 $00 $00 $09 $00 $86 $06 $0E $3C
.db $78 $38 $10 $11 $00 $00 $81 $FF $0E $80 $02 $FF $85 $01 $05 $19
.db $21 $41 $09 $01 $81 $FF $00

; Data from EEA2 to EF21 (128 bytes)
_DATA_EEA2:
.db $00 $01 $00 $01 $00 $01 $0B $01 $0C $01 $0D $01 $0E $01 $0F $01
.db $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01
.db $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $1F $09 $1F $0B
.db $00 $01 $1F $09 $1F $0B $00 $01 $1F $09 $1F $0B $00 $01 $00 $01
.db $00 $01 $00 $01 $00 $01 $01 $01 $01 $01 $01 $01 $01 $01 $01 $01
.db $01 $01 $01 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01
.db $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $1F $0D $1F $0F
.db $00 $01 $1F $0D $1F $0F $00 $01 $1F $0D $1F $0F $00 $01 $00 $01

; Data from EF22 to EF2A (9 bytes)
_DATA_EF22:
.db $04 $1F $00 $84 $09 $0B $0D $0F $00

; Data from EF2B to EF33 (9 bytes)
_DATA_EF2B:
.db $84 $13 $14 $15 $16 $00 $04 $09 $00

; Data from EF34 to EF3C (9 bytes)
_DATA_EF34:
.db $84 $17 $18 $19 $1A $00 $04 $09 $00

; Data from EF3D to FFFF (4291 bytes)
_DATA_EF3D:
.db $84 $1B $1C $1D $1E $00 $04 $09 $00

.BANK 4
.ORG $0000
Bank4:

; Data from 10000 to 10007 (8 bytes)
.db $00 $00 $00 $1E $1E $1E $7F $7F

; 2nd entry of Pointer Table from 1005C (indexed by _RAM_C40E)
; Data from 10008 to 1003F (56 bytes)
_DATA_10008:
.db $7F $FF $FF $FF $D7 $F8 $D0 $7F $7F $5F $7F $7F $0F $37 $37 $0F
.db $27 $27 $1F $07 $07 $0F $04 $03 $1B $31 $0E $0F $2B $14 $1F $6B
.db $14 $1F $5B $24 $3F $59 $26 $3F $00 $00 $00 $00 $00 $00 $00 $00
.db $00 $00 $00 $00 $00 $80 $00 $80

; Pointer Table from 10040 to 10041 (1 entries, indexed by _RAM_C40E)
.dw _DATA_10080

; Pointer Table from 10042 to 10043 (1 entries, indexed by _RAM_C40E)
.dw _DATA_10080

; Pointer Table from 10044 to 10045 (1 entries, indexed by _RAM_C40E)
.dw $C080

; Pointer Table from 10046 to 10047 (1 entries, indexed by _RAM_C40E)
.dw $C0C0

; Pointer Table from 10048 to 10049 (1 entries, indexed by _RAM_C40E)
.dw $C0C0

; Pointer Table from 1004A to 1004B (1 entries, indexed by _RAM_C40E)
.dw $C0C0

; Pointer Table from 1004C to 10053 (4 entries, indexed by _RAM_C40E)
.dw $C0C0 $E062 _RAM_C4E0 $E024

; Data from 10054 to 1005B (8 bytes)
.db $EA $18 $F8 $E4 $1C $F0 $E8 $1C

; Pointer Table from 1005C to 1005F (2 entries, indexed by _RAM_C40E)
.dw $F0F8 _DATA_10008

; Data from 10060 to 1007F (32 bytes)
.db $59 $26 $3E $5C $23 $3F $1E $21 $3F $2E $11 $1F $2C $13 $1F $20
.db $3F $20 $28 $3B $2C $64 $7D $26 $7B $67 $3E $59 $25 $3E $7C $00

; 1st entry of Pointer Table from 10040 (indexed by _RAM_C40E)
; Data from 10080 to 10081 (2 bytes)
_DATA_10080:
.db $3F $BC

; Pointer Table from 10082 to 10083 (1 entries, indexed by _RAM_C40E)
.db $42 $7F

; Data from 10084 to 10087 (4 bytes)
.db $BE $41 $7F $9F

; Pointer Table from 10088 to 1008D (3 entries, indexed by _RAM_C40E)
.dw $7F60 $F807 $E0FF

; Data from 1008E to 137DF (14162 bytes)
.incbin "banks\lots_DATA_1008E.inc"

; Data from 137E0 to 13FFF (2080 bytes)
_DATA_137E0:
.incbin "banks\lots_DATA_137E0.inc"

.BANK 5
.ORG $0000
Bank5:

; Pointer Table from 14000 to 14027 (20 entries, indexed by _RAM_MOVEMENT_STATE)
_DATA_14000:
.dw _DATA_14028 _DATA_14034 _DATA_14040 _DATA_14042 _DATA_14044 _DATA_14046 _DATA_14048 _DATA_1404A
.dw _DATA_1404C _DATA_14054 _DATA_1405C _DATA_14064 _DATA_1406C _DATA_14074 _DATA_1407C _DATA_14082
.dw _DATA_14028 _DATA_14028 _DATA_14088 _DATA_14090

; 1st entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14028 to 14033 (12 bytes)
_DATA_14028:
.db $00 $80 $50 $81 $70 $82 $90 $83 $E0 $84 $70 $82

; 2nd entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14034 to 1403F (12 bytes)
_DATA_14034:
.db $00 $86 $50 $87 $70 $88 $90 $89 $E0 $8A $70 $88

; 3rd entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14040 to 14041 (2 bytes)
_DATA_14040:
.db $40 $8E

; 4th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14042 to 14043 (2 bytes)
_DATA_14042:
.db $90 $8F

; 5th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14044 to 14045 (2 bytes)
_DATA_14044:
.db $40 $8E

; 6th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14046 to 14047 (2 bytes)
_DATA_14046:
.db $90 $8F

; 7th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14048 to 14049 (2 bytes)
_DATA_14048:
.db $00 $8C

; 8th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 1404A to 1404B (2 bytes)
_DATA_1404A:
.db $20 $8D

; 9th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 1404C to 14053 (8 bytes)
_DATA_1404C:
.db $20 $AB $70 $AC $F0 $AD $D0 $AF

; 10th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14054 to 1405B (8 bytes)
_DATA_14054:
.db $80 $B1 $D0 $B2 $50 $B4 $30 $B6

; 11th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 1405C to 14063 (8 bytes)
_DATA_1405C:
.db $E0 $90 $00 $92 $B0 $93 $60 $95

; 12th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14064 to 1406B (8 bytes)
_DATA_14064:
.db $40 $97 $60 $98 $10 $9A $C0 $9B

; 13th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 1406C to 14073 (8 bytes)
_DATA_1406C:
.db $A0 $9D $20 $9F $A0 $A0 $80 $A2

; 14th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14074 to 1407B (8 bytes)
_DATA_14074:
.db $60 $A4 $E0 $A5 $60 $A7 $40 $A9

; 15th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 1407C to 14081 (6 bytes)
_DATA_1407C:
.db $98 $80 $E8 $81 $38 $83

; 16th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14082 to 14087 (6 bytes)
_DATA_14082:
.db $88 $84 $D8 $85 $28 $87

; 19th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14088 to 1408F (8 bytes)
_DATA_14088:
.db $78 $88 $98 $89 $E8 $8A $68 $8C

; 20th entry of Pointer Table from 14000 (indexed by _RAM_MOVEMENT_STATE)
; Data from 14090 to 152F7 (4712 bytes)
_DATA_14090:
.incbin "banks\lots_DATA_14090.inc"

; Data from 152F8 to 15538 (577 bytes)
_DATA_152F8:
.db $07 $00 $88 $01 $02 $03 $04 $05 $06 $07 $08 $08 $09 $81 $4C $0F
.db $00 $88 $0A $0B $0C $0D $0E $0F $10 $11 $08 $12 $82 $4D $4E $0E
.db $00 $88 $0A $0B $13 $14 $15 $16 $17 $18 $08 $19 $82 $4F $43 $0E
.db $00 $91 $0A $1A $1B $0B $0B $1C $1D $1E $1F $50 $51 $52 $53 $54
.db $0B $0B $0A $0F $00 $91 $0A $20 $21 $22 $23 $24 $25 $26 $27 $55
.db $0B $56 $57 $58 $59 $5A $0A $0F $00 $81 $0A $04 $0B $8C $28 $29
.db $0B $1C $1D $5B $5C $5D $5E $5F $60 $0A $0F $00 $91 $2A $2B $2C
.db $0B $0B $2D $2E $2F $30 $61 $62 $63 $64 $65 $66 $67 $0A $0F $00
.db $91 $31 $32 $33 $34 $35 $36 $37 $38 $39 $1D $1E $68 $69 $6A $6B
.db $6C $0A $0F $00 $91 $3A $3B $3C $3D $3E $3F $40 $41 $42 $25 $26
.db $6D $6E $6F $70 $71 $0A $0F $00 $81 $43 $0F $44 $81 $43 $13 $00
.db $89 $45 $00 $46 $47 $48 $72 $00 $73 $74 $02 $75 $17 $00 $86 $49
.db $4A $4B $4B $4A $49 $19 $00 $82 $76 $77 $04 $78 $82 $77 $76 $11
.db $00 $82 $79 $7A $04 $00 $82 $7B $7C $06 $78 $82 $7C $7B $0F $00
.db $83 $7D $7E $7F $04 $00 $82 $80 $81 $06 $78 $86 $81 $80 $00 $00
.db $7A $79 $0B $00 $83 $82 $83 $84 $04 $00 $81 $85 $08 $78 $86 $85
.db $00 $00 $7F $7E $7D $0A $00 $84 $86 $83 $87 $88 $03 $00 $81 $89
.db $08 $8A $86 $BD $00 $00 $84 $83 $82 $06 $00 $03 $8B $81 $8C $03
.db $83 $81 $8D $03 $8B $81 $8E $05 $78 $89 $BE $BF $C0 $C1 $8B $C2
.db $C3 $83 $C4 $06 $8B $03 $8F $8A $90 $83 $83 $91 $92 $93 $94 $8F
.db $95 $96 $05 $78 $85 $C5 $C6 $C7 $8F $C8 $03 $83 $81 $C9 $05 $8F
.db $03 $97 $81 $98 $03 $83 $90 $99 $9A $9B $97 $9C $9D $9E $9E $9F
.db $CA $BE $CB $83 $CC $97 $CD $03 $83 $81 $CE $05 $97 $03 $A0 $94
.db $A1 $83 $83 $A2 $A3 $A4 $A5 $A0 $A6 $A7 $A8 $81 $78 $CF $78 $D0
.db $83 $D1 $D2 $87 $03 $83 $81 $D3 $05 $A0 $83 $A9 $AA $A9 $04 $83
.db $8F $AB $A9 $AA $AC $AD $AE $AF $B0 $B1 $A9 $D4 $87 $83 $D5 $D6
.db $04 $83 $8A $D7 $AA $A9 $AA $A9 $AA $B2 $B3 $B2 $B4 $03 $83 $90
.db $B5 $B2 $B3 $B2 $B6 $B7 $B8 $B9 $BA $D8 $D9 $DA $83 $DB $DC $DD
.db $03 $83 $9C $DE $B3 $B2 $B3 $B2 $B3 $BB $BC $BB $BC $BB $BC $BB
.db $BC $BB $BC $BB $BC $BB $BC $BB $BC $BB $DF $91 $83 $83 $E0 $05
.db $83 $85 $BC $BB $BC $BB $BC $00 $58 $00 $81 $02 $1E $00 $81 $02
.db $1F $00 $81 $02 $1F $00 $81 $02 $1F $00 $81 $02 $1F $00 $81 $02
.db $1F $00 $81 $02 $1F $00 $81 $02 $38 $00 $03 $02 $1F $00 $02 $02
.db $1F $00 $02 $02 $1E $00 $02 $02 $02 $00 $02 $02 $1B $00 $81 $02
.db $02 $00 $03 $02 $1D $00 $83 $02 $00 $02 $57 $00 $81 $02 $1C $00
.db $81 $04 $07 $00 $81 $02 $1B $00 $81 $02 $3F $00 $81 $02 $0D $00
.db $00

; Data from 15539 to 15548 (16 bytes)
_DATA_15539:
.db $00 $3F $00 $0B $06 $01 $0F $03 $02 $2A $07 $15 $2F $0C $0A $29

; Data from 15549 to 16A88 (5440 bytes)
_DATA_COMPRESSED_TITLE_SCREEN_TILES_:
.incbin "banks\lots_DATA_15549.inc"

.ASCIITABLE
MAP ' ' = 32
MAP 'A' TO 'Z' = 33
MAP ',' = 59
MAP '.' = 60
MAP '!' = 61
MAP '5' = 62
MAP "'" = 63
MAP '?' = 64
MAP '1' = 66
MAP '2' = 67
MAP '3' = 68
.ENDA

; Data from 16A89 to 16C22 (410 bytes)
_DATA_16A89: ; Intro Story Text
.db $AD
.asc "SEVERAL THOUSAND YEARS  AFTER THE DOWNFALL OF"
.db $03 $20 $F0
.asc "THE DEMON LORD RA GOAN, BALJINYA WAS ONCE MORE  FACED WITH GREAT PERIL. "
.asc "IN A SCHEME TO RESTORE  THEIR MASTER,THE"
.db $08 $20 $C5
.asc "FOLLOWERS OF RA GOAN HADKILLED THE RIGHTFUL KINGAS AN EVIL SACRIFICE."
.asc $03 $20 $A7
.asc "FEAR OVERRAN THE TOWNS  OF BALJINYA,AND"
.db $09 $20 $95
.asc "LAWLESSNESS RULED THE"
.db $03 $20 $85
.asc "LAND."
.db $13 $20 $94
.asc "A COUNCIL OF ELDERS,"
.db $04 $20 $92
.asc "SEEKING TO RESTORE"
.db $06 $20 $AC
.asc "ORDER,DECREED THAT ANY  WHO SOUGHT THE CROWN"
.db $04 $20 $00 $6C $00 $6C $00 $6C $00 $6C $00 $00

; Data from 16C23 to 16C47 (37 bytes)
_DATA_16C23:
.db $93
.asc "MUST FIRST PASS THR" $02 "E"
.db $03 $20 $86
.asc "TESTS."
.db $12 $20 $00 $30 $00 $00

; Data from 16C48 to 16CC2 (123 bytes)
_DATA_16C48:
.db $93
.asc "LANDAU,A BRAVE LAD,"
.db $05 $20 $93
.asc "RESOLVED TO ATTEMPT"
.db $05 $20 $C8
.asc "THESE FEATS FOR THE LANDHE LOVED,AND SET OFF TO FIND THE WIZARD IN AMON."
.db $00 $3C $00 $3C $00 $00

; Data from 16CC3 to 16DC1 (255 bytes)
_DATA_16CC3:
.db $81 $9F $16 $A1 $95 $9F $A0
.asc " 1.HE MUST FIND THE"
.db $03 $20 $02 $A0 $03 $20 $8F
.asc "TREE OF MARILL,"
.db $04 $20 $02 $A0 $03 $20 $91
.asc "THE SYMBOL OF THE"
.db $02 $20 $02 $A0 $03 $20 $8D
.asc "ROYAL FAMILY."
.db $06 $20 $02 $A0 $96
.asc " 2"
.db $41
.asc "HE MUST SUBDUE THE "
.db $02 $A0 $03 $20 $90
.asc "GOBLIN OF BALALA"
.db $03 $20 $02 $A0 $03 $20 $87
.asc "VALLEY."
.db $0C $20 $02 $A0 $92
.asc " 3.HE MUST DESTROY"
.db $04 $20 $02 $A0 $03 $20 $95
.asc "THE STATUE OF EVIL."
.db $A0 $9F $16 $A1 $81
.db $9F $00 $17 $00 $81 $02 $17 $00 $81 $02 $17 $00 $81 $02 $17 $00
.db $81 $02 $17 $00 $81 $02 $17 $00 $81 $02 $17 $00 $81 $02 $17 $00
.db $81 $02 $17 $00 $81 $02 $17 $00 $81 $02 $17 $04 $81 $06 $00

; 1st entry of Pointer Table from 702F (indexed by _RAM_C182)
; Data from 16DC2 to 17FFF (4670 bytes)
_DATA_16DC2: ; Credits Text
.db $92
.asc " LANDAU HAS PASSED"
.db $16 $20 $94
.asc "THE TESTS AND IS NOW"
.db $15 $20 $93
.asc "THE RIGHTFUL KING! "
.db $00 $64 $00 $00 $02 $20 $90
.asc "CONGRATULATIONS!"
.db $19 $20 $8E
.asc "RULE THIS LAND"
.db $1D $20 $87
.asc "FIRMLY!"
.db $07 $20 $00 $64 $00 $00 $93
.asc "RESTORE OUR LAND TO"
.db $19 $20 $83
.asc "ITSG "
.db $87
.asc "BEAUTY!"
.db $07 $20 $00 $64 $00 $00 $93
.asc " THOU ART NOW KING,"
.db $18 $20 $8E
.asc "FORGE A STRONG"
.db $1D $20 $88
.asc "COUNTRY!"
.db $06 $20 $00 $64 $00 $00 $93
.asc "WE HAVE ALL AWAITED"
.db $15 $20 $94
.asc "THIS DAY! HURRAH FOR"
.db $1A $20 $86
.asc "LANDAU"
.db $08 $20 $00 $64 $00 $00 $04 $20 $8C
.asc "OUR LAND AND"
.db $18 $20 $94
.asc "BALJINYA MUST ALWAYS"
.db $15 $20 $91
.asc "STAND AS FRIENDS!"
.db $02 $20 $00 $64 $00 $00 $02 $20 $90
.asc "THREE CHEERS FOR"
.db $16 $20 $94
.asc "LANDAU! WE OFFER OUR"
.db $16 $20 $8F
.asc "DEEPEST THANKS!"
.db $03 $20 $00 $64 $00 $00 $02 $20 $8F
.asc "LANDAU,SOMEWHAT"
.db $17 $20 $93
.asc "TROUBLED LOOKS DOWN"
.db $19 $20 $8C
.asc "AT BALJINYA."
.db $04 $20 $00 $64 $00 $00 $94
.asc "BALJINYA HAD COUNTED"
.db $15 $20 $91
.asc "HEAVILY ON LANDAU"
.db $18 $20 $8D
.asc "UNTIL NOW BUT"
.db $03 $41 $02 $20 $00 $64 $00 $00 $14 $20 $90
.asc "FIVE YEARS LATER"
.db $04 $41 $00 $3C $00 $00 $04 $20 $8C
.asc "BALJINYA WAS"
.db $19 $20 $92
.asc "PROSPEROUS AND THE"
.db $16 $20 $8F
.asc "PEOPLE AT PEACE"
.db $03 $41 $81 $20 $00 $64 $00 $00 $93
.asc " BUT THOUSANDS THEN"
.db $16 $20 $91
.asc "ATTACKED,CRUSHING"
.db $1B $20 $89
.asc "BALJINYA!"
.db $06 $20 $00 $64 $00 $00

.BANK 6
.ORG $0000
Bank6:

; Data from 18000 to 18007 (8 bytes)
.db $2E $A0 $6D $A0 $EF $A0 $28 $A1

; 1st entry of Pointer Table from 8000 (indexed by unknown)
; Data from 18008 to 18069 (98 bytes)
_DATA_18008:
.db $5A $A1 $C5 $A1 $EB $A1 $26 $A2 $5E $A2 $97 $A2 $CE $A2 $51 $A3
.db $96 $A3 $16 $A4 $96 $A4 $D6 $A4 $54 $A5 $89 $A5 $CE $A5 $0F $A6
.db $4B $A6 $77 $A6 $B5 $A6 $F6 $A6 $3A $A7 $57 $A7 $9A $A7 $DF $A7
.db $20 $A8 $4B $A8 $8C $A8 $C3 $A8 $00 $A9 $3D $A9 $74 $A9 $A2 $A9
.db $E2 $A9 $25 $AA $4A $AA $78 $AA $94 $AA $B0 $A0 $99 $A1 $97 $A2
.db $0C $A3 $D2 $A3 $55 $A4 $4B $A8 $C3 $AA $CA $AA $0D $AB $4D $AB
.db $8B $AB

; Data from 1806A to 18226 (445 bytes)
_DATA_COMPRESSED_FONT_TILES_:
.db $20 $00 $04 $38 $04 $6C $08 $C6 $04 $FE $08 $C6 $04 $00 $04 $FC
.db $08 $C6 $04 $FC $08 $C6 $04 $FC $04 $00 $04 $3C $04 $66 $0C $C0
.db $04 $66 $04 $3C $04 $00 $04 $F8 $04 $CC $0C $C6 $04 $CC $04 $F8
.db $04 $00 $04 $FE $08 $C0 $04 $F8 $08 $C0 $04 $FE $04 $00 $04 $FE
.db $08 $C0 $04 $F8 $0C $C0 $04 $00 $04 $3E $04 $60 $04 $C0 $04 $CE
.db $04 $C6 $04 $66 $04 $3E $04 $00 $0C $C6 $04 $FE $0C $C6 $04 $00
.db $04 $7E $14 $18 $04 $7E $04 $00 $14 $06 $04 $C6 $04 $7C $04 $00
.db $04 $C6 $04 $CC $04 $D8 $04 $F0 $04 $F8 $04 $DC $04 $CE $04 $00
.db $18 $C0 $04 $FE $04 $00 $04 $C6 $04 $EE $08 $FE $04 $D6 $08 $C6
.db $04 $00 $04 $C6 $04 $E6 $04 $F6 $04 $FE $04 $DE $04 $CE $04 $C6
.db $04 $00 $04 $7C $14 $C6 $04 $7C $04 $00 $04 $FC $0C $C6 $04 $FC
.db $08 $C0 $04 $00 $04 $7C $0C $C6 $04 $DE $04 $CC $04 $76 $04 $00
.db $04 $FC $08 $C6 $04 $CE $04 $F8 $04 $DC $04 $CE $04 $00 $04 $78
.db $04 $CC $04 $C0 $04 $7C $04 $06 $04 $C6 $04 $7C $04 $00 $04 $7E
.db $18 $18 $04 $00 $18 $C6 $04 $7C $04 $00 $0C $C6 $04 $EE $04 $7C
.db $04 $38 $04 $10 $04 $00 $08 $C6 $04 $D6 $08 $FE $04 $6C $04 $44
.db $04 $00 $04 $C6 $04 $EE $04 $7C $04 $38 $04 $7C $04 $EE $04 $C6
.db $04 $00 $0C $66 $04 $3C $0C $18 $04 $00 $04 $FE $04 $0E $04 $1C
.db $04 $38 $04 $70 $04 $E0 $04 $FE $14 $00 $08 $18 $04 $08 $04 $10
.db $14 $00 $08 $30 $04 $00 $04 $18 $0C $3C $04 $18 $04 $00 $04 $18
.db $04 $00 $04 $FC $04 $C0 $04 $FC $08 $06 $04 $C6 $04 $7C $04 $00
.db $08 $18 $04 $10 $14 $00 $04 $7C $04 $C6 $04 $06 $04 $1C $04 $30
.db $04 $00 $04 $30 $10 $00 $08 $18 $0C $00 $04 $18 $04 $38 $10 $18
.db $04 $7E $04 $00 $04 $7C $04 $C6 $04 $0E $04 $3C $04 $78 $04 $E0
.db $04 $FE $04 $00 $04 $7E $04 $0C $04 $18 $04 $3C $04 $06 $04 $C6
.db $04 $7C $04 $00 $81 $01 $03 $00 $81 $01 $03 $00 $81 $01 $03 $00
.db $81 $01 $03 $00 $81 $01 $03 $00 $81 $01 $03 $00 $81 $01 $03 $00
.db $81 $01 $03 $00 $81 $FF $1F $00 $81 $01 $1F $00 $00

; 1st entry of Pointer Table from 1A016 (indexed by _RAM_BUILDING_INDEX)
; Data from 18227 to 182DB (181 bytes)
_DATA_18227:
.db $12 $A0 $84 $A1 $A2 $A3 $A1 $0C $A0 $88 $A4 $A5 $A6 $A4 $A7 $A8
.db $A8 $A7 $08 $A0 $88 $A9 $AA $AB $A9 $AC $AD $AD $AC $03 $A0 $81
.db $AE $02 $AF $02 $A0 $88 $B0 $B1 $B2 $B0 $B3 $B4 $B4 $B3 $03 $A0
.db $83 $B5 $B6 $B7 $06 $A0 $84 $B8 $B9 $B9 $B8 $03 $A0 $C3 $BA $BB
.db $BC $A0 $BD $BE $A0 $A0 $BF $C0 $C1 $C1 $C0 $BF $A0 $A0 $BA $C2
.db $C3 $C4 $C5 $C6 $A0 $C7 $C8 $C9 $CA $CA $C9 $C8 $C7 $A0 $BA $C2
.db $C3 $CB $CC $CD $A0 $CE $CF $D0 $D1 $D1 $D0 $CF $CE $A0 $BA $D2
.db $C3 $D3 $D4 $D5 $A0 $D6 $D7 $D8 $D9 $D9 $D8 $D7 $D6 $A0 $BA $DA
.db $DB $00 $15 $00 $81 $02 $0F $00 $81 $02 $02 $00 $02 $02 $0B $00
.db $81 $02 $02 $00 $02 $02 $0B $00 $81 $02 $02 $00 $02 $02 $0E $00
.db $02 $02 $0E $00 $03 $02 $0D $00 $04 $02 $0C $00 $04 $02 $0C $00
.db $04 $02 $04 $00 $00

; 2nd entry of Pointer Table from 1A016 (indexed by _RAM_BUILDING_INDEX)
; Data from 182DC to 183A5 (202 bytes)
_DATA_182DC:
.db $17 $A0 $02 $A1 $09 $A0 $85 $A2 $A3 $A4 $A5 $A0 $02 $A6 $02 $A0
.db $81 $A7 $06 $A0 $8B $A8 $A9 $AA $AB $A0 $AC $AC $A0 $AD $AE $AF
.db $03 $A0 $06 $B0 $84 $B1 $B2 $B3 $B1 $02 $B0 $02 $B4 $02 $B0 $02
.db $B5 $02 $B6 $02 $B7 $84 $B8 $B9 $B9 $B8 $02 $B7 $02 $BA $02 $B7
.db $02 $BB $02 $BC $88 $BD $BE $BF $C0 $C0 $BF $BE $BD $02 $C1 $02
.db $B7 $02 $B0 $8C $C2 $B0 $C3 $C4 $C5 $C6 $C6 $C5 $C4 $C3 $B0 $C2
.db $02 $B0 $02 $B7 $8C $C7 $B7 $C8 $C9 $CA $C6 $C6 $CA $C9 $C8 $B7
.db $C7 $04 $B7 $8C $C7 $B7 $CB $CC $CD $C6 $C6 $CD $CC $CB $B7 $C7
.db $02 $B7 $00 $18 $00 $81 $02 $0F $00 $81 $02 $0F $00 $81 $02 $10
.db $00 $81 $02 $03 $00 $81 $02 $03 $00 $83 $02 $00 $02 $04 $00 $02
.db $02 $03 $00 $81 $02 $03 $00 $83 $02 $00 $02 $04 $00 $04 $02 $82
.db $00 $02 $0B $00 $03 $02 $82 $00 $02 $0B $00 $03 $02 $82 $00 $02
.db $0B $00 $03 $02 $82 $00 $02 $02 $00 $00

; 9th entry of Pointer Table from 1A016 (indexed by _RAM_BUILDING_INDEX)
; Data from 183A6 to 1847F (218 bytes)
_DATA_183A6:
.db $13 $A0 $83 $A1 $A2 $A1 $06 $A0 $83 $A1 $A2 $A1 $04 $A0 $8C $A3
.db $A4 $A3 $A5 $A6 $A6 $A5 $A0 $A0 $A3 $A4 $A3 $02 $A0 $02 $A7 $8C
.db $A8 $A9 $A8 $AA $AB $AB $AA $A0 $A0 $A8 $A9 $A8 $02 $A0 $02 $AC
.db $8E $AD $AE $AD $AF $B0 $B0 $AF $A0 $A0 $AD $AE $AD $A0 $B1 $02
.db $B2 $03 $B3 $84 $B4 $B5 $B5 $B4 $02 $B1 $03 $B3 $81 $B1 $04 $A0
.db $88 $B6 $B7 $B8 $B9 $B9 $B8 $B7 $B6 $04 $A0 $B0 $BA $BB $BA $BB
.db $BC $BD $BE $BF $BF $BE $BD $BC $BA $BB $BA $BB $C0 $C1 $C0 $C1
.db $C2 $C3 $C4 $C5 $C5 $C4 $C3 $C2 $C0 $C1 $C0 $C1 $C6 $C7 $C6 $C7
.db $C8 $C9 $CA $CB $CB $CA $C9 $C8 $C6 $C7 $C6 $C7 $00 $15 $00 $81
.db $02 $08 $00 $81 $02 $06 $00 $81 $02 $02 $00 $02 $02 $04 $00 $81
.db $02 $03 $00 $84 $02 $00 $00 $02 $02 $00 $02 $02 $04 $00 $81 $02
.db $03 $00 $84 $02 $00 $00 $02 $02 $00 $02 $02 $04 $00 $81 $02 $03
.db $00 $81 $02 $05 $00 $02 $02 $0E $00 $04 $02 $0C $00 $04 $02 $0C
.db $00 $04 $02 $0C $00 $04 $02 $04 $00 $00

; 11th entry of Pointer Table from 1A016 (indexed by _RAM_BUILDING_INDEX)
; Data from 18480 to 18565 (230 bytes)
_DATA_18480:
.db $F7 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0
.db $A1 $A2 $A3 $A4 $A4 $A3 $A5 $A2 $A5 $A2 $A5 $A2 $A3 $A4 $A4 $A3
.db $A5 $A0 $A6 $A7 $A7 $A6 $A1 $A8 $A9 $A9 $A8 $A1 $A6 $A7 $A7 $A6
.db $A1 $AA $AB $A7 $A7 $AB $A5 $AC $AD $AD $AC $A5 $AB $A7 $A7 $AB
.db $A5 $A0 $AE $AF $AF $AE $A1 $B0 $B1 $B1 $B0 $A1 $AE $AF $AF $AE
.db $A1 $A2 $A5 $A2 $A5 $A2 $B2 $B3 $B4 $B4 $B3 $B2 $A2 $A2 $A5 $A2
.db $A5 $A0 $A1 $A0 $A1 $A0 $B5 $B6 $B7 $B7 $B6 $B5 $A0 $A0 $A1 $A0
.db $A1 $A2 $A5 $A2 $A5 $B8 $B9 $BA $02 $BB $A7 $BA $B9 $B8 $A2 $A5
.db $A2 $A5 $A0 $A1 $A0 $A1 $BC $BD $BE $BF $BF $BE $BD $BC $A0 $A1
.db $A0 $A1 $A2 $A5 $A2 $A5 $C0 $C1 $C2 $C3 $C3 $C2 $C1 $C0 $A2 $A5
.db $A2 $A5 $00 $13 $00 $02 $02 $08 $00 $02 $02 $05 $00 $81 $02 $03
.db $00 $03 $02 $03 $00 $81 $02 $05 $00 $81 $02 $03 $00 $03 $02 $03
.db $00 $81 $02 $04 $00 $02 $02 $03 $00 $03 $02 $02 $00 $02 $02 $09
.db $00 $04 $02 $0C $00 $04 $02 $0C $00 $04 $02 $0C $00 $04 $02 $0C
.db $00 $04 $02 $04 $00 $00

; 8th entry of Pointer Table from 1A016 (indexed by _RAM_BUILDING_INDEX)
; Data from 18566 to 18606 (161 bytes)
_DATA_18566:
.db $C0 $A0 $A1 $A0 $A1 $A0 $A1 $A2 $A3 $A4 $A2 $A0 $A1 $A0 $A1 $A0
.db $A1 $A5 $A6 $A5 $A6 $A5 $A6 $A7 $A4 $A8 $A7 $A5 $A6 $A5 $A6 $A5
.db $A6 $A9 $AA $A9 $AA $A9 $AA $AB $A8 $AC $AD $A9 $AA $A9 $AA $A9
.db $AA $AE $AF $AE $AF $AE $AF $AD $AC $B0 $B1 $AE $AF $AE $AF $AE
.db $AF $06 $B2 $86 $B3 $B0 $B4 $B5 $B6 $B7 $08 $B2 $87 $B7 $B6 $B5
.db $B4 $B8 $B9 $BA $0A $B2 $85 $BA $B9 $B8 $BB $BC $0C $B2 $84 $BD
.db $BE $BF $BD $0C $B2 $84 $C0 $C1 $C2 $C0 $0C $B2 $84 $C3 $C4 $C5
.db $C3 $06 $B2 $00 $09 $00 $81 $02 $0D $00 $83 $02 $00 $02 $0D $00
.db $81 $02 $0E $00 $02 $02 $0F $00 $81 $02 $0C $00 $04 $02 $0D $00
.db $03 $02 $11 $00 $81 $02 $0F $00 $81 $02 $0F $00 $81 $02 $06 $00
.db $00

; 10th entry of Pointer Table from 1A016 (indexed by _RAM_BUILDING_INDEX)
; Data from 18607 to 186E1 (219 bytes)
_DATA_18607:
.db $DE $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0
.db $A1 $A2 $A3 $A2 $A3 $A2 $A3 $A2 $A3 $A2 $A3 $A2 $A3 $A2 $A3 $A2
.db $A3 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0 $A1 $A0
.db $A1 $A2 $A3 $A4 $A5 $A4 $A5 $A4 $A5 $A4 $A5 $A4 $A5 $A4 $A5 $A4
.db $A5 $A6 $A7 $A8 $A9 $AA $AB $A8 $AA $A9 $A8 $A9 $A9 $A8 $A9 $AC
.db $AC $AA $AB $AA $AA $A8 $AA $A9 $A8 $AB $A9 $AA $A8 $AB $AD $02
.db $AE $C0 $A9 $AA $AF $AF $B0 $B1 $B2 $B3 $B4 $AF $AF $B5 $AA $B6
.db $B7 $B8 $AF $AF $AB $AA $B9 $BA $BB $BC $BD $BE $BF $C0 $A9 $C1
.db $C2 $C3 $A8 $C4 $C4 $A9 $A8 $AA $C5 $C6 $C7 $AA $A9 $C8 $C9 $CA
.db $CB $CC $A9 $A9 $AA $A8 $AB $A9 $A9 $AA $C4 $C4 $A9 $CD $CE $CF
.db $D0 $D1 $00 $47 $00 $8C $02 $00 $00 $02 $00 $00 $02 $00 $02 $00
.db $00 $02 $06 $00 $81 $02 $05 $00 $03 $02 $82 $00 $02 $06 $00 $81
.db $02 $06 $00 $81 $02 $10 $00 $02 $02 $82 $00 $02 $04 $00 $81 $02
.db $0A $00 $81 $02 $03 $00 $81 $02 $06 $00 $00

; 1st entry of Pointer Table from 19FFE (indexed by _RAM_BUILDING_INDEX)
; Data from 186E2 to 18B14 (1075 bytes)
_DATA_186E2:
.incbin "banks\lots_DATA_186E2.inc"

; 2nd entry of Pointer Table from 19FFE (indexed by _RAM_BUILDING_INDEX)
; Data from 18B15 to 18EE3 (975 bytes)
_DATA_18B15:
.db $16 $FF $82 $E1 $DC $03 $FF $8D $FC $F0 $EA $9D $6E $FF $FF $F1
.db $44 $2A $3D $7E $7D $03 $FF $85 $7F $3F $1F $9F $5F $04 $FF $02
.db $FE $82 $F8 $FC $02 $F7 $06 $FF $A8 $BF $B1 $7F $5E $7F $40 $3F
.db $00 $37 $AA $93 $0A $85 $C8 $12 $00 $7E $7D $3E $BD $58 $07 $BF
.db $00 $AF $0F $A7 $37 $1B $1D $EA $00 $FE $FD $FB $FF $FF $D4 $A0
.db $D0 $03 $FF $82 $E3 $DF $06 $FF $82 $03 $CF $03 $FF $83 $F7 $EF
.db $DF $05 $FF $09 $00 $97 $06 $0F $09 $0E $06 $04 $04 $AE $FF $BF
.db $E1 $82 $FE $E2 $D2 $75 $FF $FD $87 $41 $7F $47 $4B $04 $00 $85
.db $03 $0F $1F $3F $07 $06 $02 $84 $04 $00 $00 $F3 $02 $FF $03 $9E
.db $08 $00 $02 $02 $82 $01 $03 $02 $07 $02 $0F $83 $E6 $FA $F8 $02
.db $FC $02 $FE $81 $FF $02 $7F $02 $FF $84 $E3 $C1 $C1 $C3 $02 $08
.db $02 $10 $02 $08 $82 $04 $03 $06 $9E $85 $6D $FF $00 $00 $01 $02
.db $03 $03 $07 $81 $3C $07 $FF $81 $3F $0F $FF $83 $67 $7F $3D $02
.db $19 $02 $0F $81 $0D $08 $00 $02 $07 $03 $03 $03 $07 $18 $FF $08
.db $00 $81 $07 $06 $03 $81 $07 $10 $FF $07 $07 $81 $03 $10 $FF $00
.db $0A $00 $82 $01 $03 $02 $07 $02 $0F $20 $00 $81 $0F $03 $1F $03
.db $3F $89 $7F $08 $08 $1C $22 $42 $4A $56 $24 $0E $00 $81 $02 $07
.db $00 $81 $80 $09 $00 $02 $7F $02 $FF $07 $00 $85 $1F $3F $33 $01
.db $00 $03 $24 $04 $FF $89 $FE $0E $1F $33 $E3 $C6 $DC $F0 $00 $09
.db $FF $85 $F9 $F0 $F6 $F1 $F9 $02 $FB $02 $00 $83 $1E $3E $3C $03
.db $80 $02 $00 $02 $78 $81 $3C $03 $01 $05 $FF $84 $FE $F4 $E2 $F8
.db $03 $FD $03 $FC $84 $F8 $FF $FF $0C $02 $00 $03 $61 $08 $FF $02
.db $FD $02 $FF $94 $FE $FD $FE $FD $C0 $C0 $F0 $D8 $A8 $DC $AC $46
.db $D0 $E0 $D0 $BC $FE $FF $FF $FE $02 $F0 $02 $E0 $02 $F0 $82 $F8
.db $FC $06 $61 $82 $92 $00 $13 $FF $93 $FE $FF $FE $FD $FA $A1 $E4
.db $FF $BF $5A $90 $20 $24 $FC $DA $E7 $FF $FF $FE $02 $FA $18 $FF
.db $88 $FD $FA $F4 $FA $FC $EA $F4 $E9 $08 $00 $18 $FF $88 $D4 $E9
.db $F0 $A3 $D5 $A3 $C5 $EA $09 $FF $81 $FE $03 $FF $8B $FE $FD $FF
.db $46 $8C $DC $8C $56 $AD $56 $AF $00 $0C $00 $84 $01 $03 $05 $03
.db $07 $00 $81 $1C $05 $00 $83 $0A $1D $6E $03 $00 $85 $04 $2A $3D
.db $7E $7D $06 $00 $8A $80 $40 $07 $0B $07 $0A $15 $01 $0F $27 $08
.db $00 $A5 $3F $31 $7F $5E $7F $40 $3F $00 $37 $AA $93 $0A $85 $C8
.db $10 $00 $7E $7D $3E $BD $58 $07 $3F $00 $A0 $00 $A0 $30 $18 $1C
.db $EA $00 $13 $26 $55 $2B $7F $03 $FF $03 $00 $81 $1D $02 $21 $05
.db $00 $8D $FF $FE $75 $A8 $00 $0C $12 $22 $42 $04 $18 $E0 $00 $04
.db $FF $04 $00 $04 $FF $81 $0F $03 $07 $85 $F1 $C1 $C1 $DF $E3 $03
.db $7F $85 $8F $83 $83 $FB $C7 $03 $FE $04 $FF $08 $00 $03 $01 $81
.db $03 $03 $00 $02 $FF $03 $0C $08 $00 $02 $07 $81 $02 $05 $00 $02
.db $3F $81 $0F $02 $07 $02 $03 $81 $01 $08 $00 $02 $07 $02 $0F $02
.db $07 $82 $03 $00 $07 $0C $81 $FF $04 $00 $93 $01 $00 $00 $02 $00
.db $00 $14 $AA $55 $AE $5F $AE $00 $00 $40 $20 $40 $A0 $40 $11 $00
.db $04 $FF $04 $0F $90 $F9 $F8 $FD $FC $00 $00 $01 $00 $5D $3E $7D
.db $BE $7C $9A $74 $3A $10 $00 $08 $0F $81 $01 $07 $00 $88 $74 $A8
.db $50 $28 $50 $28 $10 $A0 $09 $00 $82 $02 $01 $03 $00 $8A $01 $00
.db $50 $A0 $40 $A0 $40 $A0 $50 $A0 $08 $00 $00 $0C $FF $84 $FE $FC
.db $FA $FC $07 $FF $81 $E3 $05 $FF $83 $F5 $E2 $91 $03 $FF $85 $FB
.db $D5 $C2 $81 $82 $06 $FF $8E $7F $BF $F8 $F4 $F8 $F5 $EA $FE $F0
.db $D8 $F7 $F7 $E3 $C1 $03 $81 $A5 $C3 $C0 $CE $80 $A1 $80 $BF $C0
.db $FF $C8 $55 $6C $F5 $7A $37 $ED $FF $81 $82 $C1 $42 $A7 $F8 $40
.db $FF $5F $FF $5F $CF $E7 $E3 $15 $FF $EC $D9 $AA $D4 $07 $FF $81
.db $E2 $02 $DE $02 $FF $03 $C3 $8C $00 $01 $8A $57 $FF $F3 $ED $DD
.db $BD $FB $E7 $1F $05 $FF $04 $00 $04 $FF $81 $0F $03 $07 $85 $F1
.db $C1 $C1 $DF $E3 $03 $7F $85 $8F $83 $83 $FB $C7 $03 $FE $04 $FF
.db $0F $00 $02 $FF $81 $0C $02 $0D $08 $00 $02 $07 $81 $02 $05 $00
.db $02 $3F $81 $0F $02 $07 $02 $03 $81 $01 $10 $00 $06 $6D $9A $0C
.db $FF $00 $00 $01 $03 $02 $07 $07 $05 $3C $FF $EB $55 $AA $51 $A0
.db $51 $38 $FC $B8 $D0 $B8 $50 $B0 $E0 $10 $00 $04 $FF $04 $0F $95
.db $FE $FF $FE $FF $03 $07 $06 $07 $A2 $C1 $82 $41 $83 $65 $8B $C5
.db $E0 $C0 $80 $80 $C0 $02 $80 $09 $00 $08 $0F $81 $06 $06 $03 $89
.db $07 $8B $56 $AF $D6 $AE $D4 $EE $5C $08 $00 $83 $07 $05 $06 $03
.db $07 $8A $06 $03 $A8 $58 $B0 $50 $B8 $50 $A8 $58 $08 $00 $00

; 9th entry of Pointer Table from 19FFE (indexed by _RAM_BUILDING_INDEX)
; Data from 18EE4 to 1929B (952 bytes)
_DATA_18EE4:
.db $09 $00 $9F $03 $04 $03 $17 $2F $40 $7A $00 $77 $18 $DB $D3 $D3
.db $18 $FF $40 $5F $5F $1F $5F $5F $40 $3E $18 $D3 $DB $D3 $CB $DB
.db $18 $FF $15 $00 $84 $50 $60 $50 $40 $03 $5F $02 $1F $84 $40 $6F
.db $18 $D3 $04 $DB $82 $08 $EF $05 $00 $A7 $01 $03 $03 $09 $47 $3A
.db $F8 $60 $E0 $78 $7E $60 $00 $28 $30 $28 $34 $18 $14 $40 $5F $5F
.db $1F $5F $40 $7B $00 $18 $D3 $DB $CB $CB $18 $F7 $00 $03 $02 $06
.db $02 $03 $03 $89 $05 $E2 $D2 $62 $60 $E0 $E0 $E1 $70 $04 $FF $04
.db $00 $84 $D8 $D4 $C0 $FF $04 $00 $84 $55 $AA $55 $AA $04 $00 $90
.db $F9 $FA $FA $F8 $02 $03 $02 $02 $72 $B1 $B8 $B9 $FC $5B $DC $F8
.db $06 $00 $02 $01 $8C $1C $22 $49 $54 $AE $94 $28 $50 $01 $03 $3F
.db $FE $04 $7E $86 $5C $18 $88 $80 $0E $45 $02 $40 $10 $00 $03 $03
.db $8D $06 $04 $05 $04 $06 $3C $1E $8D $3E $B0 $78 $BC $7A $05 $7F
.db $02 $3F $89 $BF $40 $21 $12 $95 $8D $86 $E3 $FF $10 $00 $81 $07
.db $02 $06 $02 $02 $93 $03 $01 $01 $3C $7A $BC $7A $BC $7A $3C $79
.db $3F $9F $5F $1F $4F $B7 $9B $5C $07 $FF $81 $FC $10 $00 $81 $03
.db $03 $02 $9C $06 $05 $04 $05 $3D $79 $BD $79 $B2 $7A $F2 $62 $5F
.db $2B $25 $12 $11 $08 $09 $08 $03 $FF $DD $A8 $43 $1F $7F $BF $00
.db $09 $FF $89 $FC $FB $FF $EF $DF $BF $85 $FF $88 $02 $E7 $02 $EF
.db $82 $E7 $00 $03 $BF $81 $FF $03 $BF $89 $C1 $E7 $EF $E7 $EF $F7
.db $E7 $E7 $00 $07 $FF $89 $FE $FD $FE $E3 $CE $B1 $47 $30 $40 $05
.db $FF $83 $D5 $E3 $D5 $04 $BF $02 $FF $84 $BF $90 $E7 $EF $04 $E7
.db $9A $F7 $10 $FE $FE $FA $FC $F8 $FD $FF $F9 $09 $46 $38 $E0 $40
.db $C0 $46 $40 $E3 $FF $EB $F1 $EB $F5 $F8 $F5 $03 $BF $9D $FF $BF
.db $BF $84 $FF $E7 $EF $E7 $F7 $F7 $E7 $08 $FF $F8 $F9 $FD $F9 $FE
.db $FE $FB $FD $DC $F8 $40 $40 $C0 $40 $80 $40 $04 $00 $04 $FF $84
.db $38 $35 $3F $00 $04 $FF $04 $00 $04 $FF $90 $01 $02 $02 $04 $FA
.db $FF $FE $FA $61 $A0 $B0 $B0 $F0 $50 $D0 $F0 $06 $FF $02 $FE $8C
.db $E3 $C1 $88 $94 $2E $14 $28 $50 $FD $FB $BC $55 $04 $54 $88 $50
.db $70 $00 $60 $90 $3A $00 $30 $10 $FF $03 $FC $02 $F8 $8B $F9 $F8
.db $F8 $3C $1E $0D $3E $B0 $78 $BC $7A $03 $54 $89 $5A $55 $2D $29
.db $AA $08 $18 $04 $08 $04 $00 $10 $FF $03 $F8 $03 $FC $02 $FE $98
.db $3C $7A $BC $7A $BC $7A $3C $78 $2A $95 $56 $15 $4B $34 $1B $9C
.db $1C $22 $C9 $14 $E3 $FC $03 $FC $10 $FF $04 $FC $9C $F8 $F9 $F8
.db $F9 $3C $78 $BC $78 $B1 $79 $F1 $61 $9F $CB $C5 $E2 $E1 $F0 $F1
.db $F0 $03 $FF $DD $A8 $43 $1F $7F $BF $00 $2D $00 $02 $01 $84 $03
.db $06 $1F $7F $05 $FF $05 $00 $03 $7F $10 $00 $02 $03 $06 $07 $02
.db $FF $88 $FE $F8 $E0 $E0 $C0 $FE $7F $00 $04 $3F $02 $1F $10 $00
.db $08 $07 $83 $E2 $C6 $E2 $03 $E0 $82 $E1 $F0 $08 $00 $82 $1F $1E
.db $0E $00 $08 $07 $88 $F3 $F1 $F8 $F9 $FC $FB $FC $F8 $06 $00 $02
.db $01 $8C $1C $3E $77 $6B $D1 $EB $D7 $AF $07 $07 $43 $83 $04 $82
.db $86 $FC $F8 $E8 $E0 $FE $7F $02 $70 $10 $00 $03 $03 $02 $07 $8B
.db $06 $07 $07 $C3 $E1 $F2 $C1 $4F $87 $43 $85 $03 $81 $02 $80 $02
.db $C0 $89 $40 $7C $3D $1F $9E $8E $87 $63 $1F $10 $00 $03 $07 $03
.db $03 $02 $01 $90 $C3 $85 $43 $85 $43 $85 $C3 $87 $C0 $60 $A0 $E0
.db $B0 $C8 $E4 $63 $07 $00 $81 $03 $10 $00 $04 $03 $9C $07 $06 $07
.db $06 $C3 $87 $43 $87 $4E $86 $0E $9E $60 $34 $3A $1D $1E $0F $0E
.db $0F $FC $00 $22 $57 $BC $E0 $80 $40 $00 $3D $FF $83 $2F $1F $2F
.db $15 $FF $93 $FE $FC $FC $F6 $B8 $C5 $07 $9F $1F $BF $81 $1F $00
.db $97 $8F $97 $8B $C7 $CB $10 $FF $02 $FC $81 $F8 $04 $FC $89 $FA
.db $1D $21 $9D $9F $1F $1F $1E $8F $08 $FF $82 $C7 $CB $0E $FF $90
.db $FE $FD $FD $FF $FD $FC $FD $FD $8C $4E $47 $46 $03 $A4 $23 $07
.db $09 $FF $83 $E3 $C1 $C0 $02 $80 $02 $00 $82 $FE $FC $02 $80 $04
.db $01 $86 $A3 $E7 $77 $7F $61 $B0 $02 $BF $02 $00 $82 $F3 $FB $03
.db $FF $84 $3F $00 $00 $EF $03 $FF $86 $BE $3E $03 $C7 $DF $FE $03
.db $FC $84 $DE $00 $00 $80 $0D $00 $8B $BF $DF $EE $6C $74 $7A $1D
.db $00 $00 $E3 $F7 $03 $FF $84 $F7 $66 $00 $F7 $04 $FF $88 $FE $E6
.db $07 $C6 $EE $FE $FE $FF $02 $F7 $07 $00 $81 $01 $05 $00 $02 $80
.db $81 $C0 $09 $00 $82 $D7 $F7 $03 $FF $84 $FB $EB $00 $9F $04 $FF
.db $84 $DF $8C $03 $DE $03 $FE $03 $FC $04 $01 $04 $03 $81 $40 $02
.db $E0 $02 $F0 $03 $F8 $08 $00 $00

; 11th entry of Pointer Table from 19FFE (indexed by _RAM_BUILDING_INDEX)
; Data from 1929C to 1959E (771 bytes)
_DATA_1929C:
.db $03 $80 $85 $C0 $80 $80 $C3 $FF $03 $01 $88 $03 $01 $01 $05 $FF
.db $01 $01 $03 $03 $01 $8D $03 $FF $80 $80 $C0 $83 $8F $9F $BF $9F
.db $06 $3E $FE $05 $FF $02 $80 $81 $C0 $03 $80 $85 $84 $FF $8F $C7
.db $EF $03 $FF $02 $1F $08 $FF $03 $80 $90 $C0 $81 $80 $C2 $FD $05
.db $10 $40 $88 $C0 $90 $94 $54 $81 $01 $03 $03 $01 $82 $03 $7F $06
.db $FF $02 $1F $90 $07 $04 $0E $0D $0C $0F $05 $FF $56 $9B $CB $5D
.db $E2 $82 $81 $C1 $05 $FF $83 $9F $1F $3F $05 $FF $03 $FE $03 $8F
.db $90 $CB $8B $8F $CF $FD $FD $FE $C2 $C2 $A6 $1E $04 $84 $80 $80
.db $C0 $04 $80 $91 $F0 $07 $07 $01 $00 $10 $A8 $78 $F0 $C8 $5E $1F
.db $B1 $E0 $64 $CA $8F $07 $00 $85 $C0 $68 $B1 $69 $11 $02 $01 $02
.db $00 $8B $DD $88 $1C $B8 $50 $A8 $B0 $F8 $01 $01 $02 $04 $00 $99
.db $F8 $81 $00 $01 $02 $05 $0A $05 $0B $50 $A8 $55 $FA $FF $BF $FF
.db $FF $70 $28 $34 $28 $1A $9C $4A $8C $03 $80 $9D $C0 $80 $80 $C0
.db $F0 $05 $0A $05 $0A $01 $00 $01 $03 $7F $BF $7F $BF $7F $BF $FF
.db $7F $CA $E4 $C6 $E4 $D2 $E9 $F0 $F8 $07 $00 $97 $E0 $05 $02 $05
.db $0A $01 $02 $05 $00 $DF $FF $77 $BF $7F $FF $7B $DF $F8 $F8 $FC
.db $F8 $FC $F8 $02 $FC $00 $82 $80 $F7 $06 $FF $82 $01 $E7 $06 $FF
.db $82 $01 $D7 $06 $FF $82 $80 $F7 $04 $FF $8C $FE $FC $07 $FF $FF
.db $FC $E0 $80 $00 $00 $80 $F7 $06 $FF $02 $F8 $03 $F0 $03 $E0 $08
.db $00 $82 $80 $F7 $06 $FF $81 $07 $07 $FF $82 $81 $57 $06 $FF $08
.db $E0 $82 $07 $D7 $08 $FF $86 $FE $F7 $FE $FE $7F $7E $05 $E0 $03
.db $FF $05 $00 $03 $FF $82 $83 $F3 $02 $F1 $04 $F0 $85 $3E $02 $00
.db $3C $18 $03 $00 $82 $80 $F7 $03 $FF $A3 $FE $FC $FA $00 $D0 $FE
.db $A3 $01 $02 $01 $03 $00 $08 $0E $1F $3F $BF $FF $FF $14 $FA $FC
.db $FA $FD $FF $FC $F2 $01 $03 $03 $07 $03 $D7 $7F $0F $08 $FF $82
.db $01 $D7 $05 $FF $8A $FE $D8 $A0 $40 $B0 $C0 $80 $40 $80 $01 $07
.db $00 $81 $FF $03 $7F $02 $3F $02 $1F $90 $83 $F6 $FF $FE $FF $FE
.db $FF $FE $00 $80 $20 $80 $20 $A8 $60 $D0 $08 $00 $81 $1F $03 $0F
.db $94 $07 $03 $01 $03 $07 $DF $FF $FE $FF $FE $FD $FE $A0 $A0 $40
.db $80 $50 $A0 $50 $A0 $08 $00 $82 $01 $03 $06 $01 $00 $45 $00 $02
.db $01 $02 $02 $87 $0F $3F $77 $3F $6F $6B $AB $11 $00 $8F $03 $01
.db $02 $03 $00 $02 $00 $A9 $64 $35 $A9 $03 $03 $FD $BF $10 $00 $02
.db $0C $02 $0E $04 $0F $85 $C3 $FD $FF $C3 $E7 $03 $FF $04 $00 $81
.db $03 $03 $0F $02 $07 $81 $7F $06 $FF $87 $F7 $F1 $EE $DF $DB $35
.db $70 $02 $1F $02 $0F $85 $07 $03 $0F $3F $FF $05 $FE $02 $FF $88
.db $22 $77 $E3 $47 $AF $57 $4F $07 $02 $00 $03 $01 $84 $03 $07 $07
.db $7F $0F $FF $89 $8F $D7 $CB $D7 $E5 $E3 $F5 $F3 $03 $03 $07 $04
.db $0F $10 $FF $89 $F5 $FB $F9 $FB $FD $FE $FF $FF $07 $03 $0F $04
.db $1F $18 $FF $00 $1F $FF $81 $9F $03 $FE $0D $FF $83 $8F $C7 $EF
.db $03 $FF $02 $1F $0C $FF $8C $FE $FF $FD $FA $FB $EF $BF $77 $3F
.db $6F $6B $AB $0E $FF $02 $1F $90 $F8 $FB $F1 $F2 $F3 $F0 $FA $F8
.db $A9 $64 $35 $A8 $01 $01 $FC $BF $05 $FF $83 $9F $1F $3F $05 $FF
.db $03 $FE $02 $FC $02 $FE $04 $FF $85 $C3 $FD $FF $C3 $E7 $07 $FF
.db $81 $FC $03 $F0 $02 $FF $81 $81 $05 $00 $88 $FF $F7 $F1 $EE $DF
.db $5B $35 $70 $02 $E0 $02 $F0 $84 $F8 $FC $F0 $C0 $08 $00 $88 $22
.db $77 $E3 $47 $AF $57 $4F $07 $02 $FF $03 $FE $84 $FC $F8 $F8 $80
.db $0F $00 $89 $0F $17 $0B $17 $05 $03 $05 $03 $FC $03 $F8 $04 $F0
.db $10 $00 $85 $05 $03 $01 $03 $01 $03 $00 $81 $F8 $03 $F0 $04 $E0
.db $18 $00 $00

; 8th entry of Pointer Table from 19FFE (indexed by _RAM_BUILDING_INDEX)
; Data from 1959F to 19910 (882 bytes)
_DATA_1959F:
.db $CD $A9 $55 $AF $D8 $55 $AA $53 $EC $A3 $58 $B7 $47 $9A $E9 $55
.db $A8 $31 $62 $45 $2A $85 $48 $C0 $88 $31 $A9 $64 $9A $55 $26 $58
.db $A5 $48 $98 $26 $AC $55 $02 $91 $0E $13 $69 $86 $5B $14 $20 $00
.db $10 $75 $84 $8B $50 $2A $44 $10 $2C $54 $8A $90 $00 $02 $05 $02
.db $01 $21 $44 $AB $14 $A0 $40 $25 $4A $10 $20 $10 $10 $20 $02 $10
.db $C1 $20 $42 $14 $20 $44 $12 $28 $54 $22 $08 $05 $12 $04 $28 $10
.db $00 $05 $15 $A0 $41 $A0 $55 $C8 $A5 $CA $10 $A0 $10 $00 $40 $80
.db $40 $28 $00 $20 $10 $20 $10 $10 $20 $10 $2A $54 $24 $12 $40 $04
.db $08 $44 $E4 $80 $C0 $8A $11 $20 $40 $C4 $90 $48 $00 $00 $14 $80
.db $04 $0A $08 $FF $B2 $C9 $D2 $80 $80 $A8 $01 $20 $50 $8A $95 $7E
.db $83 $20 $84 $01 $00 $04 $02 $24 $00 $A5 $00 $00 $11 $73 $2C $35
.db $9A $24 $50 $A6 $C9 $7F $9F $3F $9F $5F $BF $BF $7F $00 $40 $00
.db $40 $A0 $09 $91 $48 $42 $52 $03 $11 $E3 $48 $A8 $A4 $92 $8D $1B
.db $2B $57 $EF $1F $7F $D6 $A9 $AB $A5 $2A $24 $21 $30 $12 $74 $39
.db $04 $12 $C4 $2A $51 $91 $80 $A2 $A2 $C0 $C1 $80 $85 $68 $84 $20
.db $14 $61 $44 $04 $84 $12 $11 $22 $20 $62 $54 $28 $50 $20 $54 $20
.db $84 $82 $A4 $8A $A4 $8A $04 $08 $08 $10 $80 $00 $80 $29 $50 $21
.db $12 $21 $02 $05 $02 $8A $85 $80 $05 $42 $21 $52 $21 $00 $80 $40
.db $04 $40 $20 $45 $AA $04 $00 $04 $08 $80 $48 $50 $08 $00 $84 $08
.db $41 $04 $48 $03 $00 $ED $13 $A2 $48 $22 $01 $00 $04 $AA $57 $1C
.db $4C $1A $10 $1A $35 $3A $75 $8E $06 $0B $44 $A8 $59 $A5 $52 $37
.db $43 $98 $51 $AA $74 $2E $E1 $EC $96 $79 $A4 $EB $DF $FF $EF $82
.db $53 $64 $83 $C1 $B3 $C7 $C3 $A3 $75 $6F $FE $FD $F8 $F8 $FA $54
.db $AB $54 $AB $5F $BA $CA $B4 $EF $DF $EF $EF $DF $EF $EF $DF $A5
.db $C3 $CB $AB $C5 $C3 $A3 $C5 $F5 $F2 $E9 $F3 $C7 $EE $F9 $F2 $EA
.db $5F $BE $44 $8A $25 $5A $35 $AF $5F $E7 $FF $3F $1F $2F $D7 $FF
.db $DF $EF $DF $02 $EF $9A $DF $EF $C1 $83 $C3 $C5 $AB $E3 $D3 $A9
.db $1B $7F $38 $45 $AE $DF $B1 $2A $6F $B7 $F7 $77 $AB $7F $DB $D5
.db $08 $00 $A8 $36 $2D $6F $6E $55 $FE $DB $AB $75 $6A $81 $7C $83
.db $69 $DE $BF $DB $6D $4B $6E $5A $ED $BF $AE $83 $CC $91 $62 $9B
.db $06 $08 $34 $00 $80 $00 $60 $A0 $40 $40 $80 $02 $BF $EE $FF $9F
.db $47 $F2 $4C $26 $B4 $AD $A6 $A6 $A4 $B7 $57 $53 $49 $32 $44 $94
.db $A8 $10 $E0 $80 $21 $10 $54 $5A $55 $5A $CC $CF $29 $8B $46 $FB
.db $4D $29 $D5 $2E $6C $75 $5D $55 $3B $3A $5F $6A $85 $3B $C5 $8B
.db $1E $BA $73 $7A $E4 $EE $D5 $CF $9D $A9 $D5 $AF $CD $AB $DD $79
.db $7D $59 $75 $5A $64 $F9 $E7 $D7 $CF $6F $FF $7F $D6 $AF $D6 $AD
.db $8E $DD $FA $FD $75 $5A $7F $DA $AD $CE $AD $DE $FF $3F $B9 $72
.db $9F $5F $BA $55 $FB $F6 $F2 $F7 $7E $95 $AD $F7 $00 $84 $F7 $BE
.db $FB $B7 $03 $FF $8B $EC $5D $B7 $DD $FE $FF $B3 $01 $80 $E0 $B0
.db $03 $E0 $02 $C0 $81 $80 $10 $00 $85 $13 $69 $86 $5B $05 $03 $CF
.db $85 $01 $80 $81 $00 $80 $03 $81 $86 $40 $80 $80 $00 $80 $C0 $02
.db $E0 $08 $00 $08 $CF $08 $81 $03 $C0 $05 $80 $08 $00 $05 $01 $83
.db $03 $07 $03 $07 $CF $81 $87 $06 $81 $0A $00 $02 $03 $03 $01 $03
.db $00 $08 $FF $02 $C0 $03 $80 $13 $00 $81 $60 $07 $00 $81 $3F $04
.db $1F $02 $3F $81 $7F $11 $00 $87 $01 $03 $03 $07 $0F $1F $7F $0A
.db $00 $81 $01 $04 $00 $81 $01 $04 $80 $02 $C0 $02 $80 $13 $00 $05
.db $80 $10 $00 $03 $80 $15 $00 $00 $0D $00 $83 $4C $FE $7E $02 $0F
.db $04 $1F $02 $3F $10 $FF $04 $00 $04 $30 $08 $7E $81 $3F $04 $7F
.db $81 $3F $02 $1F $08 $FF $08 $30 $08 $7E $03 $3F $05 $7F $08 $FF
.db $05 $FE $83 $FC $F8 $FC $07 $30 $81 $78 $06 $7E $0A $FF $02 $FC
.db $03 $FE $19 $FF $82 $E1 $C0 $18 $FF $03 $C0 $83 $E0 $F9 $FD $14
.db $FF $04 $BF $02 $3F $0B $FF $02 $FE $03 $FF $86 $FE $FC $FE $FE
.db $FF $EF $02 $CF $02 $1F $02 $3F $84 $7F $7E $7E $FD $08 $FF $8E
.db $DF $9E $9C $BC $B8 $B8 $90 $80 $FD $79 $7B $73 $73 $27 $02 $07
.db $08 $FF $84 $80 $C0 $C6 $CF $04 $FF $81 $07 $03 $0F $81 $8F $03
.db $FF $00

; 10th entry of Pointer Table from 19FFE (indexed by _RAM_BUILDING_INDEX)
; Data from 19911 to 19E80 (1392 bytes)
_DATA_19911:
.incbin "banks\lots_DATA_19911.inc"

; 1st entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19E81 to 19E90 (16 bytes)
_DATA_19E81:
.db $00 $2A $00 $05 $39 $3E $29 $24 $30 $2A $16 $01 $0B $06 $1A $00

; 3rd entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19E91 to 19EA0 (16 bytes)
_DATA_19E91:
.db $00 $2A $00 $01 $18 $1D $03 $02 $10 $2A $16 $01 $0B $06 $06 $00

; 4th entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19EA1 to 19EB0 (16 bytes)
_DATA_19EA1:
.db $00 $2A $00 $15 $05 $0A $03 $02 $38 $10 $16 $01 $0B $06 $2A $00

; 5th entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19EB1 to 19EC0 (16 bytes)
_DATA_19EB1:
.db $00 $2A $00 $00 $15 $2A $30 $20 $38 $0C $16 $01 $0B $06 $00 $00

; 7th entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19EC1 to 19ED0 (16 bytes)
_DATA_19EC1:
.db $00 $2A $00 $01 $04 $08 $32 $21 $03 $05 $16 $01 $0B $06 $02 $00

; 2nd entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19ED1 to 19EE0 (16 bytes)
_DATA_19ED1:
.db $00 $2A $00 $2A $34 $08 $0F $0A $04 $25 $03 $05 $0B $06 $01 $00

; 9th entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19EE1 to 19EF0 (16 bytes)
_DATA_19EE1:
.db $00 $2A $00 $3A $25 $17 $02 $05 $1B $06 $01 $34 $0A $20 $0F $00

; 11th entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19EF1 to 19F00 (16 bytes)
_DATA_19EF1:
.db $00 $2A $00 $1A $35 $3A $20 $03 $13 $30 $12 $01 $0B $06 $2F $00

; 12th entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19F01 to 19F10 (16 bytes)
_DATA_19F01:
.db $00 $2A $00 $2A $14 $19 $00 $02 $0B $30 $06 $01 $0B $06 $3F $00

; 8th entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19F11 to 19F20 (16 bytes)
_DATA_19F11:
.db $00 $2A $00 $0C $08 $04 $10 $0F $0B $06 $01 $2F $0A $05 $3F $00

; 10th entry of Pointer Table from 19FE6 (indexed by _RAM_BUILDING_INDEX)
; Data from 19F21 to 19F30 (16 bytes)
_DATA_19F21:
.db $00 $2A $00 $2A $25 $17 $02 $05 $0B $15 $01 $03 $0A $09 $0F $00

; Data from 19F31 to 19F96 (102 bytes)
_DATA_19F31:
.db $81 $47 $10 $46 $82 $47 $45 $10 $00 $02 $45 $10 $00 $02 $45 $10
.db $00 $02 $45 $10 $00 $02 $45 $10 $00 $02 $45 $10 $00 $02 $45 $10
.db $00 $02 $45 $10 $00 $02 $45 $10 $00 $02 $45 $10 $00 $82 $45 $47
.db $10 $46 $81 $47 $00 $11 $04 $81 $06 $11 $00 $81 $02 $11 $00 $81
.db $02 $11 $00 $81 $02 $11 $00 $81 $02 $11 $00 $81 $02 $11 $00 $81
.db $02 $11 $00 $81 $02 $11 $00 $81 $02 $11 $00 $81 $02 $11 $00 $81
.db $02 $11 $00 $81 $02 $00

; Data from 19F97 to 19FE5 (79 bytes)
_DATA_19F97:
.db $81 $47 $16 $46 $82 $47 $45 $16 $20 $02 $45 $16 $20 $02 $45 $16
.db $20 $02 $45 $16 $20 $02 $45 $16 $20 $02 $45 $16 $20 $02 $45 $16
.db $20 $82 $45 $47 $16 $46 $81 $47 $00 $17 $04 $81 $06 $17 $00 $81
.db $02 $17 $00 $81 $02 $17 $00 $81 $02 $17 $00 $81 $02 $17 $00 $81
.db $02 $17 $00 $81 $02 $17 $00 $82 $02 $00 $16 $00 $81 $02 $00

; Pointer Table from 19FE6 to 19FFD (12 entries, indexed by _RAM_BUILDING_INDEX)
_DATA_19FE6:
.dw _DATA_19E81 _DATA_19ED1 _DATA_19E91 _DATA_19EA1 _DATA_19EB1 _DATA_19E81 _DATA_19EC1 _DATA_19F11
.dw _DATA_19EE1 _DATA_19F21 _DATA_19EF1 _DATA_19F01

; Pointer Table from 19FFE to 1A015 (12 entries, indexed by _RAM_BUILDING_INDEX)
_DATA_19FFE:
.dw _DATA_186E2 _DATA_18B15 _DATA_186E2 _DATA_186E2 _DATA_186E2 _DATA_186E2 _DATA_186E2 _DATA_1959F
.dw _DATA_18EE4 _DATA_19911 _DATA_1929C _DATA_1929C

; Pointer Table from 1A016 to 1A02D (12 entries, indexed by _RAM_BUILDING_INDEX)
_DATA_1A016:
.dw _DATA_18227 _DATA_182DC _DATA_18227 _DATA_18227 _DATA_18227 _DATA_18227 _DATA_18227 _DATA_18566
.dw _DATA_183A6 _DATA_18607 _DATA_18480 _DATA_18480

; Data from 1A02E to 1ABC6 (2969 bytes)
; NPC Text
.db $15 $20 $92
.asc "LANDAU,WE PRAY FOR"
.db $17 $20 $91
.asc "THEE. IF THOU ART"
.db $17 $20 $90
.asc "TIRED,REST HERE!"
.db $02 $20 $00

.db $15 $20 $91
.asc "CAST THIS BOOK IN"
.db $16 $20 $94
.asc "THE MOUNTAIN OF FIRE"
.db $14 $20 $94
.asc "AND RETURN. PROTECT "
.db $00 $15 $20 $92
.asc "IT WELL! AND GO TO"
.db $16 $20 $92
.asc "ULMO WOODS FOR THE"
.db $17 $20 $8F
.asc "TREE OF MARILL!"
.db $03 $20 $00

.db $14 $20 $93
.asc "THE DAUGHTER OF THE"
.db $16 $20 $92
.asc "MAYOR OF LINDON IS"
.db $1B $20 $88
.asc "MISSING!"
.db $06 $20 $00

.db $15 $20 $92
.asc "ARE THERE NO BRAVE"
.db $17 $20 $8F
.asc "MEN LEFT IN OUR"
.db $1F $20 $85
.asc "LAND"
.db $41
.db $07 $20 $00

.db $16 $20 $8D
.asc "THAT RACE STI" $02 "L"
.db $17 $20 $93
.asc "EXISTS,I'D VENTURE."
.db $16 $20 $93
.asc "PERHAPS THEY COULD "
.db $00 $15 $20 $91
.asc "STILL BE FOUND IN"
.db $17 $20 $92
.asc "THE WOODS OF NAMO?I " ; TODO: Pretty sure this is part of the command
.db $00 $15 $20 $91
.asc "HAST THOU MET THE"
.db $1A $20 $8C
.asc "TREE PEOPLE?L " ; TODO: Pretty sure this is part of the command
.db $00 $16 $20 $8F
.asc "THOSE WOODS ARE"
.db $17 $20 $93
.asc "HAUNTED BY FEARSOME"
.db $18 $20 $8D
.asc "TREE SPIRITS!"
.db $04 $20 $00

.db $14 $20 $94
.asc "HAST THOU PASSED THE"
.db $15 $20 $90
.asc "FIRST OF THE THR" $02 "E"
.db $1C $20 $86
.asc "TESTS?"
.db $07 $20 $00

.db $15 $20 $91
.asc "BRAVE WARRIOR,RID"
.db $19 $20 $8E
.asc "US OF THE EVIL"
.db $1A $20 $8E
.asc "SWAMP SPIRITS!"
.db $03 $20 $00

.db $14 $20 $94
.asc "THEY SAY SHAGART HAS"
.db $16 $20 $8F
.asc "BECOME A DEN OF"
.db $1D $20 $88
.asc "THIEVES!"
.db $06 $20 $00

.db $16 $20 $8F
.asc "MY DAUGHTER WAS"
.db $17 $20 $93
.asc "TAKEN BY PIRATES TO"
.db $17 $20 $90
.asc "FALAS! SAVE HER,"
.db $02 $20 $00

.db $14 $20 $91
.asc "AND THY REWARD WI" $02 "L"
.db $15 $20 $94
.asc "BE GREAT! FOLLOW THE"
.db $14 $20 $94
.asc "COAST TO THE ISLAND."
.db $00 $14 $20 $94
.asc "RA GOAN'S EVIL POWER"
.db $14 $20 $94
.asc "IS SEALED WITHIN THE"
.db $15 $20 $91
.asc "BOOK. DESTROY IT!"
.db $02 $20 $00

.db $18 $20 $8C
.asc "MANY THANKS!"
.db $18 $20 $94
.asc "ACCEPT THIS BOW AS A"
.db $16 $20 $90
.asc "REWARD! THERE IS"
.db $02 $20 $00
.db $14 $20 $94
.asc "ALSO A SHORTCUT FROM"
.db $15 $20 $92
.asc "SHAGART TO DWARLE."
.db $15 $20 $94
.asc "COME VISIT ANYTIME! "
.db $00 $15 $20 $92
.asc "MY DEEPEST THANKS!"
.db $17 $20 $90
.asc "I HAVE HEARD THE"
.db $17 $20 $91
.asc "PIRATES KNOW MUCH"
.db $02 $20 $00
.db $14 $20 $94
.asc "OF THE LORD OF ELDER"
.db $15 $20 $91
.asc "CASTLE IN THE FAR"
.db $18 $20 $90
.asc "LAND OF YAVANNA."
.db $02 $20 $00
.db $16 $20 $90
.asc "MT.MORGOS TO THE"
.db $16 $20 $93
.asc "NORTH IS CALLED THE"
.db $16 $20 $91
.asc "MOUNTAIN OF FIRE!"
.db $02 $20 $00
.db $18 $20 $8B
.asc "THY WEAPONS"
.db $19 $20 $94
.asc "WOULD NOT DEFEAT THE"
.db $14 $20 $94
.asc "BEAST OF MT.MORGOS! "
.db $00 $14 $20 $94
.asc "OF THE LORD OF ELDER"
.db $15 $20 $91
.asc "CASTLE IN THE FAR"
.db $18 $20 $90
.asc "LAND OF YAVANNA."
.db $02 $20 $00
.db $15 $20 $92
.asc "THANK THEE KINDLY."
.db $17 $20 $90
.asc "PLEASE REST HERE"
.db $1C $20 $87
.asc "AWHILE."
.db $07 $20 $00
.db $14 $20 $94
.asc "IF THOU CAN OVERCOME"
.db $14 $20 $93
.asc "5 MEN IN A DUEL,I'D"
.db $15 $20 $94
.asc "TELL THEE ANYTHING. "
.db $00 $15 $20 $92
.asc "FOR THE STATUE,USE"
.db $16 $20 $91
.asc "THIS HERB,A SWORD"
.db $16 $20 $94
.asc "LIES IN THE VALLEY. "
.db $00 $15 $20 $92
.asc "THERE IS A STRANGE"
.db $16 $20 $92
.asc "STATUE ON MT.OZGUL"
.db $19 $20 $8C
.asc "TO THE WEST."
.db $04 $20 $00
.db $16 $20 $8F
.asc "THERE IS A PATH"
.db $1B $20 $8C
.asc "FROM HERE TO"
.db $1F $20 $85
.asc "AMON."
.db $08 $20 $00
.db $17 $20 $8D
.asc "ON THE WAY TO"
.db $18 $20 $93
.asc "PHARAZON,THERE IS A"
.db $15 $20 $94
.asc "ROAD TO A MOUNTAIN. "
.db $00 $15 $20 $92
.asc "HAST THOU NOT CAST"
.db $16 $20 $92
.asc "THAT BOOK INTO THE"
.db $16 $20 $91
.asc "MOUNTAIN OF FIRE?"
.db $02 $20 $00
.db $14 $20 $93
.asc "STRANGE PEOPLE HAVE"
.db $15 $20 $94
.asc "GATHERED AT SHAGART,"
.db $15 $20 $91
.asc "THIEVES AND SUCH."
.db $02 $20 $00
.db $17 $20 $8E
.asc "JUST ONE MORE,"
.db $1E $20 $86
.asc "RIGHT?O "
.db $00 $15 $20 $91
.asc "KILL THE BEAST AT"
.db $16 $20 $94
.asc "THE MOUNTAIN OF FIRE"
.db $14 $20 $94
.asc "AND CLAIM A REWARD! "
.db $00 $14 $20 $94
.asc "GO NORTH FROM DWARLE"
.db $14 $20 $94
.asc "AND THOU WILT FIND A"
.db $15 $20 $91
.asc "PATH TO THE WEST."
.db $02 $20 $00
.db $14 $20 $93
.asc "HAST THOU DESTROYED"
.db $15 $20 $94
.asc "THE BOOK? THIS SWORD"
.db $16 $20 $8E
.asc "IS THY REWARD!"
.db $04 $20 $00
.db $16 $20 $90
.asc "PERSEVERE JUST A"
.db $17 $20 $92
.asc "LITTLE BIT LONGER."
.db $29 $20 $00
.db $16 $20 $90
.asc "SHAGART PLANS RA"
.db $16 $20 $93
.asc "GOAN'S RESTORATION!"
.db $15 $20 $94
.asc "THOU NEEDST WEAPONS!"
.db $00

.db $16 $20 $8F
.asc "CONGRATULATION!"
.db $17 $20 $93
.asc "THOU HAST DONE MUCH"
.db $1B $20 $89
.asc "SO SOONS!"
.db $05 $20 $00
.db $15 $20 $92
.asc "SHAGART HAS BECOME"
.db $15 $20 $91
.asc "STRANGE! GO AND S" $02 "E"
.db $19 $20 $8C
.asc "FOR THYSELF!"
.db $04 $20 $00
.db $16 $20 $90
.asc "THOU HAST FOUGHT"
.db $18 $20 $90
.asc "HARD! THOU SHALT"
.db $17 $20 $91
.asc "MAKE A FINE KING!"
.db $02 $20 $00
.db $15 $20 $8F
.asc "WELCOME THE NEW"
.db $18 $20 $92
.asc "KING! OUR LAND SHA" $02 "L"
.db $1A $20 $88
.asc "BE SAFE!"
.db $06 $20 $00
.db $17 $20 $8D
.asc "BRAVE LANDAU!"
.db $1A $20 $90
.asc "RULE OUR COUNTRY"
.db $1D $20 $85
.asc "WELL!"
.db $08 $20 $00
.db $14 $20 $93
.asc "HAST THOU DESTROYED"
.db $15 $20 $93
.asc "THE BOOK? DO SO,AND"
.db $18 $20 $8E
.asc "GAIN A REWARD!"
.db $03 $20 $00
.db $14 $20 $94
.asc "THE BOOK WAS STOLEN?"
.db $14 $20 $93
.asc "THEN WE HAVE NAUGHT"
.db $17 $20 $90
.asc "BUT THY BRAVERY!"
.db $02 $20 $00
.db $15 $20 $8F
.asc "WE HAVE ONLY TH" $02 "E"
.db $1A $20 $8B
.asc "TO RELY ON!"
.db $2D $20 $00
.db $17 $20 $8D
.asc "THE PEOPLE OF"
.db $1B $20 $8D
.asc "ITHILE SUFFER"
.db $1F $20 $88
.asc "GREATLY!"
.db $05 $20 $00
.db $18 $20 $8C
.asc "GO TO VARLIN"
.db $1E $20 $87
.asc "CASTLE!"
.db $2F $20 $00 $17 $20 $8C
.asc "BRAVE LANDAU"
.db $1B $20 $8F
.asc "WE PRAY FOR THY"
.db $1D $20 $88
.asc "SUCCESS!"
.db $06 $20 $00
.db $43 $20 $04
.db $3C $31 $20
.db $00

.db $14 $20 $93
.asc "THOU HAST FULFILLED"
.db $16 $20 $92
.asc "THY PROMISE TO THE"
.db $15 $20 $94
.asc "WIZARDS? GO SEE HIM!"
.db $00 $14 $20 $93
.asc "THE DAUGHTER OF THE"
.db $17 $20 $8F
.asc "MAYOR OF LINDON"
.db $17 $20 $94
.asc "KNOWS MORE DETAILS."
.db $20 $00 $14 $20 $94
.asc "PEOPLE FROM PHARAZON"
.db $15 $20 $92
.asc "OFTEN VISIT LINDON"
.db $19 $20 $8C
.asc "VIA SHAGART."
.db $04 $20 $00
.db $14 $20 $93
.asc "PERHAPS THE TREE OF"
.db $16 $20 $92
.asc "MARILL LIES IN THE"
.db $19 $20 $8B
.asc "NAMO WOODS."
.db $05 $20 $00

; 1st entry of Pointer Table from 221B (indexed by _RAM_BUILDING_INDEX)
; Data from 1ABC7 to 1ABFE (56 bytes)
_DATA_1ABC7:
.db $E3 $AB $E5 $AB $E7 $AB $E9 $AB $EB $AB $ED $AB $EF $AB $F1 $AB
.db $F3 $AB $F5 $AB $F7 $AB $F9 $AB $FB $AB $FD $AB $01 $FF $01 $FF
.db $01 $FF $01 $FF $01 $FF $01 $FF $14 $FF $1D $FF $1D $FF $1D $FF
.db $1D $FF $1D $FF $1F $FF $1F $FF

; 3rd entry of Pointer Table from 221B (indexed by _RAM_BUILDING_INDEX)
; Data from 1ABFF to 1AC37 (57 bytes)
_DATA_1ABFF:
.db $1B $AC $1E $AC $20 $AC $22 $AC $24 $AC $26 $AC $28 $AC $2A $AC
.db $2C $AC $2E $AC $30 $AC $32 $AC $34 $AC $36 $AC $02 $2A $FF $06
.db $FF $35 $FF $08 $FF $24 $FF $24 $FF $16 $FF $19 $FF $24 $FF $24
.db $FF $24 $FF $1C $FF $28 $FF $21 $FF

; 5th entry of Pointer Table from 221B (indexed by _RAM_BUILDING_INDEX)
; Data from 1AC38 to 1AC70 (57 bytes)
_DATA_1AC38:
.db $54 $AC $56 $AC $58 $AC $5A $AC $5C $AC $5E $AC $61 $AC $63 $AC
.db $65 $AC $67 $AC $69 $AC $6B $AC $6D $AC $6F $AC $03 $FF $03 $FF
.db $03 $FF $03 $FF $29 $FF $0F $10 $FF $29 $FF $1A $FF $1A $FF $1A
.db $FF $1A $FF $1E $FF $34 $FF $23 $FF

; 7th entry of Pointer Table from 221B (indexed by _RAM_BUILDING_INDEX)
; Data from 1AC71 to 1ACA9 (57 bytes)
_DATA_1AC71:
.db $8D $AC $8F $AC $91 $AC $93 $AC $95 $AC $98 $AC $9A $AC $9C $AC
.db $9E $AC $A0 $AC $A2 $AC $A4 $AC $A6 $AC $A8 $AC $04 $FF $04 $FF
.db $04 $FF $09 $FF $0D $2E $FF $11 $FF $11 $FF $11 $FF $11 $FF $11
.db $FF $11 $FF $11 $FF $11 $FF $23 $FF

; 9th entry of Pointer Table from 221B (indexed by _RAM_BUILDING_INDEX)
; Data from 1ACAA to 1ACE7 (62 bytes)
_DATA_1ACAA:
.db $C6 $AC $C8 $AC $CA $AC $CC $AC $CE $AC $D0 $AC $D2 $AC $D4 $AC
.db $D7 $AC $DA $AC $DD $AC $E0 $AC $E3 $AC $E6 $AC $27 $FF $27 $FF
.db $07 $FF $0A $FF $0A $FF $29 $FF $15 $FF $18 $33 $FF $18 $33 $FF
.db $18 $33 $FF $18 $33 $FF $18 $33 $FF $18 $33 $FF $23 $FF

; 11th entry of Pointer Table from 221B (indexed by _RAM_BUILDING_INDEX)
; Data from 1ACE8 to 1AD1F (56 bytes)
_DATA_1ACE8:
.db $04 $AD $06 $AD $08 $AD $0A $AD $0C $AD $0E $AD $10 $AD $12 $AD
.db $14 $AD $16 $AD $18 $AD $1A $AD $1C $AD $1E $AD $01 $FF $01 $FF
.db $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF
.db $01 $FF $01 $FF $01 $FF $01 $FF

; 13th entry of Pointer Table from 221B (indexed by _RAM_BUILDING_INDEX)
; Data from 1AD20 to 1AD58 (57 bytes)
_DATA_1AD20:
.db $3C $AD $3E $AD $40 $AD $42 $AD $44 $AD $47 $AD $49 $AD $4B $AD
.db $4D $AD $4F $AD $51 $AD $53 $AD $55 $AD $57 $AD $04 $FF $04 $FF
.db $04 $FF $04 $FF $0B $2D $FF $11 $FF $11 $FF $11 $FF $11 $FF $1B
.db $FF $11 $FF $11 $FF $11 $FF $23 $FF

; 15th entry of Pointer Table from 221B (indexed by _RAM_BUILDING_INDEX)
; Data from 1AD59 to 1AD91 (57 bytes)
_DATA_1AD59:
.db $75 $AD $77 $AD $7A $AD $7C $AD $7E $AD $80 $AD $82 $AD $84 $AD
.db $86 $AD $88 $AD $8A $AD $8C $AD $8E $AD $90 $AD $31 $FF $05 $2B
.db $FF $0C $FF $17 $FF $17 $FF $17 $FF $17 $FF $17 $FF $17 $FF $17
.db $FF $17 $FF $17 $FF $17 $FF $21 $FF

; Data from 1AD92 to 1AD94 (3 bytes)
_DATA_1AD92:
.db $0E $2F $FF

; Data from 1AD95 to 1AD98 (4 bytes)
_DATA_1AD95:
.db $32 $FF $12 $FF

; Data from 1AD99 to 1AD9E (6 bytes)
_DATA_1AD99:
.db $13 $FF $20 $FF $22 $FF

; Data from 1AD9F to 1B417 (1657 bytes)
_DATA_1AD9F:
.incbin "banks\lots_DATA_1AD9F.inc"

; Data from 1B418 to 1BFFF (3048 bytes)
_DATA_1B418:
.incbin "banks\lots_DATA_1B418.inc"

.BANK 7
.ORG $0000
Bank7:

; Data from 1C000 to 1D1AB (4524 bytes)
_DATA_1C000:
.incbin "banks\lots_DATA_1C000.inc"

; Data from 1D1AC to 1DBAE (2563 bytes)
_DATA_1D1AC:
.incbin "banks\lots_DATA_1D1AC.inc"

; Data from 1DBAF to 1F13F (5521 bytes)
_DATA_1DBAF:
.incbin "banks\lots_DATA_1DBAF.inc"

.BANK 8
.ORG $0000
Bank8:

; Data from 20000 to 204F3 (1268 bytes)
.incbin "banks\lots_DATA_20000.inc"

; Data from 204F4 to 21177 (3204 bytes)
_DATA_204F4:
.incbin "banks\lots_DATA_204F4.inc"

; Data from 21178 to 21267 (240 bytes)
_DATA_21178:
.db $07 $00 $02 $18 $0D $00 $84 $18 $3C $3C $18 $0A $00 $88 $01 $07
.db $06 $0C $0C $06 $07 $01 $08 $00 $88 $80 $E0 $60 $30 $30 $60 $E0
.db $80 $04 $00 $00 $05 $00 $86 $18 $24 $5A $5A $24 $18 $09 $00 $88
.db $18 $66 $5A $BD $BD $5A $66 $18 $06 $00 $83 $01 $06 $09 $02 $17
.db $02 $2F $02 $17 $83 $09 $06 $01 $04 $00 $83 $80 $60 $90 $02 $E8
.db $02 $F4 $02 $E8 $83 $90 $60 $80 $02 $00 $00 $06 $00 $84 $18 $24
.db $24 $18 $0B $00 $86 $18 $24 $42 $42 $24 $18 $08 $00 $8A $01 $06
.db $08 $09 $13 $13 $09 $08 $06 $01 $06 $00 $8A $80 $60 $10 $90 $C8
.db $C8 $90 $10 $60 $80 $03 $00 $00 $05 $00 $86 $18 $24 $5A $5A $24
.db $18 $09 $00 $88 $18 $66 $42 $99 $99 $42 $66 $18 $06 $00 $8C $01
.db $06 $08 $11 $13 $27 $27 $13 $11 $08 $06 $01 $04 $00 $8C $80 $60
.db $10 $88 $C8 $E4 $E4 $C8 $88 $10 $60 $80 $02 $00 $00 $04 $00 $88
.db $18 $66 $5A $AD $B5 $5A $66 $18 $04 $00 $00 $07 $00 $82 $18 $08
.db $07 $00 $00 $04 $00 $88 $18 $66 $5A $BD $AD $5A $66 $18 $04 $00
.db $00 $04 $00 $81 $18 $02 $7E $02 $FF $02 $7E $81 $18 $04 $00 $00

; Data from 21268 to 23FFF (11672 bytes)
_DATA_21268:
.incbin "banks\lots_DATA_21268.inc"

.BANK 9
.ORG $0000
Bank9:

; Data from 24000 to 24716 (1815 bytes)
.incbin "banks\lots_DATA_24000.inc"

; Data from 24717 to 25327 (3089 bytes)
_DATA_24717:
.incbin "banks\lots_DATA_24717.inc"

; Data from 25328 to 25AF2 (1995 bytes)
_DATA_25328:
.incbin "banks\lots_DATA_25328.inc"

; Data from 25AF3 to 2624C (1882 bytes)
_DATA_25AF3:
.incbin "banks\lots_DATA_25AF3.inc"

; Data from 2624D to 26E3D (3057 bytes)
_DATA_2624D:
.incbin "banks\lots_DATA_2624D.inc"

; Data from 26E3E to 27FFF (4546 bytes)
_DATA_26E3E:
.incbin "banks\lots_DATA_26E3E.inc"

.BANK 10
.ORG $0000
Bank10:

; 95th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28000 to 28005 (6 bytes)
_DATA_28000:
.db $01 $00 $00 $00 $00 $00

; Pointer Table from 28006 to 28007 (1 entries, indexed by unknown)
.dw _DATA_290B6

; 2nd entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28008 to 2800D (6 bytes)
_DATA_28008:
.db $10 $1F $80 $F0 $00 $00

; Pointer Table from 2800E to 2800F (1 entries, indexed by unknown)
.dw _DATA_2981A

; Data from 28010 to 2801E (15 bytes)
.db $60 $01 $00 $12 $30 $E0 $00 $00 $12 $50 $B8 $01 $00 $12 $68

; 1st entry of Pointer Table from 281A6 (indexed by unknown)
; Data from 2801F to 2805A (60 bytes)
_DATA_2801F:
.db $D0 $01 $00 $16 $A0 $50 $02 $00 $12 $40 $B0 $02 $00 $1A $A0 $C0
.db $02 $00 $1F $80 $38 $03 $00 $12 $58 $F0 $03 $00 $12 $58 $08 $04
.db $00 $17 $98 $E8 $03 $00 $1F $60 $A0 $04 $00 $16 $68 $98 $04 $00
.db $12 $48 $70 $05 $00 $1A $A8 $F0 $05 $00 $D1 $91

; 6th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2805B to 28060 (6 bytes)
_DATA_2805B:
.db $10 $12 $30 $50 $00 $00

; Pointer Table from 28061 to 28062 (1 entries, indexed by unknown)
.dw $9014

; Data from 28063 to 280AD (75 bytes)
.db $10 $01 $00 $14 $90 $D8 $00 $00 $21 $68 $50 $01 $00 $1F $60 $D0
.db $01 $00 $12 $38 $60 $02 $00 $12 $40 $A0 $02 $01 $1F $80 $20 $03
.db $00 $17 $B0 $58 $03 $00 $12 $30 $A0 $03 $00 $1F $70 $30 $04 $00
.db $1F $70 $48 $04 $00 $21 $68 $D0 $04 $01 $12 $38 $48 $05 $00 $17
.db $98 $80 $05 $00 $1F $70 $D0 $05 $00 $06 $91

; 8th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 280AE to 280B3 (6 bytes)
_DATA_280AE:
.db $0D $1D $40 $A0 $00 $00

; Pointer Table from 280B4 to 280B7 (2 entries, indexed by unknown)
.dw _DATA_29821 $0118

; Data from 280B8 to 280F1 (58 bytes)
.db $00 $14 $C0 $50 $01 $00 $14 $C0 $88 $01 $00 $14 $C0 $C0 $01 $00
.db $1D $60 $60 $02 $01 $21 $A8 $B0 $02 $00 $1D $48 $38 $03 $00 $1D
.db $48 $68 $04 $01 $14 $C0 $90 $04 $00 $14 $C0 $B0 $04 $00 $1D $48
.db $B0 $05 $01 $21 $A8 $78 $05 $00 $E4 $90

; 10th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 280F2 to 280F7 (6 bytes)
_DATA_280F2:
.db $0C $1D $48 $60 $00 $00

; Pointer Table from 280F8 to 280F9 (1 entries, indexed by unknown)
.dw _DATA_2A81A

; Data from 280FA to 28130 (55 bytes)
.db $00 $01 $00 $1D $48 $48 $01 $00 $1D $60 $80 $01 $01 $21 $A8 $F0
.db $01 $01 $1A $A8 $40 $02 $00 $1F $80 $20 $02 $00 $1D $40 $A8 $02
.db $00 $1A $A8 $B0 $02 $00 $21 $A8 $D0 $02 $00 $1A $A8 $F0 $03 $00
.db $1D $48 $78 $03 $01 $C2 $90

; 14th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28131 to 2816A (58 bytes)
_DATA_28131:
.db $0B $1F $80 $F0 $00 $00 $1D $48 $E0 $00 $00 $16 $A0 $50 $01 $00
.db $1D $48 $80 $01 $00 $1F $80 $10 $02 $00 $14 $C0 $40 $02 $00 $14
.db $C0 $50 $02 $00 $16 $A8 $90 $02 $00 $1D $48 $C0 $02 $00 $1D $48
.db $20 $03 $00 $1D $48 $60 $03 $01 $82 $91

; 18th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2816B to 28170 (6 bytes)
_DATA_2816B:
.db $0A $1D $48 $60 $00 $00

; Pointer Table from 28171 to 28172 (1 entries, indexed by unknown)
.dw $781F

; Data from 28173 to 2819F (45 bytes)
.db $F0 $00 $00 $16 $98 $E0 $00 $00 $1A $98 $20 $01 $00 $1D $48 $80
.db $01 $00 $16 $A8 $B8 $01 $00 $1F $80 $18 $02 $00 $1F $80 $58 $02
.db $00 $16 $A0 $40 $02 $00 $1A $A0 $E8 $02 $00 $60 $91

; 20th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 281A0 to 281A5 (6 bytes)
_DATA_281A0:
.db $0A $16 $88 $20 $00 $00

; Pointer Table from 281A6 to 281A7 (1 entries, indexed by unknown)
.dw _DATA_2801F

; Data from 281A8 to 281D4 (45 bytes)
.db $F0 $00 $00 $1A $90 $28 $01 $00 $1D $48 $20 $01 $01 $1A $98 $B8
.db $01 $00 $1D $48 $C0 $01 $01 $1F $80 $C0 $01 $00 $1A $A0 $58 $02
.db $00 $1D $48 $C0 $02 $01 $16 $A8 $D0 $02 $00 $60 $91

; 22nd entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 281D5 to 28204 (48 bytes)
_DATA_281D5:
.db $09 $1D $60 $10 $00 $00 $1D $60 $E0 $00 $00 $21 $80 $D0 $00 $01
.db $1F $70 $30 $01 $00 $14 $90 $40 $01 $00 $1D $28 $D0 $01 $00 $1D
.db $28 $30 $02 $00 $21 $78 $98 $02 $00 $1D $40 $D0 $02 $01 $E4 $90

; 26th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28205 to 2820A (6 bytes)
_DATA_28205:
.db $10 $1F $78 $20 $00 $00

; Pointer Table from 2820B to 2820C (1 entries, indexed by unknown)
.dw _DATA_2A817

; Data from 2820D to 28257 (75 bytes)
.db $F0 $00 $00 $12 $40 $20 $01 $00 $21 $A8 $20 $01 $01 $14 $C0 $40
.db $01 $00 $1F $78 $D0 $01 $00 $14 $C0 $F0 $01 $00 $12 $20 $A8 $02
.db $00 $12 $38 $80 $02 $00 $12 $50 $68 $02 $00 $14 $C0 $78 $02 $00
.db $12 $30 $A0 $02 $00 $17 $98 $20 $03 $00 $14 $C0 $48 $03 $00 $12
.db $30 $A0 $03 $00 $21 $A8 $80 $03 $00 $06 $91

; 30th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28258 to 2829B (68 bytes)
_DATA_28258:
.db $0D $17 $90 $C8 $00 $00 $12 $48 $88 $00 $00 $1F $78 $F0 $01 $00
.db $1F $90 $10 $02 $00 $1F $58 $10 $02 $00 $17 $98 $80 $01 $00 $16
.db $98 $B0 $01 $00 $12 $50 $D0 $01 $00 $12 $40 $60 $02 $00 $16 $A0
.db $C0 $02 $00 $12 $48 $10 $03 $00 $14 $C0 $50 $03 $00 $17 $A0 $F0
.db $03 $00 $A4 $91

; 34th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2829C to 282A1 (6 bytes)
_DATA_2829C:
.db $0D $1F $78 $E0 $00 $00

; Pointer Table from 282A2 to 282A3 (1 entries, indexed by unknown)
.dw _DATA_2A017

; Data from 282A4 to 282DF (60 bytes)
.db $F0 $00 $00 $21 $A0 $C0 $00 $00 $12 $28 $18 $01 $00 $1A $88 $F8
.db $01 $00 $21 $90 $A0 $01 $00 $1F $78 $F0 $01 $00 $17 $70 $F0 $02
.db $00 $12 $40 $A0 $02 $00 $1F $60 $10 $03 $00 $21 $70 $48 $03 $00
.db $1A $88 $F0 $03 $00 $12 $38 $D0 $03 $00 $33 $91

; 65th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 282E0 to 282E5 (6 bytes)
_DATA_282E0:
.db $0B $1F $90 $F0 $00 $00

; Pointer Table from 282E6 to 282E7 (1 entries, indexed by unknown)
.dw _DATA_2B028

; Data from 282E8 to 28319 (50 bytes)
.db $D0 $00 $00 $1F $90 $20 $01 $00 $10 $30 $48 $01 $00 $10 $30 $90
.db $01 $00 $28 $B0 $F0 $01 $00 $26 $B0 $10 $02 $00 $28 $B0 $10 $03
.db $00 $10 $30 $B0 $03 $00 $10 $30 $00 $05 $00 $26 $B0 $F0 $04 $00
.db $20 $92

; 67th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2831A to 2834E (53 bytes)
_DATA_2831A:
.db $0A $26 $A8 $F0 $00 $00 $10 $30 $10 $01 $00 $28 $A0 $20 $01 $00
.db $26 $A8 $F0 $01 $00 $10 $30 $A0 $02 $00 $1F $70 $D0 $02 $00 $10
.db $30 $D0 $03 $00 $26 $A8 $C0 $04 $00 $10 $30 $70 $05 $00 $1A $B0
.db $A0 $05 $00 $20 $92

; 91st entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2834F to 28354 (6 bytes)
_DATA_2834F:
.db $0A $25 $B0 $18 $00 $00

; Pointer Table from 28355 to 28356 (1 entries, indexed by unknown)
.dw _DATA_2801F

; Data from 28357 to 28383 (45 bytes)
.db $F0 $00 $00 $1D $48 $10 $01 $00 $25 $B0 $80 $01 $00 $1D $48 $F0
.db $01 $00 $1F $A0 $50 $02 $00 $1D $48 $D0 $02 $00 $25 $B0 $F0 $02
.db $00 $25 $B0 $28 $03 $00 $1D $48 $D0 $03 $01 $3D $94

; 36th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28384 to 28389 (6 bytes)
_DATA_28384:
.db $10 $24 $90 $B0 $00 $00

; Pointer Table from 2838A to 2838B (1 entries, indexed by unknown)
.dw $781F

; Data from 2838C to 283D6 (75 bytes)
.db $50 $01 $00 $20 $70 $50 $01 $00 $20 $60 $A0 $01 $00 $1F $78 $E0
.db $01 $00 $1B $90 $60 $02 $00 $11 $90 $60 $02 $00 $1F $78 $80 $02
.db $00 $20 $80 $10 $03 $00 $24 $A0 $80 $03 $00 $1F $78 $D0 $03 $00
.db $20 $78 $28 $04 $00 $1F $78 $80 $04 $00 $1F $78 $20 $05 $00 $1B
.db $78 $30 $05 $00 $11 $78 $30 $05 $00 $FE $91

; 38th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 283D7 to 28429 (83 bytes)
_DATA_283D7:
.db $10 $1F $80 $F0 $00 $00 $12 $40 $C0 $00 $00 $1B $68 $30 $01 $00
.db $11 $68 $30 $01 $00 $1E $B0 $30 $01 $00 $20 $60 $A0 $01 $00 $1C
.db $B0 $F0 $01 $00 $12 $50 $C0 $02 $00 $1C $70 $60 $03 $00 $1B $80
.db $F0 $03 $00 $11 $80 $F0 $03 $00 $20 $80 $40 $04 $00 $1E $A0 $C0
.db $04 $00 $20 $80 $40 $05 $00 $12 $40 $A0 $05 $00 $1E $A0 $B0 $05
.db $00 $AB $93

; 44th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2842A to 28468 (63 bytes)
_DATA_2842A:
.db $0C $1F $70 $D0 $00 $00 $20 $70 $50 $00 $00 $1C $A0 $F0 $00 $00
.db $1B $88 $20 $01 $00 $11 $88 $20 $01 $00 $1F $80 $60 $01 $00 $1C
.db $80 $88 $01 $00 $20 $60 $D8 $01 $00 $1C $A0 $20 $02 $00 $1E $80
.db $60 $02 $00 $1B $50 $80 $02 $00 $11 $50 $80 $02 $00 $24 $93

; 48th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28469 to 2846E (6 bytes)
_DATA_28469:
.db $0D $24 $A0 $C0 $00 $00

; Pointer Table from 2846F to 28470 (1 entries, indexed by unknown)
.dw _DATA_2801F

; Data from 28471 to 284AC (60 bytes)
.db $80 $00 $00 $15 $A0 $C0 $00 $00 $1B $60 $08 $01 $00 $11 $60 $08
.db $01 $00 $20 $68 $28 $01 $00 $1F $70 $C0 $01 $00 $24 $A0 $F8 $01
.db $00 $1F $70 $08 $02 $00 $1B $60 $50 $02 $00 $11 $60 $50 $02 $00
.db $20 $38 $B0 $02 $00 $15 $90 $90 $02 $00 $7E $93

; 50th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 284AD to 284FF (83 bytes)
_DATA_284AD:
.db $10 $1F $78 $D0 $00 $00 $12 $40 $18 $01 $00 $20 $80 $18 $01 $00
.db $20 $68 $80 $01 $00 $1F $78 $F0 $01 $00 $24 $A0 $F8 $01 $00 $20
.db $40 $50 $02 $00 $12 $28 $D0 $02 $00 $1B $58 $28 $03 $00 $11 $58
.db $28 $03 $00 $24 $A0 $70 $03 $00 $12 $48 $C0 $03 $00 $20 $60 $68
.db $04 $00 $24 $A0 $C0 $05 $00 $12 $48 $D0 $05 $00 $20 $38 $20 $05
.db $00 $51 $93

; 56th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28500 to 28552 (83 bytes)
_DATA_28500:
.db $10 $1B $48 $A8 $00 $00 $11 $48 $A8 $00 $00 $1C $B0 $D8 $00 $00
.db $1F $80 $18 $01 $00 $15 $B0 $80 $01 $00 $1E $60 $D0 $01 $00 $1C
.db $B0 $30 $02 $00 $1F $88 $80 $02 $00 $15 $90 $D8 $02 $00 $1F $70
.db $40 $03 $00 $20 $40 $A0 $03 $00 $20 $40 $38 $04 $00 $1E $A0 $88
.db $04 $00 $1F $70 $C0 $04 $00 $1C $A0 $18 $05 $00 $1F $78 $60 $05
.db $00 $E3 $93

; 59th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28553 to 28558 (6 bytes)
_DATA_28553:
.db $08 $1F $70 $D0 $00 $00

; Pointer Table from 28559 to 2855A (1 entries, indexed by unknown)
.dw _DATA_2B025

; Data from 2855B to 2857D (35 bytes)
.db $D0 $00 $00 $13 $28 $20 $01 $00 $15 $88 $48 $01 $00 $1F $70 $80
.db $01 $00 $1F $78 $28 $02 $00 $25 $B0 $80 $02 $00 $15 $98 $80 $02
.db $00 $81 $94

; 61st entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2857E to 285A3 (38 bytes)
_DATA_2857E:
.db $07 $25 $B0 $80 $00 $00 $1F $70 $C0 $00 $00 $1D $38 $00 $01 $00
.db $15 $88 $A8 $01 $00 $1F $70 $30 $02 $00 $25 $B0 $68 $02 $00 $15
.db $90 $E8 $02 $00 $5F $94

; 69th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 285A4 to 285A9 (6 bytes)
_DATA_285A4:
.db $0E $1F $50 $D0 $00 $00

; Pointer Table from 285AA to 285AB (1 entries, indexed by unknown)
.dw _DATA_2A015

; Data from 285AC to 285EC (65 bytes)
.db $B0 $00 $00 $19 $70 $20 $01 $00 $1F $30 $60 $01 $00 $15 $B0 $80
.db $01 $00 $19 $80 $70 $02 $00 $1F $60 $D0 $02 $00 $1F $70 $38 $03
.db $00 $18 $88 $A0 $03 $00 $15 $80 $D0 $03 $00 $18 $68 $40 $04 $00
.db $1F $30 $90 $04 $00 $19 $60 $30 $05 $00 $1F $70 $D0 $05 $00 $02
.db $93

; 77th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 285ED to 285F2 (6 bytes)
_DATA_285ED:
.db $10 $1F $80 $20 $00 $00

; Pointer Table from 285F3 to 285F4 (1 entries, indexed by unknown)
.dw _DATA_29815

; Data from 285F5 to 2863F (75 bytes)
.db $98 $00 $00 $23 $90 $20 $01 $00 $15 $A8 $B8 $01 $00 $1F $88 $E0
.db $01 $00 $23 $60 $E0 $02 $00 $15 $70 $70 $02 $00 $20 $20 $D0 $02
.db $00 $1F $40 $10 $03 $00 $23 $80 $70 $03 $00 $20 $28 $B0 $03 $00
.db $23 $70 $30 $04 $00 $20 $60 $60 $04 $00 $23 $70 $00 $05 $00 $1F
.db $70 $F8 $04 $00 $15 $48 $A0 $05 $00 $7A $92

; 80th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28640 to 2866A (43 bytes)
_DATA_28640:
.db $08 $1F $70 $F0 $00 $00 $12 $38 $F0 $00 $00 $20 $40 $08 $01 $00
.db $1F $30 $90 $01 $00 $23 $70 $D0 $01 $00 $20 $70 $10 $02 $00 $23
.db $A0 $A8 $02 $00 $12 $30 $B0 $02 $00 $4D $92

; 83rd entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2866B to 28670 (6 bytes)
_DATA_2866B:
.db $08 $1F $68 $F0 $00 $00

; Pointer Table from 28671 to 28672 (1 entries, indexed by unknown)
.dw _DATA_28823

; Data from 28673 to 28695 (35 bytes)
.db $F0 $00 $00 $12 $70 $B0 $00 $00 $23 $78 $68 $01 $00 $20 $38 $80
.db $01 $00 $12 $60 $D8 $01 $00 $23 $C0 $50 $02 $00 $20 $80 $40 $02
.db $00 $4D $92

; 85th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28696 to 2869B (6 bytes)
_DATA_28696:
.db $0C $12 $40 $10 $00 $00

; Pointer Table from 2869C to 2869D (1 entries, indexed by unknown)
.dw $9023

; Data from 2869E to 286D4 (55 bytes)
.db $90 $01 $00 $1F $78 $F8 $00 $00 $12 $30 $10 $01 $00 $23 $B0 $38
.db $01 $00 $20 $68 $48 $01 $00 $23 $90 $90 $01 $00 $1F $68 $F0 $01
.db $00 $20 $48 $08 $02 $00 $20 $30 $58 $02 $00 $23 $60 $60 $02 $00
.db $1F $40 $F0 $02 $00 $4D $92

; 89th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 286D5 to 286DA (6 bytes)
_DATA_286D5:
.db $0B $1F $40 $10 $00 $00

; Pointer Table from 286DB to 286DC (1 entries, indexed by unknown)
.dw $7815

; Data from 286DD to 28716 (58 bytes)
.db $C0 $00 $00 $13 $40 $F0 $00 $00 $13 $40 $10 $01 $00 $18 $90 $88
.db $01 $00 $13 $58 $F8 $01 $00 $15 $98 $F0 $01 $00 $13 $48 $60 $02
.db $00 $18 $A8 $68 $02 $00 $1F $70 $F0 $02 $00 $1F $90 $E0 $02 $00
.db $BE $92 $01 $2E $70 $30 $00 $00 $A3 $94

; 3rd entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28717 to 2871C (6 bytes)
_DATA_28717:
.db $10 $1F $70 $F0 $FB $00

; Pointer Table from 2871D to 28720 (2 entries, indexed by unknown)
.dw _DATA_2A81A $FB40

; Data from 28721 to 28769 (73 bytes)
.db $00 $12 $30 $E0 $FB $00 $12 $50 $B8 $FC $00 $12 $50 $90 $FC $00
.db $16 $A0 $30 $FD $00 $12 $40 $B0 $FD $00 $1A $A0 $C0 $FD $00 $1F
.db $78 $38 $FE $00 $12 $58 $F0 $FE $00 $12 $38 $F8 $FE $00 $17 $98
.db $E8 $FE $00 $1F $60 $70 $FF $00 $16 $68 $98 $FF $00 $12 $48 $10
.db $00 $00 $1A $A8 $98 $00 $00 $D1 $91

; 7th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2876A to 2876F (6 bytes)
_DATA_2876A:
.db $10 $12 $30 $50 $FB $00

; Pointer Table from 28770 to 28773 (2 entries, indexed by unknown)
.dw $9014 $FC10

; Data from 28774 to 287BC (73 bytes)
.db $00 $14 $90 $08 $FC $00 $21 $68 $50 $FC $00 $1F $48 $F0 $FC $00
.db $12 $38 $60 $FD $00 $12 $40 $A0 $FD $01 $1F $78 $20 $FE $00 $17
.db $B0 $58 $FE $00 $12 $30 $A0 $FE $00 $1F $70 $10 $FF $00 $1F $70
.db $20 $FF $00 $21 $68 $D0 $FF $01 $12 $38 $48 $00 $00 $17 $98 $80
.db $00 $00 $1F $70 $10 $00 $00 $06 $91

; 9th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 287BD to 287C2 (6 bytes)
_DATA_287BD:
.db $0D $1D $40 $90 $FB $00

; Pointer Table from 287C3 to 287C6 (2 entries, indexed by unknown)
.dw _DATA_29821 $FC18

; Data from 287C7 to 28800 (58 bytes)
.db $00 $14 $C0 $50 $FC $00 $14 $C0 $88 $FC $00 $14 $C0 $C0 $FC $00
.db $1D $60 $E8 $FC $01 $21 $A8 $90 $FD $00 $1D $48 $38 $FE $00 $1D
.db $48 $68 $FF $00 $14 $C0 $90 $FF $00 $14 $C0 $B0 $FF $00 $1D $48
.db $B0 $00 $01 $21 $A8 $E0 $FF $00 $E4 $90

; 11th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28801 to 28806 (6 bytes)
_DATA_28801:
.db $0C $1D $48 $70 $FD $00

; Pointer Table from 28807 to 2880A (2 entries, indexed by unknown)
.dw _DATA_2A81A $FD00

; Data from 2880B to 28822 (24 bytes)
.db $00 $1D $48 $48 $FE $00 $1D $60 $80 $FE $01 $21 $A8 $F0 $FE $01
.db $1A $A8 $40 $FF $00 $1F $80 $20

; 1st entry of Pointer Table from 28671 (indexed by unknown)
; Data from 28823 to 2883F (29 bytes)
_DATA_28823:
.db $FF $00 $1D $40 $A8 $FF $00 $1A $A0 $D0 $FF $00 $21 $A0 $E0 $FF
.db $00 $1A $A8 $70 $00 $00 $1D $48 $78 $00 $00 $C2 $90

; 15th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28840 to 28879 (58 bytes)
_DATA_28840:
.db $0B $1F $80 $30 $FD $00 $1D $48 $E0 $FD $00 $16 $A0 $10 $FE $00
.db $1D $48 $80 $FE $00 $1F $80 $10 $FF $00 $14 $C0 $40 $FF $00 $14
.db $C0 $50 $FF $00 $16 $A8 $90 $FF $00 $1D $48 $C0 $FF $00 $1D $48
.db $20 $00 $00 $1D $48 $60 $00 $01 $82 $91

; 19th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2887A to 2887F (6 bytes)
_DATA_2887A:
.db $09 $1D $48 $60 $FE $00

; Pointer Table from 28880 to 28883 (2 entries, indexed by unknown)
.dw $781F $FEF0

; Data from 28884 to 288A9 (38 bytes)
.db $00 $16 $98 $E0 $FE $00 $1A $98 $E0 $FE $00 $1D $48 $80 $FF $00
.db $16 $A8 $E0 $FF $00 $1F $78 $D0 $FF $00 $1F $78 $10 $00 $00 $1A
.db $A0 $88 $00 $00 $60 $91

; 21st entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 288AA to 288E3 (58 bytes)
_DATA_288AA:
.db $0B $1F $70 $58 $FE $00 $1F $70 $80 $FE $00 $16 $90 $C0 $FE $00
.db $1D $48 $20 $FF $01 $1F $70 $80 $FF $00 $1F $50 $80 $FF $00 $1F
.db $90 $80 $FF $00 $16 $A0 $F0 $FF $00 $1D $60 $30 $00 $00 $1D $48
.db $80 $00 $01 $16 $A0 $10 $00 $00 $60 $91

; 23rd entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 288E4 to 28913 (48 bytes)
_DATA_288E4:
.db $09 $21 $A8 $80 $FE $01 $1D $48 $E0 $FE $00 $1F $70 $30 $FF $00
.db $14 $90 $40 $FF $00 $21 $68 $70 $FF $00 $1D $20 $D0 $FF $00 $1D
.db $20 $30 $00 $01 $21 $78 $78 $00 $00 $1D $38 $D0 $00 $01 $E4 $90

; 27th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28914 to 28919 (6 bytes)
_DATA_28914:
.db $0E $1F $80 $20 $FD $00

; Pointer Table from 2891A to 2891D (2 entries, indexed by unknown)
.dw _DATA_2A817 $FDF0

; Data from 2891E to 2895C (63 bytes)
.db $00 $12 $40 $20 $FD $00 $21 $A8 $20 $FE $01 $14 $C0 $40 $FE $00
.db $1F $70 $D0 $FE $00 $14 $C0 $F0 $FE $00 $12 $20 $98 $FF $00 $14
.db $C0 $78 $FF $00 $12 $30 $80 $FF $00 $17 $A8 $78 $00 $00 $14 $C0
.db $48 $00 $00 $12 $30 $10 $00 $00 $21 $98 $10 $00 $00 $06 $91

; 31st entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2895D to 2899B (63 bytes)
_DATA_2895D:
.db $0C $17 $90 $C8 $FD $00 $12 $48 $88 $FD $00 $1F $70 $40 $FE $00
.db $1F $60 $60 $FE $00 $1F $60 $40 $FE $00 $17 $98 $30 $FE $00 $16
.db $98 $B0 $FE $00 $12 $50 $D0 $FE $00 $12 $40 $60 $FF $00 $16 $A0
.db $C0 $FF $00 $12 $48 $10 $00 $00 $14 $C0 $50 $00 $00 $A4 $91

; 35th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 2899C to 289A1 (6 bytes)
_DATA_2899C:
.db $0D $1F $70 $40 $FD $00

; Pointer Table from 289A2 to 289A5 (2 entries, indexed by unknown)
.dw _DATA_2A017 $FDF0

; Data from 289A6 to 289DF (58 bytes)
.db $00 $21 $A0 $C0 $FD $00 $12 $28 $18 $FE $00 $1A $A0 $80 $FD $00
.db $21 $90 $B0 $FE $00 $1F $60 $F0 $FE $00 $17 $70 $F0 $FF $00 $12
.db $40 $A0 $FF $00 $1F $58 $10 $00 $00 $21 $68 $10 $00 $00 $1A $70
.db $10 $00 $00 $12 $38 $D0 $00 $00 $33 $91

; 66th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 289E0 to 289E5 (6 bytes)
_DATA_289E0:
.db $0B $1F $88 $50 $FB $00

; Pointer Table from 289E6 to 289E9 (2 entries, indexed by unknown)
.dw _DATA_2B028 $FBD0

; Data from 289EA to 28A19 (48 bytes)
.db $00 $1F $88 $20 $FC $00 $10 $30 $50 $FC $00 $10 $30 $90 $FC $00
.db $28 $B0 $F0 $FC $00 $26 $B8 $10 $FD $00 $28 $B0 $20 $FE $00 $10
.db $30 $90 $FE $00 $10 $30 $C0 $FF $00 $26 $B8 $F0 $FF $00 $20 $92

; 68th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28A1A to 28A4E (53 bytes)
_DATA_28A1A:
.db $0A $26 $A8 $F0 $FB $00 $10 $30 $20 $FC $00 $28 $A0 $20 $FC $00
.db $10 $30 $B0 $FD $00 $1F $78 $D0 $FD $00 $10 $30 $D0 $FE $00 $26
.db $A8 $D0 $FE $00 $26 $A8 $C0 $FF $00 $10 $30 $70 $00 $00 $28 $A0
.db $A0 $00 $00 $20 $92

; 92nd entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28A4F to 28A54 (6 bytes)
_DATA_28A4F:
.db $0A $25 $B0 $18 $FD $00

; Pointer Table from 28A55 to 28A58 (2 entries, indexed by unknown)
.dw $901F $FDF0

; Data from 28A59 to 28A83 (43 bytes)
.db $00 $1D $48 $10 $FE $00 $25 $B0 $80 $FE $00 $1D $48 $F0 $FE $00
.db $1F $90 $50 $FF $00 $1D $48 $D0 $FF $00 $25 $B0 $F0 $FF $00 $25
.db $B0 $28 $00 $00 $1D $48 $D0 $00 $01 $3D $94

; 37th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28A84 to 28A89 (6 bytes)
_DATA_28A84:
.db $10 $24 $90 $B0 $FB $00

; Pointer Table from 28A8A to 28A8D (2 entries, indexed by unknown)
.dw $781F $FC50

; Data from 28A8E to 28AD6 (73 bytes)
.db $00 $20 $70 $70 $FC $00 $20 $60 $A0 $FC $00 $1F $78 $E0 $FC $00
.db $1B $90 $60 $FD $00 $11 $90 $60 $FD $00 $1F $80 $80 $FD $00 $20
.db $80 $10 $FE $00 $24 $A0 $80 $FE $00 $1F $78 $D0 $FE $00 $20 $78
.db $28 $FF $00 $1F $78 $80 $FF $00 $1F $98 $20 $00 $00 $1B $78 $08
.db $00 $00 $11 $78 $08 $00 $00 $FE $91

; 39th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28AD7 to 28B1F (73 bytes)
_DATA_28AD7:
.db $0E $1F $80 $50 $FB $00 $12 $40 $C0 $FB $00 $1B $68 $30 $FC $00
.db $11 $68 $30 $FC $00 $20 $60 $A0 $FC $00 $1C $B0 $F0 $FC $00 $12
.db $50 $C0 $FD $00 $1C $70 $60 $FE $00 $1B $80 $F0 $FE $00 $11 $80
.db $F0 $FE $00 $20 $80 $40 $FF $00 $20 $80 $40 $00 $00 $12 $40 $A0
.db $00 $00 $1E $A0 $90 $00 $00 $AB $93

; 45th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28B20 to 28B59 (58 bytes)
_DATA_28B20:
.db $0B $1F $90 $30 $FE $00 $20 $70 $50 $FE $00 $1C $A0 $F0 $FE $00
.db $1B $70 $20 $FF $00 $11 $70 $20 $FF $00 $1F $70 $60 $FF $00 $1C
.db $90 $88 $FF $00 $20 $60 $D8 $FF $00 $1C $90 $20 $00 $00 $1B $50
.db $80 $00 $00 $11 $50 $80 $00 $00 $24 $93

; 49th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28B5A to 28B9D (68 bytes)
_DATA_28B5A:
.db $0D $24 $A0 $48 $FE $00 $1F $70 $80 $FE $00 $15 $A0 $C0 $FE $00
.db $1B $48 $08 $FF $00 $11 $48 $08 $FF $00 $20 $68 $28 $FF $00 $1F
.db $70 $C0 $FF $00 $24 $A0 $F8 $FF $00 $1F $70 $08 $00 $00 $1B $50
.db $10 $00 $00 $11 $50 $10 $00 $00 $20 $38 $B0 $00 $00 $15 $90 $A8
.db $00 $00 $7E $93

; 51st entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28B9E to 28BF0 (83 bytes)
_DATA_28B9E:
.db $10 $1F $78 $40 $FB $00 $12 $40 $18 $FC $00 $20 $80 $18 $FC $00
.db $20 $68 $80 $FC $00 $1F $60 $F0 $FC $00 $24 $A0 $F8 $FC $00 $20
.db $40 $50 $FD $00 $12 $28 $D0 $FD $00 $1B $60 $28 $FE $00 $11 $60
.db $28 $FE $00 $24 $A0 $70 $FE $00 $12 $48 $C0 $FE $00 $20 $60 $68
.db $FF $00 $24 $A0 $10 $00 $00 $12 $48 $D0 $00 $00 $20 $38 $20 $00
.db $00 $51 $93

; 57th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28BF1 to 28C39 (73 bytes)
_DATA_28BF1:
.db $0E $1B $58 $A8 $FB $00 $11 $58 $A8 $FB $00 $1C $B0 $D8 $FB $00
.db $1F $80 $18 $FC $00 $15 $B0 $80 $FC $00 $1C $B0 $30 $FD $00 $1F
.db $70 $80 $FD $00 $15 $90 $D8 $FD $00 $1F $70 $40 $FE $00 $20 $40
.db $A0 $FE $00 $20 $40 $38 $FF $00 $1F $70 $C0 $FF $00 $1C $A0 $18
.db $00 $00 $1F $70 $60 $00 $00 $E3 $93

; 60th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28C3A to 28C3F (6 bytes)
_DATA_28C3A:
.db $08 $1F $70 $60 $FE $00

; Pointer Table from 28C40 to 28C43 (2 entries, indexed by unknown)
.dw _DATA_2B025 $FED0

; Data from 28C44 to 28C64 (33 bytes)
.db $00 $13 $28 $20 $FF $00 $15 $88 $48 $FF $00 $1F $70 $80 $FF $00
.db $15 $98 $10 $00 $00 $1F $70 $28 $00 $00 $25 $B0 $80 $00 $00 $81
.db $94

; 62nd entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28C65 to 28C8A (38 bytes)
_DATA_28C65:
.db $07 $25 $B0 $80 $FE $00 $1F $70 $C0 $FE $00 $25 $B0 $70 $FF $00
.db $1D $48 $98 $FF $00 $15 $88 $A8 $FF $00 $15 $90 $30 $00 $00 $1D
.db $48 $D8 $00 $01 $5F $94

; 70th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28C8B to 28C90 (6 bytes)
_DATA_28C8B:
.db $0E $1F $70 $40 $FB $00

; Pointer Table from 28C91 to 28C96 (3 entries, indexed by unknown)
.dw _DATA_2A015 $FBB0 _DATA_1900

; Data from 28C97 to 28CD3 (61 bytes)
.db $70 $20 $FC $00 $1F $70 $60 $FC $00 $15 $B0 $80 $FC $00 $18 $88
.db $00 $FD $00 $19 $80 $70 $FD $00 $1F $60 $D0 $FD $00 $1F $40 $38
.db $FE $00 $15 $78 $D0 $FE $00 $18 $68 $40 $FF $00 $1F $30 $90 $FF
.db $00 $19 $60 $30 $00 $00 $1F $70 $10 $00 $00 $02 $93

; 78th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28CD4 to 28CD9 (6 bytes)
_DATA_28CD4:
.db $10 $1F $48 $20 $FB $00

; Pointer Table from 28CDA to 28CDD (2 entries, indexed by unknown)
.dw _DATA_29815 $FB98

; Data from 28CDE to 28D26 (73 bytes)
.db $00 $23 $50 $10 $FC $00 $15 $A8 $B8 $FC $00 $1F $70 $E0 $FC $00
.db $23 $10 $30 $FD $00 $15 $70 $70 $FD $00 $20 $20 $D0 $FD $00 $1F
.db $20 $10 $FE $00 $23 $10 $30 $FE $00 $20 $28 $B0 $FE $00 $23 $50
.db $20 $FF $00 $20 $60 $60 $FF $00 $23 $48 $F0 $FF $00 $1F $70 $F8
.db $FF $00 $15 $48 $A0 $00 $00 $7A $92

; 81st entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28D27 to 28D51 (43 bytes)
_DATA_28D27:
.db $08 $1F $70 $F0 $FE $00 $12 $38 $F0 $FE $00 $20 $40 $08 $FF $00
.db $1F $30 $90 $FF $00 $23 $60 $A0 $FF $00 $20 $70 $10 $00 $00 $23
.db $A0 $A8 $00 $00 $12 $30 $B0 $00 $00 $4D $92

; 84th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28D52 to 28D7C (43 bytes)
_DATA_28D52:
.db $08 $1F $68 $10 $FE $00 $23 $40 $A8 $FE $00 $12 $70 $C0 $FE $00
.db $23 $30 $68 $FF $00 $20 $38 $80 $FF $00 $12 $60 $D8 $00 $00 $23
.db $40 $F8 $00 $00 $20 $80 $40 $00 $00 $4D $92

; 86th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28D7D to 28D82 (6 bytes)
_DATA_28D7D:
.db $0C $12 $40 $10 $FE $00

; Pointer Table from 28D83 to 28D86 (2 entries, indexed by unknown)
.dw $9023 $FE80

; Data from 28D87 to 28DBB (53 bytes)
.db $00 $1F $78 $F8 $FE $00 $12 $30 $10 $FF $00 $23 $90 $10 $FF $00
.db $20 $68 $48 $FE $00 $23 $90 $90 $FF $00 $1F $68 $F0 $FF $00 $20
.db $48 $08 $00 $00 $20 $30 $58 $00 $00 $23 $60 $60 $00 $00 $1F $40
.db $F0 $00 $00 $4D $92

; 90th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28DBC to 28DC1 (6 bytes)
_DATA_28DBC:
.db $0B $1F $40 $10 $FE $00

; Pointer Table from 28DC2 to 28DC5 (2 entries, indexed by unknown)
.dw $7815 $FEC0

; Data from 28DC6 to 28DF5 (48 bytes)
.db $00 $13 $40 $40 $FE $00 $13 $40 $20 $FF $00 $18 $80 $88 $FF $00
.db $13 $58 $F8 $FF $00 $15 $98 $F0 $FF $00 $13 $48 $10 $00 $00 $18
.db $A8 $60 $00 $00 $1F $70 $10 $00 $00 $1F $90 $10 $00 $00 $BE $92

; 127th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28DF6 to 28E34 (63 bytes)
_DATA_28DF6:
.db $0C $1F $28 $60 $00 $00 $1F $40 $78 $00 $00 $10 $70 $80 $00 $00
.db $1E $B0 $C0 $00 $00 $1F $28 $28 $01 $00 $10 $70 $28 $01 $00 $1F
.db $98 $28 $01 $00 $1F $30 $F0 $01 $00 $20 $70 $40 $02 $00 $1E $B0
.db $48 $02 $00 $10 $30 $78 $02 $00 $10 $40 $88 $02 $00 $A3 $94

; 129th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28E35 to 28E82 (78 bytes)
_DATA_28E35:
.db $0F $1E $50 $60 $00 $00 $1F $30 $98 $00 $00 $1E $50 $B8 $00 $00
.db $10 $70 $68 $00 $00 $10 $70 $A8 $00 $00 $10 $70 $78 $00 $00 $1E
.db $B0 $D0 $00 $00 $10 $80 $88 $01 $00 $1F $A0 $78 $01 $00 $1B $58
.db $A0 $01 $00 $11 $58 $A0 $01 $00 $1B $60 $30 $02 $00 $11 $60 $30
.db $02 $00 $10 $20 $80 $02 $01 $1F $90 $E0 $02 $00 $A3 $94

; 130th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28E83 to 28EB7 (53 bytes)
_DATA_28E83:
.db $0A $12 $50 $10 $01 $00 $1E $60 $88 $01 $00 $1F $40 $C0 $01 $00
.db $1F $58 $C0 $01 $00 $1F $90 $88 $01 $00 $12 $30 $18 $02 $00 $12
.db $50 $50 $02 $00 $1B $88 $18 $02 $00 $11 $88 $18 $02 $00 $1E $B0
.db $70 $02 $00 $D0 $94

; 131st entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28EB8 to 28EEC (53 bytes)
_DATA_28EB8:
.db $0A $1E $60 $20 $FF $00 $12 $30 $90 $FF $00 $12 $48 $B0 $FF $00
.db $12 $40 $D0 $FF $00 $1B $40 $48 $00 $00 $11 $40 $48 $00 $00 $12
.db $58 $D0 $00 $00 $1E $B0 $18 $00 $00 $1E $B0 $50 $00 $00 $20 $78
.db $A0 $FF $00 $D0 $94

; 133rd entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28EED to 28F26 (58 bytes)
_DATA_28EED:
.db $0B $20 $70 $30 $FE $00 $1E $70 $A0 $FE $00 $1F $60 $F0 $FE $00
.db $1E $40 $D0 $FE $00 $1E $50 $70 $FF $00 $10 $70 $60 $FF $00 $1B
.db $40 $C8 $FF $00 $11 $40 $C8 $FF $00 $10 $20 $40 $00 $00 $10 $20
.db $68 $00 $00 $1E $B0 $88 $00 $00 $A3 $94

; 134th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28F27 to 28F6A (68 bytes)
_DATA_28F27:
.db $0D $12 $78 $30 $FE $00 $1B $40 $88 $FE $00 $11 $90 $88 $FE $00
.db $12 $60 $C0 $FE $00 $12 $50 $D8 $FE $00 $12 $50 $10 $FF $00 $1F
.db $98 $18 $FF $00 $1E $60 $50 $FF $00 $20 $60 $C8 $FF $00 $1F $30
.db $60 $00 $00 $1F $50 $70 $00 $00 $1F $40 $90 $00 $00 $20 $70 $88
.db $00 $00 $D0 $94

; 135th entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 28F6B to 28F70 (6 bytes)
_DATA_28F6B:
.db $0C $20 $30 $78 $FE $00

; Pointer Table from 28F71 to 28F74 (2 entries, indexed by unknown)
.dw _DATA_2981B $FE90

; Data from 28F75 to 28FA7 (51 bytes)
.db $00 $11 $98 $90 $FE $00 $1F $90 $08 $FF $00 $10 $70 $28 $FF $00
.db $10 $70 $40 $FF $00 $10 $70 $60 $FF $00 $10 $70 $78 $FF $00 $1E
.db $50 $88 $FF $00 $10 $60 $C0 $FF $00 $1E $40 $70 $00 $00 $1E $70
.db $88 $00 $00

; Pointer Table from 28FA8 to 290B5 (135 entries, indexed by _RAM_CURRENT_MAP)
MapEnemySpawnArrayPointers:
.dw _DATA_294A3
.dw _DATA_28008
.dw _DATA_28717
.dw _DATA_28008
.dw _DATA_28717
.dw _DATA_2805B
.dw _DATA_2876A
.dw _DATA_280AE
.dw _DATA_287BD
.dw _DATA_280F2
.dw _DATA_28801
.dw _DATA_280F2
.dw _DATA_28801
.dw _DATA_28131
.dw _DATA_28840
.dw _DATA_28131
.dw _DATA_28840
.dw _DATA_2816B
.dw _DATA_2887A
.dw _DATA_281A0
.dw _DATA_288AA
.dw _DATA_281D5
.dw _DATA_288E4
.dw _DATA_281D5
.dw _DATA_288E4
.dw _DATA_28205
.dw _DATA_28914
.dw _DATA_28205
.dw _DATA_28914
.dw _DATA_28258
.dw _DATA_2895D
.dw _DATA_28258
.dw _DATA_2895D
.dw _DATA_2829C
.dw _DATA_2899C
.dw _DATA_28384
.dw _DATA_28A84
.dw _DATA_283D7
.dw _DATA_28AD7
.dw _DATA_283D7
.dw _DATA_28AD7
.dw _DATA_283D7
.dw _DATA_28AD7
.dw _DATA_2842A
.dw _DATA_28B20
.dw _DATA_2842A
.dw _DATA_28B20
.dw _DATA_28469
.dw _DATA_28B5A
.dw _DATA_284AD
.dw _DATA_28B9E
.dw _DATA_284AD
.dw _DATA_284AD
.dw _DATA_28B9E
.dw _DATA_284AD
.dw _DATA_28500
.dw _DATA_28BF1
.dw _DATA_28500
.dw _DATA_28553
.dw _DATA_28C3A
.dw _DATA_2857E
.dw _DATA_28C65
.dw _DATA_2857E
.dw _DATA_28C65
.dw _DATA_282E0
.dw _DATA_289E0
.dw _DATA_2831A
.dw _DATA_28A1A
.dw _DATA_285A4
.dw _DATA_28C8B
.dw _DATA_285A4
.dw _DATA_28C8B
.dw _DATA_285A4
.dw _DATA_28C8B
.dw _DATA_285A4
.dw _DATA_28C8B
.dw _DATA_285ED
.dw _DATA_28CD4
.dw _DATA_285ED
.dw _DATA_28640
.dw _DATA_28D27
.dw _DATA_28640
.dw _DATA_2866B
.dw _DATA_28D52
.dw _DATA_28696
.dw _DATA_28D7D
.dw _DATA_28696
.dw _DATA_28D7D
.dw _DATA_286D5
.dw _DATA_28DBC
.dw _DATA_2834F
.dw _DATA_28A4F
.dw _DATA_2834F
.dw _DATA_28A4F
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000
.dw _DATA_28000 ; Varlin (UL, Open)
.dw _DATA_28DF6 ; Dark Suma's Dungeon 1F (DL)
.dw _DATA_28DF6
.dw _DATA_28E35
.dw _DATA_28E83
.dw _DATA_28EB8
.dw _DATA_28EB8
.dw _DATA_28EED
.dw _DATA_28F27
.dw _DATA_28F6B

; 1st entry of Pointer Table from 28006 (indexed by unknown)
; Data from 290B6 to 294A2 (1005 bytes)
_DATA_290B6:
.db $01 $C0 $54 $E8 $85 $00 $00 $00 $00 $00 $00 $00 $03 $00 $45 $F6
.db $B5 $01 $00 $05 $00 $06 $00 $4B $00 $52 $13 $B2 $01 $00 $12 $00
.db $04 $00 $56 $80 $5A $56 $8F $01 $80 $1A $80 $01 $80 $5D $03 $00
.db $45 $F6 $B5 $01 $00 $05 $00 $06 $00 $4B $00 $52 $13 $B2 $01 $00
.db $12 $00 $04 $00 $56 $80 $5A $57 $8B $01 $80 $1A $40 $02 $C0 $5C
.db $04 $00 $45 $F6 $B5 $01 $00 $05 $00 $06 $00 $4B $00 $51 $2E $84
.db $09 $00 $11 $40 $03 $40 $54 $80 $57 $17 $8A $01 $80 $17 $80 $01
.db $00 $59 $80 $5A $57 $8B $01 $80 $1A $40 $02 $C0 $5C $04 $00 $45
.db $F6 $B5 $01 $00 $05 $00 $06 $00 $4B $00 $51 $2E $84 $09 $00 $11
.db $40 $03 $40 $54 $80 $57 $17 $8A $01 $80 $17 $80 $01 $00 $59 $80
.db $5A $56 $8F $01 $80 $1A $80 $01 $80 $5D $03 $00 $45 $00 $80 $09
.db $00 $05 $40 $05 $40 $4A $00 $52 $13 $B2 $01 $00 $12 $00 $04 $00
.db $56 $80 $5A $56 $8F $01 $80 $1A $80 $01 $80 $5D $03 $00 $45 $00
.db $80 $09 $00 $05 $40 $05 $40 $4A $00 $52 $13 $B2 $01 $00 $12 $00
.db $04 $00 $56 $80 $5A $57 $8B $01 $80 $1A $40 $02 $C0 $5C $04 $00
.db $45 $00 $80 $09 $00 $05 $40 $05 $40 $4A $00 $51 $2E $84 $09 $00
.db $11 $40 $03 $40 $54 $80 $57 $17 $8A $01 $80 $17 $80 $01 $00 $59
.db $80 $5A $57 $8B $01 $80 $1A $40 $02 $C0 $5C $04 $00 $45 $00 $80
.db $09 $00 $05 $40 $05 $40 $4A $00 $51 $2E $84 $09 $00 $11 $40 $03
.db $40 $54 $80 $57 $17 $8A $01 $80 $17 $80 $01 $00 $59 $80 $5A $56
.db $8F $01 $80 $1A $80 $01 $80 $5D $03 $00 $45 $8F $9F $01 $00 $05
.db $40 $06 $40 $4B $80 $51 $02 $87 $00 $00 $00 $00 $00 $00 $00 $C0
.db $54 $E8 $85 $00 $00 $00 $00 $00 $00 $00 $04 $00 $45 $86 $BB $01
.db $00 $05 $40 $05 $40 $4A $00 $5B $21 $AE $01 $00 $1B $00 $02 $00
.db $5D $80 $4F $70 $AA $01 $80 $0F $00 $04 $80 $53 $80 $57 $00 $80
.db $00 $00 $00 $00 $00 $00 $00 $04 $00 $45 $94 $99 $01 $00 $05 $00
.db $07 $00 $4C $C0 $54 $E8 $85 $00 $00 $00 $00 $00 $00 $00 $80 $5A
.db $57 $8B $01 $80 $1A $40 $02 $C0 $5C $80 $57 $17 $8A $01 $80 $17
.db $80 $01 $00 $59 $03 $00 $45 $94 $99 $01 $00 $05 $00 $07 $00 $4C
.db $C0 $54 $E8 $85 $00 $00 $00 $00 $00 $00 $00 $00 $5A $64 $8D $01
.db $00 $1A $80 $02 $80 $5C $03 $00 $45 $70 $92 $01 $00 $05 $00 $06
.db $00 $4B $00 $51 $3F $96 $01 $00 $11 $80 $03 $80 $54 $80 $5A $57
.db $8B $01 $80 $1A $40 $02 $C0 $5C $03 $00 $45 $70 $92 $01 $00 $05
.db $00 $06 $00 $4B $00 $52 $A3 $82 $01 $00 $12 $80 $03 $80 $55 $00
.db $5A $64 $8D $01 $00 $1A $80 $02 $80 $5C $03 $00 $45 $70 $92 $01
.db $00 $05 $00 $06 $00 $4B $00 $52 $A3 $82 $01 $00 $12 $80 $03 $80
.db $55 $80 $5A $57 $8B $01 $80 $1A $40 $02 $C0 $5C $03 $00 $45 $70
.db $92 $01 $00 $05 $00 $06 $00 $4B $00 $51 $3F $96 $01 $00 $11 $80
.db $03 $80 $54 $00 $5A $64 $8D $01 $00 $1A $80 $02 $80 $5C $04 $00
.db $45 $3A $AF $01 $00 $05 $00 $04 $00 $49 $00 $4D $13 $B5 $01 $00
.db $0D $40 $02 $40 $4F $80 $51 $02 $87 $00 $00 $00 $00 $00 $00 $00
.db $C0 $54 $E8 $85 $00 $00 $00 $00 $00 $00 $00 $04 $00 $45 $8F $9F
.db $01 $00 $05 $40 $06 $40 $4B $80 $51 $02 $87 $00 $00 $00 $00 $00
.db $00 $00 $C0 $54 $E8 $85 $00 $00 $00 $00 $00 $00 $00 $80 $57 $17
.db $8A $01 $80 $17 $80 $01 $00 $59 $04 $00 $45 $8F $9F $01 $00 $05
.db $40 $06 $40 $4B $80 $51 $02 $87 $00 $00 $00 $00 $00 $00 $00 $C0
.db $54 $E8 $85 $00 $00 $00 $00 $00 $00 $00 $00 $5A $64 $8D $01 $00
.db $1A $80 $02 $80 $5C $05 $00 $45 $3A $AF $01 $00 $05 $00 $04 $00
.db $49 $00 $4D $13 $B5 $01 $00 $0D $40 $02 $40 $4F $80 $51 $02 $87
.db $00 $00 $00 $00 $00 $00 $00 $C0 $54 $E8 $85 $00 $00 $00 $00 $00
.db $00 $00 $80 $57 $17 $8A $01 $80 $17 $80 $01 $00 $59 $05 $00 $45
.db $3A $AF $01 $00 $05 $00 $04 $00 $49 $00 $4D $13 $B5 $01 $00 $0D
.db $40 $02 $40 $4F $80 $51 $02 $87 $00 $00 $00 $00 $00 $00 $00 $C0
.db $54 $E8 $85 $00 $00 $00 $00 $00 $00 $00 $00 $5A $64 $8D $01 $00
.db $1A $80 $02 $80 $5C $03 $00 $45 $86 $BB $01 $00 $05 $40 $05 $40
.db $4A $00 $52 $13 $B2 $01 $00 $12 $00 $04 $00 $56 $00 $5A $64 $8D
.db $01 $00 $1A $80 $02 $80 $5C $03 $00 $45 $0C $A5 $01 $00 $05 $80
.db $06 $80 $4B $00 $52 $13 $B2 $01 $00 $12 $00 $04 $00 $56 $00 $5A
.db $64 $8D $01 $00 $1A $80 $02 $80 $5C $03 $00 $45 $0C $A5 $01 $00
.db $05 $80 $06 $80 $4B $00 $52 $13 $B2 $01 $00 $12 $00 $04 $00 $56
.db $00 $5A $64 $8D $01 $00 $1A $80 $02 $80 $5C $03 $00 $45 $0C $A5
.db $01 $00 $05 $80 $06 $80 $4B $00 $52 $A3 $82 $01 $00 $12 $80 $03
.db $80 $55 $00 $5A $64 $8D $01 $00 $1A $80 $02 $80 $5C

; 1st entry of Pointer Table from 28FA8 (indexed by _RAM_CURRENT_MAP)
; Data from 294A3 to 294FC (90 bytes)
_DATA_294A3:
.db $04 $00 $4D $13 $B5 $01 $00 $0D $40 $02 $40 $4F $80 $57 $00 $80
.db $00 $00 $00 $00 $00 $00 $00 $C0 $54 $E8 $85 $00 $00 $00 $00 $00
.db $00 $00 $80 $51 $02 $87 $00 $00 $00 $00 $00 $00 $00 $04 $00 $4D
.db $13 $B5 $01 $00 $0D $40 $02 $40 $4F $80 $57 $17 $8A $01 $80 $17
.db $80 $01 $00 $59 $C0 $54 $E8 $85 $00 $00 $00 $00 $00 $00 $00 $80
.db $51 $02 $87 $00 $00 $00 $00 $00 $00 $00

; Data from 294FD to 29814 (792 bytes)
_DATA_294FD:
.db $20 $00 $8C $05 $00 $07 $02 $00 $03 $01 $C4 $C0 $88 $34 $74 $02
.db $38 $03 $00 $8F $0C $3C $38 $48 $C9 $88 $04 $C2 $C1 $07 $07 $03
.db $04 $1A $1F $03 $00 $88 $80 $E0 $F0 $F0 $70 $00 $00 $80 $03 $00
.db $86 $60 $E0 $0E $00 $62 $66 $03 $04 $99 $0C $03 $32 $11 $03 $00
.db $00 $01 $03 $00 $D0 $C8 $08 $1C $1E $0F $01 $03 $00 $87 $82 $80
.db $40 $81 $83 $09 $00 $03 $80 $02 $00 $82 $C0 $80 $11 $00 $8C $05
.db $00 $07 $02 $00 $03 $01 $C4 $C0 $88 $34 $74 $02 $38 $03 $00 $98
.db $0C $3C $38 $48 $C9 $88 $04 $C2 $C1 $07 $07 $03 $04 $1A $00 $00
.db $80 $E0 $F0 $F0 $70 $00 $00 $80 $03 $00 $89 $60 $E0 $10 $1F $0E
.db $00 $06 $06 $00 $02 $08 $02 $01 $82 $00 $01 $04 $00 $02 $10 $02
.db $20 $02 $40 $86 $A0 $90 $50 $C8 $68 $28 $0F $00 $85 $01 $00 $01
.db $02 $3D $0B $00 $A7 $40 $00 $C0 $E0 $00 $7A $F7 $F3 $FC $7E $3F
.db $CE $B7 $C3 $80 $82 $43 $40 $30 $01 $09 $E0 $30 $10 $20 $2C $5C
.db $1C $0C $06 $CE $0E $06 $06 $02 $80 $80 $06 $02 $02 $01 $0D $00
.db $82 $60 $F0 $02 $E0 $02 $40 $81 $20 $0B $00 $84 $02 $00 $03 $02
.db $03 $00 $02 $01 $02 $00 $81 $01 $04 $00 $94 $07 $0F $1F $1F $1E
.db $9E $3D $1E $07 $03 $63 $6C $9C $00 $00 $F0 $F8 $F8 $ED $83 $06
.db $00 $85 $80 $00 $C0 $04 $02 $07 $00 $81 $03 $04 $01 $8C $02 $07
.db $D8 $10 $18 $0B $0F $1E $3A $71 $40 $C0 $02 $80 $04 $00 $03 $60
.db $02 $30 $02 $18 $86 $9C $DE $C3 $17 $04 $02 $0C $00 $85 $C0 $EC
.db $06 $81 $01 $08 $00 $86 $08 $00 $08 $08 $00 $02 $02 $07 $02 $0F
.db $07 $00 $8C $0C $03 $01 $00 $30 $71 $7F $27 $07 $1E $1C $30 $0D
.db $00 $89 $0C $00 $00 $05 $02 $03 $06 $0E $4C $03 $38 $84 $70 $30
.db $20 $00 $03 $80 $8C $00 $20 $F0 $30 $18 $18 $8D $8F $0F $07 $21
.db $12 $09 $00 $02 $C0 $81 $8C $07 $00 $8A $20 $00 $80 $40 $22 $00
.db $09 $07 $06 $02 $03 $01 $0C $00 $8D $20 $30 $00 $80 $80 $00 $0C
.db $3C $46 $C0 $20 $00 $80 $08 $00 $8C $03 $01 $01 $00 $01 $06 $00
.db $00 $01 $19 $1F $F0 $04 $00 $82 $18 $08 $03 $80 $03 $00 $88 $81
.db $8E $1E $18 $1C $10 $08 $04 $0B $00 $02 $C0 $03 $00 $02 $0B $83
.db $08 $19 $06 $03 $00 $81 $08 $03 $30 $92 $00 $20 $30 $08 $00 $00
.db $C2 $62 $2E $48 $04 $0C $0E $0E $0C $0E $0C $08 $09 $00 $02 $01
.db $85 $03 $07 $03 $00 $02 $02 $1C $06 $00 $8A $08 $1C $80 $14 $10
.db $A0 $20 $60 $00 $80 $06 $00 $02 $01 $0A $00 $02 $03 $87 $01 $03
.db $81 $C1 $F6 $3C $0F $02 $00 $03 $0C $87 $22 $40 $06 $88 $00 $30
.db $80 $09 $00 $03 $01 $94 $07 $06 $00 $34 $3C $38 $78 $30 $70 $60
.db $00 $20 $00 $8C $B0 $D8 $30 $38 $3C $C0 $02 $0E $03 $06 $84 $00
.db $02 $03 $01 $09 $00 $81 $01 $05 $00 $86 $01 $00 $00 $18 $06 $01
.db $05 $00 $94 $84 $51 $61 $30 $00 $B0 $00 $01 $05 $0E $9C $98 $03
.db $07 $03 $01 $02 $04 $CC $08 $04 $00 $87 $80 $00 $00 $10 $80 $88
.db $08 $07 $00 $84 $03 $06 $04 $00 $03 $01 $82 $00 $01 $07 $00 $88
.db $78 $F8 $BC $0C $0E $81 $80 $04 $0D $00 $86 $18 $24 $42 $42 $24
.db $18 $05 $00 $00 $0C $00 $84 $03 $07 $0F $0E $0C $00 $9D $80 $E0
.db $F0 $78 $0D $00 $07 $02 $01 $04 $06 $CF $CB $BB $4D $0D $06 $06
.db $18 $00 $3C $0C $5C $D9 $BB $3A $79 $FC $FE $04 $FF $83 $7C $39
.db $21 $07 $00 $87 $80 $20 $00 $80 $00 $40 $C0 $02 $E0 $03 $7F $81
.db $FF $02 $FC $02 $7C $02 $3F $96 $1E $04 $03 $00 $05 $03 $E0 $F0
.db $F8 $F8 $FC $FE $7F $3F $1F $8F $40 $41 $61 $E0 $C5 $83 $08 $00
.db $81 $80 $03 $40 $03 $E0 $81 $C0 $0D $00 $9D $38 $7E $FF $0E $0D
.db $00 $07 $02 $01 $04 $06 $CF $CB $BB $4D $0D $06 $06 $18 $78 $3C
.db $0C $5C $D9 $BB $3A $79 $FC $FE

; 1st entry of Pointer Table from 285F3 (indexed by unknown)
; Data from 29815 to 29819 (5 bytes)
_DATA_29815:
.db $04 $FF $82 $7C $39

; 1st entry of Pointer Table from 2800E (indexed by unknown)
; Data from 2981A to 2981A (1 bytes)
_DATA_2981A:
.db $06

; 1st entry of Pointer Table from 28F71 (indexed by unknown)
; Data from 2981B to 29820 (6 bytes)
_DATA_2981B:
.db $00 $8B $80 $20 $00 $80

; 1st entry of Pointer Table from 280B4 (indexed by unknown)
; Data from 29821 to 29FD9 (1977 bytes)
_DATA_29821:
.incbin "banks\lots_DATA_29821.inc"

; Data from 29FDA to 2A014 (59 bytes)
_DATA_29FDA:
.db $0E $00 $02 $01 $03 $00 $81 $03 $02 $07 $02 $0F $02 $1F $91 $17
.db $33 $39 $BC $C0 $F0 $00 $30 $FC $FE $E6 $E0 $E2 $C8 $CC $C0 $E8
.db $03 $E0 $82 $20 $00 $02 $01 $05 $03 $81 $01 $08 $00 $84 $FE $FF
.db $FE $FD $06 $FF $8E $3F $1F $00 $38 $7F $7F

; 1st entry of Pointer Table from 285AA (indexed by unknown)
; Data from 2A015 to 2A016 (2 bytes)
_DATA_2A015:
.db $60 $80

; 1st entry of Pointer Table from 282A2 (indexed by unknown)
; Data from 2A017 to 2A730 (1818 bytes)
_DATA_2A017:
.incbin "banks\lots_DATA_2A017.inc"

; Data from 2A731 to 2A816 (230 bytes)
_DATA_2A731:
.db $04 $00 $82 $0C $06 $05 $00 $02 $03 $02 $01 $07 $00 $84 $40 $10
.db $04 $01 $03 $00 $02 $70 $81 $32 $03 $00 $8A $01 $00 $00 $07 $04
.db $01 $02 $40 $11 $05 $03 $00 $90 $20 $40 $40 $80 $C0 $B0 $6C $C2
.db $13 $2C $50 $23 $A3 $93 $52 $09 $08 $00 $92 $80 $60 $50 $30 $28
.db $A8 $18 $94 $03 $0B $33 $3E $1C $A1 $A8 $A8 $50 $20 $06 $00 $89
.db $08 $42 $10 $C0 $74 $38 $9A $4C $45 $02 $21 $02 $12 $C0 $02 $01
.db $0B $00 $00 $80 $23 $4C $C3 $96 $80 $55 $22 $22 $72 $F6 $F8 $91
.db $20 $99 $41 $21 $19 $2F $C7 $1F $7E $FC $FC $B8 $B1 $31 $70 $7F
.db $7F $40 $20 $10 $F0 $E0 $F0 $F8 $78 $7C $7E $F7 $E3 $E2 $EA $FA
.db $F2 $2D $59 $52 $54 $88 $B4 $BE $5A $27 $10 $0A $06 $03 $03 $00
.db $82 $87 $78 $0E $00 $90 $7F $21 $21 $13 $17 $17 $06 $16 $16 $14
.db $24 $24 $08 $40 $C0 $00 $02 $CC $02 $A0 $02 $30 $81 $18 $02 $08
.db $02 $04 $02 $00 $88 $08 $00 $00 $40 $20 $10 $F0 $E0 $02 $F0 $02
.db $78 $87 $7C $FC $EE $EA $EA $F2 $F3 $04 $05 $94 $0B $0A $0C $1C
.db $1E $3C $38 $70 $F0 $A0

; 1st entry of Pointer Table from 2820B (indexed by unknown)
; Data from 2A817 to 2A819 (3 bytes)
_DATA_2A817:
.db $C0 $00 $30

; 1st entry of Pointer Table from 280F8 (indexed by unknown)
; Data from 2A81A to 2AF7F (1894 bytes)
_DATA_2A81A:
.incbin "banks\lots_DATA_2A81A.inc"

; Data from 2AF80 to 2B024 (165 bytes)
_DATA_2AF80:
.db $81 $00 $03 $40 $92 $61 $C3 $03 $26 $26 $0F $2E $14 $00 $02 $14
.db $09 $10 $30 $30 $70 $F8 $BC $02 $1C $02 $38 $84 $78 $F0 $F0 $40
.db $0C $00 $02 $04 $94 $0C $1E $1E $1C $29 $53 $89 $A1 $81 $00 $04
.db $0E $0F $8F $8F $47 $41 $00 $30 $3C $02 $80 $02 $40 $02 $A0 $8A
.db $63 $47 $1F $87 $C7 $C7 $97 $13 $CB $05 $0A $00 $02 $80 $03 $C0
.db $8B $A0 $1E $18 $18 $00 $10 $00 $3C $34 $24 $28 $03 $20 $02 $18
.db $86 $00 $3C $3D $19 $13 $0F $04 $1F $98 $17 $3F $1D $75 $1E $6D
.db $3C $64 $0C $6C $94 $74 $78 $98 $AC $5E $5E $AE $6E $5E $DF $DF
.db $BF $30 $04 $78 $81 $70 $02 $30 $02 $20 $02 $08 $A4 $00 $30 $20
.db $00 $06 $0B $05 $0B $0D $02 $05 $02 $07 $07 $03 $00 $03 $01 $03
.db $03 $EE $7D $FE $6D

; 1st entry of Pointer Table from 28559 (indexed by unknown)
; Data from 2B025 to 2B027 (3 bytes)
_DATA_2B025:
.db $FB $F3 $FA

; 1st entry of Pointer Table from 282E6 (indexed by unknown)
; Data from 2B028 to 2BFFF (4056 bytes)
_DATA_2B028:
.incbin "banks\lots_DATA_2B028.inc"

.BANK 11
.ORG $0000
Bank11:

; 2nd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C000 to 2C00B (12 bytes)
_DATA_2C000:
.db $A8 $30 $24 $83 $00 $01 $00 $A0 $72 $72 $35 $35

; 3rd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C00C to 2C017 (12 bytes)
_DATA_2C00C:
.db $A8 $D0 $24 $83 $A0 $01 $00 $A0 $72 $72 $35 $35

; 4th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C018 to 2C023 (12 bytes)
_DATA_2C018:
.db $A8 $30 $24 $83 $00 $01 $00 $A0 $76 $76 $69 $69

; 5th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C024 to 2C02F (12 bytes)
_DATA_2C024:
.db $A8 $D0 $24 $83 $A0 $01 $00 $A0 $76 $76 $69 $69

; 6th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C030 to 2C03B (12 bytes)
_DATA_2C030:
.db $70 $30 $2E $86 $00 $01 $00 $A0 $44 $44 $6C $6C

; 7th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C03C to 2C047 (12 bytes)
_DATA_2C03C:
.db $A0 $D8 $2E $86 $A0 $01 $00 $A0 $44 $44 $6C $6C

; 8th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C048 to 2C053 (12 bytes)
_DATA_2C048:
.db $98 $30 $25 $89 $00 $01 $00 $A0 $23 $23 $5F $5F

; 9th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C054 to 2C05F (12 bytes)
_DATA_2C054:
.db $A8 $D0 $25 $89 $A0 $01 $00 $A0 $23 $23 $5F $5F

; 10th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C060 to 2C06B (12 bytes)
_DATA_2C060:
.db $A8 $30 $F0 $8B $00 $01 $00 $60 $36 $36 $3D $3D

; 11th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C06C to 2C077 (12 bytes)
_DATA_2C06C:
.db $A8 $D0 $F0 $8B $60 $01 $00 $60 $36 $36 $3D $3D

; 12th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C078 to 2C083 (12 bytes)
_DATA_2C078:
.db $A8 $30 $F0 $8B $00 $01 $00 $60 $48 $48 $6A $6A

; 13th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C084 to 2C08F (12 bytes)
_DATA_2C084:
.db $A8 $D0 $F0 $8B $60 $01 $00 $60 $48 $48 $6A $6A

; 14th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C090 to 2C09B (12 bytes)
_DATA_2C090:
.db $98 $30 $DF $8D $00 $01 $00 $60 $7A $7A $2E $2E

; 15th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C09C to 2C0A7 (12 bytes)
_DATA_2C09C:
.db $A8 $D0 $DF $8D $60 $01 $00 $60 $7A $7A $2E $2E

; 16th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C0A8 to 2C0B3 (12 bytes)
_DATA_2C0A8:
.db $98 $30 $DF $8D $00 $01 $00 $60 $6B $6B $28 $28

; 17th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C0B4 to 2C0BF (12 bytes)
_DATA_2C0B4:
.db $A8 $D0 $DF $8D $60 $01 $00 $60 $6B $6B $28 $28

; 18th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C0C0 to 2C0CB (12 bytes)
_DATA_2C0C0:
.db $A0 $30 $D0 $8F $00 $01 $00 $40 $3C $3C $61 $61

; 19th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C0CC to 2C0D7 (12 bytes)
_DATA_2C0CC:
.db $A0 $D0 $D0 $8F $40 $01 $00 $40 $3C $3C $61 $61

; 20th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C0D8 to 2C0E3 (12 bytes)
_DATA_2C0D8:
.db $88 $30 $CF $91 $00 $01 $00 $40 $5E $5E $2C $2C

; 21st entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C0E4 to 2C0EF (12 bytes)
_DATA_2C0E4:
.db $A8 $D0 $CF $91 $40 $01 $00 $40 $5E $5E $2C $2C

; 22nd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C0F0 to 2C0FB (12 bytes)
_DATA_2C0F0:
.db $A8 $30 $6B $93 $00 $01 $00 $40 $71 $71 $50 $50

; 23rd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C0FC to 2C107 (12 bytes)
_DATA_2C0FC:
.db $88 $D0 $6B $93 $40 $01 $00 $40 $71 $71 $50 $50

; 24th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C108 to 2C113 (12 bytes)
_DATA_2C108:
.db $A8 $30 $6B $93 $00 $01 $00 $40 $3E $3E $75 $75

; 25th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C114 to 2C11F (12 bytes)
_DATA_2C114:
.db $88 $D0 $6B $93 $40 $01 $00 $40 $3E $3E $75 $75

; 26th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C120 to 2C12B (12 bytes)
_DATA_2C120:
.db $A8 $30 $05 $95 $00 $01 $00 $60 $5C $5C $77 $77

; 27th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C12C to 2C137 (12 bytes)
_DATA_2C12C:
.db $A8 $D0 $05 $95 $60 $01 $00 $60 $5C $5C $77 $77

; 28th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C138 to 2C143 (12 bytes)
_DATA_2C138:
.db $A8 $30 $05 $95 $00 $01 $00 $60 $34 $34 $6D $6D

; 29th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C144 to 2C14F (12 bytes)
_DATA_2C144:
.db $A8 $D0 $05 $95 $60 $01 $00 $60 $34 $34 $6D $6D

; 30th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C150 to 2C15B (12 bytes)
_DATA_2C150:
.db $90 $30 $D1 $96 $00 $01 $00 $60 $78 $78 $FF $8A

; 31st entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C15C to 2C167 (12 bytes)
_DATA_2C15C:
.db $A0 $D0 $D1 $96 $60 $01 $00 $60 $78 $78 $FF $8A

; 32nd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C168 to 2C173 (12 bytes)
_DATA_2C168:
.db $90 $30 $D1 $96 $00 $01 $00 $60 $60 $60 $5B $5B

; 33rd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C174 to 2C17F (12 bytes)
_DATA_2C174:
.db $A0 $D0 $D1 $96 $60 $01 $00 $60 $60 $60 $5B $5B

; 34th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C180 to 2C18B (12 bytes)
_DATA_2C180:
.db $A0 $30 $E3 $98 $00 $01 $00 $60 $37 $37 $7B $7B

; 35th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C18C to 2C197 (12 bytes)
_DATA_2C18C:
.db $88 $D0 $E3 $98 $60 $01 $00 $60 $37 $37 $7B $7B

; 36th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C198 to 2C1A3 (12 bytes)
_DATA_2C198:
.db $A0 $30 $01 $9B $00 $02 $00 $A0 $62 $62 $08 $08

; 37th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C1A4 to 2C1AF (12 bytes)
_DATA_2C1A4:
.db $B0 $D0 $01 $9B $A0 $02 $00 $A0 $62 $62 $08 $08

; 38th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C1B0 to 2C1BB (12 bytes)
_DATA_2C1B0:
.db $A0 $30 $34 $9E $00 $02 $00 $A0 $64 $64 $45 $45

; 39th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C1BC to 2C1C7 (12 bytes)
_DATA_2C1BC:
.db $A0 $D0 $34 $9E $A0 $02 $00 $A0 $64 $64 $45 $45

; 40th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C1C8 to 2C1D3 (12 bytes)
_DATA_2C1C8:
.db $A0 $30 $34 $9E $00 $02 $00 $A0 $0F $0F $FF $82

; 41st entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C1D4 to 2C1DF (12 bytes)
_DATA_2C1D4:
.db $A0 $D0 $34 $9E $A0 $02 $00 $A0 $0F $0F $FF $82

; 42nd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C1E0 to 2C1EB (12 bytes)
_DATA_2C1E0:
.db $A0 $30 $34 $9E $00 $02 $00 $A0 $39 $39 $FF $81

; 43rd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C1EC to 2C1F7 (12 bytes)
_DATA_2C1EC:
.db $A0 $D0 $34 $9E $A0 $02 $00 $A0 $39 $39 $FF $81

; 44th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C1F8 to 2C203 (12 bytes)
_DATA_2C1F8:
.db $B0 $30 $7C $A1 $00 $02 $00 $40 $13 $13 $55 $55

; 45th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C204 to 2C20F (12 bytes)
_DATA_2C204:
.db $80 $D0 $7C $A1 $40 $02 $00 $40 $13 $13 $55 $55

; 46th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C210 to 2C21B (12 bytes)
_DATA_2C210:
.db $B0 $30 $7C $A1 $00 $02 $00 $40 $0D $0D $63 $63

; 47th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C21C to 2C227 (12 bytes)
_DATA_2C21C:
.db $80 $D0 $7C $A1 $40 $02 $00 $40 $0D $0D $63 $63

; 48th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C228 to 2C233 (12 bytes)
_DATA_2C228:
.db $A0 $30 $59 $A3 $00 $02 $00 $40 $56 $56 $33 $33

; 49th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C234 to 2C23F (12 bytes)
_DATA_2C234:
.db $50 $D8 $59 $A3 $40 $02 $00 $40 $56 $56 $33 $33

; 50th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C240 to 2C24B (12 bytes)
_DATA_2C240:
.db $A0 $30 $07 $A8 $00 $02 $00 $A0 $64 $64 $2F $45

; 51st entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C24C to 2C257 (12 bytes)
_DATA_2C24C:
.db $A0 $D0 $07 $A8 $A0 $02 $00 $A0 $64 $64 $2F $45

; 52nd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C258 to 2C263 (12 bytes)
_DATA_2C258:
.db $70 $30 $07 $A8 $00 $02 $00 $A0 $64 $64 $2F $45

; 53rd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C264 to 2C26F (12 bytes)
_DATA_2C264:
.db $A0 $30 $07 $A8 $00 $02 $00 $A0 $01 $01 $0A $1C

; 54th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C270 to 2C27B (12 bytes)
_DATA_2C270:
.db $A0 $D0 $07 $A8 $A0 $02 $00 $A0 $01 $01 $0A $1C

; 55th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C27C to 2C287 (12 bytes)
_DATA_2C27C:
.db $70 $30 $07 $A8 $00 $02 $00 $A0 $01 $01 $0A $1C

; 56th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C288 to 2C293 (12 bytes)
_DATA_2C288:
.db $80 $30 $80 $AB $00 $02 $00 $A0 $3A $3A $2A $22

; 57th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C294 to 2C29F (12 bytes)
_DATA_2C294:
.db $A0 $D0 $80 $AB $A0 $02 $00 $A0 $3A $3A $2A $22

; 58th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C2A0 to 2C2AB (12 bytes)
_DATA_2C2A0:
.db $50 $30 $80 $AB $00 $02 $00 $A0 $3A $3A $2A $22

; 59th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C2AC to 2C2B7 (12 bytes)
_DATA_2C2AC:
.db $88 $30 $C0 $AE $00 $03 $00 $40 $68 $68 $38 $38

; 60th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C2B8 to 2C2C3 (12 bytes)
_DATA_2C2B8:
.db $98 $D0 $C0 $AE $40 $03 $00 $40 $68 $68 $38 $38

; 61st entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C2C4 to 2C2CF (12 bytes)
_DATA_2C2C4:
.db $88 $30 $60 $B0 $00 $03 $00 $40 $09 $09 $12 $12

; 62nd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C2D0 to 2C2DB (12 bytes)
_DATA_2C2D0:
.db $88 $D0 $60 $B0 $40 $03 $00 $40 $09 $09 $12 $12

; 63rd entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C2DC to 2C2E7 (12 bytes)
_DATA_2C2DC:
.db $88 $30 $60 $B0 $00 $03 $00 $40 $46 $46 $18 $18

; 64th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C2E8 to 2C2F3 (12 bytes)
_DATA_2C2E8:
.db $88 $D0 $60 $B0 $40 $03 $00 $40 $46 $46 $18 $18

; 65th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C2F4 to 2C2FF (12 bytes)
_DATA_2C2F4:
.db $B8 $30 $FE $B1 $00 $04 $00 $A0 $58 $58 $7E $7E

; 66th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C300 to 2C30B (12 bytes)
_DATA_2C300:
.db $B8 $D0 $FE $B1 $A0 $04 $00 $A0 $58 $58 $7E $7E

; 67th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C30C to 2C317 (12 bytes)
_DATA_2C30C:
.db $A8 $30 $FA $B4 $00 $04 $00 $A0 $5A $5A $FF $85

; 68th entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2C318 to 2E1B1 (7834 bytes)
_DATA_2C318:
.incbin "banks\lots_DATA_2C318.inc"

; 1st entry of Pointer Table from 5546 (indexed by _RAM_CURRENT_MAP)
; Data from 2E1B2 to 2F83C (5771 bytes)
_DATA_2E1B2:
.incbin "banks\lots_DATA_2E1B2.inc"

; Data from 2F83D to 2F963 (295 bytes)
_DATA_2F83D:
.db $0E $00 $82 $07 $08 $07 $00 $81 $F8 $06 $00 $82 $07 $48 $06 $00
.db $82 $03 $B4 $07 $00 $81 $83 $06 $00 $82 $FC $02 $04 $00 $81 $01
.db $03 $02 $B0 $4A $B5 $57 $75 $8B $70 $A9 $7A $84 $32 $6A $09 $F2
.db $05 $F8 $00 $B7 $45 $3B $86 $78 $87 $78 $00 $4B $31 $46 $F8 $07
.db $F8 $00 $00 $4C $73 $8D $75 $DA $24 $18 $00 $FD $8A $76 $4A $BD
.db $42 $3C $00 $05 $01 $03 $00 $8D $8A $2A $4A $7A $32 $84 $68 $28
.db $00 $01 $00 $00 $01 $03 $02 $99 $94 $4A $AA $AA $2A $D4 $B4 $E4
.db $01 $00 $01 $01 $00 $01 $02 $02 $14 $B4 $54 $54 $94 $28 $A8 $C8
.db $01 $05 $00 $02 $01 $88 $28 $D8 $54 $5A $AA $B4 $48 $70 $06 $02
.db $8A $01 $00 $C8 $B4 $AA $AA $DA $AA $74 $88 $00 $0F $00 $81 $07
.db $0F $00 $81 $07 $07 $00 $81 $03 $0F $00 $81 $FC $05 $00 $03 $01
.db $9D $05 $4A $28 $08 $74 $8F $46 $84 $78 $CC $94 $F6 $0D $F8 $00
.db $00 $48 $3A $04 $01 $87 $78 $00 $00 $B0 $C0 $81 $07 $F8 $03 $00
.db $8E $83 $8C $70 $88 $24 $18 $00 $00 $02 $71 $89 $81 $42 $3C $0A
.db $00 $86 $74 $D4 $B4 $84 $CC $78 $02 $10 $05 $00 $03 $01 $88 $08
.db $84 $44 $44 $C4 $28 $48 $18 $06 $00 $02 $01 $88 $E8 $48 $88 $88
.db $08 $10 $10 $30 $08 $00 $86 $D0 $20 $28 $24 $54 $48 $02 $80 $06
.db $01 $02 $00 $88 $30 $48 $44 $44 $24 $04 $88 $70 $00 $7F $00 $41
.db $00 $00 $7F $00 $41 $00 $00

; Data from 2F964 to 2F9D5 (114 bytes)
_DATA_2F964:
.db $AA $00 $01 $02 $03 $04 $05 $06 $06 $05 $04 $04 $05 $06 $06 $05
.db $04 $03 $02 $01 $00 $07 $08 $09 $0A $0B $0C $0D $0D $0C $0B $0B
.db $0C $0D $0D $0C $0B $0A $09 $08 $07 $0E $0F $10 $00 $84 $0F $0E
.db $10 $11 $10 $00 $84 $11 $10 $12 $13 $10 $00 $84 $13 $12 $14 $15
.db $10 $00 $84 $15 $14 $16 $17 $10 $00 $82 $17 $16 $00 $07 $00 $03
.db $02 $03 $00 $06 $02 $08 $00 $03 $02 $03 $00 $07 $02 $12 $00 $02
.db $02 $12 $00 $02 $02 $12 $00 $02 $02 $12 $00 $02 $02 $12 $00 $02
.db $02 $00

; Data from 2F9D6 to 2FA56 (129 bytes)
_DATA_2F9D6:
.db $82 $16 $17 $10 $00 $84 $17 $16 $14 $15 $10 $00 $84 $15 $14 $12
.db $13 $10 $00 $84 $13 $12 $10 $11 $10 $00 $84 $11 $10 $0E $0F $10
.db $00 $A9 $0F $0E $07 $08 $09 $0A $0B $0C $0D $0D $0C $0B $0B $0C
.db $0D $0D $0C $0B $0A $09 $08 $07 $00 $01 $02 $03 $04 $05 $06 $06
.db $05 $04 $04 $05 $06 $06 $05 $04 $03 $02 $01 $81 $00 $00 $02 $04
.db $10 $00 $02 $06 $02 $04 $10 $00 $02 $06 $02 $04 $10 $00 $02 $06
.db $02 $04 $10 $00 $02 $06 $02 $04 $10 $00 $02 $06 $07 $04 $03 $06
.db $03 $04 $07 $06 $81 $00 $06 $04 $03 $06 $03 $04 $06 $06 $81 $00
.db $00

; Data from 2FA57 to 2FBB0 (346 bytes)
_DATA_2FA57:
.db $24 $9F $99 $A0 $A1 $A2 $A3 $A4 $A5 $A6 $A7 $A8 $A9 $AA $AB $C4
.db $C5 $C6 $A3 $A6 $AA $AB $C4 $A4 $A5 $A3 $C7 $C8 $06 $9F $84 $AC
.db $AD $AE $AF $04 $B0 $86 $B1 $B2 $B0 $B3 $B4 $AF $04 $B0 $83 $B3
.db $B4 $AF $03 $B0 $83 $C9 $CA $CB $04 $9F $84 $B5 $B6 $B7 $B8 $16
.db $B0 $82 $CC $CD $04 $9F $82 $B9 $BA $19 $B0 $81 $CE $04 $9F $81
.db $BB $19 $B0 $82 $CF $D0 $04 $9F $81 $BC $19 $B0 $82 $D1 $D2 $04
.db $9F $81 $BD $1A $B0 $81 $BF $04 $9F $81 $BE $1A $B0 $81 $BE $04
.db $9F $81 $BF $1A $B0 $81 $BC $04 $9F $82 $C0 $C1 $19 $B0 $81 $BD
.db $04 $9F $82 $C2 $C3 $19 $B0 $81 $D3 $04 $9F $82 $D4 $CF $18 $B0
.db $82 $E2 $E3 $04 $9F $81 $D5 $19 $B0 $82 $E4 $E5 $04 $9F $81 $BD
.db $19 $B0 $82 $E6 $E7 $04 $9F $81 $BE $19 $B0 $82 $E8 $E9 $04 $9F
.db $81 $CE $1A $B0 $81 $EA $04 $9F $82 $D0 $CF $19 $B0 $81 $BE $04
.db $9F $82 $D2 $D1 $19 $B0 $81 $BC $04 $9F $81 $D6 $1A $B0 $81 $EB
.db $04 $9F $82 $D7 $D8 $16 $B0 $84 $EC $ED $EE $EF $04 $9F $83 $D9
.db $DA $DB $03 $B0 $85 $DC $B0 $B3 $B4 $AF $03 $B0 $87 $B2 $B1 $B0
.db $B0 $DC $B0 $F0 $03 $B0 $83 $F1 $F2 $F3 $06 $9F $99 $DD $DE $A3
.db $A6 $DF $E0 $E1 $AA $AB $C4 $A6 $C6 $A9 $A8 $A7 $A6 $DF $E0 $E1
.db $F4 $E1 $F5 $F6 $F7 $F8 $24 $9F $00 $7F $00 $7E $00 $81 $06 $1F
.db $00 $81 $06 $1F $00 $81 $02 $1F $00 $81 $02 $25 $00 $81 $06 $7E
.db $00 $81 $02 $1F $00 $02 $02 $19 $00 $81 $06 $04 $00 $02 $02 $19
.db $00 $81 $02 $4C $00 $03 $04 $03 $00 $02 $06 $13 $00 $02 $04 $03
.db $00 $04 $04 $04 $06 $81 $04 $2D $00 $00

; Data from 2FBB1 to 2FCA2 (242 bytes)
_DATA_2FBB1:
.db $7F $00 $79 $00 $00 $04 $00 $82 $07 $0D $02 $0F $02 $00 $86 $1C
.db $70 $F8 $FE $8F $03 $03 $00 $8B $07 $1C $70 $E1 $83 $00 $00 $F0
.db $20 $40 $C0 $02 $80 $0E $00 $88 $01 $03 $00 $00 $03 $1E $70 $C0
.db $02 $80 $02 $00 $81 $E0 $0B $00 $02 $01 $02 $00 $02 $40 $85 $C0
.db $80 $80 $00 $06 $03 $00 $85 $06 $1F $39 $31 $01 $04 $03 $93 $06
.db $86 $86 $07 $0F $0C $18 $38 $30 $71 $63 $00 $80 $C0 $C3 $C7 $8C
.db $98 $90 $03 $00 $81 $80 $04 $C0 $83 $03 $07 $06 $03 $0E $02 $07
.db $C8 $00 $01 $07 $0E $18 $31 $63 $FE $00 $E0 $F1 $73 $E7 $C5 $89
.db $0B $00 $00 $80 $D8 $FC $CD $8D $0B $03 $03 $06 $36 $FE $DE $9C
.db $0C $61 $63 $60 $70 $30 $3C $1F $07 $06 $0C $0D $1D $19 $7B $F3
.db $C3 $E3 $E2 $C6 $C6 $86 $87 $87 $83 $31 $31 $37 $3E $7C $FD $CF
.db $07 $90 $10 $30 $20 $60 $C0 $80 $00 $05 $01 $03 $00 $82 $F8 $C0
.db $03 $80 $8B $C3 $FF $3E $1B $13 $36 $66 $E6 $CC $8C $0C $02 $1B
.db $02 $16 $85 $37 $3F $3F $19 $0C $03 $1C $84 $36 $76 $E7 $C3 $03
.db $10 $85 $30 $20 $60 $C0 $80 $00 $7F $00 $79 $00 $00 $7F $00 $79
.db $00 $00

; Data from 2FCA3 to 2FFFF (861 bytes)
_DATA_2FCA3:
.db $A1 $20 $21 $22 $23 $24 $25 $26 $27 $24 $28 $29 $2A $2B $2C $2D
.db $2E $2F $30 $31 $32 $33 $24 $34 $35 $36 $37 $38 $39 $3A $3B $3C
.db $3D $3E $00 $21 $00 $00

.BANK 12
.ORG $0000
Bank12:

; Data from 30000 to 33FFF (16384 bytes)
.incbin "banks\lots_DATA_30000.inc"

.BANK 13
.ORG $0000
Bank13:

; 1st entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 34000 to 34287 (648 bytes)
_DATA_34000:
.db $24 $3F $00 $25 $34 $3D $38 $2A $0C $09 $04 $00 $0B $06 $01 $10
.db $08 $FF $08 $00 $06 $FF $8E $FE $FC $FF $FF $FE $F9 $D1 $80 $00
.db $00 $F0 $E0 $C0 $80 $0C $00 $03 $FF $83 $57 $4D $02 $02 $00 $06
.db $FF $82 $BF $1F $08 $00 $83 $0F $07 $01 $05 $00 $03 $FF $83 $37
.db $0B $04 $02 $00 $06 $FF $82 $9F $06 $10 $00 $05 $FF $83 $A7 $43
.db $01 $05 $FF $02 $FE $81 $F8 $08 $00 $81 $20 $07 $00 $02 $FF $83
.db $EF $C7 $01 $03 $00 $85 $FF $FD $F8 $E0 $80 $03 $00 $87 $FF $FE
.db $FC $FC $F0 $E0 $C0 $02 $80 $07 $00 $06 $FF $82 $FE $FC $06 $FF
.db $87 $BF $17 $F8 $F0 $E0 $C0 $80 $03 $00 $81 $09 $07 $00 $04 $FF
.db $84 $FA $F2 $D4 $A4 $10 $00 $04 $FF $84 $BF $AF $9B $15 $06 $FF
.db $82 $F7 $D7 $02 $08 $06 $00 $83 $93 $05 $80 $15 $00 $85 $FF $7F
.db $1F $0B $05 $03 $00 $05 $FF $83 $BF $07 $01 $10 $00 $05 $FF $83
.db $7E $3C $18 $08 $00 $84 $FF $3F $0F $03 $04 $00 $83 $F3 $FC $41
.db $05 $FF $85 $FC $00 $E0 $1F $FA $03 $FF $85 $6F $11 $03 $08 $7F
.db $04 $FF $83 $3F $FF $1A $06 $FF $92 $EE $F0 $48 $FF $E8 $FF $FF
.db $F1 $18 $00 $C0 $86 $1F $FF $01 $FC $FF $F1 $05 $FF $86 $0E $01
.db $00 $E0 $31 $C7 $04 $FF $9A $13 $3F $5F $FF $FF $8F $00 $CF $7F
.db $F3 $BF $FF $FF $FE $20 $FE $E9 $FF $FE $FF $F1 $3F $07 $42 $3F
.db $DB $03 $FF $04 $00 $85 $1F $3F $7F $3F $1F $0B $00 $93 $F4 $F2
.db $F0 $F4 $00 $00 $80 $40 $80 $40 $40 $00 $F0 $02 $00 $00 $04 $00
.db $02 $02 $00 $02 $2F $02 $4F $89 $0F $00 $80 $00 $F8 $FC $FE $FC
.db $F8 $03 $00 $85 $04 $02 $04 $00 $03 $03 $00 $90 $20 $00 $00 $80
.db $40 $40 $00 $02 $01 $00 $01 $04 $00 $00 $02 $40 $02 $00 $02 $40
.db $0C $00 $81 $10 $03 $00 $81 $20 $06 $00 $8C $08 $00 $00 $02 $00
.db $42 $00 $48 $10 $00 $40 $10 $08 $00 $83 $02 $00 $01 $03 $00 $81
.db $11 $03 $00 $93 $20 $40 $80 $42 $04 $80 $04 $06 $00 $01 $02 $00
.db $00 $03 $88 $08 $10 $20 $60 $02 $80 $03 $00 $82 $10 $80 $04 $00
.db $88 $05 $01 $02 $02 $00 $05 $02 $0A $07 $00 $8C $80 $00 $02 $04
.db $04 $02 $01 $05 $0A $80 $00 $80 $04 $00 $84 $80 $02 $00 $02 $02
.db $00 $02 $02 $09 $00 $88 $01 $00 $00 $01 $00 $01 $00 $01 $08 $00
.db $82 $10 $04 $08 $00 $81 $01 $05 $00 $87 $01 $00 $00 $81 $00 $00
.db $21 $03 $00 $81 $80 $04 $00 $8F $01 $02 $0A $4E $30 $09 $01 $04
.db $02 $02 $00 $04 $08 $08 $00 $02 $20 $02 $00 $86 $04 $08 $20 $40
.db $02 $30 $06 $00 $83 $40 $00 $C0 $0C $00 $81 $14 $08 $00 $85 $80
.db $20 $18 $04 $01 $05 $00 $8B $05 $01 $00 $40 $02 $01 $01 $47 $20
.db $40 $00 $02 $80 $03 $00 $A1 $04 $20 $00 $42 $80 $14 $02 $09 $00
.db $00 $06 $00 $00 $08 $00 $00 $04 $01 $04 $02 $00 $04 $00 $02 $20
.db $40 $C0 $80 $40 $40 $00 $80 $01 $05 $00 $81 $01 $02 $00 $03 $80
.db $84 $00 $40 $00 $A0 $03 $00 $83 $02 $04 $05 $02 $08 $02 $00 $92
.db $44 $C4 $98 $AE $AA $A6 $16 $11 $35 $0F $6F $6F $2D $6D $DC $4D
.db $8F $DB $04 $DD $A6 $02 $04 $01

; 3rd entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 34288 to 34577 (752 bytes)
_DATA_34288:
.db $08 $28 $36 $31 $15 $00 $00 $44 $C4 $98 $AE $AA $A6 $2A $6A $32
.db $31 $31 $15 $5B $7B $E0 $90 $96 $16 $4C $CE $6E $B0 $67 $67 $2F
.db $7D $6D $6F $02 $6D $05 $00 $02 $01 $85 $0D $00 $30 $79 $FC $04
.db $FE $82 $0E $1E $04 $1F $92 $07 $00 $FE $FD $7B $87 $E7 $F7 $F3
.db $60 $30 $78 $FC $E0 $1F $7E $FD $FB $06 $00 $91 $C0 $E0 $FB $E5
.db $DE $DF $BF $BF $1F $1E $F8 $F8 $7C $BC $D8 $C0 $80 $03 $00 $90
.db $03 $07 $0F $1F $07 $3A $00 $00 $80 $C0 $A0 $70 $70 $F8 $7C $7E
.db $04 $7F $92 $3E $0C $F0 $EC $5E $3E $3E $7E $F8 $70 $00 $00 $02
.db $25 $D8 $00 $01 $06 $03 $00 $86 $89 $76 $00 $00 $81 $40 $03 $00
.db $9B $20 $D0 $01 $00 $60 $00 $08 $64 $03 $00 $00 $80 $60 $00 $02
.db $05 $18 $00 $80 $00 $18 $62 $00 $80 $08 $00 $C1 $03 $00 $86 $10
.db $69 $86 $00 $20 $98 $03 $00 $BA $92 $6D $00 $10 $A8 $00 $44 $1A
.db $01 $08 $00 $08 $81 $06 $00 $08 $81 $00 $04 $10 $80 $40 $00 $00
.db $81 $08 $26 $80 $00 $00 $22 $4D $80 $08 $06 $C0 $00 $55 $AA $55
.db $FF $DD $77 $DD $77 $50 $A8 $54 $FE $DD $77 $DD $77 $AA $55 $AA
.db $55 $AA $0B $00 $88 $05 $2A $55 $7F $DD $77 $DD $77 $03 $00 $95
.db $05 $4E $22 $12 $44 $00 $12 $32 $AC $22 $49 $18 $01 $00 $10 $37
.db $14 $2A $D2 $92 $44 $03 $00 $85 $A0 $08 $58 $1A $01 $08 $00 $90
.db $01 $10 $37 $14 $2A $D2 $92 $44 $40 $12 $32 $AC $22 $49 $18 $01
.db $00 $08 $FF $08 $00 $04 $FF $95 $FE $FC $F9 $F3 $FF $FC $F1 $C6
.db $2E $7B $91 $0A $ED $D8 $B0 $40 $C0 $40 $00 $00 $02 $07 $00 $88
.db $3F $0F $03 $A8 $B2 $6D $47 $23 $04 $FF $85 $7F $3F $5F $EF $20
.db $07 $00 $85 $73 $98 $0E $03 $01 $03 $00 $02 $FF $86 $07 $C9 $74
.db $3B $27 $05 $04 $FF $84 $7F $1F $66 $D9 $08 $00 $81 $57 $07 $00
.db $03 $FF $85 $CF $87 $5B $BD $D2 $04 $FF $85 $FE $FD $F1 $06 $09
.db $07 $00 $83 $D8 $B0 $20 $05 $00 $99 $E7 $C3 $91 $38 $EE $A3 $00
.db $00 $FC $F2 $C7 $1D $71 $C0 $80 $00 $FE $FD $FB $F2 $EE $DA $B0
.db $68 $40 $02 $80 $05 $00 $05 $FF $83 $FE $FD $FB $04 $FF $91 $3F
.db $0F $47 $E8 $F6 $EC $D8 $A8 $40 $C0 $80 $00 $F6 $AF $44 $40 $04
.db $03 $00 $8E $FE $FC $F8 $F0 $E5 $CD $AB $5B $FE $F4 $64 $49 $08
.db $20 $0A $00 $88 $7F $3F $1F $0F $47 $53 $65 $EA $04 $FF $94 $E7
.db $C3 $89 $28 $F7 $F7 $5D $4D $0A $06 $22 $02 $6C $FA $7F $D9 $90
.db $00 $50 $40 $10 $00 $88 $3F $8F $E3 $74 $AA $95 $11 $00 $04 $FF
.db $85 $1F $43 $F9 $DE $87 $02 $01 $05 $00 $82 $1F $02 $06 $00 $04
.db $FF $85 $7E $BD $5A $26 $18 $07 $00 $85 $3F $CF $73 $1C $23 $03
.db $00 $60 $FF $06 $00 $84 $80 $40 $20 $1F $07 $00 $9F $01 $05 $09
.db $08 $0D $0E $08 $00 $80 $40 $20 $60 $20 $A0 $A0 $0E $FD $02 $04
.db $02 $06 $05 $06 $70 $50 $D0 $30 $B0 $70 $7F $20 $03 $00 $FD $01
.db $02 $04 $F8 $00 $04 $01 $04 $02 $04 $04 $06 $04 $60 $40 $A0 $00
.db $20 $20 $A0 $60 $00 $06 $04 $04 $00 $06 $05 $04 $A0 $20 $60 $20
.db $A0 $60 $60 $A0 $01 $0A $08 $15 $03 $0C $20 $28 $82 $4C $32 $40
.db $2C $92 $B5 $28 $15 $26 $EC $14 $45 $22 $1C $61 $69 $A8 $07 $20
.db $48 $CC $03 $28 $00 $01 $04 $07 $08 $02 $01 $02 $89 $12 $A4 $A1
.db $AF $19 $E8 $16 $50 $D5 $4A $B2 $2A $21 $52 $54 $22 $88 $7C $04
.db $45 $32 $4A $84 $40 $96 $89 $D0 $9E $71 $48 $E0 $80 $40 $48 $66
.db $00 $C0 $20 $10 $00 $06 $05 $04 $0E $0A $0D $01 $06 $80 $02 $00
.db $02 $0D $89 $09 $1A $14 $16 $12 $15 $00 $80 $00 $03 $80 $DA $00

; 5th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 34578 to 346C7 (336 bytes)
_DATA_34578:
.db $40 $00 $72 $10 $0A $16 $61 $91 $02 $A0 $40 $40 $48 $92 $94 $38
.db $C4 $00 $49 $29 $58 $87 $0A $30 $4C $02 $29 $10 $90 $38 $C4 $A2
.db $90 $04 $22 $40 $19 $06 $09 $13 $00 $04 $24 $12 $0C $10 $21 $12
.db $12 $82 $B5 $09 $08 $96 $62 $16 $AB $E8 $81 $2E $B1 $C4 $9C $83
.db $62 $59 $51 $91 $4B $92 $4E $09 $25 $81 $A5 $12 $75 $14 $2A $1F
.db $51 $80 $40 $23 $00 $1E $20 $41 $88 $06 $00 $D2 $80 $20 $22 $9C
.db $44 $02 $81 $C0 $30 $00 $04 $39 $0A $04 $25 $0A $29 $42 $58 $25
.db $B0 $43 $48 $46 $08 $C9 $80 $8A $26 $29 $5A $04 $06 $02 $98 $A4
.db $43 $1A $A4 $56 $D4 $20 $10 $AA $6C $53 $60 $F8 $C4 $C2 $61 $05
.db $35 $91 $6D $6B $19 $12 $A4 $31 $48 $85 $20 $56 $99 $80 $33 $4A
.db $8A $AD $17 $19 $05 $05 $90 $A2 $2C $72 $B0 $20 $60 $40 $02 $02
.db $02 $03 $03 $02 $82 $00 $C0 $03 $40 $83 $C0 $A0 $E0 $04 $00 $99
.db $03 $04 $01 $00 $08 $00 $00 $44 $84 $08 $0C $88 $84 $10 $00 $34
.db $05 $45 $45 $04 $44 $18 $8A $AA $92 $04 $94 $A6 $03 $04 $01 $08
.db $28 $90 $30 $14 $00 $02 $44 $84 $08 $0C $88 $84 $82 $42 $22 $21
.db $A1 $06 $02 $51 $40 $11 $92 $12 $08 $8C $0C $38 $45 $45 $05 $54
.db $44 $46 $02 $44 $03 $00 $02 $01 $85 $07 $0F $1F $00 $79 $06 $FF
.db $81 $1F $05 $3F $82 $1F $07 $08 $FF $82 $78 $FE $06 $FF $03 $00
.db $85 $80 $C0 $C0 $E0 $F8 $08 $FF $02 $FC $02 $FE $02 $FC $92 $F8
.db $E0 $00 $00 $07 $0F $1F $3F $3F $7F $00 $00 $C0 $E0 $F0 $F8 $F8
.db $FC $06 $FF $82 $7F $3F $02 $FE $04 $FF $82 $FE $F8 $03 $00 $85

; 7th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 346C8 to 34987 (704 bytes)
_DATA_346C8:
.db $02 $25 $D8 $00 $01 $04 $00 $A4 $89 $76 $04 $18 $1E $60 $08 $86
.db $00 $23 $D8 $02 $81 $76 $00 $08 $F4 $23 $18 $40 $0C $E0 $00 $02
.db $24 $00 $0C $C0 $06 $18 $02 $64 $00 $00 $04 $C1 $03 $00 $85 $10
.db $69 $86 $00 $20 $04 $00 $A3 $92 $6D $00 $10 $9D $00 $44 $7A $01
.db $B0 $04 $10 $E8 $06 $30 $00 $C3 $00 $00 $33 $81 $74 $00 $00 $C1
.db $09 $66 $C0 $80 $00 $22 $5D $80 $18 $07 $05 $00 $84 $22 $88 $22
.db $88 $04 $00 $89 $22 $88 $22 $88 $55 $AA $55 $AA $55 $0B $FF $04
.db $00 $84 $22 $88 $22 $88 $03 $00 $95 $02 $19 $1D $6F $B3 $00 $00
.db $44 $53 $99 $3E $C4 $2A $00 $00 $88 $CB $5D $2D $67 $B3 $04 $00
.db $84 $A0 $2C $C4 $2A $08 $FF $90 $0C $05 $88 $CB $5D $2D $67 $B3
.db $A8 $48 $4C $53 $99 $3E $C4 $2A $00 $08 $FF $08 $00 $12 $FF $8C
.db $FD $F0 $E4 $D0 $C0 $40 $FF $B7 $62 $22 $20 $08 $02 $00 $11 $FF
.db $84 $77 $25 $00 $08 $03 $00 $03 $FF $83 $9F $07 $81 $02 $00 $06
.db $FF $82 $7F $3F $08 $FF $82 $2D $02 $06 $00 $02 $FF $82 $26 $02
.db $04 $00 $11 $FF $83 $5F $0A $08 $04 $00 $88 $FF $FD $F8 $70 $20
.db $00 $20 $00 $06 $FF $82 $F7 $A2 $05 $FF $83 $F3 $D0 $82 $06 $FF
.db $87 $FE $FC $F8 $F8 $E8 $C0 $80 $03 $00 $13 $FF $85 $FC $F8 $E8
.db $D0 $C0 $04 $FF $84 $4E $54 $01 $04 $0D $FF $85 $7F $3B $32 $10
.db $20 $02 $02 $04 $00 $16 $FF $82 $7F $6F $07 $FF $84 $F9 $27 $02
.db $22 $05 $00 $84 $E1 $C0 $00 $40 $04 $00 $07 $FF $81 $B3 $09 $FF
.db $8D $97 $83 $03 $03 $01 $00 $00 $7F $3F $1B $0A $00 $01 $02 $00
.db $08 $FF $84 $7F $3E $24 $04 $04 $00 $04 $FF $84 $7F $37 $01 $00
.db $60 $FF $03 $00 $87 $1F $3F $7F $FF $7F $3F $1F $07 $00 $82 $01
.db $07 $05 $FF $83 $00 $80 $C0 $05 $E0 $02 $FF $06 $07 $07 $FF $89
.db $E0 $F8 $FC $FE $FF $FE $FC $F8 $00 $08 $07 $08 $E0 $08 $07 $08
.db $E0 $D0 $01 $0A $08 $15 $03 $0C $20 $28 $92 $5C $32 $60 $2C $B2
.db $F5 $68 $15 $26 $EC $14 $4D $26 $1E $63 $69 $EE $4F $68 $58 $DC
.db $53 $78 $00 $01 $04 $07 $08 $02 $01 $02 $8B $13 $A5 $A1 $EF $39
.db $F9 $1F $70 $F5 $EA $F2 $EB $E7 $D6 $DC $2F $8F $7F $07 $47 $33
.db $4B $87 $D8 $9E $B9 $F0 $FE $F1 $C8 $E0 $80 $40 $78 $E6 $00 $C0
.db $20 $10 $04 $07 $04 $0F $08 $80 $03 $0F $05 $1F $07 $80 $D9 $C0
.db $02 $72 $12 $0A $16 $63 $93 $03 $A0 $40 $40 $48 $92 $94 $38 $C4
.db $01 $49 $29 $59 $87 $0B $31 $4D $02 $29 $10 $90 $38 $C4 $A2 $90
.db $1C $26 $41 $19 $06 $09 $13 $00 $04 $24 $13 $0C $10 $21 $12 $12
.db $83 $B5 $09 $89 $D7 $63 $37 $BB $E8 $81 $AE $B1 $C4 $9C $83 $63
.db $5B $5B $DF $7F $9F $4F $0F $27 $83 $A7 $16 $7D $1C $3A $3F $71
.db $80 $40 $27 $08 $3E $60 $C3 $B8 $06 $00 $D2 $C0 $20 $E2 $9C $44
.db $02 $81 $C0 $30 $00 $04 $39 $0A $04 $25 $1E $29 $42 $58 $25 $B0
.db $43 $48 $C6 $C8 $F9 $9E $8E $27 $29 $5A $04 $06 $02 $9F $A7 $43
.db $5B $E7 $57 $D7 $67 $70 $EA $EC $D3 $E0 $F8 $C4 $C2 $67 $27 $B7
.db $F3 $FF $7F $1F $1F $A4 $33 $4E $8D $20 $5E $99 $A0 $3F $4F $8F
.db $AF $17 $1F $07 $07 $B0 $E2 $EC $F2 $F0 $E0 $E0 $C0 $07 $03 $81
.db $01 $05 $C0 $03 $E0 $52 $00 $83 $30 $78 $7C $03 $FC $8E $00 $04
.db $0E $0F $0F $07 $00 $00 $78 $31 $01 $03 $83 $C1 $03 $00 $87 $70

; 9th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 34988 to 34C27 (672 bytes)
_DATA_34988:
.db $60 $00 $18 $3C $7D $F3 $07 $00 $8D $C0 $E3 $C0 $8E $9F $1F $1F
.db $0E $00 $E0 $F0 $38 $08 $07 $00 $85 $03 $07 $06 $02 $18 $03 $00
.db $85 $80 $00 $60 $60 $F0 $02 $3C $02 $3E $8B $1E $1C $00 $00 $E0
.db $40 $1C $1C $3C $78 $70 $03 $00 $82 $02 $27 $04 $FF $03 $00 $81
.db $89 $24 $FF $02 $00 $82 $10 $79 $04 $FF $03 $00 $81 $92 $2C $FF
.db $82 $F0 $FC $02 $FE $0A $FF $8C $77 $DD $77 $DD $AA $55 $AA $55
.db $AA $55 $0F $3F $02 $7F $04 $FF $20 $00 $8A $AA $55 $AA $55 $AA
.db $55 $AA $55 $0D $05 $06 $00 $83 $E8 $48 $08 $05 $00 $00 $08 $FF
.db $08 $00 $04 $FF $88 $FE $FC $F8 $F0 $FF $FC $F0 $C0 $04 $00 $83
.db $E0 $C0 $80 $0D $00 $83 $3F $0F $03 $05 $00 $04 $FF $84 $7F $3F
.db $1F $0F $08 $00 $81 $03 $07 $00 $02 $FF $82 $07 $01 $04 $00 $04
.db $FF $83 $7F $1F $06 $11 $00 $03 $FF $85 $CF $87 $03 $01 $00 $04
.db $FF $83 $FE $FC $F0 $11 $00 $83 $E7 $C3 $81 $05 $00 $83 $FC $F0
.db $C0 $05 $00 $87 $FE $FC $F8 $F0 $E0 $C0 $80 $09 $00 $05 $FF $83
.db $FE $FC $F8 $04 $FF $88 $3F $0F $07 $00 $F0 $E0 $C0 $80 $0C $00
.db $87 $FE $FC $F8 $F0 $E0 $C0 $80 $11 $00 $88 $7F $3F $1F $0F $07
.db $03 $01 $00 $04 $FF $83 $E7 $C3 $81 $21 $00 $83 $3F $0F $03 $05
.db $00 $04 $FF $83 $1F $03 $01 $11 $00 $04 $FF $83 $7E $3C $18 $09
.db $00 $83 $3F $0F $03 $05 $00 $83 $F3 $FC $41 $05 $FF $85 $FC $00
.db $E0 $1F $FA $03 $FF $85 $6F $11 $03 $08 $7F $04 $FF $83 $3F $FF
.db $1A $06 $FF $92 $EE $F0 $48 $FF $E8 $FF $FF $F1 $18 $00 $C0 $86
.db $1F $FF $01 $FC $FF $F1 $05 $FF $86 $0E $01 $00 $E0 $31 $C7 $04
.db $FF $9A $13 $3F $5F $FF $FF $8F $00 $CF $7F $F3 $BF $FF $FF $FE
.db $20 $FE $E9 $FF $FE $FF $F1 $3F $07 $42 $3F $DB $03 $FF $03 $00
.db $87 $1F $3F $7F $FF $7F $3F $1F $07 $00 $82 $01 $07 $05 $FF $83
.db $00 $80 $C0 $05 $E0 $02 $FF $06 $07 $07 $FF $89 $E0 $F8 $FC $FE
.db $FF $FE $FC $F8 $00 $08 $07 $08 $E0 $08 $07 $08 $E0 $D0 $01 $0A
.db $08 $15 $03 $0C $20 $28 $92 $5C $32 $60 $2C $B2 $F5 $68 $15 $26
.db $EC $14 $4D $26 $1E $63 $69 $EE $4F $68 $58 $DC $53 $78 $00 $01
.db $04 $07 $08 $02 $01 $02 $8B $13 $A5 $A1 $EF $39 $F9 $1F $70 $F5
.db $EA $F2 $EB $E7 $D6 $DC $2F $8F $7F $07 $47 $33 $4B $87 $D8 $9E
.db $B9 $F0 $FE $F1 $C8 $E0 $80 $40 $78 $E6 $00 $C0 $20 $10 $04 $07
.db $04 $0F $08 $80 $03 $0F $05 $1F $07 $80 $D9 $C0 $02 $72 $12 $0A
.db $16 $63 $93 $03 $A0 $40 $40 $48 $92 $94 $38 $C4 $01 $49 $29 $59
.db $87 $0B $31 $4D $02 $29 $10 $90 $38 $C4 $A2 $90 $1C $26 $41 $19
.db $06 $09 $13 $00 $04 $24 $13 $0C $10 $21 $12 $12 $83 $B5 $09 $89
.db $D7 $63 $37 $BB $E8 $81 $AE $B1 $C4 $9C $83 $63 $5B $5B $DF $7F
.db $9F $4F $0F $27 $83 $A7 $16 $7D $1C $3A $3F $71 $80 $40 $27 $08
.db $3E $60 $C3 $B8 $06 $00 $D2 $C0 $20 $E2 $9C $44 $02 $81 $C0 $30
.db $00 $04 $39 $0A $04 $25 $1E $29 $42 $58 $25 $B0 $43 $48 $C6 $C8
.db $F9 $9E $8E $27 $29 $5A $04 $06 $02 $9F $A7 $43 $5B $E7 $57 $D7
.db $67 $70 $EA $EC $D3 $E0 $F8 $C4 $C2 $67 $27 $B7 $F3 $FF $7F $1F

; 11th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 34C28 to 34CDC (181 bytes)
_DATA_34C28:
.db $1F $A4 $33 $4E $8D $20 $5E $99 $A0 $3F $4F $8F $AF $17 $1F $07
.db $07 $B0 $E2 $EC $F2 $F0 $E0 $E0 $C0 $07 $03 $81 $01 $05 $C0 $03
.db $E0 $02 $00 $9A $01 $03 $16 $0D $0A $0C $11 $22 $6C $D5 $9A $AE
.db $BA $AE $16 $35 $BD $4F $7F $EF $6D $6D $DE $CF $EF $FB $04 $DD
.db $A6 $13 $0E $0D $8A $6C $F6 $B9 $5D $40 $23 $6D $D6 $9A $AE $BA
.db $AE $AB $6F $3A $B9 $F3 $57 $5B $7F $EA $B5 $D6 $56 $5C $EE $6F
.db $FA $6F $EF $6F $7D $6D $6F $02 $6D $7F $00 $41 $00 $08 $FF $82
.db $F0 $FC $02 $FE $0A $FF $8C $77 $DD $77 $DD $AA $55 $AA $55 $AA
.db $55 $0F $3F $02 $7F $04 $FF $84 $00 $02 $0A $2F $03 $7F $84 $FF
.db $12 $B6 $F7 $05 $FF $82 $92 $BA $06 $FF $92 $00 $80 $A8 $E8 $FA
.db $FE $FE $FF $AA $55 $AA $55 $AA $55 $AA $55 $9F $BF $06 $FF $82
.db $FA $FE $06 $FF $00

; 4th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 34CDD to 34D4B (111 bytes)
_DATA_34CDD:
.db $00 $3F $00 $19 $14 $0A $16 $2B $0C $09 $04 $00 $1B $06 $01 $30
.db $0C $00 $84 $1F $3F $7F $3F $04 $00 $85 $F4 $F2 $F0 $F4 $1F $07
.db $00 $98 $F0 $02 $00 $00 $04 $00 $02 $00 $00 $04 $02 $04 $00 $03
.db $00 $00 $02 $01 $00 $01 $04 $00 $00 $02 $04 $00 $84 $01 $03 $07
.db $0F $03 $00 $04 $F0 $8B $E0 $1F $3F $BF $5E $9C $58 $50 $00 $C0
.db $80 $07 $00 $02 $2F $02 $4F $89 $0F $00 $80 $00 $F8 $FC $FE $FC
.db $F8 $03 $00 $88 $20 $00 $00 $80 $40 $40 $00 $40 $02 $00 $02

; 14th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 34D4C to 34D7F (52 bytes)
_DATA_34D4C:
.db $40 $05 $00 $E9 $80 $40 $80 $40 $40 $00 $01 $04 $01 $04 $01 $05
.db $02 $00 $14 $48 $05 $40 $42 $48 $A0 $A2 $0A $02 $08 $04 $05 $08
.db $18 $24 $89 $8A $90 $80 $24 $11 $08 $16 $20 $49 $A6 $00 $20 $02
.db $25 $40 $11 $91

; 13th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 34D80 to 34F7F (512 bytes)
_DATA_34D80:
.db $4A $80 $00 $09 $05 $40 $02 $00 $04 $00 $11 $40 $20 $09 $01 $03
.db $80 $22 $40 $09 $90 $00 $04 $90 $20 $41 $02 $08 $02 $02 $89 $25
.db $40 $80 $90 $23 $A1 $5B $01 $20 $10 $C4 $00 $10 $42 $00 $20 $08
.db $02 $23 $02 $01 $09 $0C $00 $08 $20 $06 $00 $AF $80 $21 $04 $00
.db $00 $05 $00 $00 $02 $28 $01 $00 $48 $20 $01 $01 $40 $10 $C5 $8A
.db $28 $14 $21 $10 $88 $15 $08 $80 $0A $84 $05 $80 $44 $00 $50 $80
.db $00 $40 $00 $0B $10 $04 $04 $03 $04 $13 $0B $07 $00 $81 $16 $03
.db $00 $85 $01 $00 $00 $02 $40 $04 $00 $88 $60 $00 $88 $20 $12 $32
.db $44 $09 $04 $00 $85 $6C $12 $49 $12 $0A $03 $00 $9D $09 $0A $06
.db $0A $0C $05 $13 $0B $00 $10 $03 $44 $84 $A8 $06 $01 $09 $02 $46
.db $92 $00 $91 $23 $43 $6C $12 $49 $92 $0A $04 $00 $9F $11 $44 $11
.db $AA $55 $AA $55 $00 $11 $44 $11 $AA $55 $AA $55 $FF $EE $BB $EE
.db $55 $AA $55 $AA $00 $10 $44 $10 $AA $55 $AA $55 $7F $00 $64 $00
.db $92 $01 $02 $31 $08 $12 $04 $01 $01 $20 $40 $00 $11 $00 $40 $02
.db $01 $80 $29 $03 $00 $83 $81 $44 $24 $03 $00 $87 $25 $40 $00 $02
.db $01 $04 $01 $03 $00 $94 $10 $0C $40 $30 $01 $09 $06 $02 $40 $11
.db $A8 $10 $01 $50 $21 $A0 $02 $0C $10 $60 $02 $00 $02 $40 $93 $24
.db $CE $06 $15 $21 $10 $42 $60 $02 $81 $08 $01 $01 $00 $92 $80 $00
.db $00 $18 $06 $00 $87 $11 $88 $20 $0B $02 $00 $18 $08 $00 $C1 $10
.db $02 $99 $28 $01 $80 $02 $40 $00 $48 $92 $01 $0A $62 $C1 $10 $00
.db $80 $03 $28 $84 $50 $13 $80 $02 $C0 $00 $08 $24 $00 $10 $0C $36
.db $06 $08 $05 $30 $09 $22 $40 $43 $00 $02 $01 $01 $52 $A0 $81 $02
.db $02 $68 $46 $B0 $43 $44 $61 $91 $04 $40 $A0 $00 $20 $C2 $02 $08
.db $08 $00 $88 $4C $04 $32 $50 $83 $20 $03 $02 $07 $00 $A8 $94 $34
.db $98 $40 $A4 $10 $02 $00 $0A $84 $80 $2A $A1 $10 $00 $46 $00 $04
.db $0D $14 $02 $04 $06 $08 $40 $00 $10 $20 $50 $90 $20 $10 $05 $00
.db $04 $02 $04 $04 $08 $0A $02 $60 $03 $00 $87 $30 $10 $50 $00 $04
.db $06 $08 $02 $00 $02 $04 $92 $00 $40 $00 $20 $00 $80 $20 $40 $00
.db $00 $04 $02 $04 $04 $08 $0A $C0 $60 $03 $00 $A8 $30 $10 $50 $00
.db $04 $06 $02 $00 $08 $08 $00 $C0 $00 $20 $20 $60 $00 $50 $20 $08
.db $0E $08 $04 $00 $01 $06 $11 $50 $30 $50 $00 $48 $00 $48 $08 $00
.db $02 $01 $04 $01 $03 $00 $8B $10 $0C $40 $30 $01 $09 $06 $02 $00

; 15th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 34F80 to 3511F (416 bytes)
_DATA_34F80:
.db $00 $18 $06 $00 $87 $11 $88 $20 $0B $02 $00 $18 $08 $00 $A9 $10
.db $02 $99 $28 $01 $80 $02 $40 $00 $48 $92 $01 $0A $62 $C1 $10 $00
.db $80 $03 $28 $84 $50 $13 $80 $02 $C0 $00 $08 $24 $00 $10 $0C $36
.db $06 $08 $05 $30 $09 $22 $40 $08 $07 $00 $86 $81 $00 $54 $80 $02
.db $10 $03 $00 $87 $10 $84 $02 $00 $91 $2A $42 $03 $00 $8D $B0 $00
.db $00 $10 $20 $8D $00 $88 $04 $80 $40 $84 $20 $08 $00 $02 $22 $81
.db $24 $03 $00 $82 $A4 $02 $03 $00 $AD $02 $01 $40 $00 $08 $08 $01
.db $C0 $14 $21 $0A $C8 $01 $44 $12 $49 $80 $50 $46 $83 $08 $40 $03
.db $00 $10 $24 $00 $08 $30 $00 $64 $00 $8C $41 $10 $60 $81 $10 $60
.db $80 $20 $58 $80 $80 $08 $09 $00 $87 $10 $84 $02 $00 $91 $2A $42
.db $03 $00 $8D $B0 $00 $00 $10 $20 $8D $00 $88 $04 $80 $40 $84 $20
.db $08 $00 $02 $22 $81 $24 $03 $00 $82 $A4 $02 $03 $00 $A5 $02 $01
.db $40 $00 $08 $08 $01 $C0 $14 $21 $0A $C8 $01 $44 $12 $49 $80 $50
.db $46 $83 $08 $6C $60 $10 $A0 $0C $90 $44 $02 $10 $60 $80 $20 $58
.db $80 $80 $08 $00 $0E $00 $8C $80 $40 $00 $01 $05 $09 $08 $0D $0E
.db $08 $20 $1F $06 $00 $98 $0E $FD $02 $04 $02 $06 $05 $06 $04 $01
.db $04 $02 $04 $04 $06 $04 $00 $06 $04 $04 $00 $06 $05 $04 $0A $00
.db $05 $08 $8C $10 $00 $80 $40 $21 $62 $24 $A8 $B0 $20 $40 $80 $05
.db $00 $88 $70 $50 $D0 $30 $B0 $70 $7F $20 $03 $00 $C5 $01 $02 $04
.db $F8 $00 $60 $40 $A0 $00 $20 $20 $A0 $60 $A0 $20 $60 $20 $A0 $60
.db $60 $A0 $00 $80 $40 $20 $60 $20 $A0 $B0 $02 $00 $0E $1B $1E $1A
.db $0D $0F $80 $00 $E2 $BF $99 $93 $13 $04 $15 $1D $17 $1B $1A $36
.db $25 $5B $54 $20 $04 $54 $90 $A4 $A4 $68 $1C $00 $18 $FF $D7 $55
.db $0A $0D $02 $04 $BB $10 $15 $4F $42 $E2 $BB $01 $00 $10 $0C $0C
.db $23 $4C $20 $32 $A4 $44 $C9 $1A $D0 $45 $19 $22 $6B $40 $98 $25
.db $43 $09 $0C $72 $92 $9F $76 $48 $DC $16 $A4 $34 $46 $CC $0B $10

; 17th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 35120 to 351AF (144 bytes)
_DATA_35120:
.db $23 $0D $38 $4D $35 $9C $4C $35 $1E $F6 $33 $14 $23 $4C $00 $01
.db $03 $00 $C0 $CA $3C $54 $8A $02 $05 $0A $1F $42 $54 $84 $88 $AB
.db $02 $9A $D4 $C6 $AD $A6 $2A $75 $D5 $CB $8E $EF $70 $E0 $C7 $44
.db $40 $4A $F2 $67 $09 $54 $20 $40 $40 $A0 $F0 $00 $27 $3B $13 $1C
.db $3B $2C $14 $00 $9F $FF $BF $3B $D1 $AC $68 $00 $00 $D8 $FE $FF
.db $73 $8C $BF $04 $00 $89 $80 $E0 $70 $80 $2D $80 $88 $F6 $03 $03
.db $00 $A6 $93 $21 $80 $68 $F5 $0F $00 $00 $16 $35 $39 $15 $13 $3A
.db $2C $14 $00 $EF $94 $08 $20 $57 $F9 $0E $16 $FD $B9 $0D $4F $0E
.db $DC $BC $13 $61 $80 $68 $75 $0F $13 $00 $87 $11 $44 $11 $AA $55

; 19th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 351B0 to 35831 (1666 bytes)
_DATA_351B0:
.incbin "banks\lots_DATA_351B0.inc"

; 16th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 35832 to 35C41 (1040 bytes)
_DATA_35832:
.incbin "banks\lots_DATA_35832.inc"

; 6th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 35C42 to 35DC9 (392 bytes)
_DATA_35C42:
.db $10 $3F $00 $34 $1F $10 $15 $2A $3C $38 $06 $01 $0B $3C $38 $34
.db $DF $EE $B7 $8F $C9 $A1 $6C $3D $FD $CF $B3 $71 $C6 $1D $A5 $FF
.db $9F $6F $37 $8F $CB $22 $CC $E8 $57 $E7 $BF $F9 $C6 $1D $A5 $3E
.db $43 $1B $36 $6F $B7 $5F $99 $E7 $37 $C1 $DB $BD $F2 $6A $DD $9E
.db $ED $82 $B4 $FF $AE $FF $FD $FF $BF $A9 $E7 $F6 $AF $DF $DF $37
.db $FB $F2 $FF $7B $5F $14 $55 $1E $00 $0D $39 $DF $FB $E3 $6F $B6
.db $BF $C0 $1A $6C $10 $AE $81 $0E $01 $48 $08 $1F $39 $FF $60 $AD
.db $03 $00 $85 $A0 $4B $00 $30 $E3 $03 $00 $81 $35 $03 $00 $89 $05
.db $40 $00 $31 $08 $00 $04 $00 $40 $03 $00 $F8 $50 $00 $00 $05 $00
.db $00 $3B $E7 $88 $C0 $96 $C3 $F6 $5D $B0 $C7 $D0 $6C $BE $1B $7C
.db $3F $7B $E3 $C0 $D6 $97 $4E $F5 $F2 $70 $D7 $F0 $3C $0E $31 $FC
.db $38 $95 $FC $BC $FD $EA $EA $11 $4D $B5 $5F $FC $84 $E9 $90 $5C
.db $06 $85 $7F $F0 $F7 $97 $BF $9F $EB $B3 $D3 $FE $C9 $7F $40 $FF
.db $EF $F8 $CF $D1 $EE $EF $89 $D4 $F6 $53 $FF $EF $1F $E1 $BF $9E
.db $D3 $BD $00 $FA $7E $80 $3D $40 $00 $FC $52 $00 $EC $B7 $04 $A8
.db $00 $00 $F2 $BF $6A $00 $80 $E5 $00 $00 $BC $48 $40 $20 $00 $0D
.db $00 $00 $50 $07 $00 $81 $10 $03 $00 $81 $44 $0A $00 $85 $08 $0A
.db $0F $02 $00 $02 $08 $02 $09 $90 $02 $03 $05 $06 $0A $0A $08 $0E
.db $0D $05 $06 $04 $0D $0A $0A $0C $02 $04 $02 $0A $C0 $02 $09 $0C
.db $05 $09 $0B $04 $05 $0A $0A $06 $A0 $78 $CC $19 $72 $13 $84 $E5
.db $30 $30 $50 $40 $00 $1C $3A $95 $91 $41 $48 $64 $62 $35 $32 $91
.db $80 $40 $E0 $30 $18 $04 $12 $87 $20 $10 $50 $20 $A0 $50 $50 $30
.db $C0 $4A $31 $14 $0B $05 $02 $01 $30 $90 $B0 $10 $20 $02 $50 $02
.db $20 $F6 $50 $10 $30 $50 $50 $B0 $A0 $05 $1E $33 $98 $4E $48 $A1
.db $67 $67 $58 $E2 $38 $03 $B8 $43

; 18th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 35DCA to 3649C (1747 bytes)
_DATA_35DCA:
.incbin "banks\lots_DATA_35DCA.inc"

; 8th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 3649D to 36C9A (2046 bytes)
_DATA_3649D:
.incbin "banks\lots_DATA_3649D.inc"

; 10th entry of Pointer Table from 5520 (indexed by _RAM_C118)
; Data from 36C9B to 37FFF (4965 bytes)
; TODO: There's unused free space at the end of this bin, remove it and adjust comments
_DATA_36C9B:
.incbin "banks\lots_DATA_36C9B.inc"

.BANK 14
.ORG $0000
Bank14:

; Data from 38000 to 3AABB (10940 bytes)
.incbin "banks\lots_DATA_38000.inc"

; Data from 3AABC to 3ADE0 (805 bytes)
_DATA_3AABC:
.db $04 $20 $88 $21 $22 $23 $23 $24 $23 $25 $26 $03 $27 $8D $25 $24
.db $27 $25 $26 $5A $5B $5C $5D $24 $5E $22 $21 $07 $20 $86 $28 $29
.db $2A $2B $2B $2C $07 $2B $81 $2C $03 $2B $89 $5F $60 $60 $5F $2C
.db $61 $2A $29 $28 $06 $20 $85 $2D $2E $2F $30 $31 $05 $32 $82 $33
.db $34 $04 $32 $8A $62 $63 $64 $64 $65 $32 $32 $2F $2E $2D $06 $20
.db $9A $35 $36 $31 $30 $37 $32 $32 $38 $39 $3A $3B $3C $39 $3A $66
.db $32 $67 $68 $69 $6A $6B $32 $6C $32 $57 $56 $06 $20 $9A $3D $36
.db $3E $31 $3E $32 $32 $3F $40 $41 $41 $40 $42 $47 $38 $32 $6D $6E
.db $6F $70 $65 $71 $72 $73 $36 $48 $06 $20 $82 $35 $36 $03 $32 $95
.db $43 $44 $32 $3F $40 $45 $46 $47 $66 $54 $55 $74 $75 $76 $77 $78
.db $79 $7A $7B $36 $35 $06 $20 $86 $35 $36 $32 $32 $43 $44 $05 $32
.db $02 $44 $8D $32 $58 $59 $32 $7C $7D $7E $7F $80 $81 $32 $36 $3D
.db $06 $20 $9A $48 $36 $49 $4A $4B $4C $4D $4E $4F $50 $51 $52 $53
.db $82 $83 $84 $85 $86 $87 $64 $6A $88 $89 $8A $8B $35 $06 $20 $84
.db $48 $36 $37 $3E $04 $32 $92 $54 $55 $32 $32 $37 $3E $3E $31 $32
.db $32 $65 $64 $8C $8D $8E $8F $90 $91 $06 $20 $83 $56 $57 $3E $02
.db $31 $03 $32 $86 $58 $59 $32 $32 $3E $31 $03 $32 $83 $31 $6B $6A
.db $02 $64 $02 $92 $82 $93 $56 $06 $20 $8B $35 $94 $30 $37 $32 $54
.db $32 $32 $33 $32 $34 $04 $32 $85 $37 $31 $37 $65 $70 $04 $64 $82
.db $AB $91 $06 $20 $8B $3D $36 $32 $32 $58 $59 $55 $32 $95 $96 $97
.db $03 $32 $8C $3E $AC $31 $3E $AD $6A $64 $AE $AF $64 $AB $B0 $06
.db $20 $9A $48 $36 $37 $31 $30 $55 $32 $38 $3B $98 $3C $3A $38 $32
.db $B1 $72 $B2 $B3 $B4 $6A $B5 $B6 $B6 $B7 $AB $91 $06 $20 $9A $48
.db $36 $32 $3E $31 $3E $3F $42 $47 $40 $42 $47 $3F $32 $B8 $B9 $BA
.db $BB $BC $70 $BD $BE $BE $BD $AB $91 $06 $20 $82 $48 $36 $08 $32
.db $02 $44 $8E $32 $BF $C0 $C1 $C2 $C3 $C4 $70 $C5 $C6 $C6 $C5 $93
.db $56 $06 $20 $86 $56 $57 $33 $34 $37 $30 $02 $44 $02 $32 $90 $44
.db $32 $99 $C7 $C8 $C9 $CA $CB $CC $8C $B5 $CD $CD $CE $AB $B0 $06
.db $20 $8D $35 $9A $3B $3C $39 $3A $66 $44 $43 $32 $32 $9B $9C $02
.db $A3 $03 $CF $81 $D0 $03 $64 $84 $AE $64 $AB $B0 $06 $20 $91 $9D
.db $9E $9F $40 $42 $47 $3E $3E $A0 $A1 $A2 $8E $A3 $8C $64 $64 $D1
.db $06 $64 $83 $60 $D2 $9D $06 $20 $83 $A4 $A5 $A6 $03 $2B $87 $2C
.db $2B $5F $A7 $A8 $A8 $A7 $03 $60 $81 $D3 $04 $60 $85 $D4 $60 $D5
.db $A5 $A4 $07 $20 $89 $A9 $AA $25 $26 $27 $24 $25 $5A $5B $03 $5A
.db $84 $D6 $5B $5B $24 $04 $5A $84 $24 $5B $AA $A9 $04 $20 $00 $07
.db $00 $83 $02 $00 $02 $06 $00 $81 $02 $07 $00 $82 $02 $00 $02 $02
.db $0B $00 $84 $02 $00 $02 $00 $04 $02 $85 $00 $02 $02 $00 $02 $03
.db $00 $02 $02 $81 $00 $03 $02 $1D $00 $03 $02 $1E $00 $02 $02 $14
.db $00 $81 $02 $09 $00 $82 $02 $06 $06 $00 $81 $04 $17 $00 $02 $02
.db $0A $00 $02 $02 $12 $00 $82 $06 $02 $07 $00 $81 $04 $17 $00 $81
.db $02 $06 $00 $81 $04 $11 $00 $81 $06 $1F $00 $02 $02 $03 $00 $83
.db $02 $00 $02 $18 $00 $02 $02 $0D $00 $81 $04 $11 $00 $81 $02 $04
.db $00 $81 $04 $08 $00 $81 $04 $0A $00 $81 $02 $06 $00 $84 $02 $00
.db $00 $02 $09 $00 $81 $04 $0B $00 $81 $02 $06 $00 $81 $02 $02 $00
.db $02 $02 $08 $00 $81 $04 $12 $00 $81 $02 $02 $00 $02 $02 $82 $00
.db $02 $10 $00 $81 $02 $08 $00 $86 $02 $04 $00 $02 $00 $04 $15 $00
.db $81 $02 $07 $00 $83 $06 $00 $04 $12 $00 $83 $02 $00 $02 $09 $00
.db $83 $06 $00 $02 $09 $00 $86 $04 $06 $04 $06 $06 $04 $04 $00 $03
.db $04 $81 $00 $04 $04 $83 $00 $04 $00 $02 $02 $09 $00 $02 $04 $03
.db $06 $81 $04 $03 $06 $84 $04 $00 $06 $04 $03 $06 $02 $04 $02 $06
.db $02 $02 $04 $00 $00

; Data from 3ADE1 to 3ADF0 (16 bytes)
_DATA_3ADE1:
.db $00 $00 $3F $2F $0B $0A $01 $06 $02 $38 $24 $2A $29 $05 $08 $03

; Data from 3ADF1 to 3BFFF (4623 bytes)
_DATA_3ADF1:
.incbin "banks\lots_DATA_3ADF1.inc"

.BANK 15
.ORG $0000
Bank15:

; Data from 3C000 to 3C001 (2 bytes)
.db $21 $01

; Pointer Table from 3C002 to 3C00D (6 entries, indexed by unknown)
.dw $0121 $0121 $0121 $0120 $0120 $0120

; Pointer Table from 3C00E to 3C019 (6 entries, indexed by unknown)
.dw $0120 $0121 $0121 $0121 $0121 $0120

; Pointer Table from 3C01A to 3C01B (1 entries, indexed by unknown)
.dw $0120

; Data from 3C01C to 3C025 (10 bytes)
.db $22 $01 $23 $01 $24 $01 $25 $01 $21 $01

; Pointer Table from 3C026 to 3C02B (3 entries, indexed by unknown)
.dw $0121 $0120 $0120

; Data from 3C02C to 3C061 (54 bytes)
.db $26 $01 $27 $01 $28 $01 $29 $01 $21 $01 $21 $01 $2A $01 $2B $01
.db $2C $01 $2D $01 $2E $01 $2F $01 $30 $01 $31 $01 $32 $01 $33 $01
.db $21 $01 $21 $01 $20 $01 $2E $03 $34 $01 $30 $03 $35 $01 $21 $01
.db $21 $01 $21 $01 $20 $01

; Pointer Table from 3C062 to 3C063 (1 entries, indexed by unknown)
.dw $0120

; Data from 3C064 to 3C06D (10 bytes)
.db $36 $01 $37 $01 $38 $01 $39 $01 $21 $01

; Pointer Table from 3C06E to 3C071 (2 entries, indexed by unknown)
.dw $0121 $0120

; Data from 3C072 to 3C091 (32 bytes)
.db $3A $01 $34 $01 $3B $01 $35 $01 $3C $01 $21 $01 $21 $01 $3D $01
.db $3E $01 $3F $01 $40 $01 $41 $01 $42 $01 $21 $01 $21 $01 $20 $01

; Pointer Table from 3C092 to 3C093 (1 entries, indexed by unknown)
.dw $0120

; Data from 3C094 to 3C09D (10 bytes)
.db $43 $01 $44 $01 $21 $01 $45 $01 $21 $01

; Pointer Table from 3C09E to 3C09F (1 entries, indexed by unknown)
.dw $0121

; Data from 3C0A0 to 3C0A9 (10 bytes)
.db $34 $03 $20 $01 $35 $03 $33 $03 $20 $01

; Pointer Table from 3C0AA to 3C0AB (1 entries, indexed by unknown)
.dw $0120

; Data from 3C0AC to 3C0B5 (10 bytes)
.db $32 $03 $2F $03 $21 $01 $46 $01 $21 $01

; Pointer Table from 3C0B6 to 3C0B7 (1 entries, indexed by unknown)
.dw $0121

; Data from 3C0B8 to 3C0C1 (10 bytes)
.db $33 $03 $47 $01 $21 $01 $48 $01 $20 $01

; Pointer Table from 3C0C2 to 3C0C3 (1 entries, indexed by unknown)
.dw $0120

; Data from 3C0C4 to 3C0CD (10 bytes)
.db $22 $01 $23 $01 $24 $01 $25 $01 $21 $01

; Pointer Table from 3C0CE to 3C0D3 (3 entries, indexed by unknown)
.dw $0121 $0120 $0120

; Data from 3C0D4 to 3C0E5 (18 bytes)
.db $26 $01 $2B $01 $28 $01 $2D $01 $21 $01 $21 $01 $20 $01 $20 $01
.db $2E $01

; Pointer Table from 3C0E6 to 3C0E7 (1 entries, indexed by unknown)
.dw $0120

; Data from 3C0E8 to 3C0F1 (10 bytes)
.db $30 $01 $49 $01 $21 $01 $21 $01 $20 $01

; Pointer Table from 3C0F2 to 3C0F3 (1 entries, indexed by unknown)
.dw $0120

; Data from 3C0F4 to 3C115 (34 bytes)
.db $4A $01 $4B $01 $20 $01 $20 $01 $4C $01 $4D $01 $4E $01 $4F $01
.db $20 $01 $50 $01 $51 $01 $52 $01 $53 $01 $20 $01 $54 $01 $55 $01
.db $20 $01

; Pointer Table from 3C116 to 3C119 (2 entries, indexed by unknown)
.dw $0120 $0121

; Data from 3C11A to 3C12D (20 bytes)
.db $56 $01 $21 $01 $57 $01 $58 $01 $59 $01 $5A $01 $5B $01 $21 $01
.db $21 $01 $5C $01

; Pointer Table from 3C12E to 3C12F (1 entries, indexed by unknown)
.dw $0121

; Data from 3C130 to 3C139 (10 bytes)
.db $5D $01 $5E $01 $5F $01 $60 $01 $21 $01

; Pointer Table from 3C13A to 3C145 (6 entries, indexed by unknown)
.dw $0121 $0121 _DATA_35C _DATA_359 _DATA_358 _DATA_35B

; Pointer Table from 3C146 to 3C147 (1 entries, indexed by unknown)
.dw _DATA_35A

; Data from 3C148 to 3C151 (10 bytes)
.db $56 $03 $21 $01 $57 $03 $21 $01 $5E $03

; Pointer Table from 3C152 to 3C157 (3 entries, indexed by unknown)
.dw _DATA_35D _DATA_360 _DATA_35F

; Data from 3C158 to 3C175 (30 bytes)
.db $61 $01 $62 $01 $63 $01 $64 $01 $21 $01 $65 $01 $21 $01 $21 $01
.db $66 $01 $67 $01 $68 $01 $69 $01 $6A $01 $21 $01 $21 $01

; Pointer Table from 3C176 to 3C177 (1 entries, indexed by unknown)
.dw $0121

; Data from 3C178 to 3C1BD (70 bytes)
.db $6B $01 $6C $01 $6D $01 $6E $01 $6F $01 $70 $01 $71 $01 $72 $01
.db $21 $01 $73 $01 $21 $01 $74 $01 $75 $01 $76 $01 $77 $01 $78 $01
.db $79 $01 $7A $01 $7B $01 $21 $01 $7C $01 $7D $01 $21 $01 $7E $01
.db $7F $01 $80 $01 $81 $01 $82 $01 $83 $01 $84 $01 $85 $01 $86 $01
.db $6C $03 $6B $03 $6E $03

; Pointer Table from 3C1BE to 3C1BF (1 entries, indexed by unknown)
.dw _DATA_36D

; Data from 3C1C0 to 3C1F9 (58 bytes)
.db $87 $11 $88 $11 $89 $11 $8A $11 $21 $11 $21 $11 $8B $11 $8C $11
.db $8D $11 $8E $11 $8F $11 $8A $11 $88 $13 $87 $13 $8A $13 $89 $13
.db $90 $01 $91 $01 $92 $01 $93 $01 $94 $01 $95 $01 $96 $01 $97 $01
.db $98 $01 $99 $01 $9A $01 $9B $01 $21 $01

; Pointer Table from 3C1FA to 3C1FB (1 entries, indexed by unknown)
.dw $0121

; Data from 3C1FC to 3C229 (46 bytes)
.db $9C $11 $9D $11 $9E $11 $9F $11 $A0 $31 $A1 $31 $21 $01 $21 $01
.db $A2 $11 $A3 $11 $A4 $11 $A5 $11 $A6 $31 $A7 $31 $21 $01 $21 $01
.db $A8 $61 $A9 $61 $AA $61 $AA $61 $AB $61 $AB $61 $21 $01

; Pointer Table from 3C22A to 3C22B (1 entries, indexed by unknown)
.dw $0121

; Data from 3C22C to 3C289 (94 bytes)
.db $AC $61 $A8 $61 $AD $11 $AE $11 $A8 $61 $A8 $61 $AF $11 $AE $11
.db $A8 $61 $A8 $61 $AF $11 $B0 $11 $A8 $61 $A8 $61 $21 $01 $21 $01
.db $AD $11 $AE $11 $21 $01 $21 $01 $AE $13 $AD $13 $A8 $61 $A8 $61
.db $AA $61 $AA $61 $AB $61 $AB $61 $B1 $61 $B1 $61 $B1 $61 $B1 $61
.db $B1 $61 $B1 $61 $B2 $11 $B3 $11 $A8 $61 $A8 $61 $21 $01 $21 $01
.db $A8 $61 $A8 $61 $21 $01 $21 $01 $AF $11 $AE $11 $20 $01

; Pointer Table from 3C28A to 3C291 (4 entries, indexed by unknown)
.dw $0120 $0120 $0120 $0121

; Data from 3C292 to 3C2A1 (16 bytes)
.db $22 $01 $23 $01 $24 $01 $20 $01 $25 $01 $20 $01 $26 $01 $20 $01

; Pointer Table from 3C2A2 to 3C2A3 (1 entries, indexed by unknown)
.dw $0120

; Data from 3C2A4 to 3C2B9 (22 bytes)
.db $27 $01 $28 $01 $29 $01 $2A $01 $2B $01 $2C $01 $2D $01 $20 $01
.db $2E $01 $20 $01 $20 $01

; Pointer Table from 3C2BA to 3C2BB (1 entries, indexed by unknown)
.dw $0120

; Data from 3C2BC to 3C2DD (34 bytes)
.db $28 $03 $27 $03 $2A $03 $29 $03 $2C $03 $2B $03 $20 $01 $2D $03
.db $20 $01 $2E $03 $22 $03 $21 $03 $24 $03 $23 $03 $25 $03 $20 $01
.db $26 $03

; Pointer Table from 3C2DE to 3C2DF (1 entries, indexed by unknown)
.dw $0120

; Data from 3C2E0 to 3E1B3 (7892 bytes)
.incbin "banks\lots_DATA_3C2E0.inc"

; Pointer Table from 3E1B4 to 3E1B5 (1 entries, indexed by unknown)
.dw _DATA_7050

; Data from 3E1B6 to 3F49B (4838 bytes)
.incbin "banks\lots_DATA_3E1B6.inc"

; Data from 3F49C to 3FC2C (1937 bytes)
_DATA_3F49C:
.incbin "banks\lots_DATA_3F49C.inc"

; Data from 3FC2D to 3FF8E (866 bytes)
_DATA_3FC2D:
.db $24 $00 $99 $01 $02 $03 $04 $05 $06 $07 $08 $09 $0A $0B $0C $25
.db $26 $27 $04 $07 $0B $0C $25 $05 $06 $04 $28 $29 $06 $00 $84 $0D
.db $0E $0F $10 $04 $11 $86 $12 $13 $11 $14 $15 $10 $04 $11 $83 $14
.db $15 $10 $03 $11 $83 $2A $2B $2C $04 $00 $84 $16 $17 $18 $19 $16
.db $11 $82 $2D $2E $04 $00 $82 $1A $1B $19 $11 $81 $2F $04 $00 $81
.db $1C $19 $11 $82 $30 $31 $04 $00 $81 $1D $19 $11 $82 $32 $33 $04
.db $00 $81 $1E $1A $11 $81 $20 $04 $00 $81 $1F $1A $11 $81 $1F $04
.db $00 $81 $20 $1A $11 $81 $1D $04 $00 $82 $21 $22 $19 $11 $81 $1E
.db $04 $00 $82 $23 $24 $19 $11 $81 $34 $04 $00 $82 $35 $30 $18 $11
.db $82 $43 $44 $04 $00 $81 $36 $19 $11 $82 $45 $46 $04 $00 $81 $1E
.db $19 $11 $82 $47 $48 $04 $00 $81 $1F $19 $11 $82 $49 $4A $04 $00
.db $81 $2F $1A $11 $81 $4B $04 $00 $82 $31 $30 $19 $11 $81 $1F $04
.db $00 $82 $33 $32 $19 $11 $81 $1D $04 $00 $81 $37 $1A $11 $81 $4C
.db $04 $00 $82 $38 $39 $16 $11 $84 $4D $4E $4F $50 $04 $00 $83 $3A
.db $3B $3C $03 $11 $85 $3D $11 $14 $15 $10 $03 $11 $87 $13 $12 $11
.db $11 $3D $11 $51 $03 $11 $83 $52 $53 $54 $06 $00 $99 $3E $3F $04
.db $07 $40 $41 $42 $0B $0C $25 $07 $27 $0A $09 $08 $07 $40 $41 $42
.db $55 $42 $56 $57 $58 $59 $24 $00 $00 $7F $01 $7E $01 $81 $07 $1F
.db $01 $81 $07 $1F $01 $81 $03 $1F $01 $81 $03 $25 $01 $81 $07 $7E
.db $01 $81 $03 $1F $01 $02 $03 $19 $01 $81 $07 $04 $01 $02 $03 $19
.db $01 $81 $03 $4C $01 $03 $05 $03 $01 $02 $07 $13 $01 $02 $05 $03
.db $01 $04 $05 $04 $07 $81 $05 $2D $01 $00 $06 $20 $81 $93 $04 $20
.db $81 $93 $0C $20 $9B $3F $25 $23 $7F $99 $9A $62 $99 $86 $42 $32
.db $3E $23 $46 $48 $20 $2D $23 $2E $4E $38 $4E $20 $20 $93 $20 $93
.db $07 $20 $81 $93 $0D $20 $94 $72 $81 $64 $6E $59 $3A $20 $3C $30
.db $30 $3B $20 $27 $27 $4D $41 $26 $24 $30 $92 $15 $20 $81 $93 $05
.db $20 $99 $93 $3F $25 $23 $39 $3C $54 $26 $32 $4D $43 $28 $4B $40
.db $20 $7F $99 $9A $62 $99 $86 $27 $57 $23 $30 $0E $20 $81 $93 $09
.db $20 $98 $4E $39 $33 $36 $46 $49 $20 $25 $23 $39 $21 $4E $2B $32
.db $33 $21 $49 $92 $20 $3C $54 $26 $32 $39 $08 $20 $81 $93 $0F $20
.db $8C $22 $29 $36 $24 $34 $2C $30 $39 $30 $54 $30 $92 $0C $20 $83
.db $93 $20 $93 $0B $20 $81 $93 $09 $20 $98 $72 $81 $64 $6E $59 $39
.db $3F $31 $36 $20 $27 $57 $23 $3C $26 $21 $3C $4A $20 $41 $3E $23
.db $31 $30 $18 $20 $8A $22 $34 $20 $26 $2C $33 $22 $54 $30 $92 $15
.db $20 $81 $93 $0C $20 $81 $93 $03 $20 $97 $31 $57 $23 $4B $23 $26
.db $22 $27 $3A $20 $21 $30 $47 $2C $22 $25 $23 $4D $24 $47 $3C $30
.db $42 $0D $20 $81 $93 $0B $20 $90 $9E $32 $39 $2C $4A $4E $39 $20
.db $25 $3C $4A $4D $30 $2C $30 $92 $08 $20 $00 $6C $00 $6C $00 $6C
.db $00 $6C $00 $00 $0B $20 $81 $93 $0C $20 $98 $3D $4E $27 $57 $23
.db $39 $45 $23 $2C $7F $86 $6C $99 $3A $20 $21 $22 $2D $49 $2F $2A
.db $28 $39 $30 $13 $20 $81 $93 $04 $20 $97 $42 $20 $9E $32 $39 $2C
.db $4A $4E $36 $20 $31 $57 $23 $2E $4E $2D $49 $26 $28 $2A $4D $27
.db $42 $14 $20 $02 $93 $03 $20 $98 $59 $7B $86 $41 $47 $39 $20 $3F
.db $3E $23 $32 $26 $22 $39 $43 $34 $3D $20 $30 $3B $30 $54 $30 $92
.db $00 $48 $00 $48 $00 $00 $81 $9F $16 $A1 $82 $9F $A0 $16 $20 $02
.db $A0 $94 $20 $9C $20 $25 $23 $29 $39 $2C $57 $23 $31 $57 $23 $20
.db $77 $80 $81 $39 $27 $4D $02 $20 $02 $A0 $06 $20 $81 $93 $0F $20
.db $02 $A0 $03 $20 $85 $40 $32 $29 $30 $2D $0E $20 $02 $A0 $03 $20
.db $84 $93 $20 $20 $93 $0F $20 $02 $A0 $91 $20 $9D $20 $72 $7F $7F
.db $30 $36 $39 $20 $3F $43 $39 $4D $30 $25 $2D $05 $20 $02 $A0 $03
.db $20 $81 $93 $06 $20 $81 $93 $0B $20 $02 $A0 $93 $20 $9E $20 $2C
.db $55 $21 $28 $35 $2E $27 $2F $23 $4D $20 $3A $26 $22 $2D $49 $03
.db $20 $02 $A0 $16 $20 $82 $A0 $9F $16 $A1 $81 $9F $23 $20 $81 $A0
.db $00 $17 $00 $81 $02 $7F $00 $59 $00 $81 $04 $16 $00 $81 $06 $24
.db $00 $00

; Data from 3FF8F to 3FFFF (113 bytes)
_DATA_3FF8F:
.db $03 $00 $83 $07 $0F $1C $0A $18 $03 $00 $02 $FF $03 $00 $00 $18
.db $00 $00 $18 $00 $00 $18 $00 $00

