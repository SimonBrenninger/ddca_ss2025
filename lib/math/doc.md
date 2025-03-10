
# Mathematical Support Package
The mathematical support package, provides some convenient mathematical functions that would otherwise require multiple function calls and / or type casts.


[[_TOC_]]

## Required Files

- [math_pkg.vhd](src/math_pkg.vhd)

## Subprograms

```vhdl
function log2c(constant value : in integer) return integer;
```



```vhdl
function log10c(constant value : in integer) return integer;
```

Calculates the logarithms to base 2, respectively 10, of an integer operand and rounds the resulting value up to the next integer (ceiling function).



---


```vhdl
function max(constant value1, value2 : in integer) return integer;
```



```vhdl
function min(constant value1, value2 : in integer) return integer;
```

Determines the maximum / minimum of the two integer operands and returns it.
Required because after all these years Quartus still does not support the built-in maximum / minimum functions.



---


```vhdl
function max3(constant value1, value2, value3 : in integer) return integer;
```



```vhdl
function min3(constant value1, value2, value3 : in integer) return integer;
```

Determines the maximum / minimum of the three integer operands and returns it.



[Return to main page](../../README.md)
