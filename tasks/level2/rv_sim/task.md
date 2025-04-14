
# RISC-V Simulation Model

**Points:** 15 `|` **Keywords**: simulation, risc-v, specifications

[[_TOC_]]

By now you have already experienced how useful simulations are when designing (and especially debugging) hardware.
The goal of this task is to create a simulation model (`rv_sim`) of the RV32I RISC-V ISA, you will then implement in actual hardware in following tasks.



## Description

Start by thoroughly reading the specification of the RV ISA we'll use in DDCA, provided in [`rv_core`](../../../lib/rv_core/doc.md).
Next, implement this ISA in the `rv_sim` module (a template is already provided in [`rv_sim.vhd`](src/rv_sim.vhd)).
Be aware that this is a **simulation model**.
Hence, your code is not required to be synthesizable (in fact, there is not even a Quartus project for this task) and you can thus make use VHDL in all its glory.

For your implementation consider the following remarks and hints:

- Your processor shall read instructions from the instruction memory (starting at address 0) and execute them immediately.
  Unless, you have to access the data memory this shall happen in the same clock cycle.

- Take care that the individual bytes after reading from / writing to a memory are in correct order (the [ISA](../../../lib/rv_core/doc.md) specifies a little endian byte ordering!).

- Writing to the instruction memory is not required (it is treated as read-only memory).
  Hence, some of the signals of the `rv_sim` entity's interface are unused (select appropriate default values).

- To make your life easier and to reduce the amount of redundant code, make use of procedures and functions for the different parts / functionality of the `rv_sim`.
  The provided template already contains some skeletons for useful procedures. We highly recommend you to implement them as suggested and to use them.
  You might want to start with the `read_from_imem` procedure to load instruction words from the instruction memory interface.
  The two procedures for reading from / writing to the data memory (`*_dmem`) are not immeditately required.

- Make use of the constants, types and functions of the [`rv_core_pkg`](../../../lib/rv_core/src/rv_core_pkg.vhd) for decoding instructions.

- While you might already know specific RISC-V architectures from other lectures (e.g., pipeline or FSM implementations), you are not required to adhere to any such specific architecture as this is merely a simulation model.
  You can decide freely how to implement the given ISA.

- Note that the provided assembly code files are written to also work on a RISC-V pipeline that does not deal with hazards and hence contains `NOP` instructions after jumps.
  However, since hazards are of no concern for your simulation model (which executes instructions immediately), such `NOP` instructions should not be read and executed by your processor.

- We strongly recommend you to develop and test your `rv_sim` implementation in parallel, i.e., whenever you implement a set of instruction, test it with a small assembly program (see below part about the Testbench).
  A good idea would be to start with the arithmetic functions first. Make sure they work when using two register operands and when using an immediate value.
  Next, you might want to implement the load and store instructions, and then the jump instructions.




## Testbench

In order to actually test your processor, run programs on it and check if they work as expected (you can observe the register contents, memory interfaces and - if available - UART output).
We already provide you with some programs in [`rv_sys/software`](../../../lib/rv_sys/software) and we recommend you to also put your own programs in the [`software`](../../../lib/rv_sys/software) folder of the `rv_sys` lib core, as you might use them for other tasks as well. However, make sure to put them in a dedicated subdirectory, e.g., named `user`.

However, as written above, start with verifying basic functionality such as arithmetic, memory and jump instructions in lockstep with your implementation efforts and then continue with more elaborate programs.

To add your own, more targeted, testcases check out the respective section in the documentation of [`rv_sys`](../../../lib/rv_sys/doc.md).



## Delieverables

- **Implement**: [`rv_sim.vhd`](src/rv_sim.vhd)


[Return to main page](../../../README.md)
