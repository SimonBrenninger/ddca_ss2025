library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.snes_ctrl_pkg.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
architecture ref of snes_ctrl is
  signal wrap_clk: std_logic;
  signal wrap_res_n: std_logic;
  signal wrap_snes_data: std_logic;
  signal wrap_snes_clk: std_logic;
  signal wrap_snes_latch: std_logic;
  signal wrap_ctrl_state_btn_up: std_logic;
  signal wrap_ctrl_state_btn_down: std_logic;
  signal wrap_ctrl_state_btn_left: std_logic;
  signal wrap_ctrl_state_btn_right: std_logic;
  signal wrap_ctrl_state_btn_a: std_logic;
  signal wrap_ctrl_state_btn_b: std_logic;
  signal wrap_ctrl_state_btn_x: std_logic;
  signal wrap_ctrl_state_btn_y: std_logic;
  signal wrap_ctrl_state_btn_l: std_logic;
  signal wrap_ctrl_state_btn_r: std_logic;
  signal wrap_ctrl_state_btn_start: std_logic;
  signal wrap_ctrl_state_btn_select: std_logic;
  signal n3 : std_logic;
  signal n4 : std_logic;
  signal n5 : std_logic;
  signal n6 : std_logic;
  signal n7 : std_logic;
  signal n8 : std_logic;
  signal n9 : std_logic;
  signal n10 : std_logic;
  signal n11 : std_logic;
  signal n12 : std_logic;
  signal n13 : std_logic;
  signal n14 : std_logic;
  signal state : std_logic_vector (2 downto 0);
  signal state_nxt : std_logic_vector (2 downto 0);
  signal clk_cnt : std_logic_vector (15 downto 0);
  signal clk_cnt_nxt : std_logic_vector (15 downto 0);
  signal bit_cnt : std_logic_vector (3 downto 0);
  signal bit_cnt_nxt : std_logic_vector (3 downto 0);
  signal shift_reg : std_logic_vector (15 downto 0);
  signal shift_reg_nxt : std_logic_vector (15 downto 0);
  signal btn_nxt : std_logic_vector (11 downto 0);
  signal n16 : std_logic;
  signal n35 : std_logic;
  signal n36 : std_logic;
  signal n37 : std_logic;
  signal n38 : std_logic;
  signal n39 : std_logic;
  signal n40 : std_logic;
  signal n41 : std_logic;
  signal n42 : std_logic;
  signal n43 : std_logic;
  signal n44 : std_logic;
  signal n45 : std_logic;
  signal n46 : std_logic;
  signal n48 : std_logic;
  signal n50 : std_logic_vector (15 downto 0);
  signal n52 : std_logic_vector (2 downto 0);
  signal n54 : std_logic_vector (15 downto 0);
  signal n56 : std_logic;
  signal n58 : std_logic;
  signal n60 : std_logic_vector (15 downto 0);
  signal n62 : std_logic_vector (2 downto 0);
  signal n64 : std_logic_vector (15 downto 0);
  signal n66 : std_logic;
  signal n68 : std_logic;
  signal n70 : std_logic_vector (15 downto 0);
  signal n72 : std_logic_vector (2 downto 0);
  signal n74 : std_logic_vector (15 downto 0);
  signal n76 : std_logic;
  signal n78 : std_logic;
  signal n80 : std_logic_vector (15 downto 0);
  signal n82 : std_logic_vector (2 downto 0);
  signal n84 : std_logic_vector (15 downto 0);
  signal n86 : std_logic;
  signal n87 : std_logic_vector (14 downto 0);
  signal n88 : std_logic;
  signal n89 : std_logic_vector (15 downto 0);
  signal n91 : std_logic;
  signal n93 : std_logic;
  signal n95 : std_logic;
  signal n97 : std_logic_vector (3 downto 0);
  signal n100 : std_logic_vector (2 downto 0);
  signal n102 : std_logic_vector (3 downto 0);
  signal n104 : std_logic_vector (15 downto 0);
  signal n105 : std_logic_vector (2 downto 0);
  signal n107 : std_logic_vector (15 downto 0);
  signal n108 : std_logic_vector (3 downto 0);
  signal n110 : std_logic;
  signal n111 : std_logic_vector (5 downto 0);
  signal n117 : std_logic;
  signal n122 : std_logic;
  signal n126 : std_logic_vector (2 downto 0);
  signal n128 : std_logic_vector (15 downto 0);
  signal n130 : std_logic_vector (3 downto 0);
  signal n132 : std_logic_vector (15 downto 0);
  signal n133 : std_logic;
  signal n135 : std_logic;
  signal n136 : std_logic;
  signal n138 : std_logic;
  signal n139 : std_logic;
  signal n141 : std_logic;
  signal n142 : std_logic;
  signal n144 : std_logic;
  signal n145 : std_logic;
  signal n147 : std_logic;
  signal n148 : std_logic;
  signal n150 : std_logic;
  signal n151 : std_logic;
  signal n153 : std_logic;
  signal n154 : std_logic;
  signal n156 : std_logic;
  signal n157 : std_logic;
  signal n159 : std_logic;
  signal n160 : std_logic;
  signal n162 : std_logic;
  signal n163 : std_logic;
  signal n165 : std_logic;
  signal n166 : std_logic;
  signal n168 : std_logic;
  signal n181 : std_logic_vector (2 downto 0);
  signal n182 : std_logic_vector (15 downto 0);
  signal n183 : std_logic_vector (3 downto 0);
  signal n184 : std_logic_vector (15 downto 0);
  signal n185 : std_logic_vector (11 downto 0);
  signal n186 : std_logic_vector (11 downto 0);
begin
  wrap_clk <= clk;
  wrap_res_n <= res_n;
  wrap_snes_data <= snes_data;
  snes_clk <= wrap_snes_clk;
  snes_latch <= wrap_snes_latch;
  ctrl_state.btn_up <= wrap_ctrl_state_btn_up;
  ctrl_state.btn_down <= wrap_ctrl_state_btn_down;
  ctrl_state.btn_left <= wrap_ctrl_state_btn_left;
  ctrl_state.btn_right <= wrap_ctrl_state_btn_right;
  ctrl_state.btn_a <= wrap_ctrl_state_btn_a;
  ctrl_state.btn_b <= wrap_ctrl_state_btn_b;
  ctrl_state.btn_x <= wrap_ctrl_state_btn_x;
  ctrl_state.btn_y <= wrap_ctrl_state_btn_y;
  ctrl_state.btn_l <= wrap_ctrl_state_btn_l;
  ctrl_state.btn_r <= wrap_ctrl_state_btn_r;
  ctrl_state.btn_start <= wrap_ctrl_state_btn_start;
  ctrl_state.btn_select <= wrap_ctrl_state_btn_select;
  wrap_snes_clk <= n117;
  wrap_snes_latch <= n122;
  wrap_ctrl_state_btn_up <= n3;
  wrap_ctrl_state_btn_down <= n4;
  wrap_ctrl_state_btn_left <= n5;
  wrap_ctrl_state_btn_right <= n6;
  wrap_ctrl_state_btn_a <= n7;
  wrap_ctrl_state_btn_b <= n8;
  wrap_ctrl_state_btn_x <= n9;
  wrap_ctrl_state_btn_y <= n10;
  wrap_ctrl_state_btn_l <= n11;
  wrap_ctrl_state_btn_r <= n12;
  wrap_ctrl_state_btn_start <= n13;
  wrap_ctrl_state_btn_select <= n14;
  n3 <= n186 (0);
  n4 <= n186 (1);
  n5 <= n186 (2);
  n6 <= n186 (3);
  n7 <= n186 (4);
  n8 <= n186 (5);
  n9 <= n186 (6);
  n10 <= n186 (7);
  n11 <= n186 (8);
  n12 <= n186 (9);
  n13 <= n186 (10);
  n14 <= n186 (11);
  state <= n181; -- (signal)
  state_nxt <= n126; -- (signal)
  clk_cnt <= n182; -- (signal)
  clk_cnt_nxt <= n128; -- (signal)
  bit_cnt <= n183; -- (signal)
  bit_cnt_nxt <= n130; -- (signal)
  shift_reg <= n184; -- (signal)
  shift_reg_nxt <= n132; -- (signal)
  btn_nxt <= n185; -- (signal)
  n16 <= not wrap_res_n;
  n35 <= shift_reg (15);
  n36 <= shift_reg (14);
  n37 <= shift_reg (13);
  n38 <= shift_reg (12);
  n39 <= shift_reg (11);
  n40 <= shift_reg (10);
  n41 <= shift_reg (9);
  n42 <= shift_reg (8);
  n43 <= shift_reg (7);
  n44 <= shift_reg (6);
  n45 <= shift_reg (5);
  n46 <= shift_reg (4);
  n48 <= '1' when clk_cnt = "0000001111101000" else '0';
  n50 <= std_logic_vector (unsigned (clk_cnt) + unsigned'("0000000000000001"));
  n52 <= state when n48 = '0' else "001";
  n54 <= n50 when n48 = '0' else "0000000000000000";
  n56 <= '1' when state = "000" else '0';
  n58 <= '1' when clk_cnt = "0000000011111010" else '0';
  n60 <= std_logic_vector (unsigned (clk_cnt) + unsigned'("0000000000000001"));
  n62 <= state when n58 = '0' else "010";
  n64 <= n60 when n58 = '0' else "0000000000000000";
  n66 <= '1' when state = "001" else '0';
  n68 <= '1' when clk_cnt = "0000000011111010" else '0';
  n70 <= std_logic_vector (unsigned (clk_cnt) + unsigned'("0000000000000001"));
  n72 <= state when n68 = '0' else "101";
  n74 <= n70 when n68 = '0' else "0000000000000000";
  n76 <= '1' when state = "010" else '0';
  n78 <= '1' when clk_cnt = "0000000011111001" else '0';
  n80 <= std_logic_vector (unsigned (clk_cnt) + unsigned'("0000000000000001"));
  n82 <= state when n78 = '0' else "100";
  n84 <= n80 when n78 = '0' else "0000000000000000";
  n86 <= '1' when state = "101" else '0';
  n87 <= shift_reg (14 downto 0);
  n88 <= not wrap_snes_data;
  n89 <= n87 & n88;
  n91 <= '1' when state = "100" else '0';
  n93 <= '1' when clk_cnt = "0000000011111010" else '0';
  n95 <= '1' when bit_cnt = "1111" else '0';
  n97 <= std_logic_vector (unsigned (bit_cnt) + unsigned'("0001"));
  n100 <= "101" when n95 = '0' else "000";
  n102 <= n97 when n95 = '0' else "0000";
  n104 <= std_logic_vector (unsigned (clk_cnt) + unsigned'("0000000000000001"));
  n105 <= state when n93 = '0' else n100;
  n107 <= n104 when n93 = '0' else "0000000000000000";
  n108 <= bit_cnt when n93 = '0' else n102;
  n110 <= '1' when state = "011" else '0';
  n111 <= n110 & n91 & n86 & n76 & n66 & n56;
  with n111 select n117 <=
    '1' when "100000",
    '0' when "010000",
    '0' when "001000",
    '1' when "000100",
    '1' when "000010",
    '1' when "000001",
    'X' when others;
  with n111 select n122 <=
    '0' when "100000",
    '0' when "010000",
    '0' when "001000",
    '0' when "000100",
    '1' when "000010",
    '0' when "000001",
    'X' when others;
  with n111 select n126 <=
    n105 when "100000",
    "011" when "010000",
    n82 when "001000",
    n72 when "000100",
    n62 when "000010",
    n52 when "000001",
    "XXX" when others;
  with n111 select n128 <=
    n107 when "100000",
    clk_cnt when "010000",
    n84 when "001000",
    n74 when "000100",
    n64 when "000010",
    n54 when "000001",
    (15 downto 0 => 'X') when others;
  with n111 select n130 <=
    n108 when "100000",
    bit_cnt when "010000",
    bit_cnt when "001000",
    bit_cnt when "000100",
    bit_cnt when "000010",
    bit_cnt when "000001",
    "XXXX" when others;
  with n111 select n132 <=
    shift_reg when "100000",
    n89 when "010000",
    shift_reg when "001000",
    shift_reg when "000100",
    shift_reg when "000010",
    shift_reg when "000001",
    (15 downto 0 => 'X') when others;
  n133 <= n186 (0);
  with n111 select n135 <=
    n133 when "100000",
    n133 when "010000",
    n133 when "001000",
    n133 when "000100",
    n133 when "000010",
    n39 when "000001",
    'X' when others;
  n136 <= n186 (1);
  with n111 select n138 <=
    n136 when "100000",
    n136 when "010000",
    n136 when "001000",
    n136 when "000100",
    n136 when "000010",
    n40 when "000001",
    'X' when others;
  n139 <= n186 (2);
  with n111 select n141 <=
    n139 when "100000",
    n139 when "010000",
    n139 when "001000",
    n139 when "000100",
    n139 when "000010",
    n41 when "000001",
    'X' when others;
  n142 <= n186 (3);
  with n111 select n144 <=
    n142 when "100000",
    n142 when "010000",
    n142 when "001000",
    n142 when "000100",
    n142 when "000010",
    n42 when "000001",
    'X' when others;
  n145 <= n186 (4);
  with n111 select n147 <=
    n145 when "100000",
    n145 when "010000",
    n145 when "001000",
    n145 when "000100",
    n145 when "000010",
    n43 when "000001",
    'X' when others;
  n148 <= n186 (5);
  with n111 select n150 <=
    n148 when "100000",
    n148 when "010000",
    n148 when "001000",
    n148 when "000100",
    n148 when "000010",
    n35 when "000001",
    'X' when others;
  n151 <= n186 (6);
  with n111 select n153 <=
    n151 when "100000",
    n151 when "010000",
    n151 when "001000",
    n151 when "000100",
    n151 when "000010",
    n44 when "000001",
    'X' when others;
  n154 <= n186 (7);
  with n111 select n156 <=
    n154 when "100000",
    n154 when "010000",
    n154 when "001000",
    n154 when "000100",
    n154 when "000010",
    n36 when "000001",
    'X' when others;
  n157 <= n186 (8);
  with n111 select n159 <=
    n157 when "100000",
    n157 when "010000",
    n157 when "001000",
    n157 when "000100",
    n157 when "000010",
    n45 when "000001",
    'X' when others;
  n160 <= n186 (9);
  with n111 select n162 <=
    n160 when "100000",
    n160 when "010000",
    n160 when "001000",
    n160 when "000100",
    n160 when "000010",
    n46 when "000001",
    'X' when others;
  n163 <= n186 (10);
  with n111 select n165 <=
    n163 when "100000",
    n163 when "010000",
    n163 when "001000",
    n163 when "000100",
    n163 when "000010",
    n38 when "000001",
    'X' when others;
  n166 <= n186 (11);
  with n111 select n168 <=
    n166 when "100000",
    n166 when "010000",
    n166 when "001000",
    n166 when "000100",
    n166 when "000010",
    n37 when "000001",
    'X' when others;
  process (wrap_clk, n16)
  begin
    if n16 = '1' then
      n181 <= "000";
    elsif rising_edge (wrap_clk) then
      n181 <= state_nxt;
    end if;
  end process;
  process (wrap_clk, n16)
  begin
    if n16 = '1' then
      n182 <= "0000000000000000";
    elsif rising_edge (wrap_clk) then
      n182 <= clk_cnt_nxt;
    end if;
  end process;
  process (wrap_clk, n16)
  begin
    if n16 = '1' then
      n183 <= "0000";
    elsif rising_edge (wrap_clk) then
      n183 <= bit_cnt_nxt;
    end if;
  end process;
  process (wrap_clk, n16)
  begin
    if n16 = '1' then
      n184 <= "0000000000000000";
    elsif rising_edge (wrap_clk) then
      n184 <= shift_reg_nxt;
    end if;
  end process;
  n185 <= n168 & n165 & n162 & n159 & n156 & n153 & n150 & n147 & n144 & n141 & n138 & n135;
  process (wrap_clk, n16)
  begin
    if n16 = '1' then
      n186 <= "000000000000";
    elsif rising_edge (wrap_clk) then
      n186 <= btn_nxt;
    end if;
  end process;
  assert clk_freq = 50000000 report "Unsupported generic value! clk_freq must be 50000000." severity failure;
  assert clk_out_freq = 100000 report "Unsupported generic value! clk_out_freq must be 100000." severity failure;
  assert refresh_timeout = 1000 report "Unsupported generic value! refresh_timeout must be 1000." severity failure;
end architecture;
