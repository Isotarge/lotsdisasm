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
.define	Movement_Damaged $10
.define	Movement_Crouching_Sword_Left $12
.define	Movement_Crouching_Sword_Right $13