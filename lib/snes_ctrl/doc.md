
# SNES Controller Package
This package provides everything required to interface with a [SNES (Super Nintendo Entertainment System)](https://en.wikipedia.org/wiki/Super_Nintendo_Entertainment_System) gamepad.


[[_TOC_]]

## Required Files

- [snes_ctrl.vhd](src/snes_ctrl.vhd)

- [snes_ctrl_arch_ref.vhd](src/snes_ctrl_arch_ref.vhd)

- [snes_ctrl_pkg.vhd](src/snes_ctrl_pkg.vhd)

## Components

### snes_ctrl
The self-contained `snes_ctrl` module can be directly connected to a SNES gamepad and will continuously poll the states of its buttons.


```vhdl
component snes_ctrl is
	generic (
		CLK_FREQ        : integer := 50_000_000;
		CLK_OUT_FREQ    : integer := 100_000;
		REFRESH_TIMEOUT : integer := 1000
	);
	port (
		clk        : in  std_ulogic;
		res_n      : in  std_ulogic;
		snes_clk   : out std_ulogic;
		snes_latch : out std_ulogic;
		snes_data  : in  std_ulogic;
		ctrl_state : out snes_ctrl_state_t
	);
end component;
```


#### Interface

The `clk` signal is the clock input, `res_n` is an asynchronous active-low, reset.
The `CLK_FREQ` generic must be set to match the frequency of `clk` (in Hz).


The `snes_clk`, `snes_latch`, and `snes_data` signals correspond to those of the SNES gamepad and can be directly connected to one of the gamepads in the lab.
The frequency of the `snes_clk` signal shall be `CLK_OUT_FREQ` (in Hz).


The `ctrl_state` output (of type `snes_ctrl_state_t`, see details below) provides the most recent state of the SNES gamepad, indicating whether each button was pressed (`'1'`) or not (`'0'`).
This output is updated every `REFRESH_TIMEOUT` cycles of `clk`, plus the time it takes the `snes_ctrl` to fetch the connected gamepad's current state.




#### Implementation

The implementation of the `snes_ctrl` can be found in [snes_ctrl_arch_ref.vhd](src/snes_ctrl_arch_ref.vhd).

This reference architecture implements the SNES protocol and polls the state of a connected controller approximately every 200 us.
**After** each polling cycle, the `ctrl_state` output is updated (i.e., the states of all buttons in the connected gamepad are always consistent).

Note that the reference implementation expects a **50 MHz clock to be applied at `clk`** and generates a `snes_clk` signal with a frequency of 100 kHz.
Each pulse on `snes_latch`hast the same pulse width as those on `snes_clk`.



## Types and Constants

```vhdl
type snes_ctrl_state_t is record
	btn_up     : std_ulogic;
	btn_down   : std_ulogic;
	btn_left   : std_ulogic;
	btn_right  : std_ulogic;
	btn_a      : std_ulogic;
	btn_b      : std_ulogic;
	btn_x      : std_ulogic;
	btn_y      : std_ulogic;
	btn_l      : std_ulogic;
	btn_r      : std_ulogic;
	btn_start  : std_ulogic;
	btn_select : std_ulogic;
end record;
```

Represents the state of a SNES gamepad using a single-bit element of each of the twelve buttons, indicating whether a button is pressed or not.



---


```vhdl
constant SNES_CTRL_STATE_RESET_VALUE : snes_ctrl_state_t := (others=>'0');
```

The reset value for registers of type `snes_ctrl_state_t` where all buttons are "not pressed" (i.e., reset to `'0'`).

## Subprograms

```vhdl
function to_sulv(s : snes_ctrl_state_t) return std_ulogic_vector;
```



```vhdl
function to_snes_ctrl_state(sulv : std_ulogic_vector(11 downto 0)) return snes_ctrl_state_t;
```

Conversion functions between a 12-bit `std_ulogic_value` and one of `snes_ctrl_t` and vice versa.
You can find the respective order of the individual button bits in the function bodies in [snes_ctrl_pkg.vhd](src/snes_ctrl_pkg.vhd).



[Return to main page](../../README.md)
