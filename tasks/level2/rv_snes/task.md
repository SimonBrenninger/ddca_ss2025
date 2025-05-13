
# RISC-V SNES Controller Interface

**Points:** 5 `|` **Keywords**: risc-v, assembly software development, bit banging

[[_TOC_]]

In this task, you will implement the SNES Controller Protocol from Level 1 in RISC-V Assembly. Only try this task if the [`rv_fsm`](../rv_fsm/task.md) works without **any** issues!



## Description

The structure of this task is a little different from all the other tasks as you don't have to implement any hardware components.

The `software` subdirectory contains the assembly template file (snes.S).
Use [bit banging](https://en.wikipedia.org/wiki/Bit_banging) to implement the SNES Controller Protocol in software.
The SNES controller (i.e., the signals `snes_latch`, `snes_clk` and `snes_latch`) is connected to the memory-mapped GPIOs of the `rv_sys` module.
The memory mappings and behaviors for reads vs. writes are as follows.

GPIO Register Map:

address       | read                                      | write
--------------|------------------------------------------ |---------------------------
`0xFFFF4000`  | `3 downto 0: keys, others: '0'`           | `8 downto 0: ledg`
`0xFFFF4004`  | `17 downto 0: switches, others: '0'`      | `17 downto 0: ledr`
`0xFFFF4008`  | `others: '0'`                             | `hex3 & hex2 & hex1 & hex0`
`0xFFFF400C`  | `others: '0'`                             | `hex7 & hex6 & hex5 & hex4`
`0xFFFF4010`  | `1: snes_latch, 0: snes_clk, others: '0'` | `0: snes_data`

Address `0xFFFF8000` provides access to a memory-mapped (clock) counter.

Your implementation should continuously poll the status of the connected SNES controller and display the current state of the controller on the red LEDs (i.e., GPIO address 0xFFFF4004).
Compared to the hardware `snes_ctrl` from Level 1 your signal will not be perfectly cycle-accurate, which is completely fine for this task.




## Testbench

We already provide you with a testbench template.
Extend it, such that it actually provides input data to the `snes_data` signal and verify that the result produced on the respective GPIO is correct.
The testbench shall check at least two transmissions.
You may be able to reuse parts of your `snes_ctrl` testbench from Level 1.




## Hardware

Use the provided Quartus project to synthesize your design, download it to the FPGA and run your software.
The top-level architecture is already complete, you don't need to modify it.



## Delieverables

- **Implement**: [`snes.S`](software/snes.S)

- **Implement**: [`rv_snes_tb.vhd`](tb/rv_snes_tb.vhd)


[Return to main page](../../../README.md)
