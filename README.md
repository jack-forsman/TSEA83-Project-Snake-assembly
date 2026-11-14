# Snake on a Microcoded CPU

This project is a hardware implementation of the classic Snake game for the
Digilent Basys 3 FPGA board. The game runs on a custom 16-bit microcoded CPU
written in VHDL rather than on a soft processor or an embedded software
runtime. The CPU executes the Snake program, reads movement commands from a
PS/2 keyboard, updates the game state in memory, and produces the game display
through VGA.

The project was developed for the TSEA83 computer engineering course and
demonstrates how a complete interactive application can be built from
processor, memory, input, and video hardware.

## Features

- Microcoded CPU with a 16-bit data path and a 26-bit microinstruction format
- Program memory containing the Snake game and its control flow
- Data memory for the snake length, body positions, and temporary state
- Memory-mapped video RAM for the board, snake, apple, and walls
- PS/2 keyboard decoder with W/A/S/D movement controls
- VGA output using a character/tile ROM and a 640 x 480 active display area
- Collision detection for walls and the snake itself
- Apple collection that increases the snake length
- Reset through the center button on the Basys 3 board

## Hardware and software

### Hardware

- Digilent Basys 3 FPGA board
- VGA monitor and cable
- USB keyboard connected through the Basys 3 PS/2-compatible keyboard input

### Tooling

- VHDL simulator such as ModelSim or Questa
- Xilinx Vivado for synthesis and FPGA programming
- The TSEA83 course build utilities, which are included by the Makefile

The build setup targets the 100 MHz Basys 3 system clock. Pin assignments for
the clock, reset button, keyboard interface, and VGA output are defined in
[`uCPU/Basys3.xdc`](uCPU/Basys3.xdc).

## How to play

1. Program the generated bitstream onto the Basys 3 board.
2. Connect a VGA monitor and a keyboard.
3. Press the center button to reset the game.
4. Use **W**, **A**, **S**, and **D** to move up, left, down, and right.
5. Collect apples to grow the snake and avoid the walls and the snake's body.

The game stops when the snake collides with a wall or itself. A timer-based
value is used when selecting a new apple position, providing simple
pseudo-random placement without a separate random-number generator.

## Project structure

```text
uCPU/
├── uprogCPU.vhd       Top-level CPU and component interconnect
├── Mem/
│   ├── uMem.vhd      Microinstruction memory
│   ├── pMem.vhd      Snake program memory
│   ├── DMem.vhd      Data memory
│   ├── K1Mem.vhd     Opcode-to-microaddress mapping
│   └── K2Mem.vhd     Addressing-mode mapping
├── alu_comp.vhd       Arithmetic and logic unit
├── kbd_enc.vhd        PS/2 keyboard decoder
├── video_ram.vhd      Dual-port game tile memory
├── char_rom.vhd       Tile and sprite graphics
├── vga_motor.vhd      VGA timing and pixel generation
├── uprogCPU_tb.vhd    Basic simulation testbench
├── Basys3.xdc         FPGA pin constraints
└── Makefile            Simulation and build configuration
```

## Building and simulating

From the `uCPU` directory, use the course-provided Makefile targets:

```bash
cd uCPU
make
```

The exact available targets depend on the TSEA83 course environment and the
installed FPGA/simulation tools. The top-level design entity is `uprogCPU`, and
the testbench entity is `uprogCPU_tb`.

## Memory-mapped peripherals

The CPU uses address decoding to access its peripherals:

| Address range | Peripheral |
| --- | --- |
| `0x0000–0x03FF` | Program memory |
| `0x0400–0x07FF` | Data memory |
| `0x0800–0x0FFF` | Video RAM |
| `0x1000` | Keyboard input |
| `0x1001` | Timer-based value used for apple placement |

This organization lets the game program use the same instruction and data
paths for ordinary memory operations and for interacting with the keyboard and
display hardware.
