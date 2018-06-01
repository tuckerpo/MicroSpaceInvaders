#include <LPC213X.H>
#include<stdlib.h>

unsigned enemy_refresh_count = 0;

extern int output_character(char s);

const char* clear_screen = "\033[2J";


// does exactly what it's name implies
void serial_init(void)
{
	  	/* 8-bit word length, 1 stop bit, no parity,  */
	  	/* Disable break control                      */
	  	/* Enable divisor latch access                */
   		//	*(volatile unsigned *)(0xE000C00C) = 131; 
			U0LCR = 131;
	  	/* Set lower divisor latch for 9,600 baud */
			//*(volatile unsigned *)(0xE000C000) = 10; 
			// note U0DLL = 10 makes for 115200 baud, 0 makes for 9.6k baud
			U0DLL = 10;
	  	/* Set upper divisor latch for 9,600 baud */
			//*(volatile unsigned *)(0xE000C004) = 0; 
			U0DLM = 0;
	  	/* 8-bit word length, 1 stop bit, no parity,  */
	  	/* Disable break control                      */
	  	/* Disable divisor latch access               */
	  	//	*(volatile unsigned *)(0xE000C00C) = 3;
			U0LCR = 3;
}

// finds the length of a string to be output since string.h<strlen()> include is not allowed
size_t find_length(const char* str) {

        const char *s;

        for (s = str; *s; ++s);
        return (s - str);
}


/* Prints to PuTTy using the uart on LPC2138 
PARAMS: char* to be printed
RETURN: void
DEPENDENCIES: find_length(char*s )
*/
void print_string_to_putty(const char* s) {
		int i;
		for (i = 0; i < find_length(s); i++) {
			if (s[i] != '\0') { output_character(s[i]); }
		}
}


// random number generator with new seed upon compilation
// only depends on stdlib.h
int rng_spaceship_score(void) {
		return rand() % (3 + 1 - 1) + 1;
}


void print_board(void) {
		print_string_to_putty("\033[1;1f\r|---------------------|\r\n");
		for (unsigned n = 0; n < 15; n++) {
			print_string_to_putty("|                     |\r\n");
		}
		print_string_to_putty("|---------------------|");
}

int random_zero_and_one(void) {
		return rand() % (1 + 1 - 0) + 0;
}

int random_alien_select(void) {
	return rand() % (35 + 1 - 1) + 1;
}

int random_column(void) {
	return rand() % (6 + 1 - 1) + 1;
}







