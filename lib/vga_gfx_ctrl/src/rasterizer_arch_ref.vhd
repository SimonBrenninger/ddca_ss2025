library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.mem_pkg.all;
use work.sram_ctrl_pkg.all;
use work.gfx_core_pkg.all;
use work.gfx_util_pkg.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity dp_ram_1c1r1w_3_8 is
  port (
    clk : in std_logic;
    rd1_addr : in std_logic_vector (2 downto 0);
    rd1 : in std_logic;
    wr2_addr : in std_logic_vector (2 downto 0);
    wr2_data : in std_logic_vector (7 downto 0);
    wr2 : in std_logic;
    rd1_data : out std_logic_vector (7 downto 0));
end entity dp_ram_1c1r1w_3_8;
architecture ref of dp_ram_1c1r1w_3_8 is
  signal n2219 : std_logic_vector (7 downto 0);
  signal n2220 : std_logic_vector (7 downto 0) := "00000000";
  signal n2222 : std_logic_vector (7 downto 0);
begin
  rd1_data <= n2220;
  n2219 <= n2220 when rd1 = '0' else n2222;
  process (clk)
  begin
    if rising_edge (clk) then
      n2220 <= n2219;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (7 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n2222 <= ram(to_integer (unsigned (rd1_addr)));
    if rising_edge (clk) and (wr2 = '1') then
      ram (to_integer (unsigned (wr2_addr))) := wr2_data;
    end if;
  end process;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fifo_1c1r1w_8_8 is
  port (
    clk : in std_logic;
    res_n : in std_logic;
    rd : in std_logic;
    wr_data : in std_logic_vector (7 downto 0);
    wr : in std_logic;
    rd_data : out std_logic_vector (7 downto 0);
    empty : out std_logic;
    full : out std_logic;
    half_full : out std_logic);
end entity fifo_1c1r1w_8_8;
architecture ref of fifo_1c1r1w_8_8 is
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
  signal memory_inst_n2080 : std_logic_vector (7 downto 0);
  signal memory_inst_c_rd1_data : std_logic_vector (7 downto 0);
  signal n2084 : std_logic;
  signal n2107 : std_logic;
  signal n2108 : std_logic;
  signal n2110 : std_logic_vector (2 downto 0);
  signal n2111 : std_logic_vector (2 downto 0);
  signal n2114 : std_logic;
  signal n2116 : std_logic;
  signal n2117 : std_logic;
  signal n2119 : std_logic_vector (2 downto 0);
  signal n2120 : std_logic_vector (2 downto 0);
  signal n2123 : std_logic;
  signal n2125 : std_logic;
  signal n2126 : std_logic;
  signal n2128 : std_logic_vector (31 downto 0);
  signal n2129 : std_logic;
  signal n2130 : std_logic;
  signal n2132 : std_logic_vector (31 downto 0);
  signal n2133 : std_logic_vector (31 downto 0);
  signal n2134 : std_logic_vector (31 downto 0);
  signal n2136 : std_logic;
  signal n2139 : std_logic;
  signal n2142 : std_logic_vector (2 downto 0);
  signal n2143 : std_logic;
  signal n2145 : std_logic;
  signal n2147 : std_logic;
  signal n2148 : std_logic;
  signal n2150 : std_logic_vector (2 downto 0);
  signal n2151 : std_logic;
  signal n2152 : std_logic;
  signal n2153 : std_logic;
  signal n2155 : std_logic;
  signal n2156 : std_logic;
  signal n2158 : std_logic;
  signal n2164 : std_logic;
  signal n2166 : std_logic;
  signal n2167 : std_logic;
  signal n2171 : std_logic;
  signal n2172 : std_logic;
  signal n2174 : std_logic;
  signal n2175 : std_logic;
  signal n2179 : std_logic;
  signal n2188 : std_logic := '1';
  signal n2190 : std_logic := '1';
  signal n2191 : std_logic_vector (2 downto 0);
  signal n2192 : std_logic_vector (2 downto 0);
  signal n2193 : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n2194 : std_logic;
  signal n2195 : std_logic;
  signal n2196 : std_logic;
begin
  rd_data <= memory_inst_n2080;
  empty <= n2194;
  full <= n2195;
  half_full <= n2196;
  read_address <= n2191; -- (signal)
  read_address_next <= n2120; -- (signal)
  write_address <= n2192; -- (signal)
  write_address_next <= n2111; -- (signal)
  full_next <= n2155; -- (signal)
  empty_next <= n2158; -- (signal)
  wr_int <= n2114; -- (signal)
  rd_int <= n2123; -- (signal)
  half_full_next <= n2139; -- (signal)
  pointer_diff <= n2193; -- (isignal)
  pointer_diff_next <= n2134; -- (isignal)
  memory_inst_n2080 <= memory_inst_c_rd1_data; -- (signal)
  memory_inst : entity work.dp_ram_1c1r1w_3_8 port map (
    clk => clk,
    rd1_addr => read_address,
    rd1 => rd_int,
    wr2_addr => write_address,
    wr2_data => wr_data,
    wr2 => wr_int,
    rd1_data => memory_inst_c_rd1_data);
  n2084 <= not res_n;
  n2107 <= not n2195;
  n2108 <= n2107 and wr;
  n2110 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n2111 <= write_address when n2108 = '0' else n2110;
  n2114 <= '0' when n2108 = '0' else '1';
  n2116 <= not n2194;
  n2117 <= n2116 and rd;
  n2119 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n2120 <= read_address when n2117 = '0' else n2119;
  n2123 <= '0' when n2117 = '0' else '1';
  n2125 <= not rd;
  n2126 <= n2125 and wr;
  n2128 <= std_logic_vector (unsigned (pointer_diff) + unsigned'("00000000000000000000000000000001"));
  n2129 <= not wr;
  n2130 <= n2129 and rd;
  n2132 <= std_logic_vector (unsigned (pointer_diff) - unsigned'("00000000000000000000000000000001"));
  n2133 <= pointer_diff when n2130 = '0' else n2132;
  n2134 <= n2133 when n2126 = '0' else n2128;
  n2136 <= '1' when signed (n2134) >= signed'("00000000000000000000000000000100") else '0';
  n2139 <= '0' when n2136 = '0' else '1';
  n2142 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n2143 <= '1' when write_address = n2142 else '0';
  n2145 <= n2194 when n2148 = '0' else '1';
  n2147 <= n2195 when rd = '0' else '0';
  n2148 <= n2143 and rd;
  n2150 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n2151 <= '1' when read_address = n2150 else '0';
  n2152 <= not rd;
  n2153 <= n2152 and n2151;
  n2155 <= n2147 when n2156 = '0' else '1';
  n2156 <= n2153 and wr;
  n2158 <= n2145 when wr = '0' else '0';
  n2164 <= not n2195;
  n2166 <= not n2171;
  n2167 <= n2166 or n2164;
  n2168: postponed assert n2188 = '1' severity error; --  assert
  n2171 <= '0' when wr = '0' else '1';
  n2172 <= not n2194;
  n2174 <= not n2179;
  n2175 <= n2174 or n2172;
  n2176: postponed assert n2190 = '1' severity error; --  assert
  n2179 <= '0' when rd = '0' else '1';
  process (clk)
  begin
    if rising_edge (clk) then
      n2188 <= n2167;
    end if;
  end process;
  process (clk)
  begin
    if rising_edge (clk) then
      n2190 <= n2175;
    end if;
  end process;
  process (clk, n2084)
  begin
    if n2084 = '1' then
      n2191 <= "000";
    elsif rising_edge (clk) then
      n2191 <= read_address_next;
    end if;
  end process;
  process (clk, n2084)
  begin
    if n2084 = '1' then
      n2192 <= "000";
    elsif rising_edge (clk) then
      n2192 <= write_address_next;
    end if;
  end process;
  process (clk, n2084)
  begin
    if n2084 = '1' then
      n2193 <= "00000000000000000000000000000000";
    elsif rising_edge (clk) then
      n2193 <= pointer_diff_next;
    end if;
  end process;
  process (clk, n2084)
  begin
    if n2084 = '1' then
      n2194 <= '1';
    elsif rising_edge (clk) then
      n2194 <= empty_next;
    end if;
  end process;
  process (clk, n2084)
  begin
    if n2084 = '1' then
      n2195 <= '0';
    elsif rising_edge (clk) then
      n2195 <= full_next;
    end if;
  end process;
  process (clk, n2084)
  begin
    if n2084 = '1' then
      n2196 <= '0';
    elsif rising_edge (clk) then
      n2196 <= half_full_next;
    end if;
  end process;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fifo_1c1r1w_fwft_8_8 is
  port (
    clk : in std_logic;
    res_n : in std_logic;
    rd_ack : in std_logic;
    wr_data : in std_logic_vector (7 downto 0);
    wr : in std_logic;
    rd_data : out std_logic_vector (7 downto 0);
    rd_valid : out std_logic;
    full : out std_logic;
    half_full : out std_logic);
end entity fifo_1c1r1w_fwft_8_8;
architecture ref of fifo_1c1r1w_fwft_8_8 is
  signal rd : std_logic;
  signal empty : std_logic;
  signal not_empty : std_logic;
  signal fifo_inst_n2045 : std_logic_vector (7 downto 0);
  signal fifo_inst_n2046 : std_logic;
  signal fifo_inst_n2047 : std_logic;
  signal fifo_inst_n2048 : std_logic;
  signal fifo_inst_c_rd_data : std_logic_vector (7 downto 0);
  signal fifo_inst_c_empty : std_logic;
  signal fifo_inst_c_full : std_logic;
  signal fifo_inst_c_half_full : std_logic;
  signal n2057 : std_logic;
  signal n2058 : std_logic;
  signal n2059 : std_logic;
  signal n2060 : std_logic;
  signal n2061 : std_logic;
  signal n2063 : std_logic;
  signal n2065 : std_logic;
  signal n2071 : std_logic;
  signal n2072 : std_logic;
begin
  rd_data <= fifo_inst_n2045;
  rd_valid <= n2072;
  full <= fifo_inst_n2047;
  half_full <= fifo_inst_n2048;
  rd <= n2061; -- (signal)
  empty <= fifo_inst_n2046; -- (signal)
  not_empty <= n2057; -- (signal)
  fifo_inst_n2045 <= fifo_inst_c_rd_data; -- (signal)
  fifo_inst_n2046 <= fifo_inst_c_empty; -- (signal)
  fifo_inst_n2047 <= fifo_inst_c_full; -- (signal)
  fifo_inst_n2048 <= fifo_inst_c_half_full; -- (signal)
  fifo_inst : entity work.fifo_1c1r1w_8_8 port map (
    clk => clk,
    res_n => res_n,
    rd => rd,
    wr_data => wr_data,
    wr => wr,
    rd_data => fifo_inst_c_rd_data,
    empty => fifo_inst_c_empty,
    full => fifo_inst_c_full,
    half_full => fifo_inst_c_half_full);
  n2057 <= not empty;
  n2058 <= rd_ack and not_empty;
  n2059 <= not n2072;
  n2060 <= not_empty and n2059;
  n2061 <= n2058 or n2060;
  n2063 <= not res_n;
  n2065 <= rd or rd_ack;
  n2071 <= n2072 when n2065 = '0' else not_empty;
  process (clk, n2063)
  begin
    if n2063 = '1' then
      n2072 <= '0';
    elsif rising_edge (clk) then
      n2072 <= n2071;
    end if;
  end process;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pixel_reader_21_16 is
  port (
    clk : in std_logic;
    res_n : in std_logic;
    start : in std_logic;
    bd_b : in std_logic_vector (31 downto 0);
    bd_w : in std_logic_vector (14 downto 0);
    bd_h : in std_logic_vector (14 downto 0);
    section_x : in std_logic_vector (14 downto 0);
    section_y : in std_logic_vector (14 downto 0);
    section_w : in std_logic_vector (14 downto 0);
    section_h : in std_logic_vector (14 downto 0);
    color_ack : in std_logic;
    vram_rd_data : in std_logic_vector (15 downto 0);
    vram_rd_busy : in std_logic;
    vram_rd_valid : in std_logic;
    color : out std_logic_vector (7 downto 0);
    color_valid : out std_logic;
    vram_rd_addr : out std_logic_vector (20 downto 0);
    vram_rd : out std_logic;
    vram_rd_access_mode : out std_logic);
end entity pixel_reader_21_16;
architecture ref of pixel_reader_21_16 is
  signal n1887 : std_logic_vector (61 downto 0);
  signal n1888 : std_logic_vector (59 downto 0);
  signal state : std_logic_vector (55 downto 0);
  signal state_nxt : std_logic_vector (55 downto 0);
  signal pixbuf_half_full : std_logic;
  signal fifo_wr : std_logic;
  signal n1895 : std_logic;
  signal n1903 : std_logic_vector (20 downto 0);
  signal n1904 : std_logic_vector (1 downto 0);
  signal n1905 : std_logic_vector (14 downto 0);
  signal n1906 : std_logic_vector (14 downto 0);
  signal n1908 : std_logic_vector (31 downto 0);
  signal n1909 : std_logic_vector (31 downto 0);
  signal n1910 : std_logic_vector (31 downto 0);
  signal n1912 : std_logic;
  signal n1913 : std_logic_vector (31 downto 0);
  signal n1914 : std_logic_vector (14 downto 0);
  signal n1915 : std_logic_vector (31 downto 0);
  signal n1916 : std_logic_vector (31 downto 0);
  signal n1917 : std_logic_vector (14 downto 0);
  signal n1918 : std_logic_vector (14 downto 0);
  signal n1919 : std_logic_vector (29 downto 0);
  signal n1920 : std_logic_vector (29 downto 0);
  signal n1921 : std_logic_vector (29 downto 0);
  signal n1922 : std_logic_vector (31 downto 0);
  signal n1923 : std_logic_vector (31 downto 0);
  signal n1924 : std_logic_vector (20 downto 0);
  signal n1925 : std_logic;
  signal n1927 : std_logic_vector (1 downto 0);
  signal n1928 : std_logic_vector (1 downto 0);
  signal n1930 : std_logic;
  signal n1931 : std_logic;
  signal n1933 : std_logic_vector (14 downto 0);
  signal n1934 : std_logic_vector (14 downto 0);
  signal n1935 : std_logic_vector (14 downto 0);
  signal n1936 : std_logic_vector (14 downto 0);
  signal n1938 : std_logic_vector (14 downto 0);
  signal n1939 : std_logic;
  signal n1940 : std_logic_vector (14 downto 0);
  signal n1941 : std_logic_vector (14 downto 0);
  signal n1942 : std_logic_vector (14 downto 0);
  signal n1943 : std_logic_vector (14 downto 0);
  signal n1944 : std_logic_vector (14 downto 0);
  signal n1946 : std_logic_vector (14 downto 0);
  signal n1947 : std_logic;
  signal n1949 : std_logic_vector (14 downto 0);
  signal n1951 : std_logic_vector (14 downto 0);
  signal n1952 : std_logic_vector (1 downto 0);
  signal n1953 : std_logic_vector (14 downto 0);
  signal n1954 : std_logic_vector (14 downto 0);
  signal n1955 : std_logic_vector (14 downto 0);
  signal n1957 : std_logic_vector (14 downto 0);
  signal n1958 : std_logic_vector (31 downto 0);
  signal n1959 : std_logic_vector (1 downto 0);
  signal n1960 : std_logic_vector (1 downto 0);
  signal n1961 : std_logic_vector (14 downto 0);
  signal n1962 : std_logic_vector (14 downto 0);
  signal n1963 : std_logic_vector (14 downto 0);
  signal n1964 : std_logic_vector (14 downto 0);
  signal n1965 : std_logic_vector (14 downto 0);
  signal n1968 : std_logic;
  signal n1969 : std_logic_vector (31 downto 0);
  signal n1970 : std_logic_vector (31 downto 0);
  signal n1971 : std_logic_vector (31 downto 0);
  signal n1973 : std_logic;
  signal n1974 : std_logic_vector (2 downto 0);
  signal n1976 : std_logic;
  signal n1978 : std_logic_vector (1 downto 0);
  signal n1979 : std_logic_vector (1 downto 0);
  signal n1981 : std_logic;
  signal n1982 : std_logic_vector (3 downto 0);
  signal n1985 : std_logic;
  signal n1987 : std_logic_vector (1 downto 0);
  signal n1988 : std_logic_vector (1 downto 0);
  signal n1990 : std_logic_vector (1 downto 0);
  signal n1991 : std_logic_vector (29 downto 0);
  signal n1992 : std_logic_vector (29 downto 0);
  signal n1993 : std_logic_vector (29 downto 0);
  signal n1995 : std_logic_vector (29 downto 0);
  signal n1996 : std_logic_vector (20 downto 0);
  signal n1998 : std_logic_vector (20 downto 0);
  signal n2001 : std_logic_vector (2 downto 0);
  signal n2002 : std_logic_vector (1 downto 0);
  signal n2004 : std_logic;
  signal n2005 : std_logic;
  signal n2006 : std_logic;
  signal n2007 : std_logic_vector (2 downto 0);
  signal n2009 : std_logic_vector (2 downto 0);
  signal n2010 : std_logic;
  signal n2011 : std_logic;
  signal n2012 : std_logic_vector (2 downto 0);
  signal n2014 : std_logic_vector (2 downto 0);
  signal n2015 : std_logic_vector (2 downto 0);
  signal n2016 : std_logic_vector (2 downto 0);
  signal n2017 : std_logic_vector (2 downto 0);
  constant n2019 : std_logic := '0';
  signal n2021 : std_logic_vector (1 downto 0);
  signal n2023 : std_logic;
  signal n2024 : std_logic;
  signal n2025 : std_logic;
  signal pixel_buffer_n2027 : std_logic_vector (7 downto 0);
  signal pixel_buffer_n2028 : std_logic;
  signal n2029 : std_logic_vector (7 downto 0);
  signal pixel_buffer_n2031 : std_logic;
  signal pixel_buffer_c_rd_data : std_logic_vector (7 downto 0);
  signal pixel_buffer_c_rd_valid : std_logic;
  signal pixel_buffer_c_full : std_logic;
  signal pixel_buffer_c_half_full : std_logic;
  signal n2039 : std_logic_vector (55 downto 0);
  signal n2040 : std_logic_vector (55 downto 0);
begin
  color <= pixel_buffer_n2027;
  color_valid <= pixel_buffer_n2028;
  vram_rd_addr <= n1903;
  vram_rd <= n1985;
  vram_rd_access_mode <= n2019;
  n1887 <= bd_h & bd_w & bd_b;
  n1888 <= section_h & section_w & section_y & section_x;
  state <= n2039; -- (signal)
  state_nxt <= n2040; -- (signal)
  pixbuf_half_full <= pixel_buffer_n2031; -- (signal)
  fifo_wr <= n2025; -- (signal)
  n1895 <= not res_n;
  n1903 <= state (52 downto 32);
  n1904 <= state (1 downto 0);
  n1905 <= n1888 (14 downto 0);
  n1906 <= n1888 (29 downto 15);
  n1908 <= n1906 & n1905 & "10";
  n1909 <= state (31 downto 0);
  n1910 <= n1909 when start = '0' else n1908;
  n1912 <= '1' when n1904 = "00" else '0';
  n1913 <= n1887 (31 downto 0);
  n1914 <= state (16 downto 2);
  n1915 <= "00000000000000000" & n1914;  --  uext
  n1916 <= std_logic_vector (unsigned (n1913) + unsigned (n1915));
  n1917 <= state (31 downto 17);
  n1918 <= n1887 (46 downto 32);
  n1919 <= "000000000000000" & n1917;  --  uext
  n1920 <= "000000000000000" & n1918;  --  uext
  n1921 <= std_logic_vector (resize (unsigned (n1919) * unsigned (n1920), 30));
  n1922 <= "00" & n1921;  --  uext
  n1923 <= std_logic_vector (unsigned (n1916) + unsigned (n1922));
  n1924 <= n1923 (20 downto 0);  --  trunc
  n1925 <= not pixbuf_half_full;
  n1927 <= state (1 downto 0);
  n1928 <= n1927 when n1925 = '0' else "11";
  n1930 <= '1' when n1904 = "10" else '0';
  n1931 <= not vram_rd_busy;
  n1933 <= state (16 downto 2);
  n1934 <= n1888 (14 downto 0);
  n1935 <= n1888 (44 downto 30);
  n1936 <= std_logic_vector (unsigned (n1934) + unsigned (n1935));
  n1938 <= std_logic_vector (unsigned (n1936) - unsigned'("000000000000001"));
  n1939 <= '1' when n1933 = n1938 else '0';
  n1940 <= n1888 (14 downto 0);
  n1941 <= state (31 downto 17);
  n1942 <= n1888 (29 downto 15);
  n1943 <= n1888 (59 downto 45);
  n1944 <= std_logic_vector (unsigned (n1942) + unsigned (n1943));
  n1946 <= std_logic_vector (unsigned (n1944) - unsigned'("000000000000001"));
  n1947 <= '1' when n1941 = n1946 else '0';
  n1949 <= state (31 downto 17);
  n1951 <= std_logic_vector (unsigned (n1949) + unsigned'("000000000000001"));
  n1952 <= "10" when n1947 = '0' else "01";
  n1953 <= state (31 downto 17);
  n1954 <= n1951 when n1947 = '0' else n1953;
  n1955 <= state (16 downto 2);
  n1957 <= std_logic_vector (unsigned (n1955) + unsigned'("000000000000001"));
  n1958 <= n1954 & n1940 & n1952;
  n1959 <= n1958 (1 downto 0);
  n1960 <= "10" when n1939 = '0' else n1959;
  n1961 <= n1958 (16 downto 2);
  n1962 <= n1957 when n1939 = '0' else n1961;
  n1963 <= n1958 (31 downto 17);
  n1964 <= state (31 downto 17);
  n1965 <= n1964 when n1939 = '0' else n1963;
  n1968 <= '0' when n1931 = '0' else '1';
  n1969 <= n1965 & n1962 & n1960;
  n1970 <= state (31 downto 0);
  n1971 <= n1970 when n1931 = '0' else n1969;
  n1973 <= '1' when n1904 = "11" else '0';
  n1974 <= state (55 downto 53);
  n1976 <= '1' when n1974 = "000" else '0';
  n1978 <= state (1 downto 0);
  n1979 <= n1978 when n1976 = '0' else "00";
  n1981 <= '1' when n1904 = "01" else '0';
  n1982 <= n1981 & n1973 & n1930 & n1912;
  with n1982 select n1985 <=
    '0' when "1000",
    n1968 when "0100",
    '0' when "0010",
    '0' when "0001",
    'X' when others;
  n1987 <= n1910 (1 downto 0);
  n1988 <= n1971 (1 downto 0);
  with n1982 select n1990 <=
    n1979 when "1000",
    n1988 when "0100",
    n1928 when "0010",
    n1987 when "0001",
    "XX" when others;
  n1991 <= n1910 (31 downto 2);
  n1992 <= n1971 (31 downto 2);
  n1993 <= state (31 downto 2);
  with n1982 select n1995 <=
    n1993 when "1000",
    n1992 when "0100",
    n1993 when "0010",
    n1991 when "0001",
    (29 downto 0 => 'X') when others;
  n1996 <= state (52 downto 32);
  with n1982 select n1998 <=
    n1996 when "1000",
    n1996 when "0100",
    n1924 when "0010",
    n1996 when "0001",
    (20 downto 0 => 'X') when others;
  n2001 <= state (55 downto 53);
  n2002 <= state (1 downto 0);
  n2004 <= '1' when n2002 /= "00" else '0';
  n2005 <= not vram_rd_valid;
  n2006 <= n2005 and n1985;
  n2007 <= state (55 downto 53);
  n2009 <= std_logic_vector (unsigned (n2007) + unsigned'("001"));
  n2010 <= not n1985;
  n2011 <= vram_rd_valid and n2010;
  n2012 <= state (55 downto 53);
  n2014 <= std_logic_vector (unsigned (n2012) - unsigned'("001"));
  n2015 <= n2001 when n2011 = '0' else n2014;
  n2016 <= n2015 when n2006 = '0' else n2009;
  n2017 <= n2001 when n2004 = '0' else n2016;
  n2021 <= state (1 downto 0);
  n2023 <= '1' when n2021 /= "00" else '0';
  n2024 <= n2023 and vram_rd_valid;
  n2025 <= '0' when n2024 = '0' else '1';
  pixel_buffer_n2027 <= pixel_buffer_c_rd_data; -- (signal)
  pixel_buffer_n2028 <= pixel_buffer_c_rd_valid; -- (signal)
  n2029 <= vram_rd_data (7 downto 0);
  pixel_buffer_n2031 <= pixel_buffer_c_half_full; -- (signal)
  pixel_buffer : entity work.fifo_1c1r1w_fwft_8_8 port map (
    clk => clk,
    res_n => res_n,
    rd_ack => color_ack,
    wr_data => n2029,
    wr => fifo_wr,
    rd_data => pixel_buffer_c_rd_data,
    rd_valid => pixel_buffer_c_rd_valid,
    full => open,
    half_full => pixel_buffer_c_half_full);
  process (clk, n1895)
  begin
    if n1895 = '1' then
      n2039 <= "00000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n2039 <= state_nxt;
    end if;
  end process;
  n2040 <= n2017 & n1998 & n1995 & n1990;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pixel_writer_21_16 is
  port (
    clk : in std_logic;
    res_n : in std_logic;
    wr : in std_logic;
    bd_b : in std_logic_vector (31 downto 0);
    bd_w : in std_logic_vector (14 downto 0);
    bd_h : in std_logic_vector (14 downto 0);
    color : in std_logic_vector (7 downto 0);
    position_x : in std_logic_vector (15 downto 0);
    position_y : in std_logic_vector (15 downto 0);
    alpha_mode : in std_logic;
    alpha_color : in std_logic_vector (7 downto 0);
    vram_wr_full : in std_logic;
    wr_in_progress : out std_logic;
    stall : out std_logic;
    oob : out std_logic;
    vram_wr_addr : out std_logic_vector (20 downto 0);
    vram_wr_data : out std_logic_vector (15 downto 0);
    vram_wr : out std_logic;
    vram_wr_access_mode : out std_logic);
end entity pixel_writer_21_16;
architecture ref of pixel_writer_21_16 is
  signal n1793 : std_logic_vector (61 downto 0);
  signal n1794 : std_logic_vector (31 downto 0);
  signal s1 : std_logic_vector (111 downto 0);
  signal s2 : std_logic_vector (29 downto 0);
  signal s2_nxt : std_logic_vector (29 downto 0);
  signal n1800 : std_logic;
  signal n1801 : std_logic;
  signal n1802 : std_logic;
  signal n1804 : std_logic;
  signal n1806 : std_logic;
  signal n1807 : std_logic_vector (15 downto 0);
  signal n1808 : std_logic_vector (15 downto 0);
  signal n1809 : std_logic_vector (111 downto 0);
  signal n1820 : std_logic;
  signal n1821 : std_logic_vector (15 downto 0);
  signal n1823 : std_logic;
  signal n1824 : std_logic_vector (15 downto 0);
  signal n1826 : std_logic_vector (14 downto 0);
  signal n1828 : std_logic_vector (15 downto 0);
  signal n1829 : std_logic;
  signal n1830 : std_logic;
  signal n1831 : std_logic_vector (15 downto 0);
  signal n1833 : std_logic;
  signal n1834 : std_logic;
  signal n1835 : std_logic_vector (15 downto 0);
  signal n1837 : std_logic_vector (14 downto 0);
  signal n1839 : std_logic_vector (15 downto 0);
  signal n1840 : std_logic;
  signal n1841 : std_logic;
  signal n1842 : std_logic;
  signal n1846 : std_logic;
  signal n1848 : std_logic;
  signal n1849 : std_logic;
  signal n1850 : std_logic_vector (7 downto 0);
  signal n1851 : std_logic_vector (7 downto 0);
  signal n1852 : std_logic;
  signal n1853 : std_logic;
  signal n1855 : std_logic;
  signal n1857 : std_logic_vector (31 downto 0);
  signal n1858 : std_logic_vector (15 downto 0);
  signal n1859 : std_logic_vector (31 downto 0);
  signal n1860 : std_logic_vector (31 downto 0);
  signal n1862 : std_logic_vector (14 downto 0);
  signal n1863 : std_logic_vector (15 downto 0);
  signal n1864 : std_logic_vector (30 downto 0);
  signal n1865 : std_logic_vector (30 downto 0);
  signal n1866 : std_logic_vector (30 downto 0);
  signal n1867 : std_logic_vector (31 downto 0);
  signal n1868 : std_logic_vector (31 downto 0);
  signal n1869 : std_logic_vector (20 downto 0);
  signal n1870 : std_logic_vector (7 downto 0);
  signal n1874 : std_logic_vector (7 downto 0);
  constant n1875 : std_logic_vector (15 downto 0) := "0000000000000000";
  signal n1876 : std_logic_vector (7 downto 0);
  signal n1877 : std_logic_vector (20 downto 0);
  signal n1878 : std_logic;
  constant n1880 : std_logic := '0';
  signal n1881 : std_logic_vector (111 downto 0);
  signal n1882 : std_logic_vector (111 downto 0);
  signal n1883 : std_logic_vector (29 downto 0);
  signal n1884 : std_logic_vector (29 downto 0);
  signal n1885 : std_logic_vector (29 downto 0);
  signal n1886 : std_logic_vector (15 downto 0);
begin
  wr_in_progress <= n1802;
  stall <= vram_wr_full;
  oob <= n1846;
  vram_wr_addr <= n1877;
  vram_wr_data <= n1886;
  vram_wr <= n1878;
  vram_wr_access_mode <= n1880;
  n1793 <= bd_h & bd_w & bd_b;
  n1794 <= position_y & position_x;
  s1 <= n1882; -- (signal)
  s2 <= n1884; -- (signal)
  s2_nxt <= n1885; -- (signal)
  n1800 <= s1 (0);
  n1801 <= s2 (0);
  n1802 <= n1800 or n1801;
  n1804 <= not res_n;
  n1806 <= not vram_wr_full;
  n1807 <= n1794 (31 downto 16);
  n1808 <= n1794 (15 downto 0);
  n1809 <= alpha_color & alpha_mode & n1808 & n1807 & color & n1793 & wr;
  n1820 <= s1 (0);
  n1821 <= s1 (102 downto 87);
  n1823 <= '1' when signed (n1821) >= signed'("0000000000000000") else '0';
  n1824 <= s1 (102 downto 87);
  n1826 <= s1 (47 downto 33);
  n1828 <= '0' & n1826;
  n1829 <= '1' when signed (n1824) < signed (n1828) else '0';
  n1830 <= n1829 and n1823;
  n1831 <= s1 (86 downto 71);
  n1833 <= '1' when signed (n1831) >= signed'("0000000000000000") else '0';
  n1834 <= n1833 and n1830;
  n1835 <= s1 (86 downto 71);
  n1837 <= s1 (62 downto 48);
  n1839 <= '0' & n1837;
  n1840 <= '1' when signed (n1835) < signed (n1839) else '0';
  n1841 <= n1840 and n1834;
  n1842 <= not n1841;
  n1846 <= '0' when n1842 = '0' else '1';
  n1848 <= n1820 when n1842 = '0' else '0';
  n1849 <= s1 (103);
  n1850 <= s1 (70 downto 63);
  n1851 <= s1 (111 downto 104);
  n1852 <= '1' when n1850 = n1851 else '0';
  n1853 <= n1852 and n1849;
  n1855 <= n1848 when n1853 = '0' else '0';
  n1857 <= s1 (32 downto 1);
  n1858 <= s1 (102 downto 87);
  n1859 <= "0000000000000000" & n1858;  --  uext
  n1860 <= std_logic_vector (unsigned (n1857) + unsigned (n1859));
  n1862 <= s1 (47 downto 33);
  n1863 <= s1 (86 downto 71);
  n1864 <= "0000000000000000" & n1862;  --  uext
  n1865 <= "000000000000000" & n1863;  --  uext
  n1866 <= std_logic_vector (resize (unsigned (n1864) * unsigned (n1865), 31));
  n1867 <= "0" & n1866;  --  uext
  n1868 <= std_logic_vector (unsigned (n1860) + unsigned (n1867));
  n1869 <= n1868 (20 downto 0);  --  trunc
  n1870 <= s1 (70 downto 63);
  n1874 <= s2 (29 downto 22);
  n1876 <= n1875 (15 downto 8);
  n1877 <= s2 (21 downto 1);
  n1878 <= s2 (0);
  n1881 <= s1 when n1806 = '0' else n1809;
  process (clk, n1804)
  begin
    if n1804 = '1' then
      n1882 <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1882 <= n1881;
    end if;
  end process;
  n1883 <= s2 when n1806 = '0' else s2_nxt;
  process (clk, n1804)
  begin
    if n1804 = '1' then
      n1884 <= "000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1884 <= n1883;
    end if;
  end process;
  n1885 <= n1870 & n1869 & n1855;
  n1886 <= n1876 & n1874;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity gfx_circle_renamed is
  port (
    clk : in std_logic;
    res_n : in std_logic;
    start : in std_logic;
    stall : in std_logic;
    center_x : in std_logic_vector (15 downto 0);
    center_y : in std_logic_vector (15 downto 0);
    radius : in std_logic_vector (14 downto 0);
    busy : out std_logic;
    pixel_valid : out std_logic;
    pixel_x : out std_logic_vector (15 downto 0);
    pixel_y : out std_logic_vector (15 downto 0));
end entity gfx_circle_renamed;
architecture ref of gfx_circle_renamed is
  signal n1521 : std_logic_vector (31 downto 0);
  signal n1524 : std_logic_vector (15 downto 0);
  signal n1525 : std_logic_vector (15 downto 0);
  signal state : std_logic_vector (163 downto 0);
  signal state_nxt : std_logic_vector (163 downto 0);
  signal n1528 : std_logic;
  signal n1531 : std_logic;
  signal n1545 : std_logic_vector (30 downto 0);
  signal n1546 : std_logic_vector (31 downto 0);
  signal n1547 : std_logic_vector (15 downto 0);
  signal n1548 : std_logic_vector (31 downto 0);
  signal n1549 : std_logic_vector (15 downto 0);
  signal n1550 : std_logic_vector (31 downto 0);
  signal n1553 : std_logic_vector (31 downto 0);
  signal n1554 : std_logic_vector (31 downto 0);
  signal n1555 : std_logic_vector (31 downto 0);
  signal n1556 : std_logic_vector (3 downto 0);
  signal n1558 : std_logic_vector (3 downto 0);
  signal n1559 : std_logic_vector (3 downto 0);
  signal n1561 : std_logic;
  signal n1563 : std_logic_vector (31 downto 0);
  signal n1566 : std_logic_vector (31 downto 0);
  signal n1567 : std_logic_vector (31 downto 0);
  signal n1571 : std_logic;
  signal n1573 : std_logic_vector (31 downto 0);
  signal n1576 : std_logic_vector (15 downto 0);
  signal n1579 : std_logic;
  signal n1581 : std_logic_vector (31 downto 0);
  signal n1584 : std_logic_vector (15 downto 0);
  signal n1587 : std_logic;
  signal n1589 : std_logic_vector (31 downto 0);
  signal n1592 : std_logic_vector (15 downto 0);
  signal n1595 : std_logic;
  signal n1597 : std_logic_vector (31 downto 0);
  signal n1600 : std_logic_vector (15 downto 0);
  signal n1603 : std_logic;
  signal n1604 : std_logic_vector (31 downto 0);
  signal n1605 : std_logic_vector (31 downto 0);
  signal n1606 : std_logic;
  signal n1607 : std_logic_vector (31 downto 0);
  signal n1609 : std_logic;
  signal n1610 : std_logic_vector (31 downto 0);
  signal n1612 : std_logic_vector (31 downto 0);
  signal n1614 : std_logic_vector (31 downto 0);
  signal n1615 : std_logic_vector (31 downto 0);
  signal n1616 : std_logic_vector (31 downto 0);
  signal n1617 : std_logic_vector (31 downto 0);
  signal n1618 : std_logic_vector (31 downto 0);
  signal n1619 : std_logic_vector (31 downto 0);
  signal n1620 : std_logic_vector (31 downto 0);
  signal n1622 : std_logic_vector (31 downto 0);
  signal n1624 : std_logic_vector (31 downto 0);
  signal n1625 : std_logic_vector (31 downto 0);
  signal n1627 : std_logic_vector (31 downto 0);
  signal n1630 : std_logic_vector (163 downto 0);
  signal n1631 : std_logic_vector (3 downto 0);
  signal n1632 : std_logic_vector (3 downto 0);
  signal n1633 : std_logic_vector (159 downto 0);
  signal n1634 : std_logic_vector (159 downto 0);
  signal n1635 : std_logic_vector (159 downto 0);
  signal n1640 : std_logic;
  signal n1642 : std_logic_vector (31 downto 0);
  signal n1643 : std_logic_vector (31 downto 0);
  signal n1644 : std_logic_vector (31 downto 0);
  signal n1645 : std_logic_vector (31 downto 0);
  signal n1648 : std_logic_vector (15 downto 0);
  signal n1649 : std_logic_vector (15 downto 0);
  signal n1652 : std_logic;
  signal n1654 : std_logic_vector (31 downto 0);
  signal n1655 : std_logic_vector (31 downto 0);
  signal n1656 : std_logic_vector (31 downto 0);
  signal n1657 : std_logic_vector (31 downto 0);
  signal n1660 : std_logic_vector (15 downto 0);
  signal n1661 : std_logic_vector (15 downto 0);
  signal n1664 : std_logic;
  signal n1666 : std_logic_vector (31 downto 0);
  signal n1667 : std_logic_vector (31 downto 0);
  signal n1668 : std_logic_vector (31 downto 0);
  signal n1669 : std_logic_vector (31 downto 0);
  signal n1672 : std_logic_vector (15 downto 0);
  signal n1673 : std_logic_vector (15 downto 0);
  signal n1676 : std_logic;
  signal n1678 : std_logic_vector (31 downto 0);
  signal n1679 : std_logic_vector (31 downto 0);
  signal n1680 : std_logic_vector (31 downto 0);
  signal n1681 : std_logic_vector (31 downto 0);
  signal n1684 : std_logic_vector (15 downto 0);
  signal n1685 : std_logic_vector (15 downto 0);
  signal n1688 : std_logic;
  signal n1690 : std_logic_vector (31 downto 0);
  signal n1691 : std_logic_vector (31 downto 0);
  signal n1692 : std_logic_vector (31 downto 0);
  signal n1693 : std_logic_vector (31 downto 0);
  signal n1696 : std_logic_vector (15 downto 0);
  signal n1697 : std_logic_vector (15 downto 0);
  signal n1700 : std_logic;
  signal n1702 : std_logic_vector (31 downto 0);
  signal n1703 : std_logic_vector (31 downto 0);
  signal n1704 : std_logic_vector (31 downto 0);
  signal n1705 : std_logic_vector (31 downto 0);
  signal n1708 : std_logic_vector (15 downto 0);
  signal n1709 : std_logic_vector (15 downto 0);
  signal n1712 : std_logic;
  signal n1714 : std_logic_vector (31 downto 0);
  signal n1715 : std_logic_vector (31 downto 0);
  signal n1716 : std_logic_vector (31 downto 0);
  signal n1717 : std_logic_vector (31 downto 0);
  signal n1720 : std_logic_vector (15 downto 0);
  signal n1721 : std_logic_vector (15 downto 0);
  signal n1724 : std_logic;
  signal n1726 : std_logic_vector (31 downto 0);
  signal n1727 : std_logic_vector (31 downto 0);
  signal n1728 : std_logic_vector (31 downto 0);
  signal n1729 : std_logic_vector (31 downto 0);
  signal n1732 : std_logic_vector (15 downto 0);
  signal n1733 : std_logic_vector (15 downto 0);
  signal n1736 : std_logic;
  signal n1737 : std_logic_vector (14 downto 0);
  signal n1740 : std_logic;
  signal n1755 : std_logic;
  signal n1757 : std_logic_vector (15 downto 0);
  signal n1758 : std_logic_vector (15 downto 0);
  signal n1759 : std_logic_vector (3 downto 0);
  signal n1760 : std_logic_vector (3 downto 0);
  signal n1761 : std_logic_vector (31 downto 0);
  signal n1762 : std_logic_vector (31 downto 0);
  signal n1763 : std_logic_vector (31 downto 0);
  signal n1764 : std_logic_vector (31 downto 0);
  signal n1765 : std_logic_vector (31 downto 0);
  signal n1766 : std_logic_vector (31 downto 0);
  signal n1767 : std_logic_vector (31 downto 0);
  signal n1768 : std_logic_vector (31 downto 0);
  signal n1769 : std_logic_vector (31 downto 0);
  signal n1770 : std_logic_vector (31 downto 0);
  signal n1771 : std_logic_vector (31 downto 0);
  signal n1772 : std_logic_vector (31 downto 0);
  signal n1773 : std_logic_vector (31 downto 0);
  signal n1774 : std_logic_vector (31 downto 0);
  signal n1775 : std_logic_vector (31 downto 0);
  signal n1785 : std_logic;
  signal n1787 : std_logic_vector (163 downto 0);
  signal n1788 : std_logic_vector (163 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  signal n1789 : std_logic_vector (163 downto 0);
  signal n1790 : std_logic_vector (31 downto 0);
begin
  busy <= n1740;
  pixel_valid <= n1785;
  pixel_x <= n1524;
  pixel_y <= n1525;
  n1521 <= center_y & center_x;
  n1524 <= n1790 (15 downto 0);
  n1525 <= n1790 (31 downto 16);
  state <= n1788; -- (isignal)
  state_nxt <= n1789; -- (signal)
  n1528 <= not res_n;
  n1531 <= '1' when unsigned'(1 => stall) <= unsigned'("0") else '0';
  n1545 <= "0000000000000000" & radius;  --  uext
  n1546 <= "0" & n1545;  --  uext
  n1547 <= n1521 (15 downto 0);
  n1548 <= std_logic_vector (resize (signed (n1547), 32));  --  sext
  n1549 <= n1521 (31 downto 16);
  n1550 <= std_logic_vector (resize (signed (n1549), 32));  --  sext
  n1553 <= state (67 downto 36);
  n1554 <= state (99 downto 68);
  n1555 <= state (35 downto 4);
  n1556 <= state (3 downto 0);
  n1558 <= state (3 downto 0);
  n1559 <= n1558 when start = '0' else "0001";
  n1561 <= '1' when n1556 = "0000" else '0';
  n1563 <= std_logic_vector (unsigned'("00000000000000000000000000000001") - unsigned (n1546));
  n1566 <= std_logic_vector (resize (signed'("00000000000000000000000000000010") * signed (n1546), 32));
  n1567 <= std_logic_vector(-signed (n1566));
  n1571 <= '1' when n1556 = "0001" else '0';
  n1573 <= std_logic_vector (unsigned (n1550) + unsigned (n1546));
  n1576 <= n1573 (15 downto 0);  --  trunc
  n1579 <= '1' when n1556 = "0011" else '0';
  n1581 <= std_logic_vector (unsigned (n1550) - unsigned (n1546));
  n1584 <= n1581 (15 downto 0);  --  trunc
  n1587 <= '1' when n1556 = "0100" else '0';
  n1589 <= std_logic_vector (unsigned (n1548) + unsigned (n1546));
  n1592 <= n1589 (15 downto 0);  --  trunc
  n1595 <= '1' when n1556 = "0101" else '0';
  n1597 <= std_logic_vector (unsigned (n1548) - unsigned (n1546));
  n1600 <= n1597 (15 downto 0);  --  trunc
  n1603 <= '1' when n1556 = "0110" else '0';
  n1604 <= state (131 downto 100);
  n1605 <= state (163 downto 132);
  n1606 <= '1' when signed (n1604) < signed (n1605) else '0';
  n1607 <= state (35 downto 4);
  n1609 <= '1' when signed (n1607) >= signed'("00000000000000000000000000000000") else '0';
  n1610 <= state (163 downto 132);
  n1612 <= std_logic_vector (unsigned (n1610) - unsigned'("00000000000000000000000000000001"));
  n1614 <= std_logic_vector (unsigned (n1554) + unsigned'("00000000000000000000000000000010"));
  n1615 <= std_logic_vector (unsigned (n1555) + unsigned (n1614));
  n1616 <= state (163 downto 132);
  n1617 <= n1616 when n1609 = '0' else n1612;
  n1618 <= n1554 when n1609 = '0' else n1614;
  n1619 <= n1555 when n1609 = '0' else n1615;
  n1620 <= state (131 downto 100);
  n1622 <= std_logic_vector (unsigned (n1620) + unsigned'("00000000000000000000000000000001"));
  n1624 <= std_logic_vector (unsigned (n1553) + unsigned'("00000000000000000000000000000010"));
  n1625 <= std_logic_vector (unsigned (n1619) + unsigned (n1624));
  n1627 <= std_logic_vector (unsigned (n1625) + unsigned'("00000000000000000000000000000001"));
  n1630 <= n1617 & n1622 & n1618 & n1624 & n1627 & "0111";
  n1631 <= n1630 (3 downto 0);
  n1632 <= "0000" when n1606 = '0' else n1631;
  n1633 <= n1630 (163 downto 4);
  n1634 <= state (163 downto 4);
  n1635 <= n1634 when n1606 = '0' else n1633;
  n1640 <= '1' when n1556 = "0010" else '0';
  n1642 <= state (131 downto 100);
  n1643 <= std_logic_vector (unsigned (n1548) + unsigned (n1642));
  n1644 <= state (163 downto 132);
  n1645 <= std_logic_vector (unsigned (n1550) + unsigned (n1644));
  n1648 <= n1643 (15 downto 0);  --  trunc
  n1649 <= n1645 (15 downto 0);  --  trunc
  n1652 <= '1' when n1556 = "0111" else '0';
  n1654 <= state (131 downto 100);
  n1655 <= std_logic_vector (unsigned (n1548) - unsigned (n1654));
  n1656 <= state (163 downto 132);
  n1657 <= std_logic_vector (unsigned (n1550) + unsigned (n1656));
  n1660 <= n1655 (15 downto 0);  --  trunc
  n1661 <= n1657 (15 downto 0);  --  trunc
  n1664 <= '1' when n1556 = "1000" else '0';
  n1666 <= state (131 downto 100);
  n1667 <= std_logic_vector (unsigned (n1548) + unsigned (n1666));
  n1668 <= state (163 downto 132);
  n1669 <= std_logic_vector (unsigned (n1550) - unsigned (n1668));
  n1672 <= n1667 (15 downto 0);  --  trunc
  n1673 <= n1669 (15 downto 0);  --  trunc
  n1676 <= '1' when n1556 = "1001" else '0';
  n1678 <= state (131 downto 100);
  n1679 <= std_logic_vector (unsigned (n1548) - unsigned (n1678));
  n1680 <= state (163 downto 132);
  n1681 <= std_logic_vector (unsigned (n1550) - unsigned (n1680));
  n1684 <= n1679 (15 downto 0);  --  trunc
  n1685 <= n1681 (15 downto 0);  --  trunc
  n1688 <= '1' when n1556 = "1010" else '0';
  n1690 <= state (163 downto 132);
  n1691 <= std_logic_vector (unsigned (n1548) + unsigned (n1690));
  n1692 <= state (131 downto 100);
  n1693 <= std_logic_vector (unsigned (n1550) + unsigned (n1692));
  n1696 <= n1691 (15 downto 0);  --  trunc
  n1697 <= n1693 (15 downto 0);  --  trunc
  n1700 <= '1' when n1556 = "1011" else '0';
  n1702 <= state (163 downto 132);
  n1703 <= std_logic_vector (unsigned (n1548) - unsigned (n1702));
  n1704 <= state (131 downto 100);
  n1705 <= std_logic_vector (unsigned (n1550) + unsigned (n1704));
  n1708 <= n1703 (15 downto 0);  --  trunc
  n1709 <= n1705 (15 downto 0);  --  trunc
  n1712 <= '1' when n1556 = "1100" else '0';
  n1714 <= state (163 downto 132);
  n1715 <= std_logic_vector (unsigned (n1548) + unsigned (n1714));
  n1716 <= state (131 downto 100);
  n1717 <= std_logic_vector (unsigned (n1550) - unsigned (n1716));
  n1720 <= n1715 (15 downto 0);  --  trunc
  n1721 <= n1717 (15 downto 0);  --  trunc
  n1724 <= '1' when n1556 = "1101" else '0';
  n1726 <= state (163 downto 132);
  n1727 <= std_logic_vector (unsigned (n1548) - unsigned (n1726));
  n1728 <= state (131 downto 100);
  n1729 <= std_logic_vector (unsigned (n1550) - unsigned (n1728));
  n1732 <= n1727 (15 downto 0);  --  trunc
  n1733 <= n1729 (15 downto 0);  --  trunc
  n1736 <= '1' when n1556 = "1110" else '0';
  n1737 <= n1736 & n1724 & n1712 & n1700 & n1688 & n1676 & n1664 & n1652 & n1640 & n1603 & n1595 & n1587 & n1579 & n1571 & n1561;
  with n1737 select n1740 <=
    '1' when "100000000000000",
    '1' when "010000000000000",
    '1' when "001000000000000",
    '1' when "000100000000000",
    '1' when "000010000000000",
    '1' when "000001000000000",
    '1' when "000000100000000",
    '1' when "000000010000000",
    '1' when "000000001000000",
    '1' when "000000000100000",
    '1' when "000000000010000",
    '1' when "000000000001000",
    '1' when "000000000000100",
    '1' when "000000000000010",
    '0' when "000000000000001",
    '1' when others;
  with n1737 select n1755 <=
    '1' when "100000000000000",
    '1' when "010000000000000",
    '1' when "001000000000000",
    '1' when "000100000000000",
    '1' when "000010000000000",
    '1' when "000001000000000",
    '1' when "000000100000000",
    '1' when "000000010000000",
    '0' when "000000001000000",
    '1' when "000000000100000",
    '1' when "000000000010000",
    '1' when "000000000001000",
    '1' when "000000000000100",
    '0' when "000000000000010",
    '0' when "000000000000001",
    '0' when others;
  with n1737 select n1757 <=
    n1732 when "100000000000000",
    n1720 when "010000000000000",
    n1708 when "001000000000000",
    n1696 when "000100000000000",
    n1684 when "000010000000000",
    n1672 when "000001000000000",
    n1660 when "000000100000000",
    n1648 when "000000010000000",
    "0000000000000000" when "000000001000000",
    n1600 when "000000000100000",
    n1592 when "000000000010000",
    n1547 when "000000000001000",
    n1547 when "000000000000100",
    "0000000000000000" when "000000000000010",
    "0000000000000000" when "000000000000001",
    "0000000000000000" when others;
  with n1737 select n1758 <=
    n1733 when "100000000000000",
    n1721 when "010000000000000",
    n1709 when "001000000000000",
    n1697 when "000100000000000",
    n1685 when "000010000000000",
    n1673 when "000001000000000",
    n1661 when "000000100000000",
    n1649 when "000000010000000",
    "0000000000000000" when "000000001000000",
    n1549 when "000000000100000",
    n1549 when "000000000010000",
    n1584 when "000000000001000",
    n1576 when "000000000000100",
    "0000000000000000" when "000000000000010",
    "0000000000000000" when "000000000000001",
    "0000000000000000" when others;
  n1759 <= state (3 downto 0);
  with n1737 select n1760 <=
    "0010" when "100000000000000",
    "1110" when "010000000000000",
    "1101" when "001000000000000",
    "1100" when "000100000000000",
    "1011" when "000010000000000",
    "1010" when "000001000000000",
    "1001" when "000000100000000",
    "1000" when "000000010000000",
    n1632 when "000000001000000",
    "0010" when "000000000100000",
    "0110" when "000000000010000",
    "0101" when "000000000001000",
    "0100" when "000000000000100",
    "0011" when "000000000000010",
    n1559 when "000000000000001",
    n1759 when others;
  n1761 <= n1635 (31 downto 0);
  n1762 <= state (35 downto 4);
  with n1737 select n1763 <=
    n1762 when "100000000000000",
    n1762 when "010000000000000",
    n1762 when "001000000000000",
    n1762 when "000100000000000",
    n1762 when "000010000000000",
    n1762 when "000001000000000",
    n1762 when "000000100000000",
    n1762 when "000000010000000",
    n1761 when "000000001000000",
    n1762 when "000000000100000",
    n1762 when "000000000010000",
    n1762 when "000000000001000",
    n1762 when "000000000000100",
    n1563 when "000000000000010",
    n1762 when "000000000000001",
    n1762 when others;
  n1764 <= n1635 (63 downto 32);
  n1765 <= state (67 downto 36);
  with n1737 select n1766 <=
    n1765 when "100000000000000",
    n1765 when "010000000000000",
    n1765 when "001000000000000",
    n1765 when "000100000000000",
    n1765 when "000010000000000",
    n1765 when "000001000000000",
    n1765 when "000000100000000",
    n1765 when "000000010000000",
    n1764 when "000000001000000",
    n1765 when "000000000100000",
    n1765 when "000000000010000",
    n1765 when "000000000001000",
    n1765 when "000000000000100",
    "00000000000000000000000000000000" when "000000000000010",
    n1765 when "000000000000001",
    n1765 when others;
  n1767 <= n1635 (95 downto 64);
  n1768 <= state (99 downto 68);
  with n1737 select n1769 <=
    n1768 when "100000000000000",
    n1768 when "010000000000000",
    n1768 when "001000000000000",
    n1768 when "000100000000000",
    n1768 when "000010000000000",
    n1768 when "000001000000000",
    n1768 when "000000100000000",
    n1768 when "000000010000000",
    n1767 when "000000001000000",
    n1768 when "000000000100000",
    n1768 when "000000000010000",
    n1768 when "000000000001000",
    n1768 when "000000000000100",
    n1567 when "000000000000010",
    n1768 when "000000000000001",
    n1768 when others;
  n1770 <= n1635 (127 downto 96);
  n1771 <= state (131 downto 100);
  with n1737 select n1772 <=
    n1771 when "100000000000000",
    n1771 when "010000000000000",
    n1771 when "001000000000000",
    n1771 when "000100000000000",
    n1771 when "000010000000000",
    n1771 when "000001000000000",
    n1771 when "000000100000000",
    n1771 when "000000010000000",
    n1770 when "000000001000000",
    n1771 when "000000000100000",
    n1771 when "000000000010000",
    n1771 when "000000000001000",
    n1771 when "000000000000100",
    "00000000000000000000000000000000" when "000000000000010",
    n1771 when "000000000000001",
    n1771 when others;
  n1773 <= n1635 (159 downto 128);
  n1774 <= state (163 downto 132);
  with n1737 select n1775 <=
    n1774 when "100000000000000",
    n1774 when "010000000000000",
    n1774 when "001000000000000",
    n1774 when "000100000000000",
    n1774 when "000010000000000",
    n1774 when "000001000000000",
    n1774 when "000000100000000",
    n1774 when "000000010000000",
    n1773 when "000000001000000",
    n1774 when "000000000100000",
    n1774 when "000000000010000",
    n1774 when "000000000001000",
    n1774 when "000000000000100",
    n1546 when "000000000000010",
    n1774 when "000000000000001",
    n1774 when others;
  n1785 <= n1755 when stall = '0' else '0';
  n1787 <= state when n1531 = '0' else state_nxt;
  process (clk, n1528)
  begin
    if n1528 = '1' then
      n1788 <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1788 <= n1787;
    end if;
  end process;
  n1789 <= n1775 & n1772 & n1769 & n1766 & n1763 & n1760;
  n1790 <= n1758 & n1757;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity dp_ram_1c1r1w_3_62 is
  port (
    clk : in std_logic;
    rd1_addr : in std_logic_vector (2 downto 0);
    rd1 : in std_logic;
    wr2_addr : in std_logic_vector (2 downto 0);
    wr2_data : in std_logic_vector (61 downto 0);
    wr2 : in std_logic;
    rd1_data : out std_logic_vector (61 downto 0));
end entity dp_ram_1c1r1w_3_62;
architecture ref of dp_ram_1c1r1w_3_62 is
  signal n1515 : std_logic_vector (61 downto 0);
  signal n1516 : std_logic_vector (61 downto 0) := "00000000000000000000000000000000000000000000000000000000000000";
  signal n1518 : std_logic_vector (61 downto 0);
begin
  rd1_data <= n1516;
  n1515 <= n1516 when rd1 = '0' else n1518;
  process (clk)
  begin
    if rising_edge (clk) then
      n1516 <= n1515;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (61 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n1518 <= ram(to_integer (unsigned (rd1_addr)));
    if rising_edge (clk) and (wr2 = '1') then
      ram (to_integer (unsigned (wr2_addr))) := wr2_data;
    end if;
  end process;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
architecture ref of rasterizer is
  signal wrap_clk: std_logic;
  signal wrap_res_n: std_logic;
  signal wrap_vram_wr_full: std_logic;
  signal wrap_vram_wr_emtpy: std_logic;
  subtype typwrap_vram_rd_data is std_logic_vector (15 downto 0);
  signal wrap_vram_rd_data: typwrap_vram_rd_data;
  signal wrap_vram_rd_busy: std_logic;
  signal wrap_vram_rd_valid: std_logic;
  signal wrap_fr_base_addr_req: std_logic;
  subtype typwrap_gcf_data is std_logic_vector (15 downto 0);
  signal wrap_gcf_data: typwrap_gcf_data;
  signal wrap_gcf_empty: std_logic;
  subtype typwrap_vram_wr_addr is std_logic_vector (20 downto 0);
  signal wrap_vram_wr_addr: typwrap_vram_wr_addr;
  subtype typwrap_vram_wr_data is std_logic_vector (15 downto 0);
  signal wrap_vram_wr_data: typwrap_vram_wr_data;
  signal wrap_vram_wr: std_logic;
  signal wrap_vram_wr_access_mode: std_logic;
  subtype typwrap_vram_rd_addr is std_logic_vector (20 downto 0);
  signal wrap_vram_rd_addr: typwrap_vram_rd_addr;
  signal wrap_vram_rd: std_logic;
  signal wrap_vram_rd_access_mode: std_logic;
  subtype typwrap_fr_base_addr is std_logic_vector (20 downto 0);
  signal wrap_fr_base_addr: typwrap_fr_base_addr;
  signal wrap_gcf_rd: std_logic;
  subtype typwrap_rd_data is std_logic_vector (15 downto 0);
  signal wrap_rd_data: typwrap_rd_data;
  signal wrap_rd_valid: std_logic;
  signal wrap_frame_sync: std_logic;
  signal operand_buffer : std_logic_vector (63 downto 0);
  signal state : std_logic_vector (309 downto 0);
  signal state_nxt : std_logic_vector (309 downto 0);
  signal bdt_wr : std_logic;
  signal bdt_rd : std_logic;
  signal stall : std_logic;
  signal pw_wr : std_logic;
  signal pw_color : std_logic_vector (7 downto 0);
  signal pw_position : std_logic_vector (31 downto 0);
  signal pw_alpha_mode : std_logic;
  signal pw_oob : std_logic;
  signal pw_vram_wr_addr : std_logic_vector (20 downto 0);
  signal pw_vram_wr_data : std_logic_vector (15 downto 0);
  signal pw_vram_wr : std_logic;
  signal pw_vram_wr_access_mode : std_logic;
  signal direct_vram_wr : std_logic;
  signal direct_vram_wr_addr : std_logic_vector (20 downto 0);
  signal direct_vram_wr_data : std_logic_vector (15 downto 0);
  signal direct_vram_wr_access_mode : std_logic;
  signal pr_start : std_logic;
  signal pr_color : std_logic_vector (7 downto 0);
  signal pr_color_valid : std_logic;
  signal pr_color_ack : std_logic;
  signal pr_vram_rd_addr : std_logic_vector (20 downto 0);
  signal pr_vram_rd : std_logic;
  signal pr_vram_rd_access_mode : std_logic;
  signal circle_start : std_logic;
  signal circle_busy : std_logic;
  signal circle_pixel_valid : std_logic;
  signal circle_pixel : std_logic_vector (31 downto 0);
  signal instr_color : std_logic_vector (7 downto 0);
  signal current_instr : std_logic_vector (15 downto 0);
  signal bdt_bmpidx : std_logic_vector (61 downto 0);
  signal dx : std_logic_vector (15 downto 0);
  signal dy : std_logic_vector (15 downto 0);
  signal radius : std_logic_vector (14 downto 0);
  signal bb_section : std_logic_vector (59 downto 0);
  signal addrlo : std_logic_vector (15 downto 0);
  signal addrhi : std_logic_vector (4 downto 0);
  signal data : std_logic_vector (15 downto 0);
  signal n : std_logic_vector (15 downto 0);
  signal n12 : std_logic_vector (15 downto 0);
  signal n13 : std_logic_vector (15 downto 0);
  signal n14 : std_logic_vector (15 downto 0);
  signal n15 : std_logic_vector (14 downto 0);
  signal n16 : std_logic_vector (59 downto 0);
  signal n19 : std_logic_vector (15 downto 0);
  signal n20 : std_logic_vector (4 downto 0);
  signal n21 : std_logic_vector (15 downto 0);
  signal n22 : std_logic_vector (15 downto 0);
  signal n28 : std_logic_vector (4 downto 0);
  signal n29 : std_logic_vector (15 downto 0);
  signal n30 : std_logic_vector (4 downto 0);
  signal n32 : std_logic;
  signal n33 : std_logic_vector (15 downto 0);
  signal n34 : std_logic_vector (4 downto 0);
  signal n35 : std_logic_vector (15 downto 0);
  signal n37 : std_logic;
  signal n38 : std_logic_vector (15 downto 0);
  signal n39 : std_logic_vector (4 downto 0);
  signal n40 : std_logic_vector (15 downto 0);
  signal n42 : std_logic;
  signal n43 : std_logic_vector (15 downto 0);
  signal n44 : std_logic_vector (15 downto 0);
  signal n45 : std_logic_vector (4 downto 0);
  signal n46 : std_logic_vector (15 downto 0);
  signal n48 : std_logic;
  signal n49 : std_logic_vector (3 downto 0);
  signal n50 : std_logic_vector (15 downto 0);
  signal n51 : std_logic_vector (4 downto 0);
  signal n52 : std_logic_vector (15 downto 0);
  signal n53 : std_logic_vector (15 downto 0);
  signal operands_buffer_operand_buffer_int : std_logic_vector (47 downto 0);
  signal n57 : std_logic_vector (15 downto 0);
  signal n58 : std_logic_vector (15 downto 0);
  signal n59 : std_logic_vector (15 downto 0);
  signal n62 : std_logic;
  signal n67 : std_logic_vector (15 downto 0);
  signal n68 : std_logic_vector (15 downto 0);
  signal n69 : std_logic_vector (47 downto 0);
  signal n72 : std_logic_vector (47 downto 0);
  signal n75 : std_logic_vector (47 downto 0);
  signal n76 : std_logic_vector (47 downto 0);
  signal bdt_block_bdt_bmpidx_int : std_logic_vector (61 downto 0);
  signal bdt_block_bdt_wr_data : std_logic_vector (61 downto 0);
  signal n77 : std_logic_vector (15 downto 0);
  signal n78 : std_logic_vector (15 downto 0);
  signal n79 : std_logic_vector (31 downto 0);
  signal n80 : std_logic_vector (14 downto 0);
  signal n81 : std_logic_vector (14 downto 0);
  signal n87 : std_logic_vector (2 downto 0);
  signal bdt_block_bitmaps_n88 : std_logic_vector (61 downto 0);
  signal n95 : std_logic_vector (2 downto 0);
  signal n96 : std_logic_vector (31 downto 0);
  signal n97 : std_logic_vector (14 downto 0);
  signal n98 : std_logic_vector (46 downto 0);
  signal n99 : std_logic_vector (14 downto 0);
  signal n100 : std_logic_vector (61 downto 0);
  signal bdt_block_bitmaps_c_rd1_data : std_logic_vector (61 downto 0);
  signal n103 : std_logic_vector (31 downto 0);
  signal n104 : std_logic_vector (14 downto 0);
  signal n105 : std_logic_vector (14 downto 0);
  signal n106 : std_logic_vector (61 downto 0);
  signal n107 : std_logic_vector (15 downto 0);
  signal n108 : std_logic_vector (20 downto 0);
  signal n111 : std_logic;
  signal n112 : std_logic;
  signal n113 : std_logic_vector (7 downto 0);
  signal n114 : std_logic_vector (7 downto 0);
  signal n115 : std_logic_vector (7 downto 0);
  signal n118 : std_logic;
  signal n125 : std_logic_vector (5 downto 0);
  signal n126 : std_logic;
  signal n130 : std_logic;
  signal n131 : std_logic_vector (5 downto 0);
  signal n132 : std_logic_vector (5 downto 0);
  signal n134 : std_logic;
  signal n142 : std_logic_vector (4 downto 0);
  signal n149 : std_logic;
  signal n152 : std_logic;
  signal n155 : std_logic;
  signal n158 : std_logic;
  signal n161 : std_logic;
  signal n164 : std_logic;
  signal n167 : std_logic;
  signal n170 : std_logic;
  signal n173 : std_logic;
  signal n176 : std_logic;
  signal n179 : std_logic;
  signal n182 : std_logic;
  signal n185 : std_logic;
  signal n188 : std_logic;
  signal n191 : std_logic;
  signal n194 : std_logic;
  signal n197 : std_logic;
  signal n200 : std_logic;
  signal n203 : std_logic;
  signal n206 : std_logic;
  signal n209 : std_logic;
  signal n212 : std_logic;
  signal n214 : std_logic_vector (21 downto 0);
  signal n215 : std_logic_vector (31 downto 0);
  signal n217 : std_logic;
  signal n219 : std_logic;
  signal n223 : std_logic;
  signal n227 : std_logic;
  signal n231 : std_logic;
  signal n235 : std_logic;
  signal n236 : std_logic_vector (5 downto 0);
  signal n237 : std_logic_vector (5 downto 0);
  signal n238 : std_logic_vector (1 downto 0);
  signal n239 : std_logic_vector (1 downto 0);
  signal n245 : std_logic_vector (4 downto 0);
  signal n247 : std_logic;
  signal n250 : std_logic;
  signal n253 : std_logic;
  signal n256 : std_logic;
  signal n259 : std_logic;
  signal n260 : std_logic;
  signal n261 : std_logic;
  signal n262 : std_logic_vector (7 downto 0);
  signal n263 : std_logic_vector (7 downto 0);
  signal n264 : std_logic_vector (7 downto 0);
  signal n265 : std_logic_vector (7 downto 0);
  signal n266 : std_logic_vector (7 downto 0);
  signal n267 : std_logic_vector (7 downto 0);
  signal n270 : std_logic;
  signal n273 : std_logic;
  signal n276 : std_logic;
  signal n277 : std_logic;
  signal n278 : std_logic;
  signal n280 : std_logic_vector (15 downto 0);
  signal n281 : std_logic_vector (9 downto 0);
  signal n282 : std_logic_vector (15 downto 0);
  signal n283 : std_logic_vector (15 downto 0);
  signal n285 : std_logic_vector (15 downto 0);
  signal n286 : std_logic_vector (9 downto 0);
  signal n287 : std_logic_vector (15 downto 0);
  signal n288 : std_logic_vector (15 downto 0);
  signal n289 : std_logic_vector (15 downto 0);
  signal n290 : std_logic_vector (15 downto 0);
  signal n291 : std_logic_vector (15 downto 0);
  signal n292 : std_logic_vector (15 downto 0);
  signal n295 : std_logic;
  signal n298 : std_logic;
  signal n299 : std_logic_vector (7 downto 0);
  signal n305 : std_logic_vector (1 downto 0);
  signal n308 : std_logic;
  signal n311 : std_logic;
  signal n312 : std_logic_vector (11 downto 0);
  signal n313 : std_logic_vector (5 downto 0);
  signal n314 : std_logic_vector (1 downto 0);
  signal n315 : std_logic_vector (15 downto 0);
  signal n316 : std_logic_vector (15 downto 0);
  signal n317 : std_logic_vector (15 downto 0);
  signal n318 : std_logic_vector (15 downto 0);
  signal n319 : std_logic_vector (7 downto 0);
  signal n320 : std_logic_vector (7 downto 0);
  signal n321 : std_logic_vector (7 downto 0);
  signal n322 : std_logic_vector (7 downto 0);
  signal n323 : std_logic_vector (7 downto 0);
  signal n324 : std_logic_vector (7 downto 0);
  signal n325 : std_logic_vector (1 downto 0);
  signal n326 : std_logic_vector (1 downto 0);
  signal n332 : std_logic_vector (4 downto 0);
  signal n334 : std_logic;
  signal n336 : std_logic;
  signal n337 : std_logic;
  signal n339 : std_logic;
  signal n340 : std_logic;
  signal n342 : std_logic;
  signal n343 : std_logic;
  signal n345 : std_logic;
  signal n346 : std_logic;
  signal n349 : std_logic;
  signal n351 : std_logic;
  signal n352 : std_logic;
  signal n353 : std_logic_vector (1 downto 0);
  signal n355 : std_logic;
  signal n357 : std_logic_vector (1 downto 0);
  signal n359 : std_logic_vector (1 downto 0);
  signal n361 : std_logic_vector (5 downto 0);
  signal n362 : std_logic_vector (1 downto 0);
  signal n363 : std_logic_vector (1 downto 0);
  signal n366 : std_logic;
  signal n367 : std_logic_vector (5 downto 0);
  signal n368 : std_logic_vector (5 downto 0);
  signal n369 : std_logic_vector (1 downto 0);
  signal n370 : std_logic_vector (1 downto 0);
  signal n372 : std_logic;
  signal n379 : std_logic_vector (4 downto 0);
  signal n382 : std_logic;
  signal n385 : std_logic;
  signal n388 : std_logic;
  signal n391 : std_logic;
  signal n394 : std_logic;
  signal n397 : std_logic;
  signal n400 : std_logic;
  signal n403 : std_logic;
  signal n406 : std_logic;
  signal n407 : std_logic;
  signal n408 : std_logic;
  signal n409 : std_logic_vector (15 downto 0);
  signal n410 : std_logic_vector (15 downto 0);
  signal n412 : std_logic_vector (15 downto 0);
  signal n413 : std_logic_vector (15 downto 0);
  signal n414 : std_logic_vector (15 downto 0);
  signal n416 : std_logic_vector (15 downto 0);
  signal n417 : std_logic_vector (15 downto 0);
  signal n418 : std_logic_vector (15 downto 0);
  signal n419 : std_logic_vector (31 downto 0);
  signal n420 : std_logic_vector (31 downto 0);
  signal n421 : std_logic_vector (31 downto 0);
  signal n424 : std_logic;
  signal n426 : std_logic_vector (9 downto 0);
  signal n427 : std_logic_vector (5 downto 0);
  signal n428 : std_logic_vector (31 downto 0);
  signal n429 : std_logic_vector (31 downto 0);
  signal n432 : std_logic;
  signal n434 : std_logic;
  signal n436 : std_logic_vector (9 downto 0);
  signal n437 : std_logic_vector (14 downto 0);
  signal n439 : std_logic_vector (5 downto 0);
  signal n440 : std_logic_vector (14 downto 0);
  signal n441 : std_logic_vector (14 downto 0);
  signal n443 : std_logic;
  signal n445 : std_logic_vector (15 downto 0);
  signal n446 : std_logic_vector (14 downto 0);
  signal n447 : std_logic_vector (15 downto 0);
  signal n448 : std_logic_vector (14 downto 0);
  signal n449 : std_logic_vector (15 downto 0);
  signal n450 : std_logic_vector (14 downto 0);
  signal n451 : std_logic_vector (15 downto 0);
  signal n452 : std_logic_vector (14 downto 0);
  signal n454 : std_logic;
  signal n458 : std_logic_vector (14 downto 0);
  signal n459 : std_logic_vector (14 downto 0);
  signal n461 : std_logic;
  signal n464 : std_logic;
  signal n466 : std_logic_vector (31 downto 0);
  signal n471 : std_logic;
  signal n475 : std_logic;
  signal n478 : std_logic;
  signal n484 : std_logic;
  signal n490 : std_logic;
  signal n492 : std_logic;
  signal n494 : std_logic_vector (15 downto 0);
  signal n496 : std_logic_vector (15 downto 0);
  signal n497 : std_logic_vector (15 downto 0);
  signal n498 : std_logic_vector (15 downto 0);
  signal n499 : std_logic;
  signal n501 : std_logic_vector (15 downto 0);
  signal n503 : std_logic_vector (15 downto 0);
  signal n504 : std_logic_vector (15 downto 0);
  signal n505 : std_logic_vector (15 downto 0);
  signal n506 : std_logic_vector (31 downto 0);
  signal n507 : std_logic_vector (5 downto 0);
  signal n508 : std_logic_vector (5 downto 0);
  signal n509 : std_logic_vector (31 downto 0);
  signal n510 : std_logic_vector (31 downto 0);
  signal n512 : std_logic;
  signal n513 : std_logic;
  signal n514 : std_logic_vector (31 downto 0);
  signal n515 : std_logic_vector (20 downto 0);
  signal n519 : std_logic;
  signal n520 : std_logic_vector (5 downto 0);
  signal n521 : std_logic_vector (5 downto 0);
  signal n522 : std_logic_vector (20 downto 0);
  signal n523 : std_logic_vector (20 downto 0);
  signal n524 : std_logic_vector (31 downto 0);
  signal n525 : std_logic_vector (20 downto 0);
  signal n528 : std_logic;
  signal n529 : std_logic_vector (5 downto 0);
  signal n530 : std_logic_vector (20 downto 0);
  signal n532 : std_logic;
  constant n533 : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n536 : std_logic;
  signal n538 : std_logic_vector (31 downto 0);
  signal n543 : std_logic;
  signal n547 : std_logic;
  signal n550 : std_logic;
  signal n556 : std_logic;
  signal n562 : std_logic;
  signal n564 : std_logic_vector (15 downto 0);
  signal n566 : std_logic_vector (14 downto 0);
  signal n568 : std_logic_vector (14 downto 0);
  signal n569 : std_logic_vector (15 downto 0);
  signal n570 : std_logic;
  signal n573 : std_logic_vector (15 downto 0);
  signal n575 : std_logic_vector (14 downto 0);
  signal n577 : std_logic_vector (14 downto 0);
  signal n578 : std_logic_vector (15 downto 0);
  signal n579 : std_logic;
  signal n582 : std_logic_vector (15 downto 0);
  signal n584 : std_logic_vector (15 downto 0);
  signal n585 : std_logic_vector (5 downto 0);
  signal n586 : std_logic_vector (5 downto 0);
  signal n587 : std_logic_vector (15 downto 0);
  signal n588 : std_logic_vector (15 downto 0);
  signal n590 : std_logic_vector (15 downto 0);
  signal n592 : std_logic_vector (15 downto 0);
  signal n593 : std_logic_vector (31 downto 0);
  signal n595 : std_logic;
  signal n596 : std_logic_vector (15 downto 0);
  signal n597 : std_logic_vector (15 downto 0);
  signal n598 : std_logic_vector (15 downto 0);
  signal n599 : std_logic_vector (15 downto 0);
  signal n600 : std_logic_vector (15 downto 0);
  signal n601 : std_logic_vector (31 downto 0);
  signal n603 : std_logic;
  signal n604 : std_logic_vector (31 downto 0);
  signal n605 : std_logic_vector (31 downto 0);
  signal n607 : std_logic;
  signal n609 : std_logic_vector (15 downto 0);
  signal n612 : std_logic;
  signal n614 : std_logic_vector (15 downto 0);
  signal n616 : std_logic_vector (15 downto 0);
  signal n617 : std_logic_vector (15 downto 0);
  signal n618 : std_logic;
  signal n620 : std_logic;
  signal n622 : std_logic_vector (15 downto 0);
  signal n623 : std_logic_vector (15 downto 0);
  signal n624 : std_logic_vector (15 downto 0);
  signal n625 : std_logic_vector (15 downto 0);
  signal n626 : std_logic;
  signal n628 : std_logic_vector (15 downto 0);
  signal n630 : std_logic_vector (15 downto 0);
  signal n631 : std_logic_vector (15 downto 0);
  signal n632 : std_logic_vector (15 downto 0);
  signal n635 : std_logic_vector (15 downto 0);
  signal n637 : std_logic_vector (15 downto 0);
  signal n642 : std_logic;
  signal n646 : std_logic;
  signal n649 : std_logic;
  signal n655 : std_logic;
  signal n661 : std_logic;
  signal n663 : std_logic;
  signal n665 : std_logic_vector (15 downto 0);
  signal n667 : std_logic_vector (15 downto 0);
  signal n669 : std_logic_vector (15 downto 0);
  signal n671 : std_logic_vector (15 downto 0);
  signal n672 : std_logic_vector (15 downto 0);
  signal n673 : std_logic_vector (15 downto 0);
  signal n674 : std_logic_vector (15 downto 0);
  signal n675 : std_logic_vector (31 downto 0);
  signal n676 : std_logic_vector (5 downto 0);
  signal n677 : std_logic_vector (5 downto 0);
  signal n678 : std_logic_vector (15 downto 0);
  signal n679 : std_logic_vector (15 downto 0);
  signal n680 : std_logic_vector (31 downto 0);
  signal n681 : std_logic_vector (31 downto 0);
  signal n683 : std_logic;
  signal n685 : std_logic_vector (7 downto 0);
  signal n686 : std_logic_vector (31 downto 0);
  signal n688 : std_logic_vector (31 downto 0);
  signal n690 : std_logic;
  signal n692 : std_logic_vector (15 downto 0);
  signal n695 : std_logic;
  signal n697 : std_logic_vector (15 downto 0);
  signal n699 : std_logic_vector (15 downto 0);
  signal n700 : std_logic_vector (15 downto 0);
  signal n701 : std_logic;
  signal n703 : std_logic;
  signal n705 : std_logic_vector (15 downto 0);
  signal n707 : std_logic_vector (15 downto 0);
  signal n708 : std_logic_vector (15 downto 0);
  signal n709 : std_logic_vector (15 downto 0);
  signal n710 : std_logic;
  signal n712 : std_logic_vector (15 downto 0);
  signal n713 : std_logic_vector (15 downto 0);
  signal n714 : std_logic_vector (15 downto 0);
  signal n715 : std_logic_vector (15 downto 0);
  signal n718 : std_logic_vector (15 downto 0);
  signal n720 : std_logic_vector (15 downto 0);
  signal n725 : std_logic;
  signal n729 : std_logic;
  signal n732 : std_logic;
  signal n738 : std_logic;
  signal n744 : std_logic;
  signal n746 : std_logic;
  signal n748 : std_logic_vector (15 downto 0);
  signal n750 : std_logic_vector (15 downto 0);
  signal n752 : std_logic_vector (15 downto 0);
  signal n754 : std_logic_vector (15 downto 0);
  signal n755 : std_logic_vector (15 downto 0);
  signal n756 : std_logic_vector (15 downto 0);
  signal n757 : std_logic_vector (15 downto 0);
  signal n758 : std_logic_vector (31 downto 0);
  signal n759 : std_logic_vector (5 downto 0);
  signal n760 : std_logic_vector (5 downto 0);
  signal n761 : std_logic_vector (15 downto 0);
  signal n762 : std_logic_vector (15 downto 0);
  signal n763 : std_logic_vector (31 downto 0);
  signal n764 : std_logic_vector (31 downto 0);
  signal n766 : std_logic;
  signal n768 : std_logic_vector (7 downto 0);
  signal n769 : std_logic_vector (31 downto 0);
  signal n771 : std_logic_vector (31 downto 0);
  signal n773 : std_logic;
  signal n774 : std_logic;
  signal n776 : std_logic_vector (5 downto 0);
  signal n777 : std_logic_vector (5 downto 0);
  signal n780 : std_logic;
  signal n782 : std_logic;
  signal n788 : std_logic;
  signal n792 : std_logic;
  signal n809 : std_logic;
  signal n811 : std_logic_vector (7 downto 0);
  signal n813 : std_logic_vector (31 downto 0);
  signal n814 : std_logic;
  signal n815 : std_logic;
  signal n817 : std_logic_vector (15 downto 0);
  signal n819 : std_logic_vector (15 downto 0);
  signal n820 : std_logic_vector (15 downto 0);
  signal n821 : std_logic_vector (15 downto 0);
  signal n822 : std_logic_vector (15 downto 0);
  signal n823 : std_logic;
  signal n825 : std_logic_vector (15 downto 0);
  signal n827 : std_logic_vector (15 downto 0);
  signal n828 : std_logic_vector (15 downto 0);
  signal n829 : std_logic_vector (15 downto 0);
  signal n830 : std_logic_vector (15 downto 0);
  signal n832 : std_logic_vector (31 downto 0);
  signal n833 : std_logic_vector (5 downto 0);
  signal n834 : std_logic_vector (5 downto 0);
  signal n835 : std_logic_vector (31 downto 0);
  signal n836 : std_logic_vector (31 downto 0);
  signal n838 : std_logic;
  signal n846 : std_logic;
  signal n860 : std_logic_vector (1 downto 0);
  signal n863 : std_logic_vector (15 downto 0);
  signal n866 : std_logic_vector (15 downto 0);
  signal n869 : std_logic;
  signal n871 : std_logic;
  signal n872 : std_logic;
  signal n873 : std_logic_vector (14 downto 0);
  signal n875 : std_logic_vector (15 downto 0);
  signal n877 : std_logic_vector (15 downto 0);
  signal n878 : std_logic_vector (15 downto 0);
  signal n880 : std_logic_vector (15 downto 0);
  signal n881 : std_logic_vector (15 downto 0);
  signal n883 : std_logic;
  signal n885 : std_logic;
  signal n886 : std_logic;
  signal n887 : std_logic_vector (14 downto 0);
  signal n889 : std_logic_vector (15 downto 0);
  signal n891 : std_logic_vector (15 downto 0);
  signal n892 : std_logic_vector (15 downto 0);
  signal n894 : std_logic_vector (15 downto 0);
  signal n895 : std_logic_vector (15 downto 0);
  signal n897 : std_logic;
  signal n899 : std_logic;
  signal n900 : std_logic;
  signal n902 : std_logic_vector (15 downto 0);
  signal n903 : std_logic_vector (15 downto 0);
  signal n905 : std_logic_vector (15 downto 0);
  signal n906 : std_logic_vector (15 downto 0);
  signal n908 : std_logic_vector (15 downto 0);
  signal n909 : std_logic_vector (15 downto 0);
  signal n911 : std_logic_vector (15 downto 0);
  signal n912 : std_logic_vector (15 downto 0);
  signal n913 : std_logic_vector (15 downto 0);
  signal n915 : std_logic_vector (15 downto 0);
  signal n924 : std_logic_vector (1 downto 0);
  signal n925 : std_logic_vector (7 downto 0);
  signal n926 : std_logic_vector (7 downto 0);
  signal n928 : std_logic;
  signal n929 : std_logic_vector (7 downto 0);
  signal n930 : std_logic_vector (7 downto 0);
  signal n932 : std_logic;
  signal n933 : std_logic_vector (7 downto 0);
  signal n934 : std_logic_vector (7 downto 0);
  signal n936 : std_logic;
  signal n937 : std_logic_vector (2 downto 0);
  signal n942 : std_logic;
  signal n950 : std_logic_vector (7 downto 0);
  signal n955 : std_logic_vector (7 downto 0);
  signal n956 : std_logic;
  signal n961 : std_logic;
  signal n965 : std_logic;
  signal n968 : std_logic;
  signal n974 : std_logic;
  signal n980 : std_logic;
  signal n982 : std_logic_vector (15 downto 0);
  signal n983 : std_logic_vector (14 downto 0);
  signal n985 : std_logic_vector (14 downto 0);
  signal n986 : std_logic_vector (15 downto 0);
  signal n987 : std_logic;
  signal n990 : std_logic_vector (15 downto 0);
  signal n991 : std_logic_vector (14 downto 0);
  signal n993 : std_logic_vector (14 downto 0);
  signal n994 : std_logic_vector (15 downto 0);
  signal n995 : std_logic;
  signal n998 : std_logic_vector (15 downto 0);
  signal n1000 : std_logic_vector (15 downto 0);
  signal n1001 : std_logic_vector (5 downto 0);
  signal n1002 : std_logic_vector (5 downto 0);
  signal n1003 : std_logic_vector (15 downto 0);
  signal n1004 : std_logic_vector (15 downto 0);
  signal n1006 : std_logic_vector (15 downto 0);
  signal n1008 : std_logic_vector (15 downto 0);
  signal n1009 : std_logic_vector (31 downto 0);
  signal n1011 : std_logic;
  signal n1012 : std_logic_vector (15 downto 0);
  signal n1013 : std_logic_vector (15 downto 0);
  signal n1014 : std_logic_vector (15 downto 0);
  signal n1015 : std_logic_vector (15 downto 0);
  signal n1016 : std_logic_vector (15 downto 0);
  signal n1017 : std_logic_vector (31 downto 0);
  signal n1019 : std_logic;
  signal n1020 : std_logic_vector (31 downto 0);
  signal n1021 : std_logic_vector (31 downto 0);
  signal n1024 : std_logic;
  signal n1026 : std_logic;
  signal n1028 : std_logic;
  signal n1030 : std_logic;
  signal n1032 : std_logic_vector (7 downto 0);
  signal n1033 : std_logic_vector (31 downto 0);
  signal n1035 : std_logic_vector (31 downto 0);
  signal n1037 : std_logic;
  signal n1039 : std_logic;
  signal n1041 : std_logic;
  signal n1051 : std_logic_vector (1 downto 0);
  signal n1053 : std_logic;
  signal n1055 : std_logic;
  signal n1057 : std_logic;
  signal n1058 : std_logic;
  signal n1060 : std_logic_vector (15 downto 0);
  signal n1061 : std_logic_vector (14 downto 0);
  signal n1063 : std_logic_vector (15 downto 0);
  signal n1064 : std_logic_vector (15 downto 0);
  signal n1066 : std_logic_vector (15 downto 0);
  signal n1067 : std_logic_vector (14 downto 0);
  signal n1069 : std_logic_vector (15 downto 0);
  signal n1070 : std_logic_vector (15 downto 0);
  signal n1071 : std_logic_vector (15 downto 0);
  signal n1072 : std_logic_vector (15 downto 0);
  signal n1073 : std_logic_vector (15 downto 0);
  signal n1074 : std_logic;
  signal n1076 : std_logic;
  signal n1078 : std_logic;
  signal n1079 : std_logic;
  signal n1081 : std_logic_vector (15 downto 0);
  signal n1082 : std_logic_vector (14 downto 0);
  signal n1084 : std_logic_vector (15 downto 0);
  signal n1085 : std_logic_vector (15 downto 0);
  signal n1087 : std_logic_vector (15 downto 0);
  signal n1088 : std_logic_vector (14 downto 0);
  signal n1090 : std_logic_vector (15 downto 0);
  signal n1091 : std_logic_vector (15 downto 0);
  signal n1092 : std_logic_vector (15 downto 0);
  signal n1093 : std_logic_vector (15 downto 0);
  signal n1094 : std_logic_vector (15 downto 0);
  signal n1097 : std_logic;
  signal n1098 : std_logic;
  signal n1099 : std_logic_vector (20 downto 0);
  signal n1100 : std_logic;
  signal n1103 : std_logic;
  signal n1106 : std_logic_vector (5 downto 0);
  signal n1107 : std_logic_vector (5 downto 0);
  signal n1110 : std_logic;
  signal n1112 : std_logic_vector (20 downto 0);
  signal n1114 : std_logic_vector (15 downto 0);
  signal n1116 : std_logic;
  signal n1118 : std_logic;
  signal n1119 : std_logic_vector (20 downto 0);
  signal n1122 : std_logic;
  signal n1123 : std_logic_vector (20 downto 0);
  signal n1126 : std_logic;
  signal n1127 : std_logic;
  signal n1133 : std_logic_vector (4 downto 0);
  signal n1135 : std_logic;
  signal n1138 : std_logic;
  signal n1139 : std_logic_vector (15 downto 0);
  signal n1141 : std_logic_vector (15 downto 0);
  signal n1144 : std_logic;
  signal n1145 : std_logic_vector (5 downto 0);
  signal n1146 : std_logic_vector (5 downto 0);
  signal n1147 : std_logic_vector (15 downto 0);
  signal n1148 : std_logic_vector (15 downto 0);
  signal n1150 : std_logic;
  signal n1151 : std_logic_vector (20 downto 0);
  signal n1157 : std_logic_vector (4 downto 0);
  signal n1159 : std_logic;
  signal n1160 : std_logic_vector (15 downto 0);
  signal n1161 : std_logic;
  signal n1162 : std_logic;
  signal n1163 : std_logic_vector (20 downto 0);
  signal n1165 : std_logic_vector (20 downto 0);
  signal n1166 : std_logic_vector (20 downto 0);
  signal n1168 : std_logic_vector (20 downto 0);
  signal n1169 : std_logic_vector (20 downto 0);
  signal n1172 : std_logic;
  signal n1173 : std_logic_vector (15 downto 0);
  signal n1175 : std_logic;
  signal n1178 : std_logic_vector (5 downto 0);
  signal n1179 : std_logic_vector (5 downto 0);
  signal n1180 : std_logic_vector (5 downto 0);
  signal n1181 : std_logic_vector (20 downto 0);
  signal n1182 : std_logic_vector (20 downto 0);
  signal n1185 : std_logic;
  signal n1187 : std_logic;
  signal n1189 : std_logic;
  signal n1191 : std_logic_vector (20 downto 0);
  signal n1192 : std_logic;
  signal n1195 : std_logic;
  signal n1198 : std_logic;
  signal n1200 : std_logic;
  signal n1202 : std_logic_vector (5 downto 0);
  signal n1203 : std_logic_vector (5 downto 0);
  signal n1204 : std_logic_vector (15 downto 0);
  signal n1205 : std_logic_vector (15 downto 0);
  signal n1207 : std_logic;
  signal n1210 : std_logic;
  signal n1212 : std_logic_vector (31 downto 0);
  signal n1214 : std_logic;
  signal n1216 : std_logic_vector (31 downto 0);
  signal n1218 : std_logic;
  signal n1219 : std_logic_vector (31 downto 0);
  signal n1220 : std_logic;
  signal n1224 : std_logic;
  signal n1225 : std_logic_vector (5 downto 0);
  signal n1226 : std_logic_vector (5 downto 0);
  signal n1230 : std_logic;
  signal n1231 : std_logic_vector (5 downto 0);
  signal n1232 : std_logic_vector (15 downto 0);
  signal n1233 : std_logic_vector (15 downto 0);
  signal n1235 : std_logic;
  signal n1236 : std_logic_vector (31 downto 0);
  signal n1238 : std_logic_vector (5 downto 0);
  signal n1239 : std_logic_vector (5 downto 0);
  signal n1240 : std_logic_vector (15 downto 0);
  signal n1241 : std_logic_vector (15 downto 0);
  signal n1243 : std_logic;
  signal n1245 : std_logic;
  signal n1247 : std_logic_vector (15 downto 0);
  signal n1249 : std_logic_vector (15 downto 0);
  signal n1250 : std_logic_vector (15 downto 0);
  signal n1251 : std_logic_vector (15 downto 0);
  signal n1252 : std_logic;
  signal n1254 : std_logic_vector (15 downto 0);
  signal n1256 : std_logic_vector (15 downto 0);
  signal n1257 : std_logic_vector (15 downto 0);
  signal n1258 : std_logic_vector (15 downto 0);
  signal n1260 : std_logic;
  signal n1261 : std_logic_vector (33 downto 0);
  signal n1262 : std_logic_vector (20 downto 0);
  signal n1264 : std_logic;
  signal n1267 : std_logic;
  signal n1270 : std_logic;
  signal n1275 : std_logic;
  signal n1278 : std_logic;
  signal n1280 : std_logic_vector (5 downto 0);
  signal n1281 : std_logic_vector (5 downto 0);
  signal n1282 : std_logic_vector (15 downto 0);
  signal n1283 : std_logic_vector (15 downto 0);
  signal n1284 : std_logic_vector (1 downto 0);
  signal n1285 : std_logic_vector (1 downto 0);
  signal n1286 : std_logic_vector (14 downto 0);
  signal n1287 : std_logic_vector (14 downto 0);
  signal n1288 : std_logic_vector (14 downto 0);
  signal n1289 : std_logic_vector (14 downto 0);
  signal n1290 : std_logic_vector (14 downto 0);
  signal n1291 : std_logic_vector (14 downto 0);
  signal n1292 : std_logic_vector (14 downto 0);
  signal n1293 : std_logic_vector (14 downto 0);
  signal n1294 : std_logic_vector (20 downto 0);
  signal n1295 : std_logic_vector (20 downto 0);
  signal n1296 : std_logic_vector (15 downto 0);
  signal n1297 : std_logic_vector (15 downto 0);
  signal n1298 : std_logic_vector (20 downto 0);
  signal n1299 : std_logic_vector (20 downto 0);
  signal n1300 : std_logic_vector (15 downto 0);
  signal n1301 : std_logic_vector (15 downto 0);
  signal n1302 : std_logic_vector (15 downto 0);
  signal n1303 : std_logic_vector (15 downto 0);
  signal n1304 : std_logic_vector (15 downto 0);
  signal n1305 : std_logic_vector (15 downto 0);
  signal n1306 : std_logic_vector (15 downto 0);
  signal n1307 : std_logic_vector (15 downto 0);
  signal n1308 : std_logic_vector (15 downto 0);
  signal n1309 : std_logic_vector (15 downto 0);
  signal n1310 : std_logic_vector (15 downto 0);
  signal n1311 : std_logic_vector (15 downto 0);
  signal n1312 : std_logic_vector (15 downto 0);
  signal n1313 : std_logic_vector (15 downto 0);
  signal n1314 : std_logic_vector (15 downto 0);
  signal n1315 : std_logic_vector (15 downto 0);
  signal n1316 : std_logic_vector (15 downto 0);
  signal n1317 : std_logic_vector (15 downto 0);
  signal n1318 : std_logic_vector (15 downto 0);
  signal n1319 : std_logic_vector (15 downto 0);
  signal n1320 : std_logic_vector (15 downto 0);
  signal n1321 : std_logic_vector (15 downto 0);
  signal n1322 : std_logic_vector (15 downto 0);
  signal n1323 : std_logic_vector (15 downto 0);
  signal n1324 : std_logic_vector (15 downto 0);
  signal n1325 : std_logic_vector (15 downto 0);
  signal n1326 : std_logic_vector (7 downto 0);
  signal n1327 : std_logic_vector (7 downto 0);
  signal n1328 : std_logic_vector (7 downto 0);
  signal n1329 : std_logic_vector (7 downto 0);
  signal n1330 : std_logic_vector (61 downto 0);
  signal n1331 : std_logic_vector (61 downto 0);
  signal n1332 : std_logic_vector (7 downto 0);
  signal n1333 : std_logic_vector (7 downto 0);
  signal n1334 : std_logic_vector (1 downto 0);
  signal n1335 : std_logic_vector (1 downto 0);
  signal n1356 : std_logic;
  signal n1359 : std_logic;
  signal n1362 : std_logic;
  signal n1365 : std_logic_vector (7 downto 0);
  signal n1368 : std_logic_vector (31 downto 0);
  signal n1373 : std_logic;
  signal n1376 : std_logic;
  signal n1379 : std_logic_vector (20 downto 0);
  signal n1382 : std_logic_vector (15 downto 0);
  signal n1385 : std_logic;
  signal n1389 : std_logic;
  signal n1392 : std_logic;
  signal n1395 : std_logic;
  signal n1400 : std_logic_vector (20 downto 0);
  signal n1402 : std_logic_vector (15 downto 0);
  signal n1405 : std_logic;
  signal n1407 : std_logic;
  signal n1408 : std_logic_vector (20 downto 0);
  signal n1410 : std_logic_vector (15 downto 0);
  signal n1413 : std_logic;
  signal n1415 : std_logic;
  signal gfx_circle_inst_c_busy : std_logic;
  signal gfx_circle_inst_c_pixel_valid : std_logic;
  signal gfx_circle_inst_c_pixel_x : std_logic_vector (15 downto 0);
  signal gfx_circle_inst_c_pixel_y : std_logic_vector (15 downto 0);
  signal n1419 : std_logic_vector (31 downto 0);
  signal n1420 : std_logic_vector (15 downto 0);
  signal n1421 : std_logic_vector (15 downto 0);
  signal n1423 : std_logic_vector (31 downto 0);
  signal pw_c_wr_in_progress : std_logic;
  signal pw_c_stall : std_logic;
  signal pw_c_oob : std_logic;
  signal pw_c_vram_wr_addr : std_logic_vector (20 downto 0);
  signal pw_c_vram_wr_data : std_logic_vector (15 downto 0);
  signal pw_c_vram_wr : std_logic;
  signal pw_c_vram_wr_access_mode : std_logic;
  signal n1426 : std_logic_vector (61 downto 0);
  signal n1427 : std_logic_vector (31 downto 0);
  signal n1428 : std_logic_vector (14 downto 0);
  signal n1429 : std_logic_vector (14 downto 0);
  signal n1430 : std_logic_vector (15 downto 0);
  signal n1431 : std_logic_vector (15 downto 0);
  signal n1433 : std_logic_vector (7 downto 0);
  signal n1439 : std_logic_vector (1 downto 0);
  signal n1440 : std_logic_vector (7 downto 0);
  signal n1441 : std_logic_vector (7 downto 0);
  signal n1443 : std_logic;
  signal n1444 : std_logic_vector (7 downto 0);
  signal n1445 : std_logic_vector (7 downto 0);
  signal n1447 : std_logic;
  signal n1448 : std_logic_vector (7 downto 0);
  signal n1449 : std_logic_vector (7 downto 0);
  signal n1451 : std_logic;
  signal n1452 : std_logic_vector (2 downto 0);
  signal n1457 : std_logic;
  signal n1465 : std_logic_vector (7 downto 0);
  signal n1470 : std_logic_vector (7 downto 0);
  signal pr_c_color : std_logic_vector (7 downto 0);
  signal pr_c_color_valid : std_logic;
  signal pr_c_vram_rd_addr : std_logic_vector (20 downto 0);
  signal pr_c_vram_rd : std_logic;
  signal pr_c_vram_rd_access_mode : std_logic;
  signal n1476 : std_logic_vector (31 downto 0);
  signal n1477 : std_logic_vector (14 downto 0);
  signal n1478 : std_logic_vector (14 downto 0);
  signal n1479 : std_logic_vector (14 downto 0);
  signal n1480 : std_logic_vector (14 downto 0);
  signal n1481 : std_logic_vector (14 downto 0);
  signal n1482 : std_logic_vector (14 downto 0);
  signal n1488 : std_logic_vector (63 downto 0);
  signal n1489 : std_logic_vector (309 downto 0);
  signal n1490 : std_logic_vector (309 downto 0);
  signal n1492 : std_logic_vector (61 downto 0);
begin
  wrap_clk <= clk;
  wrap_res_n <= res_n;
  wrap_vram_wr_full <= vram_wr_full;
  wrap_vram_wr_emtpy <= vram_wr_emtpy;
  wrap_vram_rd_data <= typwrap_vram_rd_data(vram_rd_data);
  wrap_vram_rd_busy <= vram_rd_busy;
  wrap_vram_rd_valid <= vram_rd_valid;
  wrap_fr_base_addr_req <= fr_base_addr_req;
  wrap_gcf_data <= typwrap_gcf_data(gcf_data);
  wrap_gcf_empty <= gcf_empty;
  vram_wr_addr <= std_ulogic_vector(wrap_vram_wr_addr);
  vram_wr_data <= std_ulogic_vector(wrap_vram_wr_data);
  vram_wr <= wrap_vram_wr;
  vram_wr_access_mode <= sram_access_mode_t'val (to_integer(unsigned'(0 => wrap_vram_wr_access_mode)));
  vram_rd_addr <= std_ulogic_vector(wrap_vram_rd_addr);
  vram_rd <= wrap_vram_rd;
  vram_rd_access_mode <= sram_access_mode_t'val (to_integer(unsigned'(0 => wrap_vram_rd_access_mode)));
  fr_base_addr <= std_ulogic_vector(wrap_fr_base_addr);
  gcf_rd <= wrap_gcf_rd;
  rd_data <= gfx_cmd_t(wrap_rd_data);
  rd_valid <= wrap_rd_valid;
  frame_sync <= wrap_frame_sync;
  wrap_vram_wr_addr <= n1408;
  wrap_vram_wr_data <= n1410;
  wrap_vram_wr <= n1413;
  wrap_vram_wr_access_mode <= n1415;
  wrap_vram_rd_addr <= n1262;
  wrap_vram_rd <= n1264;
  wrap_vram_rd_access_mode <= n1267;
  wrap_fr_base_addr <= n108;
  wrap_gcf_rd <= n1270;
  wrap_rd_data <= n107;
  wrap_rd_valid <= n1275;
  wrap_frame_sync <= n1278;
  operand_buffer <= n1488; -- (signal)
  state <= n1489; -- (signal)
  state_nxt <= n1490; -- (signal)
  bdt_wr <= n1356; -- (signal)
  bdt_rd <= n1359; -- (signal)
  stall <= pw_c_stall; -- (signal)
  pw_wr <= n1362; -- (signal)
  pw_color <= n1365; -- (signal)
  pw_position <= n1368; -- (signal)
  pw_alpha_mode <= n1373; -- (signal)
  pw_oob <= pw_c_oob; -- (signal)
  pw_vram_wr_addr <= pw_c_vram_wr_addr; -- (signal)
  pw_vram_wr_data <= pw_c_vram_wr_data; -- (signal)
  pw_vram_wr <= pw_c_vram_wr; -- (signal)
  pw_vram_wr_access_mode <= pw_c_vram_wr_access_mode; -- (signal)
  direct_vram_wr <= n1376; -- (signal)
  direct_vram_wr_addr <= n1379; -- (signal)
  direct_vram_wr_data <= n1382; -- (signal)
  direct_vram_wr_access_mode <= n1385; -- (signal)
  pr_start <= n1389; -- (signal)
  pr_color <= pr_c_color; -- (signal)
  pr_color_valid <= pr_c_color_valid; -- (signal)
  pr_color_ack <= n1392; -- (signal)
  pr_vram_rd_addr <= pr_c_vram_rd_addr; -- (signal)
  pr_vram_rd <= pr_c_vram_rd; -- (signal)
  pr_vram_rd_access_mode <= pr_c_vram_rd_access_mode; -- (signal)
  circle_start <= n1395; -- (signal)
  circle_busy <= gfx_circle_inst_c_busy; -- (signal)
  circle_pixel_valid <= gfx_circle_inst_c_pixel_valid; -- (signal)
  circle_pixel <= n1423; -- (signal)
  instr_color <= n115; -- (signal)
  current_instr <= n12; -- (signal)
  bdt_bmpidx <= n1492; -- (signal)
  dx <= n13; -- (signal)
  dy <= n14; -- (signal)
  radius <= n15; -- (signal)
  bb_section <= n16; -- (signal)
  addrlo <= n50; -- (signal)
  addrhi <= n51; -- (signal)
  data <= n52; -- (signal)
  n <= n53; -- (signal)
  n12 <= state (21 downto 6);
  n13 <= operand_buffer (63 downto 48);
  n14 <= operand_buffer (63 downto 48);
  n15 <= operand_buffer (62 downto 48);
  n16 <= state (83 downto 24);
  n19 <= operand_buffer (63 downto 48);
  n20 <= operand_buffer (52 downto 48);
  n21 <= operand_buffer (63 downto 48);
  n22 <= operand_buffer (63 downto 48);
  n28 <= current_instr (15 downto 11);
  n29 <= operand_buffer (47 downto 32);
  n30 <= operand_buffer (52 downto 48);
  n32 <= '1' when n28 = "01100" else '0';
  n33 <= operand_buffer (31 downto 16);
  n34 <= operand_buffer (36 downto 32);
  n35 <= operand_buffer (63 downto 48);
  n37 <= '1' when n28 = "01101" else '0';
  n38 <= operand_buffer (47 downto 32);
  n39 <= operand_buffer (52 downto 48);
  n40 <= operand_buffer (31 downto 16);
  n42 <= '1' when n28 = "01110" else '0';
  n43 <= operand_buffer (15 downto 0);
  n44 <= operand_buffer (31 downto 16);
  n45 <= operand_buffer (36 downto 32);
  n46 <= operand_buffer (63 downto 48);
  n48 <= '1' when n28 = "01111" else '0';
  n49 <= n48 & n42 & n37 & n32;
  with n49 select n50 <=
    n44 when "1000",
    n38 when "0100",
    n33 when "0010",
    n29 when "0001",
    n19 when others;
  with n49 select n51 <=
    n45 when "1000",
    n39 when "0100",
    n34 when "0010",
    n30 when "0001",
    n20 when others;
  with n49 select n52 <=
    n46 when "1000",
    n21 when "0100",
    n35 when "0010",
    n21 when "0001",
    n21 when others;
  with n49 select n53 <=
    n43 when "1000",
    n40 when "0100",
    n22 when "0010",
    n22 when "0001",
    n22 when others;
  operands_buffer_operand_buffer_int <= n76; -- (signal)
  n57 <= operands_buffer_operand_buffer_int (47 downto 32);
  n58 <= operands_buffer_operand_buffer_int (31 downto 16);
  n59 <= operands_buffer_operand_buffer_int (15 downto 0);
  n62 <= not wrap_res_n;
  n67 <= operands_buffer_operand_buffer_int (47 downto 32);
  n68 <= operands_buffer_operand_buffer_int (31 downto 16);
  n69 <= wrap_gcf_data & n67 & n68;
  n72 <= "0000000000000000" & "0000000000000000" & "0000000000000000";
  n75 <= operands_buffer_operand_buffer_int when n1270 = '0' else n69;
  process (wrap_clk, n62, n72)
  begin
    if n62 = '1' then
      n76 <= n72;
    elsif rising_edge (wrap_clk) then
      n76 <= n75;
    end if;
  end process;
  bdt_block_bdt_bmpidx_int <= bdt_block_bitmaps_n88; -- (signal)
  bdt_block_bdt_wr_data <= n106; -- (signal)
  n77 <= operand_buffer (31 downto 16);
  n78 <= operand_buffer (15 downto 0);
  n79 <= n77 & n78;
  n80 <= operand_buffer (46 downto 32);
  n81 <= operand_buffer (62 downto 48);
  n87 <= wrap_gcf_data (2 downto 0);
  bdt_block_bitmaps_n88 <= bdt_block_bitmaps_c_rd1_data; -- (signal)
  n95 <= state (8 downto 6);
  n96 <= bdt_block_bdt_wr_data (31 downto 0);
  n97 <= bdt_block_bdt_wr_data (46 downto 32);
  n98 <= n96 & n97;
  n99 <= bdt_block_bdt_wr_data (61 downto 47);
  n100 <= n98 & n99;
  bdt_block_bitmaps : entity work.dp_ram_1c1r1w_3_62 port map (
    clk => wrap_clk,
    rd1_addr => n87,
    rd1 => bdt_rd,
    wr2_addr => n95,
    wr2_data => n100,
    wr2 => bdt_wr,
    rd1_data => bdt_block_bitmaps_c_rd1_data);
  n103 <= bdt_block_bdt_bmpidx_int (61 downto 30);
  n104 <= bdt_block_bdt_bmpidx_int (29 downto 15);
  n105 <= bdt_block_bdt_bmpidx_int (14 downto 0);
  n106 <= n81 & n80 & n79;
  n107 <= state (120 downto 105);
  n108 <= state (104 downto 84);
  n111 <= current_instr (10);
  n112 <= not n111;
  n113 <= state (229 downto 222);
  n114 <= state (237 downto 230);
  n115 <= n114 when n112 = '0' else n113;
  n118 <= not wrap_res_n;
  n125 <= state (5 downto 0);
  n126 <= not wrap_gcf_empty;
  n130 <= '0' when n126 = '0' else '1';
  n131 <= state (5 downto 0);
  n132 <= n131 when n126 = '0' else "000001";
  n134 <= '1' when n125 = "000000" else '0';
  n142 <= wrap_gcf_data (15 downto 11);
  n149 <= '1' when n142 = "00000" else '0';
  n152 <= '1' when n142 = "00001" else '0';
  n155 <= '1' when n142 = "00010" else '0';
  n158 <= '1' when n142 = "00100" else '0';
  n161 <= '1' when n142 = "00101" else '0';
  n164 <= '1' when n142 = "00110" else '0';
  n167 <= '1' when n142 = "00111" else '0';
  n170 <= '1' when n142 = "01000" else '0';
  n173 <= '1' when n142 = "01011" else '0';
  n176 <= '1' when n142 = "01100" else '0';
  n179 <= '1' when n142 = "01101" else '0';
  n182 <= '1' when n142 = "01110" else '0';
  n185 <= '1' when n142 = "01111" else '0';
  n188 <= '1' when n142 = "10000" else '0';
  n191 <= '1' when n142 = "10001" else '0';
  n194 <= '1' when n142 = "10010" else '0';
  n197 <= '1' when n142 = "10011" else '0';
  n200 <= '1' when n142 = "10100" else '0';
  n203 <= '1' when n142 = "11000" else '0';
  n206 <= '1' when n142 = "11001" else '0';
  n209 <= '1' when n142 = "11010" else '0';
  n212 <= '1' when n142 = "11111" else '0';
  n214 <= n212 & n209 & n206 & n203 & n200 & n197 & n194 & n191 & n188 & n185 & n182 & n179 & n176 & n173 & n170 & n167 & n164 & n161 & n158 & n155 & n152 & n149;
  with n214 select n215 <=
    "00000000000000000000000000000000" when "1000000000000000000000",
    "00000000000000000000000000000001" when "0100000000000000000000",
    "00000000000000000000000000000000" when "0010000000000000000000",
    "00000000000000000000000000000100" when "0001000000000000000000",
    "00000000000000000000000000000000" when "0000100000000000000000",
    "00000000000000000000000000000000" when "0000010000000000000000",
    "00000000000000000000000000000100" when "0000001000000000000000",
    "00000000000000000000000000000000" when "0000000100000000000000",
    "00000000000000000000000000000000" when "0000000010000000000000",
    "00000000000000000000000000000100" when "0000000001000000000000",
    "11111111111111111111111111111111" when "0000000000100000000000",
    "00000000000000000000000000000011" when "0000000000010000000000",
    "00000000000000000000000000000010" when "0000000000001000000000",
    "00000000000000000000000000000000" when "0000000000000100000000",
    "00000000000000000000000000000001" when "0000000000000010000000",
    "00000000000000000000000000000001" when "0000000000000001000000",
    "00000000000000000000000000000001" when "0000000000000000100000",
    "00000000000000000000000000000000" when "0000000000000000010000",
    "00000000000000000000000000000000" when "0000000000000000001000",
    "00000000000000000000000000000000" when "0000000000000000000100",
    "00000000000000000000000000000010" when "0000000000000000000010",
    "00000000000000000000000000000000" when "0000000000000000000001",
    "11111111111111111111111111111110" when others;
  n217 <= '1' when n215 = "11111111111111111111111111111111" else '0';
  n219 <= '1' when n215 = "00000000000000000000000000000000" else '0';
  n223 <= '1' when n215 = "00000000000000000000000000000001" else '0';
  n227 <= '1' when n215 = "00000000000000000000000000000010" else '0';
  n231 <= '1' when n215 = "00000000000000000000000000000011" else '0';
  n235 <= '1' when n215 = "00000000000000000000000000000100" else '0';
  n236 <= n235 & n231 & n227 & n223 & n219 & n217;
  with n236 select n237 <=
    "000010" when "100000",
    "000010" when "010000",
    "000010" when "001000",
    "000010" when "000100",
    "000000" when "000010",
    "000000" when "000001",
    "000000" when others;
  n238 <= state (23 downto 22);
  with n236 select n239 <=
    "11" when "100000",
    "10" when "010000",
    "01" when "001000",
    "00" when "000100",
    n238 when "000010",
    n238 when "000001",
    n238 when others;
  n245 <= wrap_gcf_data (15 downto 11);
  n247 <= '1' when n245 = "00000" else '0';
  n250 <= '1' when n245 = "10011" else '0';
  n253 <= '1' when n245 = "10100" else '0';
  n256 <= '1' when n245 = "11111" else '0';
  n259 <= '1' when n245 = "01110" else '0';
  n260 <= wrap_gcf_data (10);
  n261 <= not n260;
  n262 <= wrap_gcf_data (7 downto 0);
  n263 <= wrap_gcf_data (7 downto 0);
  n264 <= state (229 downto 222);
  n265 <= n264 when n261 = '0' else n262;
  n266 <= state (237 downto 230);
  n267 <= n263 when n261 = '0' else n266;
  n270 <= '1' when n245 = "10000" else '0';
  n273 <= '1' when n245 = "00100" else '0';
  n276 <= '1' when n245 = "00101" else '0';
  n277 <= wrap_gcf_data (10);
  n278 <= not n277;
  n280 <= state (205 downto 190);
  n281 <= wrap_gcf_data (9 downto 0);
  n282 <= std_logic_vector (resize (signed (n281), 16));  --  sext
  n283 <= std_logic_vector (unsigned (n280) + unsigned (n282));
  n285 <= state (221 downto 206);
  n286 <= wrap_gcf_data (9 downto 0);
  n287 <= std_logic_vector (resize (signed (n286), 16));  --  sext
  n288 <= std_logic_vector (unsigned (n285) + unsigned (n287));
  n289 <= state (205 downto 190);
  n290 <= n289 when n278 = '0' else n283;
  n291 <= state (221 downto 206);
  n292 <= n288 when n278 = '0' else n291;
  n295 <= '1' when n245 = "00010" else '0';
  n298 <= '1' when n245 = "11001" else '0';
  n299 <= wrap_gcf_data (7 downto 0);
  n305 <= wrap_gcf_data (9 downto 8);
  n308 <= '1' when n245 = "10001" else '0';
  n311 <= '1' when n245 = "01011" else '0';
  n312 <= n311 & n308 & n298 & n295 & n276 & n273 & n270 & n259 & n256 & n253 & n250 & n247;
  with n312 select n313 <=
    "011010" when "100000000000",
    "000000" when "010000000000",
    "000110" when "001000000000",
    "000000" when "000100000000",
    "000100" when "000010000000",
    "010100" when "000001000000",
    "000000" when "000000100000",
    "000010" when "000000010000",
    "000000" when "000000001000",
    "010011" when "000000000100",
    "001000" when "000000000010",
    n237 when "000000000001",
    n237 when others;
  with n312 select n314 <=
    n239 when "100000000000",
    n239 when "010000000000",
    n239 when "001000000000",
    n239 when "000100000000",
    n239 when "000010000000",
    n239 when "000001000000",
    n239 when "000000100000",
    "10" when "000000010000",
    n239 when "000000001000",
    n239 when "000000000100",
    n239 when "000000000010",
    n239 when "000000000001",
    n239 when others;
  n315 <= state (205 downto 190);
  with n312 select n316 <=
    n315 when "100000000000",
    n315 when "010000000000",
    n315 when "001000000000",
    n290 when "000100000000",
    n315 when "000010000000",
    n315 when "000001000000",
    n315 when "000000100000",
    n315 when "000000010000",
    n315 when "000000001000",
    n315 when "000000000100",
    n315 when "000000000010",
    n315 when "000000000001",
    n315 when others;
  n317 <= state (221 downto 206);
  with n312 select n318 <=
    n317 when "100000000000",
    n317 when "010000000000",
    n317 when "001000000000",
    n292 when "000100000000",
    n317 when "000010000000",
    n317 when "000001000000",
    n317 when "000000100000",
    n317 when "000000010000",
    n317 when "000000001000",
    n317 when "000000000100",
    n317 when "000000000010",
    n317 when "000000000001",
    n317 when others;
  n319 <= state (229 downto 222);
  with n312 select n320 <=
    n319 when "100000000000",
    n319 when "010000000000",
    n319 when "001000000000",
    n319 when "000100000000",
    n319 when "000010000000",
    n319 when "000001000000",
    n265 when "000000100000",
    n319 when "000000010000",
    n319 when "000000001000",
    n319 when "000000000100",
    n319 when "000000000010",
    n319 when "000000000001",
    n319 when others;
  n321 <= state (237 downto 230);
  with n312 select n322 <=
    n321 when "100000000000",
    n321 when "010000000000",
    n321 when "001000000000",
    n321 when "000100000000",
    n321 when "000010000000",
    n321 when "000001000000",
    n267 when "000000100000",
    n321 when "000000010000",
    n321 when "000000001000",
    n321 when "000000000100",
    n321 when "000000000010",
    n321 when "000000000001",
    n321 when others;
  n323 <= state (307 downto 300);
  with n312 select n324 <=
    n323 when "100000000000",
    n299 when "010000000000",
    n323 when "001000000000",
    n323 when "000100000000",
    n323 when "000010000000",
    n323 when "000001000000",
    n323 when "000000100000",
    n323 when "000000010000",
    n323 when "000000001000",
    n323 when "000000000100",
    n323 when "000000000010",
    n323 when "000000000001",
    n323 when others;
  n325 <= state (309 downto 308);
  with n312 select n326 <=
    n325 when "100000000000",
    n305 when "010000000000",
    n325 when "001000000000",
    n325 when "000100000000",
    n325 when "000010000000",
    n325 when "000001000000",
    n325 when "000000100000",
    n325 when "000000010000",
    n325 when "000000001000",
    n325 when "000000000100",
    n325 when "000000000010",
    n325 when "000000000001",
    n325 when others;
  n332 <= wrap_gcf_data (15 downto 11);
  n334 <= '1' when n332 = "11001" else '0';
  n336 <= '1' when n332 = "11000" else '0';
  n337 <= n334 or n336;
  n339 <= '1' when n332 = "11010" else '0';
  n340 <= n337 or n339;
  n342 <= '1' when n332 = "10100" else '0';
  n343 <= n340 or n342;
  n345 <= '1' when n332 = "10011" else '0';
  n346 <= n343 or n345;
  with n346 select n349 <=
    '1' when '1',
    '0' when others;
  n351 <= '1' when n125 = "000001" else '0';
  n352 <= not wrap_gcf_empty;
  n353 <= state (23 downto 22);
  n355 <= '1' when n353 = "00" else '0';
  n357 <= state (23 downto 22);
  n359 <= std_logic_vector (unsigned (n357) - unsigned'("01"));
  n361 <= "000010" when n355 = '0' else "000011";
  n362 <= state (23 downto 22);
  n363 <= n359 when n355 = '0' else n362;
  n366 <= '0' when n352 = '0' else '1';
  n367 <= state (5 downto 0);
  n368 <= n367 when n352 = '0' else n361;
  n369 <= state (23 downto 22);
  n370 <= n369 when n352 = '0' else n363;
  n372 <= '1' when n125 = "000010" else '0';
  n379 <= state (21 downto 17);
  n382 <= '1' when n379 = "01100" else '0';
  n385 <= '1' when n379 = "01101" else '0';
  n388 <= '1' when n379 = "01110" else '0';
  n391 <= '1' when n379 = "01111" else '0';
  n394 <= '1' when n379 = "00110" else '0';
  n397 <= '1' when n379 = "00111" else '0';
  n400 <= '1' when n379 = "11000" else '0';
  n403 <= '1' when n379 = "11010" else '0';
  n406 <= '1' when n379 = "10010" else '0';
  n407 <= state (8);
  n408 <= not n407;
  n409 <= operand_buffer (47 downto 32);
  n410 <= operand_buffer (63 downto 48);
  n412 <= state (205 downto 190);
  n413 <= operand_buffer (47 downto 32);
  n414 <= std_logic_vector (unsigned (n412) + unsigned (n413));
  n416 <= state (221 downto 206);
  n417 <= operand_buffer (63 downto 48);
  n418 <= std_logic_vector (unsigned (n416) + unsigned (n417));
  n419 <= n418 & n414;
  n420 <= n410 & n409;
  n421 <= n419 when n408 = '0' else n420;
  n424 <= '1' when n379 = "00001" else '0';
  n426 <= n424 & n406 & n403 & n400 & n397 & n394 & n391 & n388 & n385 & n382;
  with n426 select n427 <=
    "000000" when "1000000000",
    "000000" when "0100000000",
    "000101" when "0010000000",
    "000111" when "0001000000",
    "011000" when "0000100000",
    "010110" when "0000010000",
    "001111" when "0000001000",
    "010000" when "0000000100",
    "001011" when "0000000010",
    "001100" when "0000000001",
    "000000" when others;
  n428 <= state (221 downto 190);
  with n426 select n429 <=
    n421 when "1000000000",
    n428 when "0100000000",
    n428 when "0010000000",
    n428 when "0001000000",
    n428 when "0000100000",
    n428 when "0000010000",
    n428 when "0000001000",
    n428 when "0000000100",
    n428 when "0000000010",
    n428 when "0000000001",
    n428 when others;
  with n426 select n432 <=
    '0' when "1000000000",
    '1' when "0100000000",
    '0' when "0010000000",
    '0' when "0001000000",
    '0' when "0000100000",
    '0' when "0000010000",
    '0' when "0000001000",
    '0' when "0000000100",
    '0' when "0000000010",
    '0' when "0000000001",
    '0' when others;
  n434 <= '1' when n125 = "000011" else '0';
  n436 <= operand_buffer (63 downto 54);
  n437 <= "00000" & n436;  --  uext
  n439 <= operand_buffer (53 downto 48);
  n440 <= "000000000" & n439;  --  uext
  n441 <= bdt_bmpidx (61 downto 47);
  n443 <= '1' when n125 = "000101" else '0';
  n445 <= operand_buffer (15 downto 0);
  n446 <= n445 (14 downto 0);  --  trunc
  n447 <= operand_buffer (31 downto 16);
  n448 <= n447 (14 downto 0);  --  trunc
  n449 <= operand_buffer (47 downto 32);
  n450 <= n449 (14 downto 0);  --  trunc
  n451 <= operand_buffer (63 downto 48);
  n452 <= n451 (14 downto 0);  --  trunc
  n454 <= '1' when n125 = "000111" else '0';
  n458 <= bdt_bmpidx (46 downto 32);
  n459 <= bdt_bmpidx (61 downto 47);
  n461 <= '1' when n125 = "000110" else '0';
  n464 <= '1' when n125 = "001000" else '0';
  n466 <= state (221 downto 190);
  n471 <= not stall;
  n475 <= '0' when n471 = '0' else '1';
  n478 <= '1' when n471 = '0' else '0';
  n484 <= 'X' when n471 = '0' else '1';
  n490 <= n484 when n478 = '0' else '0';
  n492 <= current_instr (4);
  n494 <= state (205 downto 190);
  n496 <= std_logic_vector (unsigned (n494) + unsigned'("0000000000000001"));
  n497 <= state (205 downto 190);
  n498 <= n497 when n492 = '0' else n496;
  n499 <= current_instr (5);
  n501 <= state (221 downto 206);
  n503 <= std_logic_vector (unsigned (n501) + unsigned'("0000000000000001"));
  n504 <= state (221 downto 206);
  n505 <= n504 when n499 = '0' else n503;
  n506 <= n505 & n498;
  n507 <= state (5 downto 0);
  n508 <= n507 when n490 = '0' else "000000";
  n509 <= state (221 downto 190);
  n510 <= n509 when n490 = '0' else n506;
  n512 <= '1' when n125 = "000100" else '0';
  n513 <= current_instr (10);
  n514 <= bdt_bmpidx (31 downto 0);
  n515 <= n514 (20 downto 0);  --  trunc
  n519 <= '0' when wrap_fr_base_addr_req = '0' else '1';
  n520 <= state (5 downto 0);
  n521 <= n520 when wrap_fr_base_addr_req = '0' else "000000";
  n522 <= state (104 downto 84);
  n523 <= n522 when wrap_fr_base_addr_req = '0' else n515;
  n524 <= bdt_bmpidx (31 downto 0);
  n525 <= n524 (20 downto 0);  --  trunc
  n528 <= '0' when n513 = '0' else n519;
  n529 <= "000000" when n513 = '0' else n521;
  n530 <= n525 when n513 = '0' else n523;
  n532 <= '1' when n125 = "010011" else '0';
  n536 <= '1' when n125 = "010100" else '0';
  n538 <= state (189 downto 158);
  n543 <= not stall;
  n547 <= '0' when n543 = '0' else '1';
  n550 <= '1' when n543 = '0' else '0';
  n556 <= 'X' when n543 = '0' else '1';
  n562 <= n556 when n550 = '0' else '0';
  n564 <= state (173 downto 158);
  n566 <= state (284 downto 270);
  n568 <= std_logic_vector (unsigned (n566) - unsigned'("000000000000001"));
  n569 <= "0" & n568;  --  uext
  n570 <= '1' when n564 = n569 else '0';
  n573 <= state (189 downto 174);
  n575 <= state (299 downto 285);
  n577 <= std_logic_vector (unsigned (n575) - unsigned'("000000000000001"));
  n578 <= "0" & n577;  --  uext
  n579 <= '1' when n573 = n578 else '0';
  n582 <= state (189 downto 174);
  n584 <= std_logic_vector (unsigned (n582) + unsigned'("0000000000000001"));
  n585 <= state (5 downto 0);
  n586 <= n585 when n603 = '0' else "000000";
  n587 <= state (189 downto 174);
  n588 <= n584 when n579 = '0' else n587;
  n590 <= state (173 downto 158);
  n592 <= std_logic_vector (unsigned (n590) + unsigned'("0000000000000001"));
  n593 <= n588 & "0000000000000000";
  n595 <= n579 and n570;
  n596 <= n593 (15 downto 0);
  n597 <= n592 when n570 = '0' else n596;
  n598 <= n593 (31 downto 16);
  n599 <= state (189 downto 174);
  n600 <= n599 when n570 = '0' else n598;
  n601 <= n600 & n597;
  n603 <= n595 and n562;
  n604 <= state (189 downto 158);
  n605 <= n604 when n562 = '0' else n601;
  n607 <= '1' when n125 = "010101" else '0';
  n609 <= state (205 downto 190);
  n612 <= '1' when n125 = "010110" else '0';
  n614 <= state (173 downto 158);
  n616 <= state (205 downto 190);
  n617 <= std_logic_vector (unsigned (n616) + unsigned (dx));
  n618 <= '1' when n614 = n617 else '0';
  n620 <= current_instr (4);
  n622 <= state (205 downto 190);
  n623 <= std_logic_vector (unsigned (n622) + unsigned (dx));
  n624 <= state (205 downto 190);
  n625 <= n624 when n620 = '0' else n623;
  n626 <= current_instr (5);
  n628 <= state (221 downto 206);
  n630 <= std_logic_vector (unsigned (n628) + unsigned'("0000000000000001"));
  n631 <= state (221 downto 206);
  n632 <= n631 when n626 = '0' else n630;
  n635 <= state (173 downto 158);
  n637 <= state (221 downto 206);
  n642 <= not stall;
  n646 <= '0' when n642 = '0' else '1';
  n649 <= '1' when n642 = '0' else '0';
  n655 <= 'X' when n642 = '0' else '1';
  n661 <= n655 when n649 = '0' else '0';
  n663 <= '1' when signed (dx) < signed'("0000000000000000") else '0';
  n665 <= state (173 downto 158);
  n667 <= std_logic_vector (unsigned (n665) - unsigned'("0000000000000001"));
  n669 <= state (173 downto 158);
  n671 <= std_logic_vector (unsigned (n669) + unsigned'("0000000000000001"));
  n672 <= n671 when n663 = '0' else n667;
  n673 <= state (173 downto 158);
  n674 <= n673 when n661 = '0' else n672;
  n675 <= n632 & n625;
  n676 <= state (5 downto 0);
  n677 <= n676 when n618 = '0' else "000000";
  n678 <= state (173 downto 158);
  n679 <= n674 when n618 = '0' else n678;
  n680 <= state (221 downto 190);
  n681 <= n680 when n618 = '0' else n675;
  n683 <= n646 when n618 = '0' else '0';
  n685 <= instr_color when n618 = '0' else "00000000";
  n686 <= n637 & n635;
  n688 <= n686 when n618 = '0' else "00000000000000000000000000000000";
  n690 <= '1' when n125 = "010111" else '0';
  n692 <= state (221 downto 206);
  n695 <= '1' when n125 = "011000" else '0';
  n697 <= state (189 downto 174);
  n699 <= state (221 downto 206);
  n700 <= std_logic_vector (unsigned (n699) + unsigned (dy));
  n701 <= '1' when n697 = n700 else '0';
  n703 <= current_instr (4);
  n705 <= state (205 downto 190);
  n707 <= std_logic_vector (unsigned (n705) + unsigned'("0000000000000001"));
  n708 <= state (205 downto 190);
  n709 <= n708 when n703 = '0' else n707;
  n710 <= current_instr (5);
  n712 <= state (221 downto 206);
  n713 <= std_logic_vector (unsigned (n712) + unsigned (dy));
  n714 <= state (221 downto 206);
  n715 <= n714 when n710 = '0' else n713;
  n718 <= state (205 downto 190);
  n720 <= state (189 downto 174);
  n725 <= not stall;
  n729 <= '0' when n725 = '0' else '1';
  n732 <= '1' when n725 = '0' else '0';
  n738 <= 'X' when n725 = '0' else '1';
  n744 <= n738 when n732 = '0' else '0';
  n746 <= '1' when signed (dy) < signed'("0000000000000000") else '0';
  n748 <= state (189 downto 174);
  n750 <= std_logic_vector (unsigned (n748) - unsigned'("0000000000000001"));
  n752 <= state (189 downto 174);
  n754 <= std_logic_vector (unsigned (n752) + unsigned'("0000000000000001"));
  n755 <= n754 when n746 = '0' else n750;
  n756 <= state (189 downto 174);
  n757 <= n756 when n744 = '0' else n755;
  n758 <= n715 & n709;
  n759 <= state (5 downto 0);
  n760 <= n759 when n701 = '0' else "000000";
  n761 <= state (189 downto 174);
  n762 <= n757 when n701 = '0' else n761;
  n763 <= state (221 downto 190);
  n764 <= n763 when n701 = '0' else n758;
  n766 <= n729 when n701 = '0' else '0';
  n768 <= instr_color when n701 = '0' else "00000000";
  n769 <= n720 & n718;
  n771 <= n769 when n701 = '0' else "00000000000000000000000000000000";
  n773 <= '1' when n125 = "011001" else '0';
  n774 <= not stall;
  n776 <= state (5 downto 0);
  n777 <= n776 when n774 = '0' else "001010";
  n780 <= '0' when n774 = '0' else '1';
  n782 <= '1' when n125 = "001001" else '0';
  n788 <= not stall;
  n792 <= '0' when n788 = '0' else '1';
  n809 <= '0' when circle_pixel_valid = '0' else n792;
  n811 <= "00000000" when circle_pixel_valid = '0' else instr_color;
  n813 <= "00000000000000000000000000000000" when circle_pixel_valid = '0' else circle_pixel;
  n814 <= not circle_busy;
  n815 <= current_instr (4);
  n817 <= state (205 downto 190);
  n819 <= '0' & radius;
  n820 <= std_logic_vector (unsigned (n817) + unsigned (n819));
  n821 <= state (205 downto 190);
  n822 <= n821 when n815 = '0' else n820;
  n823 <= current_instr (5);
  n825 <= state (221 downto 206);
  n827 <= '0' & radius;
  n828 <= std_logic_vector (unsigned (n825) + unsigned (n827));
  n829 <= state (221 downto 206);
  n830 <= n829 when n823 = '0' else n828;
  n832 <= n830 & n822;
  n833 <= state (5 downto 0);
  n834 <= n833 when n814 = '0' else "000000";
  n835 <= state (221 downto 190);
  n836 <= n835 when n814 = '0' else n832;
  n838 <= '1' when n125 = "001010" else '0';
  n846 <= '1' when n125 = "011111" else '0';
  n860 <= current_instr (9 downto 8);
  n863 <= state (173 downto 158);
  n866 <= state (189 downto 174);
  n869 <= '1' when n860 = "10" else '0';
  n871 <= '1' when n860 = "11" else '0';
  n872 <= n869 or n871;
  n873 <= bb_section (44 downto 30);
  n875 <= '0' & n873;
  n877 <= state (173 downto 158);
  n878 <= std_logic_vector (unsigned (n875) - unsigned (n877));
  n880 <= std_logic_vector (unsigned (n878) - unsigned'("0000000000000001"));
  n881 <= n863 when n872 = '0' else n880;
  n883 <= '1' when n860 = "01" else '0';
  n885 <= '1' when n860 = "10" else '0';
  n886 <= n883 or n885;
  n887 <= bb_section (59 downto 45);
  n889 <= '0' & n887;
  n891 <= state (189 downto 174);
  n892 <= std_logic_vector (unsigned (n889) - unsigned (n891));
  n894 <= std_logic_vector (unsigned (n892) - unsigned'("0000000000000001"));
  n895 <= n866 when n886 = '0' else n894;
  n897 <= '1' when n860 = "01" else '0';
  n899 <= '1' when n860 = "11" else '0';
  n900 <= n897 or n899;
  n902 <= state (205 downto 190);
  n903 <= std_logic_vector (unsigned (n902) + unsigned (n895));
  n905 <= state (221 downto 206);
  n906 <= std_logic_vector (unsigned (n905) + unsigned (n881));
  n908 <= state (205 downto 190);
  n909 <= std_logic_vector (unsigned (n908) + unsigned (n881));
  n911 <= state (221 downto 206);
  n912 <= std_logic_vector (unsigned (n911) + unsigned (n895));
  n913 <= n909 when n900 = '0' else n903;
  n915 <= n912 when n900 = '0' else n906;
  n924 <= state (309 downto 308);
  n925 <= state (307 downto 300);
  n926 <= pr_color and n925;
  n928 <= '1' when n924 = "01" else '0';
  n929 <= state (307 downto 300);
  n930 <= pr_color or n929;
  n932 <= '1' when n924 = "10" else '0';
  n933 <= state (307 downto 300);
  n934 <= pr_color xor n933;
  n936 <= '1' when n924 = "11" else '0';
  n937 <= n936 & n932 & n928;
  with n937 select n942 <=
    '0' when "100",
    '0' when "010",
    '0' when "001",
    '1' when others;
  with n937 select n950 <=
    n934 when "100",
    n930 when "010",
    n926 when "001",
    "XXXXXXXX" when others;
  n955 <= n950 when n942 = '0' else pr_color;
  n956 <= current_instr (10);
  n961 <= not stall;
  n965 <= '0' when n961 = '0' else '1';
  n968 <= '1' when n961 = '0' else '0';
  n974 <= 'X' when n961 = '0' else '1';
  n980 <= n974 when n968 = '0' else '0';
  n982 <= state (173 downto 158);
  n983 <= bb_section (44 downto 30);
  n985 <= std_logic_vector (unsigned (n983) - unsigned'("000000000000001"));
  n986 <= "0" & n985;  --  uext
  n987 <= '1' when n982 = n986 else '0';
  n990 <= state (189 downto 174);
  n991 <= bb_section (59 downto 45);
  n993 <= std_logic_vector (unsigned (n991) - unsigned'("000000000000001"));
  n994 <= "0" & n993;  --  uext
  n995 <= '1' when n990 = n994 else '0';
  n998 <= state (189 downto 174);
  n1000 <= std_logic_vector (unsigned (n998) + unsigned'("0000000000000001"));
  n1001 <= state (5 downto 0);
  n1002 <= n1001 when n1026 = '0' else "100001";
  n1003 <= state (189 downto 174);
  n1004 <= n1000 when n995 = '0' else n1003;
  n1006 <= state (173 downto 158);
  n1008 <= std_logic_vector (unsigned (n1006) + unsigned'("0000000000000001"));
  n1009 <= n1004 & "0000000000000000";
  n1011 <= n995 and n987;
  n1012 <= n1009 (15 downto 0);
  n1013 <= n1008 when n987 = '0' else n1012;
  n1014 <= n1009 (31 downto 16);
  n1015 <= state (189 downto 174);
  n1016 <= n1015 when n987 = '0' else n1014;
  n1017 <= n1016 & n1013;
  n1019 <= n1011 and n980;
  n1020 <= state (189 downto 158);
  n1021 <= n1020 when n1028 = '0' else n1017;
  n1024 <= '0' when n980 = '0' else '1';
  n1026 <= n1019 and pr_color_valid;
  n1028 <= n980 and pr_color_valid;
  n1030 <= '0' when pr_color_valid = '0' else n965;
  n1032 <= "00000000" when pr_color_valid = '0' else n955;
  n1033 <= n915 & n913;
  n1035 <= "00000000000000000000000000000000" when pr_color_valid = '0' else n1033;
  n1037 <= '0' when pr_color_valid = '0' else n956;
  n1039 <= '0' when pr_color_valid = '0' else n1024;
  n1041 <= '1' when n125 = "100000" else '0';
  n1051 <= current_instr (9 downto 8);
  n1053 <= current_instr (4);
  n1055 <= '1' when n1051 = "01" else '0';
  n1057 <= '1' when n1051 = "11" else '0';
  n1058 <= n1055 or n1057;
  n1060 <= state (205 downto 190);
  n1061 <= bb_section (59 downto 45);
  n1063 <= '0' & n1061;
  n1064 <= std_logic_vector (unsigned (n1060) + unsigned (n1063));
  n1066 <= state (205 downto 190);
  n1067 <= bb_section (44 downto 30);
  n1069 <= '0' & n1067;
  n1070 <= std_logic_vector (unsigned (n1066) + unsigned (n1069));
  n1071 <= n1070 when n1058 = '0' else n1064;
  n1072 <= state (205 downto 190);
  n1073 <= n1072 when n1053 = '0' else n1071;
  n1074 <= current_instr (5);
  n1076 <= '1' when n1051 = "01" else '0';
  n1078 <= '1' when n1051 = "11" else '0';
  n1079 <= n1076 or n1078;
  n1081 <= state (221 downto 206);
  n1082 <= bb_section (44 downto 30);
  n1084 <= '0' & n1082;
  n1085 <= std_logic_vector (unsigned (n1081) + unsigned (n1084));
  n1087 <= state (221 downto 206);
  n1088 <= bb_section (59 downto 45);
  n1090 <= '0' & n1088;
  n1091 <= std_logic_vector (unsigned (n1087) + unsigned (n1090));
  n1092 <= n1091 when n1079 = '0' else n1085;
  n1093 <= state (221 downto 206);
  n1094 <= n1093 when n1074 = '0' else n1092;
  n1097 <= '1' when n125 = "100001" else '0';
  n1098 <= not wrap_vram_wr_full;
  n1099 <= addrhi & addrlo;
  n1100 <= current_instr (0);
  n1103 <= '0' when n1100 = '0' else '1';
  n1106 <= state (5 downto 0);
  n1107 <= n1106 when n1098 = '0' else "000000";
  n1110 <= '0' when n1098 = '0' else '1';
  n1112 <= "000000000000000000000" when n1098 = '0' else n1099;
  n1114 <= "0000000000000000" when n1098 = '0' else data;
  n1116 <= '1' when n1098 = '0' else n1103;
  n1118 <= '1' when n125 = "001011" else '0';
  n1119 <= addrhi & addrlo;
  n1122 <= '1' when n125 = "010000" else '0';
  n1123 <= addrhi & addrlo;
  n1126 <= '1' when n125 = "001111" else '0';
  n1127 <= not wrap_gcf_empty;
  n1133 <= current_instr (15 downto 11);
  n1135 <= '1' when n1133 = "01110" else '0';
  n1138 <= '0' when n1135 = '0' else '1';
  n1139 <= state (157 downto 142);
  n1141 <= std_logic_vector (unsigned (n1139) - unsigned'("0000000000000001"));
  n1144 <= '0' when n1127 = '0' else n1138;
  n1145 <= state (5 downto 0);
  n1146 <= n1145 when n1127 = '0' else "010010";
  n1147 <= state (157 downto 142);
  n1148 <= n1147 when n1127 = '0' else n1141;
  n1150 <= '1' when n125 = "010001" else '0';
  n1151 <= state (141 downto 121);
  n1157 <= current_instr (15 downto 11);
  n1159 <= '1' when n1157 = "01110" else '0';
  n1160 <= data when n1159 = '0' else wrap_gcf_data;
  n1161 <= not wrap_vram_wr_full;
  n1162 <= current_instr (0);
  n1163 <= state (141 downto 121);
  n1165 <= std_logic_vector (unsigned (n1163) + unsigned'("000000000000000000010"));
  n1166 <= state (141 downto 121);
  n1168 <= std_logic_vector (unsigned (n1166) + unsigned'("000000000000000000001"));
  n1169 <= n1168 when n1162 = '0' else n1165;
  n1172 <= '0' when n1162 = '0' else '1';
  n1173 <= state (157 downto 142);
  n1175 <= '1' when n1173 = "0000000000000000" else '0';
  n1178 <= "010001" when n1175 = '0' else "000000";
  n1179 <= state (5 downto 0);
  n1180 <= n1179 when n1161 = '0' else n1178;
  n1181 <= state (141 downto 121);
  n1182 <= n1181 when n1161 = '0' else n1169;
  n1185 <= '0' when n1161 = '0' else '1';
  n1187 <= '1' when n1161 = '0' else n1172;
  n1189 <= '1' when n125 = "010010" else '0';
  n1191 <= addrhi & addrlo;
  n1192 <= current_instr (0);
  n1195 <= '0' when n1192 = '0' else '1';
  n1198 <= '0' when wrap_vram_wr_emtpy = '0' else '1';
  n1200 <= '1' when n125 = "001100" else '0';
  n1202 <= state (5 downto 0);
  n1203 <= n1202 when wrap_vram_rd_valid = '0' else "001110";
  n1204 <= state (120 downto 105);
  n1205 <= n1204 when wrap_vram_rd_valid = '0' else wrap_vram_rd_data;
  n1207 <= '1' when n125 = "001101" else '0';
  n1210 <= '1' when n125 = "001110" else '0';
  n1212 <= state (221 downto 190);
  n1214 <= '1' when n125 = "011010" else '0';
  n1216 <= state (221 downto 190);
  n1218 <= '1' when n125 = "011011" else '0';
  n1219 <= state (221 downto 190);
  n1220 <= not pw_oob;
  n1224 <= '0' when wrap_vram_wr_emtpy = '0' else '1';
  n1225 <= state (5 downto 0);
  n1226 <= n1225 when wrap_vram_wr_emtpy = '0' else "011101";
  n1230 <= '0' when n1220 = '0' else n1224;
  n1231 <= "011110" when n1220 = '0' else n1226;
  n1232 <= state (120 downto 105);
  n1233 <= "1111111111111111" when n1220 = '0' else n1232;
  n1235 <= '1' when n125 = "011100" else '0';
  n1236 <= state (221 downto 190);
  n1238 <= state (5 downto 0);
  n1239 <= n1238 when wrap_vram_rd_valid = '0' else "011110";
  n1240 <= state (120 downto 105);
  n1241 <= n1240 when wrap_vram_rd_valid = '0' else wrap_vram_rd_data;
  n1243 <= '1' when n125 = "011101" else '0';
  n1245 <= current_instr (4);
  n1247 <= state (205 downto 190);
  n1249 <= std_logic_vector (unsigned (n1247) + unsigned'("0000000000000001"));
  n1250 <= state (205 downto 190);
  n1251 <= n1250 when n1245 = '0' else n1249;
  n1252 <= current_instr (5);
  n1254 <= state (221 downto 206);
  n1256 <= std_logic_vector (unsigned (n1254) + unsigned'("0000000000000001"));
  n1257 <= state (221 downto 206);
  n1258 <= n1257 when n1252 = '0' else n1256;
  n1260 <= '1' when n125 = "011110" else '0';
  n1261 <= n1260 & n1243 & n1235 & n1218 & n1214 & n1210 & n1207 & n1200 & n1189 & n1150 & n1126 & n1122 & n1118 & n1097 & n1041 & n846 & n838 & n782 & n773 & n695 & n690 & n612 & n607 & n536 & n532 & n512 & n464 & n461 & n454 & n443 & n434 & n372 & n351 & n134;
  with n1261 select n1262 <=
    pw_vram_wr_addr when "1000000000000000000000000000000000",
    pw_vram_wr_addr when "0100000000000000000000000000000000",
    pw_vram_wr_addr when "0010000000000000000000000000000000",
    pw_vram_wr_addr when "0001000000000000000000000000000000",
    pw_vram_wr_addr when "0000100000000000000000000000000000",
    pw_vram_wr_addr when "0000010000000000000000000000000000",
    pw_vram_wr_addr when "0000001000000000000000000000000000",
    n1191 when "0000000100000000000000000000000000",
    pw_vram_wr_addr when "0000000010000000000000000000000000",
    pw_vram_wr_addr when "0000000001000000000000000000000000",
    pw_vram_wr_addr when "0000000000100000000000000000000000",
    pw_vram_wr_addr when "0000000000010000000000000000000000",
    pw_vram_wr_addr when "0000000000001000000000000000000000",
    pw_vram_wr_addr when "0000000000000100000000000000000000",
    pr_vram_rd_addr when "0000000000000010000000000000000000",
    pw_vram_wr_addr when "0000000000000001000000000000000000",
    pw_vram_wr_addr when "0000000000000000100000000000000000",
    pw_vram_wr_addr when "0000000000000000010000000000000000",
    pw_vram_wr_addr when "0000000000000000001000000000000000",
    pw_vram_wr_addr when "0000000000000000000100000000000000",
    pw_vram_wr_addr when "0000000000000000000010000000000000",
    pw_vram_wr_addr when "0000000000000000000001000000000000",
    pw_vram_wr_addr when "0000000000000000000000100000000000",
    pw_vram_wr_addr when "0000000000000000000000010000000000",
    pw_vram_wr_addr when "0000000000000000000000001000000000",
    pw_vram_wr_addr when "0000000000000000000000000100000000",
    pw_vram_wr_addr when "0000000000000000000000000010000000",
    pw_vram_wr_addr when "0000000000000000000000000001000000",
    pw_vram_wr_addr when "0000000000000000000000000000100000",
    pw_vram_wr_addr when "0000000000000000000000000000010000",
    pw_vram_wr_addr when "0000000000000000000000000000001000",
    pw_vram_wr_addr when "0000000000000000000000000000000100",
    pw_vram_wr_addr when "0000000000000000000000000000000010",
    pw_vram_wr_addr when "0000000000000000000000000000000001",
    pw_vram_wr_addr when others;
  with n1261 select n1264 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    n1230 when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    n1198 when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    pr_vram_rd when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1267 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    n1195 when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    pr_vram_rd_access_mode when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1270 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    n1144 when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    '0' when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    n366 when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    n130 when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1275 <=
    '1' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '1' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    '0' when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1278 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    '0' when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    n528 when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  n1280 <= state (5 downto 0);
  with n1261 select n1281 <=
    "000000" when "1000000000000000000000000000000000",
    n1239 when "0100000000000000000000000000000000",
    n1231 when "0010000000000000000000000000000000",
    "011100" when "0001000000000000000000000000000000",
    "011011" when "0000100000000000000000000000000000",
    "000000" when "0000010000000000000000000000000000",
    n1203 when "0000001000000000000000000000000000",
    "001101" when "0000000100000000000000000000000000",
    n1180 when "0000000010000000000000000000000000",
    n1146 when "0000000001000000000000000000000000",
    "010001" when "0000000000100000000000000000000000",
    "010001" when "0000000000010000000000000000000000",
    n1107 when "0000000000001000000000000000000000",
    "000000" when "0000000000000100000000000000000000",
    n1002 when "0000000000000010000000000000000000",
    "100000" when "0000000000000001000000000000000000",
    n834 when "0000000000000000100000000000000000",
    n777 when "0000000000000000010000000000000000",
    n760 when "0000000000000000001000000000000000",
    "011001" when "0000000000000000000100000000000000",
    n677 when "0000000000000000000010000000000000",
    "010111" when "0000000000000000000001000000000000",
    n586 when "0000000000000000000000100000000000",
    "010101" when "0000000000000000000000010000000000",
    n529 when "0000000000000000000000001000000000",
    n508 when "0000000000000000000000000100000000",
    "000000" when "0000000000000000000000000010000000",
    "011111" when "0000000000000000000000000001000000",
    "011111" when "0000000000000000000000000000100000",
    "011111" when "0000000000000000000000000000010000",
    n427 when "0000000000000000000000000000001000",
    n368 when "0000000000000000000000000000000100",
    n313 when "0000000000000000000000000000000010",
    n132 when "0000000000000000000000000000000001",
    n1280 when others;
  n1282 <= state (21 downto 6);
  with n1261 select n1283 <=
    n1282 when "1000000000000000000000000000000000",
    n1282 when "0100000000000000000000000000000000",
    n1282 when "0010000000000000000000000000000000",
    n1282 when "0001000000000000000000000000000000",
    n1282 when "0000100000000000000000000000000000",
    n1282 when "0000010000000000000000000000000000",
    n1282 when "0000001000000000000000000000000000",
    n1282 when "0000000100000000000000000000000000",
    n1282 when "0000000010000000000000000000000000",
    n1282 when "0000000001000000000000000000000000",
    n1282 when "0000000000100000000000000000000000",
    n1282 when "0000000000010000000000000000000000",
    n1282 when "0000000000001000000000000000000000",
    n1282 when "0000000000000100000000000000000000",
    n1282 when "0000000000000010000000000000000000",
    n1282 when "0000000000000001000000000000000000",
    n1282 when "0000000000000000100000000000000000",
    n1282 when "0000000000000000010000000000000000",
    n1282 when "0000000000000000001000000000000000",
    n1282 when "0000000000000000000100000000000000",
    n1282 when "0000000000000000000010000000000000",
    n1282 when "0000000000000000000001000000000000",
    n1282 when "0000000000000000000000100000000000",
    n1282 when "0000000000000000000000010000000000",
    n1282 when "0000000000000000000000001000000000",
    n1282 when "0000000000000000000000000100000000",
    n1282 when "0000000000000000000000000010000000",
    n1282 when "0000000000000000000000000001000000",
    n1282 when "0000000000000000000000000000100000",
    n1282 when "0000000000000000000000000000010000",
    n1282 when "0000000000000000000000000000001000",
    n1282 when "0000000000000000000000000000000100",
    wrap_gcf_data when "0000000000000000000000000000000010",
    n1282 when "0000000000000000000000000000000001",
    n1282 when others;
  n1284 <= state (23 downto 22);
  with n1261 select n1285 <=
    n1284 when "1000000000000000000000000000000000",
    n1284 when "0100000000000000000000000000000000",
    n1284 when "0010000000000000000000000000000000",
    n1284 when "0001000000000000000000000000000000",
    n1284 when "0000100000000000000000000000000000",
    n1284 when "0000010000000000000000000000000000",
    n1284 when "0000001000000000000000000000000000",
    n1284 when "0000000100000000000000000000000000",
    n1284 when "0000000010000000000000000000000000",
    n1284 when "0000000001000000000000000000000000",
    n1284 when "0000000000100000000000000000000000",
    n1284 when "0000000000010000000000000000000000",
    n1284 when "0000000000001000000000000000000000",
    n1284 when "0000000000000100000000000000000000",
    n1284 when "0000000000000010000000000000000000",
    n1284 when "0000000000000001000000000000000000",
    n1284 when "0000000000000000100000000000000000",
    n1284 when "0000000000000000010000000000000000",
    n1284 when "0000000000000000001000000000000000",
    n1284 when "0000000000000000000100000000000000",
    n1284 when "0000000000000000000010000000000000",
    n1284 when "0000000000000000000001000000000000",
    n1284 when "0000000000000000000000100000000000",
    n1284 when "0000000000000000000000010000000000",
    n1284 when "0000000000000000000000001000000000",
    n1284 when "0000000000000000000000000100000000",
    n1284 when "0000000000000000000000000010000000",
    n1284 when "0000000000000000000000000001000000",
    n1284 when "0000000000000000000000000000100000",
    n1284 when "0000000000000000000000000000010000",
    n1284 when "0000000000000000000000000000001000",
    n370 when "0000000000000000000000000000000100",
    n314 when "0000000000000000000000000000000010",
    n1284 when "0000000000000000000000000000000001",
    n1284 when others;
  n1286 <= state (38 downto 24);
  with n1261 select n1287 <=
    n1286 when "1000000000000000000000000000000000",
    n1286 when "0100000000000000000000000000000000",
    n1286 when "0010000000000000000000000000000000",
    n1286 when "0001000000000000000000000000000000",
    n1286 when "0000100000000000000000000000000000",
    n1286 when "0000010000000000000000000000000000",
    n1286 when "0000001000000000000000000000000000",
    n1286 when "0000000100000000000000000000000000",
    n1286 when "0000000010000000000000000000000000",
    n1286 when "0000000001000000000000000000000000",
    n1286 when "0000000000100000000000000000000000",
    n1286 when "0000000000010000000000000000000000",
    n1286 when "0000000000001000000000000000000000",
    n1286 when "0000000000000100000000000000000000",
    n1286 when "0000000000000010000000000000000000",
    n1286 when "0000000000000001000000000000000000",
    n1286 when "0000000000000000100000000000000000",
    n1286 when "0000000000000000010000000000000000",
    n1286 when "0000000000000000001000000000000000",
    n1286 when "0000000000000000000100000000000000",
    n1286 when "0000000000000000000010000000000000",
    n1286 when "0000000000000000000001000000000000",
    n1286 when "0000000000000000000000100000000000",
    n1286 when "0000000000000000000000010000000000",
    n1286 when "0000000000000000000000001000000000",
    n1286 when "0000000000000000000000000100000000",
    n1286 when "0000000000000000000000000010000000",
    "000000000000000" when "0000000000000000000000000001000000",
    n446 when "0000000000000000000000000000100000",
    n437 when "0000000000000000000000000000010000",
    n1286 when "0000000000000000000000000000001000",
    n1286 when "0000000000000000000000000000000100",
    n1286 when "0000000000000000000000000000000010",
    n1286 when "0000000000000000000000000000000001",
    n1286 when others;
  n1288 <= state (53 downto 39);
  with n1261 select n1289 <=
    n1288 when "1000000000000000000000000000000000",
    n1288 when "0100000000000000000000000000000000",
    n1288 when "0010000000000000000000000000000000",
    n1288 when "0001000000000000000000000000000000",
    n1288 when "0000100000000000000000000000000000",
    n1288 when "0000010000000000000000000000000000",
    n1288 when "0000001000000000000000000000000000",
    n1288 when "0000000100000000000000000000000000",
    n1288 when "0000000010000000000000000000000000",
    n1288 when "0000000001000000000000000000000000",
    n1288 when "0000000000100000000000000000000000",
    n1288 when "0000000000010000000000000000000000",
    n1288 when "0000000000001000000000000000000000",
    n1288 when "0000000000000100000000000000000000",
    n1288 when "0000000000000010000000000000000000",
    n1288 when "0000000000000001000000000000000000",
    n1288 when "0000000000000000100000000000000000",
    n1288 when "0000000000000000010000000000000000",
    n1288 when "0000000000000000001000000000000000",
    n1288 when "0000000000000000000100000000000000",
    n1288 when "0000000000000000000010000000000000",
    n1288 when "0000000000000000000001000000000000",
    n1288 when "0000000000000000000000100000000000",
    n1288 when "0000000000000000000000010000000000",
    n1288 when "0000000000000000000000001000000000",
    n1288 when "0000000000000000000000000100000000",
    n1288 when "0000000000000000000000000010000000",
    "000000000000000" when "0000000000000000000000000001000000",
    n448 when "0000000000000000000000000000100000",
    "000000000000000" when "0000000000000000000000000000010000",
    n1288 when "0000000000000000000000000000001000",
    n1288 when "0000000000000000000000000000000100",
    n1288 when "0000000000000000000000000000000010",
    n1288 when "0000000000000000000000000000000001",
    n1288 when others;
  n1290 <= state (68 downto 54);
  with n1261 select n1291 <=
    n1290 when "1000000000000000000000000000000000",
    n1290 when "0100000000000000000000000000000000",
    n1290 when "0010000000000000000000000000000000",
    n1290 when "0001000000000000000000000000000000",
    n1290 when "0000100000000000000000000000000000",
    n1290 when "0000010000000000000000000000000000",
    n1290 when "0000001000000000000000000000000000",
    n1290 when "0000000100000000000000000000000000",
    n1290 when "0000000010000000000000000000000000",
    n1290 when "0000000001000000000000000000000000",
    n1290 when "0000000000100000000000000000000000",
    n1290 when "0000000000010000000000000000000000",
    n1290 when "0000000000001000000000000000000000",
    n1290 when "0000000000000100000000000000000000",
    n1290 when "0000000000000010000000000000000000",
    n1290 when "0000000000000001000000000000000000",
    n1290 when "0000000000000000100000000000000000",
    n1290 when "0000000000000000010000000000000000",
    n1290 when "0000000000000000001000000000000000",
    n1290 when "0000000000000000000100000000000000",
    n1290 when "0000000000000000000010000000000000",
    n1290 when "0000000000000000000001000000000000",
    n1290 when "0000000000000000000000100000000000",
    n1290 when "0000000000000000000000010000000000",
    n1290 when "0000000000000000000000001000000000",
    n1290 when "0000000000000000000000000100000000",
    n1290 when "0000000000000000000000000010000000",
    n458 when "0000000000000000000000000001000000",
    n450 when "0000000000000000000000000000100000",
    n440 when "0000000000000000000000000000010000",
    n1290 when "0000000000000000000000000000001000",
    n1290 when "0000000000000000000000000000000100",
    n1290 when "0000000000000000000000000000000010",
    n1290 when "0000000000000000000000000000000001",
    n1290 when others;
  n1292 <= state (83 downto 69);
  with n1261 select n1293 <=
    n1292 when "1000000000000000000000000000000000",
    n1292 when "0100000000000000000000000000000000",
    n1292 when "0010000000000000000000000000000000",
    n1292 when "0001000000000000000000000000000000",
    n1292 when "0000100000000000000000000000000000",
    n1292 when "0000010000000000000000000000000000",
    n1292 when "0000001000000000000000000000000000",
    n1292 when "0000000100000000000000000000000000",
    n1292 when "0000000010000000000000000000000000",
    n1292 when "0000000001000000000000000000000000",
    n1292 when "0000000000100000000000000000000000",
    n1292 when "0000000000010000000000000000000000",
    n1292 when "0000000000001000000000000000000000",
    n1292 when "0000000000000100000000000000000000",
    n1292 when "0000000000000010000000000000000000",
    n1292 when "0000000000000001000000000000000000",
    n1292 when "0000000000000000100000000000000000",
    n1292 when "0000000000000000010000000000000000",
    n1292 when "0000000000000000001000000000000000",
    n1292 when "0000000000000000000100000000000000",
    n1292 when "0000000000000000000010000000000000",
    n1292 when "0000000000000000000001000000000000",
    n1292 when "0000000000000000000000100000000000",
    n1292 when "0000000000000000000000010000000000",
    n1292 when "0000000000000000000000001000000000",
    n1292 when "0000000000000000000000000100000000",
    n1292 when "0000000000000000000000000010000000",
    n459 when "0000000000000000000000000001000000",
    n452 when "0000000000000000000000000000100000",
    n441 when "0000000000000000000000000000010000",
    n1292 when "0000000000000000000000000000001000",
    n1292 when "0000000000000000000000000000000100",
    n1292 when "0000000000000000000000000000000010",
    n1292 when "0000000000000000000000000000000001",
    n1292 when others;
  n1294 <= state (104 downto 84);
  with n1261 select n1295 <=
    n1294 when "1000000000000000000000000000000000",
    n1294 when "0100000000000000000000000000000000",
    n1294 when "0010000000000000000000000000000000",
    n1294 when "0001000000000000000000000000000000",
    n1294 when "0000100000000000000000000000000000",
    n1294 when "0000010000000000000000000000000000",
    n1294 when "0000001000000000000000000000000000",
    n1294 when "0000000100000000000000000000000000",
    n1294 when "0000000010000000000000000000000000",
    n1294 when "0000000001000000000000000000000000",
    n1294 when "0000000000100000000000000000000000",
    n1294 when "0000000000010000000000000000000000",
    n1294 when "0000000000001000000000000000000000",
    n1294 when "0000000000000100000000000000000000",
    n1294 when "0000000000000010000000000000000000",
    n1294 when "0000000000000001000000000000000000",
    n1294 when "0000000000000000100000000000000000",
    n1294 when "0000000000000000010000000000000000",
    n1294 when "0000000000000000001000000000000000",
    n1294 when "0000000000000000000100000000000000",
    n1294 when "0000000000000000000010000000000000",
    n1294 when "0000000000000000000001000000000000",
    n1294 when "0000000000000000000000100000000000",
    n1294 when "0000000000000000000000010000000000",
    n530 when "0000000000000000000000001000000000",
    n1294 when "0000000000000000000000000100000000",
    n1294 when "0000000000000000000000000010000000",
    n1294 when "0000000000000000000000000001000000",
    n1294 when "0000000000000000000000000000100000",
    n1294 when "0000000000000000000000000000010000",
    n1294 when "0000000000000000000000000000001000",
    n1294 when "0000000000000000000000000000000100",
    n1294 when "0000000000000000000000000000000010",
    n1294 when "0000000000000000000000000000000001",
    n1294 when others;
  n1296 <= state (120 downto 105);
  with n1261 select n1297 <=
    n1296 when "1000000000000000000000000000000000",
    n1241 when "0100000000000000000000000000000000",
    n1233 when "0010000000000000000000000000000000",
    n1296 when "0001000000000000000000000000000000",
    n1296 when "0000100000000000000000000000000000",
    n1296 when "0000010000000000000000000000000000",
    n1205 when "0000001000000000000000000000000000",
    n1296 when "0000000100000000000000000000000000",
    n1296 when "0000000010000000000000000000000000",
    n1296 when "0000000001000000000000000000000000",
    n1296 when "0000000000100000000000000000000000",
    n1296 when "0000000000010000000000000000000000",
    n1296 when "0000000000001000000000000000000000",
    n1296 when "0000000000000100000000000000000000",
    n1296 when "0000000000000010000000000000000000",
    n1296 when "0000000000000001000000000000000000",
    n1296 when "0000000000000000100000000000000000",
    n1296 when "0000000000000000010000000000000000",
    n1296 when "0000000000000000001000000000000000",
    n1296 when "0000000000000000000100000000000000",
    n1296 when "0000000000000000000010000000000000",
    n1296 when "0000000000000000000001000000000000",
    n1296 when "0000000000000000000000100000000000",
    n1296 when "0000000000000000000000010000000000",
    n1296 when "0000000000000000000000001000000000",
    n1296 when "0000000000000000000000000100000000",
    n1296 when "0000000000000000000000000010000000",
    n1296 when "0000000000000000000000000001000000",
    n1296 when "0000000000000000000000000000100000",
    n1296 when "0000000000000000000000000000010000",
    n1296 when "0000000000000000000000000000001000",
    n1296 when "0000000000000000000000000000000100",
    n1296 when "0000000000000000000000000000000010",
    n1296 when "0000000000000000000000000000000001",
    n1296 when others;
  n1298 <= state (141 downto 121);
  with n1261 select n1299 <=
    n1298 when "1000000000000000000000000000000000",
    n1298 when "0100000000000000000000000000000000",
    n1298 when "0010000000000000000000000000000000",
    n1298 when "0001000000000000000000000000000000",
    n1298 when "0000100000000000000000000000000000",
    n1298 when "0000010000000000000000000000000000",
    n1298 when "0000001000000000000000000000000000",
    n1298 when "0000000100000000000000000000000000",
    n1182 when "0000000010000000000000000000000000",
    n1298 when "0000000001000000000000000000000000",
    n1123 when "0000000000100000000000000000000000",
    n1119 when "0000000000010000000000000000000000",
    n1298 when "0000000000001000000000000000000000",
    n1298 when "0000000000000100000000000000000000",
    n1298 when "0000000000000010000000000000000000",
    n1298 when "0000000000000001000000000000000000",
    n1298 when "0000000000000000100000000000000000",
    n1298 when "0000000000000000010000000000000000",
    n1298 when "0000000000000000001000000000000000",
    n1298 when "0000000000000000000100000000000000",
    n1298 when "0000000000000000000010000000000000",
    n1298 when "0000000000000000000001000000000000",
    n1298 when "0000000000000000000000100000000000",
    n1298 when "0000000000000000000000010000000000",
    n1298 when "0000000000000000000000001000000000",
    n1298 when "0000000000000000000000000100000000",
    n1298 when "0000000000000000000000000010000000",
    n1298 when "0000000000000000000000000001000000",
    n1298 when "0000000000000000000000000000100000",
    n1298 when "0000000000000000000000000000010000",
    n1298 when "0000000000000000000000000000001000",
    n1298 when "0000000000000000000000000000000100",
    n1298 when "0000000000000000000000000000000010",
    n1298 when "0000000000000000000000000000000001",
    n1298 when others;
  n1300 <= state (157 downto 142);
  with n1261 select n1301 <=
    n1300 when "1000000000000000000000000000000000",
    n1300 when "0100000000000000000000000000000000",
    n1300 when "0010000000000000000000000000000000",
    n1300 when "0001000000000000000000000000000000",
    n1300 when "0000100000000000000000000000000000",
    n1300 when "0000010000000000000000000000000000",
    n1300 when "0000001000000000000000000000000000",
    n1300 when "0000000100000000000000000000000000",
    n1300 when "0000000010000000000000000000000000",
    n1148 when "0000000001000000000000000000000000",
    n when "0000000000100000000000000000000000",
    n when "0000000000010000000000000000000000",
    n1300 when "0000000000001000000000000000000000",
    n1300 when "0000000000000100000000000000000000",
    n1300 when "0000000000000010000000000000000000",
    n1300 when "0000000000000001000000000000000000",
    n1300 when "0000000000000000100000000000000000",
    n1300 when "0000000000000000010000000000000000",
    n1300 when "0000000000000000001000000000000000",
    n1300 when "0000000000000000000100000000000000",
    n1300 when "0000000000000000000010000000000000",
    n1300 when "0000000000000000000001000000000000",
    n1300 when "0000000000000000000000100000000000",
    n1300 when "0000000000000000000000010000000000",
    n1300 when "0000000000000000000000001000000000",
    n1300 when "0000000000000000000000000100000000",
    n1300 when "0000000000000000000000000010000000",
    n1300 when "0000000000000000000000000001000000",
    n1300 when "0000000000000000000000000000100000",
    n1300 when "0000000000000000000000000000010000",
    n1300 when "0000000000000000000000000000001000",
    n1300 when "0000000000000000000000000000000100",
    n1300 when "0000000000000000000000000000000010",
    n1300 when "0000000000000000000000000000000001",
    n1300 when others;
  n1302 <= n533 (15 downto 0);
  n1303 <= n605 (15 downto 0);
  n1304 <= n1021 (15 downto 0);
  n1305 <= state (173 downto 158);
  with n1261 select n1306 <=
    n1305 when "1000000000000000000000000000000000",
    n1305 when "0100000000000000000000000000000000",
    n1305 when "0010000000000000000000000000000000",
    n1305 when "0001000000000000000000000000000000",
    n1305 when "0000100000000000000000000000000000",
    n1305 when "0000010000000000000000000000000000",
    n1305 when "0000001000000000000000000000000000",
    n1305 when "0000000100000000000000000000000000",
    n1305 when "0000000010000000000000000000000000",
    n1305 when "0000000001000000000000000000000000",
    n1305 when "0000000000100000000000000000000000",
    n1305 when "0000000000010000000000000000000000",
    n1305 when "0000000000001000000000000000000000",
    n1305 when "0000000000000100000000000000000000",
    n1304 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1305 when "0000000000000000100000000000000000",
    n1305 when "0000000000000000010000000000000000",
    n1305 when "0000000000000000001000000000000000",
    n1305 when "0000000000000000000100000000000000",
    n679 when "0000000000000000000010000000000000",
    n609 when "0000000000000000000001000000000000",
    n1303 when "0000000000000000000000100000000000",
    n1302 when "0000000000000000000000010000000000",
    n1305 when "0000000000000000000000001000000000",
    n1305 when "0000000000000000000000000100000000",
    n1305 when "0000000000000000000000000010000000",
    n1305 when "0000000000000000000000000001000000",
    n1305 when "0000000000000000000000000000100000",
    n1305 when "0000000000000000000000000000010000",
    n1305 when "0000000000000000000000000000001000",
    n1305 when "0000000000000000000000000000000100",
    n1305 when "0000000000000000000000000000000010",
    n1305 when "0000000000000000000000000000000001",
    n1305 when others;
  n1307 <= n533 (31 downto 16);
  n1308 <= n605 (31 downto 16);
  n1309 <= n1021 (31 downto 16);
  n1310 <= state (189 downto 174);
  with n1261 select n1311 <=
    n1310 when "1000000000000000000000000000000000",
    n1310 when "0100000000000000000000000000000000",
    n1310 when "0010000000000000000000000000000000",
    n1310 when "0001000000000000000000000000000000",
    n1310 when "0000100000000000000000000000000000",
    n1310 when "0000010000000000000000000000000000",
    n1310 when "0000001000000000000000000000000000",
    n1310 when "0000000100000000000000000000000000",
    n1310 when "0000000010000000000000000000000000",
    n1310 when "0000000001000000000000000000000000",
    n1310 when "0000000000100000000000000000000000",
    n1310 when "0000000000010000000000000000000000",
    n1310 when "0000000000001000000000000000000000",
    n1310 when "0000000000000100000000000000000000",
    n1309 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1310 when "0000000000000000100000000000000000",
    n1310 when "0000000000000000010000000000000000",
    n762 when "0000000000000000001000000000000000",
    n692 when "0000000000000000000100000000000000",
    n1310 when "0000000000000000000010000000000000",
    n1310 when "0000000000000000000001000000000000",
    n1308 when "0000000000000000000000100000000000",
    n1307 when "0000000000000000000000010000000000",
    n1310 when "0000000000000000000000001000000000",
    n1310 when "0000000000000000000000000100000000",
    n1310 when "0000000000000000000000000010000000",
    n1310 when "0000000000000000000000000001000000",
    n1310 when "0000000000000000000000000000100000",
    n1310 when "0000000000000000000000000000010000",
    n1310 when "0000000000000000000000000000001000",
    n1310 when "0000000000000000000000000000000100",
    n1310 when "0000000000000000000000000000000010",
    n1310 when "0000000000000000000000000000000001",
    n1310 when others;
  n1312 <= n429 (15 downto 0);
  n1313 <= n510 (15 downto 0);
  n1314 <= n681 (15 downto 0);
  n1315 <= n764 (15 downto 0);
  n1316 <= n836 (15 downto 0);
  n1317 <= state (205 downto 190);
  with n1261 select n1318 <=
    n1251 when "1000000000000000000000000000000000",
    n1317 when "0100000000000000000000000000000000",
    n1317 when "0010000000000000000000000000000000",
    n1317 when "0001000000000000000000000000000000",
    n1317 when "0000100000000000000000000000000000",
    n1317 when "0000010000000000000000000000000000",
    n1317 when "0000001000000000000000000000000000",
    n1317 when "0000000100000000000000000000000000",
    n1317 when "0000000010000000000000000000000000",
    n1317 when "0000000001000000000000000000000000",
    n1317 when "0000000000100000000000000000000000",
    n1317 when "0000000000010000000000000000000000",
    n1317 when "0000000000001000000000000000000000",
    n1073 when "0000000000000100000000000000000000",
    n1317 when "0000000000000010000000000000000000",
    n1317 when "0000000000000001000000000000000000",
    n1316 when "0000000000000000100000000000000000",
    n1317 when "0000000000000000010000000000000000",
    n1315 when "0000000000000000001000000000000000",
    n1317 when "0000000000000000000100000000000000",
    n1314 when "0000000000000000000010000000000000",
    n1317 when "0000000000000000000001000000000000",
    n1317 when "0000000000000000000000100000000000",
    n1317 when "0000000000000000000000010000000000",
    n1317 when "0000000000000000000000001000000000",
    n1313 when "0000000000000000000000000100000000",
    n1317 when "0000000000000000000000000010000000",
    n1317 when "0000000000000000000000000001000000",
    n1317 when "0000000000000000000000000000100000",
    n1317 when "0000000000000000000000000000010000",
    n1312 when "0000000000000000000000000000001000",
    n1317 when "0000000000000000000000000000000100",
    n316 when "0000000000000000000000000000000010",
    n1317 when "0000000000000000000000000000000001",
    n1317 when others;
  n1319 <= n429 (31 downto 16);
  n1320 <= n510 (31 downto 16);
  n1321 <= n681 (31 downto 16);
  n1322 <= n764 (31 downto 16);
  n1323 <= n836 (31 downto 16);
  n1324 <= state (221 downto 206);
  with n1261 select n1325 <=
    n1258 when "1000000000000000000000000000000000",
    n1324 when "0100000000000000000000000000000000",
    n1324 when "0010000000000000000000000000000000",
    n1324 when "0001000000000000000000000000000000",
    n1324 when "0000100000000000000000000000000000",
    n1324 when "0000010000000000000000000000000000",
    n1324 when "0000001000000000000000000000000000",
    n1324 when "0000000100000000000000000000000000",
    n1324 when "0000000010000000000000000000000000",
    n1324 when "0000000001000000000000000000000000",
    n1324 when "0000000000100000000000000000000000",
    n1324 when "0000000000010000000000000000000000",
    n1324 when "0000000000001000000000000000000000",
    n1094 when "0000000000000100000000000000000000",
    n1324 when "0000000000000010000000000000000000",
    n1324 when "0000000000000001000000000000000000",
    n1323 when "0000000000000000100000000000000000",
    n1324 when "0000000000000000010000000000000000",
    n1322 when "0000000000000000001000000000000000",
    n1324 when "0000000000000000000100000000000000",
    n1321 when "0000000000000000000010000000000000",
    n1324 when "0000000000000000000001000000000000",
    n1324 when "0000000000000000000000100000000000",
    n1324 when "0000000000000000000000010000000000",
    n1324 when "0000000000000000000000001000000000",
    n1320 when "0000000000000000000000000100000000",
    n1324 when "0000000000000000000000000010000000",
    n1324 when "0000000000000000000000000001000000",
    n1324 when "0000000000000000000000000000100000",
    n1324 when "0000000000000000000000000000010000",
    n1319 when "0000000000000000000000000000001000",
    n1324 when "0000000000000000000000000000000100",
    n318 when "0000000000000000000000000000000010",
    n1324 when "0000000000000000000000000000000001",
    n1324 when others;
  n1326 <= state (229 downto 222);
  with n1261 select n1327 <=
    n1326 when "1000000000000000000000000000000000",
    n1326 when "0100000000000000000000000000000000",
    n1326 when "0010000000000000000000000000000000",
    n1326 when "0001000000000000000000000000000000",
    n1326 when "0000100000000000000000000000000000",
    n1326 when "0000010000000000000000000000000000",
    n1326 when "0000001000000000000000000000000000",
    n1326 when "0000000100000000000000000000000000",
    n1326 when "0000000010000000000000000000000000",
    n1326 when "0000000001000000000000000000000000",
    n1326 when "0000000000100000000000000000000000",
    n1326 when "0000000000010000000000000000000000",
    n1326 when "0000000000001000000000000000000000",
    n1326 when "0000000000000100000000000000000000",
    n1326 when "0000000000000010000000000000000000",
    n1326 when "0000000000000001000000000000000000",
    n1326 when "0000000000000000100000000000000000",
    n1326 when "0000000000000000010000000000000000",
    n1326 when "0000000000000000001000000000000000",
    n1326 when "0000000000000000000100000000000000",
    n1326 when "0000000000000000000010000000000000",
    n1326 when "0000000000000000000001000000000000",
    n1326 when "0000000000000000000000100000000000",
    n1326 when "0000000000000000000000010000000000",
    n1326 when "0000000000000000000000001000000000",
    n1326 when "0000000000000000000000000100000000",
    n1326 when "0000000000000000000000000010000000",
    n1326 when "0000000000000000000000000001000000",
    n1326 when "0000000000000000000000000000100000",
    n1326 when "0000000000000000000000000000010000",
    n1326 when "0000000000000000000000000000001000",
    n1326 when "0000000000000000000000000000000100",
    n320 when "0000000000000000000000000000000010",
    n1326 when "0000000000000000000000000000000001",
    n1326 when others;
  n1328 <= state (237 downto 230);
  with n1261 select n1329 <=
    n1328 when "1000000000000000000000000000000000",
    n1328 when "0100000000000000000000000000000000",
    n1328 when "0010000000000000000000000000000000",
    n1328 when "0001000000000000000000000000000000",
    n1328 when "0000100000000000000000000000000000",
    n1328 when "0000010000000000000000000000000000",
    n1328 when "0000001000000000000000000000000000",
    n1328 when "0000000100000000000000000000000000",
    n1328 when "0000000010000000000000000000000000",
    n1328 when "0000000001000000000000000000000000",
    n1328 when "0000000000100000000000000000000000",
    n1328 when "0000000000010000000000000000000000",
    n1328 when "0000000000001000000000000000000000",
    n1328 when "0000000000000100000000000000000000",
    n1328 when "0000000000000010000000000000000000",
    n1328 when "0000000000000001000000000000000000",
    n1328 when "0000000000000000100000000000000000",
    n1328 when "0000000000000000010000000000000000",
    n1328 when "0000000000000000001000000000000000",
    n1328 when "0000000000000000000100000000000000",
    n1328 when "0000000000000000000010000000000000",
    n1328 when "0000000000000000000001000000000000",
    n1328 when "0000000000000000000000100000000000",
    n1328 when "0000000000000000000000010000000000",
    n1328 when "0000000000000000000000001000000000",
    n1328 when "0000000000000000000000000100000000",
    n1328 when "0000000000000000000000000010000000",
    n1328 when "0000000000000000000000000001000000",
    n1328 when "0000000000000000000000000000100000",
    n1328 when "0000000000000000000000000000010000",
    n1328 when "0000000000000000000000000000001000",
    n1328 when "0000000000000000000000000000000100",
    n322 when "0000000000000000000000000000000010",
    n1328 when "0000000000000000000000000000000001",
    n1328 when others;
  n1330 <= state (299 downto 238);
  with n1261 select n1331 <=
    n1330 when "1000000000000000000000000000000000",
    n1330 when "0100000000000000000000000000000000",
    n1330 when "0010000000000000000000000000000000",
    n1330 when "0001000000000000000000000000000000",
    n1330 when "0000100000000000000000000000000000",
    n1330 when "0000010000000000000000000000000000",
    n1330 when "0000001000000000000000000000000000",
    n1330 when "0000000100000000000000000000000000",
    n1330 when "0000000010000000000000000000000000",
    n1330 when "0000000001000000000000000000000000",
    n1330 when "0000000000100000000000000000000000",
    n1330 when "0000000000010000000000000000000000",
    n1330 when "0000000000001000000000000000000000",
    n1330 when "0000000000000100000000000000000000",
    n1330 when "0000000000000010000000000000000000",
    n1330 when "0000000000000001000000000000000000",
    n1330 when "0000000000000000100000000000000000",
    n1330 when "0000000000000000010000000000000000",
    n1330 when "0000000000000000001000000000000000",
    n1330 when "0000000000000000000100000000000000",
    n1330 when "0000000000000000000010000000000000",
    n1330 when "0000000000000000000001000000000000",
    n1330 when "0000000000000000000000100000000000",
    n1330 when "0000000000000000000000010000000000",
    n1330 when "0000000000000000000000001000000000",
    n1330 when "0000000000000000000000000100000000",
    bdt_bmpidx when "0000000000000000000000000010000000",
    n1330 when "0000000000000000000000000001000000",
    n1330 when "0000000000000000000000000000100000",
    n1330 when "0000000000000000000000000000010000",
    n1330 when "0000000000000000000000000000001000",
    n1330 when "0000000000000000000000000000000100",
    n1330 when "0000000000000000000000000000000010",
    n1330 when "0000000000000000000000000000000001",
    n1330 when others;
  n1332 <= state (307 downto 300);
  with n1261 select n1333 <=
    n1332 when "1000000000000000000000000000000000",
    n1332 when "0100000000000000000000000000000000",
    n1332 when "0010000000000000000000000000000000",
    n1332 when "0001000000000000000000000000000000",
    n1332 when "0000100000000000000000000000000000",
    n1332 when "0000010000000000000000000000000000",
    n1332 when "0000001000000000000000000000000000",
    n1332 when "0000000100000000000000000000000000",
    n1332 when "0000000010000000000000000000000000",
    n1332 when "0000000001000000000000000000000000",
    n1332 when "0000000000100000000000000000000000",
    n1332 when "0000000000010000000000000000000000",
    n1332 when "0000000000001000000000000000000000",
    n1332 when "0000000000000100000000000000000000",
    n1332 when "0000000000000010000000000000000000",
    n1332 when "0000000000000001000000000000000000",
    n1332 when "0000000000000000100000000000000000",
    n1332 when "0000000000000000010000000000000000",
    n1332 when "0000000000000000001000000000000000",
    n1332 when "0000000000000000000100000000000000",
    n1332 when "0000000000000000000010000000000000",
    n1332 when "0000000000000000000001000000000000",
    n1332 when "0000000000000000000000100000000000",
    n1332 when "0000000000000000000000010000000000",
    n1332 when "0000000000000000000000001000000000",
    n1332 when "0000000000000000000000000100000000",
    n1332 when "0000000000000000000000000010000000",
    n1332 when "0000000000000000000000000001000000",
    n1332 when "0000000000000000000000000000100000",
    n1332 when "0000000000000000000000000000010000",
    n1332 when "0000000000000000000000000000001000",
    n1332 when "0000000000000000000000000000000100",
    n324 when "0000000000000000000000000000000010",
    n1332 when "0000000000000000000000000000000001",
    n1332 when others;
  n1334 <= state (309 downto 308);
  with n1261 select n1335 <=
    n1334 when "1000000000000000000000000000000000",
    n1334 when "0100000000000000000000000000000000",
    n1334 when "0010000000000000000000000000000000",
    n1334 when "0001000000000000000000000000000000",
    n1334 when "0000100000000000000000000000000000",
    n1334 when "0000010000000000000000000000000000",
    n1334 when "0000001000000000000000000000000000",
    n1334 when "0000000100000000000000000000000000",
    n1334 when "0000000010000000000000000000000000",
    n1334 when "0000000001000000000000000000000000",
    n1334 when "0000000000100000000000000000000000",
    n1334 when "0000000000010000000000000000000000",
    n1334 when "0000000000001000000000000000000000",
    n1334 when "0000000000000100000000000000000000",
    n1334 when "0000000000000010000000000000000000",
    n1334 when "0000000000000001000000000000000000",
    n1334 when "0000000000000000100000000000000000",
    n1334 when "0000000000000000010000000000000000",
    n1334 when "0000000000000000001000000000000000",
    n1334 when "0000000000000000000100000000000000",
    n1334 when "0000000000000000000010000000000000",
    n1334 when "0000000000000000000001000000000000",
    n1334 when "0000000000000000000000100000000000",
    n1334 when "0000000000000000000000010000000000",
    n1334 when "0000000000000000000000001000000000",
    n1334 when "0000000000000000000000000100000000",
    n1334 when "0000000000000000000000000010000000",
    n1334 when "0000000000000000000000000001000000",
    n1334 when "0000000000000000000000000000100000",
    n1334 when "0000000000000000000000000000010000",
    n1334 when "0000000000000000000000000000001000",
    n1334 when "0000000000000000000000000000000100",
    n326 when "0000000000000000000000000000000010",
    n1334 when "0000000000000000000000000000000001",
    n1334 when others;
  with n1261 select n1356 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    '0' when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    n432 when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1359 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    '0' when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    n349 when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1362 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    n1030 when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    n809 when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    n766 when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    n683 when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    n547 when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    n475 when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1365 <=
    "00000000" when "1000000000000000000000000000000000",
    "00000000" when "0100000000000000000000000000000000",
    "00000000" when "0010000000000000000000000000000000",
    "00000000" when "0001000000000000000000000000000000",
    "00000000" when "0000100000000000000000000000000000",
    "00000000" when "0000010000000000000000000000000000",
    "00000000" when "0000001000000000000000000000000000",
    "00000000" when "0000000100000000000000000000000000",
    "00000000" when "0000000010000000000000000000000000",
    "00000000" when "0000000001000000000000000000000000",
    "00000000" when "0000000000100000000000000000000000",
    "00000000" when "0000000000010000000000000000000000",
    "00000000" when "0000000000001000000000000000000000",
    "00000000" when "0000000000000100000000000000000000",
    n1032 when "0000000000000010000000000000000000",
    "00000000" when "0000000000000001000000000000000000",
    n811 when "0000000000000000100000000000000000",
    "00000000" when "0000000000000000010000000000000000",
    n768 when "0000000000000000001000000000000000",
    "00000000" when "0000000000000000000100000000000000",
    n685 when "0000000000000000000010000000000000",
    "00000000" when "0000000000000000000001000000000000",
    instr_color when "0000000000000000000000100000000000",
    "00000000" when "0000000000000000000000010000000000",
    "00000000" when "0000000000000000000000001000000000",
    instr_color when "0000000000000000000000000100000000",
    "00000000" when "0000000000000000000000000010000000",
    "00000000" when "0000000000000000000000000001000000",
    "00000000" when "0000000000000000000000000000100000",
    "00000000" when "0000000000000000000000000000010000",
    "00000000" when "0000000000000000000000000000001000",
    "00000000" when "0000000000000000000000000000000100",
    "00000000" when "0000000000000000000000000000000010",
    "00000000" when "0000000000000000000000000000000001",
    "00000000" when others;
  with n1261 select n1368 <=
    "00000000000000000000000000000000" when "1000000000000000000000000000000000",
    n1236 when "0100000000000000000000000000000000",
    n1219 when "0010000000000000000000000000000000",
    n1216 when "0001000000000000000000000000000000",
    n1212 when "0000100000000000000000000000000000",
    "00000000000000000000000000000000" when "0000010000000000000000000000000000",
    "00000000000000000000000000000000" when "0000001000000000000000000000000000",
    "00000000000000000000000000000000" when "0000000100000000000000000000000000",
    "00000000000000000000000000000000" when "0000000010000000000000000000000000",
    "00000000000000000000000000000000" when "0000000001000000000000000000000000",
    "00000000000000000000000000000000" when "0000000000100000000000000000000000",
    "00000000000000000000000000000000" when "0000000000010000000000000000000000",
    "00000000000000000000000000000000" when "0000000000001000000000000000000000",
    "00000000000000000000000000000000" when "0000000000000100000000000000000000",
    n1035 when "0000000000000010000000000000000000",
    "00000000000000000000000000000000" when "0000000000000001000000000000000000",
    n813 when "0000000000000000100000000000000000",
    "00000000000000000000000000000000" when "0000000000000000010000000000000000",
    n771 when "0000000000000000001000000000000000",
    "00000000000000000000000000000000" when "0000000000000000000100000000000000",
    n688 when "0000000000000000000010000000000000",
    "00000000000000000000000000000000" when "0000000000000000000001000000000000",
    n538 when "0000000000000000000000100000000000",
    "00000000000000000000000000000000" when "0000000000000000000000010000000000",
    "00000000000000000000000000000000" when "0000000000000000000000001000000000",
    n466 when "0000000000000000000000000100000000",
    "00000000000000000000000000000000" when "0000000000000000000000000010000000",
    "00000000000000000000000000000000" when "0000000000000000000000000001000000",
    "00000000000000000000000000000000" when "0000000000000000000000000000100000",
    "00000000000000000000000000000000" when "0000000000000000000000000000010000",
    "00000000000000000000000000000000" when "0000000000000000000000000000001000",
    "00000000000000000000000000000000" when "0000000000000000000000000000000100",
    "00000000000000000000000000000000" when "0000000000000000000000000000000010",
    "00000000000000000000000000000000" when "0000000000000000000000000000000001",
    "00000000000000000000000000000000" when others;
  with n1261 select n1373 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    n1037 when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1376 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    n1185 when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    n1110 when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    '0' when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1379 <=
    "000000000000000000000" when "1000000000000000000000000000000000",
    "000000000000000000000" when "0100000000000000000000000000000000",
    "000000000000000000000" when "0010000000000000000000000000000000",
    "000000000000000000000" when "0001000000000000000000000000000000",
    "000000000000000000000" when "0000100000000000000000000000000000",
    "000000000000000000000" when "0000010000000000000000000000000000",
    "000000000000000000000" when "0000001000000000000000000000000000",
    "000000000000000000000" when "0000000100000000000000000000000000",
    n1151 when "0000000010000000000000000000000000",
    "000000000000000000000" when "0000000001000000000000000000000000",
    "000000000000000000000" when "0000000000100000000000000000000000",
    "000000000000000000000" when "0000000000010000000000000000000000",
    n1112 when "0000000000001000000000000000000000",
    "000000000000000000000" when "0000000000000100000000000000000000",
    "000000000000000000000" when "0000000000000010000000000000000000",
    "000000000000000000000" when "0000000000000001000000000000000000",
    "000000000000000000000" when "0000000000000000100000000000000000",
    "000000000000000000000" when "0000000000000000010000000000000000",
    "000000000000000000000" when "0000000000000000001000000000000000",
    "000000000000000000000" when "0000000000000000000100000000000000",
    "000000000000000000000" when "0000000000000000000010000000000000",
    "000000000000000000000" when "0000000000000000000001000000000000",
    "000000000000000000000" when "0000000000000000000000100000000000",
    "000000000000000000000" when "0000000000000000000000010000000000",
    "000000000000000000000" when "0000000000000000000000001000000000",
    "000000000000000000000" when "0000000000000000000000000100000000",
    "000000000000000000000" when "0000000000000000000000000010000000",
    "000000000000000000000" when "0000000000000000000000000001000000",
    "000000000000000000000" when "0000000000000000000000000000100000",
    "000000000000000000000" when "0000000000000000000000000000010000",
    "000000000000000000000" when "0000000000000000000000000000001000",
    "000000000000000000000" when "0000000000000000000000000000000100",
    "000000000000000000000" when "0000000000000000000000000000000010",
    "000000000000000000000" when "0000000000000000000000000000000001",
    "000000000000000000000" when others;
  with n1261 select n1382 <=
    "0000000000000000" when "1000000000000000000000000000000000",
    "0000000000000000" when "0100000000000000000000000000000000",
    "0000000000000000" when "0010000000000000000000000000000000",
    "0000000000000000" when "0001000000000000000000000000000000",
    "0000000000000000" when "0000100000000000000000000000000000",
    "0000000000000000" when "0000010000000000000000000000000000",
    "0000000000000000" when "0000001000000000000000000000000000",
    "0000000000000000" when "0000000100000000000000000000000000",
    n1160 when "0000000010000000000000000000000000",
    "0000000000000000" when "0000000001000000000000000000000000",
    "0000000000000000" when "0000000000100000000000000000000000",
    "0000000000000000" when "0000000000010000000000000000000000",
    n1114 when "0000000000001000000000000000000000",
    "0000000000000000" when "0000000000000100000000000000000000",
    "0000000000000000" when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    "0000000000000000" when "0000000000000000100000000000000000",
    "0000000000000000" when "0000000000000000010000000000000000",
    "0000000000000000" when "0000000000000000001000000000000000",
    "0000000000000000" when "0000000000000000000100000000000000",
    "0000000000000000" when "0000000000000000000010000000000000",
    "0000000000000000" when "0000000000000000000001000000000000",
    "0000000000000000" when "0000000000000000000000100000000000",
    "0000000000000000" when "0000000000000000000000010000000000",
    "0000000000000000" when "0000000000000000000000001000000000",
    "0000000000000000" when "0000000000000000000000000100000000",
    "0000000000000000" when "0000000000000000000000000010000000",
    "0000000000000000" when "0000000000000000000000000001000000",
    "0000000000000000" when "0000000000000000000000000000100000",
    "0000000000000000" when "0000000000000000000000000000010000",
    "0000000000000000" when "0000000000000000000000000000001000",
    "0000000000000000" when "0000000000000000000000000000000100",
    "0000000000000000" when "0000000000000000000000000000000010",
    "0000000000000000" when "0000000000000000000000000000000001",
    "0000000000000000" when others;
  with n1261 select n1385 <=
    '1' when "1000000000000000000000000000000000",
    '1' when "0100000000000000000000000000000000",
    '1' when "0010000000000000000000000000000000",
    '1' when "0001000000000000000000000000000000",
    '1' when "0000100000000000000000000000000000",
    '1' when "0000010000000000000000000000000000",
    '1' when "0000001000000000000000000000000000",
    '1' when "0000000100000000000000000000000000",
    n1187 when "0000000010000000000000000000000000",
    '1' when "0000000001000000000000000000000000",
    '1' when "0000000000100000000000000000000000",
    '1' when "0000000000010000000000000000000000",
    n1116 when "0000000000001000000000000000000000",
    '1' when "0000000000000100000000000000000000",
    '1' when "0000000000000010000000000000000000",
    '1' when "0000000000000001000000000000000000",
    '1' when "0000000000000000100000000000000000",
    '1' when "0000000000000000010000000000000000",
    '1' when "0000000000000000001000000000000000",
    '1' when "0000000000000000000100000000000000",
    '1' when "0000000000000000000010000000000000",
    '1' when "0000000000000000000001000000000000",
    '1' when "0000000000000000000000100000000000",
    '1' when "0000000000000000000000010000000000",
    '1' when "0000000000000000000000001000000000",
    '1' when "0000000000000000000000000100000000",
    '1' when "0000000000000000000000000010000000",
    '1' when "0000000000000000000000000001000000",
    '1' when "0000000000000000000000000000100000",
    '1' when "0000000000000000000000000000010000",
    '1' when "0000000000000000000000000000001000",
    '1' when "0000000000000000000000000000000100",
    '1' when "0000000000000000000000000000000010",
    '1' when "0000000000000000000000000000000001",
    '1' when others;
  with n1261 select n1389 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    '0' when "0000000000000010000000000000000000",
    '1' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1392 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    n1039 when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1261 select n1395 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    '0' when "0000000000001000000000000000000000",
    '0' when "0000000000000100000000000000000000",
    '0' when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    '0' when "0000000000000000100000000000000000",
    n780 when "0000000000000000010000000000000000",
    '0' when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    '0' when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    '0' when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    '0' when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  n1400 <= "000000000000000000000" when pw_vram_wr = '0' else pw_vram_wr_addr;
  n1402 <= "0000000000000000" when pw_vram_wr = '0' else pw_vram_wr_data;
  n1405 <= '0' when pw_vram_wr = '0' else '1';
  n1407 <= '1' when pw_vram_wr = '0' else pw_vram_wr_access_mode;
  n1408 <= n1400 when direct_vram_wr = '0' else direct_vram_wr_addr;
  n1410 <= n1402 when direct_vram_wr = '0' else direct_vram_wr_data;
  n1413 <= n1405 when direct_vram_wr = '0' else '1';
  n1415 <= n1407 when direct_vram_wr = '0' else direct_vram_wr_access_mode;
  gfx_circle_inst : entity work.gfx_circle_renamed port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    start => circle_start,
    stall => stall,
    center_x => n1420,
    center_y => n1421,
    radius => radius,
    busy => gfx_circle_inst_c_busy,
    pixel_valid => gfx_circle_inst_c_pixel_valid,
    pixel_x => gfx_circle_inst_c_pixel_x,
    pixel_y => gfx_circle_inst_c_pixel_y);
  n1419 <= state (221 downto 190);
  n1420 <= n1419 (15 downto 0);
  n1421 <= n1419 (31 downto 16);
  n1423 <= gfx_circle_inst_c_pixel_y & gfx_circle_inst_c_pixel_x;
  pw : entity work.pixel_writer_21_16 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    wr => pw_wr,
    bd_b => n1427,
    bd_w => n1428,
    bd_h => n1429,
    color => pw_color,
    position_x => n1430,
    position_y => n1431,
    alpha_mode => pw_alpha_mode,
    alpha_color => n1470,
    vram_wr_full => wrap_vram_wr_full,
    wr_in_progress => open,
    stall => pw_c_stall,
    oob => pw_c_oob,
    vram_wr_addr => pw_c_vram_wr_addr,
    vram_wr_data => pw_c_vram_wr_data,
    vram_wr => pw_c_vram_wr,
    vram_wr_access_mode => pw_c_vram_wr_access_mode);
  n1426 <= state (299 downto 238);
  n1427 <= n1426 (31 downto 0);
  n1428 <= n1426 (46 downto 32);
  n1429 <= n1426 (61 downto 47);
  n1430 <= pw_position (15 downto 0);
  n1431 <= pw_position (31 downto 16);
  n1433 <= state (237 downto 230);
  n1439 <= state (309 downto 308);
  n1440 <= state (307 downto 300);
  n1441 <= n1433 and n1440;
  n1443 <= '1' when n1439 = "01" else '0';
  n1444 <= state (307 downto 300);
  n1445 <= n1433 or n1444;
  n1447 <= '1' when n1439 = "10" else '0';
  n1448 <= state (307 downto 300);
  n1449 <= n1433 xor n1448;
  n1451 <= '1' when n1439 = "11" else '0';
  n1452 <= n1451 & n1447 & n1443;
  with n1452 select n1457 <=
    '0' when "100",
    '0' when "010",
    '0' when "001",
    '1' when others;
  with n1452 select n1465 <=
    n1449 when "100",
    n1445 when "010",
    n1441 when "001",
    "XXXXXXXX" when others;
  n1470 <= n1465 when n1457 = '0' else n1433;
  pr : entity work.pixel_reader_21_16 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    start => pr_start,
    bd_b => n1476,
    bd_w => n1477,
    bd_h => n1478,
    section_x => n1479,
    section_y => n1480,
    section_w => n1481,
    section_h => n1482,
    color_ack => pr_color_ack,
    vram_rd_data => wrap_vram_rd_data,
    vram_rd_busy => wrap_vram_rd_busy,
    vram_rd_valid => wrap_vram_rd_valid,
    color => pr_c_color,
    color_valid => pr_c_color_valid,
    vram_rd_addr => pr_c_vram_rd_addr,
    vram_rd => pr_c_vram_rd,
    vram_rd_access_mode => pr_c_vram_rd_access_mode);
  n1476 <= bdt_bmpidx (31 downto 0);
  n1477 <= bdt_bmpidx (46 downto 32);
  n1478 <= bdt_bmpidx (61 downto 47);
  n1479 <= bb_section (14 downto 0);
  n1480 <= bb_section (29 downto 15);
  n1481 <= bb_section (44 downto 30);
  n1482 <= bb_section (59 downto 45);
  n1488 <= wrap_gcf_data & n57 & n58 & n59;
  process (wrap_clk, n118)
  begin
    if n118 = '1' then
      n1489 <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (wrap_clk) then
      n1489 <= state_nxt;
    end if;
  end process;
  n1490 <= n1335 & n1333 & n1331 & n1329 & n1327 & n1325 & n1318 & n1311 & n1306 & n1301 & n1299 & n1297 & n1295 & n1293 & n1291 & n1289 & n1287 & n1285 & n1283 & n1281;
  n1492 <= n105 & n104 & n103;
  assert vram_addr_width = 21 report "Unsupported generic value! vram_addr_width must be 21." severity failure;
  assert vram_data_width = 16 report "Unsupported generic value! vram_data_width must be 16." severity failure;
end architecture;
