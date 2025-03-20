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
  signal n626 : std_logic_vector (37 downto 0);
  signal n627 : std_logic_vector (37 downto 0) := "00000000000000000000000000000000000000";
  signal n629 : std_logic_vector (37 downto 0);
begin
  rd1_data <= n627;
  n626 <= n627 when rd1 = '0' else n629;
  process (clk)
  begin
    if rising_edge (clk) then
      n627 <= n626;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (37 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n629 <= ram(to_integer (unsigned (rd1_addr)));
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
  signal memory_inst_n489 : std_logic_vector (37 downto 0);
  signal memory_inst_c_rd1_data : std_logic_vector (37 downto 0);
  signal n493 : std_logic;
  signal n516 : std_logic;
  signal n517 : std_logic;
  signal n519 : std_logic_vector (2 downto 0);
  signal n520 : std_logic_vector (2 downto 0);
  signal n523 : std_logic;
  signal n525 : std_logic;
  signal n526 : std_logic;
  signal n528 : std_logic_vector (2 downto 0);
  signal n529 : std_logic_vector (2 downto 0);
  signal n532 : std_logic;
  signal n534 : std_logic;
  signal n535 : std_logic;
  signal n537 : std_logic_vector (31 downto 0);
  signal n538 : std_logic;
  signal n539 : std_logic;
  signal n541 : std_logic_vector (31 downto 0);
  signal n542 : std_logic_vector (31 downto 0);
  signal n543 : std_logic_vector (31 downto 0);
  signal n545 : std_logic;
  signal n548 : std_logic;
  signal n551 : std_logic_vector (2 downto 0);
  signal n552 : std_logic;
  signal n554 : std_logic;
  signal n556 : std_logic;
  signal n557 : std_logic;
  signal n559 : std_logic_vector (2 downto 0);
  signal n560 : std_logic;
  signal n562 : std_logic;
  signal n563 : std_logic;
  signal n565 : std_logic;
  signal n571 : std_logic;
  signal n573 : std_logic;
  signal n574 : std_logic;
  signal n578 : std_logic;
  signal n579 : std_logic;
  signal n581 : std_logic;
  signal n582 : std_logic;
  signal n586 : std_logic;
  signal n595 : std_logic := '1';
  signal n597 : std_logic := '1';
  signal n598 : std_logic_vector (2 downto 0);
  signal n599 : std_logic_vector (2 downto 0);
  signal n600 : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n601 : std_logic;
  signal n602 : std_logic;
  signal n603 : std_logic;
begin
  rd_data <= memory_inst_n489;
  empty <= n601;
  full <= n602;
  half_full <= n603;
  read_address <= n598; -- (signal)
  read_address_next <= n529; -- (signal)
  write_address <= n599; -- (signal)
  write_address_next <= n520; -- (signal)
  full_next <= n562; -- (signal)
  empty_next <= n565; -- (signal)
  wr_int <= n523; -- (signal)
  rd_int <= n532; -- (signal)
  half_full_next <= n548; -- (signal)
  pointer_diff <= n600; -- (isignal)
  pointer_diff_next <= n543; -- (isignal)
  memory_inst_n489 <= memory_inst_c_rd1_data; -- (signal)
  memory_inst : entity work.dp_ram_1c1r1w_3_38 port map (
    clk => clk,
    rd1_addr => read_address,
    rd1 => rd_int,
    wr2_addr => write_address,
    wr2_data => wr_data,
    wr2 => wr_int,
    rd1_data => memory_inst_c_rd1_data);
  n493 <= not res_n;
  n516 <= not n602;
  n517 <= n516 and wr;
  n519 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n520 <= write_address when n517 = '0' else n519;
  n523 <= '0' when n517 = '0' else '1';
  n525 <= not n601;
  n526 <= n525 and rd;
  n528 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n529 <= read_address when n526 = '0' else n528;
  n532 <= '0' when n526 = '0' else '1';
  n534 <= not rd;
  n535 <= n534 and wr;
  n537 <= std_logic_vector (unsigned (pointer_diff) + unsigned'("00000000000000000000000000000001"));
  n538 <= not wr;
  n539 <= n538 and rd;
  n541 <= std_logic_vector (unsigned (pointer_diff) - unsigned'("00000000000000000000000000000001"));
  n542 <= pointer_diff when n539 = '0' else n541;
  n543 <= n542 when n535 = '0' else n537;
  n545 <= '1' when signed (n543) >= signed'("00000000000000000000000000000100") else '0';
  n548 <= '0' when n545 = '0' else '1';
  n551 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n552 <= '1' when write_address = n551 else '0';
  n554 <= n601 when n557 = '0' else '1';
  n556 <= n602 when rd = '0' else '0';
  n557 <= n552 and rd;
  n559 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n560 <= '1' when read_address = n559 else '0';
  n562 <= n556 when n563 = '0' else '1';
  n563 <= n560 and wr;
  n565 <= n554 when wr = '0' else '0';
  n571 <= not n602;
  n573 <= not n578;
  n574 <= n573 or n571;
  n575: postponed assert n595 = '1' severity error; --  assert
  n578 <= '0' when wr = '0' else '1';
  n579 <= not n601;
  n581 <= not n586;
  n582 <= n581 or n579;
  n583: postponed assert n597 = '1' severity error; --  assert
  n586 <= '0' when rd = '0' else '1';
  process (clk)
  begin
    if rising_edge (clk) then
      n595 <= n574;
    end if;
  end process;
  process (clk)
  begin
    if rising_edge (clk) then
      n597 <= n582;
    end if;
  end process;
  process (clk, n493)
  begin
    if n493 = '1' then
      n598 <= "000";
    elsif rising_edge (clk) then
      n598 <= read_address_next;
    end if;
  end process;
  process (clk, n493)
  begin
    if n493 = '1' then
      n599 <= "000";
    elsif rising_edge (clk) then
      n599 <= write_address_next;
    end if;
  end process;
  process (clk, n493)
  begin
    if n493 = '1' then
      n600 <= "00000000000000000000000000000000";
    elsif rising_edge (clk) then
      n600 <= pointer_diff_next;
    end if;
  end process;
  process (clk, n493)
  begin
    if n493 = '1' then
      n601 <= '1';
    elsif rising_edge (clk) then
      n601 <= empty_next;
    end if;
  end process;
  process (clk, n493)
  begin
    if n493 = '1' then
      n602 <= '0';
    elsif rising_edge (clk) then
      n602 <= full_next;
    end if;
  end process;
  process (clk, n493)
  begin
    if n493 = '1' then
      n603 <= '0';
    elsif rising_edge (clk) then
      n603 <= half_full_next;
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
  signal fifo_inst_n454 : std_logic_vector (37 downto 0);
  signal fifo_inst_n455 : std_logic;
  signal fifo_inst_n456 : std_logic;
  signal fifo_inst_n457 : std_logic;
  signal fifo_inst_c_rd_data : std_logic_vector (37 downto 0);
  signal fifo_inst_c_empty : std_logic;
  signal fifo_inst_c_full : std_logic;
  signal fifo_inst_c_half_full : std_logic;
  signal n466 : std_logic;
  signal n467 : std_logic;
  signal n468 : std_logic;
  signal n469 : std_logic;
  signal n470 : std_logic;
  signal n472 : std_logic;
  signal n474 : std_logic;
  signal n480 : std_logic;
  signal n481 : std_logic;
begin
  rd_data <= fifo_inst_n454;
  rd_valid <= n481;
  full <= fifo_inst_n456;
  half_full <= fifo_inst_n457;
  rd <= n470; -- (signal)
  empty <= fifo_inst_n455; -- (signal)
  not_empty <= n466; -- (signal)
  fifo_inst_n454 <= fifo_inst_c_rd_data; -- (signal)
  fifo_inst_n455 <= fifo_inst_c_empty; -- (signal)
  fifo_inst_n456 <= fifo_inst_c_full; -- (signal)
  fifo_inst_n457 <= fifo_inst_c_half_full; -- (signal)
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
  n466 <= not empty;
  n467 <= rd_ack and not_empty;
  n468 <= not n481;
  n469 <= not_empty and n468;
  n470 <= n467 or n469;
  n472 <= not res_n;
  n474 <= rd or rd_ack;
  n480 <= n481 when n474 = '0' else not_empty;
  process (clk, n472)
  begin
    if n472 = '1' then
      n481 <= '0';
    elsif rising_edge (clk) then
      n481 <= n480;
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
  signal wr_fifo_rd_data : std_logic_vector (15 downto 0);
  signal wr_fifo_rd_addr : std_logic_vector (20 downto 0);
  signal wr_fifo_rd_access_mode : std_logic;
  signal rd2_pending : std_logic;
  signal rd2_pending_nxt : std_logic;
  signal rd2_addr_buffer : std_logic_vector (20 downto 0);
  signal rd2_addr_buffer_nxt : std_logic_vector (20 downto 0);
  signal rd2_access_mode_buffer : std_logic;
  signal rd2_access_mode_buffer_nxt : std_logic;
  signal sram_addr_nxt : std_logic_vector (19 downto 0);
  signal sram_ub_n_nxt : std_logic;
  signal sram_lb_n_nxt : std_logic;
  signal sram_we_n_nxt : std_logic;
  signal sram_ce_n_nxt : std_logic;
  signal sram_oe_n_nxt : std_logic;
  signal sram_drive_data : std_logic;
  signal sram_drive_data_nxt : std_logic;
  signal sram_data_out : std_logic_vector (15 downto 0);
  signal sram_data_out_nxt : std_logic_vector (15 downto 0);
  signal rd1_output_mode : std_logic_vector (1 downto 0);
  signal rd2_output_mode : std_logic_vector (1 downto 0);
  signal state : std_logic_vector (1 downto 0);
  signal state_nxt : std_logic_vector (1 downto 0);
  signal wr_fifo_block_fifo_data_out : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_access_mode_sl : std_logic;
  signal wr_fifo_block_wr_fifo_n16 : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_fifo_n17 : std_logic;
  signal n18 : std_logic_vector (16 downto 0);
  signal n19 : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_fifo_n20 : std_logic;
  signal wr_fifo_block_wr_fifo_n21 : std_logic;
  signal wr_fifo_block_wr_fifo_c_rd_data : std_logic_vector (37 downto 0);
  signal wr_fifo_block_wr_fifo_c_rd_valid : std_logic;
  signal wr_fifo_block_wr_fifo_c_full : std_logic;
  signal wr_fifo_block_wr_fifo_c_half_full : std_logic;
  signal n32 : std_logic;
  signal n33 : std_logic;
  signal n35 : std_logic_vector (20 downto 0);
  signal n36 : std_logic_vector (15 downto 0);
  signal n38 : std_logic;
  signal n39 : std_logic;
  signal n41 : std_logic;
  signal n43 : std_logic;
  signal n85 : std_logic;
  signal n86 : std_logic;
  signal n88 : std_logic;
  signal n89 : std_logic;
  signal n91 : std_logic;
  signal n92 : std_logic;
  signal n94 : std_logic_vector (19 downto 0);
  signal n96 : std_logic;
  signal n97 : std_logic_vector (20 downto 0);
  signal n98 : std_logic;
  signal n99 : std_logic;
  signal n100 : std_logic;
  signal n102 : std_logic;
  signal n103 : std_logic;
  signal n105 : std_logic;
  signal n106 : std_logic;
  signal n108 : std_logic_vector (19 downto 0);
  signal n109 : std_logic_vector (19 downto 0);
  signal n110 : std_logic_vector (19 downto 0);
  signal n112 : std_logic_vector (19 downto 0);
  signal n115 : std_logic;
  signal n118 : std_logic;
  signal n121 : std_logic;
  signal n123 : std_logic_vector (1 downto 0);
  signal n125 : std_logic;
  signal n126 : std_logic_vector (19 downto 0);
  signal n129 : std_logic;
  signal n132 : std_logic;
  signal n134 : std_logic;
  signal n136 : std_logic;
  signal n138 : std_logic;
  signal n139 : std_logic_vector (1 downto 0);
  signal n140 : std_logic;
  signal n141 : std_logic_vector (19 downto 0);
  signal n143 : std_logic;
  signal n145 : std_logic;
  signal n147 : std_logic;
  signal n149 : std_logic;
  signal n151 : std_logic;
  signal n152 : std_logic_vector (1 downto 0);
  signal n155 : std_logic;
  signal n156 : std_logic;
  signal n157 : std_logic;
  signal n158 : std_logic;
  signal n159 : std_logic_vector (19 downto 0);
  signal n161 : std_logic;
  signal n163 : std_logic;
  signal n165 : std_logic;
  signal n167 : std_logic;
  signal n169 : std_logic;
  signal n170 : std_logic_vector (1 downto 0);
  signal n173 : std_logic;
  signal n175 : std_logic;
  signal n177 : std_logic;
  signal n178 : std_logic_vector (19 downto 0);
  signal n180 : std_logic;
  signal n182 : std_logic;
  signal n183 : std_logic;
  signal n184 : std_logic;
  signal n185 : std_logic;
  signal n187 : std_logic;
  signal n188 : std_logic;
  signal n189 : std_logic;
  signal n192 : std_logic;
  signal n194 : std_logic;
  signal n197 : std_logic;
  signal n199 : std_logic;
  signal n201 : std_logic;
  signal n203 : std_logic;
  signal n204 : std_logic_vector (19 downto 0);
  signal n206 : std_logic;
  signal n207 : std_logic_vector (2 downto 0);
  signal n211 : std_logic;
  signal n215 : std_logic;
  signal n218 : std_logic;
  signal n220 : std_logic;
  signal n221 : std_logic_vector (20 downto 0);
  signal n222 : std_logic;
  signal n224 : std_logic_vector (19 downto 0);
  signal n227 : std_logic;
  signal n230 : std_logic;
  signal n234 : std_logic;
  signal n239 : std_logic;
  signal n244 : std_logic;
  signal n249 : std_logic;
  signal n253 : std_logic_vector (1 downto 0);
  signal n255 : std_logic;
  signal n258 : std_logic;
  signal n261 : std_logic;
  signal n263 : std_logic;
  signal n264 : std_logic;
  signal n265 : std_logic;
  signal n266 : std_logic;
  signal n267 : std_logic_vector (7 downto 0);
  signal n269 : std_logic;
  signal n270 : std_logic;
  signal n271 : std_logic;
  signal n272 : std_logic_vector (7 downto 0);
  signal n274 : std_logic_vector (7 downto 0);
  signal n276 : std_logic_vector (7 downto 0);
  signal n278 : std_logic_vector (7 downto 0);
  signal n279 : std_logic_vector (15 downto 0);
  signal n280 : std_logic_vector (15 downto 0);
  signal n284 : std_logic;
  signal n286 : std_logic;
  signal n287 : std_logic;
  signal n289 : std_logic;
  signal n291 : std_logic;
  signal n292 : std_logic;
  signal n293 : std_logic;
  signal n294 : std_logic;
  signal n296 : std_logic;
  signal n297 : std_logic;
  signal n298 : std_logic;
  signal n301 : std_logic_vector (1 downto 0);
  signal n303 : std_logic_vector (1 downto 0);
  signal n305 : std_logic_vector (1 downto 0);
  signal n307 : std_logic_vector (1 downto 0);
  signal n310 : std_logic;
  signal n312 : std_logic;
  signal n313 : std_logic_vector (7 downto 0);
  signal n315 : std_logic;
  signal n316 : std_logic_vector (7 downto 0);
  signal n318 : std_logic;
  signal n319 : std_logic_vector (3 downto 0);
  signal n320 : std_logic_vector (7 downto 0);
  signal n323 : std_logic_vector (7 downto 0);
  signal n324 : std_logic_vector (7 downto 0);
  signal n327 : std_logic_vector (7 downto 0);
  signal n333 : std_logic;
  signal n335 : std_logic_vector (15 downto 0);
  signal n347 : std_logic;
  signal n349 : std_logic;
  signal n350 : std_logic;
  signal n351 : std_logic;
  signal n352 : std_logic;
  signal n354 : std_logic;
  signal n356 : std_logic;
  signal n357 : std_logic;
  signal n358 : std_logic;
  signal n359 : std_logic;
  signal n361 : std_logic;
  signal n362 : std_logic;
  signal n363 : std_logic;
  signal n366 : std_logic_vector (1 downto 0);
  signal n368 : std_logic_vector (1 downto 0);
  signal n370 : std_logic_vector (1 downto 0);
  signal n372 : std_logic_vector (1 downto 0);
  signal n374 : std_logic;
  signal n375 : std_logic;
  signal n377 : std_logic;
  signal n379 : std_logic;
  signal n380 : std_logic;
  signal n381 : std_logic;
  signal n382 : std_logic;
  signal n384 : std_logic;
  signal n385 : std_logic;
  signal n386 : std_logic;
  signal n388 : std_logic_vector (1 downto 0);
  signal n390 : std_logic_vector (1 downto 0);
  signal n392 : std_logic_vector (1 downto 0);
  signal n393 : std_logic_vector (1 downto 0);
  signal n395 : std_logic;
  signal n397 : std_logic;
  signal n398 : std_logic_vector (7 downto 0);
  signal n400 : std_logic;
  signal n401 : std_logic_vector (7 downto 0);
  signal n403 : std_logic;
  signal n404 : std_logic_vector (3 downto 0);
  signal n405 : std_logic_vector (7 downto 0);
  signal n408 : std_logic_vector (7 downto 0);
  signal n409 : std_logic_vector (7 downto 0);
  signal n412 : std_logic_vector (7 downto 0);
  signal n418 : std_logic;
  signal n420 : std_logic_vector (15 downto 0);
  signal n431 : std_logic;
  signal n432 : std_logic_vector (20 downto 0);
  signal n433 : std_logic;
  signal n434 : std_logic;
  signal n435 : std_logic_vector (15 downto 0);
  signal n436 : std_logic_vector (1 downto 0);
  signal n437 : std_logic_vector (1 downto 0);
  signal n438 : std_logic_vector (1 downto 0);
  signal n439 : std_logic_vector (15 downto 0);
  signal n440 : std_logic;
  signal n441 : std_logic_vector (15 downto 0);
  signal n442 : std_logic;
  signal n443 : std_logic_vector (15 downto 0);
  signal n444 : std_logic_vector (19 downto 0);
  signal n445 : std_logic;
  signal n446 : std_logic;
  signal n447 : std_logic;
  signal n448 : std_logic;
  signal n449 : std_logic;
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
  wrap_wr_empty <= n41;
  wrap_wr_full <= wr_fifo_block_wr_fifo_n20;
  wrap_wr_half_full <= wr_fifo_block_wr_fifo_n21;
  wrap_rd1_busy <= n211;
  wrap_rd1_data <= n439;
  wrap_rd1_valid <= n440;
  wrap_rd2_busy <= n215;
  wrap_rd2_data <= n441;
  wrap_rd2_valid <= n442;
  sram_dq <= n9_c_oport;
  wrap_sram_addr <= n444;
  wrap_sram_ub_n <= n445;
  wrap_sram_lb_n <= n446;
  wrap_sram_we_n <= n447;
  wrap_sram_ce_n <= n448;
  wrap_sram_oe_n <= n449;
  n9_c_oport <= n443; -- (inout - port)
  n9_c_o <= sram_dq; -- (inout - read)
  wr_fifo_rd_valid <= wr_fifo_block_wr_fifo_n17; -- (signal)
  wr_fifo_rd_ack <= n218; -- (signal)
  wr_fifo_rd_data <= n36; -- (signal)
  wr_fifo_rd_addr <= n35; -- (signal)
  wr_fifo_rd_access_mode <= n39; -- (signal)
  rd2_pending <= n431; -- (signal)
  rd2_pending_nxt <= n220; -- (signal)
  rd2_addr_buffer <= n432; -- (signal)
  rd2_addr_buffer_nxt <= n221; -- (signal)
  rd2_access_mode_buffer <= n433; -- (signal)
  rd2_access_mode_buffer_nxt <= n222; -- (signal)
  sram_addr_nxt <= n224; -- (signal)
  sram_ub_n_nxt <= n227; -- (signal)
  sram_lb_n_nxt <= n230; -- (signal)
  sram_we_n_nxt <= n234; -- (signal)
  sram_ce_n_nxt <= n239; -- (signal)
  sram_oe_n_nxt <= n244; -- (signal)
  sram_drive_data <= n434; -- (signal)
  sram_drive_data_nxt <= n249; -- (signal)
  sram_data_out <= n435; -- (signal)
  sram_data_out_nxt <= n280; -- (signal)
  rd1_output_mode <= n436; -- (signal)
  rd2_output_mode <= n437; -- (signal)
  state <= n438; -- (signal)
  state_nxt <= n253; -- (signal)
  wr_fifo_block_fifo_data_out <= wr_fifo_block_wr_fifo_n16; -- (signal)
  wr_fifo_block_wr_access_mode_sl <= n33; -- (signal)
  wr_fifo_block_wr_fifo_n16 <= wr_fifo_block_wr_fifo_c_rd_data; -- (signal)
  wr_fifo_block_wr_fifo_n17 <= wr_fifo_block_wr_fifo_c_rd_valid; -- (signal)
  n18 <= wr_fifo_block_wr_access_mode_sl & wrap_wr_data;
  n19 <= n18 & wrap_wr_addr;
  wr_fifo_block_wr_fifo_n20 <= wr_fifo_block_wr_fifo_c_full; -- (signal)
  wr_fifo_block_wr_fifo_n21 <= wr_fifo_block_wr_fifo_c_half_full; -- (signal)
  wr_fifo_block_wr_fifo : entity work.fifo_1c1r1w_fwft_8_38 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    rd_ack => wr_fifo_rd_ack,
    wr_data => n19,
    wr => wrap_wr,
    rd_data => wr_fifo_block_wr_fifo_c_rd_data,
    rd_valid => wr_fifo_block_wr_fifo_c_rd_valid,
    full => wr_fifo_block_wr_fifo_c_full,
    half_full => wr_fifo_block_wr_fifo_c_half_full);
  n32 <= '1' when wrap_wr_access_mode = '1' else '0';
  n33 <= '0' when n32 = '0' else '1';
  n35 <= wr_fifo_block_fifo_data_out (20 downto 0);
  n36 <= wr_fifo_block_fifo_data_out (36 downto 21);
  n38 <= wr_fifo_block_fifo_data_out (37);
  n39 <= '0' when n38 = '0' else '1';
  n41 <= not wr_fifo_rd_valid;
  n43 <= not wrap_res_n;
  n85 <= wrap_rd1_addr (0);
  n86 <= not n85;
  n88 <= '1' when wrap_rd1_access_mode /= '1' else '0';
  n89 <= n86 or n88;
  n91 <= not n255;
  n92 <= n91 or n89;
  n93: postponed assert n92 = '1' severity error; --  assert
  n94 <= wrap_rd1_addr (20 downto 1);
  n96 <= rd2_pending when wrap_rd2 = '0' else '1';
  n97 <= rd2_addr_buffer when n157 = '0' else wrap_rd2_addr;
  n98 <= rd2_access_mode_buffer when n158 = '0' else wrap_rd2_access_mode;
  n99 <= wrap_rd2_addr (0);
  n100 <= not n99;
  n102 <= '1' when wrap_rd2_access_mode /= '1' else '0';
  n103 <= n100 or n102;
  n105 <= not n258;
  n106 <= n105 or n103;
  n107: postponed assert n106 = '1' severity error; --  assert
  n108 <= wrap_rd2_addr (20 downto 1);
  n109 <= rd2_addr_buffer (20 downto 1);
  n110 <= wr_fifo_rd_addr (20 downto 1);
  n112 <= "00000000000000000000" when wr_fifo_rd_valid = '0' else n110;
  n115 <= '1' when wr_fifo_rd_valid = '0' else '0';
  n118 <= '1' when wr_fifo_rd_valid = '0' else '0';
  n121 <= '0' when wr_fifo_rd_valid = '0' else '1';
  n123 <= state when wr_fifo_rd_valid = '0' else "01";
  n125 <= rd2_pending when rd2_pending = '0' else '0';
  n126 <= n112 when rd2_pending = '0' else n109;
  n129 <= '1' when rd2_pending = '0' else '0';
  n132 <= '1' when rd2_pending = '0' else '0';
  n134 <= n115 when rd2_pending = '0' else '0';
  n136 <= n118 when rd2_pending = '0' else '0';
  n138 <= n121 when rd2_pending = '0' else '0';
  n139 <= n123 when rd2_pending = '0' else state;
  n140 <= n125 when wrap_rd2 = '0' else rd2_pending;
  n141 <= n126 when wrap_rd2 = '0' else n108;
  n143 <= n129 when wrap_rd2 = '0' else '0';
  n145 <= n132 when wrap_rd2 = '0' else '0';
  n147 <= n134 when wrap_rd2 = '0' else '0';
  n149 <= n136 when wrap_rd2 = '0' else '0';
  n151 <= n138 when wrap_rd2 = '0' else '0';
  n152 <= n139 when wrap_rd2 = '0' else state;
  n155 <= '0' when wrap_rd2 = '0' else '1';
  n156 <= n140 when wrap_rd1 = '0' else n96;
  n157 <= wrap_rd2 and wrap_rd1;
  n158 <= wrap_rd2 and wrap_rd1;
  n159 <= n141 when wrap_rd1 = '0' else n94;
  n161 <= n143 when wrap_rd1 = '0' else '0';
  n163 <= n145 when wrap_rd1 = '0' else '0';
  n165 <= n147 when wrap_rd1 = '0' else '0';
  n167 <= n149 when wrap_rd1 = '0' else '0';
  n169 <= n151 when wrap_rd1 = '0' else '0';
  n170 <= n152 when wrap_rd1 = '0' else state;
  n173 <= '0' when wrap_rd1 = '0' else '1';
  n175 <= n155 when wrap_rd1 = '0' else '0';
  n177 <= '1' when state = "00" else '0';
  n178 <= wr_fifo_rd_addr (20 downto 1);
  n180 <= '1' when wr_fifo_rd_access_mode = '1' else '0';
  n182 <= '1' when wr_fifo_rd_access_mode = '0' else '0';
  n183 <= wr_fifo_rd_addr (0);
  n184 <= not n183;
  n185 <= n184 and n182;
  n187 <= '1' when wr_fifo_rd_access_mode = '0' else '0';
  n188 <= wr_fifo_rd_addr (0);
  n189 <= n188 and n187;
  n192 <= '1' when n189 = '0' else '0';
  n194 <= n192 when n185 = '0' else '1';
  n197 <= '1' when n185 = '0' else '0';
  n199 <= n194 when n180 = '0' else '0';
  n201 <= n197 when n180 = '0' else '0';
  n203 <= '1' when state = "01" else '0';
  n204 <= wr_fifo_rd_addr (20 downto 1);
  n206 <= '1' when state = "10" else '0';
  n207 <= n206 & n203 & n177;
  with n207 select n211 <=
    '1' when "100",
    '1' when "010",
    '0' when "001",
    '0' when others;
  with n207 select n215 <=
    '1' when "100",
    '1' when "010",
    rd2_pending when "001",
    rd2_pending when others;
  with n207 select n218 <=
    '1' when "100",
    '0' when "010",
    '0' when "001",
    '0' when others;
  with n207 select n220 <=
    rd2_pending when "100",
    rd2_pending when "010",
    n156 when "001",
    rd2_pending when others;
  with n207 select n221 <=
    rd2_addr_buffer when "100",
    rd2_addr_buffer when "010",
    n97 when "001",
    rd2_addr_buffer when others;
  with n207 select n222 <=
    rd2_access_mode_buffer when "100",
    rd2_access_mode_buffer when "010",
    n98 when "001",
    rd2_access_mode_buffer when others;
  with n207 select n224 <=
    n204 when "100",
    n178 when "010",
    n159 when "001",
    "00000000000000000000" when others;
  with n207 select n227 <=
    '1' when "100",
    n199 when "010",
    n161 when "001",
    '1' when others;
  with n207 select n230 <=
    '1' when "100",
    n201 when "010",
    n163 when "001",
    '1' when others;
  with n207 select n234 <=
    '1' when "100",
    '0' when "010",
    '1' when "001",
    '1' when others;
  with n207 select n239 <=
    '0' when "100",
    '0' when "010",
    n165 when "001",
    '1' when others;
  with n207 select n244 <=
    '0' when "100",
    '0' when "010",
    n167 when "001",
    '1' when others;
  with n207 select n249 <=
    '1' when "100",
    '1' when "010",
    n169 when "001",
    '0' when others;
  with n207 select n253 <=
    "00" when "100",
    "10" when "010",
    n170 when "001",
    state when others;
  with n207 select n255 <=
    '0' when "100",
    '0' when "010",
    n173 when "001",
    '0' when others;
  with n207 select n258 <=
    '0' when "100",
    '0' when "010",
    n175 when "001",
    '0' when others;
  n261 <= '1' when wr_fifo_rd_access_mode = '1' else '0';
  n263 <= '1' when wr_fifo_rd_access_mode = '0' else '0';
  n264 <= wr_fifo_rd_addr (0);
  n265 <= not n264;
  n266 <= n265 and n263;
  n267 <= wr_fifo_rd_data (7 downto 0);
  n269 <= '1' when wr_fifo_rd_access_mode = '0' else '0';
  n270 <= wr_fifo_rd_addr (0);
  n271 <= n270 and n269;
  n272 <= wr_fifo_rd_data (7 downto 0);
  n274 <= "00000000" when n271 = '0' else n272;
  n276 <= "00000000" when n266 = '0' else n267;
  n278 <= n274 when n266 = '0' else "00000000";
  n279 <= n278 & n276;
  n280 <= n279 when n261 = '0' else wr_fifo_rd_data;
  n284 <= not wrap_res_n;
  n286 <= not n211;
  n287 <= wrap_rd1 and n286;
  n289 <= '1' when wrap_rd1_access_mode = '1' else '0';
  n291 <= '1' when wrap_rd1_access_mode = '0' else '0';
  n292 <= wrap_rd1_addr (0);
  n293 <= not n292;
  n294 <= n293 and n291;
  n296 <= '1' when wrap_rd1_access_mode = '0' else '0';
  n297 <= wrap_rd1_addr (0);
  n298 <= n297 and n296;
  n301 <= "00" when n298 = '0' else "11";
  n303 <= n301 when n294 = '0' else "10";
  n305 <= n303 when n289 = '0' else "01";
  n307 <= "00" when n287 = '0' else n305;
  n310 <= '1' when rd1_output_mode = "00" else '0';
  n312 <= '1' when rd1_output_mode = "01" else '0';
  n313 <= n9_c_o (7 downto 0);
  n315 <= '1' when rd1_output_mode = "10" else '0';
  n316 <= n9_c_o (15 downto 8);
  n318 <= '1' when rd1_output_mode = "11" else '0';
  n319 <= n318 & n315 & n312 & n310;
  n320 <= n9_c_o (7 downto 0);
  with n319 select n323 <=
    n316 when "1000",
    n313 when "0100",
    n320 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  n324 <= n9_c_o (15 downto 8);
  with n319 select n327 <=
    "00000000" when "1000",
    "00000000" when "0100",
    n324 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  with n319 select n333 <=
    '1' when "1000",
    '1' when "0100",
    '1' when "0010",
    '0' when "0001",
    'X' when others;
  n335 <= n327 & n323;
  n347 <= not wrap_res_n;
  n349 <= not n215;
  n350 <= wrap_rd2 and n349;
  n351 <= not wrap_rd1;
  n352 <= n350 and n351;
  n354 <= '1' when wrap_rd2_access_mode = '1' else '0';
  n356 <= '1' when wrap_rd2_access_mode = '0' else '0';
  n357 <= wrap_rd2_addr (0);
  n358 <= not n357;
  n359 <= n358 and n356;
  n361 <= '1' when wrap_rd2_access_mode = '0' else '0';
  n362 <= wrap_rd2_addr (0);
  n363 <= n362 and n361;
  n366 <= "00" when n363 = '0' else "11";
  n368 <= n366 when n359 = '0' else "10";
  n370 <= n368 when n354 = '0' else "01";
  n372 <= "00" when n352 = '0' else n370;
  n374 <= not wrap_rd1;
  n375 <= rd2_pending and n374;
  n377 <= '1' when rd2_access_mode_buffer = '1' else '0';
  n379 <= '1' when rd2_access_mode_buffer = '0' else '0';
  n380 <= rd2_addr_buffer (0);
  n381 <= not n380;
  n382 <= n381 and n379;
  n384 <= '1' when rd2_access_mode_buffer = '0' else '0';
  n385 <= rd2_addr_buffer (0);
  n386 <= n385 and n384;
  n388 <= n372 when n386 = '0' else "11";
  n390 <= n388 when n382 = '0' else "10";
  n392 <= n390 when n377 = '0' else "01";
  n393 <= n372 when n375 = '0' else n392;
  n395 <= '1' when rd2_output_mode = "00" else '0';
  n397 <= '1' when rd2_output_mode = "01" else '0';
  n398 <= n9_c_o (7 downto 0);
  n400 <= '1' when rd2_output_mode = "10" else '0';
  n401 <= n9_c_o (15 downto 8);
  n403 <= '1' when rd2_output_mode = "11" else '0';
  n404 <= n403 & n400 & n397 & n395;
  n405 <= n9_c_o (7 downto 0);
  with n404 select n408 <=
    n401 when "1000",
    n398 when "0100",
    n405 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  n409 <= n9_c_o (15 downto 8);
  with n404 select n412 <=
    "00000000" when "1000",
    "00000000" when "0100",
    n409 when "0010",
    "00000000" when "0001",
    "XXXXXXXX" when others;
  with n404 select n418 <=
    '1' when "1000",
    '1' when "0100",
    '1' when "0010",
    '0' when "0001",
    'X' when others;
  n420 <= n412 & n408;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n431 <= '0';
    elsif rising_edge (wrap_clk) then
      n431 <= rd2_pending_nxt;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n432 <= "000000000000000000000";
    elsif rising_edge (wrap_clk) then
      n432 <= rd2_addr_buffer_nxt;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n433 <= '0';
    elsif rising_edge (wrap_clk) then
      n433 <= rd2_access_mode_buffer_nxt;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n434 <= '0';
    elsif rising_edge (wrap_clk) then
      n434 <= sram_drive_data_nxt;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n435 <= "0000000000000000";
    elsif rising_edge (wrap_clk) then
      n435 <= sram_data_out_nxt;
    end if;
  end process;
  process (wrap_clk, n284)
  begin
    if n284 = '1' then
      n436 <= "00";
    elsif rising_edge (wrap_clk) then
      n436 <= n307;
    end if;
  end process;
  process (wrap_clk, n347)
  begin
    if n347 = '1' then
      n437 <= "00";
    elsif rising_edge (wrap_clk) then
      n437 <= n393;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n438 <= "00";
    elsif rising_edge (wrap_clk) then
      n438 <= state_nxt;
    end if;
  end process;
  process (wrap_clk, n284)
  begin
    if n284 = '1' then
      n439 <= "0000000000000000";
    elsif rising_edge (wrap_clk) then
      n439 <= n335;
    end if;
  end process;
  process (wrap_clk, n284)
  begin
    if n284 = '1' then
      n440 <= '0';
    elsif rising_edge (wrap_clk) then
      n440 <= n333;
    end if;
  end process;
  process (wrap_clk, n347)
  begin
    if n347 = '1' then
      n441 <= "0000000000000000";
    elsif rising_edge (wrap_clk) then
      n441 <= n420;
    end if;
  end process;
  process (wrap_clk, n347)
  begin
    if n347 = '1' then
      n442 <= '0';
    elsif rising_edge (wrap_clk) then
      n442 <= n418;
    end if;
  end process;
  n443 <= sram_data_out when (sram_drive_data = '1') else (15 downto 0 => 'Z');
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n444 <= "00000000000000000000";
    elsif rising_edge (wrap_clk) then
      n444 <= sram_addr_nxt;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n445 <= '1';
    elsif rising_edge (wrap_clk) then
      n445 <= sram_ub_n_nxt;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n446 <= '1';
    elsif rising_edge (wrap_clk) then
      n446 <= sram_lb_n_nxt;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n447 <= '1';
    elsif rising_edge (wrap_clk) then
      n447 <= sram_we_n_nxt;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n448 <= '1';
    elsif rising_edge (wrap_clk) then
      n448 <= sram_ce_n_nxt;
    end if;
  end process;
  process (wrap_clk, n43)
  begin
    if n43 = '1' then
      n449 <= '1';
    elsif rising_edge (wrap_clk) then
      n449 <= sram_oe_n_nxt;
    end if;
  end process;
  assert addr_width = 21 report "Unsupported generic value! addr_width must be 21." severity failure;
  assert data_width = 16 report "Unsupported generic value! data_width must be 16." severity failure;
  assert wr_buf_size = 8 report "Unsupported generic value! wr_buf_size must be 8." severity failure;
end architecture;
