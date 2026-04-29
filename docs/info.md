<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a simple Flappy Bird-style game in digital logic. The design generates VGA timing signals, tracks the bird position, moves a pipe across the screen, detects collisions, and renders the game scene using 2-bit RGB color outputs plus VGA horizontal and vertical sync signals. The game is controlled using two inputs: START begins the game, and JUMP makes the bird flap upward.

## How to test

Explain how to use your project

## External hardware

This project is designed to drive a VGA display using a TinyVGA-style PMOD or equivalent resistor-DAC VGA output circuit. It uses 2 bits each for red, green, and blue, plus HSYNC and VSYNC.