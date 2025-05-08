
# RISC-V M Extension

**Points:** 10 `|` **Keywords**: risc-v, specifications

[[_TOC_]]

In this task you will take the RISC-V cores developed so far and extend them to support the multiplication and division instructions defined by the RISC-V [**M Extension**](https://five-embeddev.com/riscv-user-isa-manual/Priv-v1.12/m.html).



## Description

As you might have noticed, the ISA specified in the [rv_core](../../../lib/rv_core/doc.md) package does not contain instructions for integer multiplication and division.
Currently, such operations are handled by the compiler by building them out of a combination of available instructions (typically shift and addition).
Obviously, such multiplication and division operations are quite expensive in terms of clock cycles required.
However, some applications might depend on multiplications and / or divisions to be fast (e.g., in signal processing applications).
This is typically achieved by equipping a processor with dedicated multiplication / division instructions that use hardware multipliers and dividers.

In the case of the RISC-V ISA, integer multiplication, division and remainder instructions are specified in the [**M Extension**](https://five-embeddev.com/riscv-user-isa-manual/Priv-v1.12/m.html).




### `rv_sim`: M Extension

As a first step read the linked [specification](https://five-embeddev.com/riscv-user-isa-manual/Priv-v1.12/m.html) and implement it in your [rv_sim](../rv_sim/task.md) core.
The [rv_core](../../../lib/rv_core/doc.md) package already contains some useful constants you can use.
Keep in mind, though, that the `rv_sim` core is merely a simulation model and should thus execute instructions in a single clock cycle.
This applies to the M-extension instructions as well
However, you can thus use the available operators for multiplication and division (you might want to look at the `rem` operator as well).




#### Testbench

To test your implementation you can use the `ext_m` C testcase.
However, for more detailed debugging, it definitely makes sense to include a few assembly-level user testcases.
Only after that works continue with the rest of the task.




### `rv_ext_m` Module

To support the M extension instructions in an actual synthesizable RISC-V core, the required functionality is first implemented in the `rv_ext_m` module, which has the following interface:


```vhdl
component rv_ext_m is
	generic (
		DATA_WIDTH : natural := 32
	);
	port (
		clk    : in std_ulogic;
		res_n  : in std_ulogic;
		a, b   : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
		result : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
		op     : in ext_m_op_t;
		start  : in std_ulogic;
		busy   : out std_ulogic
	);
end component;
```


As usual, `clk` and `res_n` are the clock and the active-low reset inputs.
The inputs `a` and `b` are the operands on which the module will perform its operation, whereas `result` is the corresponding result.
The generic `DATA_WIDTH` allows to set the bit width of the operands and the result.
The `op` input allows to set the desired operation (you can find the declaration of the `ext_m_op_t` type in [`rv_ext_m_pkg.vhd`](src/rv_ext_m_pkg.vhd)).
The remaining signals implement the following interface:

- The `start` input is set *for a single clock cycle* whenever an operation shall start.
  While `start` is set, `a`, `b` and `op` must be valid.

- The `busy` signal is set while the module is currently executing an operation.
  Once `busy` goes low again (i.e., after the operation completes), `result` is set to the respective operation's result.

The provided architecture in [`rv_ext_m.vhd`](src/rv_ext_m.vhd) already instantiates two IP cores that must be used for the multiplication (`LPM_MULT`) and division (`LPM_DIV`).
These IP cores make use of dedicated hardware resources of the FPGA to implement these costly operations.
Furthermore, the IP cores are already configured to internally pipeline their computations such that they can be done at the desired frequency.
Note that these **instantiations must not be changed**.

For your implementation of the M-extension, consider the following:

- Finish the architecture by implementing an FSM for the M-extension.

- Be aware that the two IP core instantiations are set to `"UNSIGNED"`.
  Thus, they only operate correctly if their inputs are unsigned.
  However, the instructions defined by the M-extension require the multiplication / division of signed numbers and a mix of signed and unsigned (for `MULHSU`) as well.
  To achieve this, add logic for converting inputs and the result of the operation whenever required.

- Note that for the `MUL` instruction the signedness of the operands does not matter, as only the lower 32 bits of the 64 bit result are used.
  For the other operations, recall that signed numbers use [two's complement](https://en.wikipedia.org/wiki/Two%27s_complement) (it is easy to invert numbers and to detect if they are negative)

- Take care to implement the special cases of the division instructions as defined in the specification.

- In order to not waste any clock cycles, make sure that `busy` and `result` are updated as soon as possible.
  For the multiplication and the special cases of the division, the results can be determined in a single clock cycle and the result should be provided accordingly.
  I.e., do not simply always set it after the amount of clock cycles it takes for the division to finish (which is the slowest operation).




#### Testbench

Create a testbench (a skeleton is already provided in [`rv_ext_m_tb.vhd`](tb/rv_ext_m_tb.vhd) that thoroughly check your `rv_ext_m` module before proceeding with the hardware check of this task.
The testbench shall exhaustively check all operations for all possible input values (the generic `DATA_WIDTH` allows you to set the data width to, e.g., 4 to make this is feasible).

Note that in the testbench you make use of the available multiplication and division operators (make sure to handle the special cases and signed though).
Ideally, you can reuse much of the code you wrote for extending your `rv_sim` core.




### `rv_fsm`: M Extension

Integrate the `rv_ext_m` module into your [`rv_fsm`](../rv_fsm/task.md) core, by adapting [`rv_fsm.vhd`](../rv_fsm/src/rv_fsm.vhd) and [`ctrl_fsm.vhd`](../rv_fsm/src/ctrl_fsm.vhd`) accordingly.
Make sure that `rv_busy` at the instantiation of `ctrl_fsm` is connected to the respective singal of the `rv_ext_m` instance (per default it is `'0'`).
Use the value `SEL_EXT_M` of the `mwb_ctrl_t` enum type to forward the `result` output of the `rv_ext_m` module to the register file.




#### Testbench

Test your implementation using the `ext_m` testcase and the assembly testcases you might have created for the `rv_sim`.




#### Hardware

Use the provided Quartus project of the `rv_fsm` task to synthesize your core.
Download it to the FPGA and make sure the `ext_m` testcase also works in hardware.
Also be sure to check the other testcases to ensure you didn’t break any existing functionality.



## Delieverables

- **Implement**: [`ctrl_fsm.vhd`](../rv_fsm/src/ctrl_fsm.vhd)

- **Implement**: [`rv_fsm.vhd`](../rv_fsm/src/rv_fsm.vhd)

- **Implement**: [`rv_sim.vhd`](../rv_sim/src/rv_sim.vhd)

- **Implement**: [`rv_ext_m.vhd`](src/rv_ext_m.vhd)


[Return to main page](../../../README.md)
