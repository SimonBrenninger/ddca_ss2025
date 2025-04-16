
# Rasterizer

**Points:** 10 `|` **Keywords**: advanced testbench, specifications

[[_TOC_]]

In this task you will implement the command processing and decoding front-end of the `rasterizer`, which is a core part of the `vga_gfx_ctrl`.



## Description

Before you continue reading this task description read the [`vga_gfx_ctrl`](../../../lib/vga_gfx_ctrl/doc.md) package documentation.
This should give you a good overview of the purpose of the `rasterizer` and the tasks it performs in the `vga_gfx_ctrl`.

The `rasterizer` has the following interface:


```vhdl
entity rasterizer is
	generic (
		VRAM_ADDR_WIDTH : integer := 21;
		VRAM_DATA_WIDTH : integer := 16
	);
	port (
		clk   : in  std_ulogic;
		res_n : in  std_ulogic;

		-- write interface to VRAM
		vram_wr_addr        : out std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		vram_wr_data        : out std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
		vram_wr_full        : in  std_ulogic;
		vram_wr_emtpy       : in  std_ulogic;
		vram_wr             : out std_ulogic;
		vram_wr_access_mode : out sram_access_mode_t;

		-- read interface to VRAM
		vram_rd_addr        : out std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		vram_rd_data        : in  std_ulogic_vector(VRAM_DATA_WIDTH-1 downto 0);
		vram_rd_busy        : in  std_ulogic;
		vram_rd             : out std_ulogic;
		vram_rd_valid       : in  std_ulogic;
		vram_rd_access_mode : out sram_access_mode_t;

		-- frame reader signals
		fr_base_addr     : out std_ulogic_vector(VRAM_ADDR_WIDTH-1 downto 0);
		fr_base_addr_req : in  std_ulogic;

		-- gfx command FIFO read port
		gcf_rd    : out std_ulogic;
		gcf_data  : in  gfx_cmd_t;
		gcf_empty : in  std_ulogic;

		-- outputs signals
		rd_data    : out gfx_cmd_t;
		rd_valid   : out std_ulogic;
		frame_sync : out std_ulogic
	);
begin
	assert VRAM_DATA_WIDTH = 16 report "Rasterizer only supports VRAMs with 16 bit data width" severity failure;
end entity;
```


On first sight this might look a little overwhelming, but you will only have to deal with a subset of these port signals yourself (in particular the `gcf_*` signals).
The provided [template](src/rasterizer_arch.vhd) already implements most of the core's functionality.
However, it lacks the interface to the graphics command FIFO, which you will implement this task.

The template's state machine starts in the IDLE state, in which it shall wait for data in the graphics command FIFO to become available (i.e., for `gcf_empty` to go low).
It shall then fetch the next instruction, decode it and fetch the associated operands if required.
Then the command can be executed.
The FSM already provides states that implement the command execution for many of the commands.
These states are `DISPLAY_BMP`, `CLEAR`, `DRAW_HLINE`, `DRAW_VLINE`, `DRAW_CIRCLE`, `BB_START`, `VRAM_WRITE`, `VRAM_WRITE_INIT`, `VRAM_WRITE_SEQ`, `VRAM_READ` and `GET_PIXEL`.
You can simply enter these stats to start the execution.
Upon finishing the FSM returns backs to the `IDLE` state.

Notice that the when clauses in the [template](src/rasterizer_arch.vhd) for each of the mentioned states is preceded by a comment.
This comment contains a list of signal names, such as the one shown in the example below:

```vhdl
[...]
  -- requires: current_instr, dx
  when DRAW_HLINE =>
    state_nxt.tmp_vec.x <= state.gp.x;
    state_nxt.fsm_state <= DRAW_HLINE_LOOP;
[...]
```

The state expects these signals to be set to the correct values when the state is entered.
Moreover, it is expected that these signals are kept stable (i.e., they don't change their value) until the FSM returns to the `IDLE` state.
The `current_instr` signal, which is required by all states, must be set to the instruction of the command currently being executed.
Other signals, such as `dx` essentially correspond to the command's operands.

For the commands `NOP`, `MOVE_GP`, `INC_GP`, `SET_PIXEL`, `SET_COLOR`, `SET_BB_EFFECT`, `DEFINE_BMP` and `ACTIVATE_BMP` the FSM does not provide any implementation. You have to implement them yourself.

**Important**:
 - It is **not required nor advisable** to change any of the existing code! Just add what is missing!
 - You don't have to understand the complete template code, you just have to figure out how to interface with it.
 - Use the signals `pcol`, `scol`, `gp`, `abd` and `bb_effect` of the state record to implement internal data structures mentioned in the GCI Specification.
 - The bitmap descriptor table is not yet implemented. You can use the `dp_ram_1c1r1w` from the [`mem`](../../../lib/mem/doc.md) for that purpose.




## Testbench

You are already provided with a testbench [template](tb/rasterizer_tb.vhd).
This template instantiates the `rasterizer` with the reference architecture provided by the [`vga_gfx_ctrl`](../../../lib/vga_gfx_ctrl/doc.md) package.

The first thing you have to do is implement the procedure `gci_write` as well as the processes `vram_read` and `vram_write`.
The actual VRAM is implemented with the `vram_t` data structure of the [`tb_util`](../../../lib/tb_util/doc.md) package, which has also been used in the `gfx_cmd_interpreter` task.

 * `vram_write`: Use the `set_byte` and `set_word` functions to write to VRAM. The signals `vram_wr_full` and `vram_wr_emtpy` shall always stay zero.
 * `vram_read`: Use the `get_byte` and `get_word` functions to read from VRAM. The signal `vram_rd_busy` shall always stay zero. The read data shall be retured in the **next** clock cycle.

If you implemented these parts correctly the testbench should produce the image shown below:


![Image generated by the testbench template](.mdata/tb.png)

Once this is working you can change the instantiation code to use your architecture instead, and extend the test scenario.

As with the testbench for the `gfx_cmd_interpreter` task, execute **all** graphics commands at least once.
You should be able to resuse large parts of the `gfx_cmd_interpreter` testbench.
Your testbench shall produce a single output file called `out.ppm`.




## Hardware

This task does not come with its own quartus project or top-level architecture.
To test your `rasterizer` use the quartus project of the `tetris` task.
Remove the file `rasterizer_arch_ref.vhd` from the project and add your own implementation (rasterizer_arch.vhd).

Download and test your game on the hardware.



## Delieverables

- **Implement**: [`rasterizer_arch.vhd`](src/rasterizer_arch.vhd)

- **Implement**: [`rasterizer_tb.vhd`](tb/rasterizer_tb.vhd)


[Return to main page](../../../README.md)
