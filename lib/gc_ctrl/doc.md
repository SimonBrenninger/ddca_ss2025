
# GameCube Controller Package
This package provides everything required to interface with a [GameCube gamepad](https://en.wikipedia.org/wiki/GameCube_controller).


[[_TOC_]]

## Required Files

- [`gc_ctrl.vhd`](src/gc_ctrl.vhd)

- [`gc_ctrl_arch_ref.vhd`](src/gc_ctrl_arch_ref.vhd)

- [`gc_ctrl_pkg.vhd`](src/gc_ctrl_pkg.vhd)

- [`test.xml`](src/test.xml)

## Components

### `gc_ctrl`
The self-contained `gc_ctrl` module can be directly connected to a GameCube gamepad and will continuously poll the states of its buttons.

```vhdl
component gc_ctrl is
	generic (
		CLK_FREQ        : positive := 50_000_000;
		SYNC_STAGES     : positive := 2;
		REFRESH_TIMEOUT : positive := 60000
	);
	port (
		clk        : in    std_ulogic;
		res_n      : in    std_ulogic;
		-- connection to the controller
		data       : inout std_logic;
		-- internal connection
		ctrl_state : out   gc_ctrl_state_t;
		rumble     : in    std_ulogic
	);
end component;
```


#### Interface

The `clk` signal is the clock input, `res_n` is an asynchronous active-low, reset.
The `CLK_FREQ` generic must be set to match the frequency of `clk` (in Hz).


The `data` signal corresponds to the bi-directional data line used to send / receive data to / from the GameCube gamepad.
This signal can be directly connected to one of the GameCube gamepads in the lab.


The `ctrl_state` output (of type `gc_ctrl_state_t`, see details below) provides the most recent state of the GameCube gamepad, indicating whether each button was pressed (`'1'`) or not (`'0'`) as well as the readings from the analog triggers and the joysticks.
This output is updated every `REFRESH_TIMEOUT` cycles of `clk`, plus the time it takes the `gc_ctrl` to fetch the connected gamepad's current state.


The 'rumble' input is used to enable/disable the rumble feature of the controller.
Setting it to `'1'` will result in the gamepads rumble motor being activated for one transmission cycle (transmission time + the refresh timeout).




#### Implementation

The obfuscated reference implementation of the `gc_ctrl` can be found in [`gc_ctrl_arch_ref.vhd`](src/gc_ctrl_arch_ref.vhd).

This reference architecture implements the GameCube gamepad protocol and polls the state of a connected controller every 1.56 ms.
This corresponds to a `REFRESH_TIMEOUT` of 60000.
Note that **after** each polling cycle, the `ctrl_state` output is updated (i.e., the states of all buttons in the connected gamepad are always consistent).

The reference implementation expects a **50 MHz clock to be applied at `clk`** and synchronizes `data` to the clock domain of `clk` using a two-stage synchronizer (`SYNC_STAGES=2`).



## Types and Constants
-   ```vhdl
    type gc_ctrl_state_t is record
    	-- buttons
    	btn_up    : std_ulogic;
    	btn_down  : std_ulogic;
    	btn_left  : std_ulogic;
    	btn_right : std_ulogic;
    	btn_a     : std_ulogic;
    	btn_b     : std_ulogic;
    	btn_x     : std_ulogic;
    	btn_y     : std_ulogic;
    	btn_z     : std_ulogic;
    	btn_start : std_ulogic;
    	btn_l     : std_ulogic;
    	btn_r     : std_ulogic;
    	-- joysticks
    	joy_x     : std_ulogic_vector(7 downto 0);
    	joy_y     : std_ulogic_vector(7 downto 0);
    	c_x       : std_ulogic_vector(7 downto 0);
    	c_y       : std_ulogic_vector(7 downto 0);
    	-- trigger
    	trigger_l : std_ulogic_vector(7 downto 0);
    	trigger_r : std_ulogic_vector(7 downto 0);
    end record;
    ```
    
    Represents the state of a GameCube Controller using a single-bit element for the button states and 8 bits for the states of the analog triggers and the joysticks.
    
    
---


-   ```vhdl
    constant GC_CTRL_STATE_RESET_VALUE : gc_ctrl_state_t := (
    	joy_x     => (others => '0'),
    	joy_y     => (others => '0'),
    	c_x       => (others => '0'),
    	c_y       => (others => '0'),
    	trigger_l => (others => '0'),
    	trigger_r => (others => '0'),
    	others => '0'
    );
    ```
    
    The reset value for registers of type `gc_ctrl_state_t` where all buttons are "not pressed" (i.e., reset to `'0'`) and the analog triggers and the joysticks are in neutral positions (all bits set to `'0'`).
    
---


-   ```vhdl
    constant GC_POLL_CMD_PREFIX : std_ulogic_vector(22 downto 0) := b"0100_0000_0000_0011_0000_000";
    ```
    
    The constant 23-bit prefix of the 24-bit polling command.
    




## Subprograms
-   ```vhdl
    function to_sulv (s : gc_ctrl_state_t) return std_ulogic_vector;
    function to_gc_ctrl_state(sulv : std_ulogic_vector(63 downto 0)) return gc_ctrl_state_t;
    ```
    
    Conversion functions between a 64-bit `std_ulogic_value` and one of `gc_ctrl_state_t` and vice versa.
    You can find the respective order of the individual button bits in the function bodies in [`gc_ctrl_pkg.vhd`](src/gc_ctrl_pkg.vhd).
    
    
---


-   ```vhdl
    function to_string(s : gc_ctrl_state_t) return string;
    ```
    
    Converts a `gc_ctrl_state_t` value into a human-readable string.
    





[Return to main page](../../README.md)
