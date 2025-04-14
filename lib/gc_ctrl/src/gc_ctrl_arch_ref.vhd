library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gc_ctrl_pkg.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
architecture ref of gc_ctrl is
  signal wrap_clk: std_logic;
  signal wrap_res_n: std_logic;
  signal wrap_rumble: std_logic;
  signal wrap_ctrl_state_btn_up: std_logic;
  signal wrap_ctrl_state_btn_down: std_logic;
  signal wrap_ctrl_state_btn_left: std_logic;
  signal wrap_ctrl_state_btn_right: std_logic;
  signal wrap_ctrl_state_btn_a: std_logic;
  signal wrap_ctrl_state_btn_b: std_logic;
  signal wrap_ctrl_state_btn_x: std_logic;
  signal wrap_ctrl_state_btn_y: std_logic;
  signal wrap_ctrl_state_btn_z: std_logic;
  signal wrap_ctrl_state_btn_start: std_logic;
  signal wrap_ctrl_state_btn_l: std_logic;
  signal wrap_ctrl_state_btn_r: std_logic;
  subtype typwrap_ctrl_state_joy_x is std_logic_vector (7 downto 0);
  signal wrap_ctrl_state_joy_x: typwrap_ctrl_state_joy_x;
  subtype typwrap_ctrl_state_joy_y is std_logic_vector (7 downto 0);
  signal wrap_ctrl_state_joy_y: typwrap_ctrl_state_joy_y;
  subtype typwrap_ctrl_state_c_x is std_logic_vector (7 downto 0);
  signal wrap_ctrl_state_c_x: typwrap_ctrl_state_c_x;
  subtype typwrap_ctrl_state_c_y is std_logic_vector (7 downto 0);
  signal wrap_ctrl_state_c_y: typwrap_ctrl_state_c_y;
  subtype typwrap_ctrl_state_trigger_l is std_logic_vector (7 downto 0);
  signal wrap_ctrl_state_trigger_l: typwrap_ctrl_state_trigger_l;
  subtype typwrap_ctrl_state_trigger_r is std_logic_vector (7 downto 0);
  signal wrap_ctrl_state_trigger_r: typwrap_ctrl_state_trigger_r;
  signal n0_c_o : std_logic;
  signal n0_c_oport : std_logic;
  signal n2 : std_logic;
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
  signal n14 : std_logic_vector (7 downto 0);
  signal n15 : std_logic_vector (7 downto 0);
  signal n16 : std_logic_vector (7 downto 0);
  signal n17 : std_logic_vector (7 downto 0);
  signal n18 : std_logic_vector (7 downto 0);
  signal n19 : std_logic_vector (7 downto 0);
  signal s : std_logic_vector (176 downto 0);
  signal s_nxt : std_logic_vector (176 downto 0);
  signal data_synced : std_logic;
  signal sync_shiftreg : std_logic_vector (1 downto 0);
  signal n21 : std_logic;
  signal n23 : std_logic;
  signal n24 : std_logic_vector (1 downto 0);
  signal n25 : std_logic;
  signal n33 : std_logic_vector (59 downto 0);
  signal n35 : std_logic;
  signal n43 : std_logic_vector (2 downto 0);
  signal n44 : std_logic_vector (16 downto 0);
  signal n46 : std_logic;
  signal n51 : std_logic_vector (23 downto 0);
  signal n53 : std_logic_vector (24 downto 0);
  signal n54 : std_logic_vector (16 downto 0);
  signal n56 : std_logic_vector (16 downto 0);
  signal n57 : std_logic_vector (27 downto 0);
  signal n58 : std_logic_vector (27 downto 0);
  signal n59 : std_logic_vector (27 downto 0);
  signal n60 : std_logic_vector (16 downto 0);
  signal n61 : std_logic_vector (6 downto 0);
  signal n62 : std_logic_vector (6 downto 0);
  signal n64 : std_logic;
  signal n65 : std_logic_vector (6 downto 0);
  signal n67 : std_logic;
  signal n71 : std_logic_vector (2 downto 0);
  signal n72 : std_logic_vector (6 downto 0);
  signal n73 : std_logic_vector (6 downto 0);
  signal n75 : std_logic;
  signal n76 : std_logic;
  signal n77 : std_logic;
  signal n78 : std_logic_vector (16 downto 0);
  signal n80 : std_logic;
  signal n81 : std_logic;
  signal n82 : std_logic;
  signal n83 : std_logic_vector (16 downto 0);
  signal n85 : std_logic;
  signal n86 : std_logic;
  signal n87 : std_logic;
  signal n90 : std_logic_vector (16 downto 0);
  signal n92 : std_logic_vector (16 downto 0);
  signal n93 : std_logic_vector (2 downto 0);
  signal n94 : std_logic_vector (2 downto 0);
  signal n95 : std_logic_vector (16 downto 0);
  signal n97 : std_logic;
  signal n98 : std_logic;
  signal n99 : std_logic;
  signal n100 : std_logic_vector (16 downto 0);
  signal n102 : std_logic;
  signal n103 : std_logic;
  signal n104 : std_logic;
  signal n105 : std_logic_vector (16 downto 0);
  signal n107 : std_logic;
  signal n108 : std_logic;
  signal n109 : std_logic;
  signal n112 : std_logic_vector (23 downto 0);
  signal n113 : std_logic;
  signal n114 : std_logic_vector (24 downto 0);
  signal n115 : std_logic_vector (6 downto 0);
  signal n117 : std_logic_vector (6 downto 0);
  signal n118 : std_logic_vector (16 downto 0);
  signal n120 : std_logic_vector (16 downto 0);
  signal n121 : std_logic_vector (27 downto 0);
  signal n122 : std_logic_vector (27 downto 0);
  signal n123 : std_logic_vector (27 downto 0);
  signal n124 : std_logic_vector (16 downto 0);
  signal n125 : std_logic_vector (6 downto 0);
  signal n126 : std_logic_vector (6 downto 0);
  signal n128 : std_logic;
  signal n129 : std_logic;
  signal n130 : std_logic;
  signal n131 : std_logic;
  signal n133 : std_logic_vector (2 downto 0);
  signal n134 : std_logic_vector (2 downto 0);
  signal n136 : std_logic;
  signal n137 : std_logic_vector (16 downto 0);
  signal n139 : std_logic;
  signal n142 : std_logic_vector (16 downto 0);
  signal n144 : std_logic_vector (16 downto 0);
  signal n145 : std_logic_vector (2 downto 0);
  signal n146 : std_logic_vector (2 downto 0);
  signal n147 : std_logic_vector (16 downto 0);
  signal n149 : std_logic;
  signal n150 : std_logic_vector (6 downto 0);
  signal n152 : std_logic;
  signal n153 : std_logic_vector (62 downto 0);
  signal n154 : std_logic_vector (63 downto 0);
  signal n155 : std_logic_vector (63 downto 0);
  signal n156 : std_logic_vector (63 downto 0);
  signal n157 : std_logic_vector (6 downto 0);
  signal n159 : std_logic;
  signal n163 : std_logic_vector (6 downto 0);
  signal n165 : std_logic_vector (6 downto 0);
  signal n166 : std_logic_vector (2 downto 0);
  signal n167 : std_logic_vector (16 downto 0);
  signal n168 : std_logic_vector (16 downto 0);
  signal n169 : std_logic_vector (6 downto 0);
  signal n170 : std_logic_vector (6 downto 0);
  signal n172 : std_logic;
  signal n173 : std_logic_vector (16 downto 0);
  signal n175 : std_logic;
  signal n184 : std_logic;
  signal n187 : std_logic;
  signal n189 : std_logic;
  signal n191 : std_logic;
  signal n193 : std_logic;
  signal n195 : std_logic;
  signal n197 : std_logic;
  signal n199 : std_logic;
  signal n201 : std_logic;
  signal n203 : std_logic;
  signal n205 : std_logic;
  signal n207 : std_logic;
  signal n209 : std_logic;
  signal n211 : std_logic;
  signal n213 : std_logic;
  signal n215 : std_logic;
  signal n217 : std_logic;
  signal n219 : std_logic;
  signal n221 : std_logic;
  signal n223 : std_logic;
  signal n225 : std_logic;
  signal n227 : std_logic;
  signal n229 : std_logic;
  signal n231 : std_logic;
  signal n233 : std_logic;
  signal n235 : std_logic;
  signal n237 : std_logic;
  signal n239 : std_logic;
  signal n241 : std_logic;
  signal n243 : std_logic;
  signal n245 : std_logic;
  signal n247 : std_logic;
  signal n249 : std_logic;
  signal n251 : std_logic;
  signal n253 : std_logic;
  signal n255 : std_logic;
  signal n257 : std_logic;
  signal n259 : std_logic;
  signal n261 : std_logic;
  signal n263 : std_logic;
  signal n265 : std_logic;
  signal n267 : std_logic;
  signal n269 : std_logic;
  signal n271 : std_logic;
  signal n273 : std_logic;
  signal n275 : std_logic;
  signal n277 : std_logic;
  signal n279 : std_logic;
  signal n281 : std_logic;
  signal n283 : std_logic;
  signal n285 : std_logic;
  signal n287 : std_logic;
  signal n289 : std_logic;
  signal n291 : std_logic;
  signal n293 : std_logic;
  signal n295 : std_logic;
  signal n297 : std_logic;
  signal n299 : std_logic;
  signal n301 : std_logic;
  signal n303 : std_logic;
  signal n305 : std_logic;
  signal n307 : std_logic;
  signal n309 : std_logic;
  signal n311 : std_logic;
  signal n312 : std_logic_vector (63 downto 0);
  signal n318 : std_logic;
  signal n322 : std_logic;
  signal n325 : std_logic;
  signal n327 : std_logic;
  signal n329 : std_logic;
  signal n331 : std_logic;
  signal n333 : std_logic;
  signal n335 : std_logic;
  signal n336 : std_logic;
  signal n338 : std_logic;
  signal n340 : std_logic;
  signal n342 : std_logic;
  signal n343 : std_logic_vector (7 downto 0);
  signal n345 : std_logic_vector (7 downto 0);
  signal n347 : std_logic_vector (7 downto 0);
  signal n349 : std_logic_vector (7 downto 0);
  signal n351 : std_logic_vector (7 downto 0);
  signal n353 : std_logic_vector (7 downto 0);
  signal n354 : std_logic_vector (59 downto 0);
  signal n357 : std_logic_vector (16 downto 0);
  signal n359 : std_logic_vector (16 downto 0);
  signal n360 : std_logic_vector (76 downto 0);
  signal n361 : std_logic_vector (2 downto 0);
  signal n362 : std_logic_vector (2 downto 0);
  signal n363 : std_logic_vector (16 downto 0);
  signal n364 : std_logic_vector (16 downto 0);
  signal n365 : std_logic_vector (59 downto 0);
  signal n366 : std_logic_vector (59 downto 0);
  signal n367 : std_logic_vector (59 downto 0);
  signal n369 : std_logic;
  signal n370 : std_logic_vector (7 downto 0);
  signal n374 : std_logic;
  signal n376 : std_logic_vector (2 downto 0);
  signal n377 : std_logic_vector (2 downto 0);
  signal n379 : std_logic_vector (2 downto 0);
  signal n380 : std_logic_vector (24 downto 0);
  signal n381 : std_logic_vector (24 downto 0);
  signal n382 : std_logic_vector (24 downto 0);
  signal n384 : std_logic_vector (24 downto 0);
  signal n385 : std_logic_vector (63 downto 0);
  signal n387 : std_logic_vector (63 downto 0);
  signal n388 : std_logic_vector (16 downto 0);
  signal n390 : std_logic_vector (16 downto 0);
  signal n391 : std_logic_vector (59 downto 0);
  signal n393 : std_logic_vector (59 downto 0);
  signal n394 : std_logic_vector (6 downto 0);
  signal n396 : std_logic_vector (6 downto 0);
  signal n403 : std_logic_vector (176 downto 0);
  signal n404 : std_logic_vector (176 downto 0);
  signal n405 : std_logic;
  signal n406 : std_logic_vector (1 downto 0);
begin
  wrap_clk <= clk;
  wrap_res_n <= res_n;
  wrap_rumble <= rumble;
  ctrl_state.btn_up <= wrap_ctrl_state_btn_up;
  ctrl_state.btn_down <= wrap_ctrl_state_btn_down;
  ctrl_state.btn_left <= wrap_ctrl_state_btn_left;
  ctrl_state.btn_right <= wrap_ctrl_state_btn_right;
  ctrl_state.btn_a <= wrap_ctrl_state_btn_a;
  ctrl_state.btn_b <= wrap_ctrl_state_btn_b;
  ctrl_state.btn_x <= wrap_ctrl_state_btn_x;
  ctrl_state.btn_y <= wrap_ctrl_state_btn_y;
  ctrl_state.btn_z <= wrap_ctrl_state_btn_z;
  ctrl_state.btn_start <= wrap_ctrl_state_btn_start;
  ctrl_state.btn_l <= wrap_ctrl_state_btn_l;
  ctrl_state.btn_r <= wrap_ctrl_state_btn_r;
  ctrl_state.joy_x <= std_ulogic_vector(wrap_ctrl_state_joy_x);
  ctrl_state.joy_y <= std_ulogic_vector(wrap_ctrl_state_joy_y);
  ctrl_state.c_x <= std_ulogic_vector(wrap_ctrl_state_c_x);
  ctrl_state.c_y <= std_ulogic_vector(wrap_ctrl_state_c_y);
  ctrl_state.trigger_l <= std_ulogic_vector(wrap_ctrl_state_trigger_l);
  ctrl_state.trigger_r <= std_ulogic_vector(wrap_ctrl_state_trigger_r);
  data <= n0_c_oport;
  wrap_ctrl_state_btn_up <= n2;
  wrap_ctrl_state_btn_down <= n3;
  wrap_ctrl_state_btn_left <= n4;
  wrap_ctrl_state_btn_right <= n5;
  wrap_ctrl_state_btn_a <= n6;
  wrap_ctrl_state_btn_b <= n7;
  wrap_ctrl_state_btn_x <= n8;
  wrap_ctrl_state_btn_y <= n9;
  wrap_ctrl_state_btn_z <= n10;
  wrap_ctrl_state_btn_start <= n11;
  wrap_ctrl_state_btn_l <= n12;
  wrap_ctrl_state_btn_r <= n13;
  wrap_ctrl_state_joy_x <= n14;
  wrap_ctrl_state_joy_y <= n15;
  wrap_ctrl_state_c_x <= n16;
  wrap_ctrl_state_c_y <= n17;
  wrap_ctrl_state_trigger_l <= n18;
  wrap_ctrl_state_trigger_r <= n19;
  n0_c_oport <= n374; -- (inout - port)
  n0_c_o <= to_X01(data); -- (inout - read)
  n2 <= n33 (0);
  n3 <= n33 (1);
  n4 <= n33 (2);
  n5 <= n33 (3);
  n6 <= n33 (4);
  n7 <= n33 (5);
  n8 <= n33 (6);
  n9 <= n33 (7);
  n10 <= n33 (8);
  n11 <= n33 (9);
  n12 <= n33 (10);
  n13 <= n33 (11);
  n14 <= n33 (19 downto 12);
  n15 <= n33 (27 downto 20);
  n16 <= n33 (35 downto 28);
  n17 <= n33 (43 downto 36);
  n18 <= n33 (51 downto 44);
  n19 <= n33 (59 downto 52);
  s <= n403; -- (signal)
  s_nxt <= n404; -- (signal)
  data_synced <= n405; -- (signal)
  sync_shiftreg <= n406; -- (signal)
  n21 <= not wrap_res_n;
  n23 <= sync_shiftreg (0);
  n24 <= n23 & n0_c_o;
  n25 <= sync_shiftreg (1);
  n33 <= s (168 downto 109);
  n35 <= not wrap_res_n;
  n43 <= s (2 downto 0);
  n44 <= s (108 downto 92);
  n46 <= '1' when n44 = "01110101001011110" else '0';
  n51 <= "01000000000000110000000" & wrap_rumble;
  n53 <= n51 & '1';
  n54 <= s (108 downto 92);
  n56 <= std_logic_vector (unsigned (n54) + unsigned'("00000000000000001"));
  n57 <= n53 & "001";
  n58 <= s (27 downto 0);
  n59 <= n58 when n46 = '0' else n57;
  n60 <= n56 when n46 = '0' else "00000000000000000";
  n61 <= s (175 downto 169);
  n62 <= n61 when n46 = '0' else "0000000";
  n64 <= '1' when n43 = "000" else '0';
  n65 <= s (175 downto 169);
  n67 <= '1' when unsigned (n65) < unsigned'("0011001") else '0';
  n71 <= "101" when n67 = '0' else "010";
  n72 <= s (175 downto 169);
  n73 <= "0000000" when n67 = '0' else n72;
  n75 <= '1' when n43 = "001" else '0';
  n76 <= s (27);
  n77 <= not n76;
  n78 <= s (108 downto 92);
  n80 <= '1' when n78 = "00000000010010101" else '0';
  n81 <= n80 and n77;
  n82 <= s (27);
  n83 <= s (108 downto 92);
  n85 <= '1' when n83 = "00000000000110001" else '0';
  n86 <= n85 and n82;
  n87 <= n81 or n86;
  n90 <= s (108 downto 92);
  n92 <= std_logic_vector (unsigned (n90) + unsigned'("00000000000000001"));
  n93 <= s (2 downto 0);
  n94 <= n93 when n87 = '0' else "011";
  n95 <= n92 when n87 = '0' else "00000000000000000";
  n97 <= '1' when n43 = "010" else '0';
  n98 <= s (27);
  n99 <= not n98;
  n100 <= s (108 downto 92);
  n102 <= '1' when n100 = "00000000000110000" else '0';
  n103 <= n102 and n99;
  n104 <= s (27);
  n105 <= s (108 downto 92);
  n107 <= '1' when n105 = "00000000010010100" else '0';
  n108 <= n107 and n104;
  n109 <= n103 or n108;
  n112 <= s (26 downto 3);
  n113 <= s (27);
  n114 <= n112 & n113;
  n115 <= s (175 downto 169);
  n117 <= std_logic_vector (unsigned (n115) + unsigned'("0000001"));
  n118 <= s (108 downto 92);
  n120 <= std_logic_vector (unsigned (n118) + unsigned'("00000000000000001"));
  n121 <= n114 & "001";
  n122 <= s (27 downto 0);
  n123 <= n122 when n109 = '0' else n121;
  n124 <= n120 when n109 = '0' else "00000000000000000";
  n125 <= s (175 downto 169);
  n126 <= n125 when n109 = '0' else n117;
  n128 <= '1' when n43 = "011" else '0';
  n129 <= not data_synced;
  n130 <= s (176);
  n131 <= n130 and n129;
  n133 <= s (2 downto 0);
  n134 <= n133 when n131 = '0' else "100";
  n136 <= '1' when n43 = "101" else '0';
  n137 <= s (108 downto 92);
  n139 <= '1' when n137 = "00000000001001010" else '0';
  n142 <= s (108 downto 92);
  n144 <= std_logic_vector (unsigned (n142) + unsigned'("00000000000000001"));
  n145 <= s (2 downto 0);
  n146 <= n145 when n139 = '0' else "110";
  n147 <= n144 when n139 = '0' else "00000000000000000";
  n149 <= '1' when n43 = "100" else '0';
  n150 <= s (175 downto 169);
  n152 <= '1' when unsigned (n150) < unsigned'("1000000") else '0';
  n153 <= s (91 downto 29);
  n154 <= data_synced & n153;
  n155 <= s (91 downto 28);
  n156 <= n155 when n152 = '0' else n154;
  n157 <= s (175 downto 169);
  n159 <= '1' when n157 = "1000000" else '0';
  n163 <= s (175 downto 169);
  n165 <= std_logic_vector (unsigned (n163) + unsigned'("0000001"));
  n166 <= "101" when n159 = '0' else "111";
  n167 <= s (108 downto 92);
  n168 <= n167 when n159 = '0' else "00000000000000000";
  n169 <= s (175 downto 169);
  n170 <= n165 when n159 = '0' else n169;
  n172 <= '1' when n43 = "110" else '0';
  n173 <= s (108 downto 92);
  n175 <= '1' when n173 = "00000000001110111" else '0';
  n184 <= s (91);
  n187 <= s (90);
  n189 <= s (89);
  n191 <= s (88);
  n193 <= s (87);
  n195 <= s (86);
  n197 <= s (85);
  n199 <= s (84);
  n201 <= s (83);
  n203 <= s (82);
  n205 <= s (81);
  n207 <= s (80);
  n209 <= s (79);
  n211 <= s (78);
  n213 <= s (77);
  n215 <= s (76);
  n217 <= s (75);
  n219 <= s (74);
  n221 <= s (73);
  n223 <= s (72);
  n225 <= s (71);
  n227 <= s (70);
  n229 <= s (69);
  n231 <= s (68);
  n233 <= s (67);
  n235 <= s (66);
  n237 <= s (65);
  n239 <= s (64);
  n241 <= s (63);
  n243 <= s (62);
  n245 <= s (61);
  n247 <= s (60);
  n249 <= s (59);
  n251 <= s (58);
  n253 <= s (57);
  n255 <= s (56);
  n257 <= s (55);
  n259 <= s (54);
  n261 <= s (53);
  n263 <= s (52);
  n265 <= s (51);
  n267 <= s (50);
  n269 <= s (49);
  n271 <= s (48);
  n273 <= s (47);
  n275 <= s (46);
  n277 <= s (45);
  n279 <= s (44);
  n281 <= s (43);
  n283 <= s (42);
  n285 <= s (41);
  n287 <= s (40);
  n289 <= s (39);
  n291 <= s (38);
  n293 <= s (37);
  n295 <= s (36);
  n297 <= s (35);
  n299 <= s (34);
  n301 <= s (33);
  n303 <= s (32);
  n305 <= s (31);
  n307 <= s (30);
  n309 <= s (29);
  n311 <= s (28);
  n312 <= n311 & n309 & n307 & n305 & n303 & n301 & n299 & n297 & n295 & n293 & n291 & n289 & n287 & n285 & n283 & n281 & n279 & n277 & n275 & n273 & n271 & n269 & n267 & n265 & n263 & n261 & n259 & n257 & n255 & n253 & n251 & n249 & n247 & n245 & n243 & n241 & n239 & n237 & n235 & n233 & n231 & n229 & n227 & n225 & n223 & n221 & n219 & n217 & n215 & n213 & n211 & n209 & n207 & n205 & n203 & n201 & n199 & n197 & n195 & n193 & n191 & n189 & n187 & n184;
  n318 <= n312 (60);
  n322 <= n312 (59);
  n325 <= n312 (58);
  n327 <= n312 (57);
  n329 <= n312 (56);
  n331 <= n312 (54);
  n333 <= n312 (53);
  n335 <= n312 (52);
  n336 <= n312 (51);
  n338 <= n312 (50);
  n340 <= n312 (49);
  n342 <= n312 (48);
  n343 <= n312 (47 downto 40);
  n345 <= n312 (39 downto 32);
  n347 <= n312 (31 downto 24);
  n349 <= n312 (23 downto 16);
  n351 <= n312 (15 downto 8);
  n353 <= n312 (7 downto 0);
  n354 <= n353 & n351 & n349 & n347 & n345 & n343 & n333 & n331 & n318 & n335 & n322 & n325 & n327 & n329 & n340 & n342 & n338 & n336;
  n357 <= s (108 downto 92);
  n359 <= std_logic_vector (unsigned (n357) + unsigned'("00000000000000001"));
  n360 <= n354 & "00000000000000000";
  n361 <= s (2 downto 0);
  n362 <= n361 when n175 = '0' else "000";
  n363 <= n360 (16 downto 0);
  n364 <= n359 when n175 = '0' else n363;
  n365 <= n360 (76 downto 17);
  n366 <= s (168 downto 109);
  n367 <= n366 when n175 = '0' else n365;
  n369 <= '1' when n43 = "111" else '0';
  n370 <= n369 & n172 & n149 & n136 & n128 & n97 & n75 & n64;
  with n370 select n374 <=
    'Z' when "10000000",
    'Z' when "01000000",
    'Z' when "00100000",
    'Z' when "00010000",
    'Z' when "00001000",
    '0' when "00000100",
    'Z' when "00000010",
    'Z' when "00000001",
    'X' when others;
  n376 <= n59 (2 downto 0);
  n377 <= n123 (2 downto 0);
  with n370 select n379 <=
    n362 when "10000000",
    n166 when "01000000",
    n146 when "00100000",
    n134 when "00010000",
    n377 when "00001000",
    n94 when "00000100",
    n71 when "00000010",
    n376 when "00000001",
    "XXX" when others;
  n380 <= n59 (27 downto 3);
  n381 <= n123 (27 downto 3);
  n382 <= s (27 downto 3);
  with n370 select n384 <=
    n382 when "10000000",
    n382 when "01000000",
    n382 when "00100000",
    n382 when "00010000",
    n381 when "00001000",
    n382 when "00000100",
    n382 when "00000010",
    n380 when "00000001",
    (24 downto 0 => 'X') when others;
  n385 <= s (91 downto 28);
  with n370 select n387 <=
    n385 when "10000000",
    n156 when "01000000",
    n385 when "00100000",
    n385 when "00010000",
    n385 when "00001000",
    n385 when "00000100",
    n385 when "00000010",
    n385 when "00000001",
    (63 downto 0 => 'X') when others;
  n388 <= s (108 downto 92);
  with n370 select n390 <=
    n364 when "10000000",
    n168 when "01000000",
    n147 when "00100000",
    n388 when "00010000",
    n124 when "00001000",
    n95 when "00000100",
    n388 when "00000010",
    n60 when "00000001",
    (16 downto 0 => 'X') when others;
  n391 <= s (168 downto 109);
  with n370 select n393 <=
    n367 when "10000000",
    n391 when "01000000",
    n391 when "00100000",
    n391 when "00010000",
    n391 when "00001000",
    n391 when "00000100",
    n391 when "00000010",
    n391 when "00000001",
    (59 downto 0 => 'X') when others;
  n394 <= s (175 downto 169);
  with n370 select n396 <=
    n394 when "10000000",
    n170 when "01000000",
    n394 when "00100000",
    n394 when "00010000",
    n126 when "00001000",
    n394 when "00000100",
    n73 when "00000010",
    n62 when "00000001",
    "XXXXXXX" when others;
  process (wrap_clk, n35)
  begin
    if n35 = '1' then
      n403 <= "100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (wrap_clk) then
      n403 <= s_nxt;
    end if;
  end process;
  n404 <= data_synced & n396 & n393 & n390 & n387 & n384 & n379;
  process (wrap_clk, n21)
  begin
    if n21 = '1' then
      n405 <= '0';
    elsif rising_edge (wrap_clk) then
      n405 <= n25;
    end if;
  end process;
  process (wrap_clk, n21)
  begin
    if n21 = '1' then
      n406 <= "00";
    elsif rising_edge (wrap_clk) then
      n406 <= n24;
    end if;
  end process;
  assert clk_freq = 50000000 report "Unsupported generic value! clk_freq must be 50000000." severity failure;
  assert sync_stages = 2 report "Unsupported generic value! sync_stages must be 2." severity failure;
  assert refresh_timeout = 60000 report "Unsupported generic value! refresh_timeout must be 60000." severity failure;
end architecture;
