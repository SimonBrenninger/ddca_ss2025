
# Testbench Utility Package
The testbench utility package `tb_util_pkg` provides useful protected types and subprograms for implementing advanced testbenches.


[[_TOC_]]

## Required Files

- [tb_util_pkg.vhd](src/tb_util_pkg.vhd)

## Protected Types

```vhdl
type random_t is protected
	impure function gen_sul_01 return std_ulogic;
	impure function gen_sulv_01(len : positive) return std_ulogic_vector;
end protected;
```

The **non-synthesizable** protected type `random_t` allows to generate values /sequences of type `std_ulogic` / `std_ulogic_vector` over the domain of `0` and `1` (i.e., only these two of the nine possible values will be randomly generated).
This can be done using the `gen_sul_01`, respectively `gen_sulv_01` functions.
The parameter of the `gen_sulv_01` function allows to specify the length of the desired vector.

The random values are sampled from a **uniform** distribution.

Note that the internally used pseudo-random number generator is always initialized using the same seeds.
Hence, the values generated via the functions of `random_t` will also be the same in multiple simulations runs, thus allowing for reproducibility of results.

To use the protected type you can declare a `shared variable` of this type in, e.g., an architecture's declarative section and then use it throughout your design as shown below:

```vhdl
architecture arch of xyz is
  shared variable ran : random_t;
begin
  process is begin
    report to_string(ran.gen_sul_01);
    report to_string(ran.gen_sulv_01(8));
  end process;
end architecture;
```



---


```vhdl
type vram_t is protected
	procedure init(addr_width : natural);
	impure function get_byte(addr : natural) return std_ulogic_vector;
	impure function get_word(addr : natural) return std_ulogic_vector;
	procedure set_byte(addr : natural; value : std_ulogic_vector(7 downto 0));
	procedure set_word(addr : natural; value : std_ulogic_vector(15 downto 0));
	procedure dump_bitmap (base_address, width, height : natural; filename : string);
end protected;
```

The **non-synthesizable** protected type `vram_t` provides a video RAM (VRAM) for simulations and subprograms to access / manipulate it.
Furthermore, it contains a function to dump an image in VRAM to a PPM image file.

The `init` procedure must be called before using an instance of `vram_t` as it allocates the actual memory.
The `addr_width` parameter specifies the **byte** address width in bits of this memory.
I.e., setting to e.g. `8` will result in a memory consisting of `2^addr_width-1` bytes.
Initially all bytes of the memory are 0.

The `get_byte` / `get_word` functions return the byte / word at the respective address of the memory, where a word consists of two bytes (i.e., 16 bits).
Note that the `get_word` function expects a proper word access, therefore only accepting values that are multiple of 2.

The `set_byte` and `set_word` procedures allow to set the memory byte / word at the respective address.
Note that for the address values passed to `set_word` the same restrictions as for the ones passed to `get_word` apply.

Finally, the `dump_bitmap` procedure allows to dump (a section of) the memory as bitmap, where each byte is interpreted as [RGB332](https://en.wikipedia.org/wiki/List_of_monochrome_and_RGB_color_formats#3-3-2_bit_RGB_or_8-8-4_levels_RGB) color.
Given that the protected type is supposed to be used as *video* RAM, this is quite useful for debugging graphics applications.
The first three parameters to the `dump_bitmap` procedure allow to specify the desired memory region, starting at a certain `base_address` (even address) and having a certain `width` and `height` (in byte).
The `filename` parameter is the name of the target bitmap file.
Note that an already existing file of the same name will be overwritten!
Since VHDL does only support text-based file I/O, a text-based image format must be used.
In particular, the `dump_bitmap` procedure creates [PPM](https://en.wikipedia.org/wiki/Netpbm#PPM_example) files.
Since they are text-based the resulting images can be quite large.


[Return to main page](../../README.md)
