library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sram_ctrl_pkg.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity dp_ram_1c1r1w_3_38 is
  port (
    clk : in std_logic;
    rd1_addr : in std_logic_vector (2 downto 0);
    rd1 : in std_logic;
    wr2_addr : in std_logic_vector (2 downto 0);
    wr2_data : in std_logic_vector (37 downto 0);
    wr2 : in std_logic;
    rd1_data : out std_logic_vector (37 downto 0));
end entity dp_ram_1c1r1w_3_38;
architecture ref of dp_ram_1c1r1w_3_38 is
  signal n692 : std_logic_vector (37 downto 0);
  signal n693 : std_logic_vector (37 downto 0) := "00000000000000000000000000000000000000";
  signal n695 : std_logic_vector (37 downto 0);
begin
  rd1_data <= n693;
  n692 <= n693 when rd1 = '0' else n695;
  process (clk)
  begin
    if rising_edge (clk) then
      n693 <= n692;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (37 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n695 <= ram(to_integer (unsigned (rd1_addr)));
    if rising_edge (clk) and (wr2 = '1') then
      ram (to_integer (unsigned (wr2_addr))) := wr2_data;
    end if;
  end process;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fifo_1c1r1w_8_38 is
  port (
    clk : in std_logic;
    res_n : in std_logic;
    rd : in std_logic;
    wr_data : in std_logic_vector (37 downto 0);
    wr : in std_logic;
    rd_data : out std_logic_vector (37 downto 0);
    empty : out std_logic;
    full : out std_logic;
    half_full : out std_logic);
end entity fifo_1c1r1w_8_38;
architecture ref of fifo_1c1r1w_8_38 is
  signal read_address : std_logic_vector (2 downto 0);
  signal read_address_next : std_logic_vector (2 downto 0);
  signal write_address : std_logic_vector (2 downto 0);
  signal write_address_next : std_logic_vector (2 downto 0);
  signal full_next : std_logic;
  signal empty_next : std_logic;
  signal wr_int : std_logic;
  signal rd_int : std_logic;
  signal half_full_next : std_logic;
  signal pointer_diff : std_logic_vector (31 downto 0);
  signal pointer_diff_next : std_logic_vector (31 downto 0);
  signal memory_inst_n579 : std_logic_vector (37 downto 0);
  signal memory_inst_c_rd1_data : std_logic_vector (37 downto 0);
  signal n583 : std_logic;
  signal n606 : std_logic;
  signal n607 : std_logic;
  signal n609 : std_logic_vector (2 downto 0);
  signal n610 : std_logic_vector (2 downto 0);
  signal n613 : std_logic;
  signal n615 : std_logic;
  signal n616 : std_logic;
  signal n618 : std_logic_vector (2 downto 0);
  signal n619 : std_logic_vector (2 downto 0);
  signal n622 : std_logic;
  signal n624 : std_logic;
  signal n625 : std_logic;
  signal n627 : std_logic_vector (31 downto 0);
  signal n628 : std_logic;
  signal n629 : std_logic;
  signal n631 : std_logic_vector (31 downto 0);
  signal n632 : std_logic_vector (31 downto 0);
  signal n633 : std_logic_vector (31 downto 0);
  signal n635 : std_logic;
  signal n638 : std_logic;
  signal n641 : std_logic_vector (2 downto 0);
  signal n642 : std_logic;
  signal n644 : std_logic;
  signal n646 : std_logic;
  signal n647 : std_logic;
  signal n649 : std_logic_vector (2 downto 0);
  signal n650 : std_logic;
  signal n651 : std_logic;
  signal n652 : std_logic;
  signal n654 : std_logic;
  signal n655 : std_logic;
  signal n657 : std_logic;
  signal n664 : std_logic_vector (2 downto 0);
  signal n665 : std_logic_vector (2 downto 0);
  signal n666 : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n667 : std_logic;
  signal n668 : std_logic;
  signal n669 : std_logic;
begin
  rd_data <= memory_inst_n579;
  empty <= n667;
  full <= n668;
  half_full <= n669;
  read_address <= n664; -- (signal)
  read_address_next <= n619; -- (signal)
  write_address <= n665; -- (signal)
  write_address_next <= n610; -- (signal)
  full_next <= n654; -- (signal)
  empty_next <= n657; -- (signal)
  wr_int <= n613; -- (signal)
  rd_int <= n622; -- (signal)
  half_full_next <= n638; -- (signal)
  pointer_diff <= n666; -- (isignal)
  pointer_diff_next <= n633; -- (isignal)
  memory_inst_n579 <= memory_inst_c_rd1_data; -- (signal)
  memory_inst : entity work.dp_ram_1c1r1w_3_38 port map (
    clk => clk,
    rd1_addr => read_address,
    rd1 => rd_int,
    wr2_addr => write_address,
    wr2_data => wr_data,
    wr2 => wr_int,
    rd1_data => memory_inst_c_rd1_data);
  n583 <= not res_n;
  n606 <= not n668;
  n607 <= n606 and wr;
  n609 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n610 <= write_address when n607 = '0' else n609;
  n613 <= '0' when n607 = '0' else '1';
  n615 <= not n667;
  n616 <= n615 and rd;
  n618 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n619 <= read_address when n616 = '0' else n618;
  n622 <= '0' when n616 = '0' else '1';
  n624 <= not rd;
  n625 <= n624 and wr;
  n627 <= std_logic_vector (unsigned (pointer_diff) + unsigned'("00000000000000000000000000000001"));
  n628 <= not wr;
  n629 <= n628 and rd;
  n631 <= std_logic_vector (unsigned (pointer_diff) - unsigned'("00000000000000000000000000000001"));
  n632 <= pointer_diff when n629 = '0' else n631;
  n633 <= n632 when n625 = '0' else n627;
  n635 <= '1' when signed (n633) >= signed'("00000000000000000000000000000100") else '0';
  n638 <= '0' when n635 = '0' else '1';
  n641 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n642 <= '1' when write_address = n641 else '0';
  n644 <= n667 when n647 = '0' else '1';
  n646 <= n668 when rd = '0' else '0';
  n647 <= n642 and rd;
  n649 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n650 <= '1' when read_address = n649 else '0';
  n651 <= not rd;
  n652 <= n651 and n650;
  n654 <= n646 when n655 = '0' else '1';
  n655 <= n652 and wr;
  n657 <= n644 when wr = '0' else '0';
  process (clk, n583)
  begin
    if n583 = '1' then
      n664 <= "000";
    elsif rising_edge (clk) then
      n664 <= read_address_next;
    end if;
  end process;
  process (clk, n583)
  begin
    if n583 = '1' then
      n665 <= "000";
    elsif rising_edge (clk) then
      n665 <= write_address_next;
    end if;
  end process;
  process (clk, n583)
  begin
    if n583 = '1' then
      n666 <= "00000000000000000000000000000000";
    elsif rising_edge (clk) then
      n666 <= pointer_diff_next;
    end if;
  end process;
  process (clk, n583)
  begin
    if n583 = '1' then
      n667 <= '1';
    elsif rising_edge (clk) then
      n667 <= empty_next;
    end if;
  end process;
  process (clk, n583)
  begin
    if n583 = '1' then
      n668 <= '0';
    elsif rising_edge (clk) then
      n668 <= full_next;
    end if;
  end process;
  process (clk, n583)
  begin
    if n583 = '1' then
      n669 <= '0';
    elsif rising_edge (clk) then
      n669 <= half_full_next;
    end if;
  end process;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fifo_1c1r1w_fwft_8_38 is
  port (
    clk : in std_logic;
    res_n : in std_logic;
    rd_ack : in std_logic;
    wr_data : in std_logic_vector (37 downto 0);
    wr : in std_logic;
    rd_data : out std_logic_vector (37 downto 0);
    rd_valid : out std_logic;
    full : out std_logic;
    half_full : out std_logic);
end entity fifo_1c1r1w_fwft_8_38;
architecture ref of fifo_1c1r1w_fwft_8_38 is
  signal rd : std_logic;
  signal empty : std_logic;
  signal not_empty : std_logic;
  signal fifo_inst_n544 : std_logic_vector (37 downto 0);
  signal fifo_inst_n545 : std_logic;
  signal fifo_inst_n546 : std_logic;
  signal fifo_inst_n547 : std_logic;
  signal fifo_inst_c_rd_data : std_logic_vector (37 downto 0);
  signal fifo_inst_c_empty : std_logic;
  signal fifo_inst_c_full : std_logic;
  signal fifo_inst_c_half_full : std_logic;
  signal n556 : std_logic;
  signal n557 : std_logic;
  signal n558 : std_logic;
  signal n559 : std_logic;
  signal n560 : std_logic;
  signal n562 : std_logic;
  signal n564 : std_logic;
  signal n570 : std_logic;
  signal n571 : std_logic;
begin
  rd_data <= fifo_inst_n544;
  rd_valid <= n571;
  full <= fifo_inst_n546;
  half_full <= fifo_inst_n547;
  rd <= n560; -- (signal)
  empty <= fifo_inst_n545; -- (signal)
  not_empty <= n556; -- (signal)
  fifo_inst_n544 <= fifo_inst_c_rd_data; -- (signal)
  fifo_inst_n545 <= fifo_inst_c_empty; -- (signal)
  fifo_inst_n546 <= fifo_inst_c_full; -- (signal)
  fifo_inst_n547 <= fifo_inst_c_half_full; -- (signal)
  fifo_inst : entity work.fifo_1c1r1w_8_38 port map (
    clk => clk,
    res_n => res_n,
    rd => rd,
    wr_data => wr_data,
    wr => wr,
    rd_data => fifo_inst_c_rd_data,
    empty => fifo_inst_c_empty,
    full => fifo_inst_c_full,
    half_full => fifo_inst_c_half_full);
  n556 <= not empty;
  n557 <= rd_ack and not_empty;
  n558 <= not n571;
  n559 <= not_empty and n558;
  n560 <= n557 or n559;
  n562 <= not res_n;
  n564 <= rd or rd_ack;
  n570 <= n571 when n564 = '0' else not_empty;
  process (clk, n562)
  begin
    if n562 = '1' then
      n571 <= '0';
    elsif rising_edge (clk) then
      n571 <= n570;
    end if;
  end process;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
architecture ref of sram_ctrl is
  signal wrap_clk: std_logic;
  signal wrap_res_n: std_logic;
  subtype typwrap_wr_addr is std_logic_vector (20 downto 0);
  signal wrap_wr_addr: typwrap_wr_addr;
  subtype typwrap_wr_data is std_logic_vector (15 downto 0);
  signal wrap_wr_data: typwrap_wr_data;
  signal wrap_wr: std_logic;
  signal wrap_wr_access_mode: std_logic;
  subtype typwrap_rd1_addr is std_logic_vector (20 downto 0);
  signal wrap_rd1_addr: typwrap_rd1_addr;
  signal wrap_rd1: std_logic;
  signal wrap_rd1_access_mode: std_logic;
  subtype typwrap_rd2_addr is std_logic_vector (20 downto 0);
  signal wrap_rd2_addr: typwrap_rd2_addr;
  signal wrap_rd2: std_logic;
  signal wrap_rd2_access_mode: std_logic;
  signal wrap_wr_empty: std_logic;
  signal wrap_wr_full: std_logic;
  signal wrap_wr_half_full: std_logic;
  signal wrap_rd1_busy: std_logic;
  subtype typwrap_rd1_data is std_logic_vector (15 downto 0);
  signal wrap_rd1_data: typwrap_rd1_data;
  signal wrap_rd1_valid: std_logic;
  signal wrap_rd2_busy: std_logic;
  subtype typwrap_rd2_data is std_logic_vector (15 downto 0);
  signal wrap_rd2_data: typwrap_rd2_data;
  signal wrap_rd2_valid: std_logic;
  subtype typwrap_sram_addr is std_logic_vector (19 downto 0);
  signal wrap_sram_addr: typwrap_sram_addr;
  signal wrap_sram_ub_n: std_logic;
  signal wrap_sram_lb_n: std_logic;
  signal wrap_sram_we_n: std_logic;
  signal wrap_sram_ce_n: std_logic;
  signal wrap_sram_oe_n: std_logic;
  signal n9_c_o : std_logic_vector (15 downto 0);
  signal n9_c_oport : std_logic_vector (15 downto 0);
  signal wr_fifo_rd_valid : std_logic;
  signal wr_fifo_rd_ack : std_logic;
  signal wr_fifo_data : std_logic_vector (15 downto 0);
  signal wr_fifo_addr : std_logic_vector (20 downto 0);
  signal wr_fifo_access_mode : std_logic;
  signal rd1_output_mode : std_logic_vector (1 downto 0);
  signal rd2_output_mode : std_logic_vector (1 downto 0);
  signal s : std_logic_vector (66 downto 0);
  signal s_nxt : std_logic_vector (66 downto 0);
  signal n16 : std_logic_vector (15 downto 0);
  signal n17 : std_logic;
  signal n20 : std_logic_vector (19 downto 0);
  signal n21 : std_logic;
  signal n22 : std_logic;
  signal n23 : std_logic;
  signal n24 : std_logic;
  signal n25 : std_logic;
  signal n27 : std_logic;
  signal n34 : std_logic_vector (1 downto 0);
  constant n35 : std_logic_vector (66 downto 0) := "0000000000000000000000000000000000000000000000000000000000001111100";
  signal n37 : std_logic;
  signal n40 : std_logic_vector (20 downto 0);
  signal n42 : std_logic;
  signal n43 : std_logic;
  signal n44 : std_logic_vector (1 downto 0);
  signal n46 : std_logic_vector (19 downto 0);
  signal n54 : std_logic_vector (22 downto 0);
  signal n55 : std_logic_vector (22 downto 0);
  signal n56 : std_logic_vector (22 downto 0);
  signal n58 : std_logic_vector (19 downto 0);
  signal n65 : std_logic;
  signal n68 : std_logic_vector (19 downto 0);
  signal n76 : std_logic_vector (19 downto 0);
  signal n80 : std_logic_vector (22 downto 0);
  signal n81 : std_logic_vector (1 downto 0);
  signal n82 : std_logic_vector (22 downto 0);
  signal n83 : std_logic_vector (22 downto 0);
  signal n84 : std_logic_vector (1 downto 0);
  signal n85 : std_logic_vector (1 downto 0);
  signal n86 : std_logic_vector (1 downto 0);
  signal n87 : std_logic_vector (1 downto 0);
  signal n88 : std_logic_vector (1 downto 0);
  signal n89 : std_logic_vector (1 downto 0);
  signal n90 : std_logic_vector (1 downto 0);
  signal n91 : std_logic;
  signal n92 : std_logic;
  signal n93 : std_logic;
  signal n94 : std_logic_vector (19 downto 0);
  signal n95 : std_logic_vector (19 downto 0);
  signal n96 : std_logic;
  signal n97 : std_logic_vector (3 downto 0);
  signal n98 : std_logic_vector (22 downto 0);
  signal n99 : std_logic_vector (1 downto 0);
  signal n100 : std_logic_vector (1 downto 0);
  signal n101 : std_logic_vector (1 downto 0);
  signal n102 : std_logic_vector (1 downto 0);
  signal n103 : std_logic_vector (1 downto 0);
  signal n104 : std_logic_vector (1 downto 0);
  signal n105 : std_logic_vector (1 downto 0);
  signal n106 : std_logic_vector (1 downto 0);
  signal n107 : std_logic;
  signal n108 : std_logic;
  signal n109 : std_logic;
  signal n110 : std_logic_vector (19 downto 0);
  signal n111 : std_logic_vector (19 downto 0);
  signal n112 : std_logic;
  signal n113 : std_logic_vector (3 downto 0);
  signal n114 : std_logic_vector (22 downto 0);
  signal n115 : std_logic_vector (1 downto 0);
  signal n116 : std_logic_vector (1 downto 0);
  signal n117 : std_logic_vector (1 downto 0);
  signal n118 : std_logic_vector (1 downto 0);
  signal n119 : std_logic_vector (1 downto 0);
  signal n120 : std_logic_vector (1 downto 0);
  signal n121 : std_logic_vector (1 downto 0);
  signal n122 : std_logic_vector (1 downto 0);
  signal n123 : std_logic;
  signal n124 : std_logic;
  signal n125 : std_logic;
  signal n126 : std_logic_vector (19 downto 0);
  signal n127 : std_logic_vector (19 downto 0);
  signal n128 : std_logic;
  signal n129 : std_logic;
  signal n130 : std_logic_vector (21 downto 0);
  signal n131 : std_logic_vector (21 downto 0);
  signal n132 : std_logic_vector (21 downto 0);
  signal n134 : std_logic;
  signal n136 : std_logic_vector (19 downto 0);
  signal n142 : std_logic;
  signal n146 : std_logic;
  signal n147 : std_logic;
  signal n148 : std_logic;
  signal n149 : std_logic;
  signal n153 : std_logic;
  signal n154 : std_logic;
  signal n155 : std_logic;
  signal n158 : std_logic_vector (1 downto 0);
  signal n159 : std_logic_vector (1 downto 0);
  signal n160 : std_logic_vector (1 downto 0);
  signal n161 : std_logic_vector (1 downto 0);
  signal n162 : std_logic_vector (1 downto 0);
  signal n163 : std_logic_vector (1 downto 0);
  signal n164 : std_logic_vector (1 downto 0);
  signal n166 : std_logic;
  signal n168 : std_logic_vector (19 downto 0);
  signal n173 : std_logic;
  signal n174 : std_logic_vector (2 downto 0);
  signal n178 : std_logic;
  signal n182 : std_logic;
  signal n185 : std_logic;
  signal n187 : std_logic_vector (1 downto 0);
  signal n188 : std_logic_vector (1 downto 0);
  signal n189 : std_logic_vector (1 downto 0);
  signal n190 : std_logic;
  signal n191 : std_logic;
  signal n192 : std_logic;
  signal n193 : std_logic;
  signal n194 : std_logic;
  signal n195 : std_logic;
  signal n196 : std_logic;
  signal n197 : std_logic;
  signal n198 : std_logic;
  signal n199 : std_logic;
  signal n200 : std_logic_vector (19 downto 0);
  signal n201 : std_logic_vector (19 downto 0);
  signal n202 : std_logic;
  signal n203 : std_logic_vector (21 downto 0);
  signal n204 : std_logic_vector (21 downto 0);
  signal n212 : std_logic;
  signal n214 : std_logic;
  signal n215 : std_logic;
  signal n216 : std_logic;
  signal n217 : std_logic;
  signal n218 : std_logic_vector (7 downto 0);
  signal n220 : std_logic;
  signal n221 : std_logic;
  signal n222 : std_logic;
  signal n223 : std_logic_vector (7 downto 0);
  signal n224 : std_logic_vector (7 downto 0);
  signal n225 : std_logic_vector (7 downto 0);
  signal n226 : std_logic_vector (7 downto 0);
  signal n227 : std_logic_vector (7 downto 0);
  signal n228 : std_logic_vector (7 downto 0);
  signal n229 : std_logic_vector (7 downto 0);
  signal n230 : std_logic_vector (15 downto 0);
  signal n231 : std_logic_vector (15 downto 0);
  signal n234 : std_logic;
  signal n236 : std_logic;
  signal n237 : std_logic;
  signal n244 : std_logic;
  signal n247 : std_logic;
  signal n248 : std_logic;
  signal n249 : std_logic;
  signal n250 : std_logic;
  signal n253 : std_logic;
  signal n254 : std_logic;
  signal n255 : std_logic;
  signal n259 : std_logic;
  signal n263 : std_logic_vector (1 downto 0);
  signal n265 : std_logic;
  signal n268 : std_logic_vector (1 downto 0);
  signal n270 : std_logic;
  signal n275 : std_logic_vector (1 downto 0);
  signal n281 : std_logic_vector (1 downto 0);
  signal n283 : std_logic_vector (1 downto 0);
  signal n289 : std_logic;
  signal n291 : std_logic;
  signal n292 : std_logic_vector (7 downto 0);
  signal n294 : std_logic;
  signal n295 : std_logic_vector (7 downto 0);
  signal n297 : std_logic;
  signal n298 : std_logic_vector (3 downto 0);
  signal n299 : std_logic_vector (7 downto 0);
  signal n302 : std_logic_vector (7 downto 0);
  signal n303 : std_logic_vector (7 downto 0);
  signal n306 : std_logic_vector (7 downto 0);
  signal n312 : std_logic;
  signal n314 : std_logic_vector (15 downto 0);
  signal n326 : std_logic;
  signal n328 : std_logic;
  signal n329 : std_logic;
  signal n330 : std_logic;
  signal n331 : std_logic;
  signal n338 : std_logic;
  signal n341 : std_logic;
  signal n342 : std_logic;
  signal n343 : std_logic;
  signal n344 : std_logic;
  signal n347 : std_logic;
  signal n348 : std_logic;
  signal n349 : std_logic;
  signal n353 : std_logic;
  signal n357 : std_logic_vector (1 downto 0);
  signal n359 : std_logic;
  signal n362 : std_logic_vector (1 downto 0);
  signal n364 : std_logic;
  signal n369 : std_logic_vector (1 downto 0);
  signal n375 : std_logic_vector (1 downto 0);
  signal n377 : std_logic_vector (1 downto 0);
  signal n379 : std_logic;
  signal n380 : std_logic;
  signal n381 : std_logic;
  signal n383 : std_logic;
  signal n390 : std_logic;
  signal n393 : std_logic;
  signal n394 : std_logic;
  signal n395 : std_logic;
  signal n396 : std_logic;
  signal n399 : std_logic;
  signal n400 : std_logic;
  signal n401 : std_logic;
  signal n405 : std_logic;
  signal n409 : std_logic_vector (1 downto 0);
  signal n411 : std_logic;
  signal n414 : std_logic_vector (1 downto 0);
  signal n416 : std_logic;
  signal n421 : std_logic_vector (1 downto 0);
  signal n427 : std_logic_vector (1 downto 0);
  signal n428 : std_logic_vector (1 downto 0);
  signal n433 : std_logic;
  signal n435 : std_logic;
  signal n436 : std_logic_vector (7 downto 0);
  signal n438 : std_logic;
  signal n439 : std_logic_vector (7 downto 0);
  signal n441 : std_logic;
  signal n442 : std_logic_vector (3 downto 0);
  signal n443 : std_logic_vector (7 downto 0);
  signal n446 : std_logic_vector (7 downto 0);
  signal n447 : std_logic_vector (7 downto 0);
  signal n450 : std_logic_vector (7 downto 0);
  signal n456 : std_logic;
  signal n458 : std_logic_vector (15 downto 0);
  signal wr_fifo_block_fifo_data_out : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_access_mode_sul : std_logic;
  signal wr_fifo_block_wr_fifo_n469 : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_fifo_n470 : std_logic;
  signal n471 : std_logic_vector (16 downto 0);
  signal n472 : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_fifo_n473 : std_logic;
  signal wr_fifo_block_wr_fifo_n474 : std_logic;
  signal wr_fifo_block_wr_fifo_c_rd_data : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_fifo_c_rd_valid : std_logic;
  signal wr_fifo_block_wr_fifo_c_full : std_logic;
  signal wr_fifo_block_wr_fifo_c_half_full : std_logic;
  signal n489 : std_logic;
  signal n493 : std_logic;
  signal n499 : std_logic;
  signal n505 : std_logic;
  signal n506 : std_logic;
  signal n507 : std_logic_vector (20 downto 0);
  signal n508 : std_logic_vector (15 downto 0);
  signal n510 : std_logic;
  signal n518 : std_logic;
  signal n524 : std_logic;
  signal n530 : std_logic;
  signal n531 : std_logic_vector (1 downto 0);
  signal n532 : std_logic_vector (1 downto 0);
  signal n533 : std_logic_vector (66 downto 0);
  signal n534 : std_logic_vector (66 downto 0);
  signal n535 : std_logic_vector (15 downto 0);
  signal n536 : std_logic;
  signal n537 : std_logic_vector (15 downto 0);
  signal n538 : std_logic;
  signal n539 : std_logic_vector (15 downto 0);
begin
  wrap_clk <= clk;
  wrap_res_n <= res_n;
  wrap_wr_addr <= typwrap_wr_addr(wr_addr);
  wrap_wr_data <= typwrap_wr_data(wr_data);
  wrap_wr <= wr;
  wrap_wr_access_mode <= '0' when sram_access_mode_t'pos (wr_access_mode) = 0 else '1';
  wrap_rd1_addr <= typwrap_rd1_addr(rd1_addr);
  wrap_rd1 <= rd1;
  wrap_rd1_access_mode <= '0' when sram_access_mode_t'pos (rd1_access_mode) = 0 else '1';
  wrap_rd2_addr <= typwrap_rd2_addr(rd2_addr);
  wrap_rd2 <= rd2;
  wrap_rd2_access_mode <= '0' when sram_access_mode_t'pos (rd2_access_mode) = 0 else '1';
  wr_empty <= wrap_wr_empty;
  wr_full <= wrap_wr_full;
  wr_half_full <= wrap_wr_half_full;
  rd1_busy <= wrap_rd1_busy;
  rd1_data <= std_ulogic_vector(wrap_rd1_data);
  rd1_valid <= wrap_rd1_valid;
  rd2_busy <= wrap_rd2_busy;
  rd2_data <= std_ulogic_vector(wrap_rd2_data);
  rd2_valid <= wrap_rd2_valid;
  sram_addr <= std_ulogic_vector(wrap_sram_addr);
  sram_ub_n <= wrap_sram_ub_n;
  sram_lb_n <= wrap_sram_lb_n;
  sram_we_n <= wrap_sram_we_n;
  sram_ce_n <= wrap_sram_ce_n;
  sram_oe_n <= wrap_sram_oe_n;
  wrap_wr_empty <= n506;
  wrap_wr_full <= wr_fifo_block_wr_fifo_n473;
  wrap_wr_half_full <= wr_fifo_block_wr_fifo_n474;
  wrap_rd1_busy <= n178;
  wrap_rd1_data <= n535;
  wrap_rd1_valid <= n536;
  wrap_rd2_busy <= n182;
  wrap_rd2_data <= n537;
  wrap_rd2_valid <= n538;
  sram_dq <= n9_c_oport;
  wrap_sram_addr <= n20;
  wrap_sram_ub_n <= n21;
  wrap_sram_lb_n <= n22;
  wrap_sram_we_n <= n23;
  wrap_sram_ce_n <= n24;
  wrap_sram_oe_n <= n25;
  n9_c_oport <= n539; -- (inout - port)
  n9_c_o <= sram_dq; -- (inout - read)
  wr_fifo_rd_valid <= wr_fifo_block_wr_fifo_n470; -- (signal)
  wr_fifo_rd_ack <= n185; -- (signal)
  wr_fifo_data <= n508; -- (signal)
  wr_fifo_addr <= n507; -- (signal)
  wr_fifo_access_mode <= n530; -- (signal)
  rd1_output_mode <= n531; -- (signal)
  rd2_output_mode <= n532; -- (signal)
  s <= n533; -- (signal)
  s_nxt <= n534; -- (signal)
  n16 <= s (43 downto 28);
  n17 <= s (7);
  n20 <= s (27 downto 8);
  n21 <= s (2);
  n22 <= s (3);
  n23 <= s (4);
  n24 <= s (5);
  n25 <= s (6);
  n27 <= not wrap_res_n;
  n34 <= s (1 downto 0);
  n37 <= s (44);
  n40 <= s (65 downto 45);
  n42 <= s (66);
  n43 <= s (44);
  n44 <= s (1 downto 0);
  n46 <= wrap_rd1_addr (20 downto 1);
  n54 <= wrap_rd2_access_mode & wrap_rd2_addr & '1';
  n55 <= n42 & n40 & n37;
  n56 <= n55 when wrap_rd2 = '0' else n54;
  n58 <= wrap_rd2_addr (20 downto 1);
  n65 <= s (44);
  n68 <= s (65 downto 46);
  n76 <= wr_fifo_addr (20 downto 1);
  n80 <= n76 & '1' & '0' & '0';
  n81 <= n34 when wr_fifo_rd_valid = '0' else "01";
  n82 <= n35 (27 downto 5);
  n83 <= n82 when wr_fifo_rd_valid = '0' else n80;
  n84 <= '0' & '0';
  n85 <= '0' & '0';
  n86 <= n81 when n65 = '0' else n34;
  n87 <= n35 (3 downto 2);
  n88 <= n87 when n65 = '0' else n84;
  n89 <= n83 (1 downto 0);
  n90 <= n89 when n65 = '0' else n85;
  n91 <= n83 (2);
  n92 <= n35 (7);
  n93 <= n91 when n65 = '0' else n92;
  n94 <= n83 (22 downto 3);
  n95 <= n94 when n65 = '0' else n68;
  n96 <= n37 when n65 = '0' else '0';
  n97 <= n88 & n86;
  n98 <= n95 & n93 & n90;
  n99 <= '0' & '0';
  n100 <= '0' & '0';
  n101 <= n97 (1 downto 0);
  n102 <= n101 when wrap_rd2 = '0' else n34;
  n103 <= n97 (3 downto 2);
  n104 <= n103 when wrap_rd2 = '0' else n99;
  n105 <= n98 (1 downto 0);
  n106 <= n105 when wrap_rd2 = '0' else n100;
  n107 <= n98 (2);
  n108 <= n35 (7);
  n109 <= n107 when wrap_rd2 = '0' else n108;
  n110 <= n98 (22 downto 3);
  n111 <= n110 when wrap_rd2 = '0' else n58;
  n112 <= n96 when wrap_rd2 = '0' else n37;
  n113 <= n104 & n102;
  n114 <= n111 & n109 & n106;
  n115 <= '0' & '0';
  n116 <= '0' & '0';
  n117 <= n113 (1 downto 0);
  n118 <= n117 when wrap_rd1 = '0' else n34;
  n119 <= n113 (3 downto 2);
  n120 <= n119 when wrap_rd1 = '0' else n115;
  n121 <= n114 (1 downto 0);
  n122 <= n121 when wrap_rd1 = '0' else n116;
  n123 <= n114 (2);
  n124 <= n35 (7);
  n125 <= n123 when wrap_rd1 = '0' else n124;
  n126 <= n114 (22 downto 3);
  n127 <= n126 when wrap_rd1 = '0' else n46;
  n128 <= n56 (0);
  n129 <= n112 when wrap_rd1 = '0' else n128;
  n130 <= n56 (22 downto 1);
  n131 <= n42 & n40;
  n132 <= n131 when wrap_rd1 = '0' else n130;
  n134 <= '1' when n44 = "00" else '0';
  n136 <= wr_fifo_addr (20 downto 1);
  n142 <= '1' when wr_fifo_access_mode = '1' else '0';
  n146 <= '1' when wr_fifo_access_mode = '0' else '0';
  n147 <= wr_fifo_addr (0);
  n148 <= not n147;
  n149 <= n148 and n146;
  n153 <= '1' when wr_fifo_access_mode = '0' else '0';
  n154 <= wr_fifo_addr (0);
  n155 <= n154 and n153;
  n158 <= '1' & '0';
  n159 <= n35 (3 downto 2);
  n160 <= n159 when n155 = '0' else n158;
  n161 <= '0' & '1';
  n162 <= n160 when n149 = '0' else n161;
  n163 <= '0' & '0';
  n164 <= n162 when n142 = '0' else n163;
  n166 <= '1' when n44 = "01" else '0';
  n168 <= wr_fifo_addr (20 downto 1);
  n173 <= '1' when n44 = "10" else '0';
  n174 <= n173 & n166 & n134;
  with n174 select n178 <=
    '1' when "100",
    '1' when "010",
    '0' when "001",
    '0' when others;
  with n174 select n182 <=
    '1' when "100",
    '1' when "010",
    n43 when "001",
    n43 when others;
  with n174 select n185 <=
    '1' when "100",
    '0' when "010",
    '0' when "001",
    '0' when others;
  with n174 select n187 <=
    "00" when "100",
    "10" when "010",
    n118 when "001",
    n34 when others;
  n188 <= n35 (3 downto 2);
  with n174 select n189 <=
    n188 when "100",
    n164 when "010",
    n120 when "001",
    n188 when others;
  n190 <= n35 (4);
  with n174 select n191 <=
    n190 when "100",
    '0' when "010",
    n190 when "001",
    n190 when others;
  n192 <= n122 (0);
  n193 <= n35 (5);
  with n174 select n194 <=
    '0' when "100",
    '0' when "010",
    n192 when "001",
    n193 when others;
  n195 <= n122 (1);
  n196 <= n35 (6);
  with n174 select n197 <=
    '0' when "100",
    '0' when "010",
    n195 when "001",
    n196 when others;
  n198 <= n35 (7);
  with n174 select n199 <=
    '0' when "100",
    '1' when "010",
    n125 when "001",
    n198 when others;
  n200 <= n35 (27 downto 8);
  with n174 select n201 <=
    n168 when "100",
    n136 when "010",
    n127 when "001",
    n200 when others;
  with n174 select n202 <=
    n37 when "100",
    n37 when "010",
    n129 when "001",
    n37 when others;
  n203 <= n42 & n40;
  with n174 select n204 <=
    n203 when "100",
    n203 when "010",
    n132 when "001",
    n203 when others;
  n212 <= '1' when wr_fifo_access_mode = '1' else '0';
  n214 <= '1' when wr_fifo_access_mode = '0' else '0';
  n215 <= wr_fifo_addr (0);
  n216 <= not n215;
  n217 <= n216 and n214;
  n218 <= wr_fifo_data (7 downto 0);
  n220 <= '1' when wr_fifo_access_mode = '0' else '0';
  n221 <= wr_fifo_addr (0);
  n222 <= n221 and n220;
  n223 <= wr_fifo_data (7 downto 0);
  n224 <= n35 (43 downto 36);
  n225 <= n224 when n222 = '0' else n223;
  n226 <= n35 (35 downto 28);
  n227 <= n226 when n217 = '0' else n218;
  n228 <= n35 (43 downto 36);
  n229 <= n225 when n217 = '0' else n228;
  n230 <= n229 & n227;
  n231 <= n230 when n212 = '0' else wr_fifo_data;
  n234 <= not wrap_res_n;
  n236 <= not n178;
  n237 <= n236 and wrap_rd1;
  n244 <= '1' when wrap_rd1_access_mode = '1' else '0';
  n247 <= '1' when wrap_rd1_access_mode = '0' else '0';
  n248 <= wrap_rd1_addr (0);
  n249 <= not n248;
  n250 <= n249 and n247;
  n253 <= '1' when wrap_rd1_access_mode = '0' else '0';
  n254 <= wrap_rd1_addr (0);
  n255 <= n254 and n253;
  n259 <= '1' when n255 = '0' else '0';
  n263 <= "XX" when n255 = '0' else "11";
  n265 <= n259 when n250 = '0' else '0';
  n268 <= n263 when n250 = '0' else "10";
  n270 <= n265 when n244 = '0' else '0';
  n275 <= n268 when n244 = '0' else "01";
  n281 <= n275 when n270 = '0' else "00";
  n283 <= "00" when n237 = '0' else n281;
  n289 <= '1' when rd1_output_mode = "00" else '0';
  n291 <= '1' when rd1_output_mode = "01" else '0';
  n292 <= n9_c_o (7 downto 0);
  n294 <= '1' when rd1_output_mode = "10" else '0';
  n295 <= n9_c_o (15 downto 8);
  n297 <= '1' when rd1_output_mode = "11" else '0';
  n298 <= n297 & n294 & n291 & n289;
  n299 <= n9_c_o (7 downto 0);
  with n298 select n302 <=
    n295 when "1000",
    n292 when "0100",
    n299 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  n303 <= n9_c_o (15 downto 8);
  with n298 select n306 <=
    "00000000" when "1000",
    "00000000" when "0100",
    n303 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  with n298 select n312 <=
    '1' when "1000",
    '1' when "0100",
    '1' when "0010",
    '0' when "0001",
    'X' when others;
  n314 <= n306 & n302;
  n326 <= not wrap_res_n;
  n328 <= not n182;
  n329 <= wrap_rd2 and n328;
  n330 <= not wrap_rd1;
  n331 <= n329 and n330;
  n338 <= '1' when wrap_rd2_access_mode = '1' else '0';
  n341 <= '1' when wrap_rd2_access_mode = '0' else '0';
  n342 <= wrap_rd2_addr (0);
  n343 <= not n342;
  n344 <= n343 and n341;
  n347 <= '1' when wrap_rd2_access_mode = '0' else '0';
  n348 <= wrap_rd2_addr (0);
  n349 <= n348 and n347;
  n353 <= '1' when n349 = '0' else '0';
  n357 <= "XX" when n349 = '0' else "11";
  n359 <= n353 when n344 = '0' else '0';
  n362 <= n357 when n344 = '0' else "10";
  n364 <= n359 when n338 = '0' else '0';
  n369 <= n362 when n338 = '0' else "01";
  n375 <= n369 when n364 = '0' else "00";
  n377 <= "00" when n331 = '0' else n375;
  n379 <= s (44);
  n380 <= not wrap_rd1;
  n381 <= n379 and n380;
  n383 <= s (66);
  n390 <= '1' when n383 = '1' else '0';
  n393 <= '1' when n383 = '0' else '0';
  n394 <= s (45);
  n395 <= not n394;
  n396 <= n395 and n393;
  n399 <= '1' when n383 = '0' else '0';
  n400 <= s (45);
  n401 <= n400 and n399;
  n405 <= '1' when n401 = '0' else '0';
  n409 <= "XX" when n401 = '0' else "11";
  n411 <= n405 when n396 = '0' else '0';
  n414 <= n409 when n396 = '0' else "10";
  n416 <= n411 when n390 = '0' else '0';
  n421 <= n414 when n390 = '0' else "01";
  n427 <= n421 when n416 = '0' else "00";
  n428 <= n377 when n381 = '0' else n427;
  n433 <= '1' when rd2_output_mode = "00" else '0';
  n435 <= '1' when rd2_output_mode = "01" else '0';
  n436 <= n9_c_o (7 downto 0);
  n438 <= '1' when rd2_output_mode = "10" else '0';
  n439 <= n9_c_o (15 downto 8);
  n441 <= '1' when rd2_output_mode = "11" else '0';
  n442 <= n441 & n438 & n435 & n433;
  n443 <= n9_c_o (7 downto 0);
  with n442 select n446 <=
    n439 when "1000",
    n436 when "0100",
    n443 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  n447 <= n9_c_o (15 downto 8);
  with n442 select n450 <=
    "00000000" when "1000",
    "00000000" when "0100",
    n447 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  with n442 select n456 <=
    '1' when "1000",
    '1' when "0100",
    '1' when "0010",
    '0' when "0001",
    'X' when others;
  n458 <= n450 & n446;
  wr_fifo_block_fifo_data_out <= wr_fifo_block_wr_fifo_n469; -- (signal)
  wr_fifo_block_wr_access_mode_sul <= n505; -- (signal)
  wr_fifo_block_wr_fifo_n469 <= wr_fifo_block_wr_fifo_c_rd_data; -- (signal)
  wr_fifo_block_wr_fifo_n470 <= wr_fifo_block_wr_fifo_c_rd_valid; -- (signal)
  n471 <= wr_fifo_block_wr_access_mode_sul & wrap_wr_data;
  n472 <= n471 & wrap_wr_addr;
  wr_fifo_block_wr_fifo_n473 <= wr_fifo_block_wr_fifo_c_full; -- (signal)
  wr_fifo_block_wr_fifo_n474 <= wr_fifo_block_wr_fifo_c_half_full; -- (signal)
  wr_fifo_block_wr_fifo : entity work.fifo_1c1r1w_fwft_8_38 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    rd_ack => wr_fifo_rd_ack,
    wr_data => n472,
    wr => wrap_wr,
    rd_data => wr_fifo_block_wr_fifo_c_rd_data,
    rd_valid => wr_fifo_block_wr_fifo_c_rd_valid,
    full => wr_fifo_block_wr_fifo_c_full,
    half_full => wr_fifo_block_wr_fifo_c_half_full);
  n489 <= '1' when wrap_wr_access_mode = '1' else '0';
  n493 <= '1' when n489 = '0' else '0';
  n499 <= 'X' when n489 = '0' else '1';
  n505 <= n499 when n493 = '0' else '0';
  n506 <= not wr_fifo_rd_valid;
  n507 <= wr_fifo_block_fifo_data_out (20 downto 0);
  n508 <= wr_fifo_block_fifo_data_out (36 downto 21);
  n510 <= wr_fifo_block_fifo_data_out (37);
  n518 <= '1' when n510 = '0' else '0';
  n524 <= 'X' when n510 = '0' else '1';
  n530 <= n524 when n518 = '0' else '0';
  process (wrap_clk, n234)
  begin
    if n234 = '1' then
      n531 <= "00";
    elsif rising_edge (wrap_clk) then
      n531 <= n283;
    end if;
  end process;
  process (wrap_clk, n326)
  begin
    if n326 = '1' then
      n532 <= "00";
    elsif rising_edge (wrap_clk) then
      n532 <= n428;
    end if;
  end process;
  process (wrap_clk, n27)
  begin
    if n27 = '1' then
      n533 <= "0000000000000000000000000000000000000000000000000000000000001111100";
    elsif rising_edge (wrap_clk) then
      n533 <= s_nxt;
    end if;
  end process;
  n534 <= n204 & n202 & n231 & n201 & n199 & n197 & n194 & n191 & n189 & n187;
  process (wrap_clk, n234)
  begin
    if n234 = '1' then
      n535 <= "0000000000000000";
    elsif rising_edge (wrap_clk) then
      n535 <= n314;
    end if;
  end process;
  process (wrap_clk, n234)
  begin
    if n234 = '1' then
      n536 <= '0';
    elsif rising_edge (wrap_clk) then
      n536 <= n312;
    end if;
  end process;
  process (wrap_clk, n326)
  begin
    if n326 = '1' then
      n537 <= "0000000000000000";
    elsif rising_edge (wrap_clk) then
      n537 <= n458;
    end if;
  end process;
  process (wrap_clk, n326)
  begin
    if n326 = '1' then
      n538 <= '0';
    elsif rising_edge (wrap_clk) then
      n538 <= n456;
    end if;
  end process;
  n539 <= n16 when (n17 = '1') else (15 downto 0 => 'Z');
  assert addr_width = 21 report "Unsupported generic value! addr_width must be 21." severity failure;
  assert data_width = 16 report "Unsupported generic value! data_width must be 16." severity failure;
  assert wr_buf_size = 8 report "Unsupported generic value! wr_buf_size must be 8." severity failure;
end architecture;
