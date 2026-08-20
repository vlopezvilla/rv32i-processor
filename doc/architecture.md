# Architecture

## Modules

- `alu.v` — arithmetic/logic unit (ADD, SUB, AND, OR, XOR, SLT)
- `registers.v` — 32x32-bit register file, x0 hardwired to 0
- `decoder.v` — instruction field/immediate extraction (R/I/S/B/U/J-type)
- `cpu.v` — single-cycle datapath: fetch, decode, register read, ALU, write-back
- `imem.v` — instruction memory (not yet implemented)
- `dmem.v` — data memory for loads/stores (not yet implemented)
- `top.v` — top-level module wiring cpu + imem + dmem (not yet implemented)

## Block diagram

See `block_diagram.png` (add when available).
