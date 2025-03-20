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
  constant n13 : std_logic := '1';
  signal n15 : std_logic;
  signal n17 : std_logic_vector (31 downto 0);
  signal n19 : std_logic;
  signal n20 : std_logic_vector (31 downto 0);
  signal n22 : std_logic;
  signal n25 : std_logic;
  signal n26 : std_logic_vector (31 downto 0);
  signal n28 : std_logic;
  signal n29 : std_logic_vector (31 downto 0);
  signal n31 : std_logic;
  signal n32 : std_logic_vector (31 downto 0);
  signal n34 : std_logic;
  signal n35 : std_logic;
  signal n38 : std_logic;
  signal n40 : std_logic_vector (31 downto 0);
  signal n42 : std_logic_vector (31 downto 0);
  signal n43 : std_logic_vector (9 downto 0);
  signal n45 : std_logic_vector (9 downto 0);
  signal n46 : std_logic;
  signal n47 : std_logic_vector (31 downto 0);
  signal n49 : std_logic;
  signal n50 : std_logic_vector (31 downto 0);
  signal n52 : std_logic;
  signal n53 : std_logic;
  signal n56 : std_logic;
  signal n57 : std_logic_vector (31 downto 0);
  signal n59 : std_logic_vector (31 downto 0);
  signal n60 : std_logic_vector (9 downto 0);
  signal n62 : std_logic;
  signal n65 : std_logic_vector (9 downto 0);
  signal n68 : std_logic;
  signal n88 : std_logic;
  signal n98 : std_logic_vector (31 downto 0);
  signal n100 : std_logic;
  signal n101 : std_logic_vector (31 downto 0);
  signal n103 : std_logic;
  signal n104 : std_logic;
  signal n107 : std_logic;
  signal n111 : std_logic;
  signal n114 : std_logic_vector (23 downto 0);
  signal n117 : std_logic_vector (9 downto 0);
  signal n118 : std_logic_vector (9 downto 0);
  signal n119 : std_logic_vector (9 downto 0) := "0111100001";
  signal n120 : std_logic;
  signal n121 : std_logic;
  signal n122 : std_logic;
  signal n123 : std_logic;
  signal n124 : std_logic;
  signal n125 : std_logic;
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
  wrap_frame_start <= n123;
  wrap_pix_ack <= n107;
  wrap_vga_hsync <= n124;
  wrap_vga_vsync <= n125;
  wrap_vga_dac_clk <= wrap_clk;
  wrap_vga_dac_blank_n <= n111;
  wrap_vga_dac_sync_n <= n13;
  wrap_vga_dac_color_r <= n9;
  wrap_vga_dac_color_g <= n10;
  wrap_vga_dac_color_b <= n11;
  n1 <= wrap_pix_color_b & wrap_pix_color_g & wrap_pix_color_r;
  n9 <= n114 (7 downto 0);
  n10 <= n114 (15 downto 8);
  n11 <= n114 (23 downto 16);
  line_clk_cnt <= n117; -- (signal)
  hline_cnt <= n119; -- (isignal)
  vga_hsync_int <= n120; -- (signal)
  vga_vsync_int <= n122; -- (signal)
  n15 <= not wrap_res_n;
  n17 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n19 <= '1' when n17 = "00000000000000000000001100011111" else '0';
  n20 <= "0000000000000000000000" & hline_cnt;  --  uext
  n22 <= '1' when n20 = "00000000000000000000001000001011" else '0';
  n25 <= '0' when n22 = '0' else '1';
  n26 <= "0000000000000000000000" & hline_cnt;  --  uext
  n28 <= '1' when n26 = "00000000000000000000001000001100" else '0';
  n29 <= "0000000000000000000000" & hline_cnt;  --  uext
  n31 <= '1' when signed (n29) >= signed'("00000000000000000000000111101001") else '0';
  n32 <= "0000000000000000000000" & hline_cnt;  --  uext
  n34 <= '1' when signed (n32) < signed'("00000000000000000000000111101011") else '0';
  n35 <= n34 and n31;
  n38 <= '1' when n35 = '0' else '0';
  n40 <= "0000000000000000000000" & hline_cnt;  --  uext
  n42 <= std_logic_vector (unsigned (n40) + unsigned'("00000000000000000000000000000001"));
  n43 <= n42 (9 downto 0);  --  trunc
  n45 <= n43 when n28 = '0' else "0000000000";
  n46 <= n38 when n28 = '0' else vga_vsync_int;
  n47 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n49 <= '1' when signed (n47) >= signed'("00000000000000000000001010001110") else '0';
  n50 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n52 <= '1' when signed (n50) < signed'("00000000000000000000001011101110") else '0';
  n53 <= n52 and n49;
  n56 <= '1' when n53 = '0' else '0';
  n57 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n59 <= std_logic_vector (unsigned (n57) + unsigned'("00000000000000000000000000000001"));
  n60 <= n59 (9 downto 0);  --  trunc
  n62 <= '0' when n19 = '0' else n25;
  n65 <= n60 when n19 = '0' else "0000000000";
  n68 <= n56 when n19 = '0' else '1';
  n88 <= not wrap_res_n;
  n98 <= "0000000000000000000000" & line_clk_cnt;  --  uext
  n100 <= '1' when signed (n98) < signed'("00000000000000000000001010000000") else '0';
  n101 <= "0000000000000000000000" & hline_cnt;  --  uext
  n103 <= '1' when signed (n101) < signed'("00000000000000000000000111100000") else '0';
  n104 <= n103 and n100;
  n107 <= '0' when n104 = '0' else '1';
  n111 <= '0' when n104 = '0' else '1';
  n114 <= "000000000000000000000000" when n104 = '0' else n1;
  process (wrap_clk, n15)
  begin
    if n15 = '1' then
      n117 <= "0000000000";
    elsif rising_edge (wrap_clk) then
      n117 <= n65;
    end if;
  end process;
  n118 <= hline_cnt when n19 = '0' else n45;
  process (wrap_clk, n15)
  begin
    if n15 = '1' then
      n119 <= "1000001011";
    elsif rising_edge (wrap_clk) then
      n119 <= n118;
    end if;
  end process;
  process (wrap_clk, n15)
  begin
    if n15 = '1' then
      n120 <= '1';
    elsif rising_edge (wrap_clk) then
      n120 <= n68;
    end if;
  end process;
  n121 <= vga_vsync_int when n19 = '0' else n46;
  process (wrap_clk, n15)
  begin
    if n15 = '1' then
      n122 <= '1';
    elsif rising_edge (wrap_clk) then
      n122 <= n121;
    end if;
  end process;
  process (wrap_clk, n15)
  begin
    if n15 = '1' then
      n123 <= '0';
    elsif rising_edge (wrap_clk) then
      n123 <= n62;
    end if;
  end process;
  process (wrap_clk, n88)
  begin
    if n88 = '1' then
      n124 <= '1';
    elsif rising_edge (wrap_clk) then
      n124 <= vga_hsync_int;
    end if;
  end process;
  process (wrap_clk, n88)
  begin
    if n88 = '1' then
      n125 <= '1';
    elsif rising_edge (wrap_clk) then
      n125 <= vga_vsync_int;
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
