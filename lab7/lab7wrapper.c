#include<stdlib.h>
#include "space_invaders.h"
extern int lab7(void);
extern int pin_connect_block_setup_for_uart0(void);
extern int uart_init(void);
extern int interrupt_init(void);

const char* time = "\033[47m\033[34mYou have two minutes for the entire game. If your two minutes run out, the game will end prematurely.\n\n\rThe two minute timer is paused while the game is paused.\n\n\r";
const char* clear = "\033[2J\r\033[00;00f";
const char* welcome = "\033[33m\033[4mWelcome to Space Invaders!\n\n\r\033[0m";
const char* dirs = "\033[37m\033[4mDirections:\033[0m\n\n\r\033[0;91mYour goal is to destroy all the aliens! If you can do so, you will advance to the next level. You have four lives. If you're shot, you will lose one life and also 100 points.\n\n\rIf you are shot while having less than 100 points total on a level, your score will be reset to 0. There is no negative score.\n\n\rTake cover under the shields. An 'S' can be shot once before turning into an 's'. An 's' can only be shot once before you lose it's protection forever!\n\n\rAim your shots well. You can only shoot one bullet at a time. If you miss, you have to wait until your bullet flies off the screen to fire again. This could mean precious seconds shaved off of your time limit.\n\n\r";
const char* graders = "\033[0;92mFor graders: If you find it difficult to finish level one before the two minute timer runs out, you can go into lab7.s, cntl+F for \"bl check_timeout\" and comment that line out. That will disable the two minute game over check. This may prove to be helpful in grading things like checking level up, shooting motherships and seeing that multiple level statstics can be displayed at the end game.\n\n\r";
const char* controls = "\033[0;92m\033[4mControls:\033[0m\n\n\r\033[0;94mPressing 'a' will move you to the left. 'd' will move you to the right. Spacebar will fire a shot. 'q' will end the game prematurely. The P0.14 interrupt button pauses and unpauses the game. Press it now to start playing.\n\n\r\033[0m";
int main() {
	pin_connect_block_setup_for_uart0();
	//uart_init();
	serial_init();
	//interrupt_init();
	print_string_to_putty(clear);
	print_string_to_putty(welcome);
	print_string_to_putty(dirs);
	print_string_to_putty(time);
	print_string_to_putty(controls);
	print_string_to_putty(graders);
	lab7();
}
