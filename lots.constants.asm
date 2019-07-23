; Ports
.define Port_MemoryControl $3E
.define Port_PSG $7F
.define Port_VDPData $BE
.define Port_VDPAddress $BF
.define _PORT_DF $DF
.define Port_FMAddress $F0
.define Port_FMData $F1
.define Port_AudioControl $F2

; Input Ports
.define Port_VDPStatus $BF
.define Port_IOPort1 $DC
.define Port_IOPort2 $DD

; Buttons
.define	ButtonUp 0
.define	ButtonDown 1
.define	ButtonLeft 2
.define	ButtonRight 3
.define	Button_1 4
.define	Button_2 5

.define	ButtonUp_Mask 1 << ButtonUp
.define	ButtonDown_Mask 1 << ButtonDown
.define	ButtonLeft_Mask 1 << ButtonLeft
.define	ButtonRight_Mask 1 << ButtonRight
.define	Button_1_Mask 1 << Button_1
.define	Button_2_Mask 1 << Button_2

; Map Status
.define	Map_Status_Reset $00
.define	Map_Status_Map $01
.define	Map_Status_Sega_Logo $02
.define	Map_Status_Title_Screen $03
.define	Map_Status_Demo $04
.define	Map_Status_Start_Game $05
.define	Map_Status_Story $06

; Building Status
.define	Building_Status_Map $00
.define	Building_Status_Load_Map $01
.define	Building_Status_Building $02
.define	Building_Status_Boss_Fight $03
.define	Building_Status_Map_Screen $04
.define	Building_Status_Ending $05
.define	Building_Status_Death $06

; Buildings
.define	Building_Harfoot $01
.define	Building_Amon $02
.define	Building_Dwarle $03
.define	Building_Ithile $04
.define	Building_Pharazon $05
.define	Building_Shagart $06 ; Unused but the progress flags are still set by Ra Goan
.define	Building_Lindon $07
.define	Building_Ulmo $08
.define	Building_Mayors_Daughter $09 ; After Pirate
.define	Building_Unknown_0A $0A ; Not sure what this is
.define	Building_Elder $0B
.define	Building_Varlin $0C

; Movement States
.define	Movement_Walking_Left $00
.define	Movement_Walking_Right $01
.define	Movement_Jumping_Left $02
.define	Movement_Jumping_Right $03
.define	Movement_Falling_Left $04
.define	Movement_Falling_Right $05
.define	Movement_Crouching_Left $06
.define	Movement_Crouching_Right $07
.define	Movement_Sword_Left $08
.define	Movement_Sword_Right $09
.define	Movement_Bow_Left $0A
.define	Movement_Bow_Right $0B
.define	Movement_Crouching_Bow_Left $0C
.define	Movement_Crouching_Bow_Right $0D
.define	Movement_Death $0E
.define	Movement_Death_0F $0F
.define	Movement_Damaged $10
.define	Movement_Damaged_11 $11
.define	Movement_Crouching_Sword_Left $12
.define	Movement_Crouching_Sword_Right $13

; Bosses
.define	Boss_Index_Ulmo $01
.define	Boss_Index_Namo $02
.define	Boss_Index_Baruga $03 ; Mt. Morgos
.define	Boss_Index_Medusa $04
.define	Boss_Index_Necromancer $05
.define	Boss_Index_Duels $06
.define	Boss_Index_Pirate1 $07 ; The actual fight
.define	Boss_Index_Pirate2 $08 ; Map to the right of Pirate?
.define	Boss_Index_Pirate3 $09 ; Empty map w/cave?
.define	Boss_Index_Pirate4 $0A ; Empty map to the right?
.define	Boss_Index_Dark_Suma $0B
.define	Boss_Index_Ra_Goan $0C

; Map Types
.define	Map_Type_Swamp $01
.define	Map_Type_Forest $02
.define	Map_Type_Coast $03
.define	Map_Type_Cave $04
.define	Map_Type_Mountains $05
.define	Map_Type_Dark_Forest $06
.define	Map_Type_Town $07
.define	Map_Type_Castle $08
.define	Map_Type_Dungeon_Suma $09
.define	Map_Type_Dungeon_Ra_Goan $0A

.struct object
	type db
	unknown_0x01 db
	unknown_0x02 db
	unknown_0x03 db ; Spawned flag? if 0, init the object, if 1, run normal behaviour
	unknown_0x04 db ; Pointer, tiles?
	unknown_0x05 db ; Pointer, tiles?
	y_position_sub db   ; 6
	y_position_minor db ; 7
	unknown_0x08 db
	x_position_sub db   ; 9
	x_position_minor db ; 10
	x_position_major db ; 11
	unknown_0x0C db
	unknown_0x0D db
	sign_index db       ; 14 More general: Animation Frame?
	sign_timer db       ; 15
	y_velocity_sub db   ; 16
	y_velocity_minor db ; 17
	unknown_0x12 db
	x_velocity_sub db   ; 19
	x_velocity_minor db ; 20
	x_velocity_major db ; 21
	hitbox_y_offset db  ; 22
	hitbox_height db    ; 23
	hitbox_x_offset db  ; 24
	hitbox_width db     ; 25
	unknown_0x1A db
	unknown_0x1B db ; Upper 4 bits are score table index, not sure what lower 4 do
	unknown_0x1C db
	unknown_0x1D db
	unknown_0x1E db
	unknown_0x1F db
	unknown_0x20 db
	unknown_0x21 db
	boss_teleport_timer db ; 34 - Hm, also seems to be "in air" flag for the player
	unknown_0x23 db
	boss_flash_timer db ; 36
	unknown_0x25 db
	unknown_0x26 db
	unknown_0x27 db
	unknown_0x28 db
	unknown_0x29 db
	unknown_0x2A db
	unknown_0x2B db ; 43 - Damage to be applied after knockback
	unknown_0x2C db
	unknown_0x2D db
	unknown_0x2E db
	unknown_0x2F db
	respawn_timer_minor db ; Technically DW but handling it as 2 DB is easier on my end, oof, might be able to fix in the future
	respawn_timer_major db
	unknown_0x32 db
	unknown_0x33 db
	boss_hp db ; 52
	unknown_0x35 db
	unknown_0x36 db
	unknown_0x37 db
	unknown_0x38 db
	unknown_0x39 db
	current_hp db ; 58
	unknown_0x3B db
	unknown_0x3C db
	unknown_0x3D db
	boss_defeated db ; 62
	unknown_0x3F db
.endst