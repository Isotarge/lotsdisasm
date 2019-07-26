.enum $C000 export
_RAM_C000 db
.ende

.enum $C093 export
_RAM_SCORE_COUNTER_NEEDS_REDRAW db
_RAM_SCORE_RIGHT_DIGIT db
_RAM_SCORE_MIDDLE_DIGIT db
_RAM_SCORE_LEFT_DIGIT db
.ende

.enum $C098 export
_RAM_CURRENT_MAP db
.ende

.enum $C0A0 export
_RAM_MAP_STATUS db
_RAM_BUILDING_STATUS db
_RAM_MAP_BACKGROUND_IS_SCROLLABLE db
.ende

.enum $C0A4 export
_RAM_GAME_LOOP_IS_RUNNING db ; 1 on NMI boundaries for lag frames
_RAM_CONTROLLER_INPUT db
_RAM_NEW_CONTROLLER_INPUT db
_RAM_GAME_IS_PAUSED db
_RAM_C0A8 dw
_RAM_C0AA dw
_RAM_C0AC dw
.ende

.enum $C0B0 export
_RAM_C0B0 dw
.ende

.enum $C0B4 export
_RAM_C0B4 dw
_RAM_C0B6 dw
_RAM_C0B8 dw
_RAM_C0BA dw
_RAM_C0BC db
.ende

.enum $C100 export
_RAM_C100 db
.ende

.enum $C104 export
_RAM_DEMO_TIMER dw
_RAM_C106 db
_RAM_C107 db
_RAM_C108 db
_RAM_C109 db
_RAM_SCREEN_X_TILE db
_RAM_C10B db
_RAM_C10C db
_RAM_C10D db
_RAM_C10E db
_RAM_SCREEN_X_PIXEL db
_RAM_C110 db
_RAM_C111 db
_RAM_C112 db
_RAM_C113 db
_RAM_C114 db
_RAM_C115 db
_RAM_C116 db
_RAM_C117 db
_RAM_MAP_TYPE db
_RAM_WARP_DESTINATION_TOP_RIGHT db
_RAM_WARP_DESTINATION_BOTTOM_RIGHT db
_RAM_WARP_DESTINATION_TOP_LEFT db
_RAM_WARP_DESTINATION_BOTTOM_LEFT db
_RAM_C11D db
.ende

.enum $C129 export
_RAM_HEALTH db
_RAM_HEALTH_BAR_NEEDS_REDRAW db
_RAM_RECOVERY_STATUS db
_RAM_RECOVERY_TIMER dw
_RAM_C12E db
_RAM_C12F db
_RAM_C130 db
_RAM_C131 db
_RAM_C132 db
_RAM_C133 db
_RAM_C134 db
_RAM_C135 db
_RAM_C136 db
_RAM_C137 dw
_RAM_C139 db
_RAM_C13A db
_RAM_C13B dw
_RAM_C13D db
.ende

.enum $C13F export
_RAM_BUILDING_INITIALIZED db
_RAM_C140 db
_RAM_C141 db
_RAM_BUILDING_FLAG_PROGRESS db
_RAM_C143 db
.ende

.enum $C146 export
_RAM_C146 db
_RAM_BACKGROUND_SCROLL_X db
_RAM_C148 db
_RAM_C149 db
_RAM_C14A db
_RAM_C14B db
_RAM_C14C db
_RAM_C14D db
.ende

.enum $C14F export
_RAM_C14F dw
_RAM_BOSS_FIGHT_INITIALIZED db
_RAM_BOSS_INDEX db
_RAM_C153 db
_RAM_C154 db
_RAM_C155 db
.ende

.enum $C161 export
_RAM_C161 db ; Boolean, whether the position is pulled from C164 and C165 on map load
_RAM_C162 db
_RAM_C163 db
_RAM_C164 db ; Custom X position, read on map load
_RAM_C165 db ; Custom Y position, read on map load
.ende

.enum $C169 export
_RAM_BUILDING_INDEX db
_RAM_C16A db
_RAM_C16B db
.ende

.enum $C16D export
_RAM_INVENTORY_NEEDS_REDRAW db
_RAM_C16E db
_RAM_C16F db
_RAM_C170 db
_RAM_C171 db
_RAM_C172 db
_RAM_C173 dw
_RAM_C175 db
_RAM_C176 db
_RAM_C177 db
_RAM_C178 db
_RAM_C179 db
_RAM_C17A db
_RAM_C17B db
_RAM_C17C dw
_RAM_C17E dw
_RAM_C180 db
_RAM_C181 db
_RAM_C182 db
_RAM_C183 db
_RAM_C184 db
_RAM_ENDING_SCREEN_TRANSITION_TIMER dw
.ende

.enum $C300 export
_RAM_C300 dsb $40
.ende

.enum $C360 export
_RAM_C360 dsb $80
.ende

.enum $C400 export
_RAM_C400 db
_RAM_MOVEMENT_STATE db
_RAM_C402 db
_RAM_C403 db
_RAM_C404 dw
_RAM_Y_POSITION_SUB db
_RAM_Y_POSITION_MINOR db
.ende

.enum $C409 export
_RAM_X_POSITION_SUB db
_RAM_X_POSITION_MINOR db
_RAM_X_POSITION_MAJOR db
_RAM_C40C db
_RAM_C40D db
_RAM_C40E db
_RAM_C40F db
_RAM_Y_VELOCITY_SUB db
_RAM_Y_VELOCITY_MINOR db
.ende

.enum $C413 export
_RAM_X_VELOCITY_SUB db
_RAM_X_VELOCITY_MINOR db
_RAM_X_VELOCITY_MAJOR db
.ende

.enum $C420 export
_RAM_C420 db
_RAM_C421 db
_RAM_LANDAU_IN_AIR db
_RAM_C423 db
.ende

.enum $C425 export
_RAM_C425 db
_RAM_C426 db
_RAM_C427 db
_RAM_C428 db
_RAM_PRE_DAMAGE_MOVEMENT_STATE db
_RAM_C42A db
_RAM_INCOMING_LANDAU_DAMAGE db
_RAM_C42C db
.ende

.enum $C440 export
_RAM_C440 dsb $4
_RAM_C444 dw
.ende

.enum $C460 export
_RAM_C460 db
_RAM_C461 db
.ende

.enum $C480 export
_RAM_C480 db
_RAM_C481 db
.ende

.enum $C483 export
_RAM_C483 db
_RAM_C484 dw
.ende

.enum $C4C0 export
_RAM_SIGN_OBJECT_BASE db
.ende

.enum $C4C3 export
_RAM_C4C3 db
_RAM_C4C4 dw
.ende

.enum $C4CE export
_RAM_SIGN_INDEX db
.ende

.enum $C4E0 export
_RAM_C4E0 db
.ende

.enum $C500 export
_RAM_C500 db
_RAM_C501 db
_RAM_C502 db
.ende

.enum $C504 export
_RAM_C504 dw
.ende

.enum $C50C export
_RAM_C50C db
_RAM_C50D db
_RAM_C50E db
_RAM_C50F db
.ende

.enum $C51A export
_RAM_C51A db
_RAM_C51B db
_RAM_C51C db
_RAM_C51D db
_RAM_C51E db
_RAM_C51F db
_RAM_C520 db
_RAM_C521 db
_RAM_C522 db
_RAM_C523 db
_RAM_C524 db
_RAM_C525 dw
_RAM_C527 db
_RAM_C528 dw
_RAM_C52A dw
.ende

.enum $C52F export
_RAM_C52F db
_RAM_C530 db
_RAM_C531 db
_RAM_C532 db
_RAM_C533 db
.ende

.enum $C538 export
_RAM_C538 db
.ende

.enum $C540 export
_RAM_C540 dsb $3
.ende

.enum $C544 export
_RAM_C544 dw
.ende

.enum $C54C export
_RAM_C54C db
_RAM_C54D db
_RAM_C54E db
_RAM_C54F db
.ende

.enum $C55A export
_RAM_C55A db
_RAM_C55B db
.ende

.enum $C578 export
_RAM_C578 db
.ende

.enum $C580 export
_RAM_C580 dsb $3
.ende

.enum $C584 export
_RAM_C584 dw
.ende

.enum $C59A export
_RAM_C59A db
.ende

.enum $C5B8 export
_RAM_C5B8 db
.ende

.enum $C5C0 export
_RAM_C5C0 dsb $38
.ende

.enum $C600 export
_RAM_C600 dsb $38
.ende

.enum $C640 export
_RAM_C640 db
_RAM_C641 db
.ende

.enum $C680 export
_RAM_C680 dsb $38
.ende

.enum $C6C0 export
_RAM_C6C0 dsb $38
.ende

.enum $C900 export
_RAM_C900 db
.ende

.enum $C9C0 export
_RAM_C9C0 db
.ende

.enum $CC00 export
_RAM_FLAG_TREE_SPIRIT_DEFEATED db
_RAM_FLAG_BARUGA_DEFEATED db
_RAM_FLAG_MEDUSA_DEFEATED db
_RAM_FLAG_NECROMANCER_DEFEATED db
_RAM_FLAG_DUELS_DEFEATED db
_RAM_FLAG_PIRATE_DEFEATED db
_RAM_FLAG_DARK_SUMA_DEFEATED db
_RAM_FLAG_RA_GOAN_DEFEATED db
.ende

.enum $CC11 export
_RAM_FLAG_GAME_STARTED db ; Could also be "building progress enabled"
_RAM_FLAG_ULMO_BUILDING_ENABLED db
_RAM_FLAG_TREE_SPIRIT_SPAWNED db
_RAM_CC14 db
_RAM_CC15 db
_RAM_FLAG_MAYORS_DAUGHTER_RETURNED db
_RAM_CC17 db
_RAM_CC18 db
_RAM_FLAG_MEDUSA_SPAWNED db
_RAM_CC1A db
_RAM_CC1B db
_RAM_CC1C db
_RAM_FLAG_VARLIN_OPEN db
_RAM_CC1E db
.ende

.enum $CC21 export
_RAM_FLAG_BUILDING_PROGRESS_HARFOOT_START db
.ende

.enum $CC27 export
_RAM_CC27 db ; Harfoot Medusa textbox flag
.ende

.enum $CC31 export
_RAM_FLAG_BUILDING_PROGRESS_AMON_START db
.ende

.enum $CC37 export
_RAM_CC37 db ; Amon Pharazon path textbox flag
.ende

.enum $CC41 export
_RAM_FLAG_BUILDING_PROGRESS_DWARLE_START db
.ende

.enum $CC48 export
_RAM_CC48 db ; Dwarle: Baruga Defeated?
_RAM_CC49 db ; Dwarle: Kill the beast text
_RAM_CC4A db ; Baruga Defeated?
_RAM_CC4B db ; Baruga Defeated?
.ende

.enum $CC51 export
_RAM_FLAG_BUILDING_PROGRESS_ITHILE_START db
.ende

.enum $CC61 export
_RAM_FLAG_BUILDING_PROGRESS_PHARAZON_START db
.ende

.enum $CC67 export
_RAM_CC67 db ; Pharazon path to Amon textbox flag
.ende

.enum $CC71 export
_RAM_FLAG_BUILDING_PROGRESS_SHAGART_START db ; Unused but flags are still set by Ra Goan
.ende

.enum $CC81 export
_RAM_FLAG_BUILDING_PROGRESS_LINDON_START db
.ende

.enum $CC8A export
_RAM_CC8A db
.ende

.enum $CC91 export
_RAM_FLAG_BUILDING_PROGRESS_ULMO_START db
.ende

.enum $CC93 export
_RAM_CC93 db
.ende

.enum $CCA0 export
_RAM_CCA0 db
_RAM_CCA1 db
_RAM_FLAG_PIRATE_PATH_OPEN db
_RAM_CCA3 db
_RAM_CCA4 db
.ende

.enum $CCA8 export
_RAM_SWORD_DAMAGE db
_RAM_BOW_DAMAGE db
_RAM_INVENTORY_BOOK db
_RAM_INVENTORY_TREE_LIMB db
_RAM_INVENTORY_HERB db
_RAM_CCAD db
_RAM_CONTINUE_MAP db
_RAM_CONTINUES_USED db
.ende

.enum $D000 export
_RAM_LEVEL_LAYOUT db
.ende

.enum $D004 export
_RAM_D004 db
.ende

.enum $D420 export
_RAM_D420 db
.ende

.enum $D430 export
_RAM_D430 db
.ende

.enum $D70D export
_RAM_D70D db
.ende

.enum $DE00 export
_RAM_DE00 db
_RAM_DE01 db
_RAM_DE02 db
_RAM_DE03 db ; Currently Playing Sound?
_RAM_SOUND_TO_PLAY db ; Used to queue new sound/music to play by the game
.ende

.enum $DE07 export
_RAM_DE07 db
_RAM_DE08 db
_RAM_DE09 db
_RAM_DE0A db
_RAM_DE0B db
_RAM_DE0C db
.ende

.enum $DE0E export
_RAM_DE0E db
.ende

.enum $DE15 export
_RAM_DE15 db
_RAM_DE16 db
.ende

.enum $DE18 export
_RAM_DE18 db
.ende

.enum $DE4E export
_RAM_DE4E db
.ende

.enum $DE61 export
_RAM_DE61 db
.ende

.enum $DE6E export
_RAM_DE6E db
.ende

.enum $DE81 export
_RAM_DE81 db
.ende

.enum $DE8E export
_RAM_DE8E db
.ende

.enum $DE95 export
_RAM_DE95 db
.ende

.enum $DEA1 export
_RAM_DEA1 db
.ende

.enum $DEAE export
_RAM_DEAE db
.ende

.enum $DEB5 export
_RAM_DEB5 db
.ende

.enum $DECE export
_RAM_DECE db
.ende

.enum $DEEE export
_RAM_DEEE db
.ende

.enum $FFFB export
_RAM_FFFB db
_RAM_FFFC db
_RAM_FFFD db
_RAM_FFFE db
_RAM_FFFF db
.ende