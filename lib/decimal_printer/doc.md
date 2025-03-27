
# Decimal Printer Package
The `decimal_printer_pkg` provides a single core that can be used to print the decimal representation of unsigned numbers to a Graphics Command Interface (GCI).


[[_TOC_]]

## Required Files

- [decimal_printer.vhd](src/decimal_printer.vhd)

- [decimal_printer_pkg.vhd](src/decimal_printer_pkg.vhd)

## Components

### decimal_printer
The `decimal_printer` prints the 5-digit decimal representation of an unsigned 16-bit number using a GCI.


```vhdl
component decimal_printer is
	port (
		clk : in std_ulogic;
		res_n : in std_ulogic;
		gci_in : out gci_in_t;
		gci_out : in gci_out_t;
		start : in std_ulogic;
		busy : out std_ulogic;
		number : in std_ulogic_vector(15 downto 0);
		bmpidx : in bmpidx_t;
		charwidth : in charwidth_t
	);
end component;
```


#### Interface

The figure below shows an example timing diagram for the `decimal_printer`.
After the `start` signal is asserted, the core starts with the conversion process.
When it is done converting the provided `number` to its decimal representation, it outputs exactly 5 `BB_CHAR` commands at its `gci_out` port.
As soon as the `busy` signal goes low a new drawing operation can be started.
**Important**: During the whole conversion process (i.e., while busy is asserted) the inputs `bmpidx`, `charwidth` and `number` must not change.


![`decimal_printer` example timing diagram](.mdata/decimal_printer_timing.svg)

The `decimal_printer` always prints leading zeros (e.g. the number 1 will be presented as 00001).
The core requires a bitmap index (`bmpidx`) which refers to a bitmap containing the numbers 0-9 (in that order) as `charwidth` pixel wide characters.
The figure below shows how such a bitmap can look like.


![Example font bitmap with 8 pixel wide characters](.mdata/example_bitmap.svg)

It is fine if the bitmap contains further characters, but the first 10 must be the numbers 0-9 (as shown in the figure).


Note that the decimal representation is printed at the **current** location of the Graphics Pointer.
Afterwards the x coordinate of the Graphics Pointer is incremented by `charwidth*5` (since it prints 5 chars, each `charwidth` pixels wide).




[Return to main page](../../README.md)
