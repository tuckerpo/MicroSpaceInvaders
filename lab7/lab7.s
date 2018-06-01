	PRESERVE8
	AREA interrupts, CODE, READWRITE
	EXPORT lab7
	EXPORT FIQ_Handler
	EXTERN output_string
	EXTERN read_character
	EXTERN output_character
	EXTERN display_digit_on_7_seg
	EXTERN turn_7_seg_off
	EXTERN htoi
	EXTERN seven_seg_setup
	EXTERN print_newline
	EXTERN interrupt_init
	EXPORT lab7_quit
		; C externs
	EXTERN random_zero_and_one
	EXTERN random_alien_select
	EXTERN rng_spaceship_score
	EXTERN random_column
		; export to library
	EXPORT level
	EXPORT lab6_really_quit
	EXPORT gameover_flag
	EXPORT lab7_start
		; export to c

P0DIR EQU 0xE0028008 ; port 0 direction
U0BA  EQU 0xE000C000            ; UART0 Base Address
U0LSR EQU 0x14                  ; UART0 Line Status Register
U0LCR EQU 0x0C                  ; UART0 Line Control Register
PINSEL0 EQU 0xE002C000          ; Pin Connect BlockF Port 0
PINSEL1 EQU 0xE002C004
IO0DIR  EQU 0xE0028008          ; GPIO Direction Registers
IO1DIR  EQU 0xE0028018
IO0SET  EQU 0xE0028004          ; GPIO Output Set Registers
IO1SET  EQU 0xE0028014
IO0CLR  EQU 0xE002800C          ; GPIO Output Clear Registers
IO1CLR  EQU 0xE002801C
IO0PIN  EQU 0xE0028000          ; GPIO Port Pin Value Registers
IO1PIN  EQU 0xE0028010
	
; ----- ENEMY PROMPTS ----- ;

prompt_board_f = "\033[1;1f","\r|---------------------|\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|                     |\r\n|---------------------|\r\n",0

; ----- PLAYER PROMPT ----- ;
made_it_to = "\n\nYou made it to level ",0
enter_or_q = "\n\rPress the enter key to play again, or press q to quit for good.",0
gameover_flag = "0",0
w_hit = "0",0
o_hit = "0",0
m_hit = "0",0
tilde 	 = "\033[00;00f\033[1:92m~\033[0m",0
e_bullet = "\033[05;07f\033[1;93mv\033[0m",0
enemy_bullet_in_flight = "0",0
player = "\033[16;11fA",0
bullet = "\033[15;11f\033[1;92m^\033[0m",0
shield_health = "2",0
player_bullet_velocity = "0",0
player_bullet_fired = "0",0
bullet_in_flight = "0",0
movement_count = "0",0
move_down = "0",0
move_left = "0",0
move_right = "0",0
moves = "0",0
opposite_direction = "1",0
opposite_down = "1",0
; stuff for each level
lives = "4",0
level = "1",0
score  = "0000\n\r",0
score1 = "0000\n\r",0
score2 = "0000\n\r",0
score3 = "0000\n\r",0
score4 = "0000\n\r",0
score5 = "0000\n\r",0
score6 = "0000\n\r",0
score7 = "0000\n\r",0
score8 = "0000\n\r",0
score9 = "0000\n\r",0 ;  they probably won't eve even get here, right?
motherships_killed  = "0000\n\r",0
motherships_killed1 = "0000\n\r",0
motherships_killed2 = "0000\n\r",0
motherships_killed3 = "0000\n\r",0
motherships_killed4 = "0000\n\r",0
motherships_killed5 = "0000\n\r",0
motherships_killed6 = "0000\n\r",0
motherships_killed7 = "0000\n\r",0
motherships_killed8 = "0000\n\r",0
motherships_killed9 = "0000\n\r",0
prompt_color = "\033[0;35m",0
prompt_color1 = "\033[0;36m",0
prompt_color2 = "\033[0;32m",0
prompt_color3 = "\033[47m",0

color_end   = "\033[0m",0

time  = "0000 s",0
time1 = "0000 s",0
time2 = "0000 s",0
time3 = "0000 s",0
time4 = "0000 s",0
time5 = "0000 s",0
time6 = "0000 s",0
time7 = "0000 s",0
time8 = "0000 s",0
time9 = "0000 s",0

possible_motherships =  "0000\n\r",0
possible_motherships1 = "0000\n\r",0
possible_motherships2 = "0000\n\r",0
possible_motherships3 = "0000\n\r",0
possible_motherships4 = "0000\n\r",0
possible_motherships5 = "0000\n\r",0
possible_motherships6 = "0000\n\r",0
possible_motherships7 = "0000\n\r",0
possible_motherships8 = "0000\n\r",0
possible_motherships9 = "0000\n\r",0

score_from_motherships = "0000\n\r",0
score_from_motherships1 = "0000\n\r",0
score_from_motherships2 = "0000\n\r",0
score_from_motherships3 = "0000\n\r",0
score_from_motherships4 = "0000\n\r",0
score_from_motherships5 = "0000\n\r",0
score_from_motherships6 = "0000\n\r",0
score_from_motherships7 = "0000\n\r",0
score_from_motherships8 = "0000\n\r",0
score_from_motherships9 = "0000\n\r",0

deaths = "0",0
deaths1 = "0",0
deaths2 = "0",0
deaths3 = "0",0
deaths4 = "0",0
deaths5 = "0",0
deaths6 = "0",0
deaths7 = "0",0
deaths8 = "0",0
deaths9 = "0",0


timeleft = "120",0
ticker = "0",0


	ALIGN
mothership_timer_count = "0",0
mothership_flight = "0",0
mothership_from_left = "0",0
mothership_from_right = "0",0
		ALIGN
paused = "\033[31m\033[24;00fGAME IS NOW PAUSED\033[0m",0
unpaused = "\033[32m\033[22;22fGAME IS NOW UNPAUSED\033[0m",0
levelup = "0",0
prompt_started = "0",0
prompt_input_ctr = "0",0
prompt_clr = "\033[2J\r\033[00;00f",0
prompt_status = "0",0 ; this will hold interrupt status as 0 or 1 in ascii hex
prompt_hex_seq_digit_0 = "",0 ; will hold the hex string given to us
prompt_hex_seq_digit_1 = "",0
prompt_hex_seq_digit_2 = "",0
prompt_hex_seq_digit_3 = "",0
prompt_found_enter = "0",0 ; will tell us if we've found enter or not.
promt_status2 = "0",0 ; interrupt key status 
level_counter = "1",0

gameover = "\033[2J\rGame over! Thanks for playing.\n\r",0
spaceship_total = "\nTotal number of possible mothership kills:\r\n",0
mothership_killed_total = "\nTotal number of motherships you destroyed:\r\n",0
currlevel = "\033[18;00f\033[0;93mYou're currently on level: \033[0m",0
indiv_breakdown = "\nIndividual level breakdown...\n\n\r",0
pts_from_mship = "Points achieved by destroying motherships:\r\n",0
any_blank = "\n\nIf any of the above scores are blank, that means you did not reach that level.\n\r",0
lvl1str = "\r\033[4;36mLevel 1:\n\033[0m",0
lvl2str = "\n\n\r\033[4;36mLevel 2:\n\033[0m",0
lvl3str = "\n\n\r\033[4;36mLevel 3:\n\033[0m",0
lvl4str = "\n\n\r\033[4;36mLevel 4:\n\033[0m",0
lvl5str = "\n\n\r\033[4;36mLevel 5:\n\033[0m",0
lvl6str = "\n\n\r\033[4;36mLevel 6:\n\033[0m",0
lvl7str = "\n\n\r\033[4;36mLevel 7:\n\033[0m",0
lvl8str = "\n\n\r\033[4;36mLevel 8:\n\033[0m",0
lvl9str = "\n\n\r\033[4;36mLevel 9:\n\033[0m",0
lvl1hit = "0",0
lvl2hit = "0",0
lvl3hit = "0",0
lvl4hit = "0",0
lvl5hit = "0",0
lvl6hit = "0",0
lvl7hit = "0",0
lvl8hit = "0",0
lvl9hit = "0",0

score_blank = "\rScore:\r\n",0
ships_passed = "\rMotherships that appeared:\r\n",0
motherships_destroyed = "\rMotherships destroyed:\r\n",0
death_count = "Number of times you died on this level:\r\n",0
timeout dcd 0x0000
	ALIGN

spaceship = "\033[02;02f\033[1;91m \033[0m",0 ; initially have it way off screen
shield = "\033[13;04fS\033[13;05fS\033[13;06fS\033[13;10fS\033[13;11fS\033[13;12fS\033[13;16fS\033[13;17fS\033[13;18fS\033[14;04fS\033[14;06fS\033[14;10fS\033[14;12fS\033[14;16fS\033[14;18fS",0
O_shield = "\033[13;04fS\033[13;05fS\033[13;06fS\033[13;10fS\033[13;11fS\033[13;12fS\033[13;16fS\033[13;17fS\033[13;18fS\033[14;04fs\033[14;06fs\033[14;10fs\033[14;12fs\033[14;16fs\033[14;18fs",0

move = "0",0
move1 = "0",0
moveR = "1",0
moveD = "1",0
moveL = "0",0

wshield5 = "",0
wshield6 = "",0
		
invader1 = "\033[03;07fO\033[03;08fO\033[03;09fO\033[03;10fO\033[03;11fO\033[03;12fO\033[03;13fO\033[04;07fM\033[04;08fM\033[04;09fM\033[04;10fM\033[04;11fM\033[04;12fM\033[04;13fM\033[05;07fM\033[05;08fM\033[05;09fM\033[05;10fM\033[05;11fM\033[05;12fM\033[05;13fM\033[06;07fW\033[06;08fW\033[06;09fW\033[06;10fW\033[06;11fW\033[06;12fW\033[06;13fW\033[07;07fW\033[07;08fW\033[07;09fW\033[07;10fW\033[07;11fW\033[07;12fW\033[07;13fW",0
reset_in = "\033[03;07fO\033[03;08fO\033[03;09fO\033[03;10fO\033[03;11fO\033[03;12fO\033[03;13fO\033[04;07fM\033[04;08fM\033[04;09fM\033[04;10fM\033[04;11fM\033[04;12fM\033[04;13fM\033[05;07fM\033[05;08fM\033[05;09fM\033[05;10fM\033[05;11fM\033[05;12fM\033[05;13fM\033[06;07fW\033[06;08fW\033[06;09fW\033[06;10fW\033[06;11fW\033[06;12fW\033[06;13fW\033[07;07fW\033[07;08fW\033[07;09fW\033[07;10fW\033[07;11fW\033[07;12fW\033[07;13fW",0
invader_init_left = "0",0
invader_init_right = "0",0

currscore = "\033[19;00f\033[1;34mYour current score is: \033[0m",0
currlives = "\033[20;00f\033[1;32mLives remaining: \033[0m",0
currmothcount = "\033[21;00f\033[1;33mMotherships passed: \033[0m",0
currmothkilled = "\033[22;00f\033[1;34mMotherships killed: \033[0m",0
currmothscore = "\033[23;00f\033[1;35mScore from motherships: \033[0m",0
currtime = "\033[24;00f\033[1;38mTime left (seconds): \033[0m",0
enemies_left = "35",0
	ALIGN
		
lab7 
	STMFD SP!, {lr}	
	bl Reset1
	bl reinit_aliens
	ldr r1, =random_zero_and_one
	mov lr, pc
	bx r1
	LTORG
	cmp r0, #0
	ldreq r4, =opposite_direction
	moveq r5, #0x30
	strbeq r5, [r4]
	cmp r0, #1
	ldreq r4, =opposite_direction
	moveq r5, #0x31
	strbeq r5, [r4]
	BL seven_seg_setup
	BL gpio_init
	BL interrupt_init
lab7_start
	LDR r0, =prompt_started
	LDRB r1, [r0]
	CMP r1, #0x30
	BEQ lab7_start
	LDR r4, =prompt_board_f
	BL output_string	
lab6_loop_to_be_interrupted
	B lab6_loop_to_be_interrupted	
lab7_quit
	ldr r4, =IO0SET
	ldr r5, =0x00260000
	str r5, [r4]
	ldr r4, =IO0CLR
	ldr r5, =0x00060000
	str r5, [r4]
	LDR r4, =gameover
	BL output_string
	ldr r4, =gameover_flag
	mov r5, #0x31
	strb r5, [r4] ; set game over flag high so enter and q are no longer ignored
	ldr r4, =indiv_breakdown
	bl output_string
	
	ldr r4, =lvl1str
	bl output_string
print_score1

	ldr r4, =score_blank
	bl output_string
	ldr r4, =score1
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score
	bl output_string
	ldr r4, =ships_passed
	bl output_string
	ldr r4, =possible_motherships1
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =possible_motherships
	bl output_string
	ldr r4, =motherships_destroyed
	bl output_string
	ldr r4, =motherships_killed1
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =motherships_killed
	bl output_string
	ldr r4, =pts_from_mship
	bl output_string
	ldr r4, =score_from_motherships1
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score_from_motherships
	bl output_string
	ldr r4, =death_count
	bl output_string
	ldr r4, =deaths1
	ldrb r0, [r4, #0]
	cmp r0, #0x30
 	ldreq r4, =deaths
	bl output_string
	
print_score2
	ldr r4, =lvl2hit
	ldrb r5, [r4]
	cmp r5, #0x31
	bne last_print
	ldr r4, =lvl2str
	bl output_string
	
	ldr r4, =score_blank
	bl output_string
	ldr r4, =score2
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score
	bl output_string
	
	ldr r4, =ships_passed
	bl output_string
	ldr r4, =possible_motherships2
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =possible_motherships
	bl output_string
	
	ldr r4, =motherships_destroyed
	bl output_string
	ldr r4, =motherships_killed2
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =motherships_killed
	bl output_string
	ldr r4, =pts_from_mship
	bl output_string
	ldr r4, =score_from_motherships2
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score_from_motherships
	bl output_string
	ldr r4, =death_count
	bl output_string
	ldr r4, =deaths2
	ldrb r0, [r4, #0]
	cmp r0, #0x30
 	ldreq r4, =deaths
	bl output_string
print_score3
	ldr r4, =lvl3hit
	ldrb r5, [r4]
	cmp r5, #0x31
	bne last_print
	ldr r4, =lvl3str
	bl output_string
	ldr r4, =score_blank
	bl output_string
	ldr r4, =score3
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score
	bl output_string
	ldr r4, =ships_passed
	bl output_string
	ldr r4, =possible_motherships3
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =possible_motherships
	bl output_string
	ldr r4, =motherships_destroyed
	bl output_string
	ldr r4, =motherships_killed3
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =motherships_killed
	bl output_string
	ldr r4, =pts_from_mship
	bl output_string
	ldr r4, =score_from_motherships3
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score_from_motherships
	bl output_string
	ldr r4, =death_count
	bl output_string
	ldr r4, =deaths3
	ldrb r0, [r4, #0]
	cmp r0, #0x30
 	ldreq r4, =deaths
	bl output_string
print_score4
	ldr r4, =lvl4hit
	ldrb r5, [r4]
	cmp r5, #0x31
	bne last_print
	ldr r4, =lvl2str
	bl output_string
	ldr r4, =score_blank
	bl output_string
	ldr r4, =score4
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score
	bl output_string
	ldr r4, =ships_passed
	bl output_string
	ldr r4, =possible_motherships4
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =possible_motherships
	bl output_string
	ldr r4, =motherships_destroyed
	bl output_string
	ldr r4, =motherships_killed4
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =motherships_killed
	bl output_string
	ldr r4, =pts_from_mship
	bl output_string
	ldr r4, =score_from_motherships4
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score_from_motherships
	bl output_string
	ldr r4, =death_count
	bl output_string
	ldr r4, =deaths4
	ldrb r0, [r4, #0]
	cmp r0, #0x30
 	ldreq r4, =deaths
	bl output_string
print_score5
	ldr r4, =lvl5hit
	ldrb r5, [r4]
	cmp r5, #0x31
	bne last_print
	ldr r4, =lvl5str
	bl output_string
	ldr r4, =score_blank
	bl output_string
	ldr r4, =score5
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score
	bl output_string
	ldr r4, =ships_passed
	bl output_string
	ldr r4, =possible_motherships5
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =possible_motherships
	bl output_string
	ldr r4, =motherships_destroyed
	bl output_string
	ldr r4, =motherships_killed5
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =motherships_killed
	bl output_string
	ldr r4, =pts_from_mship
	bl output_string
	ldr r4, =score_from_motherships5
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score_from_motherships
	bl output_string
	ldr r4, =death_count
	bl output_string
	ldr r4, =deaths5
	ldrb r0, [r4, #0]
	cmp r0, #0x30
 	ldreq r4, =deaths
	bl output_string
print_score6
	ldr r4, =lvl6hit
	ldrb r5, [r4]
	cmp r5, #0x31
	bne last_print
	ldr r4, =lvl6str
	bl output_string
	ldr r4, =score_blank
	bl output_string
	ldr r4, =score6
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score
	bl output_string
	ldr r4, =ships_passed
	bl output_string
	ldr r4, =possible_motherships6
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =possible_motherships
	bl output_string
	ldr r4, =motherships_destroyed
	bl output_string
	ldr r4, =motherships_killed6
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =motherships_killed
	bl output_string
	ldr r4, =pts_from_mship
	bl output_string
	ldr r4, =score_from_motherships6
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score_from_motherships
	bl output_string
	ldr r4, =death_count
	bl output_string
	ldr r4, =deaths6
	ldrb r0, [r4, #0]
	cmp r0, #0x30
 	ldreq r4, =deaths
	bl output_string
print_score7
	ldr r4, =lvl7hit
	ldrb r5, [r4]
	cmp r5, #0x31
	bne last_print
	ldr r4, =lvl7str
	bl output_string
	ldr r4, =score_blank
	bl output_string
	ldr r4, =score7
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score
	bl output_string
	ldr r4, =ships_passed
	bl output_string
	ldr r4, =possible_motherships7
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =possible_motherships
	bl output_string
	ldr r4, =motherships_destroyed
	bl output_string
	ldr r4, =motherships_killed7
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =motherships_killed
	bl output_string
	ldr r4, =pts_from_mship
	bl output_string
	ldr r4, =score_from_motherships7
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score_from_motherships
	bl output_string
	ldr r4, =death_count
	bl output_string
	ldr r4, =deaths7
	ldrb r0, [r4, #0]
	cmp r0, #0x30
 	ldreq r4, =deaths
	bl output_string
print_score8
	ldr r4, =lvl8hit
	ldrb r5, [r4]
	cmp r5, #0x31
	bne last_print
	ldr r4, =lvl8str
	bl output_string
	ldr r4, =score_blank
	bl output_string
	ldr r4, =score8
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score
	bl output_string
	ldr r4, =ships_passed
	bl output_string
	ldr r4, =possible_motherships8
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =possible_motherships
	bl output_string
	ldr r4, =motherships_destroyed
	bl output_string
	ldr r4, =motherships_killed8
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =motherships_killed
	bl output_string
	ldr r4, =pts_from_mship
	bl output_string
	ldr r4, =score_from_motherships8
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score_from_motherships
	bl output_string
	ldr r4, =death_count
	bl output_string
	ldr r4, =deaths8
	ldrb r0, [r4, #0]
	cmp r0, #0x30
 	ldreq r4, =deaths
	bl output_string
print_score9
	ldr r4, =lvl9hit
	ldrb r5, [r4]
	cmp r5, #0x31
	bne last_print
	ldr r4, =lvl9str
	bl output_string
	ldr r4, =score_blank
	bl output_string
	ldr r4, =score9
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score
	bl output_string
	ldr r4, =ships_passed
	bl output_string
	ldr r4, =possible_motherships9
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =possible_motherships
	bl output_string
	ldr r4, =motherships_destroyed
	bl output_string
	ldr r4, =motherships_killed9
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =motherships_killed
	bl output_string
	ldr r4, =pts_from_mship
	bl output_string
	ldr r4, =score_from_motherships9
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30
	cmpeq r2, #0x30
	cmpeq r3, #0x30
	ldreq r4, =score_from_motherships
	bl output_string
	ldr r4, =death_count
	bl output_string
	ldr r4, =deaths9
	ldrb r0, [r4, #0]
	cmp r0, #0x30
 	ldreq r4, =deaths
	bl output_string
	
last_print
	LDR r4, =IO0SET
	LDR r1, =0x0000003C

	STR r1, [r4]
	ldr r4, =enter_or_q
	bl output_string
lab7_quit_poll
	bl read_character
lab6_really_quit
	LDMFD SP! , {lr}
	BX lr
	LTORG
Reset1
	STMFD SP!, {lr}

	AND r6,r6,#0
	AND r5,r5, #0
	ADD r5,r5, #8
loop4
	LDR r4, =shield
	LDR r3, =O_shield

	LDRB r2, [r3,r5]
	STRB r2, [r4,r5]
	ADD r5,r5, #9
	
	ADD r6,r6,#1
	CMP r6, #23
	BNE loop4
	AND r6,r6,#0
	AND r5,r5, #0
	ADD r5,r5, #8
	STMFD SP!,{lr}
	BX lr
	LTORG

; -----------
reinit_aliens
	stmfd sp!, {r0-r12, lr}
	ldr r4, =invader1
	ldr r5, =reset_in
reinit_aliens_init
	mov r7, #0
	mov r8, #0
reinit_aliens_replace
	ldrb r0,[r5, #2]
	MOV r0, #0x30
	STRB r0, [r5, #2]
	ldrb r0,[r5, #3]
	MOV r0, #0x33
	STRB r0, [r5, #3]
	ldrb r0,[r5, #4]
	MOV r0, #0x3B
	STRB r0, [r5, #4]
	ldrb r0,[r5, #5]
	MOV r0, #0x30
	STRB r0, [r5, #5]
	ldrb r0,[r5, #6]
	MOV r0, #0x37
	STRB r0, [r5, #6]
	AND r0, r0, #0
	add r7, r7, #2
	ldrb r0, [r5, r7] ; 2
	strb r0, [r4, r7]
	add r7, r7, #1
	ldrb r1, [r5, r7] ; 3
	strb r1, [r4, r7]
	add r7, r7, #2
	ldrb r2, [r5, r7] ; 5
	strb r2, [r4, r7]
	add r7, r7, #1
	ldrb r3, [r5, r7] ; 6
	strb r3, [r4, r7]
	add r7, r7, #2
	ldrb r6, [r5, r7]
	strb r6, [r4, r7]
	add r7, r7, #1
	cmp r8, #35 ; for some reason 34 works instead of 35
	addne r8, #1
	beq reinit_aliens_end
	bne reinit_aliens_replace
reinit_aliens_end
	ldmfd sp!, {r0-r12, lr}
	bx lr
	LTORG



; ------------
; mothership_init
mothership_init
	stmfd sp!, {r0-r12, lr}
	ldr r1, =random_zero_and_one
	mov lr, pc
	bx r1
	cmp r0, #0

	beq m_left
	bne m_right

m_left
	ldr r4, =spaceship
	mov r0, #0x30
	mov r1, #0x32
	mov r2, #0x30
	mov r3, #0x32
	mov r5, #0x58 ;'X'
	strb r0, [r4, #2]
	strb r1, [r4, #3]
	strb r2, [r4, #5]
	strb r3, [r4, #6]
	strb r5, [r4, #15]
	mov r0, #0x31
	ldr r4, =mothership_from_left
	strb r0, [r4]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #3]
	cmp r0, #0x39
	addne r0, r0, #1
	strbne r0, [r4, #3]	
	moveq r0, #0x30
	strbeq r0, [r4, #3]
	ldrbeq r1, [r4, #2]
	addeq r1, r1, #1
	strbeq r1, [r4, #2]
	b mothership_init_end
m_right	
	ldr r4, =spaceship
	mov r0, #0x30
	mov r1, #0x32
	mov r2, #0x32
	mov r3, #0x31
	mov r5, #0x58 ;'X'
	strb r0, [r4, #2]
	strb r1, [r4, #3]
	strb r2, [r4, #5]
	strb r3, [r4, #6]
	strb r5, [r4, #15]
	mov r0, #0x31
	ldr r4, =mothership_from_right
	strb r0, [r4]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #3]
	cmp r0, #0x39
	addne r0, r0, #1
	strbne r0, [r4, #3]	
	moveq r0, #0x30
	strbeq r0, [r4, #3]
	ldrbeq r1, [r4, #2]
	addeq r1, r1, #1
	strbeq r1, [r4, #2]
	b mothership_init_end
mothership_init_end
	ldr r4, =mothership_flight
	mov r5, #0x31
	strb r5, [r4]
	ldmfd sp!, {r0-r12, lr}
	bx lr
	ltorg
; ------------
; mothership_update
mothership_update
	stmfd sp!, {r0-r12,lr}
	ldr r4, =mothership_flight
	ldrb r5, [r4]
	cmp r5, #0x30
	beq mothership_update_end
	; Check if the bullet collides here!
	ldr r4, =bullet
	ldrb r0, [r4, #2]
	ldrb r1, [r4, #3]
	ldrb r2, [r4, #5]
	ldrb r3, [r4, #6]
	ldr r4, =spaceship
	ldrb r5, [r4, #2]
	ldrb r6, [r4, #3]
	ldrb r7, [r4, #5]
	ldrb r8, [r4, #6]
	cmp r0, r5
	cmpeq r1, r6
	cmpeq r2, r7
	cmpeq r3, r8
	; If the bullet hit the spaceship
	ldreq r4, =bullet
	moveq r10, #0x30
	strbeq r10, [r4, #2]
	strbeq r10, [r4, #3]
	strbeq r10, [r4, #5]
	strbeq r10, [r4, #6]
	ldreq r4, =spaceship
	moveq r10, #0x20
	strbeq r10, [r4, #15] ; overwrites mothership witha  blank space if it is shot. will remain blank until it is reinit'd
	moveq r10, #0x35
	strbeq r10, [r4, #2]
	strbeq r10, [r4, #3]
	strbeq r10, [r4, #5]
	strbeq r10, [r4, #6]
	ldreq r4, =motherships_killed
	ldrbeq r5, [r4]
	addeq r5, r5, #1
	strbeq r5, [r4, #3]
	ldreq r4, =mothership_flight
	moveq r5, #0x30
	strbeq r5, [r4]
	ldreq r4, =bullet_in_flight
	strbeq r5, [r4]
	ldreq r1, =rng_spaceship_score
	moveq lr, pc
	bxeq r1
	

m_100
	cmp r0, #1
	moveq r9, #10
	bne m_200
m_100_begin
	bl update_score
	bl update_score_mship
	add r9, r9, #-1
	cmp r9, #0
	bne m_100_begin
	beq mothership_cont
m_200	
	cmp r0, #2
	moveq r9, #20
	bne m_300
m_200_begin
	bl update_score
	bl update_score_mship
	add r9, r9, #-1
	cmp r9, #0
	bne m_200_begin
	beq mothership_cont
m_300
	cmp r0, #3
	moveq r9, #30
	bne mothership_cont
m_300_begin
	bl update_score
	bl update_score_mship
	add r9, r9, #-1
	cmp r9, #0
	bne m_300_begin
	beq mothership_cont
	
	
mothership_cont
	ldr r4, =mothership_from_left
	ldrb r5, [r4]
	cmp r5, #0x31
	beq handle_from_left
	ldr r4, =mothership_from_right
	ldrb r5, [r4]
	cmp r5, #0x31
	beq handle_from_right
handle_from_left
	ldr r4, =spaceship 
	ldrb r0, [r4, #5]
	ldrb r1, [r4, #6]
	cmp r0, #0x32
	cmpeq r1, #0x32
	ldreq r4, =mothership_from_left
	moveq r5, #0x30
	strbeq r5, [r4]
	ldreq r4, =mothership_flight
	strbeq r5, [r4]
	ldreq r4, =spaceship
	moveq r0, #0x35
	moveq r5, #0x20
	strbeq r0, [r4, #2]
	strbeq r0, [r4, #3]
	strbeq r0, [r4, #5]
	strbeq r0, [r4, #6]	
	strbeq r5, [r4, #15] ; overwrite mothership with a space to hit it
	beq mothership_update_end ; finish update if the mothership started from the left and went all the way to the end
	cmp r1, #0x39
	ldrbeq r2, [r4, #5]
	addeq r2, r2, #1
	strbeq r2, [r4, #5]
	moveq r1, #0x2F
	add r1, r1, #1
	strb r1, [r4, #6]
	b mothership_update_end
	
handle_from_right
	ldr r4, =spaceship 
	ldrb r0, [r4, #5]
	ldrb r1, [r4, #6]
	cmp r0, #0x30
	cmpeq r1, #0x32
	ldreq r4, =mothership_from_right
	moveq r5, #0x30
	strbeq r5, [r4]
	ldreq r4, =mothership_flight
	strbeq r5, [r4]
	ldreq r4, =spaceship
	moveq r0, #0x35
	moveq r5, #0x20
	strbeq r0, [r4, #2]
	strbeq r0, [r4, #3]
	strbeq r0, [r4, #5]
	strbeq r0, [r4, #6]
	strbeq r5, [r4, #15] ; overwrite mothership with a space to hit it	
	beq mothership_update_end ; finish update if the mothership started from the left and went all the way to the end
	cmp r1, #0x30
	ldrbeq r2, [r4, #5]
	addeq r2, r2, #-1
	strbeq r2, [r4, #5]
	moveq r1, #0x3A
	add r1, r1, #-1
	strb r1, [r4, #6]
	b mothership_update_end
mothership_update_end	
	ldmfd sp!, {r0-r12,lr}
	bx lr
	ltorg
	
; ------------
; gpio_init
gpio_init
	stmfd sp!, {r0-r12, lr}
	ldr r4, =IO1DIR
	ldr r6, [r4]
	ldr r5, =0x000F0000 ; bitmask for LED pins
	orr r6, r5
	str r6, [r4]
	ldr r4, =IO1CLR ; leds are active low due to voltage drop
	str r6, [r4]
	ldr r4, =IO0DIR
	ldr r6, [r4]
	ldr r5, =0x00260000 ; mask for RGB LED
	orr r6, r5
	str r6, [r4]
	ldr r4, =IO0SET ; turn off rgb
	str r6, [r4]
	ldr r4, =IO0CLR
	ldr r5, =0x00260000 ; bitmask for violet (red + blue) pin
	str r5, [r4]		; turn on violet color since game is initially paused
	ldmfd sp!, {r0-r12, lr}
	bx lr
	ltorg
; ------------
check_shield_collision_enemy
	stmfd sp!, {r0-r12, lr}
	ldr r4, =enemy_bullet_in_flight
	ldrb r5, [r4]
	cmp r5, #0x30
	beq check_shield_collision_enemy_end
	ldr r4, =e_bullet
	ldrb r0, [r4, #2]
	ldrb r1, [r4, #3]
	ldrb r2, [r4, #5]
	ldrb r3, [r4, #6]	
	mov r9, #2
	mov r10, #8
	mov r12, #0
check_shield_collision_enemy_begin
	ldr r4, =shield
	ldrb r5, [r4, r9]
	add r9, r9, #1	; increase offset by 1
	ldrb r6, [r4, r9]
	add r9, r9, #2	; increase offset by 2
	ldrb r7, [r4, r9]
	add r9, r9, #1	; increase offset by 1
	ldrb r8, [r4, r9]	
	cmp   r0, r5
	cmpeq r1, r6
	cmpeq r2, r7
	cmpeq r3, r8
	addne r9, #5 		  ; increase offset by 5 to get to the row 1 of next invader if there was no collision
	addne r10,#9	      ; increase invader char offset by 9 to get to next invader char if there was no collision
	addne r12, #1
	beq e_check_s
	cmpne r12, #15
	beq check_shield_collision_enemy_end
	bne check_shield_collision_enemy_begin ; branch back and check the next invader for collision

e_check_s
	ldrb r5, [r4, r10]
	cmp r5, #0x53 	; check if it is a strong shield
	bne e_check_S
		ldreq r4, =shield
		moveq r5, #0x73 ; 's'
		strbeq r5, [r4, r10]
		ldreq r4, =enemy_bullet_in_flight
		moveq r5,  #0x30
		strbeq r5, [r4]		
		beq check_shield_collision_enemy_end
e_check_S
	cmp r5, #0x73
	bne check_shield_collision_enemy_end
		ldreq r4, =shield
		moveq r5, #0x20
		strbeq r5, [r4, r10]
		ldreq r4, =enemy_bullet_in_flight
		moveq r5,  #0x30
		strbeq r5, [r4]			
		beq check_shield_collision_enemy_end

check_shield_collision_enemy_end
	ldmfd sp!, {r0-r12, lr}
	bx lr
	ltorg
; ------------
; r8: hold 's' for when 'S' is shot
; r9: hold ascii space for when 's' is shot
check_shield_collision
	stmfd sp!, {r0-r12, lr}
	ldr r4, =bullet_in_flight
	ldrb r5, [r4]
	cmp r5, #0x30
	beq check_shield_collision_end
	ldr r4, =bullet
	ldrb r0, [r4, #2]
	ldrb r1, [r4, #3]
	ldrb r2, [r4, #5]
	ldrb r3, [r4, #6]	
	mov r9, #2
	mov r10, #8
	mov r12, #0
check_shield_collision_begin
	ldr r4, =shield
	ldrb r5, [r4, r9]
	add r9, r9, #1	; increase offset by 1
	ldrb r6, [r4, r9]
	add r9, r9, #2	; increase offset by 2
	ldrb r7, [r4, r9]
	add r9, r9, #1	; increase offset by 1
	ldrb r8, [r4, r9]	
	cmp   r0, r5
	cmpeq r1, r6
	cmpeq r2, r7
	cmpeq r3, r8
	addne r9, #5 		  ; increase offset by 5 to get to the row 1 of next invader if there was no collision
	addne r10,#9	      ; increase invader char offset by 9 to get to next invader char if there was no collision
	addne r12, #1
	beq check_s
	cmpne r12, #15
	beq check_shield_collision_end
	bne check_shield_collision_begin ; branch back and check the next invader for collision

check_s
	ldrb r5, [r4, r10]
	cmp r5, #0x53 	; check if it is a strong shield
	bne check_S
		ldreq r4, =shield
		moveq r5, #0x73 ; 's'
		strbeq r5, [r4, r10]
		ldreq r4, =bullet_in_flight
		moveq r5,  #0x30
		strbeq r5, [r4]		
		beq check_shield_collision_end
check_S
	cmp r5, #0x73
	bne check_shield_collision_end
		ldreq r4, =shield
		moveq r5, #0x20
		strbeq r5, [r4, r10]
		ldreq r4, =bullet_in_flight
		moveq r5,  #0x30
		strbeq r5, [r4]			
		beq check_shield_collision_end

check_shield_collision_end
	ldmfd sp!, {r0-r12, lr}
	bx lr
; ------------
; r4: base address of invaders
; r5: char checking offset (sets for space)
; r6: will hold char at char offset
; r7: hold how many spaces we have found. if 35, time for level up

; this works!!!!
check_levelup
	stmfd sp!, {r0-r12, lr}
	mov r5, #8
	mov r7, #0 ; init space counter
check_levelup_begin
	ldr r4, =invader1
	ldrb r6, [r4, r5]
	cmp r6, #0x20
	bne check_levelup_end
	add r5, r5, #9
	add r7, r7, #1
	cmp r7, #35
	bleq shift_scores  ;  store indiv level scores
	cmp r7, #35
	ldreq r4, =level
	ldrbeq r2, [r4]
	addeq r2, r2, #1
	strbeq r2, [r4]
	bleq update_match_reg
	bleq reinit_aliens
	ldreq r1, =random_zero_and_one
	moveq lr, pc
	bxeq r1
	cmp r0, #0
	ldreq r4, =opposite_direction
	moveq r5, #0x30
	strbeq r5, [r4]
	cmp r0, #1
	ldreq r4, =opposite_direction
	moveq r5, #0x31
	strbeq r5, [r4]
	ldreq r4, =move
	moveq r5, #0x30
	strbeq r5, [r4]
	ldreq r4, =move1
	moveq r5, #0x30
	strbeq r5, [r4]
	ldreq r4, =moveR
	moveq r5, #0x31
	strbeq r5, [r4]
	ldreq r4, =moveD
	moveq r5, #0x31
	strbeq r5, [r4]
	ldreq r4, =moveL
	moveq r5, #0x30
	strbeq r5, [r4]
	b check_levelup_begin
check_levelup_end
	ldmfd sp!, {r0-r12, lr}
	bx lr
	ltorg

; ----------
update_match_reg
	stmfd sp!, {r0-r12, lr}
	ldr r6, =0xE000401C 
	ldr r4, =level
	ldrb r5, [r4]
	cmp r5, #0x32
	ldreq r5, =0x005DC000 ;  3hz
	streq r5, [r6]
	beq update_match_reg_end
	
	cmpne r5, #0x33
	ldreq r5, =0x00465000 ; 4 hz
	streq r5, [r6]
	beq update_match_reg_end
	
	cmpne r5, #0x34
	ldreq r5, =0x00384000 ; 5 hz
	streq r5, [r6]
	beq update_match_reg_end
	
	cmpne r5, #0x35
	ldreq r5, =0x200EE000 ; 6 hz
	streq r5, [r6]
	beq update_match_reg_end
	
	cmpne r5, #0x36
	ldreq r5, =0x00232800; 7 hz
	streq r5, [r6]
	beq update_match_reg_end
	
	cmpne r5, #0x37
	ldreq r5, =0x00232800 ; 8 hz
	streq r5, [r6]
	beq update_match_reg_end
	
	cmpne r5, #0x38
	ldreq r5, =0x001F4000 ; 9 hz
	streq r5, [r6]
	beq update_match_reg_end

	cmpne r5, #0x39
	ldreq r5, =0x001C2000 ; 10 hz. does not get faster after this point.
	streq r5, [r6]
	beq update_match_reg_end
	
update_match_reg_end
	ldmfd sp!, {r0-r12, lr}
	bx lr
	ltorg
; ----------
shift_scores
	stmfd sp!, {r0-r12, lr}
	ldr r4, =level
	ldrb r5, [r4]
	cmp r5, #0x31
	ldreq r4, =lvl2hit 
	moveq r6, #0x31
	strbeq r6, [r4]
	beq score_1
	
	cmpne r5, #0x32
	ldreq r4, =lvl3hit 
	moveq r6, #0x31
	strbeq r6, [r4]
	cmpne r5, #0x32
	beq score_2
	
	cmpne r5, #0x33
	ldreq r4, =lvl4hit 
	moveq r6, #0x31
	strbeq r6, [r4]
	beq score_3
	
	cmpne r5, #0x34
	ldreq r4, =lvl5hit 
	moveq r6, #0x31
	strbeq r6, [r4]
	beq score_4
	
	cmpne r5, #0x35
	ldreq r4, =lvl5hit 
	moveq r6, #0x31
	strbeq r6, [r4]
	beq score_5

	cmpne r5, #0x36
	ldreq r4, =lvl6hit 
	moveq r6, #0x31
	strbeq r6, [r4]
	beq score_6
	
	cmpne r5, #0x37
	ldreq r4, =lvl8hit 
	moveq r6, #0x31
	strbeq r6, [r4]
	beq score_7
	
	cmpne r5, #0x38
	ldreq r4, =lvl9hit 
	moveq r6, #0x31
	strbeq r6, [r4]
	beq score_8



score_1
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score1
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =possible_motherships1
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =motherships_killed
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =motherships_killed1
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score_from_motherships1
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =deaths
	ldrb r0, [r4, #0]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	ldr r4, =deaths1
	strb r0, [r4, #0]
	b shift_scores_end
score_2	
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]
	ldr r4, =score2
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =possible_motherships2
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =motherships_killed
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =motherships_killed2
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score_from_motherships2
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =deaths
	ldrb r0, [r4, #0]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	ldr r4, =deaths2
	strb r0, [r4, #0]
	b shift_scores_end
score_3
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score3
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =possible_motherships3
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =motherships_killed
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =motherships_killed3
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score_from_motherships3
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =deaths
	ldrb r0, [r4, #0]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	ldr r4, =deaths3
	strb r0, [r4, #0]
	b shift_scores_end	
score_4
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score4
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =possible_motherships4
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =motherships_killed
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =motherships_killed4
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score_from_motherships4
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =deaths
	ldrb r0, [r4, #0]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	ldr r4, =deaths4
	strb r0, [r4, #0]
	b shift_scores_end	
score_5
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score5
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =possible_motherships5
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =motherships_killed
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =motherships_killed5
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score_from_motherships5
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =deaths
	ldrb r0, [r4, #0]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	ldr r4, =deaths5
	strb r0, [r4, #0]
	b shift_scores_end	
score_6
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]
	ldr r4, =score6
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =possible_motherships6
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =motherships_killed
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =motherships_killed6
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score_from_motherships6
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =deaths
	ldrb r0, [r4, #0]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	ldr r4, =deaths6
	strb r0, [r4, #0]
	b shift_scores_end	
score_7
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score7
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =possible_motherships7
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =motherships_killed
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =motherships_killed7
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score_from_motherships6
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =deaths
	ldrb r0, [r4, #0]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	ldr r4, =deaths7
	strb r0, [r4, #0]
	b shift_scores_end	
score_8
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score8
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =possible_motherships8
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =motherships_killed
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =motherships_killed8
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score_from_motherships6
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =deaths
	ldrb r0, [r4, #0]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	ldr r4, =deaths8
	strb r0, [r4, #0]
	b shift_scores_end	
score_9
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score9
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =possible_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =possible_motherships9
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =motherships_killed
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =motherships_killed9
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	strb r8, [r4, #1]
	strb r8, [r4, #2]
	strb r8, [r4, #3]	
	ldr r4, =score_from_motherships6
	strb r0, [r4, #0]
	strb r1, [r4, #1]
	strb r2, [r4, #2]
	strb r3, [r4, #3]
	ldr r4, =deaths
	ldrb r0, [r4, #0]
	mov r8, #0x30	; zero out score again for seven seg and sep. levels
	strb r8, [r4, #0]
	ldr r4, =deaths9
	strb r0, [r4, #0]
	b shift_scores_end	
shift_scores_end
	ldr r4, =score
	mov r5, #0x35
	strb r5, [r4, #2]
	ldmfd sp!, {r0-r12, lr}
	bx lr
	ltorg
; ------------
update_score ; iterates score by 10
	stmfd sp!, {r0-r12, lr}
check_w_entry
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r2, #0x39
	; is r2 = 9?
	addne r2, r2, #1
	strbne r2, [r4, #2]
	bne check_hit_score_end
		moveq r2, #0x30
		strbeq r2, [r4, #2]
		cmpeq r1, #0x39
		; is r1 also = 9?
			addne r1, r1, #1
			strbne r1, [r4, #1]
			moveq r1, #0x30
			strbeq r1, [r4, #1]
			ldrbeq r0, [r4, #0]
			addeq r0, r0, #1
			strbeq r0, [r4, #0]
check_hit_score_end
	ldmfd sp!, {r0-r12, lr}
	bx lr	
	
; ------------
update_score_mship ; iterates score by 10
	stmfd sp!, {r0-r12, lr}
check_w_entry_mship
	ldr r4, =score_from_motherships
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r2, #0x39
	; is r2 = 9?
	addne r2, r2, #1
	strbne r2, [r4, #2]
	bne check_hit_score_end_mship
		moveq r2, #0x30
		strbeq r2, [r4, #2]
		cmpeq r1, #0x39
		; is r1 also = 9?
			addne r1, r1, #1
			strbne r1, [r4, #1]
			moveq r1, #0x30
			strbeq r1, [r4, #1]
			ldrbeq r0, [r4, #0]
			addeq r0, r0, #1
			strbeq r0, [r4, #0]
check_hit_score_end_mship
	ldmfd sp!, {r0-r12, lr}
	bx lr	
	
	
	
; -----------
update_score_down ; iterates score by - 10 for being shot
	stmfd sp!, {r0-r12, lr}
check_w_entry_down
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r2, #0x30
	; is r2 = 9?
	addne r2, r2, #-1
	strbne r2, [r4, #2]
	bne check_hit_score_down_end
		moveq r2, #0x39
		strbeq r2, [r4, #2]
		cmpeq r1, #0x30
		; is r1 also = 9?
			addne r1, r1, #-1
			strbne r1, [r4, #1]
			moveq r1, #0x39
			strbeq r1, [r4, #1]
			ldrbeq r0, [r4, #0]
			addeq r0, r0, #-1
			strbeq r0, [r4, #0]
check_hit_score_down_end
	ldmfd sp!, {r0-r12, lr}
	bx lr
	
	
; -----------
bullet_collied
	STMFD SP!, {lr,r0-r12}
	ldr r4, =bullet
	ldrb r0, [r4, #2]
	ldrb r1, [r4, #3]

	ldrb r2, [r4, #5]
	ldrb r3, [r4, #6]
	LDR r10, =e_bullet
	ldrb r5, [r10, #2]
	ldrb r6, [r10, #3]

	ldrb r7, [r10, #5]
	ldrb r8, [r10, #6]
	
	CMP r0, r5
	CMPEQ r1, r6 
	CMPEQ r2, r7 
	CMPEQ r3, r8  
	LDREQ r9, =tilde
	ldrbeq r5, [r9, #2]
	strbeq r0, [r9, #2]
	ldrbeq r6, [r9, #3]
	strbeq r1, [r9, #3]
	ldrbeq r7, [r9, #5]
	strbeq r2, [r9, #5]
	ldrbeq r8, [r9, #6]
	strbeq r3, [r9, #6]
	LDREQ r4, =tilde
	BLEQ  output_string
	LDMFD SP!, {lr, r0-r12}
	BX lr


; ------------
; ASCII 
; M: 0x4D O: 0x4F W: 0x57
; in memory: .[11;11f^
; r0: row 1
; r1: row 2
; r2: column 1
; r3: column 2
; r5: row 1
; r6: row 2
; r7: column 1
; r8: column 2
; r9: offset register
; r10: char offset
; r11: replacement char (null)
; comparing r0 -> r5, r1 -> r6, r2 -> r7, r3 -> r8
; ------------
check_collisions
	stmfd sp!, {r0-r12, lr}
	ldr r4, =bullet
	ldrb r0, [r4, #2]
	ldrb r1, [r4, #3]
	ldrb r2, [r4, #5]
	ldrb r3, [r4, #6]
	mov r9, #2
	mov r10, #8
	mov r11, #0x20 ; ascii space
	mov r12, #0
begin_checking_invaders
	ldr r4, =invader1
	ldrb r5, [r4, r9]
	add r9, r9, #1	; increase offset by 1
	ldrb r6, [r4, r9]
	add r9, r9, #2	; increase offset by 2
	ldrb r7, [r4, r9]
	add r9, r9, #1	; increase offset by 1
	ldrb r8, [r4, r9]
	cmp   r0, r5
	cmpeq r1, r6
	cmpeq r2, r7
	cmpeq r3, r8
	addne r9, #5 		  ; increase offset by 5 to get to the row 1 of next invader if there was no collision
	addne r10,#9	      ; increase invader char offset by 9 to get to next invader char if there was no collision
	addne r12, r12, #1
	beq check_M
	cmpne r12, #36
	beq collision_end
	bne begin_checking_invaders ; branch back and check the next invader for collision
;   If there was a collision...
	
check_M
	ldrb r5, [r4, r10]
	cmp r5, #0x4D ; check for 'M'
	bne check_O
	; If the char is an M...
		ldreq r4, =invader1
		strbeq r11, [r4, r10] ; overwrite invader char with null	
		ldreq r4, =bullet_in_flight
		moveq r5, #0x30
		strbeq r5, [r4]

		ldreq r4, =bullet
		moveq r0, #0
		strbeq r0, [r4, #2]
		strbeq r0, [r4, #3]
		strbeq r0, [r4, #5]
		strbeq r0, [r4, #6]

		bleq update_score
		bl update_score ; call twice for 20
		
		b collision_end
check_O
	cmp r5, #0x4F ; check for 'O'
	bne check_W
	; If the char is an O...
		ldreq r4, =invader1
		strbeq r11, [r4, r10] ; overwrite invader char with null	
		ldreq r4, =bullet_in_flight
		moveq r5, #0x30
		strbeq r5, [r4]
		
		
		
		ldreq r4, =bullet
		moveq r0, #0
		strbeq r0, [r4, #2]
		strbeq r0, [r4, #3]
		strbeq r0, [r4, #5]
		strbeq r0, [r4, #6]
		

		bleq update_score
		bl update_score ; call 4 times since 4*10=40
		bl update_score
		bl update_score
		b collision_end
check_W
	cmp r5, #0x57 ; check for 'W'
	
	; If the char is a 'W'...
		ldreq r4, =invader1
		strbeq r11, [r4, r10] ; overwrite invader char with null			
		ldreq r4, =bullet_in_flight
		moveq r5, #0x30
		strbeq r5, [r4]
		strbeq r5, [r4]
		ldreq r4, =bullet
		moveq r0, #0
		strbeq r0, [r4, #2]
		strbeq r0, [r4, #3]
		strbeq r0, [r4, #5]
		strbeq r0, [r4, #6]
		bleq update_score		
		b collision_end		

	
;   If there was no collision...
	
collision_end
	ldmfd sp!, {r0 - r12, lr}
	bx lr

	
check_timeout
	stmfd sp!, {r0-r12,lr}
	; Update the timer timeout label, check for two minutes being up
	ldr r4, =timeout
	ldr r6, =0x00002F58 ; 101 x 120 hz somehow gives two minutes
	ldr r5, [r4]
	cmp r5, r6
	add r5, r5, #1
	str r5, [r4]
	
	beq lab7_quit
	
	cmp r0, #0x39
	moveq r0, #0x30
	strbeq r0, [r4, #0]
	
	ldmfd sp!, {r0-r12,lr}
	bx lr
	
	
; --------
enemies_fire
	stmfd sp!, {r0-r12, lr}
enemies_fire_begin
	ldr r4, =enemy_bullet_in_flight
	ldrb r5, [r4]
	cmp r5, #0x31
	beq enemies_fire_end
	ldr r1, =random_column
	mov lr, pc
	bx r1
	ldr r4, =invader1
check_bottom_init
	mov r3, #9
	mov r5, #28
	mul r2, r5, r3
	add r2, r2, #-1
	add r2, r2, #9
random_bottom_select
	cmp r0, #0
	addne r2, r2, #9
	subne r0, r0, #1
	bne random_bottom_select
check_bottom_row ; 06;07



	ldrb r5, [r4, r2]
	cmp r5, #0x20 ; check if the loaded random invader was a space or not
	moveq r3, #5
	beq check_row_4_init
	; If random invader was not a space... 
	add r2, r2, #-2 ; decrement r2 by one will bring us to column pos 2
	ldrb r0, [r4, r2]
	add r2, r2, #-1 ; decrement r2 by one again will bring us to column pos 1
	ldrb r1, [r4, r2]
	add r2, r2, #-2
	ldrb r3, [r4, r2]
	cmp r3, #0x39
	subeq r3, r3, #1
	add r2, r2, #-1 
	ldrb r5, [r4, r2]
	add r3, r3, #1
	; at this point, we have r5r3;r1r0 for ansi position
	mov r2, #2 ; reinit r2 to 0
	; set intial enemy bullet row and column based on position of enemy which is firing
	ldr r4, =e_bullet
	strb r5, [r4, r2]
	add r2, r2, #1
	strb r3, [r4, r2]
	add r2, r2, #2
	strb r1, [r4, r2]
	add r2, r2, #1
	strb r0, [r4, r2]
	ldr r4, =enemy_bullet_in_flight
	mov r5, #0x31
	strb r5, [r4]
	b enemies_fire_end
check_row_4_init	; after we've obtained a random column
	sub r2, r2, #63	; start from the bottom up and find a valid invader to fire from
	sub r3, r3, #1
	cmp r3, #0
	beq enemies_fire_end
	ldrb r5, [r4, r2]
	cmp r5, #0x20
	bne check_bottom_row
	beq check_row_4_init
enemies_fire_end
	ldmfd sp!, {r0-r12, lr}
	bx lr
	
	
; ----------
enemy_bullet_handler
	stmfd sp!, {r0-r12, lr}
	ldr r4, =enemy_bullet_in_flight
	ldrb r5, [r4]
	cmp r5, #0x31
	bne enemy_bullet_handler_end
	ldr r4, =e_bullet
	ldrb r0, [r4, #2]
	ldrb r1, [r4, #3]
	cmp r0, #0x31
	cmpeq r1, #0x36
	ldreq r4, =enemy_bullet_in_flight
	moveq r5, #0x30
	strbeq r5, [r4]
	beq enemy_bullet_handler_end
	cmp r1, #0x39
	addeq r0, r0, #1
	strbeq r0, [r4, #2]
	moveq r1, #0x30
	strbeq r1, [r4, #3]
	addne r1, r1, #1
	strb r1, [r4, #3]
	beq enemy_bullet_handler_end	
enemy_bullet_handler_end	
	ldmfd sp!, {r0-r12, lr}
	bx lr
	
; ----------
check_for_some_bullet_on_bullet_action
	stmfd sp!, {r0-r12, lr}
	ldr r4, =bullet
	ldrb r0, [r4, #2]
	ldrb r1, [r4, #3]
	ldrb r2, [r4, #5]
	ldrb r3, [r4, #6]
	ldr r4, =e_bullet
	ldrb r5, [r4, #2]
	ldrb r6, [r4, #3]
	ldrb r7, [r4, #5]
	ldrb r8, [r4, #6]
	cmp r0, r5
	cmpeq r1, r6
	cmpeq r2, r7
	cmpeq r3, r8
	ldreq r4, =tilde
	strbeq r0, [r4, #2]
	strbeq r1, [r4, #3]
	strbeq r2, [r4, #5]
	strbeq r3, [r4, #6]
	bleq output_string
	ldmfd sp!, {r0-r12, lr}
	bx lr
	
; ----------
enemy_bullet_collision_handler
	stmfd sp!, {r0-r12, lr}
	ldr r4, =enemy_bullet_in_flight
	ldrb r5, [r4]
	cmp r5, #0x31
	bne enemy_bullet_collision_handler_end
	ldr r4, =e_bullet
	ldrb r0, [r4, #2]
	ldrb r1, [r4, #3]
	ldrb r2, [r4, #5]
	ldrb r3, [r4, #6]
	ldr r4, =player
	ldrb r5, [r4, #2]
	ldrb r6, [r4, #3]
	ldrb r7, [r4, #5]
	ldrb r8, [r4, #6]
	cmp r0, r5
	cmpeq r1, r6
	cmpeq r2, r7
	cmpeq r3, r8
	ldreq r4, =enemy_bullet_in_flight
	moveq r5, #0x30
	strbeq r5, [r4]
	bleq player_was_shot_gpio
	b enemy_bullet_collision_handler_end
enemy_bullet_collision_handler_end
	ldmfd sp!, {r0-r12, lr}
	bx lr
	
	
; ----------
player_was_shot_gpio
	stmfd sp!, {r0-r12, lr}

	ldr r4, =deaths
	ldrb r5, [r4]
	add r5, r5, #1
	strb r5, [r4]
	ldr r4, =lives
	ldrb r5, [r4]
	cmp r5, #0x31 ; only one life left
	ldreq r4, =IO1SET
	ldreq r5, =0x00010000
	streq r5, [r4] ; turn next off
	beq lab7_quit
	addne r5, r5, #-1
	strb r5, [r4]
	ldr r4,= IO0SET
	ldr r5, =0x00260000 ; clear rgb led
	str r5, [r4]
	ldr r4, =IO0CLR
	ldr r5, =0x00020000 ; flash rbg led red for a split second since we were shot
	str r5, [r4]

	
	ldr r4, =lives
	ldrb r5, [r4]
	cmp r5, #0x33
	ldreq r4, =IO1SET
	ldreq r5, =0x00080000
	streq r5, [r4] ; turn rightmost led off
	cmp r5, #0x32
	ldreq r4, =IO1SET
	ldreq r5, =0x00040000
	streq r5, [r4] ; turn next off
	str r5, [r4]
	cmp r5, #0x31
	ldreq r4, =IO1SET
	ldreq r5, =0x00020000
	streq r5, [r4] ; turn next off
	str r5, [r4]
	ldr r4, =score
	ldrb r0, [r4, #0]
	ldrb r1, [r4, #1]
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	cmp r0, #0x30
	cmpeq r1, #0x30 ; if both r0 and r1 are 0 then we have less than 100 points
	movne r11, #9
	bne minus_100
	moveq r0, #0x30		; since we had < 100 pts set score back to 0. no negative score.
	strbeq r0, [r4, #0]
	strbeq r0, [r4, #1]
	strbeq r0, [r4, #2]
	strbeq r0, [r4, #3]
	beq end_shot

minus_100
	bl update_score_down
	cmp r11, #0
	addne r11, r11, #-1
	bne minus_100
end_shot
	ldmfd sp!, {r0-r12, lr}
	bx lr
; ----------	
player_bullet_handler
	stmfd sp!, {r0-r12, lr}
	ldr r4, =bullet_in_flight
	ldrb r5, [r4]
	cmp r5, #0x31
	bne player_bullet_handler_end
	ldr r4, =bullet ; check if hit top of board
	ldrb r5, [r4, #3]
	ldrb r6, [r4, #2]
	cmp r5, #0x31
	cmpeq r6, #0x30
	ldreq r4, =bullet_in_flight
	moveq r5, #0x30
	strbeq r5, [r4]
	beq player_bullet_handler_end
	ldr r4, =bullet
	ldrb r5, [r4, #3]
	cmp r5, #0x30
	ldrbeq r6, [r4, #2]
	addeq r6, r6, #-1;
	strbeq r6, [r4, #2]
	moveq r5, #0x3A
	add r5, r5, #-1
	strb r5, [r4, #3]
	ldr r4, =bullet
	bl output_string
player_bullet_handler_end
	ldmfd sp!, {r0-r12, lr}
	bx lr
	

FIQ_Handler
	STMFD SP!, {r0-r12, lr}   ; Save registers 
; 120 hz timer
Timer1
	LDR r0, =0xE0008000
	LDR r1, [r0]
	TST r1, #2
	BEQ Timer0
	
	; check if paused
	LDR r0, =prompt_started
    LDRB r1, [r0]
    CMP r1, #0x30
    BEQ Timer1_Exit
	
	
	
	; check if two minutes has been hit on each interrupt
	bl check_timeout
	

	LDR r4, = promt_status2	; promt_status2 holds that value of which digit we should be strobing currently
	LDRB r6, [r4]
	CMP r6, #0x30
	BEQ L1
	BNE L6
L1
	LDR r1, =score ; this holds the user entered char to be displayed on digit 0 of the 7seg
	LDRB r0, [r1, #0]
	BL htoi	; we send the entered char (arg r0) to htoi to be converted to int equivalent
	LDR r1, =IO0SET 
	LDR r2, =0x00000038
	STR r2, [r1] ; here we set all the digits that we do not currently care about to high, which turns them off since they are active low
	LDR r1, =IO0CLR
	LDR r2, =0x00000004 ; digit0 [0,1,2,3] ; here we turn on the one digit we do care about
	STR r2, [r1] ; turn digit one on
	BL  display_digit_on_7_seg
	MOV r6, #0x31 
	STRB r6, [r4]	; here we are incrementing the value in promt_status2 by one so the next time the timer interrupt handler is called, we're strobing on the next digit
	B Timer1_Exit
	
L6
	; strobe digit 1
	LDR r4, = promt_status2
	LDRB r6, [r4]
	CMP r6 , #0x31
	BEQ L2
	BNE L5
L2
	LDR r1, =score
	LDRB r0, [r1, #1]
	BL htoi
	LDR r1, =IO0SET 
	LDR r2, =0x00000034    ; this point digit 0 get clearr
	STR r2, [r1]
	LDR r1, =IO0CLR
	LDR r2, =0x00000008 ; digit 1 (2^3) [0,1,2,3]
	STR r2, [r1]    ; previous digit get displayed
	BL display_digit_on_7_seg
	MOV r6, #0x32
	STRB r6, [r4]
	B Timer1_Exit
	
L5
	;strobe digit 2
	LDR r4, = promt_status2
	LDRB r6, [r4]
	CMP r6 , #0x32
	BEQ L3
	BNE L7
L3
	LDR r1, =score
	LDRB r0, [r1, #2]
	BL htoi
	LDR r1, =IO0SET 
	LDR r2, =0x0000002C
	STR r2, [r1]
	LDR r1, =IO0CLR 
	LDR r2, =0x00000010 ; digit 2 (2^4) [0,1,2,3]
	STR r2, [r1]
	BL display_digit_on_7_seg
	MOV r6, #0x33
	STRB r6, [r4]
	B Timer1_Exit
L7
	; strobe digit 3, final digit
	LDR r4, = promt_status2
	LDRB r6, [r4]
	CMP r6 , #0x33
	BEQ L4
	BNE Timer1_Exit
L4
	LDR r1, =score
	LDRB r0, [r1, #3]
	BL htoi
	LDR r1, =IO0SET 
	LDR r2, =0x0000001C
	STR r2, [r1]
	LDR r1, =IO0CLR
	LDR r2, =0x00000020 ; digit 3 (2^5) [0,1,2,3]
	STR r2, [r1]
	MOV r6, #0x30
	STRB r6, [r4]
	BL display_digit_on_7_seg
	
Timer1_Exit 
	ldr r0, =0xE0008000
	ldr r1, [r0]
	orr r1, #2
	str r1, [r0]
	b FIQ_Exit
	


;timer 0 interrupt handler
; gets called when the # of clock rising edges = value we set in our match register
Timer0
	LDR r0, =0xE0004000 ; t0 interrupt register
	LDR r1, [r0]
	TST r1, #2	; check if it's a pending timer interrupt or not
	BEQ UART0	; if not, go to the UART handler and check there


	; check if paused
	LDR r0, =prompt_started
    LDRB r1, [r0]
    CMP r1, #0x30
    BEQ Timer0_Exit
	
	
	
	

	
	ldr r4,= IO0SET
	ldr r5, =0x00260000 ; clear rgb led
	str r5, [r4]
	ldr r4, =IO0CLR
	ldr r5, =0x00200000 ; turn rgb red
	str r5, [r4]
	
	bl check_collisions
	bl enemies_fire
;	******** oppostide direction movement undr construction*****************
    LDR r4, =opposite_direction
    LDRB r3, [r4]
    CMP r3, #0x31
    BEQ left_start
    BNE Right_start
    
left_start
    LDR r4, =move1;
    LDRB r3, [r4];
    CMP r3,#0x30
    BEQ left
	LDR r4, =opposite_down
   LDRB r3, [r4];
    CMP r3, #0x31
    BEQ Down
    BNE Right_start
    
; if the prompt is high then move otherwise exit

;***************invader movement **************************************************
Right_start

    LDR r4, =moveR
    LDRB r3, [r4]
    CMP r3,#0x31
    ANDEQ r7,r7,#0
    ANDEQ r9,r9,#0
    ADDEQ r7,r7, #6            ; starting position 
    ANDEQ r10,r10,#0
    BEQ MOVE_right
    BNE Down


MOVE_right
    CMP r9, #1
    ADDEQ r7,r7, #9
    MOV r9, #1
    LDR r4, =invader1
    LDRB r3, [r4, r7]
    AND r2 , r2, #0
    LDRB r3, [r4 , r7]
    CMP r3, #0x39
    ADDEQ r2, r2, #1
    SUBEQ r7,r7,#1
    LDRBEQ r1, [r4, r7]
    ADDEQ r7,r7,#1
    CMPEQ r1, #0x31
    ADDEQ r2,r2,#1

    ; special case of 10
    ADD r3,r3, #1
    CMP r3, #0x3A
    SUBEQ r7,r7,#1
    LDRBEQ r1, [r4 , r7]
    MOVEQ r1, #0x31
    STRBEQ r1, [r4, r7]
    MOVEQ r3, #0x30
    ADDEQ r7,r7,#1
    STRB r3, [r4, r7]
    
    ; special case of 20 
    CMP r2, #2
    SUBEQ r7,r7,#1
    LDRBEQ r1, [r4 , r7]
    MOVEQ r1, #0x32
    STRBEQ r1, [r4, r7]
    MOVEQ r3, #0x30
    ADDEQ r7,r7,#1
    STRBEQ r3, [r4, r7]
 
    ADD r10, r10, #1
    CMP r10, #0x24   ; this will increment all the ivader coloum
    
    BNE MOVE_right
    BEQ exit      ; now all 35 invader are moved once to right
    
exit   
    LDR r4, =invader1
    LDRB r3, [r4, #6]
    CMP r3, #0x36     ; as the first enemy get to coloum  17 it chech if its 7 stop moveing to right and then move to down
    LDRBEQ r3, [r4, #5]
    CMPEQ r3, #0x31          ; as the most right invader reaches 16 resrt everything 
    LDREQ r4, =moveR   ; set it 0 so next refresh it dont move to right
    MOVEQ r3, #0x30   ; setting the movement of right by 0
    STRBEQ r3, [r4]
    ADDEQ r0, r0, #1     ; in order to print again 
    
    LDREQ r4, =moveD   ; down promp tset to active high
    LDRBEQ r3, [r4]
    MOVEQ  r3, #0x31
    STRBEQ r3, [r4]
    
    LDREQ r3, =move1  
    LDRBEQ r2, [r3]; lefty movement prompt is ste high ;
    MOVEQ r2, #0x30
    STRBEQ  r2, [r3]
	
    LDREQ r4, = opposite_down
    MOVEQ r3, #0x31
    STRBEQ r3, [r4]
   
    LDR r4, =opposite_direction
	LDRB r3, [r4]
	CMP r3, #0x31
	LDREQ r3, =move1  
    LDRBEQ r2, [r3]; lefty movement prompt is ste high ;
    MOVEQ r2, #0x31
    STRBEQ  r2, [r3]
	LDR r4, =invader1
	LDRB r3, [r4, #3]
	CMP r3, #0x38
	LDREQ r4, =opposite_down
	MOVEQ r3, #0x30
	STRBEQ r3, [r4]
	B print
 ; is the point where we clear the board and print enemies 
Down
    LDR r4, =invader1    ; this for to stop to enemy movement above the shield
    LDRB r3, [r4, #3]
    CMP r3, #0x38
    LDREQ r4, =moveD
    MOVEQ r3, #0x30
    STRBEQ r3, [r4]
	LDREQ r4, =move1
	STRBEQ r3, [r4]
	AND r6,r6,#0
    AND r7,r7,#0    ; rest everything
    AND r9,r9,#0
    AND r0,r0, #0
    ADD r7,r7,#3      ; if going down set r7 to 3 , if going left or right set r7 to 6
    AND r10,r10,#0
    LDR r4, =moveD
    LDRB r3, [r4]
    CMP  r3, #0x31
    BEQ MOVE_down
    BNE left
    
MOVE_down
    CMP r9, #0X32
    ADDEQ r7,r7, #9
    MOV r9, #0x32
    LDR r4, =invader1
    LDRB r3, [r4, r7]
    ADD r3,r3,#1
    CMP r3, #0x3A
    SUBEQ r7,r7,#1
    LDRBEQ r3, [r4 , r7]
    MOVEQ r1, #0x31
    STRBEQ r1, [r4, r7]
    MOVEQ r3, #0x30
    ADDEQ r7,r7,#1
    STRB r3, [r4, r7]
    ADD r10,r10,#1
    CMP r10, #0x24
    BNE MOVE_down
    BEQ exit2
; should move just one this is point where it get messed up 
exit2

	LDR r4, =opposite_down
	MOV r0, #0x30
	STRB r0,[r4]
    LDR r4, =moveD
    MOV r3, #0x30
    STRB r3, [r4]                 ; setting right movement to active high
    LDR r4, =invader1
    LDRB r2, [r4, #3]
    
    LDR r3, =moveR 
    CMP r2, #0x35                    ; if it was move to 5th 
    MOVEQ r0, #0x31
    STRBEQ r0,[r3]
    
    LDR r5 ,=move1
    CMP r2, #0x34                    ; if it was move to 5th 
    MOVEQ r0, #0x30
    STRBEQ r0,[r5]
		
	LDR r5, =move1
    CMP r2, #0x36               ; moving left on the 6th line
    MOVEQ r0, #0x30
    STRBEQ r0,[r5]
    
	LDR r3, =moveR
    CMP r2, #0x37               ; moving left on the 6th line
    MOVEQ r0, #0x31
    STRBEQ r0,[r3]
    
	CMP r2, #0x37               ; moving left on the 6th line
    MOVEQ r0, #0x30
    STRBEQ r0,[r5]
	
    LDR r6, =opposite_direction
    LDRB r3,[r6]
    CMP r3, #0x31
	
	BNE print

	LDREQ r4, =invader1
    LDRBEQ r2, [r4, #3]
   
	LDR r5 ,=move1
    CMP r2, #0x34                    ; if it was move to 5th 
    MOVEQ r0, #0x31
    STRBEQ r0,[r5]
	
    LDR r3 ,=moveR
    CMP r2, #0x34                    ; if it was move to 5th 
    MOVEQ r0, #0x31
    STRBEQ r0,[r5]
	
    CMP r2, #0x36                    ; if it was move to 5th 
    MOVEQ r0, #0x31
    STRBEQ r0,[r5]
	

    CMP r2, #0x35                    ; if it was move to 5th 
    MOVEQ r0, #0x30
    STRBEQ r0,[r5]
    
    CMP r2, #0x37                    ; if it was move to 5th 
    MOVEQ r0, #0x30
    STRBEQ r0,[r5]
  
	CMP r2, #0x38               ; moving left on the 6th line
    MOVEQ r0, #0x31
    STRBEQ r0,[r5]
	B print
                    ; if it exit then down is never printed , if i print can t get to left after refresh timer
    
left
    LDR r3, =move1
    LDRB r4, [r3]
    CMP  r4, #0x30
	AND r6,r6, #0
	AND r7,r7,#0
    AND r9,r9,#0
    ADD r7,r7,#6
    AND r10,r10,#0
    BEQ MOVE_left
    BNE exit3
    
MOVE_left
    AND r10,r10, #0
    LDR r4 , =move       ; once first invader is moved then increment the postion to  move
    LDRB r3, [r4]
    CMP r3, #0x31
    ADDEQ r7,r7, #9
    LDR r4, =invader1
    LDRB r3, [r4, r7]
    LDRB r1, [r4 , r7]
    sub  r7,r7,#1
    LDRB r2, [r4 , r7]
    CMP r2, #0x32              ; special case of 20 detected
    ADDEQ r10,r10,#1
    CMP r1, #0x30
    ADDEQ r10,r10,#1
    add r7,r7, #1
    
    SUB r3, r3, #1
    LDRB r1, [r4 , r7]
    CMP r1, #0x32              ; special case of 10 is done here
    ADDEQ r0,r0,#1
    CMP r3, #0x2F
    SUBEQ r7, r7, #1
    LDRBEQ r1, [r4 , r7]
    MOVEQ r1, #0x30
    STRBEQ r1, [r4, r7]
    MOVEQ r3, #0x39
    ADDEQ r7,r7,#1
    STRB r3, [r4, r7]
    
    CMP r10,#2                   ; take care of case 20
    MOVEQ r1, #0x39
    STRBEQ r1, [r4, r7]
    SUBEQ r7,r7,#1
    MOVEQ r2, #0x31
    STRBEQ r2, [r4,r7]
    ADDEQ r7,r7,#1
    LDR r4, =move
    MOV r3, #0x31
    STRB r3, [r4]
    ADD r6, r6, #1
    CMP r6, #0x24
    BNE MOVE_left
    BEQ exit3
    
exit3

    LDR r4, =invader1
    LDRB r3, [r4, #6]
    CMP r3, #0x32                  ; as  the inavder reached 02 then set the down high and from dow right is set high 
    LDRBEQ r3, [r4, #5]
    CMPEQ r3, #0x30             ; left movement has reach it limits 
    ;LDRBEQ r3, [r4, #5]
    ;CMPEQ r3, #0x30  ; while moving left
   
    LDREQ r4, =move1
    MOVEQ r1, #0x31   ; setting left moveement to low 
    STRBEQ r1, [r4]
    
    LDREQ r4, =move     ; reset the prompt used avbove
    MOVEQ r3, #0x30
    STRBEQ r3, [r4]
    
    LDREQ r4, = opposite_down
    MOVEQ r3, #0x31
    STRBEQ r3, [r4]

    LDREQ r4, =moveD
    MOVEQ  r3, #0x31    ; down movement is set to high 
    STRBEQ r3, [r4]
    
    AND r1,r1,#0    ; clear r1 for compare
    LDR r4, =invader1
    LDRB r3,[r4, #3]
    CMP r3, #0x38 
	LDREQ r4, =opposite_down
	MOVEQ r3, #0x30
	STRBEQ r3, [r4]; line reahced 8
    LDREQ r2, =move
    LDRBEQ r1,[r2]
    CMP r1, #0x30
    LDREQ r4, =moveR                ; start moving just left and right
    MOVEQ r3, #0x31
    STRBEQ r3,[r4]
    
    LDR r4, =move                      ; rest prompt if not invader is at 02
    MOV r3, #0x30
    STRB r3, [r4]
    

     B print


print
	
		
	; check for bullet collisions on every timer interrupt
	
	
	ldr r4, =mothership_flight
	ldrb r5, [r4]
	cmp r5, #0x30
	ldreq r4, =mothership_timer_count
	ldrbeq r5, [r4]
	cmpeq r5, #0x39
	moveq r5, #0x30
	strbeq r5, [r4]
	bleq mothership_init
	addne r5, r5, #1
	strbne r5, [r4]




	; output player
	ldr r4, =player
	bl output_string


	


	

	; check if it's time to level up after each collision
	bl check_levelup


	  
Timer0Int_Draw
    ; clear screen
    LDR r4, =prompt_clr
    BL output_string
	; reprint board
    LDR r4, =prompt_board_f
	BL output_string	

	
	ldr r4, =prompt_color
	bl output_string
	; reprint invaders
	ldr r4, =invader1
	bl output_string
	
	ldr r4, =color_end
	bl output_string


	ldr r4, =prompt_color1
	bl output_string
	
	; reprint what is left of shields
	ldr r4, =shield
	bl output_string
	
	ldr r4, =color_end
	bl output_string
	
	ldr r4, =currlevel
	bl output_string
	ldr r4, =level
	bl output_string
	ldr r4, =currscore
	bl output_string
	ldr r4, =score
	bl output_string
	ldr r4, =currlives
	bl output_string
	ldr r4, =lives
	bl output_string
	ldr r4, =currmothcount
	bl output_string
	ldr r4, =possible_motherships
	bl output_string
	ldr r4, =currmothkilled
	bl output_string
	ldr r4, =motherships_killed
	bl output_string
	ldr r4, =currmothscore
	bl output_string
	ldr r4, =score_from_motherships
	bl output_string



	LDR r0, =prompt_started
    LDRB r1, [r0]
    CMP r1, #0x30
    BEQ Timer0_Exit

	;bl enemies_fire

	bl check_collisions
		; print bullet
	bl player_bullet_handler
	
	;bl check_for_some_bullet_on_bullet_action
	bl bullet_collied
		; also check shield collisions
	ldr r4, =e_bullet
	bl output_string		
	bl check_shield_collision
	bl check_shield_collision_enemy
	
	bl enemy_bullet_collision_handler
	bl enemy_bullet_handler

	ldr r4, =prompt_color2
	bl output_string
	ldr r4, =player
	bl output_string
	
	ldr r4, =color_end
	bl output_string
			; update mothership and print it
	bl mothership_update
	
		bl check_collisions
	ldr r4, =spaceship
	bl output_string

	


	
	
	
Timer0_Exit
    ; Clear Interrupt
	LDR r0, =0xE0004000  	; get T0InterruptRegister
	LDR r1, [r0]			; by writing 1 to bit 1
	ORR r1, #2              ; Clear interrupt for MR1
	STR r1, [r0]            ; by writing to bit 1
	B FIQ_Exit


	
	
UART0 
	LDR r0, =0xE000C008 ;uart interrupt i.d. register
	LDR r1, [r0] ; load contents of i.d. register
	TST r1, #1 ; 0 = pending interrupts, 1 = no pending interrupts
	BNE EINT1 ; branch to button interrupt check
	
	ldr r4, =gameover_flag
	ldrb r5, [r4]
	cmp r5, #0x31
	beq uart_interrupt_handler_end
	STMFD SP!, {r0-r12, lr}   ; Save registers 
	BL read_character ; read char in from putty
	MOV r6, r0 ; hold it in r6
	
	LDR r0, =prompt_status ; load status prompt
	LDRB r4, [r0] ; load contents of status prompt
	BIC r4, r4, #0xFFFFFF00 ; clear everything except the stuff we care about
	CMP r4, #0x30 ; check for 0
	BEQ uart_interrupt_handler_end ; go to end if 0
	MOV r0, r6 ; put char back in r0 if not 0

; move player left
UART0_a
	CMP r0, #0x61
	BNE UART0_d
	ldr r4, =player
	ldrb r0, [r4, #6]
	ldrb r1, [r4, #5]
	cmp r0, #0x32	;	if the player is already as far left as it can go, ignore more a presses
	cmpeq r1, #0x30 ;
	beq uart_interrupt_handler_end
	LDR r4, =player
	LDRB r0, [r4, #6]
	cmp r0, #0x30
	ldrbeq r1, [r4, #5]
	addeq r1, r1, #-1
	strbeq r1, [r4, #5]
	moveq r0, #0x39
	strbeq r0, [r4, #6]
	addne r0, r0, #-1
	strbne r0, [r4, #6]
	B uart_interrupt_handler_end
; move player right
UART0_d
	CMP r0, #0x64
	BNE uart0_space
	LDR r4, =player
	ldrb r0, [r4, #6]
	ldrb r1, [r4, #5]
	cmp r0, #0x32	;	if the player is already as far right as it can go, ignore more d presses
	cmpeq r1, #0x32 ;
	beq uart_interrupt_handler_end
	LDRB r0, [r4, #6]
	cmp r0, #0x39
	ldrbeq r1, [r4, #5]
	addeq r1, r1, #1
	strbeq r1, [r4, #5]
	moveq r0, #0x30
	strbeq r0, [r4, #6]
	addne r0, r0, #1
	strbne r0, [r4, #6]
	B uart_interrupt_handler_end
uart0_space
	ldr r4, =bullet_in_flight
	ldrb r5, [r4]
	cmp r5, #0x31
	beq uart_interrupt_handler_end
	cmp r0, #0x20
	bne uart0_q
	ldr r4,= IO0SET
	ldr r5, =0x00260000 ; clear rgb led
	str r5, [r4]
	ldr r4, =IO0CLR
	ldr r5, =0x00020000 ; flash rbg led red for a split second since we were shot
	str r5, [r4]
	ldr r4, =bullet_in_flight
	mov r5, #0x31
	strb r5, [r4]
	bne uart_interrupt_handler_end
	; get both row and column pos of player for bullet
	ldr r0, =player
	ldrb r1, [r0, #5]
	ldrb r3, [r0, #6]
	ldrb r8, [r0, #2]
	ldrb r9, [r0, #3]
	ldr r2, =bullet
	strb r1, [r2, #5]
	strb r3, [r2, #6]
	strb r8, [r2, #2]
	strb r9, [r2, #3]
	b uart_interrupt_handler_end
uart0_q
	cmp r0, #0x71
	bne uart0_n
	ldr r4, =gameover_flag
	ldrb r5, [r4]
	cmp r5, #0x31
	bne uart_interrupt_handler_end
	beq lab6_really_quit
	
uart0_n 
	cmp r0, #0x6E
	bne uart_interrupt_handler_end
		
uart_interrupt_handler_end
	LDMFD SP!, {r0-r12, lr}
	B FIQ_Exit
	
EINT1			; Check for EINT1 interrupt
		LDR r0, =0xE01FC140
		LDR r1, [r0]
		TST r1, #2		
		BEQ FIQ_Exit
	
		STMFD SP!, {r0-r12, lr}   ; Save registers 
			
		; Push button EINT1 Handling Code goes here
		; should turn 7 seg on and off without losing the previous value displayed
		LDR r0, =prompt_started
		LDRB r1, [r0]
		CMP r1, #0x30
		MOVEQ r1, #0x31
		MOVNE r1, #0x30
		STRBEQ r1, [r0]
		STRBNE r1, [r0]

		
		LDR r0, =prompt_status
		LDRB r6, [r0]
		CMP r6, #0x30
		BNE turn_display_off
		
		
		MOV r6, #0x31
		STRB r6, [r0] ; replace 0 with a 1
		; continue button press handler here
		LDR r0, =prompt_status
		LDRB r6, [r0]
		
		; tell user how to use shit again since interrupt is about to end
		LDR r1, =0xE002800C ;io0clr
		LDR r2, =0x0000003C ; turn all digits on
		STR r2, [r1] ; set digits active low. turns them on.
		
	
		;LDR r4, =unpaused
		;BL output_string
		ldr r4, =IO0SET
		ldr r5, =0x00260000
		str r5, [r4]
		ldr r4, =IO0CLR
		ldr r5, =0x00200000
		str r5, [r4] ; turn rgb green since game is unpaused
		B turn_display_on
		
	
turn_display_off
		LDR r0, =prompt_status
		MOV r1, #0x30
		STRB r1, [r0]
		LDR r4, =paused
		BL output_string
		ldr r4,= IO0SET
		ldr r5, =0x00260000
		str r5, [r4]
		ldr r4, =IO0CLR
		ldr r5, =0x00040000 ; turn rgb blue
		str r5, [r4]
		BL turn_7_seg_off
		
turn_display_on
		LDMFD SP!, {r0-r12, lr}   ; Restore registers
		ORR r1, r1, #2		; Clear Interrupt
		STR r1, [r0]
	
FIQ_Exit
	LDMFD SP!, {r0-r12, lr}
	SUBS pc, lr, #4

	END