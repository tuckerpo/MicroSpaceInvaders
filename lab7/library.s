	AREA lab7library, code, readwrite
	EXPORT div_and_mod
	EXPORT read_string
	EXPORT output_string
	EXPORT read_character
	EXPORT output_character
	EXPORT atoi
	EXPORT pin_connect_block_setup_for_uart0
	EXPORT uart_init
	EXPORT print_newline
	EXPORT read_character
	EXPORT htoi
	EXPORT display_digit_on_7_seg
	EXPORT Reversed
	EXPORT itoa
	EXPORT illuminateLEDs
	EXPORT read_from_push_btns
	EXPORT seven_seg_setup
	EXPORT turn_7_seg_off
	EXTERN lab7_quit
	EXPORT print_newline
	EXPORT interrupt_init
		; extern
	EXTERN level
	EXTERN gameover_flag
	EXTERN lab6_really_quit
	EXTERN lab7
	EXTERN lab7_start
	EXPORT match_reg

		
; 7seg display lookup table - fixed
digits_SET	
		DCD 0x00003780  ; 0
 		DCD 0x00003000  ; 1 
		DCD 0x00009580  ; 2
		DCD 0x00008780	; 3
		DCD 0x0000A300  ; 4
		DCD 0x0000A680	; 5
		DCD 0x0000B680	; 6
		DCD 0x00008380  ; 7
		DCD 0x0000B780  ; 8
		DCD 0x0000A380  ; 9
	ALIGN

		
	; MEM MAP LABELS
	
P0DIR EQU 0xE0028008 ; port 0 direction
U0BA  EQU 0xE000C000            ; UART0 Base Address
U0LSR EQU 0x14                  ; UART0 Line Status Register
U0LCR EQU 0x0C                  ; UART0 Line Control Register
PINSEL0 EQU 0xE002C000          ; Pin Connect Block Port 0
PINSEL1 EQU 0xE002C004
IO0DIR  EQU 0xE0028008          ; GPIO Direction Registers
IO1DIR  EQU 0xE0028018
IO0SET  EQU 0xE0028004          ; GPIO Output Set Registers
IO1SET  EQU 0xE0028014
IO0CLR  EQU 0xE002800C          ; GPIO Output Clear Registers
IO1CLR  EQU 0xE002801C
IO0PIN  EQU 0xE0028000          ; GPIO Port Pin Value Registers
IO1PIN  EQU 0xE0028010
; atoi steps: 
; check string[0] for '-' char, perform 2's comp if found
; go through char by char, subtract '0', multiply by 10
; value = 0; for (char c : str) { value = value*10 + c - '0'; }
atoi
    STMFD   SP!, {lr, r2-r4}
    MOV     r2, #0	; init r2
    MOV     r3, #10 ; init r3 to 10 
    ; Check sign
    MOV     r5, #0 ; init sign bit
    LDRB    r0, [r4]  ; load first char
    CMP     r0, #0x2D ; check if first char == '-'
    MOVEQ   r5, #1 ; if char == '-' set sign bit high
	ADDEQ 	r4, #1
atoi_conv
    LDRB    r0, [r4], #1 ; load next char
    CMP     r0, #0	; compare to null temrinator
    BEQ     atoi_end ; finish if we hit null character
    SUB     r0, r0, #0x30 ; take ascii value - '0' to convert to int
    MLA     r2, r3, r2, r0	; multiply with add; multiply r3 with r2, add r0, store in r2
    B       atoi_conv
atoi_end
    CMP     r5, #1 ; check sign bit
    MVNEQ   r2, r2 ; bitflip if r5 is high
    ADDEQ   r2, r2, #1 ; add 1 if r5 high to complete 2's comp
    MOV     r0, r2 ; converted int now in r0
;	ADD 	r11, r11, r0 ; running sum += new input
    LDMFD   sp!, {lr, r2-r4}
    BX      lr
	
; converts single hex char in the range of 0 to F to int
; needed for 7seg lookup table offset
htoi
    STMFD   SP!, {lr, r3, r4}
	MOV     r3, #0    
    MOV     r4, #0
    SUBS    r3, r0, #0x30	; subtract 0x30 from arg, store in r3 as to not overwrite base arg          
    RSBS    r4, r0, #0x39   ; reverse subtract arg from 0x39; store in r4 as to not overwrite base arg
    CMP     r3, #0          ;	make sure both checks came out positive
    CMPPL   r4, #0          ;  
    BPL     htoi_numeric	; if arg >= 0 && <= 9, branch to numeric conversion
    SUBS    r3, r0, #0x41	; subtract 0x41 from arg
    RSBS    r4, r0, #0x46	; reverse subtract arg from 0x46
    CMP     r3, #0	; both checks came out positive              
    CMPPL   r4, #0	; ^
    BPL     htoi_a_f  ; if arg >= 'A' and arg <= 'F' branch to A-F conversion
    B       htoi_end  ; else branch to end, do nothing
htoi_numeric   
    SUB   r0, r0, #0x30 ; subtract 0x30 from arg, converts it to int equivalent 
    B     htoi_end
htoi_a_f
    SUB     r0, r0, #0x37 ; subtract 0x37 from arg, converts it to int equivalent (i.e. user enters 'F', will be value F after conversion)        
htoi_end
    LDMFD   SP!, {lr, r3, r4}
    BX      lr
		
		
		
read_string             
    STMFD SP!, {lr, r0, r4, r5}     ; Store registers on stack
cin_loop
    BL      read_character
    STRB    r0, [r4], #1        ; get char from string, increment array of char index
    BL      output_character
    CMP     r0, #0x0D 				; check for '\r'
    BNE     cin_loop                ; if not '\r' keep reading, user has not pressed enter
	;ADDEQ 	r9, r9, #1			    ; counter++ since we found '\r' 
    MOV     r5, #0 ; init r5 to nullchar
	ADD 	r4, r4, #-1;			
    STRB    r5, [r4] ; decrement buff index, then append NULL char
	; ADD 	r9, r9, #1 ; # of inputs ++
   
    LDMFD sp!, {lr, r0, r4, r5}
    BX lr

output_string           ; base address of string passed into r4
    STMFD   SP!, {lr, r0, r1, r4}
cout_loop
    LDRB    r0, [r4], #1        ; load i'th char into r0, i++
	LDR r1, =U0BA
    BL      output_character    ; output char in r0
    CMP     r0, #0              ; check for null terminator
    BNE     cout_loop           ; loop if we haven't yet found the null terminator
    LDMFD sp!, {lr, r0, r1, r4}
    BX lr
   
   
read_character                  
    STMFD   SP!,{lr, r1-r3}            
    LDR     r0, =0xE000C000 ; base uart0 addy
read
    LDRB    r1, [r0, #U0LSR] ; load byte of lsr offet
    ANDS    r2, r1, #1 ; check rdr
    BEQ     read     ; loop if rdr low, meaning not ready to receive
    LDRB    r3, [r0] ; else Read byte from receive register

	cmp 	r3, #0x71
	bne check_enter
	BEQ 	lab7_quit
check_enter
	cmp r3, #0x0D
	moveq pc, #0
	BEQ lab7_start
    MOV     r0, r3 ; Return char in r0
    LDMFD   sp!, {lr, r1-r3}          
    BX      lr

output_character                
    STMFD   SP!,{lr, r1, r2, r3}            
    MOV     r3, r0              ; temp hold r0 in r3
    LDR     r0, =0xE000C000     
write
    LDRB    r1, [r0, #U0LSR]    ; load lsr offset
    ANDS    r2, r1, #32     	; check thre, 5th bit
    BEQ     write	        	; loop if thre low
    STRB    r3, [r0]        	; else Store byte in transmit register
	MOV 	r0, r3
	; CMP 	r0, #0x6E for testing only, confirmed 'n' breaks from input and branches to average
	; BEQ 	avg		  for testing only, confirmed 'n' breaks from input and branches to average
	; ADD 	r10, r10, #1 ; iterate char print counter
    LDMFD   sp!, {lr, r1, r2, r3}
    BX      lr
	
	
itoa ; int to ascii conversion
    STMFD SP!, {lr, r1-r2, r4, r6-r7}
    MOV r6, #10
    MOV r7, #0
    CMP r1, #0
    MOV r5, #0x2D ; '-'
   ; STRBMI r5, [r4], #1 ; append negative sign if negative
    MVNMI r0, r0 ; bit flip if negative
    ADDMI r0, r0, #1 ; 2's comp if negative
    CMP r0, #0 ; check if int is 0
    BNE itoa_div_push
    ADD r0, r10, #0x30 ; adding hex 30 to int [1, 9] will convert to equivalent ascii value
    STRB r0, [r4], #1 ; store
    B itoa_append_nullchar
itoa_div_push
    MOV r1, r6;
    BL div_and_mod ; divide int by 10
    CMP r1, #0 ; remainder
    CMPEQ r0, #0  ; quotient
    BEQ stack_pop
    ADD r1, r1, #0x30 ; add hex 30 to convert to ascii
    PUSH {r1} ;push to stack, preserve value -> store content of r1 in sp - 4 and then grow sp downwards by 4
    ADD r7, r7, #1 ; stack size ++
    B itoa_div_push
stack_pop
    CMP r7, #0 ; equivalent to stack.peek();
    BEQ itoa_append_nullchar ; if nothing left to be popped, we're done
    POP {r1} ; pop from stack, restore value -> load value of r1 off the stack, increment sp by 4 so it points to next member of stack
    STRB r1, [r4], #1 ; pop converted ascii off stack and append to our string
    SUB r7, r7, #1 ; stack size --
    B stack_pop
itoa_append_nullchar
    MOV r1, #0     ; init nullchar
    STRB r1, [r4], #1 ; append to string to be output
	BL print_newline
    LDMFD SP!, {lr, r1-r2, r4, r6-r7}
    BX lr

div_and_mod ;same div_and_mod from lab2
        STMFD SP!, {r2-r12, lr}

        ; Your code for the signed division/mod routine goes here.
        ; The dividend is passed in r1 and the divisor in r0.
        ; The quotient is returned in r1 and the remainder in r0.

        ; this implementation of divide & modulus follows Dr Schindler's iterative subtraction algorithm discussed in class
        ; I added signed value checking at the beginning & ends of Dr Schindler's algorithm to take care of negative value checking
        ; I also made use of ARM's conditional instruction suffixes also discussed in class

        CMP r0, #0 ; check sign of dividend, updates condition flags
        MOV r5, #0 ; hold sign value in r5, assume positive
        MOVMI r5, #1 ; switch sign vlaue of divisor to negative if need be based on N flag's value
        MVNMI r0, r0 ; bit flip if signed negative
        ADDMI r0, r0, #1 ; add one to complete 2's comp
        ; repeat the same procedure for the divisor
        ; *.MI suffix is checking the N flag in the CPSR, if N==1, the instruction's register operand is negative
        CMP r1, #0
        MOV r6, #0 ; hold sign value of dividend in r6, assume positive
        MOVMI r6, #1 ; switch sign value of dividend if need be
        MVNMI r1, r1
        ADDMI r1, r1, #1
        MOV r2, #15 ; load immediate value of decimal 15 into r2, will serve as counter value
        MOV r3, #0  ; load quotient to 0
        LSL r1, r1, #15 ; logic left shift divisor 15
        MOV r4, r0 ; let r4 hold initial remainder which should be equal to the dividend if dividend < divisor
rec_sub
        SUBS r4, r4, r1 ; remainder -= divisor; subs = substraction w/ ALU flag updating
        ADDLT r4, r4, r1 ; for negative remainder
        LSLLT r3, #1 ; shift quotient left; LT suffix checks N != V?
        ; for non-negative remainder
        LSLGE r3, #1 ; shift quotient left;  GE suffix checks N == V?
        ORRGE r3, r3, #1 ; set least sig bit of quotient = 1
        LSR r1, r1, #1 ; right shift divisor
        SUBS r2, r2, #1 ; counter--
        BPL rec_sub ; back to loop if r2 is non-zero
        ; loop has ended
        MOV r0, r3; toss quotient into r0
		MOV r1, r4; toss remainder into r1
		EOR     r7, r5, r6 ; eor signs of dividor and dividend
    	CMP     r7, #1 ; we only care if one and only one of the two operands was negative, EOR fits that well
   		MVNEQ   r0, r0     ;2's comp
    	ADDEQ   r0, r0, #1 ;2's comp
		LDMFD SP!, {lr, r2-r12}
		BX lr
		
uart_init
	STMFD SP!, {lr}
	; *(volatile unsigned *)(0xE000C00C) = 131; 
	MOV r0, #131
	LDR r1, =0xE000C00C
	STR r0, [r1]
	; *(volatile unsigned *)(0xE000C000) = 120; 
	; set lower divisor latch baud
	; 0 = 9.6k baud
	; 10 = 115200 baud
	; 1 = 1,115,200 baud
	MOV r0, #10
	LDR r1, =0xE000C000
	STR r0, [r1]
	; *(volatile unsigned *)(0xE000C004) = 0; 
	; upper divisor latch 9.6k baud
	MOV r0, #0
	LDR r1, =0xE000C004
	STR r0, [r1]
	; *(volatile unsigned *)(0xE000C00C) = 3;
	MOV r0, #3
	LDR r1, =0xE000C00C
	STR r0, [r1]
	LDMFD SP!, {lr}
	BX lr
	
	
illuminateLEDs
	STMFD SP!, {lr, r1 -r12}
	
	BL atoi
	BL Reversing
	
Reversing                       ; reversing the bit because on LED its opposite. for example value 5 is represented as 10 on led                  ; Desired value to represent on LED
	AND r1,r0, #1               
	MOV r1, r1, LSL #3           ; LSB ----- MSB
	AND r2, r0, #2
	MOV r2, r2, LSL #1            ; Switch the middle bit
	AND r3, r0, #4
	MOV r3, r3, LSR #1             ; switch the middle bit
	AND r4, r0, #8
	MOV r4, r4, LSR #3         ; MSB----------LSB
	ADD r5, r1, r2
	ADD r6, r3, r4
	ADD r0, r5, r6            ;new value
	MOV r0, r0, LSL #16        ; shifting it the 16 place so the value will start displaying from pin16
	BL clear_register          ; turn on the desire LED

	LDMFD SP!, {lr, r1-r12}
	BX lr
clear_register
	STMFD SP!,{lr, r1-r12}	; Store register lr on stack
	LDR r2, =0xE0028018  ; Direction register port1 
	STR r0, [r2]		; store the led pin back to address
	LDMFD SP!,{lr, r1-r12}
	BX lr

	
	
	
	

display_digit_on_7_seg
	STMFD SP!, {lr, r1-r4}
	LDR r1, =IO0CLR 
	LDR r2, =0x0000B780   ; clear everything
	STR r2, [r1] ; clear old pattern to prevent ghosting digit to digit
	LDR r1, =IO0SET ; load set register
	LDR r3, =digits_SET ; load base address of lookup table
	MOV r0, r0, LSL #2 ; 
	LDR r2, [r3, r0] ; load from the lookup table base address + offset of r0
	STR r2, [r1] ; set the io0set pins correlating to the lookup table result to high (turn on the lights)
seven_seg_out_of_bounds_error
	LDMFD SP!, {lr, r1-r4}
	BX lr


; **** BEGIN 7SEG **** ;
; 7 - 13 -> A-F, 15 -> G
seven_seg_setup
	STMFD SP!, {lr, r1-r4}
	LDR r1, =PINSEL0
	LDR r2, =0x0FFF4000 ; bit mask for port0 pins 2-5, 7-13, 15
	LDR r3, [r1]
	BIC r3, r3, r2 ; clear pinsel bits
	STR r3, [r1] ; set pins as GPIO
	LDR r1, =P0DIR ;port 0 direction register
	LDR r2, =0x0000BFBC ; BFBC = bit pattern for 2-5, 7-13, 15
	LDR r3, [r1]
	ORR r3, r3, r2	; set BFBC high on directional -> set as output
	STR r3, [r1] ; set 2-5, 7-13, 15 as output
	LDR r1, =IO0SET ; load IO0SET register
	LDR r2, =0x0000003C ; 0x3C corresponds to the anode pins in IO0SET/IO0CLR
	STR r2, [r1] ; clear 7 seg anodes by setting their pins to high
	;LDR r2, =0x00000004 ; pin 2 anode 0
	;LDR r1, =IO0CLR ; set anode 0 active low
	;STR r2, [r1] ; set anode 0 active low
	STMFD SP!, {lr, r1-r4}
	BX lr


turn_7_seg_off ; sets anode to high which turns it off without losing old value
	STMFD SP!, {lr, r1-r4}
	LDR r1, =IO0SET 
	LDR r2, =0x0000003C ; turn all digits off
	STR r2, [r1]
	LDMFD SP!, {lr, r1-r4}
	BX lr
	
	

	
print_newline
	STMFD SP!, {lr, r0} ; must preserve r0
	MOV r0, #0x0A
	BL output_character
	MOV r0, #0x0D
	BL output_character
	LDMFD SP!, {lr, r0}
Reversed
	STMFD SP!, {lr, r1-r6}; reversing the bit because on LED its opposite. for example value 5 is represented as 10 on led                  ; Desired value to represent on LED
	AND r1,r0, #1               
	MOV r1, r1, LSL #3           ; LSB ----- MSB
	AND r2, r0, #2
	MOV r2, r2, LSL #1            ; Switch the middle bit
	AND r3, r0, #4
	MOV r3, r3, LSR #1             ; switch the middle bit
	AND r4, r0, #8
	MOV r4, r4, LSR #3         ; MSB----------LSB
	ADD r5, r1, r2
	ADD r6, r3, r4
	ADD r0, r5, r6             ; hold the newly reversed bit value
	LDMFD SP!, {lr, r1-r6}
	BX lr
	
read_from_push_btns
	STMFD SP!, {lr,r4}

	BL atoi                ; conversion
	
	CMP r0, #0x05          ; 5 to press numbers
	BEQ press
	BNE read_from_push_btns
	
	
press
	LDR r2, =0xE0028010  ; Direction register port0 to set an output for RGB lights
    
	LDR r0, [r2]            
    AND r0, r0, #0xF00000 ; Check for high 
	
	CMP r0, #0xF00000	   ; checking if anything was pressed if not go back if yea go down
	BEQ press
	MVN r0,r0				; pressed buttopn is 0 , change to high
	AND r0, #0xF00000		; keep the pressed button high rest low
	MOV r0, r0, LSR #20     ; shifed right ar pin 20 
	LDMFD SP!, {lr,r4}
	BX lr

interrupt_init      
	STMFD SP!, {r0-r1, r4-r5, lr}   ; Save registers
		
	; Push button setup		 
	LDR r0, =0xE002C000
	LDR r1, [r0]
	ORR r1, r1, #0x20000000
	BIC r1, r1, #0x10000000
	STR r1, [r0]  ; PINSEL0 bits 29:28 = 10
		
	; UART0 setup
	LDR r0, =0xE000C004  ; U0IER
	LDR r1, [r0]
	ORR r1, r1, #1 	; Enable Receive Data Available Interrupt(RDA) Bit 0
	STR r1, [r0]

	; Classify sources as IRQ or FIQ
	LDR r0, =0xFFFFF000
	LDR r1, [r0, #0xC]
	ORR r1, r1, #0x8000 ; External Interrupt 1
	ORR r1, r1, #0x40 	; UART0 Interrupt
    ORR r1, r1, #0x10   ; TIMER 0
	orr r1, r1, #0x20 	; timer 1
	STR r1, [r0, #0xC]

	; Enable Interrupts
	LDR r0, =0xFFFFF000
	LDR r1, [r0, #0x10] 
	ORR r1, r1, #0x8000 ; External Interrupt 1
	ORR r1, r1, #0x40	; UART0 Interrupt
    ORR r1, r1, #0x10    ; TIMER 0
	ORR r1, r1, #0x20 ; Timer 1
	STR r1, [r0, #0x10]
	
    LDR r4, =0xE0004014 	; T0MCR - Timer0MatchControlRegister
	LDR r5, [r4]
    ORR r5, r5, #0x18 		; Interrupt and Reset for MR1
    STR r5, [r4]
	
	ldr r4, =0xE0008014 ; t1mcr
	ldr r5, [r4]
	orr r5, r5, #0x18 ; int and reset on mr1 for timer 1
	str r5, [r4]

match_reg
	LDR r4, =0xE000401C 	; Match Register 1
	LDR r6, =level
	ldrb r7, [r6]
	cmp r7, #0x31
	ldreq r5, =0x008CA000		; refresh rate ~ 2 Hz for level 0 and level 1
	cmp r7, #0x32
	ldreq r5, =0x005DC000 		; 3 Hz for level 2 (0.1 s faster period from lvl 1)
	STR r5, [r4]
	
	ldr r4, =0xE000801C
	ldr r5, =0x00025800 		; 120 hz for strobing 7seg
	str r5, [r4]

	; Enable Timer0
	LDR r4, =0xE0004004	    ; T0TCR - Timer0ControlRegister
    LDR r5, [r4]
	ORR r5, r5, #1
	STR r5, [r4]
	; enable timer 1
	
	LDR r4, =0xE0008004
	ldr r5, [r4]
	orr r5, r5, #1
	str r5, [r4]
	
	; External Interrupt 1 setup for edge sensitive
	LDR r0, =0xE01FC148
	LDR r1, [r0]
	ORR r1, r1, #2  ; EINT1 = Edge Sensitive
	STR r1, [r0]

	; Enable FIQ's, Disable IRQ's
	MRS r0, CPSR
	BIC r0, r0, #0x40
	ORR r0, r0, #0x80

	MSR CPSR_c, r0
	
	; Set match register
	; value of match register determines when interrupts are triggered off the timer
	; PCLK speed is (5/4)*clock speed set in target settings = (5/4)*14.7456 = 18,432,000 cycles/sec 
	; we want the interrupt to occur somewhere between 60 and 1,000 times a second, I chose 300 times / sec for consistent strobing
	; so we take PCLK / desired interrupt speed -> 18,432,000/300 Hz = 0xF000 = match register value!

	

	LDMFD SP!, {r0-r1, r4-r5, lr} ; Restore registers
	BX lr             	   ; Return


pin_connect_block_setup_for_uart0
	STMFD sp!, {r0, r1, lr}
	LDR r0, =0xE002C000  ; PINSEL0
	LDR r1, [r0]
	ORR r1, r1, #5
	BIC r1, r1, #0xA
	STR r1, [r0]
	LDMFD sp!, {r0, r1, lr}
	BX lr

	END