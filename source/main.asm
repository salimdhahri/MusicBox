; Assembler Final Project
; Digital Juke Box
; Jay Phillips & Salim Dhahri

; Layout of this file:
;     1. Interrupt Vector
;     2. Frequency compare values
;     3. Song data
;     4. Variable names
;     5. main
;     6. Standard and Interrupt Subroutines

.DEVICE ATmega328p ; Define the correct device

.cseg
.org 000000
; ***********************************
; R E S E T  &  I N T - V E C T O R S
; ***********************************

; Page 49
; RETI, RJMP, NOP	: 1 byte
; JMP				: 2 bytes

	RJMP main ; RESET
	NOP
	RETI ; INT0
	NOP
	RETI ; INT1
	NOP
	RJMP handle_PINB_change ; PCI0
	NOP
	RETI ; PCI1
	NOP
	RETI ; PCI2
	NOP
	RETI ; WDT
	NOP
	RJMP increment_T2CMCount ; OC2A
	NOP
	RETI ; OC2B
	NOP
	RETI ; OVF2
	NOP
	RETI ; ICP1
	NOP
	RJMP change_amplitude ; OC1A
	NOP
	RETI ; OC1B
	NOP
	RETI ; OVF1
	NOP
	RETI ; OC0A
	NOP
	RETI ; OC0B
	NOP
	RETI ; OVF0
	NOP
	RETI ; SPI
	NOP
	RETI ; URXC
	NOP
	RETI ; UDRE
	NOP
	RETI ; UTXC
	NOP
	RETI ; ADCC
	NOP
	RETI ; ERDY
	NOP
	RETI ; ACI
	NOP
	RETI ; TWI
	NOP
	RETI ; SPMR
	NOP

.cseg
; There are 49 possible frequencies spanning 4 octaves
FLASH_frequencies:
	.DB 0x43, 0x09 ; Bb1 --  0
	.DB 0x3F, 0x45 ; B1  --  1
	.DB 0x3B, 0xB8 ; C2  --  2
	.DB 0x38, 0x5E ; C#2 --  3
	.DB 0x35, 0x34 ; D2  --  4
	.DB 0x32, 0x39 ; Eb2 --  5
	.DB 0x2F, 0x66 ; E2  --  6
	.DB 0x2C, 0xBD ; F2  --  7
	.DB 0x2A, 0x3B ; F#2 --  8
	.DB 0x27, 0xDC ; G2  --  9
	.DB 0x25, 0x9F ; Ab2 -- 10
	.DB 0x23, 0x83 ; A2  -- 11

	.DB 0x21, 0x85 ; Bb2 -- 12
	.DB 0x1F, 0xA3 ; B2  -- 13
	.DB 0x1D, 0xDD ; C3  -- 14
	.DB 0x1C, 0x30 ; C#3 -- 15
	.DB 0x1A, 0x9B ; D3  -- 16
	.DB 0x19, 0x1C ; Eb3 -- 17
	.DB 0x17, 0xB4 ; E3  -- 18
	.DB 0x16, 0x5F ; F3  -- 19
	.DB 0x15, 0x1D ; F#3 -- 20
	.DB 0x13, 0xEE ; G3  -- 21
	.DB 0x12, 0xD0 ; Ab3 -- 22
	.DB 0x11, 0xC1 ; A3  -- 23

	.DB 0x10, 0xC2 ; Bb3 -- 24
	.DB 0x0F, 0xD2 ; B3  -- 25
	.DB 0x0E, 0xEE ; C4  -- 26
	.DB 0x0E, 0x18 ; C#4 -- 27
	.DB 0x0D, 0x4D ; D4  -- 28
	.DB 0x0C, 0x8E ; Eb4 -- 29
	.DB 0x0B, 0xDA ; E4  -- 30
	.DB 0x0B, 0x2F ; F4  -- 31
	.DB 0x0A, 0x8F ; F#4 -- 32
	.DB 0x09, 0xF7 ; G4  -- 33
	.DB 0x09, 0x68 ; Ab4 -- 34
	.DB 0x08, 0xE1 ; A4  -- 35

	.DB 0x08, 0x61 ; Bb4 -- 36
	.DB 0x07, 0xE9 ; B4  -- 37
	.DB 0x07, 0x77 ; C5  -- 38
	.DB 0x07, 0x0C ; C#5 -- 39
	.DB 0x06, 0xA7 ; D5  -- 40
	.DB 0x06, 0x47 ; Eb5 -- 41
	.DB 0x05, 0xED ; E5  -- 42
	.DB 0x05, 0x98 ; F5  -- 43
	.DB 0x05, 0x47 ; F#5 -- 44
	.DB 0x04, 0xFC ; G5  -- 45
	.DB 0x04, 0xB4 ; Ab5 -- 46
	.DB 0x04, 0x70 ; A5  -- 47

	.DB 0x04, 0x31 ; Bb5 -- 48



; Chromatic Scale to test every possible pitch
; First byte: Pitch value
; Second byte: number of 0.01s high byte
; Third byte: number of 0.01s low byte
; Fourth byte: Spacer. Each line must have an even number of bytes to properly fill program memory locations
song1:
	.DB 1, 0, 25, 0 ; B1 for 0.5 seconds
	.DB 2, 0, 25, 0
	.DB 3, 0, 25, 0
	.DB 4, 0, 25, 0
	.DB 5, 0, 25, 0
	.DB 6, 0, 25, 0
	.DB 7, 0, 25, 0
	.DB 8, 0, 25, 0
	.DB 9, 0, 25, 0
	.DB 10, 0, 25, 0

	.DB 11, 0, 25, 0
	.DB 12, 0, 25, 0
	.DB 13, 0, 25, 0
	.DB 14, 0, 25, 0
	.DB 15, 0, 25, 0
	.DB 16, 0, 25, 0
	.DB 17, 0, 25, 0
	.DB 18, 0, 25, 0
	.DB 19, 0, 25, 0
	.DB 20, 0, 25, 0

	.DB 21, 0, 25, 0
	.DB 22, 0, 25, 0
	.DB 23, 0, 25, 0
	.DB 24, 0, 25, 0
	.DB 25, 0, 25, 0
	.DB 26, 0, 25, 0
	.DB 27, 0, 25, 0
	.DB 28, 0, 25, 0
	.DB 29, 0, 25, 0
	.DB 30, 0, 25, 0

	.DB 31, 0, 25, 0
	.DB 32, 0, 25, 0
	.DB 33, 0, 25, 0
	.DB 34, 0, 25, 0
	.DB 35, 0, 25, 0
	.DB 36, 0, 25, 0
	.DB 37, 0, 25, 0
	.DB 38, 0, 25, 0
	.DB 39, 0, 25, 0
	.DB 40, 0, 25, 0

	.DB 41, 0, 25, 0
	.DB 42, 0, 25, 0
	.DB 43, 0, 25, 0
	.DB 44, 0, 25, 0
	.DB 45, 0, 25, 0
	.DB 46, 0, 25, 0
	.DB 47, 0, 25, 0

; Star Wars Main Theme
song2:
	; 1st byte: Note pitch. 2nd and 3rd bytes: Length of note in centiseconds
	.DB 31, 0,  20, 0
	.DB 31, 0,  20, 0
	.DB 31, 0,  20, 0

	.DB 36, 0, 100, 0
	.DB 43, 0, 100, 0

	.DB 41, 0,  20, 0
	.DB 40, 0,  20, 0
	.DB 38, 0,  20, 0

	.DB 48, 0, 100, 0
	.DB 43, 0,  50, 0

	.DB 41, 0,  20, 0
	.DB 40, 0,  20, 0
	.DB 38, 0,  20, 0

	.DB 48, 0, 100, 0
	.DB 43, 0,  50, 0

	.DB 41, 0,  20, 0
	.DB 40, 0,  20, 0
	.DB 41, 0,  20, 0
	.DB 38, 0, 100, 1

variable_names:
	.EQU SRAM_frequencies = 0x0100 ; Location of first frequency value in SRAM

	; Timer 2 Compare Match Count. Number of centiseconds that have elapsed
	.EQU T2CMCountH = 0x0162
	.EQU T2CMCountL = 0x0163

	; CentiSeconds To Wait. Used by the wait_x_centiseconds subroutine
	.EQU CSTWH = 0x0164
	.EQU CSTWL = 0x0165

	; Wave flags indicate weather the wave of a particular pitch is high or low
	.EQU wave1_flag = 0x0166
	.EQU wave2_flag = 0x0167 ; Unused
	.EQU wave3_flag = 0x0168 ; Unused
	.EQU feq_array_ptr = 0x0169 ; Unused

	.EQU is_playing = 0x016A ; If true, a song is currently playing. False if otherwise

	.EQU song_pointer = 0x016B

main:
	; Setting the Stack Pointer to the end of SRAM
	; DO NOT CHANGE
	LDI r16, 0x08
	LDI r17, 0xFF
	OUT SPH, r16
	OUT SPL, r17

	CALL setup_TimerCounter0 ; PWM
	CALL setup_TimerCounter1 ; Amplitude changes
	CALL setup_TimerCounter2 ; Chord duration
	CALL setup_buttons ; Play/Pause, next song, previous song
	CALL load_SRAM_frequencies ; Load pitch frequency compare values from program memory to SRAM
;	CALL configure_song_array ; Unused

	SBI DDRD, DDD2 ; Setup debugging LED

	SER r16
	STS wave1_flag, r16 ; Initilize sound wave to start high
	STS is_playing, r16 ; Initialize is_playing to true

	; Set pointer to the beginning of song1
	LDI ZH, HIGH(song1*2)
	LDI ZL, LOW(song1*2)
	CALL prepare_note
	ADIW Z, 0x04 ; Point to next note in Program Memory
	SEI ; Global Interrupt Enable

	play_loop:
		CALL play_note
		CALL prepare_note
		ADIW Z, 0x04

	wait:
		NOP
		LDS r16, is_playing
		SBRS r16, 0
		CALL pause_song ; Call if is_playing = false

		BRTC wait
		CLT ; Reset T flag
		RJMP play_loop

; ************************************************
; S T A N D A R D  &  I N T  S U B R O U T I N E S
; ************************************************

; Timer/Counter0 is set to fast PWM mode
; The fast PWM is resposible for setting the voltage amplitude of the auido signal.
; Output on PORTD5
setup_TimerCounter0:
	PUSH r16

	; PORTD5 is connected to OC0B, the output of fast PWM
	; Thus, DDD5 must be set to allow fast PWM
	SBI DDRD, DDD5

	; OCR0B contains an 8-bit value that determines the PWM duty cycle
	; Initialized to zero. (Minimum amplitude)
	LDI r16, 0x00
	OUT OCR0B, r16

	; Setting COM0B1 causes OC0B to be cleared upon compare match
	; WGM01 and WGM00 are both set to select fast PWM
	LDI r16, (1<<COM0B1)|(1<<WGM01)|(1<<WGM00)
	OUT TCCR0A, r16

	; CS01 Selects a prescaler of 1 for TCNT0
	LDI r16, (1<<CS00)
	OUT TCCR0B, r16

	POP r16
	RET


; Timer/Counter 1 keeps track of time delays between amplitude changes in the audio signal
setup_TimerCounter1:
	PUSH r16

	; Setting WGM12 selects CTC mode. CS11 selects a prescaler of 8 for TCNT1 (16-bit Timer)
	LDI r16, (1<<WGM12)|(1<<CS11)
	STS TCCR1B, r16

	; Enable interrupts on compare match with OCF1A
	LDI r16, (1<<OCIE1A)
	STS TIMSK1, r16

	POP r16
	RET


; Timer/Counter2 keeps track of the time it takes to play a particular chord
setup_TimerCounter2:
	PUSH r16

	; Setting WGM21 selects CTC mode for Timer/Counter2
	LDI r16, (1<<WGM21)
	STS TCCR2A, r16

	; These 3 bits select a prescaler of 1024
	LDI r16, (1<<CS22)|(1<<CS21)|(1<<CS20)
	STS TCCR2B, r16

	; With a prescaler of 1024, a compare value of 0x9C (156) will stall for approximately 0.01s
	; A true 0.01s is 156.25
	; Do not change
	LDI r16, 0x9C
	STS OCR2A, r16
	STS OCR2B, r16 ; Used for debouncing. Interrupts are not enabled upon compare match

	; Enable interrupts for compare match with OCR2A
	; See page 132 for further clarification
	LDI r16, (1<<OCIE2A)
	STS TIMSK2, r16

	POP r16
	RET


; Configuring appropriate registers for pin change interrupts
setup_buttons:
	PUSH r16

	; Enable input on PIND[2:0]
	LDI r16, (0<<DDB0)|(0<<DDB1)|(0<<DDB2)
	OUT DDRB, r16

	; Enable interrupts on PIND[2:0]
	LDI r16, (1<<PCINT0)|(1<<PCINT1)|(1<<PCINT2)
	STS PCMSK0, r16

	; Enable PCINT0 interrupts
	LDI r16, (1<<PCIE0)
	STS PCICR, r16

	POP r16
	RET


; Setup Subroutine for loading frequency values into SRAM
load_SRAM_frequencies:
	PUSH r16
	PUSH r17
	PUSH r18
	PUSH XH
	PUSH XL
	PUSH ZH
	PUSH ZL

	; Setting Z pointer to the beginning of frequency array in flash
	LDI ZH, HIGH(FLASH_frequencies*2)
	LDI ZL, LOW(FLASH_frequencies*2)

	; Set X pointer the the beginning of internal SRAM
	; This SRAM location is where the frequencies will be stored for later use
	LDI XH, 0x01
	LDI XL, 0x00

	LDI r18, 0x31 ; Initilizing i. There are 49 values to get from program memory

	load_loop:
		; Get 16-bit value from program memory
		LPM r16, Z+
		LPM r17, Z+
		; Store value in SRAM
		ST X+, r16
		ST X+, r17

		DEC r18 ; i--
		BRNE load_loop

	POP ZL
	POP ZH
	POP XL
	POP XH
	POP r18
	POP r17
	POP r16
	RET




; Unused
configure_song_array:
	PUSH r16
	PUSH r17
	PUSH XH
	PUSH XL

	LDI XH, HIGH(song_pointer)
	LDI XL, LOW(song_pointer)

	LDI r16, HIGH(song1*2)
	LDI r17, LOW(song1*2)
	ST X+, r16
	ST X+, r17

	LDI r16, HIGH(song2*2)
	LDI r17, LOW(song2*2)
	ST X+, r16
	ST X+, r17

	POP XL
	POP XH
	POP r17
	POP r16
	RET

; INPUT: Number of sentiseconds to wait (r18:r19)
; OUTPUT: Void Subroutine
; 25 clock cycles
wait_x_centiseconds:
	PUSH r16
	PUSH r18
	PUSH r19

	CLR r16 ; Reset count
	STS TCNT2, r16 ; Reset timer
	STS T2CMCountH, r16
	STS T2CMCountL, r16 ; Yes this is supposed to be r16
	
	STS CSTWH, r18 ; Store count compare value
	STS CSTWL, r19
	
	POP r19
	POP r18
	POP r16
	RET


; INPUT: A positive integer corresponding to a pitch frequency compare value (r18)
; OUTPUT: The pitch frequency compare value (r18:r19)
fetch_compare_value:
	PUSH XH
	PUSH XL

	CLR r19

	; Setting the X Pointer to the correct SRAM locatin of desired 16-bit value
	; 2 ADD instructions are required because there are 2 bytes for each frequency
	LDI XH, HIGH(SRAM_frequencies)
	LDI XL, LOW(SRAM_frequencies)
	ADD XL, r18 ; Index X + 2*r18. This is because there are 2 bytes for each compare value in SRAM
	ADC XH, r19
	ADD XL, r18
	ADC XH, r19

	LD r18, X+  ; Load 16-bit frequency compare value into r18 and r19 for return
	LD r19, X

	POP XL
	POP XH
	RET


; INPUT: Pointer to notes in Program Memory Location (Z register)
; OTUPUT: Provies the frequency compare value. (r18:r19) Provides note duration in centiseconds. (r20:r21)
; Does not push or pop r18-r21 as these 4 registers are used for returns
prepare_note:
	PUSH ZH
	PUSH ZL

	LPM r18, Z+ ; Load pitch value
	CALL fetch_compare_value ; Places frequency in (r18:r19)

	; Load length of note in centiseconds
	LPM r20, Z+
	LPM r21, Z+

	POP ZL
	POP ZH
	RET

; INPUT: Compare value of note. (r18:r19) Length of note in centiseconds (r20:r21)
; OUTPUT: Comfigures timers and interrupts. Initiates note on speaker.
play_note:
	PUSH r18
	PUSH r19
	PUSH r20
	PUSH r21

	; Update frequency
	STS OCR1AH, r18
	STS OCR1AL, r19

	; Initialize the wait
	MOV r18, r20
	MOV r19, r21
	CALL wait_x_centiseconds

	POP r21
	POP r20
	POP r19
	POP r18
	RET


; IPNUT: A pointer to the first element in the current frequency array. Size of array (r18)
; OUTPUT: A sorted array of three frequency compare vales
; Unused Subroutine
bubble_sort:
	PUSH r16
	PUSH r17
	PUSH r18
	PUSH r19
	PUSH r20
	PUSH r21
	PUSH r22
	PUSH r23
	PUSH XH
	PUSH XL
	PUSH YH
	PUSH YL
	PUSH ZH
	PUSH ZL

	; Load address of 0th element
	LDI XH, HIGH(feq_array_ptr)
	LDI XL, LOW(feq_array_ptr)

	MOVW Z, X ; Save X
	MOV r22, r18 ; Declare i
	SUBI r22, 0x01 ; i = n-1
	outer_loop:
		MOVW X, Z ; Restore X to point at first element of array
		; Establish 2 pointers, X and Y
		MOVW Y, X
		ADIW Y, 0x02 ; Offset Y by 1 index

		MOV r23, r22 ; j = i
		inner_loop:
			; Load in two adjacent values
			LD r16, X+
			LD r17, X+
			LD r18, Y+
			LD r19, Y+

			; Compare most significant bytes first. Swap immediately if MSbytes are unordered
			CP r18, r16
			BRMI swap
			BREQ check_LSB
			RJMP check_inner ; Should only occur 

			check_LSB:
				CP r19, r17
				BRMI swap

				RJMP check_inner ; If no swap, check if done with current iteration

			swap:
				; Step back to store at correct locations
				SUBI XL, 0x02
				SBCI XH, 0x00
				SUBI YL, 0x02
				SBCI YH, 0x00

				MOV r20, r16 ; temp = X
				MOV r21, r17
				MOV r16, r18 ; X = Y
				MOV r17, r19
				MOV r18, r20 ; Y = temp
				MOV r19, r21

				; Update the array in SRAM
				ST X+, r16
				ST X+, r17
				ST Y+, r18
				ST Y+, r19

			check_inner:
				DEC r23 ; j--
				BREQ check_outer
				RJMP inner_loop

		check_outer:
			DEC r22 ; i--
			BREQ end_outer
			RJMP outer_loop

		end_outer:
			POP ZL
			POP ZH
			POP YL
			POP YH
			POP XL
			POP XH
			POP r23
			POP r22
			POP r21
			POP r20
			POP r19
			POP r18
			POP r17
			POP r16
			RET


; Increment Timer2 Compare Match Count
; Adds 1 to the number centiseconds elapsed since the wait_x_centiseconds was called
; OUTPUT: Sets T flag in SREG if specified number of centiseconds have elapsed
;         Otherwise, T flag is cleared
increment_T2CMCount:
	CLI ; Disable interrupts
	PUSH r16
	PUSH r17
	PUSH YH
	PUSH YL

	LDS YH, T2CMCountH
	LDS YL, T2CMCountL
	ADIW Y, 0x01

	LDS r16, CSTWH
	LDS r17, CSTWL

	CP r16, YH
	BRNE too_early
	CP r17, YL
	BRNE too_early

	SET ; Set T flag if 
	RJMP returnITC

	too_early:
		CLT
		STS T2CMCountL, YL
		STS T2CMCountH, YH

	returnITC:
		POP YH
		POP YL
		POP r17
		POP r16
		RETI


; INPUT: new amplitude of wave
change_amplitude:
	CLI ; Disable interrupts
	PUSH r16

	LDS r16, wave1_flag
	COM r16
	OUT OCR0B, r16

	STS wave1_flag, r16

	POP r16
	RETI


; Handles 3 possible pin changes on PORTD
handle_PINB_change:
	CLI ; Disable interrupts
	PUSH r16

	IN r16, PINB
	ANDI r16, (1<<PINB0)|(1<<PINB1)|(1<<PINB2)
	CALL wait_for_release ; Ensure all buttons are not pressed before continuing

	SBRC r16, 0
	NOP ; Not used

	SBRC r16, 1
	NOP ; Not used

	SBRC r16, 2
	CALL toggle_is_playing

	POP r16
	RETI

; Toggles is_playing variable
; isplaying != isplaying
toggle_is_playing:
	PUSH r16

	LDS r16, is_playing
	COM r16
	STS is_playing, r16

	POP r16
	RET


; Look for falling edge of buttons
wait_for_release:
	PUSH r16

	still_pressed:
		IN r16, PINB ; Read buttons
		ANDI r16, (1<<PINB0)|(1<<PINB1)|(1<<PINB2) ; Mask input
		BRNE still_pressed

	CALL stall ; Wait for 0.01 seconds

	POP r16
	RET


; Mute speaker and remain idle until unpaused
pause_song:
	PUSH r16
	PUSH r17
	PUSH r18

	CBI DDRD, DDD5 ; Mute speaker

	; Disable interrupts on Timer/Counter1
	LDI r16, (0<<OCIE1A)
	STS TIMSK1, r16

	; Disable interrupts on Timer/Counter2
	LDI r16, (0<<OCIE2A)
	STS TIMSK2, r16

	; Save number of centiseconds elapsed at time of pause_song subroutine call
	LDS r16, T2CMCountH
	LDS r17, T2CMCountL

	CALL wait_for_unpause ; Wait until button red button is pressed to unpause the song

	; Restore note timer value
	STS T2CMCountH, r16
	STS T2CMCountL, r17

	; Reenable interrupts on Timer/Counter2
	LDI r16, (1<<OCIE2A)
	STS TIMSK2, r16

	; Reenable interrupts on Timer/Counter1
	LDI r16, (1<<OCIE1A)
	STS TIMSK1, r16

	SBI DDRD, DDD5 ; Unmute speaker

	POP r18
	POP r17
	POP r16
	RET


; Debounces button press
wait_for_unpause:
	PUSH r16
	not_pressed:
		IN r16, PINB ; Read buttons
		ANDI r16, (1<<PINB2) ; Mask input. Only check the red play/pause button. Ignore the other 2
		BRNE not_pressed ; If previous operation sets the Z flag, exit loop

	CALL stall ; Better Call Stall!

	POP r16
	RET


; Wait for 0.01 seconds to debounce button presses
stall:
	PUSH r16

	CLR r16 ; Reset count
	STS TCNT2, r16 ; Reset timer

	stall_loop:
		NOP
		SBIS TIFR1, OCF1B
		RJMP stall_loop
	
	SBI TIFR2, OCF2B ; Set interrupt on Compare with OCR2B. (Clear it)

	POP r16
	RET

