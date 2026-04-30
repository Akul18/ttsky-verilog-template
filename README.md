## How it works
This project implements a simple Flappy Bird-style game in digital logic. VGA timing logic generates horizontal/vertical sync signals and pixel coordinates to drive a display. A physics module updates the bird’s vertical position using gravity and jump inputs, while a pipe generator creates a moving obstacle with a gap.
Collision logic detects when the bird hits the pipe or ground, ending the game. A renderer uses the current pixel location to draw the bird, pipe, ground, and background in real time. The output is sent as 2-bit RGB signals along with HSYNC and VSYNC to a VGA display.

## How to test
Connect the VGA outputs to a TinyVGA-style PMOD or resistor-based VGA DAC, then connect to a monitor. Ensure the chip is powered and clocked.
Use ui[0] as START and ui[1] as JUMP. After reset, press START to begin. Press JUMP to move the bird upward and avoid the pipe. If the bird collides, the game ends and can be restarted.

## External hardware
This project requires a VGA interface (TinyVGA PMOD or equivalent resistor-DAC circuit) and a VGA monitor. It outputs 2-bit RGB signals plus HSYNC and VSYNC.
Push buttons should be connected to ui[0] and ui[1] for game control.