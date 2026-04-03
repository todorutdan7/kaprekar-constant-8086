# Kaprekar's Constant in 8086 Assembly

This repository contains an implementation of [Kaprekar's Constant](https://en.wikipedia.org/wiki/6174_(number)) (6174) written in 8086 asm. 

Kaprekar's routine is an algorithm that involves taking any 4 digit number (where not all digits are the same), sorting the digits in descending and ascending order, and subtracting the smaller number from the larger one. When repeated, this process always outputs the number **6174**.

## Prerequisites
To run this code, you will need an 8086 emulator or assembler such as:

* [DOSBox](https://www.dosbox.com/) with MASM or TASM installed

## How to run
1. Open your emulator
2. Load the `kaprekar.asm` file.
3. Assemble and run the program.

## Built With
* Notepad++
* 8086 Assembly Language
