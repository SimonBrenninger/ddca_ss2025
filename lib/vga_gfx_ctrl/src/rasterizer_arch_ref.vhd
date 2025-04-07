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
  signal n2205 : std_logic_vector (7 downto 0);
  signal n2206 : std_logic_vector (7 downto 0) := "00000000";
  signal n2208 : std_logic_vector (7 downto 0);
begin
  rd1_data <= n2206;
  n2205 <= n2206 when rd1 = '0' else n2208;
  process (clk)
  begin
    if rising_edge (clk) then
      n2206 <= n2205;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (7 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n2208 <= ram(to_integer (unsigned (rd1_addr)));
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
  signal memory_inst_n2092 : std_logic_vector (7 downto 0);
  signal memory_inst_c_rd1_data : std_logic_vector (7 downto 0);
  signal n2096 : std_logic;
  signal n2119 : std_logic;
  signal n2120 : std_logic;
  signal n2122 : std_logic_vector (2 downto 0);
  signal n2123 : std_logic_vector (2 downto 0);
  signal n2126 : std_logic;
  signal n2128 : std_logic;
  signal n2129 : std_logic;
  signal n2131 : std_logic_vector (2 downto 0);
  signal n2132 : std_logic_vector (2 downto 0);
  signal n2135 : std_logic;
  signal n2137 : std_logic;
  signal n2138 : std_logic;
  signal n2140 : std_logic_vector (31 downto 0);
  signal n2141 : std_logic;
  signal n2142 : std_logic;
  signal n2144 : std_logic_vector (31 downto 0);
  signal n2145 : std_logic_vector (31 downto 0);
  signal n2146 : std_logic_vector (31 downto 0);
  signal n2148 : std_logic;
  signal n2151 : std_logic;
  signal n2154 : std_logic_vector (2 downto 0);
  signal n2155 : std_logic;
  signal n2157 : std_logic;
  signal n2159 : std_logic;
  signal n2160 : std_logic;
  signal n2162 : std_logic_vector (2 downto 0);
  signal n2163 : std_logic;
  signal n2164 : std_logic;
  signal n2165 : std_logic;
  signal n2167 : std_logic;
  signal n2168 : std_logic;
  signal n2170 : std_logic;
  signal n2177 : std_logic_vector (2 downto 0);
  signal n2178 : std_logic_vector (2 downto 0);
  signal n2179 : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n2180 : std_logic;
  signal n2181 : std_logic;
  signal n2182 : std_logic;
begin
  rd_data <= memory_inst_n2092;
  empty <= n2180;
  full <= n2181;
  half_full <= n2182;
  read_address <= n2177; -- (signal)
  read_address_next <= n2132; -- (signal)
  write_address <= n2178; -- (signal)
  write_address_next <= n2123; -- (signal)
  full_next <= n2167; -- (signal)
  empty_next <= n2170; -- (signal)
  wr_int <= n2126; -- (signal)
  rd_int <= n2135; -- (signal)
  half_full_next <= n2151; -- (signal)
  pointer_diff <= n2179; -- (isignal)
  pointer_diff_next <= n2146; -- (isignal)
  memory_inst_n2092 <= memory_inst_c_rd1_data; -- (signal)
  memory_inst : entity work.dp_ram_1c1r1w_3_8 port map (
    clk => clk,
    rd1_addr => read_address,
    rd1 => rd_int,
    wr2_addr => write_address,
    wr2_data => wr_data,
    wr2 => wr_int,
    rd1_data => memory_inst_c_rd1_data);
  n2096 <= not res_n;
  n2119 <= not n2181;
  n2120 <= n2119 and wr;
  n2122 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n2123 <= write_address when n2120 = '0' else n2122;
  n2126 <= '0' when n2120 = '0' else '1';
  n2128 <= not n2180;
  n2129 <= n2128 and rd;
  n2131 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n2132 <= read_address when n2129 = '0' else n2131;
  n2135 <= '0' when n2129 = '0' else '1';
  n2137 <= not rd;
  n2138 <= n2137 and wr;
  n2140 <= std_logic_vector (unsigned (pointer_diff) + unsigned'("00000000000000000000000000000001"));
  n2141 <= not wr;
  n2142 <= n2141 and rd;
  n2144 <= std_logic_vector (unsigned (pointer_diff) - unsigned'("00000000000000000000000000000001"));
  n2145 <= pointer_diff when n2142 = '0' else n2144;
  n2146 <= n2145 when n2138 = '0' else n2140;
  n2148 <= '1' when signed (n2146) >= signed'("00000000000000000000000000000100") else '0';
  n2151 <= '0' when n2148 = '0' else '1';
  n2154 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n2155 <= '1' when write_address = n2154 else '0';
  n2157 <= n2180 when n2160 = '0' else '1';
  n2159 <= n2181 when rd = '0' else '0';
  n2160 <= n2155 and rd;
  n2162 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n2163 <= '1' when read_address = n2162 else '0';
  n2164 <= not rd;
  n2165 <= n2164 and n2163;
  n2167 <= n2159 when n2168 = '0' else '1';
  n2168 <= n2165 and wr;
  n2170 <= n2157 when wr = '0' else '0';
  process (clk, n2096)
  begin
    if n2096 = '1' then
      n2177 <= "000";
    elsif rising_edge (clk) then
      n2177 <= read_address_next;
    end if;
  end process;
  process (clk, n2096)
  begin
    if n2096 = '1' then
      n2178 <= "000";
    elsif rising_edge (clk) then
      n2178 <= write_address_next;
    end if;
  end process;
  process (clk, n2096)
  begin
    if n2096 = '1' then
      n2179 <= "00000000000000000000000000000000";
    elsif rising_edge (clk) then
      n2179 <= pointer_diff_next;
    end if;
  end process;
  process (clk, n2096)
  begin
    if n2096 = '1' then
      n2180 <= '1';
    elsif rising_edge (clk) then
      n2180 <= empty_next;
    end if;
  end process;
  process (clk, n2096)
  begin
    if n2096 = '1' then
      n2181 <= '0';
    elsif rising_edge (clk) then
      n2181 <= full_next;
    end if;
  end process;
  process (clk, n2096)
  begin
    if n2096 = '1' then
      n2182 <= '0';
    elsif rising_edge (clk) then
      n2182 <= half_full_next;
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
  signal fifo_inst_n2057 : std_logic_vector (7 downto 0);
  signal fifo_inst_n2058 : std_logic;
  signal fifo_inst_n2059 : std_logic;
  signal fifo_inst_n2060 : std_logic;
  signal fifo_inst_c_rd_data : std_logic_vector (7 downto 0);
  signal fifo_inst_c_empty : std_logic;
  signal fifo_inst_c_full : std_logic;
  signal fifo_inst_c_half_full : std_logic;
  signal n2069 : std_logic;
  signal n2070 : std_logic;
  signal n2071 : std_logic;
  signal n2072 : std_logic;
  signal n2073 : std_logic;
  signal n2075 : std_logic;
  signal n2077 : std_logic;
  signal n2083 : std_logic;
  signal n2084 : std_logic;
begin
  rd_data <= fifo_inst_n2057;
  rd_valid <= n2084;
  full <= fifo_inst_n2059;
  half_full <= fifo_inst_n2060;
  rd <= n2073; -- (signal)
  empty <= fifo_inst_n2058; -- (signal)
  not_empty <= n2069; -- (signal)
  fifo_inst_n2057 <= fifo_inst_c_rd_data; -- (signal)
  fifo_inst_n2058 <= fifo_inst_c_empty; -- (signal)
  fifo_inst_n2059 <= fifo_inst_c_full; -- (signal)
  fifo_inst_n2060 <= fifo_inst_c_half_full; -- (signal)
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
  n2069 <= not empty;
  n2070 <= rd_ack and not_empty;
  n2071 <= not n2084;
  n2072 <= not_empty and n2071;
  n2073 <= n2070 or n2072;
  n2075 <= not res_n;
  n2077 <= rd or rd_ack;
  n2083 <= n2084 when n2077 = '0' else not_empty;
  process (clk, n2075)
  begin
    if n2075 = '1' then
      n2084 <= '0';
    elsif rising_edge (clk) then
      n2084 <= n2083;
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
  signal n1899 : std_logic_vector (61 downto 0);
  signal n1900 : std_logic_vector (59 downto 0);
  signal state : std_logic_vector (55 downto 0);
  signal state_nxt : std_logic_vector (55 downto 0);
  signal pixbuf_half_full : std_logic;
  signal fifo_wr : std_logic;
  signal n1907 : std_logic;
  signal n1915 : std_logic_vector (20 downto 0);
  signal n1916 : std_logic_vector (1 downto 0);
  signal n1917 : std_logic_vector (14 downto 0);
  signal n1918 : std_logic_vector (14 downto 0);
  signal n1920 : std_logic_vector (31 downto 0);
  signal n1921 : std_logic_vector (31 downto 0);
  signal n1922 : std_logic_vector (31 downto 0);
  signal n1924 : std_logic;
  signal n1925 : std_logic_vector (31 downto 0);
  signal n1926 : std_logic_vector (14 downto 0);
  signal n1927 : std_logic_vector (31 downto 0);
  signal n1928 : std_logic_vector (31 downto 0);
  signal n1929 : std_logic_vector (14 downto 0);
  signal n1930 : std_logic_vector (14 downto 0);
  signal n1931 : std_logic_vector (29 downto 0);
  signal n1932 : std_logic_vector (29 downto 0);
  signal n1933 : std_logic_vector (29 downto 0);
  signal n1934 : std_logic_vector (31 downto 0);
  signal n1935 : std_logic_vector (31 downto 0);
  signal n1936 : std_logic_vector (20 downto 0);
  signal n1937 : std_logic;
  signal n1939 : std_logic_vector (1 downto 0);
  signal n1940 : std_logic_vector (1 downto 0);
  signal n1942 : std_logic;
  signal n1943 : std_logic;
  signal n1945 : std_logic_vector (14 downto 0);
  signal n1946 : std_logic_vector (14 downto 0);
  signal n1947 : std_logic_vector (14 downto 0);
  signal n1948 : std_logic_vector (14 downto 0);
  signal n1950 : std_logic_vector (14 downto 0);
  signal n1951 : std_logic;
  signal n1952 : std_logic_vector (14 downto 0);
  signal n1953 : std_logic_vector (14 downto 0);
  signal n1954 : std_logic_vector (14 downto 0);
  signal n1955 : std_logic_vector (14 downto 0);
  signal n1956 : std_logic_vector (14 downto 0);
  signal n1958 : std_logic_vector (14 downto 0);
  signal n1959 : std_logic;
  signal n1961 : std_logic_vector (14 downto 0);
  signal n1963 : std_logic_vector (14 downto 0);
  signal n1964 : std_logic_vector (1 downto 0);
  signal n1965 : std_logic_vector (14 downto 0);
  signal n1966 : std_logic_vector (14 downto 0);
  signal n1967 : std_logic_vector (14 downto 0);
  signal n1969 : std_logic_vector (14 downto 0);
  signal n1970 : std_logic_vector (31 downto 0);
  signal n1971 : std_logic_vector (1 downto 0);
  signal n1972 : std_logic_vector (1 downto 0);
  signal n1973 : std_logic_vector (14 downto 0);
  signal n1974 : std_logic_vector (14 downto 0);
  signal n1975 : std_logic_vector (14 downto 0);
  signal n1976 : std_logic_vector (14 downto 0);
  signal n1977 : std_logic_vector (14 downto 0);
  signal n1980 : std_logic;
  signal n1981 : std_logic_vector (31 downto 0);
  signal n1982 : std_logic_vector (31 downto 0);
  signal n1983 : std_logic_vector (31 downto 0);
  signal n1985 : std_logic;
  signal n1986 : std_logic_vector (2 downto 0);
  signal n1988 : std_logic;
  signal n1990 : std_logic_vector (1 downto 0);
  signal n1991 : std_logic_vector (1 downto 0);
  signal n1993 : std_logic;
  signal n1994 : std_logic_vector (3 downto 0);
  signal n1997 : std_logic;
  signal n1999 : std_logic_vector (1 downto 0);
  signal n2000 : std_logic_vector (1 downto 0);
  signal n2002 : std_logic_vector (1 downto 0);
  signal n2003 : std_logic_vector (29 downto 0);
  signal n2004 : std_logic_vector (29 downto 0);
  signal n2005 : std_logic_vector (29 downto 0);
  signal n2007 : std_logic_vector (29 downto 0);
  signal n2008 : std_logic_vector (20 downto 0);
  signal n2010 : std_logic_vector (20 downto 0);
  signal n2013 : std_logic_vector (2 downto 0);
  signal n2014 : std_logic_vector (1 downto 0);
  signal n2016 : std_logic;
  signal n2017 : std_logic;
  signal n2018 : std_logic;
  signal n2019 : std_logic_vector (2 downto 0);
  signal n2021 : std_logic_vector (2 downto 0);
  signal n2022 : std_logic;
  signal n2023 : std_logic;
  signal n2024 : std_logic_vector (2 downto 0);
  signal n2026 : std_logic_vector (2 downto 0);
  signal n2027 : std_logic_vector (2 downto 0);
  signal n2028 : std_logic_vector (2 downto 0);
  signal n2029 : std_logic_vector (2 downto 0);
  constant n2031 : std_logic := '0';
  signal n2033 : std_logic_vector (1 downto 0);
  signal n2035 : std_logic;
  signal n2036 : std_logic;
  signal n2037 : std_logic;
  signal pixel_buffer_n2039 : std_logic_vector (7 downto 0);
  signal pixel_buffer_n2040 : std_logic;
  signal n2041 : std_logic_vector (7 downto 0);
  signal pixel_buffer_n2043 : std_logic;
  signal pixel_buffer_c_rd_data : std_logic_vector (7 downto 0);
  signal pixel_buffer_c_rd_valid : std_logic;
  signal pixel_buffer_c_full : std_logic;
  signal pixel_buffer_c_half_full : std_logic;
  signal n2051 : std_logic_vector (55 downto 0);
  signal n2052 : std_logic_vector (55 downto 0);
begin
  color <= pixel_buffer_n2039;
  color_valid <= pixel_buffer_n2040;
  vram_rd_addr <= n1915;
  vram_rd <= n1997;
  vram_rd_access_mode <= n2031;
  n1899 <= bd_h & bd_w & bd_b;
  n1900 <= section_h & section_w & section_y & section_x;
  state <= n2051; -- (signal)
  state_nxt <= n2052; -- (signal)
  pixbuf_half_full <= pixel_buffer_n2043; -- (signal)
  fifo_wr <= n2037; -- (signal)
  n1907 <= not res_n;
  n1915 <= state (52 downto 32);
  n1916 <= state (1 downto 0);
  n1917 <= n1900 (14 downto 0);
  n1918 <= n1900 (29 downto 15);
  n1920 <= n1918 & n1917 & "10";
  n1921 <= state (31 downto 0);
  n1922 <= n1921 when start = '0' else n1920;
  n1924 <= '1' when n1916 = "00" else '0';
  n1925 <= n1899 (31 downto 0);
  n1926 <= state (16 downto 2);
  n1927 <= "00000000000000000" & n1926;  --  uext
  n1928 <= std_logic_vector (unsigned (n1925) + unsigned (n1927));
  n1929 <= state (31 downto 17);
  n1930 <= n1899 (46 downto 32);
  n1931 <= "000000000000000" & n1929;  --  uext
  n1932 <= "000000000000000" & n1930;  --  uext
  n1933 <= std_logic_vector (resize (unsigned (n1931) * unsigned (n1932), 30));
  n1934 <= "00" & n1933;  --  uext
  n1935 <= std_logic_vector (unsigned (n1928) + unsigned (n1934));
  n1936 <= n1935 (20 downto 0);  --  trunc
  n1937 <= not pixbuf_half_full;
  n1939 <= state (1 downto 0);
  n1940 <= n1939 when n1937 = '0' else "11";
  n1942 <= '1' when n1916 = "10" else '0';
  n1943 <= not vram_rd_busy;
  n1945 <= state (16 downto 2);
  n1946 <= n1900 (14 downto 0);
  n1947 <= n1900 (44 downto 30);
  n1948 <= std_logic_vector (unsigned (n1946) + unsigned (n1947));
  n1950 <= std_logic_vector (unsigned (n1948) - unsigned'("000000000000001"));
  n1951 <= '1' when n1945 = n1950 else '0';
  n1952 <= n1900 (14 downto 0);
  n1953 <= state (31 downto 17);
  n1954 <= n1900 (29 downto 15);
  n1955 <= n1900 (59 downto 45);
  n1956 <= std_logic_vector (unsigned (n1954) + unsigned (n1955));
  n1958 <= std_logic_vector (unsigned (n1956) - unsigned'("000000000000001"));
  n1959 <= '1' when n1953 = n1958 else '0';
  n1961 <= state (31 downto 17);
  n1963 <= std_logic_vector (unsigned (n1961) + unsigned'("000000000000001"));
  n1964 <= "10" when n1959 = '0' else "01";
  n1965 <= state (31 downto 17);
  n1966 <= n1963 when n1959 = '0' else n1965;
  n1967 <= state (16 downto 2);
  n1969 <= std_logic_vector (unsigned (n1967) + unsigned'("000000000000001"));
  n1970 <= n1966 & n1952 & n1964;
  n1971 <= n1970 (1 downto 0);
  n1972 <= "10" when n1951 = '0' else n1971;
  n1973 <= n1970 (16 downto 2);
  n1974 <= n1969 when n1951 = '0' else n1973;
  n1975 <= n1970 (31 downto 17);
  n1976 <= state (31 downto 17);
  n1977 <= n1976 when n1951 = '0' else n1975;
  n1980 <= '0' when n1943 = '0' else '1';
  n1981 <= n1977 & n1974 & n1972;
  n1982 <= state (31 downto 0);
  n1983 <= n1982 when n1943 = '0' else n1981;
  n1985 <= '1' when n1916 = "11" else '0';
  n1986 <= state (55 downto 53);
  n1988 <= '1' when n1986 = "000" else '0';
  n1990 <= state (1 downto 0);
  n1991 <= n1990 when n1988 = '0' else "00";
  n1993 <= '1' when n1916 = "01" else '0';
  n1994 <= n1993 & n1985 & n1942 & n1924;
  with n1994 select n1997 <=
    '0' when "1000",
    n1980 when "0100",
    '0' when "0010",
    '0' when "0001",
    'X' when others;
  n1999 <= n1922 (1 downto 0);
  n2000 <= n1983 (1 downto 0);
  with n1994 select n2002 <=
    n1991 when "1000",
    n2000 when "0100",
    n1940 when "0010",
    n1999 when "0001",
    "XX" when others;
  n2003 <= n1922 (31 downto 2);
  n2004 <= n1983 (31 downto 2);
  n2005 <= state (31 downto 2);
  with n1994 select n2007 <=
    n2005 when "1000",
    n2004 when "0100",
    n2005 when "0010",
    n2003 when "0001",
    (29 downto 0 => 'X') when others;
  n2008 <= state (52 downto 32);
  with n1994 select n2010 <=
    n2008 when "1000",
    n2008 when "0100",
    n1936 when "0010",
    n2008 when "0001",
    (20 downto 0 => 'X') when others;
  n2013 <= state (55 downto 53);
  n2014 <= state (1 downto 0);
  n2016 <= '1' when n2014 /= "00" else '0';
  n2017 <= not vram_rd_valid;
  n2018 <= n2017 and n1997;
  n2019 <= state (55 downto 53);
  n2021 <= std_logic_vector (unsigned (n2019) + unsigned'("001"));
  n2022 <= not n1997;
  n2023 <= vram_rd_valid and n2022;
  n2024 <= state (55 downto 53);
  n2026 <= std_logic_vector (unsigned (n2024) - unsigned'("001"));
  n2027 <= n2013 when n2023 = '0' else n2026;
  n2028 <= n2027 when n2018 = '0' else n2021;
  n2029 <= n2013 when n2016 = '0' else n2028;
  n2033 <= state (1 downto 0);
  n2035 <= '1' when n2033 /= "00" else '0';
  n2036 <= n2035 and vram_rd_valid;
  n2037 <= '0' when n2036 = '0' else '1';
  pixel_buffer_n2039 <= pixel_buffer_c_rd_data; -- (signal)
  pixel_buffer_n2040 <= pixel_buffer_c_rd_valid; -- (signal)
  n2041 <= vram_rd_data (7 downto 0);
  pixel_buffer_n2043 <= pixel_buffer_c_half_full; -- (signal)
  pixel_buffer : entity work.fifo_1c1r1w_fwft_8_8 port map (
    clk => clk,
    res_n => res_n,
    rd_ack => color_ack,
    wr_data => n2041,
    wr => fifo_wr,
    rd_data => pixel_buffer_c_rd_data,
    rd_valid => pixel_buffer_c_rd_valid,
    full => open,
    half_full => pixel_buffer_c_half_full);
  process (clk, n1907)
  begin
    if n1907 = '1' then
      n2051 <= "00000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n2051 <= state_nxt;
    end if;
  end process;
  n2052 <= n2029 & n2010 & n2007 & n2002;
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
  signal n1805 : std_logic_vector (61 downto 0);
  signal n1806 : std_logic_vector (31 downto 0);
  signal s1 : std_logic_vector (111 downto 0);
  signal s2 : std_logic_vector (29 downto 0);
  signal s2_nxt : std_logic_vector (29 downto 0);
  signal n1812 : std_logic;
  signal n1813 : std_logic;
  signal n1814 : std_logic;
  signal n1816 : std_logic;
  signal n1818 : std_logic;
  signal n1819 : std_logic_vector (15 downto 0);
  signal n1820 : std_logic_vector (15 downto 0);
  signal n1821 : std_logic_vector (111 downto 0);
  signal n1832 : std_logic;
  signal n1833 : std_logic_vector (15 downto 0);
  signal n1835 : std_logic;
  signal n1836 : std_logic_vector (15 downto 0);
  signal n1838 : std_logic_vector (14 downto 0);
  signal n1840 : std_logic_vector (15 downto 0);
  signal n1841 : std_logic;
  signal n1842 : std_logic;
  signal n1843 : std_logic_vector (15 downto 0);
  signal n1845 : std_logic;
  signal n1846 : std_logic;
  signal n1847 : std_logic_vector (15 downto 0);
  signal n1849 : std_logic_vector (14 downto 0);
  signal n1851 : std_logic_vector (15 downto 0);
  signal n1852 : std_logic;
  signal n1853 : std_logic;
  signal n1854 : std_logic;
  signal n1858 : std_logic;
  signal n1860 : std_logic;
  signal n1861 : std_logic;
  signal n1862 : std_logic_vector (7 downto 0);
  signal n1863 : std_logic_vector (7 downto 0);
  signal n1864 : std_logic;
  signal n1865 : std_logic;
  signal n1867 : std_logic;
  signal n1869 : std_logic_vector (31 downto 0);
  signal n1870 : std_logic_vector (15 downto 0);
  signal n1871 : std_logic_vector (31 downto 0);
  signal n1872 : std_logic_vector (31 downto 0);
  signal n1874 : std_logic_vector (14 downto 0);
  signal n1875 : std_logic_vector (15 downto 0);
  signal n1876 : std_logic_vector (30 downto 0);
  signal n1877 : std_logic_vector (30 downto 0);
  signal n1878 : std_logic_vector (30 downto 0);
  signal n1879 : std_logic_vector (31 downto 0);
  signal n1880 : std_logic_vector (31 downto 0);
  signal n1881 : std_logic_vector (20 downto 0);
  signal n1882 : std_logic_vector (7 downto 0);
  signal n1886 : std_logic_vector (7 downto 0);
  constant n1887 : std_logic_vector (15 downto 0) := "0000000000000000";
  signal n1888 : std_logic_vector (7 downto 0);
  signal n1889 : std_logic_vector (20 downto 0);
  signal n1890 : std_logic;
  constant n1892 : std_logic := '0';
  signal n1893 : std_logic_vector (111 downto 0);
  signal n1894 : std_logic_vector (111 downto 0);
  signal n1895 : std_logic_vector (29 downto 0);
  signal n1896 : std_logic_vector (29 downto 0);
  signal n1897 : std_logic_vector (29 downto 0);
  signal n1898 : std_logic_vector (15 downto 0);
begin
  wr_in_progress <= n1814;
  stall <= vram_wr_full;
  oob <= n1858;
  vram_wr_addr <= n1889;
  vram_wr_data <= n1898;
  vram_wr <= n1890;
  vram_wr_access_mode <= n1892;
  n1805 <= bd_h & bd_w & bd_b;
  n1806 <= position_y & position_x;
  s1 <= n1894; -- (signal)
  s2 <= n1896; -- (signal)
  s2_nxt <= n1897; -- (signal)
  n1812 <= s1 (0);
  n1813 <= s2 (0);
  n1814 <= n1812 or n1813;
  n1816 <= not res_n;
  n1818 <= not vram_wr_full;
  n1819 <= n1806 (31 downto 16);
  n1820 <= n1806 (15 downto 0);
  n1821 <= alpha_color & alpha_mode & n1820 & n1819 & color & n1805 & wr;
  n1832 <= s1 (0);
  n1833 <= s1 (102 downto 87);
  n1835 <= '1' when signed (n1833) >= signed'("0000000000000000") else '0';
  n1836 <= s1 (102 downto 87);
  n1838 <= s1 (47 downto 33);
  n1840 <= '0' & n1838;
  n1841 <= '1' when signed (n1836) < signed (n1840) else '0';
  n1842 <= n1841 and n1835;
  n1843 <= s1 (86 downto 71);
  n1845 <= '1' when signed (n1843) >= signed'("0000000000000000") else '0';
  n1846 <= n1845 and n1842;
  n1847 <= s1 (86 downto 71);
  n1849 <= s1 (62 downto 48);
  n1851 <= '0' & n1849;
  n1852 <= '1' when signed (n1847) < signed (n1851) else '0';
  n1853 <= n1852 and n1846;
  n1854 <= not n1853;
  n1858 <= '0' when n1854 = '0' else '1';
  n1860 <= n1832 when n1854 = '0' else '0';
  n1861 <= s1 (103);
  n1862 <= s1 (70 downto 63);
  n1863 <= s1 (111 downto 104);
  n1864 <= '1' when n1862 = n1863 else '0';
  n1865 <= n1864 and n1861;
  n1867 <= n1860 when n1865 = '0' else '0';
  n1869 <= s1 (32 downto 1);
  n1870 <= s1 (102 downto 87);
  n1871 <= "0000000000000000" & n1870;  --  uext
  n1872 <= std_logic_vector (unsigned (n1869) + unsigned (n1871));
  n1874 <= s1 (47 downto 33);
  n1875 <= s1 (86 downto 71);
  n1876 <= "0000000000000000" & n1874;  --  uext
  n1877 <= "000000000000000" & n1875;  --  uext
  n1878 <= std_logic_vector (resize (unsigned (n1876) * unsigned (n1877), 31));
  n1879 <= "0" & n1878;  --  uext
  n1880 <= std_logic_vector (unsigned (n1872) + unsigned (n1879));
  n1881 <= n1880 (20 downto 0);  --  trunc
  n1882 <= s1 (70 downto 63);
  n1886 <= s2 (29 downto 22);
  n1888 <= n1887 (15 downto 8);
  n1889 <= s2 (21 downto 1);
  n1890 <= s2 (0);
  n1893 <= s1 when n1818 = '0' else n1821;
  process (clk, n1816)
  begin
    if n1816 = '1' then
      n1894 <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1894 <= n1893;
    end if;
  end process;
  n1895 <= s2 when n1818 = '0' else s2_nxt;
  process (clk, n1816)
  begin
    if n1816 = '1' then
      n1896 <= "000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1896 <= n1895;
    end if;
  end process;
  n1897 <= n1882 & n1881 & n1867;
  n1898 <= n1888 & n1886;
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
  signal n1533 : std_logic_vector (31 downto 0);
  signal n1536 : std_logic_vector (15 downto 0);
  signal n1537 : std_logic_vector (15 downto 0);
  signal state : std_logic_vector (163 downto 0);
  signal state_nxt : std_logic_vector (163 downto 0);
  signal n1540 : std_logic;
  signal n1543 : std_logic;
  signal n1557 : std_logic_vector (30 downto 0);
  signal n1558 : std_logic_vector (31 downto 0);
  signal n1559 : std_logic_vector (15 downto 0);
  signal n1560 : std_logic_vector (31 downto 0);
  signal n1561 : std_logic_vector (15 downto 0);
  signal n1562 : std_logic_vector (31 downto 0);
  signal n1565 : std_logic_vector (31 downto 0);
  signal n1566 : std_logic_vector (31 downto 0);
  signal n1567 : std_logic_vector (31 downto 0);
  signal n1568 : std_logic_vector (3 downto 0);
  signal n1570 : std_logic_vector (3 downto 0);
  signal n1571 : std_logic_vector (3 downto 0);
  signal n1573 : std_logic;
  signal n1575 : std_logic_vector (31 downto 0);
  signal n1578 : std_logic_vector (31 downto 0);
  signal n1579 : std_logic_vector (31 downto 0);
  signal n1583 : std_logic;
  signal n1585 : std_logic_vector (31 downto 0);
  signal n1588 : std_logic_vector (15 downto 0);
  signal n1591 : std_logic;
  signal n1593 : std_logic_vector (31 downto 0);
  signal n1596 : std_logic_vector (15 downto 0);
  signal n1599 : std_logic;
  signal n1601 : std_logic_vector (31 downto 0);
  signal n1604 : std_logic_vector (15 downto 0);
  signal n1607 : std_logic;
  signal n1609 : std_logic_vector (31 downto 0);
  signal n1612 : std_logic_vector (15 downto 0);
  signal n1615 : std_logic;
  signal n1616 : std_logic_vector (31 downto 0);
  signal n1617 : std_logic_vector (31 downto 0);
  signal n1618 : std_logic;
  signal n1619 : std_logic_vector (31 downto 0);
  signal n1621 : std_logic;
  signal n1622 : std_logic_vector (31 downto 0);
  signal n1624 : std_logic_vector (31 downto 0);
  signal n1626 : std_logic_vector (31 downto 0);
  signal n1627 : std_logic_vector (31 downto 0);
  signal n1628 : std_logic_vector (31 downto 0);
  signal n1629 : std_logic_vector (31 downto 0);
  signal n1630 : std_logic_vector (31 downto 0);
  signal n1631 : std_logic_vector (31 downto 0);
  signal n1632 : std_logic_vector (31 downto 0);
  signal n1634 : std_logic_vector (31 downto 0);
  signal n1636 : std_logic_vector (31 downto 0);
  signal n1637 : std_logic_vector (31 downto 0);
  signal n1639 : std_logic_vector (31 downto 0);
  signal n1642 : std_logic_vector (163 downto 0);
  signal n1643 : std_logic_vector (3 downto 0);
  signal n1644 : std_logic_vector (3 downto 0);
  signal n1645 : std_logic_vector (159 downto 0);
  signal n1646 : std_logic_vector (159 downto 0);
  signal n1647 : std_logic_vector (159 downto 0);
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
  signal n1738 : std_logic_vector (31 downto 0);
  signal n1739 : std_logic_vector (31 downto 0);
  signal n1740 : std_logic_vector (31 downto 0);
  signal n1741 : std_logic_vector (31 downto 0);
  signal n1744 : std_logic_vector (15 downto 0);
  signal n1745 : std_logic_vector (15 downto 0);
  signal n1748 : std_logic;
  signal n1749 : std_logic_vector (14 downto 0);
  signal n1752 : std_logic;
  signal n1767 : std_logic;
  signal n1769 : std_logic_vector (15 downto 0);
  signal n1770 : std_logic_vector (15 downto 0);
  signal n1771 : std_logic_vector (3 downto 0);
  signal n1772 : std_logic_vector (3 downto 0);
  signal n1773 : std_logic_vector (31 downto 0);
  signal n1774 : std_logic_vector (31 downto 0);
  signal n1775 : std_logic_vector (31 downto 0);
  signal n1776 : std_logic_vector (31 downto 0);
  signal n1777 : std_logic_vector (31 downto 0);
  signal n1778 : std_logic_vector (31 downto 0);
  signal n1779 : std_logic_vector (31 downto 0);
  signal n1780 : std_logic_vector (31 downto 0);
  signal n1781 : std_logic_vector (31 downto 0);
  signal n1782 : std_logic_vector (31 downto 0);
  signal n1783 : std_logic_vector (31 downto 0);
  signal n1784 : std_logic_vector (31 downto 0);
  signal n1785 : std_logic_vector (31 downto 0);
  signal n1786 : std_logic_vector (31 downto 0);
  signal n1787 : std_logic_vector (31 downto 0);
  signal n1797 : std_logic;
  signal n1799 : std_logic_vector (163 downto 0);
  signal n1800 : std_logic_vector (163 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  signal n1801 : std_logic_vector (163 downto 0);
  signal n1802 : std_logic_vector (31 downto 0);
begin
  busy <= n1752;
  pixel_valid <= n1797;
  pixel_x <= n1536;
  pixel_y <= n1537;
  n1533 <= center_y & center_x;
  n1536 <= n1802 (15 downto 0);
  n1537 <= n1802 (31 downto 16);
  state <= n1800; -- (isignal)
  state_nxt <= n1801; -- (signal)
  n1540 <= not res_n;
  n1543 <= '1' when unsigned'(1 => stall) <= unsigned'("0") else '0';
  n1557 <= "0000000000000000" & radius;  --  uext
  n1558 <= "0" & n1557;  --  uext
  n1559 <= n1533 (15 downto 0);
  n1560 <= std_logic_vector (resize (signed (n1559), 32));  --  sext
  n1561 <= n1533 (31 downto 16);
  n1562 <= std_logic_vector (resize (signed (n1561), 32));  --  sext
  n1565 <= state (67 downto 36);
  n1566 <= state (99 downto 68);
  n1567 <= state (35 downto 4);
  n1568 <= state (3 downto 0);
  n1570 <= state (3 downto 0);
  n1571 <= n1570 when start = '0' else "0001";
  n1573 <= '1' when n1568 = "0000" else '0';
  n1575 <= std_logic_vector (unsigned'("00000000000000000000000000000001") - unsigned (n1558));
  n1578 <= std_logic_vector (resize (signed'("00000000000000000000000000000010") * signed (n1558), 32));
  n1579 <= std_logic_vector(-signed (n1578));
  n1583 <= '1' when n1568 = "0001" else '0';
  n1585 <= std_logic_vector (unsigned (n1562) + unsigned (n1558));
  n1588 <= n1585 (15 downto 0);  --  trunc
  n1591 <= '1' when n1568 = "0011" else '0';
  n1593 <= std_logic_vector (unsigned (n1562) - unsigned (n1558));
  n1596 <= n1593 (15 downto 0);  --  trunc
  n1599 <= '1' when n1568 = "0100" else '0';
  n1601 <= std_logic_vector (unsigned (n1560) + unsigned (n1558));
  n1604 <= n1601 (15 downto 0);  --  trunc
  n1607 <= '1' when n1568 = "0101" else '0';
  n1609 <= std_logic_vector (unsigned (n1560) - unsigned (n1558));
  n1612 <= n1609 (15 downto 0);  --  trunc
  n1615 <= '1' when n1568 = "0110" else '0';
  n1616 <= state (131 downto 100);
  n1617 <= state (163 downto 132);
  n1618 <= '1' when signed (n1616) < signed (n1617) else '0';
  n1619 <= state (35 downto 4);
  n1621 <= '1' when signed (n1619) >= signed'("00000000000000000000000000000000") else '0';
  n1622 <= state (163 downto 132);
  n1624 <= std_logic_vector (unsigned (n1622) - unsigned'("00000000000000000000000000000001"));
  n1626 <= std_logic_vector (unsigned (n1566) + unsigned'("00000000000000000000000000000010"));
  n1627 <= std_logic_vector (unsigned (n1567) + unsigned (n1626));
  n1628 <= state (163 downto 132);
  n1629 <= n1628 when n1621 = '0' else n1624;
  n1630 <= n1566 when n1621 = '0' else n1626;
  n1631 <= n1567 when n1621 = '0' else n1627;
  n1632 <= state (131 downto 100);
  n1634 <= std_logic_vector (unsigned (n1632) + unsigned'("00000000000000000000000000000001"));
  n1636 <= std_logic_vector (unsigned (n1565) + unsigned'("00000000000000000000000000000010"));
  n1637 <= std_logic_vector (unsigned (n1631) + unsigned (n1636));
  n1639 <= std_logic_vector (unsigned (n1637) + unsigned'("00000000000000000000000000000001"));
  n1642 <= n1629 & n1634 & n1630 & n1636 & n1639 & "0111";
  n1643 <= n1642 (3 downto 0);
  n1644 <= "0000" when n1618 = '0' else n1643;
  n1645 <= n1642 (163 downto 4);
  n1646 <= state (163 downto 4);
  n1647 <= n1646 when n1618 = '0' else n1645;
  n1652 <= '1' when n1568 = "0010" else '0';
  n1654 <= state (131 downto 100);
  n1655 <= std_logic_vector (unsigned (n1560) + unsigned (n1654));
  n1656 <= state (163 downto 132);
  n1657 <= std_logic_vector (unsigned (n1562) + unsigned (n1656));
  n1660 <= n1655 (15 downto 0);  --  trunc
  n1661 <= n1657 (15 downto 0);  --  trunc
  n1664 <= '1' when n1568 = "0111" else '0';
  n1666 <= state (131 downto 100);
  n1667 <= std_logic_vector (unsigned (n1560) - unsigned (n1666));
  n1668 <= state (163 downto 132);
  n1669 <= std_logic_vector (unsigned (n1562) + unsigned (n1668));
  n1672 <= n1667 (15 downto 0);  --  trunc
  n1673 <= n1669 (15 downto 0);  --  trunc
  n1676 <= '1' when n1568 = "1000" else '0';
  n1678 <= state (131 downto 100);
  n1679 <= std_logic_vector (unsigned (n1560) + unsigned (n1678));
  n1680 <= state (163 downto 132);
  n1681 <= std_logic_vector (unsigned (n1562) - unsigned (n1680));
  n1684 <= n1679 (15 downto 0);  --  trunc
  n1685 <= n1681 (15 downto 0);  --  trunc
  n1688 <= '1' when n1568 = "1001" else '0';
  n1690 <= state (131 downto 100);
  n1691 <= std_logic_vector (unsigned (n1560) - unsigned (n1690));
  n1692 <= state (163 downto 132);
  n1693 <= std_logic_vector (unsigned (n1562) - unsigned (n1692));
  n1696 <= n1691 (15 downto 0);  --  trunc
  n1697 <= n1693 (15 downto 0);  --  trunc
  n1700 <= '1' when n1568 = "1010" else '0';
  n1702 <= state (163 downto 132);
  n1703 <= std_logic_vector (unsigned (n1560) + unsigned (n1702));
  n1704 <= state (131 downto 100);
  n1705 <= std_logic_vector (unsigned (n1562) + unsigned (n1704));
  n1708 <= n1703 (15 downto 0);  --  trunc
  n1709 <= n1705 (15 downto 0);  --  trunc
  n1712 <= '1' when n1568 = "1011" else '0';
  n1714 <= state (163 downto 132);
  n1715 <= std_logic_vector (unsigned (n1560) - unsigned (n1714));
  n1716 <= state (131 downto 100);
  n1717 <= std_logic_vector (unsigned (n1562) + unsigned (n1716));
  n1720 <= n1715 (15 downto 0);  --  trunc
  n1721 <= n1717 (15 downto 0);  --  trunc
  n1724 <= '1' when n1568 = "1100" else '0';
  n1726 <= state (163 downto 132);
  n1727 <= std_logic_vector (unsigned (n1560) + unsigned (n1726));
  n1728 <= state (131 downto 100);
  n1729 <= std_logic_vector (unsigned (n1562) - unsigned (n1728));
  n1732 <= n1727 (15 downto 0);  --  trunc
  n1733 <= n1729 (15 downto 0);  --  trunc
  n1736 <= '1' when n1568 = "1101" else '0';
  n1738 <= state (163 downto 132);
  n1739 <= std_logic_vector (unsigned (n1560) - unsigned (n1738));
  n1740 <= state (131 downto 100);
  n1741 <= std_logic_vector (unsigned (n1562) - unsigned (n1740));
  n1744 <= n1739 (15 downto 0);  --  trunc
  n1745 <= n1741 (15 downto 0);  --  trunc
  n1748 <= '1' when n1568 = "1110" else '0';
  n1749 <= n1748 & n1736 & n1724 & n1712 & n1700 & n1688 & n1676 & n1664 & n1652 & n1615 & n1607 & n1599 & n1591 & n1583 & n1573;
  with n1749 select n1752 <=
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
  with n1749 select n1767 <=
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
  with n1749 select n1769 <=
    n1744 when "100000000000000",
    n1732 when "010000000000000",
    n1720 when "001000000000000",
    n1708 when "000100000000000",
    n1696 when "000010000000000",
    n1684 when "000001000000000",
    n1672 when "000000100000000",
    n1660 when "000000010000000",
    "0000000000000000" when "000000001000000",
    n1612 when "000000000100000",
    n1604 when "000000000010000",
    n1559 when "000000000001000",
    n1559 when "000000000000100",
    "0000000000000000" when "000000000000010",
    "0000000000000000" when "000000000000001",
    "0000000000000000" when others;
  with n1749 select n1770 <=
    n1745 when "100000000000000",
    n1733 when "010000000000000",
    n1721 when "001000000000000",
    n1709 when "000100000000000",
    n1697 when "000010000000000",
    n1685 when "000001000000000",
    n1673 when "000000100000000",
    n1661 when "000000010000000",
    "0000000000000000" when "000000001000000",
    n1561 when "000000000100000",
    n1561 when "000000000010000",
    n1596 when "000000000001000",
    n1588 when "000000000000100",
    "0000000000000000" when "000000000000010",
    "0000000000000000" when "000000000000001",
    "0000000000000000" when others;
  n1771 <= state (3 downto 0);
  with n1749 select n1772 <=
    "0010" when "100000000000000",
    "1110" when "010000000000000",
    "1101" when "001000000000000",
    "1100" when "000100000000000",
    "1011" when "000010000000000",
    "1010" when "000001000000000",
    "1001" when "000000100000000",
    "1000" when "000000010000000",
    n1644 when "000000001000000",
    "0010" when "000000000100000",
    "0110" when "000000000010000",
    "0101" when "000000000001000",
    "0100" when "000000000000100",
    "0011" when "000000000000010",
    n1571 when "000000000000001",
    n1771 when others;
  n1773 <= n1647 (31 downto 0);
  n1774 <= state (35 downto 4);
  with n1749 select n1775 <=
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
    n1575 when "000000000000010",
    n1774 when "000000000000001",
    n1774 when others;
  n1776 <= n1647 (63 downto 32);
  n1777 <= state (67 downto 36);
  with n1749 select n1778 <=
    n1777 when "100000000000000",
    n1777 when "010000000000000",
    n1777 when "001000000000000",
    n1777 when "000100000000000",
    n1777 when "000010000000000",
    n1777 when "000001000000000",
    n1777 when "000000100000000",
    n1777 when "000000010000000",
    n1776 when "000000001000000",
    n1777 when "000000000100000",
    n1777 when "000000000010000",
    n1777 when "000000000001000",
    n1777 when "000000000000100",
    "00000000000000000000000000000000" when "000000000000010",
    n1777 when "000000000000001",
    n1777 when others;
  n1779 <= n1647 (95 downto 64);
  n1780 <= state (99 downto 68);
  with n1749 select n1781 <=
    n1780 when "100000000000000",
    n1780 when "010000000000000",
    n1780 when "001000000000000",
    n1780 when "000100000000000",
    n1780 when "000010000000000",
    n1780 when "000001000000000",
    n1780 when "000000100000000",
    n1780 when "000000010000000",
    n1779 when "000000001000000",
    n1780 when "000000000100000",
    n1780 when "000000000010000",
    n1780 when "000000000001000",
    n1780 when "000000000000100",
    n1579 when "000000000000010",
    n1780 when "000000000000001",
    n1780 when others;
  n1782 <= n1647 (127 downto 96);
  n1783 <= state (131 downto 100);
  with n1749 select n1784 <=
    n1783 when "100000000000000",
    n1783 when "010000000000000",
    n1783 when "001000000000000",
    n1783 when "000100000000000",
    n1783 when "000010000000000",
    n1783 when "000001000000000",
    n1783 when "000000100000000",
    n1783 when "000000010000000",
    n1782 when "000000001000000",
    n1783 when "000000000100000",
    n1783 when "000000000010000",
    n1783 when "000000000001000",
    n1783 when "000000000000100",
    "00000000000000000000000000000000" when "000000000000010",
    n1783 when "000000000000001",
    n1783 when others;
  n1785 <= n1647 (159 downto 128);
  n1786 <= state (163 downto 132);
  with n1749 select n1787 <=
    n1786 when "100000000000000",
    n1786 when "010000000000000",
    n1786 when "001000000000000",
    n1786 when "000100000000000",
    n1786 when "000010000000000",
    n1786 when "000001000000000",
    n1786 when "000000100000000",
    n1786 when "000000010000000",
    n1785 when "000000001000000",
    n1786 when "000000000100000",
    n1786 when "000000000010000",
    n1786 when "000000000001000",
    n1786 when "000000000000100",
    n1558 when "000000000000010",
    n1786 when "000000000000001",
    n1786 when others;
  n1797 <= n1767 when stall = '0' else '0';
  n1799 <= state when n1543 = '0' else state_nxt;
  process (clk, n1540)
  begin
    if n1540 = '1' then
      n1800 <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1800 <= n1799;
    end if;
  end process;
  n1801 <= n1787 & n1784 & n1781 & n1778 & n1775 & n1772;
  n1802 <= n1770 & n1769;
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
  signal n1527 : std_logic_vector (61 downto 0);
  signal n1528 : std_logic_vector (61 downto 0) := "00000000000000000000000000000000000000000000000000000000000000";
  signal n1530 : std_logic_vector (61 downto 0);
begin
  rd1_data <= n1528;
  n1527 <= n1528 when rd1 = '0' else n1530;
  process (clk)
  begin
    if rising_edge (clk) then
      n1528 <= n1527;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (61 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n1530 <= ram(to_integer (unsigned (rd1_addr)));
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
  signal n409 : std_logic;
  signal n410 : std_logic;
  signal n411 : std_logic;
  signal n412 : std_logic_vector (15 downto 0);
  signal n413 : std_logic_vector (15 downto 0);
  signal n415 : std_logic_vector (15 downto 0);
  signal n416 : std_logic_vector (15 downto 0);
  signal n417 : std_logic_vector (15 downto 0);
  signal n419 : std_logic_vector (15 downto 0);
  signal n420 : std_logic_vector (15 downto 0);
  signal n421 : std_logic_vector (15 downto 0);
  signal n422 : std_logic_vector (31 downto 0);
  signal n423 : std_logic_vector (31 downto 0);
  signal n424 : std_logic_vector (31 downto 0);
  signal n427 : std_logic;
  signal n429 : std_logic_vector (10 downto 0);
  signal n430 : std_logic_vector (5 downto 0);
  signal n431 : std_logic_vector (31 downto 0);
  signal n432 : std_logic_vector (31 downto 0);
  signal n435 : std_logic;
  signal n437 : std_logic;
  signal n439 : std_logic_vector (9 downto 0);
  signal n440 : std_logic_vector (14 downto 0);
  signal n442 : std_logic_vector (5 downto 0);
  signal n443 : std_logic_vector (14 downto 0);
  signal n444 : std_logic_vector (14 downto 0);
  signal n446 : std_logic;
  signal n448 : std_logic_vector (15 downto 0);
  signal n449 : std_logic_vector (14 downto 0);
  signal n450 : std_logic_vector (15 downto 0);
  signal n451 : std_logic_vector (14 downto 0);
  signal n452 : std_logic_vector (15 downto 0);
  signal n453 : std_logic_vector (14 downto 0);
  signal n454 : std_logic_vector (15 downto 0);
  signal n455 : std_logic_vector (14 downto 0);
  signal n457 : std_logic;
  signal n461 : std_logic_vector (14 downto 0);
  signal n462 : std_logic_vector (14 downto 0);
  signal n464 : std_logic;
  signal n467 : std_logic;
  signal n469 : std_logic_vector (31 downto 0);
  signal n474 : std_logic;
  signal n478 : std_logic;
  signal n481 : std_logic;
  signal n487 : std_logic;
  signal n493 : std_logic;
  signal n495 : std_logic;
  signal n497 : std_logic_vector (15 downto 0);
  signal n499 : std_logic_vector (15 downto 0);
  signal n500 : std_logic_vector (15 downto 0);
  signal n501 : std_logic_vector (15 downto 0);
  signal n502 : std_logic;
  signal n504 : std_logic_vector (15 downto 0);
  signal n506 : std_logic_vector (15 downto 0);
  signal n507 : std_logic_vector (15 downto 0);
  signal n508 : std_logic_vector (15 downto 0);
  signal n509 : std_logic_vector (31 downto 0);
  signal n510 : std_logic_vector (5 downto 0);
  signal n511 : std_logic_vector (5 downto 0);
  signal n512 : std_logic_vector (31 downto 0);
  signal n513 : std_logic_vector (31 downto 0);
  signal n515 : std_logic;
  signal n516 : std_logic;
  signal n517 : std_logic_vector (31 downto 0);
  signal n518 : std_logic_vector (20 downto 0);
  signal n522 : std_logic;
  signal n523 : std_logic_vector (5 downto 0);
  signal n524 : std_logic_vector (5 downto 0);
  signal n525 : std_logic_vector (20 downto 0);
  signal n526 : std_logic_vector (20 downto 0);
  signal n527 : std_logic_vector (31 downto 0);
  signal n528 : std_logic_vector (20 downto 0);
  signal n531 : std_logic;
  signal n532 : std_logic_vector (5 downto 0);
  signal n533 : std_logic_vector (20 downto 0);
  signal n535 : std_logic;
  constant n536 : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n539 : std_logic;
  signal n541 : std_logic_vector (31 downto 0);
  signal n546 : std_logic;
  signal n550 : std_logic;
  signal n553 : std_logic;
  signal n559 : std_logic;
  signal n565 : std_logic;
  signal n567 : std_logic_vector (15 downto 0);
  signal n569 : std_logic_vector (14 downto 0);
  signal n571 : std_logic_vector (14 downto 0);
  signal n572 : std_logic_vector (15 downto 0);
  signal n573 : std_logic;
  signal n576 : std_logic_vector (15 downto 0);
  signal n578 : std_logic_vector (14 downto 0);
  signal n580 : std_logic_vector (14 downto 0);
  signal n581 : std_logic_vector (15 downto 0);
  signal n582 : std_logic;
  signal n585 : std_logic_vector (15 downto 0);
  signal n587 : std_logic_vector (15 downto 0);
  signal n588 : std_logic_vector (5 downto 0);
  signal n589 : std_logic_vector (5 downto 0);
  signal n590 : std_logic_vector (15 downto 0);
  signal n591 : std_logic_vector (15 downto 0);
  signal n593 : std_logic_vector (15 downto 0);
  signal n595 : std_logic_vector (15 downto 0);
  signal n596 : std_logic_vector (31 downto 0);
  signal n598 : std_logic;
  signal n599 : std_logic_vector (15 downto 0);
  signal n600 : std_logic_vector (15 downto 0);
  signal n601 : std_logic_vector (15 downto 0);
  signal n602 : std_logic_vector (15 downto 0);
  signal n603 : std_logic_vector (15 downto 0);
  signal n604 : std_logic_vector (31 downto 0);
  signal n606 : std_logic;
  signal n607 : std_logic_vector (31 downto 0);
  signal n608 : std_logic_vector (31 downto 0);
  signal n610 : std_logic;
  signal n612 : std_logic_vector (15 downto 0);
  signal n615 : std_logic;
  signal n617 : std_logic_vector (15 downto 0);
  signal n619 : std_logic_vector (15 downto 0);
  signal n620 : std_logic_vector (15 downto 0);
  signal n621 : std_logic;
  signal n623 : std_logic;
  signal n625 : std_logic_vector (15 downto 0);
  signal n626 : std_logic_vector (15 downto 0);
  signal n627 : std_logic_vector (15 downto 0);
  signal n628 : std_logic_vector (15 downto 0);
  signal n629 : std_logic;
  signal n631 : std_logic_vector (15 downto 0);
  signal n633 : std_logic_vector (15 downto 0);
  signal n634 : std_logic_vector (15 downto 0);
  signal n635 : std_logic_vector (15 downto 0);
  signal n638 : std_logic_vector (15 downto 0);
  signal n640 : std_logic_vector (15 downto 0);
  signal n645 : std_logic;
  signal n649 : std_logic;
  signal n652 : std_logic;
  signal n658 : std_logic;
  signal n664 : std_logic;
  signal n666 : std_logic;
  signal n668 : std_logic_vector (15 downto 0);
  signal n670 : std_logic_vector (15 downto 0);
  signal n672 : std_logic_vector (15 downto 0);
  signal n674 : std_logic_vector (15 downto 0);
  signal n675 : std_logic_vector (15 downto 0);
  signal n676 : std_logic_vector (15 downto 0);
  signal n677 : std_logic_vector (15 downto 0);
  signal n678 : std_logic_vector (31 downto 0);
  signal n679 : std_logic_vector (5 downto 0);
  signal n680 : std_logic_vector (5 downto 0);
  signal n681 : std_logic_vector (15 downto 0);
  signal n682 : std_logic_vector (15 downto 0);
  signal n683 : std_logic_vector (31 downto 0);
  signal n684 : std_logic_vector (31 downto 0);
  signal n686 : std_logic;
  signal n688 : std_logic_vector (7 downto 0);
  signal n689 : std_logic_vector (31 downto 0);
  signal n691 : std_logic_vector (31 downto 0);
  signal n693 : std_logic;
  signal n695 : std_logic_vector (15 downto 0);
  signal n698 : std_logic;
  signal n700 : std_logic_vector (15 downto 0);
  signal n702 : std_logic_vector (15 downto 0);
  signal n703 : std_logic_vector (15 downto 0);
  signal n704 : std_logic;
  signal n706 : std_logic;
  signal n708 : std_logic_vector (15 downto 0);
  signal n710 : std_logic_vector (15 downto 0);
  signal n711 : std_logic_vector (15 downto 0);
  signal n712 : std_logic_vector (15 downto 0);
  signal n713 : std_logic;
  signal n715 : std_logic_vector (15 downto 0);
  signal n716 : std_logic_vector (15 downto 0);
  signal n717 : std_logic_vector (15 downto 0);
  signal n718 : std_logic_vector (15 downto 0);
  signal n721 : std_logic_vector (15 downto 0);
  signal n723 : std_logic_vector (15 downto 0);
  signal n728 : std_logic;
  signal n732 : std_logic;
  signal n735 : std_logic;
  signal n741 : std_logic;
  signal n747 : std_logic;
  signal n749 : std_logic;
  signal n751 : std_logic_vector (15 downto 0);
  signal n753 : std_logic_vector (15 downto 0);
  signal n755 : std_logic_vector (15 downto 0);
  signal n757 : std_logic_vector (15 downto 0);
  signal n758 : std_logic_vector (15 downto 0);
  signal n759 : std_logic_vector (15 downto 0);
  signal n760 : std_logic_vector (15 downto 0);
  signal n761 : std_logic_vector (31 downto 0);
  signal n762 : std_logic_vector (5 downto 0);
  signal n763 : std_logic_vector (5 downto 0);
  signal n764 : std_logic_vector (15 downto 0);
  signal n765 : std_logic_vector (15 downto 0);
  signal n766 : std_logic_vector (31 downto 0);
  signal n767 : std_logic_vector (31 downto 0);
  signal n769 : std_logic;
  signal n771 : std_logic_vector (7 downto 0);
  signal n772 : std_logic_vector (31 downto 0);
  signal n774 : std_logic_vector (31 downto 0);
  signal n776 : std_logic;
  signal n777 : std_logic;
  signal n779 : std_logic_vector (5 downto 0);
  signal n780 : std_logic_vector (5 downto 0);
  signal n783 : std_logic;
  signal n785 : std_logic;
  signal n791 : std_logic;
  signal n795 : std_logic;
  signal n812 : std_logic;
  signal n814 : std_logic_vector (7 downto 0);
  signal n816 : std_logic_vector (31 downto 0);
  signal n817 : std_logic;
  signal n818 : std_logic;
  signal n820 : std_logic_vector (15 downto 0);
  signal n822 : std_logic_vector (15 downto 0);
  signal n823 : std_logic_vector (15 downto 0);
  signal n824 : std_logic_vector (15 downto 0);
  signal n825 : std_logic_vector (15 downto 0);
  signal n826 : std_logic;
  signal n828 : std_logic_vector (15 downto 0);
  signal n830 : std_logic_vector (15 downto 0);
  signal n831 : std_logic_vector (15 downto 0);
  signal n832 : std_logic_vector (15 downto 0);
  signal n833 : std_logic_vector (15 downto 0);
  signal n835 : std_logic_vector (31 downto 0);
  signal n836 : std_logic_vector (5 downto 0);
  signal n837 : std_logic_vector (5 downto 0);
  signal n838 : std_logic_vector (31 downto 0);
  signal n839 : std_logic_vector (31 downto 0);
  signal n841 : std_logic;
  signal n849 : std_logic;
  signal n863 : std_logic_vector (1 downto 0);
  signal n866 : std_logic_vector (15 downto 0);
  signal n869 : std_logic_vector (15 downto 0);
  signal n872 : std_logic;
  signal n874 : std_logic;
  signal n875 : std_logic;
  signal n876 : std_logic_vector (14 downto 0);
  signal n878 : std_logic_vector (15 downto 0);
  signal n880 : std_logic_vector (15 downto 0);
  signal n881 : std_logic_vector (15 downto 0);
  signal n883 : std_logic_vector (15 downto 0);
  signal n884 : std_logic_vector (15 downto 0);
  signal n886 : std_logic;
  signal n888 : std_logic;
  signal n889 : std_logic;
  signal n890 : std_logic_vector (14 downto 0);
  signal n892 : std_logic_vector (15 downto 0);
  signal n894 : std_logic_vector (15 downto 0);
  signal n895 : std_logic_vector (15 downto 0);
  signal n897 : std_logic_vector (15 downto 0);
  signal n898 : std_logic_vector (15 downto 0);
  signal n900 : std_logic;
  signal n902 : std_logic;
  signal n903 : std_logic;
  signal n905 : std_logic_vector (15 downto 0);
  signal n906 : std_logic_vector (15 downto 0);
  signal n908 : std_logic_vector (15 downto 0);
  signal n909 : std_logic_vector (15 downto 0);
  signal n911 : std_logic_vector (15 downto 0);
  signal n912 : std_logic_vector (15 downto 0);
  signal n914 : std_logic_vector (15 downto 0);
  signal n915 : std_logic_vector (15 downto 0);
  signal n916 : std_logic_vector (15 downto 0);
  signal n918 : std_logic_vector (15 downto 0);
  signal n927 : std_logic_vector (1 downto 0);
  signal n928 : std_logic_vector (7 downto 0);
  signal n929 : std_logic_vector (7 downto 0);
  signal n931 : std_logic;
  signal n932 : std_logic_vector (7 downto 0);
  signal n933 : std_logic_vector (7 downto 0);
  signal n935 : std_logic;
  signal n936 : std_logic_vector (7 downto 0);
  signal n937 : std_logic_vector (7 downto 0);
  signal n939 : std_logic;
  signal n940 : std_logic_vector (2 downto 0);
  signal n945 : std_logic;
  signal n953 : std_logic_vector (7 downto 0);
  signal n958 : std_logic_vector (7 downto 0);
  signal n959 : std_logic;
  signal n964 : std_logic;
  signal n968 : std_logic;
  signal n971 : std_logic;
  signal n977 : std_logic;
  signal n983 : std_logic;
  signal n985 : std_logic_vector (15 downto 0);
  signal n986 : std_logic_vector (14 downto 0);
  signal n988 : std_logic_vector (14 downto 0);
  signal n989 : std_logic_vector (15 downto 0);
  signal n990 : std_logic;
  signal n993 : std_logic_vector (15 downto 0);
  signal n994 : std_logic_vector (14 downto 0);
  signal n996 : std_logic_vector (14 downto 0);
  signal n997 : std_logic_vector (15 downto 0);
  signal n998 : std_logic;
  signal n1001 : std_logic_vector (15 downto 0);
  signal n1003 : std_logic_vector (15 downto 0);
  signal n1004 : std_logic_vector (5 downto 0);
  signal n1005 : std_logic_vector (5 downto 0);
  signal n1006 : std_logic_vector (15 downto 0);
  signal n1007 : std_logic_vector (15 downto 0);
  signal n1009 : std_logic_vector (15 downto 0);
  signal n1011 : std_logic_vector (15 downto 0);
  signal n1012 : std_logic_vector (31 downto 0);
  signal n1014 : std_logic;
  signal n1015 : std_logic_vector (15 downto 0);
  signal n1016 : std_logic_vector (15 downto 0);
  signal n1017 : std_logic_vector (15 downto 0);
  signal n1018 : std_logic_vector (15 downto 0);
  signal n1019 : std_logic_vector (15 downto 0);
  signal n1020 : std_logic_vector (31 downto 0);
  signal n1022 : std_logic;
  signal n1023 : std_logic_vector (31 downto 0);
  signal n1024 : std_logic_vector (31 downto 0);
  signal n1027 : std_logic;
  signal n1029 : std_logic;
  signal n1031 : std_logic;
  signal n1033 : std_logic;
  signal n1035 : std_logic_vector (7 downto 0);
  signal n1036 : std_logic_vector (31 downto 0);
  signal n1038 : std_logic_vector (31 downto 0);
  signal n1040 : std_logic;
  signal n1042 : std_logic;
  signal n1044 : std_logic;
  signal n1054 : std_logic_vector (1 downto 0);
  signal n1056 : std_logic;
  signal n1058 : std_logic;
  signal n1060 : std_logic;
  signal n1061 : std_logic;
  signal n1063 : std_logic_vector (15 downto 0);
  signal n1064 : std_logic_vector (14 downto 0);
  signal n1066 : std_logic_vector (15 downto 0);
  signal n1067 : std_logic_vector (15 downto 0);
  signal n1069 : std_logic_vector (15 downto 0);
  signal n1070 : std_logic_vector (14 downto 0);
  signal n1072 : std_logic_vector (15 downto 0);
  signal n1073 : std_logic_vector (15 downto 0);
  signal n1074 : std_logic_vector (15 downto 0);
  signal n1075 : std_logic_vector (15 downto 0);
  signal n1076 : std_logic_vector (15 downto 0);
  signal n1077 : std_logic;
  signal n1079 : std_logic;
  signal n1081 : std_logic;
  signal n1082 : std_logic;
  signal n1084 : std_logic_vector (15 downto 0);
  signal n1085 : std_logic_vector (14 downto 0);
  signal n1087 : std_logic_vector (15 downto 0);
  signal n1088 : std_logic_vector (15 downto 0);
  signal n1090 : std_logic_vector (15 downto 0);
  signal n1091 : std_logic_vector (14 downto 0);
  signal n1093 : std_logic_vector (15 downto 0);
  signal n1094 : std_logic_vector (15 downto 0);
  signal n1095 : std_logic_vector (15 downto 0);
  signal n1096 : std_logic_vector (15 downto 0);
  signal n1097 : std_logic_vector (15 downto 0);
  signal n1100 : std_logic;
  signal n1101 : std_logic;
  signal n1102 : std_logic_vector (20 downto 0);
  signal n1103 : std_logic;
  signal n1106 : std_logic;
  signal n1109 : std_logic_vector (5 downto 0);
  signal n1110 : std_logic_vector (5 downto 0);
  signal n1113 : std_logic;
  signal n1115 : std_logic_vector (20 downto 0);
  signal n1117 : std_logic_vector (15 downto 0);
  signal n1119 : std_logic;
  signal n1121 : std_logic;
  signal n1122 : std_logic_vector (20 downto 0);
  signal n1125 : std_logic;
  signal n1126 : std_logic_vector (20 downto 0);
  signal n1129 : std_logic;
  signal n1130 : std_logic;
  signal n1136 : std_logic_vector (4 downto 0);
  signal n1138 : std_logic;
  signal n1139 : std_logic;
  signal n1145 : std_logic_vector (4 downto 0);
  signal n1147 : std_logic;
  signal n1150 : std_logic;
  signal n1151 : std_logic_vector (15 downto 0);
  signal n1153 : std_logic_vector (15 downto 0);
  signal n1156 : std_logic;
  signal n1157 : std_logic_vector (5 downto 0);
  signal n1158 : std_logic_vector (5 downto 0);
  signal n1159 : std_logic_vector (15 downto 0);
  signal n1160 : std_logic_vector (15 downto 0);
  signal n1162 : std_logic;
  signal n1163 : std_logic_vector (20 downto 0);
  signal n1169 : std_logic_vector (4 downto 0);
  signal n1171 : std_logic;
  signal n1172 : std_logic_vector (15 downto 0);
  signal n1173 : std_logic;
  signal n1174 : std_logic;
  signal n1175 : std_logic_vector (20 downto 0);
  signal n1177 : std_logic_vector (20 downto 0);
  signal n1178 : std_logic_vector (20 downto 0);
  signal n1180 : std_logic_vector (20 downto 0);
  signal n1181 : std_logic_vector (20 downto 0);
  signal n1184 : std_logic;
  signal n1185 : std_logic_vector (15 downto 0);
  signal n1187 : std_logic;
  signal n1190 : std_logic_vector (5 downto 0);
  signal n1191 : std_logic_vector (5 downto 0);
  signal n1192 : std_logic_vector (5 downto 0);
  signal n1193 : std_logic_vector (20 downto 0);
  signal n1194 : std_logic_vector (20 downto 0);
  signal n1197 : std_logic;
  signal n1199 : std_logic;
  signal n1201 : std_logic;
  signal n1203 : std_logic_vector (20 downto 0);
  signal n1204 : std_logic;
  signal n1207 : std_logic;
  signal n1210 : std_logic;
  signal n1212 : std_logic;
  signal n1214 : std_logic_vector (5 downto 0);
  signal n1215 : std_logic_vector (5 downto 0);
  signal n1216 : std_logic_vector (15 downto 0);
  signal n1217 : std_logic_vector (15 downto 0);
  signal n1219 : std_logic;
  signal n1222 : std_logic;
  signal n1224 : std_logic_vector (31 downto 0);
  signal n1226 : std_logic;
  signal n1228 : std_logic_vector (31 downto 0);
  signal n1230 : std_logic;
  signal n1231 : std_logic_vector (31 downto 0);
  signal n1232 : std_logic;
  signal n1236 : std_logic;
  signal n1237 : std_logic_vector (5 downto 0);
  signal n1238 : std_logic_vector (5 downto 0);
  signal n1242 : std_logic;
  signal n1243 : std_logic_vector (5 downto 0);
  signal n1244 : std_logic_vector (15 downto 0);
  signal n1245 : std_logic_vector (15 downto 0);
  signal n1247 : std_logic;
  signal n1248 : std_logic_vector (31 downto 0);
  signal n1250 : std_logic_vector (5 downto 0);
  signal n1251 : std_logic_vector (5 downto 0);
  signal n1252 : std_logic_vector (15 downto 0);
  signal n1253 : std_logic_vector (15 downto 0);
  signal n1255 : std_logic;
  signal n1257 : std_logic;
  signal n1259 : std_logic_vector (15 downto 0);
  signal n1261 : std_logic_vector (15 downto 0);
  signal n1262 : std_logic_vector (15 downto 0);
  signal n1263 : std_logic_vector (15 downto 0);
  signal n1264 : std_logic;
  signal n1266 : std_logic_vector (15 downto 0);
  signal n1268 : std_logic_vector (15 downto 0);
  signal n1269 : std_logic_vector (15 downto 0);
  signal n1270 : std_logic_vector (15 downto 0);
  signal n1272 : std_logic;
  signal n1273 : std_logic_vector (33 downto 0);
  signal n1274 : std_logic_vector (20 downto 0);
  signal n1276 : std_logic;
  signal n1279 : std_logic;
  signal n1282 : std_logic;
  signal n1287 : std_logic;
  signal n1290 : std_logic;
  signal n1292 : std_logic_vector (5 downto 0);
  signal n1293 : std_logic_vector (5 downto 0);
  signal n1294 : std_logic_vector (15 downto 0);
  signal n1295 : std_logic_vector (15 downto 0);
  signal n1296 : std_logic_vector (1 downto 0);
  signal n1297 : std_logic_vector (1 downto 0);
  signal n1298 : std_logic_vector (14 downto 0);
  signal n1299 : std_logic_vector (14 downto 0);
  signal n1300 : std_logic_vector (14 downto 0);
  signal n1301 : std_logic_vector (14 downto 0);
  signal n1302 : std_logic_vector (14 downto 0);
  signal n1303 : std_logic_vector (14 downto 0);
  signal n1304 : std_logic_vector (14 downto 0);
  signal n1305 : std_logic_vector (14 downto 0);
  signal n1306 : std_logic_vector (20 downto 0);
  signal n1307 : std_logic_vector (20 downto 0);
  signal n1308 : std_logic_vector (15 downto 0);
  signal n1309 : std_logic_vector (15 downto 0);
  signal n1310 : std_logic_vector (20 downto 0);
  signal n1311 : std_logic_vector (20 downto 0);
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
  signal n1326 : std_logic_vector (15 downto 0);
  signal n1327 : std_logic_vector (15 downto 0);
  signal n1328 : std_logic_vector (15 downto 0);
  signal n1329 : std_logic_vector (15 downto 0);
  signal n1330 : std_logic_vector (15 downto 0);
  signal n1331 : std_logic_vector (15 downto 0);
  signal n1332 : std_logic_vector (15 downto 0);
  signal n1333 : std_logic_vector (15 downto 0);
  signal n1334 : std_logic_vector (15 downto 0);
  signal n1335 : std_logic_vector (15 downto 0);
  signal n1336 : std_logic_vector (15 downto 0);
  signal n1337 : std_logic_vector (15 downto 0);
  signal n1338 : std_logic_vector (7 downto 0);
  signal n1339 : std_logic_vector (7 downto 0);
  signal n1340 : std_logic_vector (7 downto 0);
  signal n1341 : std_logic_vector (7 downto 0);
  signal n1342 : std_logic_vector (61 downto 0);
  signal n1343 : std_logic_vector (61 downto 0);
  signal n1344 : std_logic_vector (7 downto 0);
  signal n1345 : std_logic_vector (7 downto 0);
  signal n1346 : std_logic_vector (1 downto 0);
  signal n1347 : std_logic_vector (1 downto 0);
  signal n1368 : std_logic;
  signal n1371 : std_logic;
  signal n1374 : std_logic;
  signal n1377 : std_logic_vector (7 downto 0);
  signal n1380 : std_logic_vector (31 downto 0);
  signal n1385 : std_logic;
  signal n1388 : std_logic;
  signal n1391 : std_logic_vector (20 downto 0);
  signal n1394 : std_logic_vector (15 downto 0);
  signal n1397 : std_logic;
  signal n1401 : std_logic;
  signal n1404 : std_logic;
  signal n1407 : std_logic;
  signal n1412 : std_logic_vector (20 downto 0);
  signal n1414 : std_logic_vector (15 downto 0);
  signal n1417 : std_logic;
  signal n1419 : std_logic;
  signal n1420 : std_logic_vector (20 downto 0);
  signal n1422 : std_logic_vector (15 downto 0);
  signal n1425 : std_logic;
  signal n1427 : std_logic;
  signal gfx_circle_inst_c_busy : std_logic;
  signal gfx_circle_inst_c_pixel_valid : std_logic;
  signal gfx_circle_inst_c_pixel_x : std_logic_vector (15 downto 0);
  signal gfx_circle_inst_c_pixel_y : std_logic_vector (15 downto 0);
  signal n1431 : std_logic_vector (31 downto 0);
  signal n1432 : std_logic_vector (15 downto 0);
  signal n1433 : std_logic_vector (15 downto 0);
  signal n1435 : std_logic_vector (31 downto 0);
  signal pw_c_wr_in_progress : std_logic;
  signal pw_c_stall : std_logic;
  signal pw_c_oob : std_logic;
  signal pw_c_vram_wr_addr : std_logic_vector (20 downto 0);
  signal pw_c_vram_wr_data : std_logic_vector (15 downto 0);
  signal pw_c_vram_wr : std_logic;
  signal pw_c_vram_wr_access_mode : std_logic;
  signal n1438 : std_logic_vector (61 downto 0);
  signal n1439 : std_logic_vector (31 downto 0);
  signal n1440 : std_logic_vector (14 downto 0);
  signal n1441 : std_logic_vector (14 downto 0);
  signal n1442 : std_logic_vector (15 downto 0);
  signal n1443 : std_logic_vector (15 downto 0);
  signal n1445 : std_logic_vector (7 downto 0);
  signal n1451 : std_logic_vector (1 downto 0);
  signal n1452 : std_logic_vector (7 downto 0);
  signal n1453 : std_logic_vector (7 downto 0);
  signal n1455 : std_logic;
  signal n1456 : std_logic_vector (7 downto 0);
  signal n1457 : std_logic_vector (7 downto 0);
  signal n1459 : std_logic;
  signal n1460 : std_logic_vector (7 downto 0);
  signal n1461 : std_logic_vector (7 downto 0);
  signal n1463 : std_logic;
  signal n1464 : std_logic_vector (2 downto 0);
  signal n1469 : std_logic;
  signal n1477 : std_logic_vector (7 downto 0);
  signal n1482 : std_logic_vector (7 downto 0);
  signal pr_c_color : std_logic_vector (7 downto 0);
  signal pr_c_color_valid : std_logic;
  signal pr_c_vram_rd_addr : std_logic_vector (20 downto 0);
  signal pr_c_vram_rd : std_logic;
  signal pr_c_vram_rd_access_mode : std_logic;
  signal n1488 : std_logic_vector (31 downto 0);
  signal n1489 : std_logic_vector (14 downto 0);
  signal n1490 : std_logic_vector (14 downto 0);
  signal n1491 : std_logic_vector (14 downto 0);
  signal n1492 : std_logic_vector (14 downto 0);
  signal n1493 : std_logic_vector (14 downto 0);
  signal n1494 : std_logic_vector (14 downto 0);
  signal n1500 : std_logic_vector (63 downto 0);
  signal n1501 : std_logic_vector (309 downto 0);
  signal n1502 : std_logic_vector (309 downto 0);
  signal n1504 : std_logic_vector (61 downto 0);
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
  wrap_vram_wr_addr <= n1420;
  wrap_vram_wr_data <= n1422;
  wrap_vram_wr <= n1425;
  wrap_vram_wr_access_mode <= n1427;
  wrap_vram_rd_addr <= n1274;
  wrap_vram_rd <= n1276;
  wrap_vram_rd_access_mode <= n1279;
  wrap_fr_base_addr <= n108;
  wrap_gcf_rd <= n1282;
  wrap_rd_data <= n107;
  wrap_rd_valid <= n1287;
  wrap_frame_sync <= n1290;
  operand_buffer <= n1500; -- (signal)
  state <= n1501; -- (signal)
  state_nxt <= n1502; -- (signal)
  bdt_wr <= n1368; -- (signal)
  bdt_rd <= n1371; -- (signal)
  stall <= pw_c_stall; -- (signal)
  pw_wr <= n1374; -- (signal)
  pw_color <= n1377; -- (signal)
  pw_position <= n1380; -- (signal)
  pw_alpha_mode <= n1385; -- (signal)
  pw_oob <= pw_c_oob; -- (signal)
  pw_vram_wr_addr <= pw_c_vram_wr_addr; -- (signal)
  pw_vram_wr_data <= pw_c_vram_wr_data; -- (signal)
  pw_vram_wr <= pw_c_vram_wr; -- (signal)
  pw_vram_wr_access_mode <= pw_c_vram_wr_access_mode; -- (signal)
  direct_vram_wr <= n1388; -- (signal)
  direct_vram_wr_addr <= n1391; -- (signal)
  direct_vram_wr_data <= n1394; -- (signal)
  direct_vram_wr_access_mode <= n1397; -- (signal)
  pr_start <= n1401; -- (signal)
  pr_color <= pr_c_color; -- (signal)
  pr_color_valid <= pr_c_color_valid; -- (signal)
  pr_color_ack <= n1404; -- (signal)
  pr_vram_rd_addr <= pr_c_vram_rd_addr; -- (signal)
  pr_vram_rd <= pr_c_vram_rd; -- (signal)
  pr_vram_rd_access_mode <= pr_c_vram_rd_access_mode; -- (signal)
  circle_start <= n1407; -- (signal)
  circle_busy <= gfx_circle_inst_c_busy; -- (signal)
  circle_pixel_valid <= gfx_circle_inst_c_pixel_valid; -- (signal)
  circle_pixel <= n1435; -- (signal)
  instr_color <= n115; -- (signal)
  current_instr <= n12; -- (signal)
  bdt_bmpidx <= n1504; -- (signal)
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
  n75 <= operands_buffer_operand_buffer_int when n1282 = '0' else n69;
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
  n400 <= '1' when n379 = "01000" else '0';
  n403 <= '1' when n379 = "11000" else '0';
  n406 <= '1' when n379 = "11010" else '0';
  n409 <= '1' when n379 = "10010" else '0';
  n410 <= state (8);
  n411 <= not n410;
  n412 <= operand_buffer (47 downto 32);
  n413 <= operand_buffer (63 downto 48);
  n415 <= state (205 downto 190);
  n416 <= operand_buffer (47 downto 32);
  n417 <= std_logic_vector (unsigned (n415) + unsigned (n416));
  n419 <= state (221 downto 206);
  n420 <= operand_buffer (63 downto 48);
  n421 <= std_logic_vector (unsigned (n419) + unsigned (n420));
  n422 <= n421 & n417;
  n423 <= n413 & n412;
  n424 <= n422 when n411 = '0' else n423;
  n427 <= '1' when n379 = "00001" else '0';
  n429 <= n427 & n409 & n406 & n403 & n400 & n397 & n394 & n391 & n388 & n385 & n382;
  with n429 select n430 <=
    "000000" when "10000000000",
    "000000" when "01000000000",
    "000101" when "00100000000",
    "000111" when "00010000000",
    "001001" when "00001000000",
    "011000" when "00000100000",
    "010110" when "00000010000",
    "001111" when "00000001000",
    "010000" when "00000000100",
    "001011" when "00000000010",
    "001100" when "00000000001",
    "000000" when others;
  n431 <= state (221 downto 190);
  with n429 select n432 <=
    n424 when "10000000000",
    n431 when "01000000000",
    n431 when "00100000000",
    n431 when "00010000000",
    n431 when "00001000000",
    n431 when "00000100000",
    n431 when "00000010000",
    n431 when "00000001000",
    n431 when "00000000100",
    n431 when "00000000010",
    n431 when "00000000001",
    n431 when others;
  with n429 select n435 <=
    '0' when "10000000000",
    '1' when "01000000000",
    '0' when "00100000000",
    '0' when "00010000000",
    '0' when "00001000000",
    '0' when "00000100000",
    '0' when "00000010000",
    '0' when "00000001000",
    '0' when "00000000100",
    '0' when "00000000010",
    '0' when "00000000001",
    '0' when others;
  n437 <= '1' when n125 = "000011" else '0';
  n439 <= operand_buffer (63 downto 54);
  n440 <= "00000" & n439;  --  uext
  n442 <= operand_buffer (53 downto 48);
  n443 <= "000000000" & n442;  --  uext
  n444 <= bdt_bmpidx (61 downto 47);
  n446 <= '1' when n125 = "000101" else '0';
  n448 <= operand_buffer (15 downto 0);
  n449 <= n448 (14 downto 0);  --  trunc
  n450 <= operand_buffer (31 downto 16);
  n451 <= n450 (14 downto 0);  --  trunc
  n452 <= operand_buffer (47 downto 32);
  n453 <= n452 (14 downto 0);  --  trunc
  n454 <= operand_buffer (63 downto 48);
  n455 <= n454 (14 downto 0);  --  trunc
  n457 <= '1' when n125 = "000111" else '0';
  n461 <= bdt_bmpidx (46 downto 32);
  n462 <= bdt_bmpidx (61 downto 47);
  n464 <= '1' when n125 = "000110" else '0';
  n467 <= '1' when n125 = "001000" else '0';
  n469 <= state (221 downto 190);
  n474 <= not stall;
  n478 <= '0' when n474 = '0' else '1';
  n481 <= '1' when n474 = '0' else '0';
  n487 <= 'X' when n474 = '0' else '1';
  n493 <= n487 when n481 = '0' else '0';
  n495 <= current_instr (4);
  n497 <= state (205 downto 190);
  n499 <= std_logic_vector (unsigned (n497) + unsigned'("0000000000000001"));
  n500 <= state (205 downto 190);
  n501 <= n500 when n495 = '0' else n499;
  n502 <= current_instr (5);
  n504 <= state (221 downto 206);
  n506 <= std_logic_vector (unsigned (n504) + unsigned'("0000000000000001"));
  n507 <= state (221 downto 206);
  n508 <= n507 when n502 = '0' else n506;
  n509 <= n508 & n501;
  n510 <= state (5 downto 0);
  n511 <= n510 when n493 = '0' else "000000";
  n512 <= state (221 downto 190);
  n513 <= n512 when n493 = '0' else n509;
  n515 <= '1' when n125 = "000100" else '0';
  n516 <= current_instr (10);
  n517 <= bdt_bmpidx (31 downto 0);
  n518 <= n517 (20 downto 0);  --  trunc
  n522 <= '0' when wrap_fr_base_addr_req = '0' else '1';
  n523 <= state (5 downto 0);
  n524 <= n523 when wrap_fr_base_addr_req = '0' else "000000";
  n525 <= state (104 downto 84);
  n526 <= n525 when wrap_fr_base_addr_req = '0' else n518;
  n527 <= bdt_bmpidx (31 downto 0);
  n528 <= n527 (20 downto 0);  --  trunc
  n531 <= '0' when n516 = '0' else n522;
  n532 <= "000000" when n516 = '0' else n524;
  n533 <= n528 when n516 = '0' else n526;
  n535 <= '1' when n125 = "010011" else '0';
  n539 <= '1' when n125 = "010100" else '0';
  n541 <= state (189 downto 158);
  n546 <= not stall;
  n550 <= '0' when n546 = '0' else '1';
  n553 <= '1' when n546 = '0' else '0';
  n559 <= 'X' when n546 = '0' else '1';
  n565 <= n559 when n553 = '0' else '0';
  n567 <= state (173 downto 158);
  n569 <= state (284 downto 270);
  n571 <= std_logic_vector (unsigned (n569) - unsigned'("000000000000001"));
  n572 <= "0" & n571;  --  uext
  n573 <= '1' when n567 = n572 else '0';
  n576 <= state (189 downto 174);
  n578 <= state (299 downto 285);
  n580 <= std_logic_vector (unsigned (n578) - unsigned'("000000000000001"));
  n581 <= "0" & n580;  --  uext
  n582 <= '1' when n576 = n581 else '0';
  n585 <= state (189 downto 174);
  n587 <= std_logic_vector (unsigned (n585) + unsigned'("0000000000000001"));
  n588 <= state (5 downto 0);
  n589 <= n588 when n606 = '0' else "000000";
  n590 <= state (189 downto 174);
  n591 <= n587 when n582 = '0' else n590;
  n593 <= state (173 downto 158);
  n595 <= std_logic_vector (unsigned (n593) + unsigned'("0000000000000001"));
  n596 <= n591 & "0000000000000000";
  n598 <= n582 and n573;
  n599 <= n596 (15 downto 0);
  n600 <= n595 when n573 = '0' else n599;
  n601 <= n596 (31 downto 16);
  n602 <= state (189 downto 174);
  n603 <= n602 when n573 = '0' else n601;
  n604 <= n603 & n600;
  n606 <= n598 and n565;
  n607 <= state (189 downto 158);
  n608 <= n607 when n565 = '0' else n604;
  n610 <= '1' when n125 = "010101" else '0';
  n612 <= state (205 downto 190);
  n615 <= '1' when n125 = "010110" else '0';
  n617 <= state (173 downto 158);
  n619 <= state (205 downto 190);
  n620 <= std_logic_vector (unsigned (n619) + unsigned (dx));
  n621 <= '1' when n617 = n620 else '0';
  n623 <= current_instr (4);
  n625 <= state (205 downto 190);
  n626 <= std_logic_vector (unsigned (n625) + unsigned (dx));
  n627 <= state (205 downto 190);
  n628 <= n627 when n623 = '0' else n626;
  n629 <= current_instr (5);
  n631 <= state (221 downto 206);
  n633 <= std_logic_vector (unsigned (n631) + unsigned'("0000000000000001"));
  n634 <= state (221 downto 206);
  n635 <= n634 when n629 = '0' else n633;
  n638 <= state (173 downto 158);
  n640 <= state (221 downto 206);
  n645 <= not stall;
  n649 <= '0' when n645 = '0' else '1';
  n652 <= '1' when n645 = '0' else '0';
  n658 <= 'X' when n645 = '0' else '1';
  n664 <= n658 when n652 = '0' else '0';
  n666 <= '1' when signed (dx) < signed'("0000000000000000") else '0';
  n668 <= state (173 downto 158);
  n670 <= std_logic_vector (unsigned (n668) - unsigned'("0000000000000001"));
  n672 <= state (173 downto 158);
  n674 <= std_logic_vector (unsigned (n672) + unsigned'("0000000000000001"));
  n675 <= n674 when n666 = '0' else n670;
  n676 <= state (173 downto 158);
  n677 <= n676 when n664 = '0' else n675;
  n678 <= n635 & n628;
  n679 <= state (5 downto 0);
  n680 <= n679 when n621 = '0' else "000000";
  n681 <= state (173 downto 158);
  n682 <= n677 when n621 = '0' else n681;
  n683 <= state (221 downto 190);
  n684 <= n683 when n621 = '0' else n678;
  n686 <= n649 when n621 = '0' else '0';
  n688 <= instr_color when n621 = '0' else "00000000";
  n689 <= n640 & n638;
  n691 <= n689 when n621 = '0' else "00000000000000000000000000000000";
  n693 <= '1' when n125 = "010111" else '0';
  n695 <= state (221 downto 206);
  n698 <= '1' when n125 = "011000" else '0';
  n700 <= state (189 downto 174);
  n702 <= state (221 downto 206);
  n703 <= std_logic_vector (unsigned (n702) + unsigned (dy));
  n704 <= '1' when n700 = n703 else '0';
  n706 <= current_instr (4);
  n708 <= state (205 downto 190);
  n710 <= std_logic_vector (unsigned (n708) + unsigned'("0000000000000001"));
  n711 <= state (205 downto 190);
  n712 <= n711 when n706 = '0' else n710;
  n713 <= current_instr (5);
  n715 <= state (221 downto 206);
  n716 <= std_logic_vector (unsigned (n715) + unsigned (dy));
  n717 <= state (221 downto 206);
  n718 <= n717 when n713 = '0' else n716;
  n721 <= state (205 downto 190);
  n723 <= state (189 downto 174);
  n728 <= not stall;
  n732 <= '0' when n728 = '0' else '1';
  n735 <= '1' when n728 = '0' else '0';
  n741 <= 'X' when n728 = '0' else '1';
  n747 <= n741 when n735 = '0' else '0';
  n749 <= '1' when signed (dy) < signed'("0000000000000000") else '0';
  n751 <= state (189 downto 174);
  n753 <= std_logic_vector (unsigned (n751) - unsigned'("0000000000000001"));
  n755 <= state (189 downto 174);
  n757 <= std_logic_vector (unsigned (n755) + unsigned'("0000000000000001"));
  n758 <= n757 when n749 = '0' else n753;
  n759 <= state (189 downto 174);
  n760 <= n759 when n747 = '0' else n758;
  n761 <= n718 & n712;
  n762 <= state (5 downto 0);
  n763 <= n762 when n704 = '0' else "000000";
  n764 <= state (189 downto 174);
  n765 <= n760 when n704 = '0' else n764;
  n766 <= state (221 downto 190);
  n767 <= n766 when n704 = '0' else n761;
  n769 <= n732 when n704 = '0' else '0';
  n771 <= instr_color when n704 = '0' else "00000000";
  n772 <= n723 & n721;
  n774 <= n772 when n704 = '0' else "00000000000000000000000000000000";
  n776 <= '1' when n125 = "011001" else '0';
  n777 <= not stall;
  n779 <= state (5 downto 0);
  n780 <= n779 when n777 = '0' else "001010";
  n783 <= '0' when n777 = '0' else '1';
  n785 <= '1' when n125 = "001001" else '0';
  n791 <= not stall;
  n795 <= '0' when n791 = '0' else '1';
  n812 <= '0' when circle_pixel_valid = '0' else n795;
  n814 <= "00000000" when circle_pixel_valid = '0' else instr_color;
  n816 <= "00000000000000000000000000000000" when circle_pixel_valid = '0' else circle_pixel;
  n817 <= not circle_busy;
  n818 <= current_instr (4);
  n820 <= state (205 downto 190);
  n822 <= '0' & radius;
  n823 <= std_logic_vector (unsigned (n820) + unsigned (n822));
  n824 <= state (205 downto 190);
  n825 <= n824 when n818 = '0' else n823;
  n826 <= current_instr (5);
  n828 <= state (221 downto 206);
  n830 <= '0' & radius;
  n831 <= std_logic_vector (unsigned (n828) + unsigned (n830));
  n832 <= state (221 downto 206);
  n833 <= n832 when n826 = '0' else n831;
  n835 <= n833 & n825;
  n836 <= state (5 downto 0);
  n837 <= n836 when n817 = '0' else "000000";
  n838 <= state (221 downto 190);
  n839 <= n838 when n817 = '0' else n835;
  n841 <= '1' when n125 = "001010" else '0';
  n849 <= '1' when n125 = "011111" else '0';
  n863 <= current_instr (9 downto 8);
  n866 <= state (173 downto 158);
  n869 <= state (189 downto 174);
  n872 <= '1' when n863 = "10" else '0';
  n874 <= '1' when n863 = "11" else '0';
  n875 <= n872 or n874;
  n876 <= bb_section (44 downto 30);
  n878 <= '0' & n876;
  n880 <= state (173 downto 158);
  n881 <= std_logic_vector (unsigned (n878) - unsigned (n880));
  n883 <= std_logic_vector (unsigned (n881) - unsigned'("0000000000000001"));
  n884 <= n866 when n875 = '0' else n883;
  n886 <= '1' when n863 = "01" else '0';
  n888 <= '1' when n863 = "10" else '0';
  n889 <= n886 or n888;
  n890 <= bb_section (59 downto 45);
  n892 <= '0' & n890;
  n894 <= state (189 downto 174);
  n895 <= std_logic_vector (unsigned (n892) - unsigned (n894));
  n897 <= std_logic_vector (unsigned (n895) - unsigned'("0000000000000001"));
  n898 <= n869 when n889 = '0' else n897;
  n900 <= '1' when n863 = "01" else '0';
  n902 <= '1' when n863 = "11" else '0';
  n903 <= n900 or n902;
  n905 <= state (205 downto 190);
  n906 <= std_logic_vector (unsigned (n905) + unsigned (n898));
  n908 <= state (221 downto 206);
  n909 <= std_logic_vector (unsigned (n908) + unsigned (n884));
  n911 <= state (205 downto 190);
  n912 <= std_logic_vector (unsigned (n911) + unsigned (n884));
  n914 <= state (221 downto 206);
  n915 <= std_logic_vector (unsigned (n914) + unsigned (n898));
  n916 <= n912 when n903 = '0' else n906;
  n918 <= n915 when n903 = '0' else n909;
  n927 <= state (309 downto 308);
  n928 <= state (307 downto 300);
  n929 <= pr_color and n928;
  n931 <= '1' when n927 = "01" else '0';
  n932 <= state (307 downto 300);
  n933 <= pr_color or n932;
  n935 <= '1' when n927 = "10" else '0';
  n936 <= state (307 downto 300);
  n937 <= pr_color xor n936;
  n939 <= '1' when n927 = "11" else '0';
  n940 <= n939 & n935 & n931;
  with n940 select n945 <=
    '0' when "100",
    '0' when "010",
    '0' when "001",
    '1' when others;
  with n940 select n953 <=
    n937 when "100",
    n933 when "010",
    n929 when "001",
    "XXXXXXXX" when others;
  n958 <= n953 when n945 = '0' else pr_color;
  n959 <= current_instr (10);
  n964 <= not stall;
  n968 <= '0' when n964 = '0' else '1';
  n971 <= '1' when n964 = '0' else '0';
  n977 <= 'X' when n964 = '0' else '1';
  n983 <= n977 when n971 = '0' else '0';
  n985 <= state (173 downto 158);
  n986 <= bb_section (44 downto 30);
  n988 <= std_logic_vector (unsigned (n986) - unsigned'("000000000000001"));
  n989 <= "0" & n988;  --  uext
  n990 <= '1' when n985 = n989 else '0';
  n993 <= state (189 downto 174);
  n994 <= bb_section (59 downto 45);
  n996 <= std_logic_vector (unsigned (n994) - unsigned'("000000000000001"));
  n997 <= "0" & n996;  --  uext
  n998 <= '1' when n993 = n997 else '0';
  n1001 <= state (189 downto 174);
  n1003 <= std_logic_vector (unsigned (n1001) + unsigned'("0000000000000001"));
  n1004 <= state (5 downto 0);
  n1005 <= n1004 when n1029 = '0' else "100001";
  n1006 <= state (189 downto 174);
  n1007 <= n1003 when n998 = '0' else n1006;
  n1009 <= state (173 downto 158);
  n1011 <= std_logic_vector (unsigned (n1009) + unsigned'("0000000000000001"));
  n1012 <= n1007 & "0000000000000000";
  n1014 <= n998 and n990;
  n1015 <= n1012 (15 downto 0);
  n1016 <= n1011 when n990 = '0' else n1015;
  n1017 <= n1012 (31 downto 16);
  n1018 <= state (189 downto 174);
  n1019 <= n1018 when n990 = '0' else n1017;
  n1020 <= n1019 & n1016;
  n1022 <= n1014 and n983;
  n1023 <= state (189 downto 158);
  n1024 <= n1023 when n1031 = '0' else n1020;
  n1027 <= '0' when n983 = '0' else '1';
  n1029 <= n1022 and pr_color_valid;
  n1031 <= n983 and pr_color_valid;
  n1033 <= '0' when pr_color_valid = '0' else n968;
  n1035 <= "00000000" when pr_color_valid = '0' else n958;
  n1036 <= n918 & n916;
  n1038 <= "00000000000000000000000000000000" when pr_color_valid = '0' else n1036;
  n1040 <= '0' when pr_color_valid = '0' else n959;
  n1042 <= '0' when pr_color_valid = '0' else n1027;
  n1044 <= '1' when n125 = "100000" else '0';
  n1054 <= current_instr (9 downto 8);
  n1056 <= current_instr (4);
  n1058 <= '1' when n1054 = "01" else '0';
  n1060 <= '1' when n1054 = "11" else '0';
  n1061 <= n1058 or n1060;
  n1063 <= state (205 downto 190);
  n1064 <= bb_section (59 downto 45);
  n1066 <= '0' & n1064;
  n1067 <= std_logic_vector (unsigned (n1063) + unsigned (n1066));
  n1069 <= state (205 downto 190);
  n1070 <= bb_section (44 downto 30);
  n1072 <= '0' & n1070;
  n1073 <= std_logic_vector (unsigned (n1069) + unsigned (n1072));
  n1074 <= n1073 when n1061 = '0' else n1067;
  n1075 <= state (205 downto 190);
  n1076 <= n1075 when n1056 = '0' else n1074;
  n1077 <= current_instr (5);
  n1079 <= '1' when n1054 = "01" else '0';
  n1081 <= '1' when n1054 = "11" else '0';
  n1082 <= n1079 or n1081;
  n1084 <= state (221 downto 206);
  n1085 <= bb_section (44 downto 30);
  n1087 <= '0' & n1085;
  n1088 <= std_logic_vector (unsigned (n1084) + unsigned (n1087));
  n1090 <= state (221 downto 206);
  n1091 <= bb_section (59 downto 45);
  n1093 <= '0' & n1091;
  n1094 <= std_logic_vector (unsigned (n1090) + unsigned (n1093));
  n1095 <= n1094 when n1082 = '0' else n1088;
  n1096 <= state (221 downto 206);
  n1097 <= n1096 when n1077 = '0' else n1095;
  n1100 <= '1' when n125 = "100001" else '0';
  n1101 <= not wrap_vram_wr_full;
  n1102 <= addrhi & addrlo;
  n1103 <= current_instr (0);
  n1106 <= '0' when n1103 = '0' else '1';
  n1109 <= state (5 downto 0);
  n1110 <= n1109 when n1101 = '0' else "000000";
  n1113 <= '0' when n1101 = '0' else '1';
  n1115 <= "000000000000000000000" when n1101 = '0' else n1102;
  n1117 <= "0000000000000000" when n1101 = '0' else data;
  n1119 <= '1' when n1101 = '0' else n1106;
  n1121 <= '1' when n125 = "001011" else '0';
  n1122 <= addrhi & addrlo;
  n1125 <= '1' when n125 = "010000" else '0';
  n1126 <= addrhi & addrlo;
  n1129 <= '1' when n125 = "001111" else '0';
  n1130 <= not wrap_gcf_empty;
  n1136 <= current_instr (15 downto 11);
  n1138 <= '1' when n1136 = "01111" else '0';
  n1139 <= n1130 or n1138;
  n1145 <= current_instr (15 downto 11);
  n1147 <= '1' when n1145 = "01110" else '0';
  n1150 <= '0' when n1147 = '0' else '1';
  n1151 <= state (157 downto 142);
  n1153 <= std_logic_vector (unsigned (n1151) - unsigned'("0000000000000001"));
  n1156 <= '0' when n1139 = '0' else n1150;
  n1157 <= state (5 downto 0);
  n1158 <= n1157 when n1139 = '0' else "010010";
  n1159 <= state (157 downto 142);
  n1160 <= n1159 when n1139 = '0' else n1153;
  n1162 <= '1' when n125 = "010001" else '0';
  n1163 <= state (141 downto 121);
  n1169 <= current_instr (15 downto 11);
  n1171 <= '1' when n1169 = "01110" else '0';
  n1172 <= data when n1171 = '0' else wrap_gcf_data;
  n1173 <= not wrap_vram_wr_full;
  n1174 <= current_instr (0);
  n1175 <= state (141 downto 121);
  n1177 <= std_logic_vector (unsigned (n1175) + unsigned'("000000000000000000010"));
  n1178 <= state (141 downto 121);
  n1180 <= std_logic_vector (unsigned (n1178) + unsigned'("000000000000000000001"));
  n1181 <= n1180 when n1174 = '0' else n1177;
  n1184 <= '0' when n1174 = '0' else '1';
  n1185 <= state (157 downto 142);
  n1187 <= '1' when n1185 = "0000000000000000" else '0';
  n1190 <= "010001" when n1187 = '0' else "000000";
  n1191 <= state (5 downto 0);
  n1192 <= n1191 when n1173 = '0' else n1190;
  n1193 <= state (141 downto 121);
  n1194 <= n1193 when n1173 = '0' else n1181;
  n1197 <= '0' when n1173 = '0' else '1';
  n1199 <= '1' when n1173 = '0' else n1184;
  n1201 <= '1' when n125 = "010010" else '0';
  n1203 <= addrhi & addrlo;
  n1204 <= current_instr (0);
  n1207 <= '0' when n1204 = '0' else '1';
  n1210 <= '0' when wrap_vram_wr_emtpy = '0' else '1';
  n1212 <= '1' when n125 = "001100" else '0';
  n1214 <= state (5 downto 0);
  n1215 <= n1214 when wrap_vram_rd_valid = '0' else "001110";
  n1216 <= state (120 downto 105);
  n1217 <= n1216 when wrap_vram_rd_valid = '0' else wrap_vram_rd_data;
  n1219 <= '1' when n125 = "001101" else '0';
  n1222 <= '1' when n125 = "001110" else '0';
  n1224 <= state (221 downto 190);
  n1226 <= '1' when n125 = "011010" else '0';
  n1228 <= state (221 downto 190);
  n1230 <= '1' when n125 = "011011" else '0';
  n1231 <= state (221 downto 190);
  n1232 <= not pw_oob;
  n1236 <= '0' when wrap_vram_wr_emtpy = '0' else '1';
  n1237 <= state (5 downto 0);
  n1238 <= n1237 when wrap_vram_wr_emtpy = '0' else "011101";
  n1242 <= '0' when n1232 = '0' else n1236;
  n1243 <= "011110" when n1232 = '0' else n1238;
  n1244 <= state (120 downto 105);
  n1245 <= "1111111111111111" when n1232 = '0' else n1244;
  n1247 <= '1' when n125 = "011100" else '0';
  n1248 <= state (221 downto 190);
  n1250 <= state (5 downto 0);
  n1251 <= n1250 when wrap_vram_rd_valid = '0' else "011110";
  n1252 <= state (120 downto 105);
  n1253 <= n1252 when wrap_vram_rd_valid = '0' else wrap_vram_rd_data;
  n1255 <= '1' when n125 = "011101" else '0';
  n1257 <= current_instr (4);
  n1259 <= state (205 downto 190);
  n1261 <= std_logic_vector (unsigned (n1259) + unsigned'("0000000000000001"));
  n1262 <= state (205 downto 190);
  n1263 <= n1262 when n1257 = '0' else n1261;
  n1264 <= current_instr (5);
  n1266 <= state (221 downto 206);
  n1268 <= std_logic_vector (unsigned (n1266) + unsigned'("0000000000000001"));
  n1269 <= state (221 downto 206);
  n1270 <= n1269 when n1264 = '0' else n1268;
  n1272 <= '1' when n125 = "011110" else '0';
  n1273 <= n1272 & n1255 & n1247 & n1230 & n1226 & n1222 & n1219 & n1212 & n1201 & n1162 & n1129 & n1125 & n1121 & n1100 & n1044 & n849 & n841 & n785 & n776 & n698 & n693 & n615 & n610 & n539 & n535 & n515 & n467 & n464 & n457 & n446 & n437 & n372 & n351 & n134;
  with n1273 select n1274 <=
    pw_vram_wr_addr when "1000000000000000000000000000000000",
    pw_vram_wr_addr when "0100000000000000000000000000000000",
    pw_vram_wr_addr when "0010000000000000000000000000000000",
    pw_vram_wr_addr when "0001000000000000000000000000000000",
    pw_vram_wr_addr when "0000100000000000000000000000000000",
    pw_vram_wr_addr when "0000010000000000000000000000000000",
    pw_vram_wr_addr when "0000001000000000000000000000000000",
    n1203 when "0000000100000000000000000000000000",
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
  with n1273 select n1276 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    n1242 when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    n1210 when "0000000100000000000000000000000000",
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
  with n1273 select n1279 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    n1207 when "0000000100000000000000000000000000",
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
  with n1273 select n1282 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    n1156 when "0000000001000000000000000000000000",
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
  with n1273 select n1287 <=
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
  with n1273 select n1290 <=
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
    n531 when "0000000000000000000000001000000000",
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
  n1292 <= state (5 downto 0);
  with n1273 select n1293 <=
    "000000" when "1000000000000000000000000000000000",
    n1251 when "0100000000000000000000000000000000",
    n1243 when "0010000000000000000000000000000000",
    "011100" when "0001000000000000000000000000000000",
    "011011" when "0000100000000000000000000000000000",
    "000000" when "0000010000000000000000000000000000",
    n1215 when "0000001000000000000000000000000000",
    "001101" when "0000000100000000000000000000000000",
    n1192 when "0000000010000000000000000000000000",
    n1158 when "0000000001000000000000000000000000",
    "010001" when "0000000000100000000000000000000000",
    "010001" when "0000000000010000000000000000000000",
    n1110 when "0000000000001000000000000000000000",
    "000000" when "0000000000000100000000000000000000",
    n1005 when "0000000000000010000000000000000000",
    "100000" when "0000000000000001000000000000000000",
    n837 when "0000000000000000100000000000000000",
    n780 when "0000000000000000010000000000000000",
    n763 when "0000000000000000001000000000000000",
    "011001" when "0000000000000000000100000000000000",
    n680 when "0000000000000000000010000000000000",
    "010111" when "0000000000000000000001000000000000",
    n589 when "0000000000000000000000100000000000",
    "010101" when "0000000000000000000000010000000000",
    n532 when "0000000000000000000000001000000000",
    n511 when "0000000000000000000000000100000000",
    "000000" when "0000000000000000000000000010000000",
    "011111" when "0000000000000000000000000001000000",
    "011111" when "0000000000000000000000000000100000",
    "011111" when "0000000000000000000000000000010000",
    n430 when "0000000000000000000000000000001000",
    n368 when "0000000000000000000000000000000100",
    n313 when "0000000000000000000000000000000010",
    n132 when "0000000000000000000000000000000001",
    n1292 when others;
  n1294 <= state (21 downto 6);
  with n1273 select n1295 <=
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
    n1294 when "0000000000000000000000001000000000",
    n1294 when "0000000000000000000000000100000000",
    n1294 when "0000000000000000000000000010000000",
    n1294 when "0000000000000000000000000001000000",
    n1294 when "0000000000000000000000000000100000",
    n1294 when "0000000000000000000000000000010000",
    n1294 when "0000000000000000000000000000001000",
    n1294 when "0000000000000000000000000000000100",
    wrap_gcf_data when "0000000000000000000000000000000010",
    n1294 when "0000000000000000000000000000000001",
    n1294 when others;
  n1296 <= state (23 downto 22);
  with n1273 select n1297 <=
    n1296 when "1000000000000000000000000000000000",
    n1296 when "0100000000000000000000000000000000",
    n1296 when "0010000000000000000000000000000000",
    n1296 when "0001000000000000000000000000000000",
    n1296 when "0000100000000000000000000000000000",
    n1296 when "0000010000000000000000000000000000",
    n1296 when "0000001000000000000000000000000000",
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
    n370 when "0000000000000000000000000000000100",
    n314 when "0000000000000000000000000000000010",
    n1296 when "0000000000000000000000000000000001",
    n1296 when others;
  n1298 <= state (38 downto 24);
  with n1273 select n1299 <=
    n1298 when "1000000000000000000000000000000000",
    n1298 when "0100000000000000000000000000000000",
    n1298 when "0010000000000000000000000000000000",
    n1298 when "0001000000000000000000000000000000",
    n1298 when "0000100000000000000000000000000000",
    n1298 when "0000010000000000000000000000000000",
    n1298 when "0000001000000000000000000000000000",
    n1298 when "0000000100000000000000000000000000",
    n1298 when "0000000010000000000000000000000000",
    n1298 when "0000000001000000000000000000000000",
    n1298 when "0000000000100000000000000000000000",
    n1298 when "0000000000010000000000000000000000",
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
    "000000000000000" when "0000000000000000000000000001000000",
    n449 when "0000000000000000000000000000100000",
    n440 when "0000000000000000000000000000010000",
    n1298 when "0000000000000000000000000000001000",
    n1298 when "0000000000000000000000000000000100",
    n1298 when "0000000000000000000000000000000010",
    n1298 when "0000000000000000000000000000000001",
    n1298 when others;
  n1300 <= state (53 downto 39);
  with n1273 select n1301 <=
    n1300 when "1000000000000000000000000000000000",
    n1300 when "0100000000000000000000000000000000",
    n1300 when "0010000000000000000000000000000000",
    n1300 when "0001000000000000000000000000000000",
    n1300 when "0000100000000000000000000000000000",
    n1300 when "0000010000000000000000000000000000",
    n1300 when "0000001000000000000000000000000000",
    n1300 when "0000000100000000000000000000000000",
    n1300 when "0000000010000000000000000000000000",
    n1300 when "0000000001000000000000000000000000",
    n1300 when "0000000000100000000000000000000000",
    n1300 when "0000000000010000000000000000000000",
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
    "000000000000000" when "0000000000000000000000000001000000",
    n451 when "0000000000000000000000000000100000",
    "000000000000000" when "0000000000000000000000000000010000",
    n1300 when "0000000000000000000000000000001000",
    n1300 when "0000000000000000000000000000000100",
    n1300 when "0000000000000000000000000000000010",
    n1300 when "0000000000000000000000000000000001",
    n1300 when others;
  n1302 <= state (68 downto 54);
  with n1273 select n1303 <=
    n1302 when "1000000000000000000000000000000000",
    n1302 when "0100000000000000000000000000000000",
    n1302 when "0010000000000000000000000000000000",
    n1302 when "0001000000000000000000000000000000",
    n1302 when "0000100000000000000000000000000000",
    n1302 when "0000010000000000000000000000000000",
    n1302 when "0000001000000000000000000000000000",
    n1302 when "0000000100000000000000000000000000",
    n1302 when "0000000010000000000000000000000000",
    n1302 when "0000000001000000000000000000000000",
    n1302 when "0000000000100000000000000000000000",
    n1302 when "0000000000010000000000000000000000",
    n1302 when "0000000000001000000000000000000000",
    n1302 when "0000000000000100000000000000000000",
    n1302 when "0000000000000010000000000000000000",
    n1302 when "0000000000000001000000000000000000",
    n1302 when "0000000000000000100000000000000000",
    n1302 when "0000000000000000010000000000000000",
    n1302 when "0000000000000000001000000000000000",
    n1302 when "0000000000000000000100000000000000",
    n1302 when "0000000000000000000010000000000000",
    n1302 when "0000000000000000000001000000000000",
    n1302 when "0000000000000000000000100000000000",
    n1302 when "0000000000000000000000010000000000",
    n1302 when "0000000000000000000000001000000000",
    n1302 when "0000000000000000000000000100000000",
    n1302 when "0000000000000000000000000010000000",
    n461 when "0000000000000000000000000001000000",
    n453 when "0000000000000000000000000000100000",
    n443 when "0000000000000000000000000000010000",
    n1302 when "0000000000000000000000000000001000",
    n1302 when "0000000000000000000000000000000100",
    n1302 when "0000000000000000000000000000000010",
    n1302 when "0000000000000000000000000000000001",
    n1302 when others;
  n1304 <= state (83 downto 69);
  with n1273 select n1305 <=
    n1304 when "1000000000000000000000000000000000",
    n1304 when "0100000000000000000000000000000000",
    n1304 when "0010000000000000000000000000000000",
    n1304 when "0001000000000000000000000000000000",
    n1304 when "0000100000000000000000000000000000",
    n1304 when "0000010000000000000000000000000000",
    n1304 when "0000001000000000000000000000000000",
    n1304 when "0000000100000000000000000000000000",
    n1304 when "0000000010000000000000000000000000",
    n1304 when "0000000001000000000000000000000000",
    n1304 when "0000000000100000000000000000000000",
    n1304 when "0000000000010000000000000000000000",
    n1304 when "0000000000001000000000000000000000",
    n1304 when "0000000000000100000000000000000000",
    n1304 when "0000000000000010000000000000000000",
    n1304 when "0000000000000001000000000000000000",
    n1304 when "0000000000000000100000000000000000",
    n1304 when "0000000000000000010000000000000000",
    n1304 when "0000000000000000001000000000000000",
    n1304 when "0000000000000000000100000000000000",
    n1304 when "0000000000000000000010000000000000",
    n1304 when "0000000000000000000001000000000000",
    n1304 when "0000000000000000000000100000000000",
    n1304 when "0000000000000000000000010000000000",
    n1304 when "0000000000000000000000001000000000",
    n1304 when "0000000000000000000000000100000000",
    n1304 when "0000000000000000000000000010000000",
    n462 when "0000000000000000000000000001000000",
    n455 when "0000000000000000000000000000100000",
    n444 when "0000000000000000000000000000010000",
    n1304 when "0000000000000000000000000000001000",
    n1304 when "0000000000000000000000000000000100",
    n1304 when "0000000000000000000000000000000010",
    n1304 when "0000000000000000000000000000000001",
    n1304 when others;
  n1306 <= state (104 downto 84);
  with n1273 select n1307 <=
    n1306 when "1000000000000000000000000000000000",
    n1306 when "0100000000000000000000000000000000",
    n1306 when "0010000000000000000000000000000000",
    n1306 when "0001000000000000000000000000000000",
    n1306 when "0000100000000000000000000000000000",
    n1306 when "0000010000000000000000000000000000",
    n1306 when "0000001000000000000000000000000000",
    n1306 when "0000000100000000000000000000000000",
    n1306 when "0000000010000000000000000000000000",
    n1306 when "0000000001000000000000000000000000",
    n1306 when "0000000000100000000000000000000000",
    n1306 when "0000000000010000000000000000000000",
    n1306 when "0000000000001000000000000000000000",
    n1306 when "0000000000000100000000000000000000",
    n1306 when "0000000000000010000000000000000000",
    n1306 when "0000000000000001000000000000000000",
    n1306 when "0000000000000000100000000000000000",
    n1306 when "0000000000000000010000000000000000",
    n1306 when "0000000000000000001000000000000000",
    n1306 when "0000000000000000000100000000000000",
    n1306 when "0000000000000000000010000000000000",
    n1306 when "0000000000000000000001000000000000",
    n1306 when "0000000000000000000000100000000000",
    n1306 when "0000000000000000000000010000000000",
    n533 when "0000000000000000000000001000000000",
    n1306 when "0000000000000000000000000100000000",
    n1306 when "0000000000000000000000000010000000",
    n1306 when "0000000000000000000000000001000000",
    n1306 when "0000000000000000000000000000100000",
    n1306 when "0000000000000000000000000000010000",
    n1306 when "0000000000000000000000000000001000",
    n1306 when "0000000000000000000000000000000100",
    n1306 when "0000000000000000000000000000000010",
    n1306 when "0000000000000000000000000000000001",
    n1306 when others;
  n1308 <= state (120 downto 105);
  with n1273 select n1309 <=
    n1308 when "1000000000000000000000000000000000",
    n1253 when "0100000000000000000000000000000000",
    n1245 when "0010000000000000000000000000000000",
    n1308 when "0001000000000000000000000000000000",
    n1308 when "0000100000000000000000000000000000",
    n1308 when "0000010000000000000000000000000000",
    n1217 when "0000001000000000000000000000000000",
    n1308 when "0000000100000000000000000000000000",
    n1308 when "0000000010000000000000000000000000",
    n1308 when "0000000001000000000000000000000000",
    n1308 when "0000000000100000000000000000000000",
    n1308 when "0000000000010000000000000000000000",
    n1308 when "0000000000001000000000000000000000",
    n1308 when "0000000000000100000000000000000000",
    n1308 when "0000000000000010000000000000000000",
    n1308 when "0000000000000001000000000000000000",
    n1308 when "0000000000000000100000000000000000",
    n1308 when "0000000000000000010000000000000000",
    n1308 when "0000000000000000001000000000000000",
    n1308 when "0000000000000000000100000000000000",
    n1308 when "0000000000000000000010000000000000",
    n1308 when "0000000000000000000001000000000000",
    n1308 when "0000000000000000000000100000000000",
    n1308 when "0000000000000000000000010000000000",
    n1308 when "0000000000000000000000001000000000",
    n1308 when "0000000000000000000000000100000000",
    n1308 when "0000000000000000000000000010000000",
    n1308 when "0000000000000000000000000001000000",
    n1308 when "0000000000000000000000000000100000",
    n1308 when "0000000000000000000000000000010000",
    n1308 when "0000000000000000000000000000001000",
    n1308 when "0000000000000000000000000000000100",
    n1308 when "0000000000000000000000000000000010",
    n1308 when "0000000000000000000000000000000001",
    n1308 when others;
  n1310 <= state (141 downto 121);
  with n1273 select n1311 <=
    n1310 when "1000000000000000000000000000000000",
    n1310 when "0100000000000000000000000000000000",
    n1310 when "0010000000000000000000000000000000",
    n1310 when "0001000000000000000000000000000000",
    n1310 when "0000100000000000000000000000000000",
    n1310 when "0000010000000000000000000000000000",
    n1310 when "0000001000000000000000000000000000",
    n1310 when "0000000100000000000000000000000000",
    n1194 when "0000000010000000000000000000000000",
    n1310 when "0000000001000000000000000000000000",
    n1126 when "0000000000100000000000000000000000",
    n1122 when "0000000000010000000000000000000000",
    n1310 when "0000000000001000000000000000000000",
    n1310 when "0000000000000100000000000000000000",
    n1310 when "0000000000000010000000000000000000",
    n1310 when "0000000000000001000000000000000000",
    n1310 when "0000000000000000100000000000000000",
    n1310 when "0000000000000000010000000000000000",
    n1310 when "0000000000000000001000000000000000",
    n1310 when "0000000000000000000100000000000000",
    n1310 when "0000000000000000000010000000000000",
    n1310 when "0000000000000000000001000000000000",
    n1310 when "0000000000000000000000100000000000",
    n1310 when "0000000000000000000000010000000000",
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
  n1312 <= state (157 downto 142);
  with n1273 select n1313 <=
    n1312 when "1000000000000000000000000000000000",
    n1312 when "0100000000000000000000000000000000",
    n1312 when "0010000000000000000000000000000000",
    n1312 when "0001000000000000000000000000000000",
    n1312 when "0000100000000000000000000000000000",
    n1312 when "0000010000000000000000000000000000",
    n1312 when "0000001000000000000000000000000000",
    n1312 when "0000000100000000000000000000000000",
    n1312 when "0000000010000000000000000000000000",
    n1160 when "0000000001000000000000000000000000",
    n when "0000000000100000000000000000000000",
    n when "0000000000010000000000000000000000",
    n1312 when "0000000000001000000000000000000000",
    n1312 when "0000000000000100000000000000000000",
    n1312 when "0000000000000010000000000000000000",
    n1312 when "0000000000000001000000000000000000",
    n1312 when "0000000000000000100000000000000000",
    n1312 when "0000000000000000010000000000000000",
    n1312 when "0000000000000000001000000000000000",
    n1312 when "0000000000000000000100000000000000",
    n1312 when "0000000000000000000010000000000000",
    n1312 when "0000000000000000000001000000000000",
    n1312 when "0000000000000000000000100000000000",
    n1312 when "0000000000000000000000010000000000",
    n1312 when "0000000000000000000000001000000000",
    n1312 when "0000000000000000000000000100000000",
    n1312 when "0000000000000000000000000010000000",
    n1312 when "0000000000000000000000000001000000",
    n1312 when "0000000000000000000000000000100000",
    n1312 when "0000000000000000000000000000010000",
    n1312 when "0000000000000000000000000000001000",
    n1312 when "0000000000000000000000000000000100",
    n1312 when "0000000000000000000000000000000010",
    n1312 when "0000000000000000000000000000000001",
    n1312 when others;
  n1314 <= n536 (15 downto 0);
  n1315 <= n608 (15 downto 0);
  n1316 <= n1024 (15 downto 0);
  n1317 <= state (173 downto 158);
  with n1273 select n1318 <=
    n1317 when "1000000000000000000000000000000000",
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
    n1317 when "0000000000000100000000000000000000",
    n1316 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1317 when "0000000000000000100000000000000000",
    n1317 when "0000000000000000010000000000000000",
    n1317 when "0000000000000000001000000000000000",
    n1317 when "0000000000000000000100000000000000",
    n682 when "0000000000000000000010000000000000",
    n612 when "0000000000000000000001000000000000",
    n1315 when "0000000000000000000000100000000000",
    n1314 when "0000000000000000000000010000000000",
    n1317 when "0000000000000000000000001000000000",
    n1317 when "0000000000000000000000000100000000",
    n1317 when "0000000000000000000000000010000000",
    n1317 when "0000000000000000000000000001000000",
    n1317 when "0000000000000000000000000000100000",
    n1317 when "0000000000000000000000000000010000",
    n1317 when "0000000000000000000000000000001000",
    n1317 when "0000000000000000000000000000000100",
    n1317 when "0000000000000000000000000000000010",
    n1317 when "0000000000000000000000000000000001",
    n1317 when others;
  n1319 <= n536 (31 downto 16);
  n1320 <= n608 (31 downto 16);
  n1321 <= n1024 (31 downto 16);
  n1322 <= state (189 downto 174);
  with n1273 select n1323 <=
    n1322 when "1000000000000000000000000000000000",
    n1322 when "0100000000000000000000000000000000",
    n1322 when "0010000000000000000000000000000000",
    n1322 when "0001000000000000000000000000000000",
    n1322 when "0000100000000000000000000000000000",
    n1322 when "0000010000000000000000000000000000",
    n1322 when "0000001000000000000000000000000000",
    n1322 when "0000000100000000000000000000000000",
    n1322 when "0000000010000000000000000000000000",
    n1322 when "0000000001000000000000000000000000",
    n1322 when "0000000000100000000000000000000000",
    n1322 when "0000000000010000000000000000000000",
    n1322 when "0000000000001000000000000000000000",
    n1322 when "0000000000000100000000000000000000",
    n1321 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1322 when "0000000000000000100000000000000000",
    n1322 when "0000000000000000010000000000000000",
    n765 when "0000000000000000001000000000000000",
    n695 when "0000000000000000000100000000000000",
    n1322 when "0000000000000000000010000000000000",
    n1322 when "0000000000000000000001000000000000",
    n1320 when "0000000000000000000000100000000000",
    n1319 when "0000000000000000000000010000000000",
    n1322 when "0000000000000000000000001000000000",
    n1322 when "0000000000000000000000000100000000",
    n1322 when "0000000000000000000000000010000000",
    n1322 when "0000000000000000000000000001000000",
    n1322 when "0000000000000000000000000000100000",
    n1322 when "0000000000000000000000000000010000",
    n1322 when "0000000000000000000000000000001000",
    n1322 when "0000000000000000000000000000000100",
    n1322 when "0000000000000000000000000000000010",
    n1322 when "0000000000000000000000000000000001",
    n1322 when others;
  n1324 <= n432 (15 downto 0);
  n1325 <= n513 (15 downto 0);
  n1326 <= n684 (15 downto 0);
  n1327 <= n767 (15 downto 0);
  n1328 <= n839 (15 downto 0);
  n1329 <= state (205 downto 190);
  with n1273 select n1330 <=
    n1263 when "1000000000000000000000000000000000",
    n1329 when "0100000000000000000000000000000000",
    n1329 when "0010000000000000000000000000000000",
    n1329 when "0001000000000000000000000000000000",
    n1329 when "0000100000000000000000000000000000",
    n1329 when "0000010000000000000000000000000000",
    n1329 when "0000001000000000000000000000000000",
    n1329 when "0000000100000000000000000000000000",
    n1329 when "0000000010000000000000000000000000",
    n1329 when "0000000001000000000000000000000000",
    n1329 when "0000000000100000000000000000000000",
    n1329 when "0000000000010000000000000000000000",
    n1329 when "0000000000001000000000000000000000",
    n1076 when "0000000000000100000000000000000000",
    n1329 when "0000000000000010000000000000000000",
    n1329 when "0000000000000001000000000000000000",
    n1328 when "0000000000000000100000000000000000",
    n1329 when "0000000000000000010000000000000000",
    n1327 when "0000000000000000001000000000000000",
    n1329 when "0000000000000000000100000000000000",
    n1326 when "0000000000000000000010000000000000",
    n1329 when "0000000000000000000001000000000000",
    n1329 when "0000000000000000000000100000000000",
    n1329 when "0000000000000000000000010000000000",
    n1329 when "0000000000000000000000001000000000",
    n1325 when "0000000000000000000000000100000000",
    n1329 when "0000000000000000000000000010000000",
    n1329 when "0000000000000000000000000001000000",
    n1329 when "0000000000000000000000000000100000",
    n1329 when "0000000000000000000000000000010000",
    n1324 when "0000000000000000000000000000001000",
    n1329 when "0000000000000000000000000000000100",
    n316 when "0000000000000000000000000000000010",
    n1329 when "0000000000000000000000000000000001",
    n1329 when others;
  n1331 <= n432 (31 downto 16);
  n1332 <= n513 (31 downto 16);
  n1333 <= n684 (31 downto 16);
  n1334 <= n767 (31 downto 16);
  n1335 <= n839 (31 downto 16);
  n1336 <= state (221 downto 206);
  with n1273 select n1337 <=
    n1270 when "1000000000000000000000000000000000",
    n1336 when "0100000000000000000000000000000000",
    n1336 when "0010000000000000000000000000000000",
    n1336 when "0001000000000000000000000000000000",
    n1336 when "0000100000000000000000000000000000",
    n1336 when "0000010000000000000000000000000000",
    n1336 when "0000001000000000000000000000000000",
    n1336 when "0000000100000000000000000000000000",
    n1336 when "0000000010000000000000000000000000",
    n1336 when "0000000001000000000000000000000000",
    n1336 when "0000000000100000000000000000000000",
    n1336 when "0000000000010000000000000000000000",
    n1336 when "0000000000001000000000000000000000",
    n1097 when "0000000000000100000000000000000000",
    n1336 when "0000000000000010000000000000000000",
    n1336 when "0000000000000001000000000000000000",
    n1335 when "0000000000000000100000000000000000",
    n1336 when "0000000000000000010000000000000000",
    n1334 when "0000000000000000001000000000000000",
    n1336 when "0000000000000000000100000000000000",
    n1333 when "0000000000000000000010000000000000",
    n1336 when "0000000000000000000001000000000000",
    n1336 when "0000000000000000000000100000000000",
    n1336 when "0000000000000000000000010000000000",
    n1336 when "0000000000000000000000001000000000",
    n1332 when "0000000000000000000000000100000000",
    n1336 when "0000000000000000000000000010000000",
    n1336 when "0000000000000000000000000001000000",
    n1336 when "0000000000000000000000000000100000",
    n1336 when "0000000000000000000000000000010000",
    n1331 when "0000000000000000000000000000001000",
    n1336 when "0000000000000000000000000000000100",
    n318 when "0000000000000000000000000000000010",
    n1336 when "0000000000000000000000000000000001",
    n1336 when others;
  n1338 <= state (229 downto 222);
  with n1273 select n1339 <=
    n1338 when "1000000000000000000000000000000000",
    n1338 when "0100000000000000000000000000000000",
    n1338 when "0010000000000000000000000000000000",
    n1338 when "0001000000000000000000000000000000",
    n1338 when "0000100000000000000000000000000000",
    n1338 when "0000010000000000000000000000000000",
    n1338 when "0000001000000000000000000000000000",
    n1338 when "0000000100000000000000000000000000",
    n1338 when "0000000010000000000000000000000000",
    n1338 when "0000000001000000000000000000000000",
    n1338 when "0000000000100000000000000000000000",
    n1338 when "0000000000010000000000000000000000",
    n1338 when "0000000000001000000000000000000000",
    n1338 when "0000000000000100000000000000000000",
    n1338 when "0000000000000010000000000000000000",
    n1338 when "0000000000000001000000000000000000",
    n1338 when "0000000000000000100000000000000000",
    n1338 when "0000000000000000010000000000000000",
    n1338 when "0000000000000000001000000000000000",
    n1338 when "0000000000000000000100000000000000",
    n1338 when "0000000000000000000010000000000000",
    n1338 when "0000000000000000000001000000000000",
    n1338 when "0000000000000000000000100000000000",
    n1338 when "0000000000000000000000010000000000",
    n1338 when "0000000000000000000000001000000000",
    n1338 when "0000000000000000000000000100000000",
    n1338 when "0000000000000000000000000010000000",
    n1338 when "0000000000000000000000000001000000",
    n1338 when "0000000000000000000000000000100000",
    n1338 when "0000000000000000000000000000010000",
    n1338 when "0000000000000000000000000000001000",
    n1338 when "0000000000000000000000000000000100",
    n320 when "0000000000000000000000000000000010",
    n1338 when "0000000000000000000000000000000001",
    n1338 when others;
  n1340 <= state (237 downto 230);
  with n1273 select n1341 <=
    n1340 when "1000000000000000000000000000000000",
    n1340 when "0100000000000000000000000000000000",
    n1340 when "0010000000000000000000000000000000",
    n1340 when "0001000000000000000000000000000000",
    n1340 when "0000100000000000000000000000000000",
    n1340 when "0000010000000000000000000000000000",
    n1340 when "0000001000000000000000000000000000",
    n1340 when "0000000100000000000000000000000000",
    n1340 when "0000000010000000000000000000000000",
    n1340 when "0000000001000000000000000000000000",
    n1340 when "0000000000100000000000000000000000",
    n1340 when "0000000000010000000000000000000000",
    n1340 when "0000000000001000000000000000000000",
    n1340 when "0000000000000100000000000000000000",
    n1340 when "0000000000000010000000000000000000",
    n1340 when "0000000000000001000000000000000000",
    n1340 when "0000000000000000100000000000000000",
    n1340 when "0000000000000000010000000000000000",
    n1340 when "0000000000000000001000000000000000",
    n1340 when "0000000000000000000100000000000000",
    n1340 when "0000000000000000000010000000000000",
    n1340 when "0000000000000000000001000000000000",
    n1340 when "0000000000000000000000100000000000",
    n1340 when "0000000000000000000000010000000000",
    n1340 when "0000000000000000000000001000000000",
    n1340 when "0000000000000000000000000100000000",
    n1340 when "0000000000000000000000000010000000",
    n1340 when "0000000000000000000000000001000000",
    n1340 when "0000000000000000000000000000100000",
    n1340 when "0000000000000000000000000000010000",
    n1340 when "0000000000000000000000000000001000",
    n1340 when "0000000000000000000000000000000100",
    n322 when "0000000000000000000000000000000010",
    n1340 when "0000000000000000000000000000000001",
    n1340 when others;
  n1342 <= state (299 downto 238);
  with n1273 select n1343 <=
    n1342 when "1000000000000000000000000000000000",
    n1342 when "0100000000000000000000000000000000",
    n1342 when "0010000000000000000000000000000000",
    n1342 when "0001000000000000000000000000000000",
    n1342 when "0000100000000000000000000000000000",
    n1342 when "0000010000000000000000000000000000",
    n1342 when "0000001000000000000000000000000000",
    n1342 when "0000000100000000000000000000000000",
    n1342 when "0000000010000000000000000000000000",
    n1342 when "0000000001000000000000000000000000",
    n1342 when "0000000000100000000000000000000000",
    n1342 when "0000000000010000000000000000000000",
    n1342 when "0000000000001000000000000000000000",
    n1342 when "0000000000000100000000000000000000",
    n1342 when "0000000000000010000000000000000000",
    n1342 when "0000000000000001000000000000000000",
    n1342 when "0000000000000000100000000000000000",
    n1342 when "0000000000000000010000000000000000",
    n1342 when "0000000000000000001000000000000000",
    n1342 when "0000000000000000000100000000000000",
    n1342 when "0000000000000000000010000000000000",
    n1342 when "0000000000000000000001000000000000",
    n1342 when "0000000000000000000000100000000000",
    n1342 when "0000000000000000000000010000000000",
    n1342 when "0000000000000000000000001000000000",
    n1342 when "0000000000000000000000000100000000",
    bdt_bmpidx when "0000000000000000000000000010000000",
    n1342 when "0000000000000000000000000001000000",
    n1342 when "0000000000000000000000000000100000",
    n1342 when "0000000000000000000000000000010000",
    n1342 when "0000000000000000000000000000001000",
    n1342 when "0000000000000000000000000000000100",
    n1342 when "0000000000000000000000000000000010",
    n1342 when "0000000000000000000000000000000001",
    n1342 when others;
  n1344 <= state (307 downto 300);
  with n1273 select n1345 <=
    n1344 when "1000000000000000000000000000000000",
    n1344 when "0100000000000000000000000000000000",
    n1344 when "0010000000000000000000000000000000",
    n1344 when "0001000000000000000000000000000000",
    n1344 when "0000100000000000000000000000000000",
    n1344 when "0000010000000000000000000000000000",
    n1344 when "0000001000000000000000000000000000",
    n1344 when "0000000100000000000000000000000000",
    n1344 when "0000000010000000000000000000000000",
    n1344 when "0000000001000000000000000000000000",
    n1344 when "0000000000100000000000000000000000",
    n1344 when "0000000000010000000000000000000000",
    n1344 when "0000000000001000000000000000000000",
    n1344 when "0000000000000100000000000000000000",
    n1344 when "0000000000000010000000000000000000",
    n1344 when "0000000000000001000000000000000000",
    n1344 when "0000000000000000100000000000000000",
    n1344 when "0000000000000000010000000000000000",
    n1344 when "0000000000000000001000000000000000",
    n1344 when "0000000000000000000100000000000000",
    n1344 when "0000000000000000000010000000000000",
    n1344 when "0000000000000000000001000000000000",
    n1344 when "0000000000000000000000100000000000",
    n1344 when "0000000000000000000000010000000000",
    n1344 when "0000000000000000000000001000000000",
    n1344 when "0000000000000000000000000100000000",
    n1344 when "0000000000000000000000000010000000",
    n1344 when "0000000000000000000000000001000000",
    n1344 when "0000000000000000000000000000100000",
    n1344 when "0000000000000000000000000000010000",
    n1344 when "0000000000000000000000000000001000",
    n1344 when "0000000000000000000000000000000100",
    n324 when "0000000000000000000000000000000010",
    n1344 when "0000000000000000000000000000000001",
    n1344 when others;
  n1346 <= state (309 downto 308);
  with n1273 select n1347 <=
    n1346 when "1000000000000000000000000000000000",
    n1346 when "0100000000000000000000000000000000",
    n1346 when "0010000000000000000000000000000000",
    n1346 when "0001000000000000000000000000000000",
    n1346 when "0000100000000000000000000000000000",
    n1346 when "0000010000000000000000000000000000",
    n1346 when "0000001000000000000000000000000000",
    n1346 when "0000000100000000000000000000000000",
    n1346 when "0000000010000000000000000000000000",
    n1346 when "0000000001000000000000000000000000",
    n1346 when "0000000000100000000000000000000000",
    n1346 when "0000000000010000000000000000000000",
    n1346 when "0000000000001000000000000000000000",
    n1346 when "0000000000000100000000000000000000",
    n1346 when "0000000000000010000000000000000000",
    n1346 when "0000000000000001000000000000000000",
    n1346 when "0000000000000000100000000000000000",
    n1346 when "0000000000000000010000000000000000",
    n1346 when "0000000000000000001000000000000000",
    n1346 when "0000000000000000000100000000000000",
    n1346 when "0000000000000000000010000000000000",
    n1346 when "0000000000000000000001000000000000",
    n1346 when "0000000000000000000000100000000000",
    n1346 when "0000000000000000000000010000000000",
    n1346 when "0000000000000000000000001000000000",
    n1346 when "0000000000000000000000000100000000",
    n1346 when "0000000000000000000000000010000000",
    n1346 when "0000000000000000000000000001000000",
    n1346 when "0000000000000000000000000000100000",
    n1346 when "0000000000000000000000000000010000",
    n1346 when "0000000000000000000000000000001000",
    n1346 when "0000000000000000000000000000000100",
    n326 when "0000000000000000000000000000000010",
    n1346 when "0000000000000000000000000000000001",
    n1346 when others;
  with n1273 select n1368 <=
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
    n435 when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1273 select n1371 <=
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
  with n1273 select n1374 <=
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
    n1033 when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    n812 when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    n769 when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    n686 when "0000000000000000000010000000000000",
    '0' when "0000000000000000000001000000000000",
    n550 when "0000000000000000000000100000000000",
    '0' when "0000000000000000000000010000000000",
    '0' when "0000000000000000000000001000000000",
    n478 when "0000000000000000000000000100000000",
    '0' when "0000000000000000000000000010000000",
    '0' when "0000000000000000000000000001000000",
    '0' when "0000000000000000000000000000100000",
    '0' when "0000000000000000000000000000010000",
    '0' when "0000000000000000000000000000001000",
    '0' when "0000000000000000000000000000000100",
    '0' when "0000000000000000000000000000000010",
    '0' when "0000000000000000000000000000000001",
    '0' when others;
  with n1273 select n1377 <=
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
    n1035 when "0000000000000010000000000000000000",
    "00000000" when "0000000000000001000000000000000000",
    n814 when "0000000000000000100000000000000000",
    "00000000" when "0000000000000000010000000000000000",
    n771 when "0000000000000000001000000000000000",
    "00000000" when "0000000000000000000100000000000000",
    n688 when "0000000000000000000010000000000000",
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
  with n1273 select n1380 <=
    "00000000000000000000000000000000" when "1000000000000000000000000000000000",
    n1248 when "0100000000000000000000000000000000",
    n1231 when "0010000000000000000000000000000000",
    n1228 when "0001000000000000000000000000000000",
    n1224 when "0000100000000000000000000000000000",
    "00000000000000000000000000000000" when "0000010000000000000000000000000000",
    "00000000000000000000000000000000" when "0000001000000000000000000000000000",
    "00000000000000000000000000000000" when "0000000100000000000000000000000000",
    "00000000000000000000000000000000" when "0000000010000000000000000000000000",
    "00000000000000000000000000000000" when "0000000001000000000000000000000000",
    "00000000000000000000000000000000" when "0000000000100000000000000000000000",
    "00000000000000000000000000000000" when "0000000000010000000000000000000000",
    "00000000000000000000000000000000" when "0000000000001000000000000000000000",
    "00000000000000000000000000000000" when "0000000000000100000000000000000000",
    n1038 when "0000000000000010000000000000000000",
    "00000000000000000000000000000000" when "0000000000000001000000000000000000",
    n816 when "0000000000000000100000000000000000",
    "00000000000000000000000000000000" when "0000000000000000010000000000000000",
    n774 when "0000000000000000001000000000000000",
    "00000000000000000000000000000000" when "0000000000000000000100000000000000",
    n691 when "0000000000000000000010000000000000",
    "00000000000000000000000000000000" when "0000000000000000000001000000000000",
    n541 when "0000000000000000000000100000000000",
    "00000000000000000000000000000000" when "0000000000000000000000010000000000",
    "00000000000000000000000000000000" when "0000000000000000000000001000000000",
    n469 when "0000000000000000000000000100000000",
    "00000000000000000000000000000000" when "0000000000000000000000000010000000",
    "00000000000000000000000000000000" when "0000000000000000000000000001000000",
    "00000000000000000000000000000000" when "0000000000000000000000000000100000",
    "00000000000000000000000000000000" when "0000000000000000000000000000010000",
    "00000000000000000000000000000000" when "0000000000000000000000000000001000",
    "00000000000000000000000000000000" when "0000000000000000000000000000000100",
    "00000000000000000000000000000000" when "0000000000000000000000000000000010",
    "00000000000000000000000000000000" when "0000000000000000000000000000000001",
    "00000000000000000000000000000000" when others;
  with n1273 select n1385 <=
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
    n1040 when "0000000000000010000000000000000000",
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
  with n1273 select n1388 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    n1197 when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    n1113 when "0000000000001000000000000000000000",
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
  with n1273 select n1391 <=
    "000000000000000000000" when "1000000000000000000000000000000000",
    "000000000000000000000" when "0100000000000000000000000000000000",
    "000000000000000000000" when "0010000000000000000000000000000000",
    "000000000000000000000" when "0001000000000000000000000000000000",
    "000000000000000000000" when "0000100000000000000000000000000000",
    "000000000000000000000" when "0000010000000000000000000000000000",
    "000000000000000000000" when "0000001000000000000000000000000000",
    "000000000000000000000" when "0000000100000000000000000000000000",
    n1163 when "0000000010000000000000000000000000",
    "000000000000000000000" when "0000000001000000000000000000000000",
    "000000000000000000000" when "0000000000100000000000000000000000",
    "000000000000000000000" when "0000000000010000000000000000000000",
    n1115 when "0000000000001000000000000000000000",
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
  with n1273 select n1394 <=
    "0000000000000000" when "1000000000000000000000000000000000",
    "0000000000000000" when "0100000000000000000000000000000000",
    "0000000000000000" when "0010000000000000000000000000000000",
    "0000000000000000" when "0001000000000000000000000000000000",
    "0000000000000000" when "0000100000000000000000000000000000",
    "0000000000000000" when "0000010000000000000000000000000000",
    "0000000000000000" when "0000001000000000000000000000000000",
    "0000000000000000" when "0000000100000000000000000000000000",
    n1172 when "0000000010000000000000000000000000",
    "0000000000000000" when "0000000001000000000000000000000000",
    "0000000000000000" when "0000000000100000000000000000000000",
    "0000000000000000" when "0000000000010000000000000000000000",
    n1117 when "0000000000001000000000000000000000",
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
  with n1273 select n1397 <=
    '1' when "1000000000000000000000000000000000",
    '1' when "0100000000000000000000000000000000",
    '1' when "0010000000000000000000000000000000",
    '1' when "0001000000000000000000000000000000",
    '1' when "0000100000000000000000000000000000",
    '1' when "0000010000000000000000000000000000",
    '1' when "0000001000000000000000000000000000",
    '1' when "0000000100000000000000000000000000",
    n1199 when "0000000010000000000000000000000000",
    '1' when "0000000001000000000000000000000000",
    '1' when "0000000000100000000000000000000000",
    '1' when "0000000000010000000000000000000000",
    n1119 when "0000000000001000000000000000000000",
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
  with n1273 select n1401 <=
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
  with n1273 select n1404 <=
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
    n1042 when "0000000000000010000000000000000000",
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
  with n1273 select n1407 <=
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
    n783 when "0000000000000000010000000000000000",
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
  n1412 <= "000000000000000000000" when pw_vram_wr = '0' else pw_vram_wr_addr;
  n1414 <= "0000000000000000" when pw_vram_wr = '0' else pw_vram_wr_data;
  n1417 <= '0' when pw_vram_wr = '0' else '1';
  n1419 <= '1' when pw_vram_wr = '0' else pw_vram_wr_access_mode;
  n1420 <= n1412 when direct_vram_wr = '0' else direct_vram_wr_addr;
  n1422 <= n1414 when direct_vram_wr = '0' else direct_vram_wr_data;
  n1425 <= n1417 when direct_vram_wr = '0' else '1';
  n1427 <= n1419 when direct_vram_wr = '0' else direct_vram_wr_access_mode;
  gfx_circle_inst : entity work.gfx_circle_renamed port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    start => circle_start,
    stall => stall,
    center_x => n1432,
    center_y => n1433,
    radius => radius,
    busy => gfx_circle_inst_c_busy,
    pixel_valid => gfx_circle_inst_c_pixel_valid,
    pixel_x => gfx_circle_inst_c_pixel_x,
    pixel_y => gfx_circle_inst_c_pixel_y);
  n1431 <= state (221 downto 190);
  n1432 <= n1431 (15 downto 0);
  n1433 <= n1431 (31 downto 16);
  n1435 <= gfx_circle_inst_c_pixel_y & gfx_circle_inst_c_pixel_x;
  pw : entity work.pixel_writer_21_16 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    wr => pw_wr,
    bd_b => n1439,
    bd_w => n1440,
    bd_h => n1441,
    color => pw_color,
    position_x => n1442,
    position_y => n1443,
    alpha_mode => pw_alpha_mode,
    alpha_color => n1482,
    vram_wr_full => wrap_vram_wr_full,
    wr_in_progress => open,
    stall => pw_c_stall,
    oob => pw_c_oob,
    vram_wr_addr => pw_c_vram_wr_addr,
    vram_wr_data => pw_c_vram_wr_data,
    vram_wr => pw_c_vram_wr,
    vram_wr_access_mode => pw_c_vram_wr_access_mode);
  n1438 <= state (299 downto 238);
  n1439 <= n1438 (31 downto 0);
  n1440 <= n1438 (46 downto 32);
  n1441 <= n1438 (61 downto 47);
  n1442 <= pw_position (15 downto 0);
  n1443 <= pw_position (31 downto 16);
  n1445 <= state (237 downto 230);
  n1451 <= state (309 downto 308);
  n1452 <= state (307 downto 300);
  n1453 <= n1445 and n1452;
  n1455 <= '1' when n1451 = "01" else '0';
  n1456 <= state (307 downto 300);
  n1457 <= n1445 or n1456;
  n1459 <= '1' when n1451 = "10" else '0';
  n1460 <= state (307 downto 300);
  n1461 <= n1445 xor n1460;
  n1463 <= '1' when n1451 = "11" else '0';
  n1464 <= n1463 & n1459 & n1455;
  with n1464 select n1469 <=
    '0' when "100",
    '0' when "010",
    '0' when "001",
    '1' when others;
  with n1464 select n1477 <=
    n1461 when "100",
    n1457 when "010",
    n1453 when "001",
    "XXXXXXXX" when others;
  n1482 <= n1477 when n1469 = '0' else n1445;
  pr : entity work.pixel_reader_21_16 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    start => pr_start,
    bd_b => n1488,
    bd_w => n1489,
    bd_h => n1490,
    section_x => n1491,
    section_y => n1492,
    section_w => n1493,
    section_h => n1494,
    color_ack => pr_color_ack,
    vram_rd_data => wrap_vram_rd_data,
    vram_rd_busy => wrap_vram_rd_busy,
    vram_rd_valid => wrap_vram_rd_valid,
    color => pr_c_color,
    color_valid => pr_c_color_valid,
    vram_rd_addr => pr_c_vram_rd_addr,
    vram_rd => pr_c_vram_rd,
    vram_rd_access_mode => pr_c_vram_rd_access_mode);
  n1488 <= bdt_bmpidx (31 downto 0);
  n1489 <= bdt_bmpidx (46 downto 32);
  n1490 <= bdt_bmpidx (61 downto 47);
  n1491 <= bb_section (14 downto 0);
  n1492 <= bb_section (29 downto 15);
  n1493 <= bb_section (44 downto 30);
  n1494 <= bb_section (59 downto 45);
  n1500 <= wrap_gcf_data & n57 & n58 & n59;
  process (wrap_clk, n118)
  begin
    if n118 = '1' then
      n1501 <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (wrap_clk) then
      n1501 <= state_nxt;
    end if;
  end process;
  n1502 <= n1347 & n1345 & n1343 & n1341 & n1339 & n1337 & n1330 & n1323 & n1318 & n1313 & n1311 & n1309 & n1307 & n1305 & n1303 & n1301 & n1299 & n1297 & n1295 & n1293;
  n1504 <= n105 & n104 & n103;
  assert vram_addr_width = 21 report "Unsupported generic value! vram_addr_width must be 21." severity failure;
  assert vram_data_width = 16 report "Unsupported generic value! vram_data_width must be 16." severity failure;
end architecture;
