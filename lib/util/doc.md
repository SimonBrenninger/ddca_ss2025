
# Utility Support Package
The utility support package provides some convenient functions and constants you may need for various tasks.


[[_TOC_]]

## Required Files

- [`util_pkg.vhd`](src/util_pkg.vhd)

## Types and Constants


### SSD Constants

Besides the 16 symbols required to display hexadecimal numbers, sevent-segment diplays also support a limited number of other symbols. For that purpose the package defines a few constants:




```vhdl
constant SSD_CHAR_OFF  : std_ulogic_vector(6 downto 0) := "1111111";
constant SSD_CHAR_DASH : std_ulogic_vector(6 downto 0) := "0111111";
constant SSD_CHAR_A    : std_ulogic_vector(6 downto 0) := "0001000";
constant SSD_CHAR_G    : std_ulogic_vector(6 downto 0) := "1000010";
constant SSD_CHAR_P    : std_ulogic_vector(6 downto 0) := "0001100";
constant SSD_CHAR_O    : std_ulogic_vector(6 downto 0) := "1000000";
constant SSD_CHAR_E    : std_ulogic_vector(6 downto 0) := "0000110";
constant SSD_CHAR_F    : std_ulogic_vector(6 downto 0) := "0001110";
constant SSD_CHAR_L    : std_ulogic_vector(6 downto 0) := "1000111";
constant SSD_CHAR_OPENING_BRACKET : std_ulogic_vector(6 downto 0) := "1000110"; -- (
constant SSD_CHAR_CLOSING_BRACKET : std_ulogic_vector(6 downto 0) := "1110000"; -- )
constant SSD_CHAR_CLOSING_BRACKET : std_ulogic_vector(6 downto 0) := "1110000"; -- )
constant SSD_CHAR_LC_R : std_ulogic_vector(6 downto 0) := "0101111"; -- lowercase r
constant SSD_CHAR_LC_I : std_ulogic_vector(6 downto 0) := "1101111"; -- lowercase i
constant SSD_CHAR_LC_I : std_ulogic_vector(6 downto 0) := "1101111"; -- lowercase i
```






## Subprograms
```vhdl
function to_segs(value : in std_ulogic_vector(3 downto 0)) return std_ulogic_vector;
```

Converts the hexadecimal (4-bit) input value into a bit-pattern that can be displayed on a seven-segment display.






[Return to main page](../../README.md)
