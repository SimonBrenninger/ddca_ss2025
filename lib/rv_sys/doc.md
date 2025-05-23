
# RISC-V System Package
The purpose of the RISC-V System Package (`rv_sys_pkg`) and the related Software Development Kit (SDK) is to provide a framework that allows you to compile software for, simulate and synthesize the various RISC-V processor cores you will implement in this lecture.
To that end the package provides two modules named `rv_sys` and `memu`.



[[_TOC_]]

## Required Files

- [`delay.vhd`](src/delay.vhd)

- [`memory_jtag.vhd`](src/memory_jtag.vhd)

- [`memory_sim.vhd`](src/memory_sim.vhd)

- [`memu.vhd`](src/memu.vhd)

- [`mm_counter.vhd`](src/mm_counter.vhd)

- [`mm_gci.vhd`](src/mm_gci.vhd)

- [`mm_gpio.vhd`](src/mm_gpio.vhd)

- [`mm_serial_port.vhd`](src/mm_serial_port.vhd)

- [`rv.vhd`](src/rv.vhd)

- [`rv_sys.vhd`](src/rv_sys.vhd)

- [`rv_sys_pkg.vhd`](src/rv_sys_pkg.vhd)

- [`sld_virtual_jtag_stub.vhd`](src/sld_virtual_jtag_stub.vhd)

- [`virtual_jtag_wrapper.vhd`](src/virtual_jtag_wrapper.vhd)


## Overview

While the [RISC-V ISA](../rv_core/doc.md) specifies the instructions of a processor and thus what operations it can perform, it does not really define the processor's surroundings except for the fact that 32-bit instruction- and data words are used.
Where these data words come from and what the respective interface looks like is left to the implementation.
Such details are part of what is referred to as the microarchitecture.
The purpose of this package is to specify and provide the memory subsystem of the DDCA RISC-V processing systems.

Hence, let us first define a physical memory interface that will be used throughout the cores provided by this package.
A memory interface always consists of a pair of signal of the types `mem_out_t` and `mem_in_t`.


```vhdl
type mem_out_t is record
	address  : mem_address_t;
	rd       : std_ulogic;
	wr       : std_ulogic;
	byteena  : mem_byteena_t;
	wrdata   : mem_data_t;
end record;
```


```vhdl
type mem_in_t is record
	busy   : std_ulogic;
	rddata : mem_data_t;
end record;
```



The directional indicators `in` and `out` used in the record names have to be read from the point of view of the module that uses the memory interface (e.g., the processor core).
Note that, following the [Harvard architecture](https://en.wikipedia.org/wiki/Harvard_architecture) design paradigm the processors cors (such as the `rv` entity) have two separate memory interfaces.

The `mem_out_t` record type combines outputs going to a connected memory.
It contains elements for the word-address (`address`), the byte-enable signals (`byteena`) and for the data to be written to memory (`wrdata`).
Note that the interface uses **big-endian** byte ordering (i.e., the most significant byte is stored at the lowest memory address).
The `byteena` signal is used to enable sub-word (write) access.
If bit $b_i$​ of the `byteena` signal is asserted the corresponding byte $i$ in `wrdata` will be written.
Moreover, it contains read / write (`rd` / `wr`) flag to initate memory operations.

The `mem_in_t` record type combines all memory outputs.
The `rddata` signal contains the read data, while the `busy` signal is asserted during an ongoing memory operation.

A memory operation is issued by asserting either `rd` or `wr` for exactly one clock cycle.
While `busy` is asserted no new memory operation (read or write) may be issued.
Asserting both `rd` and `wr` simultaneously is not allowed.
The behavior of the memory interface is such a case is **undefined**.

When `wr` is asserted `address`, `byteena` and `wrdata` must be valid in the same clock cycle.
When `rd` is asserted `address` must be valid in the same clock cycle, `wrdata` and `byteena` are not used.
If neither `wr` nor `rd` is asserted the values of all other signals in the `mem_out_t` record are irrelevant (don't care).

When a read is performed, the earliest the read data is available is in the next clock cycle on`rddata`.
However, it can happen that the memory needs more time to respond and asserts the `busy` signal instead.
Then `rddata` is only valid when busy goes back to low again.
The busy signal may stay high for an arbitray amount of clock cycles.
The timing diagram below illustrates this behavior.
Note that `rddata` is only valid for **one clock cycle**.


![Image Caption](.mdata/mem_read.svg)


## Components

### `rv_sys`
The `rv_sys` module implements the memory subsytem of a RISC-V processing system.
It contains the data and instruction memories, as well as some memory mapped I/O devices.
These devices include a timer, a UART controller and some general purpose inputs and outputs (GPIOs).
The program and instruction memories can be programmed via a JTAG interface from the host PC (details in the SDK section).
For simulation purposes it is also possible to load data and instruction memory contents from files.


```vhdl
component rv_sys is
	generic (
		BAUD_RATE         : natural := 115200;
		CLK_FREQ          : natural := 75000000;
		SIMULATE_ELF_FILE : string  := "OFF";
		GPIO_ADDR_WIDTH   : natural := 8;
		DMEM_DELAY        : natural := 0;
		IMEM_DELAY        : natural := 0
	);
	port (
		clk   : in std_ulogic;
		res_n : in std_ulogic;

		cpu_reset_n : out std_ulogic;

		-- instruction memory interface
		imem_out : in  mem_out_t;
		imem_in  : out mem_in_t;

		-- data memory interface
		dmem_out : in  mem_out_t;
		dmem_in  : out mem_in_t;

		-- UART port
		rx : in  std_ulogic;
		tx : out std_ulogic;

		-- GPIO
		gp_out : out mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
		gp_in  : in  mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0)
	);
end component;
```


#### Interface

The `clk` signal is the clock input, `res_n` is an asynchronous active-low, reset.
The `CLK_FREQ` generic must be set to match the frequency of `clk` (in Hz).

The `cpu_reset_n` signal is an active-low reset that resets the RISC-V core connected to `rv_sys`.
Details on its behavior can be found in the Implementation section below.

The `rv_sys` module provides interfaces to two memories: an instruction memory (`imem_*` signals) and a data memory (`dmem_*` signals).
Note that these signals are named from the processor's point of view (i.e., the processor's instruction memory *output* interface is called *imem_out* in the `rv_sys` interface).

To enable the attached RISC-V processor to conveniently communicate with a host PC, the `rv_sys` module integrates a UART controller, which produces the `tx` signal and reads the `rx` signal.
The baud rate of this interface can be set using the `BAUD_RATE` generic (the baud rate is given in symbols per second).

Finally, the core also features `2**GPIO_ADDR_WIDTH` software read- / write-able 32-bit general purpose inputs (`gp_in`) and outputs (`gp_out`), which can be used to connect other devices, like the FPGA board's I/O.

The generic `SIMULATE_ELF_FILE` is used to initialize the data and instruction memory during simulation.
For synthesis its value must be set to "OFF".




#### Implementation

The `cpu_reset_n` reset signal is connected to `res_n` in simulations. enabling you to simply use a single global reset for the overall system.
On the actual hardware, this signal is controlled via JTAG, allowing your CPU to be reset automatically (e.g., after downloading a new program).



### `rv`
The `rv` module implements represents an RISC-V core that can connected to the `rv_sys` module. Note that the package itself only specifies the entity/component and does not provide an implementation.


```vhdl
component rv is
	generic (
		CLK_FREQ : positive := 50_000_000
	);
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;
		-- Interface to instruction memory
		imem_out : out mem_out_t;
		imem_in  : in mem_in_t;
		-- Interface to data memory
		dmem_out : out mem_out_t;
		dmem_in  : in mem_in_t
	);
end component;
```


#### Interface

The signals `dmem_*` and `imem_*` can directly be conntected to the corresponding signals of the `rv_sys` module.


### `memu`
The Memory Unit (`memu`) is a simple combinational module that converts byte-addressed memory operations (generated by a processor) to the word-addressing big-endian format required to operate the `{i,d}mem_{in,out}` signal of the `rv_sys` core.

```vhdl
component memu is
	port (
		op     : in  memu_op_t;
		addr   : in  mem_data_t;
		wrdata : in  mem_data_t;
		rddata : out mem_data_t := (others => '0');
		busy   : out std_ulogic := '0';

		xl : out std_ulogic := '0';
		xs : out std_ulogic := '0';

		-- to rv_sys
		mem_in  : in  mem_in_t;
		mem_out : out mem_out_t
	);
end component;
```


#### Interface

The `op` input of type `memu_op_t` is used to issue memory operations to the `memu`.
Whereas the `op` input provides the control data for a operation, the respective memory address (byte address!) and write data (in **little-endian** byte order) are provided at `addr` and `wrdata`, respectively.
The result of a read operation is provided at `rddata` in **little-endian** byte ordering (as expected by the processor).


`busy` is asserted during an on-going memory operation.
While this signal is asserted no new memory operation (neither read nor write) must be issued.
Note that the value of `rddata` is only guaranteed to be valid when `busy` is low.


The output `xl` and `xs` indicate load and store exceptions caused by [unaligned](https://en.wikipedia.org/wiki/Bus_error#Unaligned_access) memory accesses.
These signals can be used by a processor to jump to an exception handler.


The `mem_in` and `mem_out` act as counterparts for the `[d,i]mem_[out,in]` signals of `rv_sys`, thus allowing the `memu` to be directly connected to an `rv_sys` memory interface.




#### Implementation

The following table shows how the `mem_out.byteena` and `mem_out.wrdata` signals are set for memory write operations (i.e., `op.wr`=1).
It is assumed that the data word to be written (i.e., `wrdata`) has the format $b_3b_2b_1b_0$ with $b_3$ being the most significant byte.
A value $b_0XXX$ in the last column states that the most significant byte of `mem_out.wrdata` is the least significant byte of $wrdata$ and that the other bytes are irrelevant and may contain arbitrary values

The input `addr` denotes the byte address as provided by the processor.
The address output `mem_out.address` is generated by right-shifting `addr` by two positions.

| `op.access_type` | `addr(1 downto 0)` | `mem_out.byteena` | `mem_out.wrdata` |
| --------- | ------------ | ------- | ------ |
| `MEM_B` (store byte) | 00 | 1000 | $b_0XXX$ |
| `MEM_B` (store byte) | 01 | 0100 | $Xb_0XX$ |
| `MEM_B` (store byte) | 10 | 0010 | $XXb_0X$ |
| `MEM_B` (store byte) | 11 | 0001 | $XXXb_0$ |
| | | | |
| `MEM_H` (store halfword) | 00, 01 | 1100 | $b_0b_1XX$ |
| `MEM_H` (store halfword) | 10, 11 | 0011 | $XXb_0b_1$ |
| | | | |
| `MEM_W` (store word)| XX | 1111 | $b_0b_1b_2b_3$ |


For read operations (i.e., `op.rd`=1), the memory returns the data (`mem_in.rddata`) with the format $=b_3b_2b_1b_0$ (with $b_3$ being the MSB).
The table below shows how the `memu` generates the `rddata` output.
$S$ denotes a sign-extended and $0$ a zero-filled byte.
For example, $SSSb_3$ means that the result of the read operation is the sign-extended most significant byte of the memory interface's `rddata` signal.

| `op.access_type` | `addr(1 downto 0)` | `rddata` |
| --------- | ------------ | ------ |
| `MEM_B` (load byte) | 00 | $SSSb_3$ |
| `MEM_B` (load byte) | 01 | $SSSb_2$ |
| `MEM_B` (load byte) | 10 | $SSSb_1$ |
| `MEM_B` (load byte) | 11 | $SSSb_0$ |
| | | |
| `MEM_BU` (load byte unsigned) | 00 | $000b_3$ |
| `MEM_BU` (load byte unsigned) | 01 | $000b_2$ |
| `MEM_BU` (load byte unsigned) | 10 | $000b_1$ |
| `MEM_BU` (load byte unsigned) | 11 | $000b_0$ |
| | | |
| `MEM_H` (load halfword) | 00, 01 | $SSb_2b_3$ |
| `MEM_H` (load halfword) | 10, 11 | $SSb_0b_1$ |
| | | |
| `MEM_HU` (load halfword unsigned) | 00, 01 | $00b_2b_3$ |
| `MEM_HU` (load halfword unsigned) | 10, 11 | $00b_0b_1$ |
| | | |
| `MEM_W` (load word) | XX | $b_0b_1b_2b_3$ |



## Types and Constants
-   ```vhdl
    constant RV_SYS_ADDR_WIDTH : positive := 14;
    constant RV_SYS_DATA_WIDTH : positive := 32;
    ```
    
    Address and data widths of the instruction and data memories provided by `rv_sys` (in bits).
    Note that the address width refers to the addressable **words** rather than bytes!
    
    
---


-   ```vhdl
    subtype mem_address_t    is std_ulogic_vector(RV_SYS_ADDR_WIDTH-1 downto 0);
    subtype mem_data_t       is std_ulogic_vector(RV_SYS_DATA_WIDTH-1 downto 0);
    subtype mem_byteena_t    is std_ulogic_vector(RV_SYS_DATA_WIDTH/8-1 downto 0);
    ```
    
    Utility subtypes for interfacing with the instruction and data memories.
    Note that `mem_address_t` holds **word** addresses.
    
    
---


-   ```vhdl
    type mem_out_t is record
    	address  : mem_address_t;
    	rd       : std_ulogic;
    	wr       : std_ulogic;
    	byteena  : mem_byteena_t;
    	wrdata   : mem_data_t;
    end record;
    type mem_in_t is record
    	busy   : std_ulogic;
    	rddata : mem_data_t;
    end record;
    ```
    
    The `mem_out_t` and `mem_in_t` record types represent a memory interface and combine all signals going to and coming from memory.
    
    
---


-   ```vhdl
    constant MEM_OUT_NOP : mem_out_t := (
    	address => (others => '0'),
    	rd      => '0',
    	wr      => '0',
    	byteena => (others => '1'),
    	wrdata  => (others => '0')
    );
    constant MEM_IN_NOP : mem_in_t := (
    	busy   => '0',
    	rddata => (others => '0')
    );
    ```
    
    Default values for `mem_out_t` and `mem_in_t` that corresponds to doing no operation (*nop*) at a memory interface.
    
---


-   ```vhdl
    type mem_data_array_t is array(natural range<>) of mem_data_t;
    ```
    
    The `mem_data_t` array type can be used to refer to regions / section of `rv_sys` arrays (e.g., for special memory regions like the addressable GPIO).
    
---


-   ```vhdl
    type memu_op_t is record
    	rd          : std_ulogic;
    	wr          : std_ulogic;
    	access_type : memu_access_type_t;
    end record;
    ```
    
    Contains the control information required for a single operation of the `memu`.
    For read / write operations `rd` / `wr` must be asserted, `access_type` is the respective access type (see below).
    
    
---


-   ```vhdl
    type memu_access_type_t is (
    	MEM_B,
    	MEM_BU,
    	MEM_H,
    	MEM_HU,
    	MEM_W
    );
    ```
    
    This enum type defines the various access modes for memory operations performed by / at the `memu`.
    It supports (unsigned) byte accesses (`MEM_B[U]`), (unsigned) halfword (i.e., 16 bit) accesses (`MEM_H[U]`) and word accesses (`MEM_W`).
    
    
---


-   ```vhdl
    constant MEMU_NOP : memu_op_t := (
    	rd          => '0',
    	wr          => '0',
    	access_type => MEM_W
    );
    ```
    
    Default value for `memu_op_t` that corresponds to no operation (*nop*) at the respective memu interface.
    
    




## Subprograms
```vhdl
function swap_endianness(i : mem_data_t) return mem_data_t;
```

The `swap_endianness` function returns the value passed via its paramete r `i` in reversed byte order.
I.e., it can be used to convert between little endian and big endian byte ordering.






## Software Development Kit (SDK)

In order to compile any software in the VM, you first have to copy the appropriate RISC-V compiler from the lab.
Execute the following commands inside the VM:

```bash
scp USERNAME@ssh.tilab.tuwien.ac.at:/opt/ddca/riscv.tar.gz .
sudo mkdir -p /opt/ddca
sudo tar -xvf riscv.tar.gz -C /opt/ddca/
```

Don't change any of the paths and place the compiler exactly in this directory, otherwise it will not work.


The [`sdk`](sdk) directory contains Makefiles that implement all the required steps to compile C or assembly programs and to download the generated binaries to the data and instruction memories of an `rv_sys` instance.
In order to use them, you have to create a Makefile and include either [rv_asm.mk](./sdk/rv_asm.mk) or for assembly programs or [rv_c.mk](./sdk/rv_c.mk) for C-programs.
You will find more details about what to include and to configure for creating your own testcases further below in the *Testcases* section of this documentation.
However, including the respective Makefile allows compiling testcases inside their respective directory (e.g., calling `make` in `testcases/asm/send_uart`).

Successful compilation of a testcase (no matter if C or assembly) generates a `.elf` executable file, as well as the files `.imem.mif` and `.dmem.mif`, which contain the contents of the instruction and data memories, respectively.
E.g., for the `send_uart` test case the files [`send_uart.elf`](testcases/asm/send_uart/send_uart.elf), [`send_uart.imem.mif`](testcases/asm/send_uart/send_uart.imem.mif) and [`send_uart.dmem.mif`](testcases/asm/send_uart/send_uart.dmem.mif) files will be created.
The `.mif` files are **human-readable** and can be quite useful for debugging processors.
In particular, each row of the file contains a single instruction / data word where the row number is the word address (starting at 0).

The `clean` target can then be used to delete all files created during compilation.


After a program has been compiled successfully, it can be downloaded to the actual processing system running on the FPGA (i.e., the data and instruction memories in the `rv_sys` module).
To do so, first program the FPGA with the desired bitstream (SOF file) and then execute the `run` Makefile target in the respective testcase directory.

You can also use the `remote_run` target to download your program to a board in the Remote Lab.
To use this target you must already have an active connection to the Remote Lab, i.e., either via `rpa_shell.py` or `rpa_gui.py`.




## Testcases

We already provide you with some demo programs, which can be used to test RISC-V processors attached to the `rv_sys` core in the [testcases](./testcases) directory.
The provided testcases can be categorized into those that are directly written in our ISA's assembly language, and those that are written in C.

While C allows you to write complex programs a lot more efficiently and less error-prone than in assembly, for debugging a processor, writing and running assembly code is strongly recommended, as this gives you (almost) full control of what is actually executed.
Later in the development you can switch to C to try more elaborate programs.


For C-programs we provide you with some library functions in [util.h](sdk/util.h).
Use these functions to write to (and potentially read from) the UART interface and to read and write the GPIOs.
Please note that the program is not linked against a full-featured *libc*.
Therefore, not all standard functions are available.


While the testcases we provide you with are a first starting point, they are insufficient for debugging your processor.
You will therefore have to create your own testcases.
In the following we'll explain how this can be done.

Create and place your testcases in a `user` subdirectory in the [testcases](testcases/) folder.
Each individual testcase in turn resides in its own subdirectory (e.g., `testcases/user/mytestcase`).
Each testcase consists of the following files:

- Makefile: This Makefile is responsible to compile the software part of a testcase. For assembly language testcases this file only needs to include the [`rv_asm.mk`](sdk/rv_asm.mk) file (refer to the [`startup`](testcases/asm/startup/Makefile) testcase for a basic example).
  For C-programs the [`rv_c.mk`](sdk/rv_c.mk) file must be included and additionally, the source files and the target elf file name must be specified using the `SRC_FILES` and `ELF_NAME` Make variables.
  A basic example is the [`uart_loopback`](testcases/c/uart_loopback/Makefile) testcase.

- *RISC-V Testcase (RVTC) Makefile*: This is another Makefile containing a series of Make variables that provide information for the actual simulation.
  Its filename must end in `rvtc.mk`. We recommend naming this file after the testcase folder it resides in (e.g., `mytestcase.rvtc.mk`).
  The RVTC Makefile must first annouce the testcase name to the test framework by appending a unique name to the `RV_TESTCASES` Make variable (e.g., `RV_TESTCASES+=MYTESTCASE`).
  All other variables that are set in the file must then be prefixed with this name (e.g., setting the `TB` variable below actually requires you to set `MYTESTCASE_TB=some_tb`).
  There are only two required variables that must always be set:

   - `TB`: The **entity name** of the testbench used to run the testcase simulation. Refer to the *Creating Testcase Testbenches* section to learn about the minimal set of generics testcase testbenches must provide.
   - `ELF_FILE`: The complete **absolute** path to the ELF file the processor shall execute in the testcase. This path is passed into the testbench entity via its `ELF_FILE` generic.

  The optional variabes are:

   - `[GTKW_]WAVE_FILE`: These variabes override the default wave file in a task's Makefile, set via the `[GTKW_]WAVE_FILE` varibales.
   - `[GHDL|VSIM]_USER_ARGS`: User defined arguments passed to the simulator (Questasim / GHDL).
   - `VHDL_FILES`: VHDL files that are required for the testcase (in most cases this will be the actual testbench). Note that here also an absolute path must be specfied.
   - `NAME`: The default name used for the testcase is the one appended to the `RV_TESTCASES` variable. This name is used for as a prefix for the automatically generated makefile targets and is also passed to the testbench via its `TESTCASE_NAME` generic. Explictly setting the `NAME` variables overrides this default value.

- Actual source files: For an assembly test case this must be a single file (e.g., `mytestcase.S`). For C programs multiple (source and header) files can be used (e.g., `mytestcase.c` and `mytestcase.h`).

- Optional: A VHDL file containing a particular testbench for this testcase (e.g., `TESTCASE_tb.vhd`).
  More details on the actual testbenches can be found below.

Examples on which you can base your testcases can be found in [send_uart](testcases/asm/send_uart) and [uart_loopback](testcases/c/uart_loopback).

Each testcase adhering to the structure decribed above, results in the creation of a set of Make targets that can then be used to test your various RV implementations.
In particular, the following targets will be created (`NAME` refers to the name choosen for the testcase):

- `NAME_info`: Dumps information about the testcase like its name, the target elf, used testbench etc.
- `NAME_[g]sim`: Runs a simulation using GHDL / QuestaSim for the respective testcase in headless mode.
- `NAME_[g]sim_gui`: Runs a simulation using GHDL / QuestaSim for the respective testcase and opens the waveform viewer.

Furthermore, the Makefile targets `rvall_[g]sim` are provided that run **all** testcases and grep for reports of "PASSED" / "FAILED".
You can use this for simple regression testing.


As mentioned above, each testcase has a dedicated testbench.
However, such testbenches cannot be arbitrary but must provide at least two generics:

- `TESTCASE_NAME` of type string
- `ELF_FILE` of type string

These generics are then later set to the values of particular testcases by the framework.
Hence, you do not need to provide (default) values for them.
However, you can add aribtrary further generics which are set during simulation by the framework.
An example, is the provided [`rv_uart_io_tb`](tb/rv_uart_io_tb.vhd) testbench that declares a `UART_RX` and `UART_TX` generic and uses them to check received UART data, and to transmit data via UART by itself.
Such generics can then easily be set in the `*.rvtc.mk` files via the `NAME_[GHDL|VSIM]_USER_ARGS` by setting them to particular values using the `-gGENERIC='VALUE'` switch.
You can find an example in [uart_loopback.rvtc.mk](testcases/c/uart_loopback/uart_loopback.rvtc.mk).


To assist you in your debugging efforts, `rv_sys` reports certain events for which you can grep in the simulator output.
That way you can easily get "traces" / event sequences for your testcases and thus pinpoint misbehavior of your processor(s).
The following is reported using the listed prefixes for which you can grep:

- Uart transmission: `UART TX`
- Uart reception: `UART RX`
- Write to / read from data memory: `DMEM write` / `DMEM read`
- Read from instruction memory: `IMEM read`
- GPIO access: `GPIO`

For example, to get all UART events (transmission and reception), you could simply run
```bash
make send_uart_gsim | grep UART
```


While all of the above might seem daunting, much of it is optional, allowing you to tailor your testcases and to make them more powerful.
To get you started you can refer to the `startup` assembly testcase which simply checks if a sequence of writes to the data memory is performed correctly.
Later, when you are certain your processor works for such simple cases you can look at the provided UART testcases and create similar ones where UART is used to convey whether a testcase passed or failed.




[Return to main page](../../README.md)
