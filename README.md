# Kaprekar's Constant in 8086 Assembly

This repository contains an implementation of [Kaprekar's Constant](https://en.wikipedia.org/wiki/6174_(number)) (6174) written 8086 asm. 

## Features
The program includes a text based menu offering two modes:
* **Interactive Mode (i):** The user inputs a 4 digit number, and the program calculates the number of iterations required to reach 6174 (or 0000).
* **Automatic Mode (a):** The program automatically generates a file named `kaprekar.txt` and calculates the required iterations for *all* valid 4 digit numbers.

## Prerequisites
To compile and run this code, you will need:
* [DOSBox](https://www.dosbox.com/)
* An assembler and linker (e.g., MASM/LINK or TASM/TLINK)

## How to Run in DOSBox
1. Place `kaprekar.asm` and your assembler/linker executables in a local folder (e.g., `C:\8086`).
2. Open DOSBox and mount the directory:
   ```text
   mount c c:\8086
   c:
