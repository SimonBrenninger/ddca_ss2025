
# Graphics Command Interpreter

**Points:** 15 `|` **Keywords**: advanced testbench, specifications

[[_TOC_]]

In this task you will implement the `gfx_cmd_interpreter` which acts as a sink for the graphics command interface specified in the [graphics command interface core package](../../../lib/gfx_core/doc.md).
It will be an important tool for implementing the Tetris game in a follow-up task.



## Description

The purpose of the `gfx_cmd_interpreter` is to implement a **simulation** model of the graphics command sink interface specified [here](../../../lib/gfx_core/doc.md).
This allows to test modules that implement a graphics command source interface, such as the Tetris game, by directly connecting it and instance of the `gfx_cmd_interpreter`.
The `gfx_cmd_interpreter` then dumps the rendered frames as images on the computer running the testbench.
This greatly simplifies testing as it mitigates the need to look at waveforms of the graphics command source interface (e.g., for the Tetris game).
To illustrate the need of such a module: Just the *initialization* of the `Tetris` game issues hundreds of data words to the graphics command interface.
Finding bugs by just looking at the graphics command stream is therefore not very effective.

Note that because the `gfx_cmd_interpreter` is only intended to be used in a simulation setting, it is **not** meant to be synthesizable.
Therefore, there is no need to implement a classic state machine, as you would for "real" hardware, in order to provide the required functionality.

Another core that also implements a GCI sink will be the `vga_gfx_ctrl` you use when implementing the game.
However, in contrast to the `gfx_cmd_interpreter`, the `vga_gfx_ctrl` is synthesizable and can be used on an FPGA.
Hence, you can view the `gfx_cmd_interpreter` as a simulation model for the `vga_gfx_ctrl`.
Therefore, whenever a module outputs something over a graphics command interface the `gfx_cmd_interpreter` can be used to actually visualize this output.

**Important**: Before you continue reading with reading this task description, you should consult the [`gfx_core`](../../../lib/gfx_core/doc.md) documentation to get an overview of the GCI and its functionality.
You should also have a look at the [`gfx_cmd_pkg`](../../../lib/gfx_core/src/gfx_core_pkg.vhd), as it contains important constants and functions that will help you with your implementation.

You are already provided with a [template](src/gfx_cmd_interpreter.vhd) for the interpreter containing some very basic code and procedure / function skeletons.
You do not have to use the provided code, but we strongly suggest you to.
The interface of the `gfx_cmd_interpreter` entity is


```vhdl
entity gfx_cmd_interpreter is
	generic (
		OUTPUT_DIR : string := "./"
	);
	port (
		clk     : in std_ulogic;
		gci_in  : in gci_in_t;
		gci_out : out gci_out_t
	);
end entity;
```


The `gfx_cmd_interpreter` should simply receive graphics commands via the `gci_in` signal, and **immediately** execute them by performing the appropriate graphical operations on an internal data structure representing the VRAM.
This data structure is implemented by the [protected type](https://fpgatutorial.com/vhdl-shared-variable-protected-type/) `vram_t` defined in the [tb_util_pkg](../../../lib/tb_util/src/tb_util_pkg.vhd) package.
Protected types in VHDL are comparable to classes in other programming languages.
However, you do not really need to fully understand this code or the concept of protected types in order to use it.
The code in the template already shows how to integrate it into your `gfx_cmd_interpreter`.

The `vram_t` type features functions to read and write bytes and words from and to VRAM.
Furthermore, it contains a function to dump an image in VRAM to a [PPM image file](https://en.wikipedia.org/wiki/Netpbm).
Note that since PPM is a text based-format, the resulting images can be quite large.

Your `gfx_cmd_interpreter` should support **all** commands defined in the [documentation](../../../lib/gfx_core/doc.md).
For `DRAW_CIRCLE` use the [Bresenham algorithm for circles](https://de.wikipedia.org/wiki/Bresenham-Algorithmus#Kreisvariante_des_Algorithmus).

The `gfx_cmd_interpreter`'s main purpose is to dump frames as images.
This is achieved by dumping the bitmap identified by the `bmpidx` field to a file whenever the `gfx_cmd_interpreter` executes a `DISPLAY_BMP` command.
Also, if the `fs` flag field of the `DISPLAY_BMP` command is set, your interpreter shall assert its `gci_out.frame_sync` output for a single clock cycle.

Name the dumped frame images as `[N].ppm`, where `[N]` is a number increased with every frame that is dumped (beginning with 0, i.e., the first dumped frame shall be named `0.ppm`).
Your interpreter shall place the created image files in the directory specified by the `OUTPUT_DIR` generic.
The interpreter should be capable of dumping images of arbitrary dimensions.

**Important**
- Don't hard-code constants in your code!
- Try to make use of functions and procedures, as this will significantly simplify your code (especially try to evade redundant code). **Reuse** subprograms you have already written.
- As a primary goal of this task is writing clean and concise code. Spaghetti code, although functionally correct, will lead to points being deducted!

**Suggested Implemenation Order**
- Develop the interpreter and its testbench in parallel, i.e., whenever you implement a specific command, add testcode to your testbench to check if it works correctly.
- Start out by completing the `VRAM_*` commands. The effects of a write to VRAM can be checked by the read operation.
- Once this works, implement `DEFINE_BMP`, `ACTIVATE_BMP` and `DISPLAY_BMP` (the provided one is not complete!).
- Next, implement the simple drawing commands (like `SET_PIXEL`, `CLEAR` etc.) and the commands used to access the graphics pointer.
- Now, you can implement the advanced drawing commanded (`DRAW_HLINE`, `DRAW_VLINE`, `DRAW_CIRCLE`).
- Finally, take care of the bit blit commands.




## Testbench

Create a testbench to see if **all** the graphics commands are executed correctly (i.e., the testbench shall execute each command at least once).
Use the provided [template](tb/gfx_cmd_interpreter_tb.vhd).



## Delieverables

- **Implement**: [`gfx_cmd_interpreter.vhd`](src/gfx_cmd_interpreter.vhd)

- **Implement**: [`gfx_cmd_interpreter_tb.vhd`](tb/gfx_cmd_interpreter_tb.vhd)


[Return to main page](../../../README.md)
