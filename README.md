# Kaprekar's Constant in 8086 Assembly

This repository contains an implementation of [Kaprekar's Constant](https://en.wikipedia.org/wiki/6174_(number)) (6174) written in Intel 16-bit 8086 Assembly language. 

## About the Project
Kaprekar's routine is an algorithm that involves taking any 4 digit number (where at least one digit is different), sorting the digits in descending and ascending order, and subtracting the smaller number from the larger one. When repeated, this process always yields the number **6174**.

## Features
The program includes a text menu offering two modes:
* **Interactive Mode (`i`):** The user inputs a 4 digit number, and the program calculates and prints the number of iterations required to reach 6174 (or 0000).
* **Automatic Mode (`a`):** The program automatically generates an external file named `kaprekar.txt` and calculates the required iterations for *all* valid 4 digit numbers.

## Prerequisites
To compile and run this code, you will need:
* [DOSBox](https://www.dosbox.com/) (or a similar DOS emulator)
* An assembler and linker, such as:
  * **TASM** (Turbo Assembler) / **TLINK**

## How to Run (DOSBox)

1. Create a folder on your computer (e.g., `C:\8086`).
2. Place `kaprekar.asm` and your assembler/linker executable files (like `tasm.exe` and `tlink.exe`) into this folder.
3. Open DOSBox and mount the directory by typing:
   mount c c:\8086
   c:

Assemble the code to create the object file. (Example using TASM):
tasm kaprekar.asm

Link the object file to create the executable:
tlink kaprekar.obj

Run the program:
kaprekar.exe
