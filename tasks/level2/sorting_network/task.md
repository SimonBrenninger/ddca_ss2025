
# Sorting Network

**Points:** 10 `|` **Keywords**: pipeline

[[_TOC_]]

In this task you will implement a [*sorting network*](https://en.wikipedia.org/wiki/Sorting_network).
As the name suggests, such networks can be used to sort values.
For reference check out [this list](https://bertdobbelaere.github.io/sorting_networks.html) of `Smallest and fastest sorting networks for a given number of inputs`.



## Description

The particular network you will implement in this tasks features 10 inputs, uses 29 *compare/exchange elements* (CEs) and 8 has layers.
It is thus referred to as `N10L29D8`.

Note that, although it is not directly about pipelining, the [video about the synchronous design style](https://hwmod.lva.tuwien.ac.at/sync.html) of Hardware Modeling might be a good resource to grasp the concept of pipelining.

The sorting network shall be implemented as architecture(s) of the following entity:


```vhdl
entity sorting_network is
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;

		-- UART data streamer interface
		unsorted_ready   : out std_ulogic;
		unsorted_data    : in word_array_t(0 to 9);
		unsorted_valid   : in std_ulogic;

		sorted_ready     : in std_ulogic;
		sorted_data      : out word_array_t(0 to 9);
		sorted_valid     : out std_ulogic
	);
end entity;
```


The `clk` signal is the clock input, `res_n` is an asynchronous active-low, reset.

The remaining ports of the entity conform to the interface of the [uart_data_streamer](../../../lib/uart_data_streamer/doc.md)'s streaming interfaces, so be sure to check out its documentation before you start implementing!

Whenever the sorting network asserts `unsorted_ready` it signals that it is ready to consume new (unsorted) data.
A high `unsorted_valid` implies that `unsorted_data` holds a valid array of 10 32-bit vectors that shall be sorted.

An asserted `sorted_ready` signals the sorting network that the module consuming the sorted data, provided at `sorted_data`, is ready for new data.
Whenever this is the case and the sorting network is done, it should assert `sorted_valid` and provide the sorted data at `sorted_data` simultaneously.


In order to demonstrate the properties of pipelining a design, you will implement multiple architectures in this task and compare them.
Below you will find a short description of the different architectures and steps of this task:

- Start by simply describing a combinatorial architecture that implements the sorting network.
  If you did not do so before, carefully read the specification of the `N10L29D8` network in [this list](https://bertdobbelaere.github.io/sorting_networks.html#N10L29D8).

  Then, implement the `sorting_network_combinatorial` architecture for the `sorting_network` entity in [`sorting_network_combinatorial.vhd`](src/sorting_network_combinatorial.vhd).

- Next, ensure that your testbench (see Testbench section) validates that your **combinatorial** sorting network is actually capable to sort.
  In particular, at latest now you should implement the testbench.

- Synthesize your **combinatorial** sorting network, download it to the FPGA board and utilize the UART interfface to send the data that shall be sorted (and receive the sorted one).
  Also: Check Quartus' timing analyzer and note down your `Fmax` (highest possible clock frequency) and `Worst-Case Timing Paths`.


- Next, answer the following questions about your combinatorial sorting network in [`questions.md`](questions.md) (this file will also be submitted):

  - Why does your sorting network supposedly sort the first inputs?
  - Why does your sorting network fail to successfully sort the second inputs?
  - What is your design's `Fmax`? Explain how you got this value.
  - What is your design's `Critical-Path`? Explain how you got this information.

- In the previous steps you should have observed that your combinatorial sorting network does work in the simulation, but not in hardware.
  This is expected and we will next discuss how this can be dealt with.
  In principle there are two ways, both of which you will explore in the following:

  - Delay the combinatorial logic of your cricital-path such that your design supports the given clock frequency.
  - Introduce work-steps (pipeline stages) and furthermore improve throughput.




### Delay

The straightforward approach is to introduce delays into your design.
This requires `unsorted_ready` to be low for the time the sorting takes place.
Additionally, you have to delay asserting `sorted_valid`.
Find the number of cycles required to successfully sort the consecutive two inputs from the previous hardware step.

Put your delayed architecture in [`sorting_network_delayed.vhd`](src/sorting_network_delayed.vhd).

Your circuit should now be able to correctly sort the previous inputs.
However, this approach does not make use of any benefits provided by higher clock frequencies!
Additionally, Quartus still complains about timing violations if we do not manually provide timing information about the delay!




### Pipelining


In order to fix timing violations in addition to making use of higher clock frequencies and throughput, you have to introduce work steps via pipeline stages.
The layers given by [`N10L29D8`](https://bertdobbelaere.github.io/sorting_networks.html#N10L29D8) are perfect candidates for such steps.
Introduce registers between layers in order to allow pipelined operation of the circuit.
This way you reduce the critical-path to be between two layers instead of the whole network.
Additionally, your sorting network should now be able to support consuming data in each clock cycle (`unsorted_ready` is always high).
This also enables your network to actively sort multiple inputs at the same time.
**Assert `sorted_valid` for one clock cycle whenever a valid sorted data array is at the output.**

Put your pipelined architecture in [`sorting_network_pipelined.vhd`](src/sorting_network_pipelined.vhd).

Test your design in testbenches before synthesizing your design.
Especially check, whether your sorting network asserts `sorted_valid` in the correct clock cycle.

When done correctly, your pipelined design should be able to run on a 150 MHz clock without timing violations.
If not, always check for the ciritical path and try to optimize your design.

**Hint:** `sorted_valid` should 'follow' the input data through the pipeline stages in your network. Check out shift registers.




## Testbench

Implement a testbench for your `sorting_network` in the provided [`sorting_network_tb.vhd`](tb/sorting_network_tb.vhd) file.
Use two processes, one for providing unsorted data to the `sorting_network` and for consuming the sorted data.
The process responsible for consuming the data shall also assert if it is correctly sorted.




## Hardware

After downloading your design to the board, you can utilize the UART interface to send data to be sorted.

You are already provided with the [`top_arch.vhd`](top_arch.vhd) file, containing a top architecture that instantiates your design and the [uart_data_streamer](../../../lib/uart_data_streamer/doc.md) and connects them to each other.
Additionally, a pll that generates the desired 150 MHz clock frequency is also already provided and appropriately connected.
There is no need to change the given top architecture.

To use UART, perform the following steps:

- Reset your design and assert `halt` (put `SW0` high) of the `uart_data_streamer`.
- Send two different inputs to be sorted (e.g. numbers and strings). The documentation of [top](../../../lib/top/doc.md) provides information about how to do that.
- Unassert `halt` such that the `uart_data_streamer` sends both words in consecutive clock cycles to your network and check the results.

**Hint:** Yout can use "0003000900070005000600010000000800020004" and "wisppavelushgermcozyhazeyarnployvastdusk" as reference UART inputs.



## Delieverables

- **Implement**: [`questions.md`](questions.md)

- **Implement**: [`sorting_network_combinatorial.vhd`](src/sorting_network_combinatorial.vhd)

- **Implement**: [`sorting_network_delayed.vhd`](src/sorting_network_delayed.vhd)

- **Implement**: [`sorting_network_pipelined.vhd`](src/sorting_network_pipelined.vhd)

- **Implement**: [`sorting_network_tb.vhd`](tb/sorting_network_tb.vhd)

- **Implement**: [`top_arch.vhd`](top_arch.vhd)


[Return to main page](../../../README.md)
