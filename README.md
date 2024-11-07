# Digital Music Box Project

This project implements a simple digital music player that plays songs using a breadboard speaker. The user can navigate through songs using buttons to play, pause, skip forward, or rewind songs. The music player is based on an ATmega328p microcontroller, and the system is controlled through button presses and plays various songs by sending the appropriate frequencies to the speaker.

## Overview

This project involves building a digital juke box that can play multiple songs on a breadboard speaker. The songs are selected and controlled using four buttons. The core logic is implemented in assembly code and runs on an ATmega328p microcontroller.

### Features:
- Play, pause, skip, and rewind functionality
- Music played through a breadboard speaker
- Button-based navigation: 
  - Play/Pause
  - Next Song
  - Previous Song
  - Skip
- Debugging LED for troubleshooting

## Circuit Diagram

Please refer to the attached schematic for the wiring of the speaker and buttons. The circuit uses the following components:

- **Speaker**: For audio output.
- **4 Buttons**: For controlling the music player (Play/Pause, Next Song, Previous Song, Skip).
- **Resistors**: Used to limit the current where necessary.
- **Potentiometer**: For adjusting the volume or frequency range.

## Materials

- 1x Speaker
- 4x Push buttons (for Play/Pause, Next Song, Previous Song, Skip)
- 4x Resistors (for button debouncing and current limiting)
- 1x Potentiometer (for volume control, optional)
- 1x ATmega328p microcontroller
- Breadboard and jumper wires
- LED (optional for debugging purposes)

## High Level Algorithm

When the program starts:
1. **Play First Song**: The first song in the list is played immediately.
2. **Button Handlers**:
   - **Next Song Button**: Triggers an interrupt to play the next song. If the last song is playing, it loops back to the first song.
   - **Pause Button**: Pauses the current song.
   - **Fast Forward Button**: Jumps forward by a set number of seconds in the current song.
   - **Rewind Button**: Jumps backward by a set number of seconds in the current song.
3. **Sound Output**: Continuously sends the appropriate frequencies to the speaker based on the current song and user inputs.

## Controls

- **Play/Pause Button (Red Button)**:
  - This button toggles the play/pause state of the song.
  
- **Next Song Button (Middle Button)**:
  - This button skips to the next song in the playlist. If the current song is the last song, it loops back to the first song.
  
- **Previous Song Button (Third Button)**:
  - This button moves to the previous song in the playlist. If the current song is the first one, it loops back to the last song.
  
- **LED**:
  - The LED is used for debugging purposes to show the system's status (e.g., indicating song playback or pause).

## Code Explanation

The code for this project is written in assembly language for the ATmega328p microcontroller. Here's a high-level breakdown of the main sections:

1. **Interrupt Vectors**: The program uses interrupts to handle button presses for navigating between songs and controlling playback.
   
2. **Frequency Compare Values**: The list of frequencies represents the musical notes for each song. Each note is associated with its frequency and duration.

3. **Song Data**: Songs are defined in arrays, where each note is specified by its pitch and duration in centiseconds. Multiple songs are supported.

4. **Main Program**: The main loop plays the first song and checks for button presses. Depending on the button pressed, it triggers an interrupt to perform actions like skipping songs, pausing, or fast-forwarding.

5. **Interrupt Subroutines**: These subroutines handle the logic for each button press. For example, when the "Next Song" button is pressed, the system jumps to the next song in the list.

## Usage Instructions
1. **Power the System**: Plug the board into a power source. Upon powering up, the first song will begin playing automatically.
2. **Control Playback**: Use the buttons to interact with the system:
   - Press the **Red Button** to toggle play/pause.
   - Use the **Middle Button** to skip to the next song.
   - Use the **Top Button** to jump to the previous song.
   - Optionally, use the **Fast Forward** and **Rewind** buttons to adjust playback within the current song.

## Conclusion
This project demonstrates a basic digital music player using a breadboard setup, where the user can control song playback with a few buttons. The ATmega328p microcontroller is used to process inputs from the buttons and generate the appropriate sound signals to the speaker, creating a simple but effective juke box experience.

## Future Improvements
- Add volume control using the potentiometer.
- Improve song management with additional songs and better navigation between them.
- Add a display to show the current song or playback status.
