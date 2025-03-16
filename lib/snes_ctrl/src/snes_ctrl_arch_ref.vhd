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
  signal s : std_logic_vector (50 downto 0);
  signal s_nxt : std_logic_vector (50 downto 0);
  signal n16 : std_logic;
  signal n23 : std_logic_vector (11 downto 0);
  signal n24 : std_logic_vector (2 downto 0);
  signal n32 : std_logic;
  signal n36 : std_logic;
  signal n39 : std_logic;
  signal n41 : std_logic;
  signal n43 : std_logic;
  signal n45 : std_logic;
  signal n47 : std_logic;
  signal n49 : std_logic;
  signal n51 : std_logic;
  signal n52 : std_logic;
  signal n53 : std_logic;
  signal n55 : std_logic;
  signal n56 : std_logic_vector (11 downto 0);
  signal n60 : std_logic_vector (15 downto 0);
  signal n62 : std_logic;
  signal n65 : std_logic_vector (15 downto 0);
  signal n67 : std_logic_vector (15 downto 0);
  signal n68 : std_logic_vector (18 downto 0);
  signal n69 : std_logic_vector (2 downto 0);
  signal n70 : std_logic_vector (2 downto 0);
  signal n71 : std_logic_vector (2 downto 0);
  signal n72 : std_logic_vector (15 downto 0);
  signal n73 : std_logic_vector (15 downto 0);
  signal n75 : std_logic;
  signal n79 : std_logic_vector (15 downto 0);
  signal n81 : std_logic;
  signal n84 : std_logic_vector (15 downto 0);
  signal n86 : std_logic_vector (15 downto 0);
  signal n87 : std_logic_vector (18 downto 0);
  signal n88 : std_logic_vector (2 downto 0);
  signal n89 : std_logic_vector (2 downto 0);
  signal n90 : std_logic_vector (2 downto 0);
  signal n91 : std_logic_vector (15 downto 0);
  signal n92 : std_logic_vector (15 downto 0);
  signal n94 : std_logic;
  signal n98 : std_logic_vector (15 downto 0);
  signal n100 : std_logic;
  signal n103 : std_logic_vector (15 downto 0);
  signal n105 : std_logic_vector (15 downto 0);
  signal n106 : std_logic_vector (18 downto 0);
  signal n107 : std_logic_vector (2 downto 0);
  signal n108 : std_logic_vector (2 downto 0);
  signal n109 : std_logic_vector (2 downto 0);
  signal n110 : std_logic_vector (15 downto 0);
  signal n111 : std_logic_vector (15 downto 0);
  signal n113 : std_logic;
  signal n117 : std_logic_vector (15 downto 0);
  signal n119 : std_logic;
  signal n122 : std_logic_vector (15 downto 0);
  signal n124 : std_logic_vector (15 downto 0);
  signal n125 : std_logic_vector (18 downto 0);
  signal n126 : std_logic_vector (2 downto 0);
  signal n127 : std_logic_vector (2 downto 0);
  signal n128 : std_logic_vector (2 downto 0);
  signal n129 : std_logic_vector (15 downto 0);
  signal n130 : std_logic_vector (15 downto 0);
  signal n132 : std_logic;
  signal n134 : std_logic;
  signal n135 : std_logic_vector (14 downto 0);
  signal n136 : std_logic_vector (15 downto 0);
  signal n138 : std_logic;
  signal n139 : std_logic_vector (15 downto 0);
  signal n141 : std_logic;
  signal n143 : std_logic_vector (3 downto 0);
  signal n145 : std_logic;
  signal n148 : std_logic_vector (3 downto 0);
  signal n150 : std_logic_vector (3 downto 0);
  signal n152 : std_logic_vector (2 downto 0);
  signal n153 : std_logic_vector (3 downto 0);
  signal n154 : std_logic_vector (15 downto 0);
  signal n156 : std_logic_vector (15 downto 0);
  signal n157 : std_logic_vector (22 downto 0);
  signal n158 : std_logic_vector (2 downto 0);
  signal n159 : std_logic_vector (2 downto 0);
  signal n160 : std_logic_vector (2 downto 0);
  signal n161 : std_logic_vector (15 downto 0);
  signal n162 : std_logic_vector (15 downto 0);
  signal n163 : std_logic_vector (3 downto 0);
  signal n164 : std_logic_vector (3 downto 0);
  signal n165 : std_logic_vector (3 downto 0);
  signal n167 : std_logic;
  signal n168 : std_logic_vector (5 downto 0);
  signal n174 : std_logic;
  signal n179 : std_logic;
  signal n182 : std_logic_vector (2 downto 0);
  signal n183 : std_logic_vector (15 downto 0);
  signal n185 : std_logic_vector (15 downto 0);
  signal n186 : std_logic_vector (3 downto 0);
  signal n188 : std_logic_vector (3 downto 0);
  signal n189 : std_logic_vector (15 downto 0);
  signal n191 : std_logic_vector (15 downto 0);
  signal n192 : std_logic_vector (11 downto 0);
  signal n194 : std_logic_vector (11 downto 0);
  signal n200 : std_logic_vector (50 downto 0);
  signal n201 : std_logic_vector (50 downto 0);
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
  wrap_snes_clk <= n174;
  wrap_snes_latch <= n179;
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
  n3 <= n23 (0);
  n4 <= n23 (1);
  n5 <= n23 (2);
  n6 <= n23 (3);
  n7 <= n23 (4);
  n8 <= n23 (5);
  n9 <= n23 (6);
  n10 <= n23 (7);
  n11 <= n23 (8);
  n12 <= n23 (9);
  n13 <= n23 (10);
  n14 <= n23 (11);
  s <= n200; -- (signal)
  s_nxt <= n201; -- (signal)
  n16 <= not wrap_res_n;
  n23 <= s (50 downto 39);
  n24 <= s (2 downto 0);
  n32 <= s (23);
  n36 <= s (24);
  n39 <= s (25);
  n41 <= s (26);
  n43 <= s (27);
  n45 <= s (28);
  n47 <= s (29);
  n49 <= s (30);
  n51 <= s (31);
  n52 <= s (32);
  n53 <= s (33);
  n55 <= s (34);
  n56 <= n39 & n41 & n55 & n53 & n36 & n52 & n32 & n51 & n49 & n47 & n45 & n43;
  n60 <= s (18 downto 3);
  n62 <= '1' when n60 = "0000001111100111" else '0';
  n65 <= s (18 downto 3);
  n67 <= std_logic_vector (unsigned (n65) + unsigned'("0000000000000001"));
  n68 <= "0000000000000000" & "001";
  n69 <= n68 (2 downto 0);
  n70 <= s (2 downto 0);
  n71 <= n70 when n62 = '0' else n69;
  n72 <= n68 (18 downto 3);
  n73 <= n67 when n62 = '0' else n72;
  n75 <= '1' when n24 = "000" else '0';
  n79 <= s (18 downto 3);
  n81 <= '1' when n79 = "0000000011111001" else '0';
  n84 <= s (18 downto 3);
  n86 <= std_logic_vector (unsigned (n84) + unsigned'("0000000000000001"));
  n87 <= "0000000000000000" & "010";
  n88 <= n87 (2 downto 0);
  n89 <= s (2 downto 0);
  n90 <= n89 when n81 = '0' else n88;
  n91 <= n87 (18 downto 3);
  n92 <= n86 when n81 = '0' else n91;
  n94 <= '1' when n24 = "001" else '0';
  n98 <= s (18 downto 3);
  n100 <= '1' when n98 = "0000000011111001" else '0';
  n103 <= s (18 downto 3);
  n105 <= std_logic_vector (unsigned (n103) + unsigned'("0000000000000001"));
  n106 <= "0000000000000000" & "101";
  n107 <= n106 (2 downto 0);
  n108 <= s (2 downto 0);
  n109 <= n108 when n100 = '0' else n107;
  n110 <= n106 (18 downto 3);
  n111 <= n105 when n100 = '0' else n110;
  n113 <= '1' when n24 = "010" else '0';
  n117 <= s (18 downto 3);
  n119 <= '1' when n117 = "0000000011111000" else '0';
  n122 <= s (18 downto 3);
  n124 <= std_logic_vector (unsigned (n122) + unsigned'("0000000000000001"));
  n125 <= "0000000000000000" & "100";
  n126 <= n125 (2 downto 0);
  n127 <= s (2 downto 0);
  n128 <= n127 when n119 = '0' else n126;
  n129 <= n125 (18 downto 3);
  n130 <= n124 when n119 = '0' else n129;
  n132 <= '1' when n24 = "101" else '0';
  n134 <= not wrap_snes_data;
  n135 <= s (38 downto 24);
  n136 <= n134 & n135;
  n138 <= '1' when n24 = "100" else '0';
  n139 <= s (18 downto 3);
  n141 <= '1' when n139 = "0000000011111001" else '0';
  n143 <= s (22 downto 19);
  n145 <= '1' when n143 = "1111" else '0';
  n148 <= s (22 downto 19);
  n150 <= std_logic_vector (unsigned (n148) + unsigned'("0001"));
  n152 <= "101" when n145 = '0' else "000";
  n153 <= n150 when n145 = '0' else "0000";
  n154 <= s (18 downto 3);
  n156 <= std_logic_vector (unsigned (n154) + unsigned'("0000000000000001"));
  n157 <= n153 & "0000000000000000" & n152;
  n158 <= n157 (2 downto 0);
  n159 <= s (2 downto 0);
  n160 <= n159 when n141 = '0' else n158;
  n161 <= n157 (18 downto 3);
  n162 <= n156 when n141 = '0' else n161;
  n163 <= n157 (22 downto 19);
  n164 <= s (22 downto 19);
  n165 <= n164 when n141 = '0' else n163;
  n167 <= '1' when n24 = "011" else '0';
  n168 <= n167 & n138 & n132 & n113 & n94 & n75;
  with n168 select n174 <=
    '1' when "100000",
    '0' when "010000",
    '0' when "001000",
    '1' when "000100",
    '1' when "000010",
    '1' when "000001",
    'X' when others;
  with n168 select n179 <=
    '0' when "100000",
    '0' when "010000",
    '0' when "001000",
    '0' when "000100",
    '1' when "000010",
    '0' when "000001",
    'X' when others;
  with n168 select n182 <=
    n160 when "100000",
    "011" when "010000",
    n128 when "001000",
    n109 when "000100",
    n90 when "000010",
    n71 when "000001",
    "XXX" when others;
  n183 <= s (18 downto 3);
  with n168 select n185 <=
    n162 when "100000",
    n183 when "010000",
    n130 when "001000",
    n111 when "000100",
    n92 when "000010",
    n73 when "000001",
    (15 downto 0 => 'X') when others;
  n186 <= s (22 downto 19);
  with n168 select n188 <=
    n165 when "100000",
    n186 when "010000",
    n186 when "001000",
    n186 when "000100",
    n186 when "000010",
    n186 when "000001",
    "XXXX" when others;
  n189 <= s (38 downto 23);
  with n168 select n191 <=
    n189 when "100000",
    n136 when "010000",
    n189 when "001000",
    n189 when "000100",
    n189 when "000010",
    n189 when "000001",
    (15 downto 0 => 'X') when others;
  n192 <= s (50 downto 39);
  with n168 select n194 <=
    n192 when "100000",
    n192 when "010000",
    n192 when "001000",
    n192 when "000100",
    n192 when "000010",
    n56 when "000001",
    (11 downto 0 => 'X') when others;
  process (wrap_clk, n16)
  begin
    if n16 = '1' then
      n200 <= "000000000000000000000000000000000000000000000000000";
    elsif rising_edge (wrap_clk) then
      n200 <= s_nxt;
    end if;
  end process;
  n201 <= n194 & n191 & n188 & n185 & n182;
  assert clk_freq = 50000000 report "Unsupported generic value! clk_freq must be 50000000." severity failure;
  assert clk_out_freq = 100000 report "Unsupported generic value! clk_out_freq must be 100000." severity failure;
  assert refresh_timeout = 1000 report "Unsupported generic value! refresh_timeout must be 1000." severity failure;
end architecture;
