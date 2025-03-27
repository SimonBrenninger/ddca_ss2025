library ieee;
use ieee.std_logic_1164.all;
use work.vga_ctrl_pkg.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
architecture ref of vga_ctrl is
  signal wrap_clk: std_logic;
  signal wrap_res_n: std_logic;
  subtype typwrap_pix_color_r is std_logic_vector (7 downto 0);
  signal wrap_pix_color_r: typwrap_pix_color_r;
  subtype typwrap_pix_color_g is std_logic_vector (7 downto 0);
  signal wrap_pix_color_g: typwrap_pix_color_g;
  subtype typwrap_pix_color_b is std_logic_vector (7 downto 0);
  signal wrap_pix_color_b: typwrap_pix_color_b;
  signal wrap_frame_start: std_logic;
  signal wrap_pix_ack: std_logic;
  signal wrap_vga_hsync: std_logic;
  signal wrap_vga_vsync: std_logic;
  signal wrap_vga_dac_clk: std_logic;
  signal wrap_vga_dac_blank_n: std_logic;
  signal wrap_vga_dac_sync_n: std_logic;
  subtype typwrap_vga_dac_color_r is std_logic_vector (7 downto 0);
  signal wrap_vga_dac_color_r: typwrap_vga_dac_color_r;
  subtype typwrap_vga_dac_color_g is std_logic_vector (7 downto 0);
  signal wrap_vga_dac_color_g: typwrap_vga_dac_color_g;
  subtype typwrap_vga_dac_color_b is std_logic_vector (7 downto 0);
  signal wrap_vga_dac_color_b: typwrap_vga_dac_color_b;
  signal n1 : std_logic_vector (23 downto 0);
  signal n9 : std_logic_vector (7 downto 0);
  signal n10 : std_logic_vector (7 downto 0);
  signal n11 : std_logic_vector (7 downto 0);
  signal line_clk_cnt : std_logic_vector (9 downto 0);
  signal hline_cnt : std_logic_vector (9 downto 0);
  signal vga_hsync_int : std_logic;
  signal vga_vsync_int : std_logic;
  constant n12 : std_logic := '1';
  signal n14 : std_logic;
  signal n16 : std_logic_vector (31 downto 0);
  signal n18 : std_logic;
  signal n19 : std_logic_vector (31 downto 0);
  signal n21 : std_logic;
  signal n24 : std_logic;
  signal n25 : std_logic_vector (31 downto 0);
  signal n27 : std_logic;
  signal n28 : std_logic_vector (31 downto 0);
  signal n30 : std_logic;
  signal n31 : std_logic_vector (31 downto 0);
  signal n33 : std_logic;
  signal n34 : std_logic;
  signal n37 : std_logic;
  signal n39 : std_logic_vector (31 downto 0);
  signal n41 : std_logic_vector (31 downto 0);
  signal n42 : std_logic_vector (9 downto 0);
  signal n44 : std_logic_vector (9 downto 0);
  signal n45 : std_logic;
  signal n46 : std_logic_vector (31 downto 0);
  signal n48 : std_logic;
  signal n49 : std_logic_vector (31 downto 0);
  signal n51 : std_logic;
  signal n52 : std_logic;
  signal n55 : std_logic;
  signal n56 : std_logic_vector (31 downto 0);
  signal n58 : std_logic_vector (31 downto 0);
  signal n59 : std_logic_vector (9 downto 0);
  signal n61 : std_logic;
  signal n64 : std_logic_vector (9 downto 0);
  signal n67 : std_logic;
  signal n87 : std_logic;
  signal n97 : std_logic_vector (31 downto 0);
  signal n99 : std_logic;
  signal n100 : std_logic_vector (31 downto 0);
  signal n102 : std_logic;
  signal n103 : std_logic;
  signal n106 : std_logic;
  signal n110 : std_logic;
  signal n113 : std_logic_vector (23 downto 0);
  signal n116 : std_logic_vector (9 downto 0);
  signal n117 : std_logic_vector (9 downto 0);
  signal n118 : std_logic_vector (9 downto 0);
  signal n119 : std_logic;
  signal n120 : std_logic;
  signal n121 : std_logic;
  signal n122 : std_logic;
  signal n123 : std_logic;
  signal n124 : std_logic;
begin
  wrap_clk <= clk;
  wrap_res_n <= res_n;
  wrap_pix_color_r <= typwrap_pix_color_r(pix_color.r);
  wrap_pix_color_g <= typwrap_pix_color_g(pix_color.g);
  wrap_pix_color_b <= typwrap_pix_color_b(pix_color.b);
  frame_start <= wrap_frame_start;
  pix_ack <= wrap_pix_ack;
  vga_hsync <= wrap_vga_hsync;
  vga_vsync <= wrap_vga_vsync;
  vga_dac_clk <= wrap_vga_dac_clk;
  vga_dac_blank_n <= wrap_vga_dac_blank_n;
  vga_dac_sync_n <= wrap_vga_dac_sync_n;
  vga_dac_color.r <= std_ulogic_vector(wrap_vga_dac_color_r);
  vga_dac_color.g <= std_ulogic_vector(wrap_vga_dac_color_g);
  vga_dac_color.b <= std_ulogic_vector(wrap_vga_dac_color_b);
  wrap_frame_start <= n122;
  wrap_pix_ack <= n106;
  wrap_vga_hsync <= n123;
  wrap_vga_vsync <= n124;
  wrap_vga_dac_clk <= wrap_clk;
  wrap_vga_dac_blank_n <= n110;
  wrap_vga_dac_sync_n <= n12;
  wrap_vga_dac_color_r <= n9;
  wrap_vga_dac_color_g <= n10;
  wrap_vga_dac_color_b <= n11;
  n1 <= wrap_pix_color_b & wrap_pix_color_g & wrap_pix_color_r;
  n9 <= n113 (7 downto 0);
  n10 <= n113 (15 downto 8);
  n11 <= n113 (23 downto 16);
  line_clk_cnt <= n116; -- (signal)
  hline_cnt <= n118; -- (signal)
  vga_hsync_int <= n119; -- (signal)
  vga_vsync_int <= n121; -- (signal)
  n14 <= not wrap_res_n;
  n16 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n18 <= '1' when n16 = "00000000000000000000001100011111" else '0';
  n19 <= "0000000000000000000000" & hline_cnt;  --  uext
  n21 <= '1' when n19 = "00000000000000000000001000001011" else '0';
  n24 <= '0' when n21 = '0' else '1';
  n25 <= "0000000000000000000000" & hline_cnt;  --  uext
  n27 <= '1' when n25 = "00000000000000000000001000001100" else '0';
  n28 <= "0000000000000000000000" & hline_cnt;  --  uext
  n30 <= '1' when signed (n28) >= signed'("00000000000000000000000111101001") else '0';
  n31 <= "0000000000000000000000" & hline_cnt;  --  uext
  n33 <= '1' when signed (n31) < signed'("00000000000000000000000111101011") else '0';
  n34 <= n33 and n30;
  n37 <= '1' when n34 = '0' else '0';
  n39 <= "0000000000000000000000" & hline_cnt;  --  uext
  n41 <= std_logic_vector (unsigned (n39) + unsigned'("00000000000000000000000000000001"));
  n42 <= n41 (9 downto 0);  --  trunc
  n44 <= n42 when n27 = '0' else "0000000000";
  n45 <= n37 when n27 = '0' else vga_vsync_int;
  n46 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n48 <= '1' when signed (n46) >= signed'("00000000000000000000001010001110") else '0';
  n49 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n51 <= '1' when signed (n49) < signed'("00000000000000000000001011101110") else '0';
  n52 <= n51 and n48;
  n55 <= '1' when n52 = '0' else '0';
  n56 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n58 <= std_logic_vector (unsigned (n56) + unsigned'("00000000000000000000000000000001"));
  n59 <= n58 (9 downto 0);  --  trunc
  n61 <= '0' when n18 = '0' else n24;
  n64 <= n59 when n18 = '0' else "0000000000";
  n67 <= n55 when n18 = '0' else '1';
  n87 <= not wrap_res_n;
  n97 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n99 <= '1' when signed (n97) < signed'("00000000000000000000001010000000") else '0';
  n100 <= "0000000000000000000000" & hline_cnt;  --  uext
  n102 <= '1' when signed (n100) < signed'("00000000000000000000000111100000") else '0';
  n103 <= n102 and n99;
  n106 <= '0' when n103 = '0' else '1';
  n110 <= '0' when n103 = '0' else '1';
  n113 <= "000000000000000000000000" when n103 = '0' else n1;
  process (wrap_clk, n14)
  begin
    if n14 = '1' then
      n116 <= "0000000000";
    elsif rising_edge (wrap_clk) then
      n116 <= n64;
    end if;
  end process;
  n117 <= hline_cnt when n18 = '0' else n44;
  process (wrap_clk, n14)
  begin
    if n14 = '1' then
      n118 <= "1000001011";
    elsif rising_edge (wrap_clk) then
      n118 <= n117;
    end if;
  end process;
  process (wrap_clk, n14)
  begin
    if n14 = '1' then
      n119 <= '1';
    elsif rising_edge (wrap_clk) then
      n119 <= n67;
    end if;
  end process;
  n120 <= vga_vsync_int when n18 = '0' else n45;
  process (wrap_clk, n14)
  begin
    if n14 = '1' then
      n121 <= '1';
    elsif rising_edge (wrap_clk) then
      n121 <= n120;
    end if;
  end process;
  process (wrap_clk, n14)
  begin
    if n14 = '1' then
      n122 <= '0';
    elsif rising_edge (wrap_clk) then
      n122 <= n61;
    end if;
  end process;
  process (wrap_clk, n87)
  begin
    if n87 = '1' then
      n123 <= '1';
    elsif rising_edge (wrap_clk) then
      n123 <= vga_hsync_int;
    end if;
  end process;
  process (wrap_clk, n87)
  begin
    if n87 = '1' then
      n124 <= '1';
    elsif rising_edge (wrap_clk) then
      n124 <= vga_vsync_int;
    end if;
  end process;
  assert h_front_porch = 16 report "Unsupported generic value! h_front_porch must be 16." severity failure;
  assert h_back_porch = 48 report "Unsupported generic value! h_back_porch must be 48." severity failure;
  assert h_sync_pulse = 96 report "Unsupported generic value! h_sync_pulse must be 96." severity failure;
  assert h_visible_area = 640 report "Unsupported generic value! h_visible_area must be 640." severity failure;
  assert v_front_porch = 10 report "Unsupported generic value! v_front_porch must be 10." severity failure;
  assert v_back_porch = 33 report "Unsupported generic value! v_back_porch must be 33." severity failure;
  assert v_sync_pulse = 2 report "Unsupported generic value! v_sync_pulse must be 2." severity failure;
  assert v_visible_area = 480 report "Unsupported generic value! v_visible_area must be 480." severity failure;
end architecture;
