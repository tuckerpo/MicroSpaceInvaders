# MicroSpaceInvaders - an ASCII clone of the 1978 arcade classics written entirely in ARM7 assembly. 

Building & Running
------------------

This program was written in ARM7, a somewhat deprecated RISC instruction set. The game was also intended to be played over serial from an ARM7 chip to a terminal. As such, you'll need both an ARM7 emulator (specifically emulating an LPC213X board would be optimal) and a virtual serial port emulator. I recommend [Keil uVision](http://www.keil.com/) and [VSPE](http://www.eterlogic.com/Products.VSPE.html) for these, respectively. 

Game Logic
----------

The game follows the same basic ruleset as the original Space Invaders. You're given four lives. There was 7x5 (35) aliens on a level. Successive rows of aliens are worth more points. Motherships pass by at random, and provide random point values in the range [100, 300]. Losing all lives ends the game. The game can be played again any time by pressing enter. The game can also be quit by pressing q. The game is entirely interrupt driven.  

See it in action:

TODO: Record gameplay and host it somewhere.