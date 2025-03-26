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
  signal n691 : std_logic_vector (37 downto 0);
  signal n692 : std_logic_vector (37 downto 0) := "00000000000000000000000000000000000000";
  signal n694 : std_logic_vector (37 downto 0);
begin
  rd1_data <= n692;
  n691 <= n692 when rd1 = '0' else n694;
  process (clk)
  begin
    if rising_edge (clk) then
      n692 <= n691;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (37 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n694 <= ram(to_integer (unsigned (rd1_addr)));
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
  signal memory_inst_n578 : std_logic_vector (37 downto 0);
  signal memory_inst_c_rd1_data : std_logic_vector (37 downto 0);
  signal n582 : std_logic;
  signal n605 : std_logic;
  signal n606 : std_logic;
  signal n608 : std_logic_vector (2 downto 0);
  signal n609 : std_logic_vector (2 downto 0);
  signal n612 : std_logic;
  signal n614 : std_logic;
  signal n615 : std_logic;
  signal n617 : std_logic_vector (2 downto 0);
  signal n618 : std_logic_vector (2 downto 0);
  signal n621 : std_logic;
  signal n623 : std_logic;
  signal n624 : std_logic;
  signal n626 : std_logic_vector (31 downto 0);
  signal n627 : std_logic;
  signal n628 : std_logic;
  signal n630 : std_logic_vector (31 downto 0);
  signal n631 : std_logic_vector (31 downto 0);
  signal n632 : std_logic_vector (31 downto 0);
  signal n634 : std_logic;
  signal n637 : std_logic;
  signal n640 : std_logic_vector (2 downto 0);
  signal n641 : std_logic;
  signal n643 : std_logic;
  signal n645 : std_logic;
  signal n646 : std_logic;
  signal n648 : std_logic_vector (2 downto 0);
  signal n649 : std_logic;
  signal n650 : std_logic;
  signal n651 : std_logic;
  signal n653 : std_logic;
  signal n654 : std_logic;
  signal n656 : std_logic;
  signal n663 : std_logic_vector (2 downto 0);
  signal n664 : std_logic_vector (2 downto 0);
  signal n665 : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n666 : std_logic;
  signal n667 : std_logic;
  signal n668 : std_logic;
begin
  rd_data <= memory_inst_n578;
  empty <= n666;
  full <= n667;
  half_full <= n668;
  read_address <= n663; -- (signal)
  read_address_next <= n618; -- (signal)
  write_address <= n664; -- (signal)
  write_address_next <= n609; -- (signal)
  full_next <= n653; -- (signal)
  empty_next <= n656; -- (signal)
  wr_int <= n612; -- (signal)
  rd_int <= n621; -- (signal)
  half_full_next <= n637; -- (signal)
  pointer_diff <= n665; -- (isignal)
  pointer_diff_next <= n632; -- (isignal)
  memory_inst_n578 <= memory_inst_c_rd1_data; -- (signal)
  memory_inst : entity work.dp_ram_1c1r1w_3_38 port map (
    clk => clk,
    rd1_addr => read_address,
    rd1 => rd_int,
    wr2_addr => write_address,
    wr2_data => wr_data,
    wr2 => wr_int,
    rd1_data => memory_inst_c_rd1_data);
  n582 <= not res_n;
  n605 <= not n667;
  n606 <= n605 and wr;
  n608 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n609 <= write_address when n606 = '0' else n608;
  n612 <= '0' when n606 = '0' else '1';
  n614 <= not n666;
  n615 <= n614 and rd;
  n617 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n618 <= read_address when n615 = '0' else n617;
  n621 <= '0' when n615 = '0' else '1';
  n623 <= not rd;
  n624 <= n623 and wr;
  n626 <= std_logic_vector (unsigned (pointer_diff) + unsigned'("00000000000000000000000000000001"));
  n627 <= not wr;
  n628 <= n627 and rd;
  n630 <= std_logic_vector (unsigned (pointer_diff) - unsigned'("00000000000000000000000000000001"));
  n631 <= pointer_diff when n628 = '0' else n630;
  n632 <= n631 when n624 = '0' else n626;
  n634 <= '1' when signed (n632) >= signed'("00000000000000000000000000000100") else '0';
  n637 <= '0' when n634 = '0' else '1';
  n640 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n641 <= '1' when write_address = n640 else '0';
  n643 <= n666 when n646 = '0' else '1';
  n645 <= n667 when rd = '0' else '0';
  n646 <= n641 and rd;
  n648 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n649 <= '1' when read_address = n648 else '0';
  n650 <= not rd;
  n651 <= n650 and n649;
  n653 <= n645 when n654 = '0' else '1';
  n654 <= n651 and wr;
  n656 <= n643 when wr = '0' else '0';
  process (clk, n582)
  begin
    if n582 = '1' then
      n663 <= "000";
    elsif rising_edge (clk) then
      n663 <= read_address_next;
    end if;
  end process;
  process (clk, n582)
  begin
    if n582 = '1' then
      n664 <= "000";
    elsif rising_edge (clk) then
      n664 <= write_address_next;
    end if;
  end process;
  process (clk, n582)
  begin
    if n582 = '1' then
      n665 <= "00000000000000000000000000000000";
    elsif rising_edge (clk) then
      n665 <= pointer_diff_next;
    end if;
  end process;
  process (clk, n582)
  begin
    if n582 = '1' then
      n666 <= '1';
    elsif rising_edge (clk) then
      n666 <= empty_next;
    end if;
  end process;
  process (clk, n582)
  begin
    if n582 = '1' then
      n667 <= '0';
    elsif rising_edge (clk) then
      n667 <= full_next;
    end if;
  end process;
  process (clk, n582)
  begin
    if n582 = '1' then
      n668 <= '0';
    elsif rising_edge (clk) then
      n668 <= half_full_next;
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
  signal fifo_inst_n543 : std_logic_vector (37 downto 0);
  signal fifo_inst_n544 : std_logic;
  signal fifo_inst_n545 : std_logic;
  signal fifo_inst_n546 : std_logic;
  signal fifo_inst_c_rd_data : std_logic_vector (37 downto 0);
  signal fifo_inst_c_empty : std_logic;
  signal fifo_inst_c_full : std_logic;
  signal fifo_inst_c_half_full : std_logic;
  signal n555 : std_logic;
  signal n556 : std_logic;
  signal n557 : std_logic;
  signal n558 : std_logic;
  signal n559 : std_logic;
  signal n561 : std_logic;
  signal n563 : std_logic;
  signal n569 : std_logic;
  signal n570 : std_logic;
begin
  rd_data <= fifo_inst_n543;
  rd_valid <= n570;
  full <= fifo_inst_n545;
  half_full <= fifo_inst_n546;
  rd <= n559; -- (signal)
  empty <= fifo_inst_n544; -- (signal)
  not_empty <= n555; -- (signal)
  fifo_inst_n543 <= fifo_inst_c_rd_data; -- (signal)
  fifo_inst_n544 <= fifo_inst_c_empty; -- (signal)
  fifo_inst_n545 <= fifo_inst_c_full; -- (signal)
  fifo_inst_n546 <= fifo_inst_c_half_full; -- (signal)
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
  n555 <= not empty;
  n556 <= rd_ack and not_empty;
  n557 <= not n570;
  n558 <= not_empty and n557;
  n559 <= n556 or n558;
  n561 <= not res_n;
  n563 <= rd or rd_ack;
  n569 <= n570 when n563 = '0' else not_empty;
  process (clk, n561)
  begin
    if n561 = '1' then
      n570 <= '0';
    elsif rising_edge (clk) then
      n570 <= n569;
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
  signal n38 : std_logic_vector (1 downto 0);
  signal n40 : std_logic_vector (19 downto 0);
  signal n48 : std_logic_vector (22 downto 0);
  signal n49 : std_logic_vector (22 downto 0);
  signal n50 : std_logic_vector (22 downto 0);
  signal n52 : std_logic_vector (19 downto 0);
  signal n59 : std_logic;
  signal n62 : std_logic_vector (19 downto 0);
  signal n70 : std_logic_vector (19 downto 0);
  signal n74 : std_logic_vector (22 downto 0);
  signal n75 : std_logic_vector (1 downto 0);
  signal n76 : std_logic_vector (22 downto 0);
  signal n77 : std_logic_vector (22 downto 0);
  signal n78 : std_logic_vector (1 downto 0);
  signal n79 : std_logic_vector (1 downto 0);
  signal n80 : std_logic_vector (1 downto 0);
  signal n81 : std_logic_vector (1 downto 0);
  signal n82 : std_logic_vector (1 downto 0);
  signal n83 : std_logic_vector (1 downto 0);
  signal n84 : std_logic_vector (1 downto 0);
  signal n85 : std_logic;
  signal n86 : std_logic;
  signal n87 : std_logic;
  signal n88 : std_logic_vector (19 downto 0);
  signal n89 : std_logic_vector (19 downto 0);
  signal n90 : std_logic;
  signal n91 : std_logic;
  signal n92 : std_logic_vector (3 downto 0);
  signal n93 : std_logic_vector (22 downto 0);
  signal n94 : std_logic_vector (1 downto 0);
  signal n95 : std_logic_vector (1 downto 0);
  signal n96 : std_logic_vector (1 downto 0);
  signal n97 : std_logic_vector (1 downto 0);
  signal n98 : std_logic_vector (1 downto 0);
  signal n99 : std_logic_vector (1 downto 0);
  signal n100 : std_logic_vector (1 downto 0);
  signal n101 : std_logic_vector (1 downto 0);
  signal n102 : std_logic;
  signal n103 : std_logic;
  signal n104 : std_logic;
  signal n105 : std_logic_vector (19 downto 0);
  signal n106 : std_logic_vector (19 downto 0);
  signal n107 : std_logic;
  signal n108 : std_logic;
  signal n109 : std_logic_vector (3 downto 0);
  signal n110 : std_logic_vector (22 downto 0);
  signal n111 : std_logic_vector (1 downto 0);
  signal n112 : std_logic_vector (1 downto 0);
  signal n113 : std_logic_vector (1 downto 0);
  signal n114 : std_logic_vector (1 downto 0);
  signal n115 : std_logic_vector (1 downto 0);
  signal n116 : std_logic_vector (1 downto 0);
  signal n117 : std_logic_vector (1 downto 0);
  signal n118 : std_logic_vector (1 downto 0);
  signal n119 : std_logic;
  signal n120 : std_logic;
  signal n121 : std_logic;
  signal n122 : std_logic_vector (19 downto 0);
  signal n123 : std_logic_vector (19 downto 0);
  signal n124 : std_logic;
  signal n125 : std_logic;
  signal n126 : std_logic_vector (21 downto 0);
  signal n127 : std_logic_vector (21 downto 0);
  signal n128 : std_logic_vector (21 downto 0);
  signal n130 : std_logic;
  signal n132 : std_logic_vector (19 downto 0);
  signal n138 : std_logic;
  signal n142 : std_logic;
  signal n143 : std_logic;
  signal n144 : std_logic;
  signal n145 : std_logic;
  signal n149 : std_logic;
  signal n150 : std_logic;
  signal n151 : std_logic;
  signal n154 : std_logic_vector (1 downto 0);
  signal n155 : std_logic_vector (1 downto 0);
  signal n156 : std_logic_vector (1 downto 0);
  signal n157 : std_logic_vector (1 downto 0);
  signal n158 : std_logic_vector (1 downto 0);
  signal n159 : std_logic_vector (1 downto 0);
  signal n160 : std_logic_vector (1 downto 0);
  signal n162 : std_logic;
  signal n164 : std_logic_vector (19 downto 0);
  signal n169 : std_logic;
  signal n170 : std_logic_vector (2 downto 0);
  signal n174 : std_logic;
  signal n178 : std_logic;
  signal n181 : std_logic;
  signal n183 : std_logic_vector (1 downto 0);
  signal n184 : std_logic_vector (1 downto 0);
  signal n185 : std_logic_vector (1 downto 0);
  signal n186 : std_logic;
  signal n187 : std_logic;
  signal n188 : std_logic;
  signal n189 : std_logic;
  signal n190 : std_logic;
  signal n191 : std_logic;
  signal n192 : std_logic;
  signal n193 : std_logic;
  signal n194 : std_logic;
  signal n195 : std_logic;
  signal n196 : std_logic_vector (19 downto 0);
  signal n197 : std_logic_vector (19 downto 0);
  signal n198 : std_logic;
  signal n199 : std_logic;
  signal n200 : std_logic_vector (21 downto 0);
  signal n201 : std_logic_vector (21 downto 0);
  signal n211 : std_logic;
  signal n213 : std_logic;
  signal n214 : std_logic;
  signal n215 : std_logic;
  signal n216 : std_logic;
  signal n217 : std_logic_vector (7 downto 0);
  signal n219 : std_logic;
  signal n220 : std_logic;
  signal n221 : std_logic;
  signal n222 : std_logic_vector (7 downto 0);
  signal n223 : std_logic_vector (7 downto 0);
  signal n224 : std_logic_vector (7 downto 0);
  signal n225 : std_logic_vector (7 downto 0);
  signal n226 : std_logic_vector (7 downto 0);
  signal n227 : std_logic_vector (7 downto 0);
  signal n228 : std_logic_vector (7 downto 0);
  signal n229 : std_logic_vector (15 downto 0);
  signal n230 : std_logic_vector (15 downto 0);
  signal n233 : std_logic;
  signal n235 : std_logic;
  signal n236 : std_logic;
  signal n243 : std_logic;
  signal n246 : std_logic;
  signal n247 : std_logic;
  signal n248 : std_logic;
  signal n249 : std_logic;
  signal n252 : std_logic;
  signal n253 : std_logic;
  signal n254 : std_logic;
  signal n258 : std_logic;
  signal n262 : std_logic_vector (1 downto 0);
  signal n264 : std_logic;
  signal n267 : std_logic_vector (1 downto 0);
  signal n269 : std_logic;
  signal n274 : std_logic_vector (1 downto 0);
  signal n280 : std_logic_vector (1 downto 0);
  signal n282 : std_logic_vector (1 downto 0);
  signal n288 : std_logic;
  signal n290 : std_logic;
  signal n291 : std_logic_vector (7 downto 0);
  signal n293 : std_logic;
  signal n294 : std_logic_vector (7 downto 0);
  signal n296 : std_logic;
  signal n297 : std_logic_vector (3 downto 0);
  signal n298 : std_logic_vector (7 downto 0);
  signal n301 : std_logic_vector (7 downto 0);
  signal n302 : std_logic_vector (7 downto 0);
  signal n305 : std_logic_vector (7 downto 0);
  signal n311 : std_logic;
  signal n313 : std_logic_vector (15 downto 0);
  signal n325 : std_logic;
  signal n327 : std_logic;
  signal n328 : std_logic;
  signal n329 : std_logic;
  signal n330 : std_logic;
  signal n337 : std_logic;
  signal n340 : std_logic;
  signal n341 : std_logic;
  signal n342 : std_logic;
  signal n343 : std_logic;
  signal n346 : std_logic;
  signal n347 : std_logic;
  signal n348 : std_logic;
  signal n352 : std_logic;
  signal n356 : std_logic_vector (1 downto 0);
  signal n358 : std_logic;
  signal n361 : std_logic_vector (1 downto 0);
  signal n363 : std_logic;
  signal n368 : std_logic_vector (1 downto 0);
  signal n374 : std_logic_vector (1 downto 0);
  signal n376 : std_logic_vector (1 downto 0);
  signal n378 : std_logic;
  signal n379 : std_logic;
  signal n380 : std_logic;
  signal n382 : std_logic;
  signal n389 : std_logic;
  signal n392 : std_logic;
  signal n393 : std_logic;
  signal n394 : std_logic;
  signal n395 : std_logic;
  signal n398 : std_logic;
  signal n399 : std_logic;
  signal n400 : std_logic;
  signal n404 : std_logic;
  signal n408 : std_logic_vector (1 downto 0);
  signal n410 : std_logic;
  signal n413 : std_logic_vector (1 downto 0);
  signal n415 : std_logic;
  signal n420 : std_logic_vector (1 downto 0);
  signal n426 : std_logic_vector (1 downto 0);
  signal n427 : std_logic_vector (1 downto 0);
  signal n432 : std_logic;
  signal n434 : std_logic;
  signal n435 : std_logic_vector (7 downto 0);
  signal n437 : std_logic;
  signal n438 : std_logic_vector (7 downto 0);
  signal n440 : std_logic;
  signal n441 : std_logic_vector (3 downto 0);
  signal n442 : std_logic_vector (7 downto 0);
  signal n445 : std_logic_vector (7 downto 0);
  signal n446 : std_logic_vector (7 downto 0);
  signal n449 : std_logic_vector (7 downto 0);
  signal n455 : std_logic;
  signal n457 : std_logic_vector (15 downto 0);
  signal wr_fifo_block_fifo_data_out : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_access_mode_sul : std_logic;
  signal wr_fifo_block_wr_fifo_n468 : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_fifo_n469 : std_logic;
  signal n470 : std_logic_vector (16 downto 0);
  signal n471 : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_fifo_n472 : std_logic;
  signal wr_fifo_block_wr_fifo_n473 : std_logic;
  signal wr_fifo_block_wr_fifo_c_rd_data : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_fifo_c_rd_valid : std_logic;
  signal wr_fifo_block_wr_fifo_c_full : std_logic;
  signal wr_fifo_block_wr_fifo_c_half_full : std_logic;
  signal n488 : std_logic;
  signal n492 : std_logic;
  signal n498 : std_logic;
  signal n504 : std_logic;
  signal n505 : std_logic;
  signal n506 : std_logic_vector (20 downto 0);
  signal n507 : std_logic_vector (15 downto 0);
  signal n509 : std_logic;
  signal n517 : std_logic;
  signal n523 : std_logic;
  signal n529 : std_logic;
  signal n530 : std_logic_vector (1 downto 0);
  signal n531 : std_logic_vector (1 downto 0);
  signal n532 : std_logic_vector (66 downto 0);
  signal n533 : std_logic_vector (66 downto 0);
  signal n534 : std_logic_vector (15 downto 0);
  signal n535 : std_logic;
  signal n536 : std_logic_vector (15 downto 0);
  signal n537 : std_logic;
  signal n538 : std_logic_vector (15 downto 0);
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
  wrap_wr_empty <= n505;
  wrap_wr_full <= wr_fifo_block_wr_fifo_n472;
  wrap_wr_half_full <= wr_fifo_block_wr_fifo_n473;
  wrap_rd1_busy <= n174;
  wrap_rd1_data <= n534;
  wrap_rd1_valid <= n535;
  wrap_rd2_busy <= n178;
  wrap_rd2_data <= n536;
  wrap_rd2_valid <= n537;
  sram_dq <= n9_c_oport;
  wrap_sram_addr <= n20;
  wrap_sram_ub_n <= n21;
  wrap_sram_lb_n <= n22;
  wrap_sram_we_n <= n23;
  wrap_sram_ce_n <= n24;
  wrap_sram_oe_n <= n25;
  n9_c_oport <= n538; -- (inout - port)
  n9_c_o <= sram_dq; -- (inout - read)
  wr_fifo_rd_valid <= wr_fifo_block_wr_fifo_n469; -- (signal)
  wr_fifo_rd_ack <= n181; -- (signal)
  wr_fifo_data <= n507; -- (signal)
  wr_fifo_addr <= n506; -- (signal)
  wr_fifo_access_mode <= n529; -- (signal)
  rd1_output_mode <= n530; -- (signal)
  rd2_output_mode <= n531; -- (signal)
  s <= n532; -- (signal)
  s_nxt <= n533; -- (signal)
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
  n38 <= s (1 downto 0);
  n40 <= wrap_rd1_addr (20 downto 1);
  n48 <= wrap_rd2_access_mode & wrap_rd2_addr & '1';
  n49 <= n35 (66 downto 44);
  n50 <= n49 when wrap_rd2 = '0' else n48;
  n52 <= wrap_rd2_addr (20 downto 1);
  n59 <= s (44);
  n62 <= s (65 downto 46);
  n70 <= wr_fifo_addr (20 downto 1);
  n74 <= n70 & '1' & '0' & '0';
  n75 <= n34 when wr_fifo_rd_valid = '0' else "01";
  n76 <= n35 (27 downto 5);
  n77 <= n76 when wr_fifo_rd_valid = '0' else n74;
  n78 <= '0' & '0';
  n79 <= '0' & '0';
  n80 <= n75 when n59 = '0' else n34;
  n81 <= n35 (3 downto 2);
  n82 <= n81 when n59 = '0' else n78;
  n83 <= n77 (1 downto 0);
  n84 <= n83 when n59 = '0' else n79;
  n85 <= n77 (2);
  n86 <= n35 (7);
  n87 <= n85 when n59 = '0' else n86;
  n88 <= n77 (22 downto 3);
  n89 <= n88 when n59 = '0' else n62;
  n90 <= n35 (44);
  n91 <= n90 when n59 = '0' else '0';
  n92 <= n82 & n80;
  n93 <= n89 & n87 & n84;
  n94 <= '0' & '0';
  n95 <= '0' & '0';
  n96 <= n92 (1 downto 0);
  n97 <= n96 when wrap_rd2 = '0' else n34;
  n98 <= n92 (3 downto 2);
  n99 <= n98 when wrap_rd2 = '0' else n94;
  n100 <= n93 (1 downto 0);
  n101 <= n100 when wrap_rd2 = '0' else n95;
  n102 <= n93 (2);
  n103 <= n35 (7);
  n104 <= n102 when wrap_rd2 = '0' else n103;
  n105 <= n93 (22 downto 3);
  n106 <= n105 when wrap_rd2 = '0' else n52;
  n107 <= n35 (44);
  n108 <= n91 when wrap_rd2 = '0' else n107;
  n109 <= n99 & n97;
  n110 <= n106 & n104 & n101;
  n111 <= '0' & '0';
  n112 <= '0' & '0';
  n113 <= n109 (1 downto 0);
  n114 <= n113 when wrap_rd1 = '0' else n34;
  n115 <= n109 (3 downto 2);
  n116 <= n115 when wrap_rd1 = '0' else n111;
  n117 <= n110 (1 downto 0);
  n118 <= n117 when wrap_rd1 = '0' else n112;
  n119 <= n110 (2);
  n120 <= n35 (7);
  n121 <= n119 when wrap_rd1 = '0' else n120;
  n122 <= n110 (22 downto 3);
  n123 <= n122 when wrap_rd1 = '0' else n40;
  n124 <= n50 (0);
  n125 <= n108 when wrap_rd1 = '0' else n124;
  n126 <= n50 (22 downto 1);
  n127 <= n35 (66 downto 45);
  n128 <= n127 when wrap_rd1 = '0' else n126;
  n130 <= '1' when n38 = "00" else '0';
  n132 <= wr_fifo_addr (20 downto 1);
  n138 <= '1' when wr_fifo_access_mode = '1' else '0';
  n142 <= '1' when wr_fifo_access_mode = '0' else '0';
  n143 <= wr_fifo_addr (0);
  n144 <= not n143;
  n145 <= n144 and n142;
  n149 <= '1' when wr_fifo_access_mode = '0' else '0';
  n150 <= wr_fifo_addr (0);
  n151 <= n150 and n149;
  n154 <= '1' & '0';
  n155 <= n35 (3 downto 2);
  n156 <= n155 when n151 = '0' else n154;
  n157 <= '0' & '1';
  n158 <= n156 when n145 = '0' else n157;
  n159 <= '0' & '0';
  n160 <= n158 when n138 = '0' else n159;
  n162 <= '1' when n38 = "01" else '0';
  n164 <= wr_fifo_addr (20 downto 1);
  n169 <= '1' when n38 = "10" else '0';
  n170 <= n169 & n162 & n130;
  with n170 select n174 <=
    '1' when "100",
    '1' when "010",
    '0' when "001",
    '0' when others;
  with n170 select n178 <=
    '1' when "100",
    '1' when "010",
    n37 when "001",
    n37 when others;
  with n170 select n181 <=
    '1' when "100",
    '0' when "010",
    '0' when "001",
    '0' when others;
  with n170 select n183 <=
    "00" when "100",
    "10" when "010",
    n114 when "001",
    n34 when others;
  n184 <= n35 (3 downto 2);
  with n170 select n185 <=
    n184 when "100",
    n160 when "010",
    n116 when "001",
    n184 when others;
  n186 <= n35 (4);
  with n170 select n187 <=
    n186 when "100",
    '0' when "010",
    n186 when "001",
    n186 when others;
  n188 <= n118 (0);
  n189 <= n35 (5);
  with n170 select n190 <=
    '0' when "100",
    '0' when "010",
    n188 when "001",
    n189 when others;
  n191 <= n118 (1);
  n192 <= n35 (6);
  with n170 select n193 <=
    '0' when "100",
    '0' when "010",
    n191 when "001",
    n192 when others;
  n194 <= n35 (7);
  with n170 select n195 <=
    '0' when "100",
    '1' when "010",
    n121 when "001",
    n194 when others;
  n196 <= n35 (27 downto 8);
  with n170 select n197 <=
    n164 when "100",
    n132 when "010",
    n123 when "001",
    n196 when others;
  n198 <= n35 (44);
  with n170 select n199 <=
    n198 when "100",
    n198 when "010",
    n125 when "001",
    n198 when others;
  n200 <= n35 (66 downto 45);
  with n170 select n201 <=
    n200 when "100",
    n200 when "010",
    n128 when "001",
    n200 when others;
  n211 <= '1' when wr_fifo_access_mode = '1' else '0';
  n213 <= '1' when wr_fifo_access_mode = '0' else '0';
  n214 <= wr_fifo_addr (0);
  n215 <= not n214;
  n216 <= n215 and n213;
  n217 <= wr_fifo_data (7 downto 0);
  n219 <= '1' when wr_fifo_access_mode = '0' else '0';
  n220 <= wr_fifo_addr (0);
  n221 <= n220 and n219;
  n222 <= wr_fifo_data (7 downto 0);
  n223 <= n35 (43 downto 36);
  n224 <= n223 when n221 = '0' else n222;
  n225 <= n35 (35 downto 28);
  n226 <= n225 when n216 = '0' else n217;
  n227 <= n35 (43 downto 36);
  n228 <= n224 when n216 = '0' else n227;
  n229 <= n228 & n226;
  n230 <= n229 when n211 = '0' else wr_fifo_data;
  n233 <= not wrap_res_n;
  n235 <= not n174;
  n236 <= n235 and wrap_rd1;
  n243 <= '1' when wrap_rd1_access_mode = '1' else '0';
  n246 <= '1' when wrap_rd1_access_mode = '0' else '0';
  n247 <= wrap_rd1_addr (0);
  n248 <= not n247;
  n249 <= n248 and n246;
  n252 <= '1' when wrap_rd1_access_mode = '0' else '0';
  n253 <= wrap_rd1_addr (0);
  n254 <= n253 and n252;
  n258 <= '1' when n254 = '0' else '0';
  n262 <= "XX" when n254 = '0' else "11";
  n264 <= n258 when n249 = '0' else '0';
  n267 <= n262 when n249 = '0' else "10";
  n269 <= n264 when n243 = '0' else '0';
  n274 <= n267 when n243 = '0' else "01";
  n280 <= n274 when n269 = '0' else "00";
  n282 <= "00" when n236 = '0' else n280;
  n288 <= '1' when rd1_output_mode = "00" else '0';
  n290 <= '1' when rd1_output_mode = "01" else '0';
  n291 <= n9_c_o (7 downto 0);
  n293 <= '1' when rd1_output_mode = "10" else '0';
  n294 <= n9_c_o (15 downto 8);
  n296 <= '1' when rd1_output_mode = "11" else '0';
  n297 <= n296 & n293 & n290 & n288;
  n298 <= n9_c_o (7 downto 0);
  with n297 select n301 <=
    n294 when "1000",
    n291 when "0100",
    n298 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  n302 <= n9_c_o (15 downto 8);
  with n297 select n305 <=
    "00000000" when "1000",
    "00000000" when "0100",
    n302 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  with n297 select n311 <=
    '1' when "1000",
    '1' when "0100",
    '1' when "0010",
    '0' when "0001",
    'X' when others;
  n313 <= n305 & n301;
  n325 <= not wrap_res_n;
  n327 <= not n178;
  n328 <= wrap_rd2 and n327;
  n329 <= not wrap_rd1;
  n330 <= n328 and n329;
  n337 <= '1' when wrap_rd2_access_mode = '1' else '0';
  n340 <= '1' when wrap_rd2_access_mode = '0' else '0';
  n341 <= wrap_rd2_addr (0);
  n342 <= not n341;
  n343 <= n342 and n340;
  n346 <= '1' when wrap_rd2_access_mode = '0' else '0';
  n347 <= wrap_rd2_addr (0);
  n348 <= n347 and n346;
  n352 <= '1' when n348 = '0' else '0';
  n356 <= "XX" when n348 = '0' else "11";
  n358 <= n352 when n343 = '0' else '0';
  n361 <= n356 when n343 = '0' else "10";
  n363 <= n358 when n337 = '0' else '0';
  n368 <= n361 when n337 = '0' else "01";
  n374 <= n368 when n363 = '0' else "00";
  n376 <= "00" when n330 = '0' else n374;
  n378 <= s (44);
  n379 <= not wrap_rd1;
  n380 <= n378 and n379;
  n382 <= s (66);
  n389 <= '1' when n382 = '1' else '0';
  n392 <= '1' when n382 = '0' else '0';
  n393 <= s (45);
  n394 <= not n393;
  n395 <= n394 and n392;
  n398 <= '1' when n382 = '0' else '0';
  n399 <= s (45);
  n400 <= n399 and n398;
  n404 <= '1' when n400 = '0' else '0';
  n408 <= "XX" when n400 = '0' else "11";
  n410 <= n404 when n395 = '0' else '0';
  n413 <= n408 when n395 = '0' else "10";
  n415 <= n410 when n389 = '0' else '0';
  n420 <= n413 when n389 = '0' else "01";
  n426 <= n420 when n415 = '0' else "00";
  n427 <= n376 when n380 = '0' else n426;
  n432 <= '1' when rd2_output_mode = "00" else '0';
  n434 <= '1' when rd2_output_mode = "01" else '0';
  n435 <= n9_c_o (7 downto 0);
  n437 <= '1' when rd2_output_mode = "10" else '0';
  n438 <= n9_c_o (15 downto 8);
  n440 <= '1' when rd2_output_mode = "11" else '0';
  n441 <= n440 & n437 & n434 & n432;
  n442 <= n9_c_o (7 downto 0);
  with n441 select n445 <=
    n438 when "1000",
    n435 when "0100",
    n442 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  n446 <= n9_c_o (15 downto 8);
  with n441 select n449 <=
    "00000000" when "1000",
    "00000000" when "0100",
    n446 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  with n441 select n455 <=
    '1' when "1000",
    '1' when "0100",
    '1' when "0010",
    '0' when "0001",
    'X' when others;
  n457 <= n449 & n445;
  wr_fifo_block_fifo_data_out <= wr_fifo_block_wr_fifo_n468; -- (signal)
  wr_fifo_block_wr_access_mode_sul <= n504; -- (signal)
  wr_fifo_block_wr_fifo_n468 <= wr_fifo_block_wr_fifo_c_rd_data; -- (signal)
  wr_fifo_block_wr_fifo_n469 <= wr_fifo_block_wr_fifo_c_rd_valid; -- (signal)
  n470 <= wr_fifo_block_wr_access_mode_sul & wrap_wr_data;
  n471 <= n470 & wrap_wr_addr;
  wr_fifo_block_wr_fifo_n472 <= wr_fifo_block_wr_fifo_c_full; -- (signal)
  wr_fifo_block_wr_fifo_n473 <= wr_fifo_block_wr_fifo_c_half_full; -- (signal)
  wr_fifo_block_wr_fifo : entity work.fifo_1c1r1w_fwft_8_38 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    rd_ack => wr_fifo_rd_ack,
    wr_data => n471,
    wr => wrap_wr,
    rd_data => wr_fifo_block_wr_fifo_c_rd_data,
    rd_valid => wr_fifo_block_wr_fifo_c_rd_valid,
    full => wr_fifo_block_wr_fifo_c_full,
    half_full => wr_fifo_block_wr_fifo_c_half_full);
  n488 <= '1' when wrap_wr_access_mode = '1' else '0';
  n492 <= '1' when n488 = '0' else '0';
  n498 <= 'X' when n488 = '0' else '1';
  n504 <= n498 when n492 = '0' else '0';
  n505 <= not wr_fifo_rd_valid;
  n506 <= wr_fifo_block_fifo_data_out (20 downto 0);
  n507 <= wr_fifo_block_fifo_data_out (36 downto 21);
  n509 <= wr_fifo_block_fifo_data_out (37);
  n517 <= '1' when n509 = '0' else '0';
  n523 <= 'X' when n509 = '0' else '1';
  n529 <= n523 when n517 = '0' else '0';
  process (wrap_clk, n233)
  begin
    if n233 = '1' then
      n530 <= "00";
    elsif rising_edge (wrap_clk) then
      n530 <= n282;
    end if;
  end process;
  process (wrap_clk, n325)
  begin
    if n325 = '1' then
      n531 <= "00";
    elsif rising_edge (wrap_clk) then
      n531 <= n427;
    end if;
  end process;
  process (wrap_clk, n27)
  begin
    if n27 = '1' then
      n532 <= "0000000000000000000000000000000000000000000000000000000000001111100";
    elsif rising_edge (wrap_clk) then
      n532 <= s_nxt;
    end if;
  end process;
  n533 <= n201 & n199 & n230 & n197 & n195 & n193 & n190 & n187 & n185 & n183;
  process (wrap_clk, n233)
  begin
    if n233 = '1' then
      n534 <= "0000000000000000";
    elsif rising_edge (wrap_clk) then
      n534 <= n313;
    end if;
  end process;
  process (wrap_clk, n233)
  begin
    if n233 = '1' then
      n535 <= '0';
    elsif rising_edge (wrap_clk) then
      n535 <= n311;
    end if;
  end process;
  process (wrap_clk, n325)
  begin
    if n325 = '1' then
      n536 <= "0000000000000000";
    elsif rising_edge (wrap_clk) then
      n536 <= n457;
    end if;
  end process;
  process (wrap_clk, n325)
  begin
    if n325 = '1' then
      n537 <= '0';
    elsif rising_edge (wrap_clk) then
      n537 <= n455;
    end if;
  end process;
  n538 <= n16 when (n17 = '1') else (15 downto 0 => 'Z');
  assert addr_width = 21 report "Unsupported generic value! addr_width must be 21." severity failure;
  assert data_width = 16 report "Unsupported generic value! data_width must be 16." severity failure;
  assert wr_buf_size = 8 report "Unsupported generic value! wr_buf_size must be 8." severity failure;
end architecture;
