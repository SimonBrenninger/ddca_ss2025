
# On-Chip Memory Package
This package provides commonly used on-chip memories in the from of random access memories (RAMs) and first-in first-out buffers (FIFOs).


[[_TOC_]]

## Required Files

- [mem_pkg.vhd](src/mem_pkg.vhd)

- [dp_ram_1c1r1w.vhd](src/dp_ram_1c1r1w.vhd)

- [dp_ram_1c1r1w_rdw.vhd](src/dp_ram_1c1r1w_rdw.vhd)

- [dp_ram_2c2rw.vhd](src/dp_ram_2c2rw.vhd)

- [dp_ram_2c2rw_byteen.vhd](src/dp_ram_2c2rw_byteen.vhd)

- [fifo_1c1r1w.vhd](src/fifo_1c1r1w.vhd)

- [fifo_1c1r1w_fwft.vhd](src/fifo_1c1r1w_fwft.vhd)


## Overview

Important components in nearly every integrated circuit are memories.
If storage with full access speed is required, only on-chip memories are viable options.


This package provides various on-chip memory modules, with different access strategies:

- `dp_ram_1c1r1w`: a single-clock simple dual-port RAM with one read and one write port
- `dp_ram_2c2rw`: a dual-clock true dual-port RAM with two read/write ports
- `dp_ram_2c2rw_byteen`: a dual-clock true dual-port RAM with byte-enable control singals
- `fifo_1c1r1w`: a classic FIFO with one read and one write port
- `fifo_1c1r1w_fwft`: a classic FIFO with one read and one write port and first word fall through (FWFT) behavior




[Return to main page](../../README.md)
