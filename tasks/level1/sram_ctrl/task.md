
# SRAM Controller

**Points:** 5 `|` **Keywords**: external interface, datasheets, fsms

[[_TOC_]]

Your task is to create the `sram_ctrl` controller for the DE2-115's 2MB [IS61WV102416BLL](https://www.issi.com/WW/pdf/61WV102416ALL.pdf) [SRAM](https://de.wikipedia.org/wiki/Static_random-access_memory).
Note that an obfuscated reference implementation of the `sram_ctrl`, as well as a package containing related declarations and documentation are available in [lib/sram_ctrl](../../../lib/sram_ctrl/doc.md).



## Background

The *IS61WV102416BLL* is a 2 MB, word-addressable, asynchronous, single-port, static RAM.
This means
 - there are $2^{20}$ memory locations (i.e., addresses), where each stores 16 bits of data
 - its interface does not include a clock signal
 - reading and writing simultaneously is not possible

The purpose of the `sram_ctrl` is to abstract away these hardware details and to provide three separate, byte-addressable, (more or less) independent interfaces to this memory (two read ports and one write port).




## Description

Start by thoroughly reading the documentation of the [provided `sram_ctrl` core](../../../lib/sram_ctrl/doc.md).
Afterwards, create your own implementation in [`sram_ctrl_arch.vhd`](src/sram_ctrl_arch.vhd).


For your implementation consider the following remarks and hints:

- Study the SRAM [datasheet](https://www.issi.com/WW/pdf/61WV102416ALL.pdf) (in particular how write and read accesses work and the involved timings).

- When reading the timing diagrams and tables in the datasheet, always check whether a given parameter is a *maximum* or *minimum* value.

- You can assume that the frequency of the clock signal is 50 MHz.
  This information is important for satisfying the timing constraints of the SRAM.

- The generics of `sram_ctrl` are essentially only for documentation of the semantics of the `sram_ctrl` entity's port ranges.
  We only target the DE2-115's SRAM though, meaning that you can assume that `ADDR_WIDTH=21` and `DATA_WIDTH=16`.

- As stated in the lib core's documentation, the write port is buffered and features a FIFO-like interface.
  To implement this behavior you can simply use a suitable FIFO from the provided [mem_pkg](../../../lib/mem_pkg/doc.md) and set its size according to `WR_BUF_SIZE`.

- Note that the inputs `rdX_addr` and `wr_addr` specify byte addresses, whereas the SRAM is word-addressed.
  Hence, the `sram_ctrl` is responsible for much of the byte-accessing logic.
  However, the `lb_n` and `ub_n` signals might come in handy to select bytes when writing.

- Observe that `sram_dq` (i.e., the `sram_ctrl`'s port connected to the SRAM's data port) is of type `std_logic` and of mode `inout`.
  This is because the SRAM's data port is used for reading and writing, thus requiring the SRAM and the connected controller to actively drive the data wires.
  This is implemented using a tri-state buffer and the `sram_ctrl` must therefore assign the high-impendance value `'Z'` whenever it does not actively write data to the memory.
  Note that this is the **only** time where the `sram_ctrl` must drive `sram_dq` to something other than `'Z'`!

- All `sram_*` output signals shall be fed directly from registers (i.e., they **must not** be generated combinationally)!
  The provided [template](src/sram_ctrl_arch.vhd) already contains suitable code.

- You do not require a synchronizer for `sram_dq`.

- The SRAM can be read in a single clock cycle.
  However, this does not mean that there is no latency involved from the point of view of the SRAM Controller's read ports (refer to the lib core documentation stating that a read may take two cycles).

- Writing to the SRAM takes multiple clock cycles.
  You can implement this using a simple state machine.
  However, be sure that `rd1_busy` and `rd2_busy` are set during a write operation.




## Testbench

Create a testbench for the `sram_ctrl` entity and place it in the provided [template](tb/sram_ctrl_tb.vhd).

Your testbench shall feature accesses to the write and both read ports individually, simultaneous reads on both ports, showing the different priorities and accesses to all three ports simultaneously, showing that write operations are correctly buffered.
Furthermore, make sure to test that byte / word accesses work as specified and that the busy signals are set correctly.

To support you in your efforts, you are provided with a (very basic) simulation model of the SRAM in [IS61WV102416BLL.vhd](../../../lib/sram_ctrl/src/IS61WV102416BLL.vhd).




## Hardware

The top-level architecture in top_arch_sram_ctrl.vhd already instantiates the `sram-ctrl' and declares the required signals.

Implement a simple state machine that first writes an 8 bit counter to the first 256 byte addresses of the SRAM controller.
Then it reads them back and checks whether the data is as expected.
Use LEDs to output the result of this check.
The FSM must read the data in the following way: The two read ports are used to read each pair of bytes simultaneously.
Only after the low priority read port provided its requested data, the next byte pair is read (in the same fashion).

Furthermore, use the on-board SignalTap logic analyzer to capture the control signals of the two read ports and the SRAM, as well as `sram_addr` (the data and the read port addresses are not required) during such a simultaneous read (including the following few clock cycles showing both reads to the SRAM).
Create a screenshot of this and provide it as signaltap.png.

Additionally you can also add more elaborate test cases that test simultaneous reading on both read ports, interleaving reads and writes and so on.

Once you are confident that your `sram_ctrl` works, integrate it into the `vga_gfx_ctrl` and replace the provided obfuscated reference implementation.
Make sure that your tetris game still works with your SRAM controller in place.



## Delieverables

- **Create**: signaltap.png

- **Implement**: [`sram_ctrl_arch.vhd`](src/sram_ctrl_arch.vhd)

- **Implement**: [`sram_ctrl_tb.vhd`](tb/sram_ctrl_tb.vhd)


[Return to main page](../../../README.md)
