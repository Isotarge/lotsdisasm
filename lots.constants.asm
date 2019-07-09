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
.define	Building_Dawrle $03
.define	Building_Ithile $04
.define	Building_Pharazon $05
.define	Building_Unused_6 $06 ; Unused but the progress flags are still set by Ra Goan
.define	Building_Lindon $07
.define	Building_Ulmo $08
.define	Building_Mayors_Daughter $09 ; After Pirate
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