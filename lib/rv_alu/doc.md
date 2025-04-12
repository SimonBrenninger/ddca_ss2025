
# RISCV-V ALU Package
The `rv_alu` package, provides an arithmetic logic unit (ALU) that can be used in RISC-V cores that implement the ISA specified in [rv_core](../rv_core/doc.md).


[[_TOC_]]

## Required Files

- [`rv_alu.vhd`](src/rv_alu.vhd)

- [`rv_alu_pkg.vhd`](src/rv_alu_pkg.vhd)

## Components

### `rv_alu`
ALU implementing the operations required for an RISC-V core compatible with the [rv_core](../rv_core/doc.md) ISA.

```vhdl
component rv_alu is
	port (
		op     : in  rv_alu_op_t;
		a, b   : in  std_ulogic_vector(31 downto 0);
		result : out std_ulogic_vector(31 downto 0);
		z      : out std_ulogic
	);
end component;
```


#### Interface

The `op` input of the enumeration type `rv_alu_op_t` defines the operation the ALU performs on its two operands `a` and `b`.
The output `result` provides the result of the current operation and `z` is an outpout flag for certain operations, e.g., to indicate if the result of a subtraction is zero.




#### Implementation

The `rv_alu` performs the operations listed below for the different possible `op` values.
Note that `SLL`, `SRL`, `SRA` are abbreviations for shift left logical, shift right logical respectively shift right arithmetic.


|op       | R                       | Z          |
|---------|-------------------------|------------|
|ALU_NOP  | B                       | don't care |
|ALU_SLT  | A < B ? 1 : 0, signed   | not R(0)   |
|ALU_SLTU | A < B ? 1 : 0, unsigned | not R(0)   |
|ALU_SLL  | A sll B(4 downto 0)     | don't care |
|ALU_SRL  | A srl B(4 downto 0)     | don't care |
|ALU_SRA  | A sra B(4 downto 0)     | don't care |
|ALU_ADD  | A + B, signed           | don't care |
|ALU_SUB  | A - B, signed           | A = B      |
|ALU_AND  | A and B                 | don't care |
|ALU_OR   | A or B                  | don't care |
|ALU_XOR  | A xor B                 | don't care |



## Types and Constants
```vhdl
type rv_alu_op_t is (
	ALU_NOP,
	ALU_SLT,
	ALU_SLTU,
	ALU_SLL,
	ALU_SRL,
	ALU_SRA,
	ALU_ADD,
	ALU_SUB,
	ALU_AND,
	ALU_OR,
	ALU_XOR
);
```

Enumeration type defining the different ALU operations required for implementing the [rv_core](../rv_core/doc.md) ISA.





[Return to main page](../../README.md)
