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
  signal n2202 : std_logic_vector (7 downto 0);
  signal n2203 : std_logic_vector (7 downto 0) := "00000000";
  signal n2205 : std_logic_vector (7 downto 0);
begin
  rd1_data <= n2203;
  n2202 <= n2203 when rd1 = '0' else n2205;
  process (clk)
  begin
    if rising_edge (clk) then
      n2203 <= n2202;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (7 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n2205 <= ram(to_integer (unsigned (rd1_addr)));
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
  signal memory_inst_n2089 : std_logic_vector (7 downto 0);
  signal memory_inst_c_rd1_data : std_logic_vector (7 downto 0);
  signal n2093 : std_logic;
  signal n2116 : std_logic;
  signal n2117 : std_logic;
  signal n2119 : std_logic_vector (2 downto 0);
  signal n2120 : std_logic_vector (2 downto 0);
  signal n2123 : std_logic;
  signal n2125 : std_logic;
  signal n2126 : std_logic;
  signal n2128 : std_logic_vector (2 downto 0);
  signal n2129 : std_logic_vector (2 downto 0);
  signal n2132 : std_logic;
  signal n2134 : std_logic;
  signal n2135 : std_logic;
  signal n2137 : std_logic_vector (31 downto 0);
  signal n2138 : std_logic;
  signal n2139 : std_logic;
  signal n2141 : std_logic_vector (31 downto 0);
  signal n2142 : std_logic_vector (31 downto 0);
  signal n2143 : std_logic_vector (31 downto 0);
  signal n2145 : std_logic;
  signal n2148 : std_logic;
  signal n2151 : std_logic_vector (2 downto 0);
  signal n2152 : std_logic;
  signal n2154 : std_logic;
  signal n2156 : std_logic;
  signal n2157 : std_logic;
  signal n2159 : std_logic_vector (2 downto 0);
  signal n2160 : std_logic;
  signal n2161 : std_logic;
  signal n2162 : std_logic;
  signal n2164 : std_logic;
  signal n2165 : std_logic;
  signal n2167 : std_logic;
  signal n2174 : std_logic_vector (2 downto 0);
  signal n2175 : std_logic_vector (2 downto 0);
  signal n2176 : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n2177 : std_logic;
  signal n2178 : std_logic;
  signal n2179 : std_logic;
begin
  rd_data <= memory_inst_n2089;
  empty <= n2177;
  full <= n2178;
  half_full <= n2179;
  read_address <= n2174; -- (signal)
  read_address_next <= n2129; -- (signal)
  write_address <= n2175; -- (signal)
  write_address_next <= n2120; -- (signal)
  full_next <= n2164; -- (signal)
  empty_next <= n2167; -- (signal)
  wr_int <= n2123; -- (signal)
  rd_int <= n2132; -- (signal)
  half_full_next <= n2148; -- (signal)
  pointer_diff <= n2176; -- (isignal)
  pointer_diff_next <= n2143; -- (isignal)
  memory_inst_n2089 <= memory_inst_c_rd1_data; -- (signal)
  memory_inst : entity work.dp_ram_1c1r1w_3_8 port map (
    clk => clk,
    rd1_addr => read_address,
    rd1 => rd_int,
    wr2_addr => write_address,
    wr2_data => wr_data,
    wr2 => wr_int,
    rd1_data => memory_inst_c_rd1_data);
  n2093 <= not res_n;
  n2116 <= not n2178;
  n2117 <= n2116 and wr;
  n2119 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n2120 <= write_address when n2117 = '0' else n2119;
  n2123 <= '0' when n2117 = '0' else '1';
  n2125 <= not n2177;
  n2126 <= n2125 and rd;
  n2128 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n2129 <= read_address when n2126 = '0' else n2128;
  n2132 <= '0' when n2126 = '0' else '1';
  n2134 <= not rd;
  n2135 <= n2134 and wr;
  n2137 <= std_logic_vector (unsigned (pointer_diff) + unsigned'("00000000000000000000000000000001"));
  n2138 <= not wr;
  n2139 <= n2138 and rd;
  n2141 <= std_logic_vector (unsigned (pointer_diff) - unsigned'("00000000000000000000000000000001"));
  n2142 <= pointer_diff when n2139 = '0' else n2141;
  n2143 <= n2142 when n2135 = '0' else n2137;
  n2145 <= '1' when signed (n2143) >= signed'("00000000000000000000000000000100") else '0';
  n2148 <= '0' when n2145 = '0' else '1';
  n2151 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n2152 <= '1' when write_address = n2151 else '0';
  n2154 <= n2177 when n2157 = '0' else '1';
  n2156 <= n2178 when rd = '0' else '0';
  n2157 <= n2152 and rd;
  n2159 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n2160 <= '1' when read_address = n2159 else '0';
  n2161 <= not rd;
  n2162 <= n2161 and n2160;
  n2164 <= n2156 when n2165 = '0' else '1';
  n2165 <= n2162 and wr;
  n2167 <= n2154 when wr = '0' else '0';
  process (clk, n2093)
  begin
    if n2093 = '1' then
      n2174 <= "000";
    elsif rising_edge (clk) then
      n2174 <= read_address_next;
    end if;
  end process;
  process (clk, n2093)
  begin
    if n2093 = '1' then
      n2175 <= "000";
    elsif rising_edge (clk) then
      n2175 <= write_address_next;
    end if;
  end process;
  process (clk, n2093)
  begin
    if n2093 = '1' then
      n2176 <= "00000000000000000000000000000000";
    elsif rising_edge (clk) then
      n2176 <= pointer_diff_next;
    end if;
  end process;
  process (clk, n2093)
  begin
    if n2093 = '1' then
      n2177 <= '1';
    elsif rising_edge (clk) then
      n2177 <= empty_next;
    end if;
  end process;
  process (clk, n2093)
  begin
    if n2093 = '1' then
      n2178 <= '0';
    elsif rising_edge (clk) then
      n2178 <= full_next;
    end if;
  end process;
  process (clk, n2093)
  begin
    if n2093 = '1' then
      n2179 <= '0';
    elsif rising_edge (clk) then
      n2179 <= half_full_next;
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
  signal fifo_inst_n2054 : std_logic_vector (7 downto 0);
  signal fifo_inst_n2055 : std_logic;
  signal fifo_inst_n2056 : std_logic;
  signal fifo_inst_n2057 : std_logic;
  signal fifo_inst_c_rd_data : std_logic_vector (7 downto 0);
  signal fifo_inst_c_empty : std_logic;
  signal fifo_inst_c_full : std_logic;
  signal fifo_inst_c_half_full : std_logic;
  signal n2066 : std_logic;
  signal n2067 : std_logic;
  signal n2068 : std_logic;
  signal n2069 : std_logic;
  signal n2070 : std_logic;
  signal n2072 : std_logic;
  signal n2074 : std_logic;
  signal n2080 : std_logic;
  signal n2081 : std_logic;
begin
  rd_data <= fifo_inst_n2054;
  rd_valid <= n2081;
  full <= fifo_inst_n2056;
  half_full <= fifo_inst_n2057;
  rd <= n2070; -- (signal)
  empty <= fifo_inst_n2055; -- (signal)
  not_empty <= n2066; -- (signal)
  fifo_inst_n2054 <= fifo_inst_c_rd_data; -- (signal)
  fifo_inst_n2055 <= fifo_inst_c_empty; -- (signal)
  fifo_inst_n2056 <= fifo_inst_c_full; -- (signal)
  fifo_inst_n2057 <= fifo_inst_c_half_full; -- (signal)
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
  n2066 <= not empty;
  n2067 <= rd_ack and not_empty;
  n2068 <= not n2081;
  n2069 <= not_empty and n2068;
  n2070 <= n2067 or n2069;
  n2072 <= not res_n;
  n2074 <= rd or rd_ack;
  n2080 <= n2081 when n2074 = '0' else not_empty;
  process (clk, n2072)
  begin
    if n2072 = '1' then
      n2081 <= '0';
    elsif rising_edge (clk) then
      n2081 <= n2080;
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
  signal n1896 : std_logic_vector (61 downto 0);
  signal n1897 : std_logic_vector (59 downto 0);
  signal state : std_logic_vector (55 downto 0);
  signal state_nxt : std_logic_vector (55 downto 0);
  signal pixbuf_half_full : std_logic;
  signal fifo_wr : std_logic;
  signal n1904 : std_logic;
  signal n1912 : std_logic_vector (20 downto 0);
  signal n1913 : std_logic_vector (1 downto 0);
  signal n1914 : std_logic_vector (14 downto 0);
  signal n1915 : std_logic_vector (14 downto 0);
  signal n1917 : std_logic_vector (31 downto 0);
  signal n1918 : std_logic_vector (31 downto 0);
  signal n1919 : std_logic_vector (31 downto 0);
  signal n1921 : std_logic;
  signal n1922 : std_logic_vector (31 downto 0);
  signal n1923 : std_logic_vector (14 downto 0);
  signal n1924 : std_logic_vector (31 downto 0);
  signal n1925 : std_logic_vector (31 downto 0);
  signal n1926 : std_logic_vector (14 downto 0);
  signal n1927 : std_logic_vector (14 downto 0);
  signal n1928 : std_logic_vector (29 downto 0);
  signal n1929 : std_logic_vector (29 downto 0);
  signal n1930 : std_logic_vector (29 downto 0);
  signal n1931 : std_logic_vector (31 downto 0);
  signal n1932 : std_logic_vector (31 downto 0);
  signal n1933 : std_logic_vector (20 downto 0);
  signal n1934 : std_logic;
  signal n1936 : std_logic_vector (1 downto 0);
  signal n1937 : std_logic_vector (1 downto 0);
  signal n1939 : std_logic;
  signal n1940 : std_logic;
  signal n1942 : std_logic_vector (14 downto 0);
  signal n1943 : std_logic_vector (14 downto 0);
  signal n1944 : std_logic_vector (14 downto 0);
  signal n1945 : std_logic_vector (14 downto 0);
  signal n1947 : std_logic_vector (14 downto 0);
  signal n1948 : std_logic;
  signal n1949 : std_logic_vector (14 downto 0);
  signal n1950 : std_logic_vector (14 downto 0);
  signal n1951 : std_logic_vector (14 downto 0);
  signal n1952 : std_logic_vector (14 downto 0);
  signal n1953 : std_logic_vector (14 downto 0);
  signal n1955 : std_logic_vector (14 downto 0);
  signal n1956 : std_logic;
  signal n1958 : std_logic_vector (14 downto 0);
  signal n1960 : std_logic_vector (14 downto 0);
  signal n1961 : std_logic_vector (1 downto 0);
  signal n1962 : std_logic_vector (14 downto 0);
  signal n1963 : std_logic_vector (14 downto 0);
  signal n1964 : std_logic_vector (14 downto 0);
  signal n1966 : std_logic_vector (14 downto 0);
  signal n1967 : std_logic_vector (31 downto 0);
  signal n1968 : std_logic_vector (1 downto 0);
  signal n1969 : std_logic_vector (1 downto 0);
  signal n1970 : std_logic_vector (14 downto 0);
  signal n1971 : std_logic_vector (14 downto 0);
  signal n1972 : std_logic_vector (14 downto 0);
  signal n1973 : std_logic_vector (14 downto 0);
  signal n1974 : std_logic_vector (14 downto 0);
  signal n1977 : std_logic;
  signal n1978 : std_logic_vector (31 downto 0);
  signal n1979 : std_logic_vector (31 downto 0);
  signal n1980 : std_logic_vector (31 downto 0);
  signal n1982 : std_logic;
  signal n1983 : std_logic_vector (2 downto 0);
  signal n1985 : std_logic;
  signal n1987 : std_logic_vector (1 downto 0);
  signal n1988 : std_logic_vector (1 downto 0);
  signal n1990 : std_logic;
  signal n1991 : std_logic_vector (3 downto 0);
  signal n1994 : std_logic;
  signal n1996 : std_logic_vector (1 downto 0);
  signal n1997 : std_logic_vector (1 downto 0);
  signal n1999 : std_logic_vector (1 downto 0);
  signal n2000 : std_logic_vector (29 downto 0);
  signal n2001 : std_logic_vector (29 downto 0);
  signal n2002 : std_logic_vector (29 downto 0);
  signal n2004 : std_logic_vector (29 downto 0);
  signal n2005 : std_logic_vector (20 downto 0);
  signal n2007 : std_logic_vector (20 downto 0);
  signal n2010 : std_logic_vector (2 downto 0);
  signal n2011 : std_logic_vector (1 downto 0);
  signal n2013 : std_logic;
  signal n2014 : std_logic;
  signal n2015 : std_logic;
  signal n2016 : std_logic_vector (2 downto 0);
  signal n2018 : std_logic_vector (2 downto 0);
  signal n2019 : std_logic;
  signal n2020 : std_logic;
  signal n2021 : std_logic_vector (2 downto 0);
  signal n2023 : std_logic_vector (2 downto 0);
  signal n2024 : std_logic_vector (2 downto 0);
  signal n2025 : std_logic_vector (2 downto 0);
  signal n2026 : std_logic_vector (2 downto 0);
  constant n2028 : std_logic := '0';
  signal n2030 : std_logic_vector (1 downto 0);
  signal n2032 : std_logic;
  signal n2033 : std_logic;
  signal n2034 : std_logic;
  signal pixel_buffer_n2036 : std_logic_vector (7 downto 0);
  signal pixel_buffer_n2037 : std_logic;
  signal n2038 : std_logic_vector (7 downto 0);
  signal pixel_buffer_n2040 : std_logic;
  signal pixel_buffer_c_rd_data : std_logic_vector (7 downto 0);
  signal pixel_buffer_c_rd_valid : std_logic;
  signal pixel_buffer_c_full : std_logic;
  signal pixel_buffer_c_half_full : std_logic;
  signal n2048 : std_logic_vector (55 downto 0);
  signal n2049 : std_logic_vector (55 downto 0);
begin
  color <= pixel_buffer_n2036;
  color_valid <= pixel_buffer_n2037;
  vram_rd_addr <= n1912;
  vram_rd <= n1994;
  vram_rd_access_mode <= n2028;
  n1896 <= bd_h & bd_w & bd_b;
  n1897 <= section_h & section_w & section_y & section_x;
  state <= n2048; -- (signal)
  state_nxt <= n2049; -- (signal)
  pixbuf_half_full <= pixel_buffer_n2040; -- (signal)
  fifo_wr <= n2034; -- (signal)
  n1904 <= not res_n;
  n1912 <= state (52 downto 32);
  n1913 <= state (1 downto 0);
  n1914 <= n1897 (14 downto 0);
  n1915 <= n1897 (29 downto 15);
  n1917 <= n1915 & n1914 & "10";
  n1918 <= state (31 downto 0);
  n1919 <= n1918 when start = '0' else n1917;
  n1921 <= '1' when n1913 = "00" else '0';
  n1922 <= n1896 (31 downto 0);
  n1923 <= state (16 downto 2);
  n1924 <= "00000000000000000" & n1923;  --  uext
  n1925 <= std_logic_vector (unsigned (n1922) + unsigned (n1924));
  n1926 <= state (31 downto 17);
  n1927 <= n1896 (46 downto 32);
  n1928 <= "000000000000000" & n1926;  --  uext
  n1929 <= "000000000000000" & n1927;  --  uext
  n1930 <= std_logic_vector (resize (unsigned (n1928) * unsigned (n1929), 30));
  n1931 <= "00" & n1930;  --  uext
  n1932 <= std_logic_vector (unsigned (n1925) + unsigned (n1931));
  n1933 <= n1932 (20 downto 0);  --  trunc
  n1934 <= not pixbuf_half_full;
  n1936 <= state (1 downto 0);
  n1937 <= n1936 when n1934 = '0' else "11";
  n1939 <= '1' when n1913 = "10" else '0';
  n1940 <= not vram_rd_busy;
  n1942 <= state (16 downto 2);
  n1943 <= n1897 (14 downto 0);
  n1944 <= n1897 (44 downto 30);
  n1945 <= std_logic_vector (unsigned (n1943) + unsigned (n1944));
  n1947 <= std_logic_vector (unsigned (n1945) - unsigned'("000000000000001"));
  n1948 <= '1' when n1942 = n1947 else '0';
  n1949 <= n1897 (14 downto 0);
  n1950 <= state (31 downto 17);
  n1951 <= n1897 (29 downto 15);
  n1952 <= n1897 (59 downto 45);
  n1953 <= std_logic_vector (unsigned (n1951) + unsigned (n1952));
  n1955 <= std_logic_vector (unsigned (n1953) - unsigned'("000000000000001"));
  n1956 <= '1' when n1950 = n1955 else '0';
  n1958 <= state (31 downto 17);
  n1960 <= std_logic_vector (unsigned (n1958) + unsigned'("000000000000001"));
  n1961 <= "10" when n1956 = '0' else "01";
  n1962 <= state (31 downto 17);
  n1963 <= n1960 when n1956 = '0' else n1962;
  n1964 <= state (16 downto 2);
  n1966 <= std_logic_vector (unsigned (n1964) + unsigned'("000000000000001"));
  n1967 <= n1963 & n1949 & n1961;
  n1968 <= n1967 (1 downto 0);
  n1969 <= "10" when n1948 = '0' else n1968;
  n1970 <= n1967 (16 downto 2);
  n1971 <= n1966 when n1948 = '0' else n1970;
  n1972 <= n1967 (31 downto 17);
  n1973 <= state (31 downto 17);
  n1974 <= n1973 when n1948 = '0' else n1972;
  n1977 <= '0' when n1940 = '0' else '1';
  n1978 <= n1974 & n1971 & n1969;
  n1979 <= state (31 downto 0);
  n1980 <= n1979 when n1940 = '0' else n1978;
  n1982 <= '1' when n1913 = "11" else '0';
  n1983 <= state (55 downto 53);
  n1985 <= '1' when n1983 = "000" else '0';
  n1987 <= state (1 downto 0);
  n1988 <= n1987 when n1985 = '0' else "00";
  n1990 <= '1' when n1913 = "01" else '0';
  n1991 <= n1990 & n1982 & n1939 & n1921;
  with n1991 select n1994 <=
    '0' when "1000",
    n1977 when "0100",
    '0' when "0010",
    '0' when "0001",
    'X' when others;
  n1996 <= n1919 (1 downto 0);
  n1997 <= n1980 (1 downto 0);
  with n1991 select n1999 <=
    n1988 when "1000",
    n1997 when "0100",
    n1937 when "0010",
    n1996 when "0001",
    "XX" when others;
  n2000 <= n1919 (31 downto 2);
  n2001 <= n1980 (31 downto 2);
  n2002 <= state (31 downto 2);
  with n1991 select n2004 <=
    n2002 when "1000",
    n2001 when "0100",
    n2002 when "0010",
    n2000 when "0001",
    (29 downto 0 => 'X') when others;
  n2005 <= state (52 downto 32);
  with n1991 select n2007 <=
    n2005 when "1000",
    n2005 when "0100",
    n1933 when "0010",
    n2005 when "0001",
    (20 downto 0 => 'X') when others;
  n2010 <= state (55 downto 53);
  n2011 <= state (1 downto 0);
  n2013 <= '1' when n2011 /= "00" else '0';
  n2014 <= not vram_rd_valid;
  n2015 <= n2014 and n1994;
  n2016 <= state (55 downto 53);
  n2018 <= std_logic_vector (unsigned (n2016) + unsigned'("001"));
  n2019 <= not n1994;
  n2020 <= vram_rd_valid and n2019;
  n2021 <= state (55 downto 53);
  n2023 <= std_logic_vector (unsigned (n2021) - unsigned'("001"));
  n2024 <= n2010 when n2020 = '0' else n2023;
  n2025 <= n2024 when n2015 = '0' else n2018;
  n2026 <= n2010 when n2013 = '0' else n2025;
  n2030 <= state (1 downto 0);
  n2032 <= '1' when n2030 /= "00" else '0';
  n2033 <= n2032 and vram_rd_valid;
  n2034 <= '0' when n2033 = '0' else '1';
  pixel_buffer_n2036 <= pixel_buffer_c_rd_data; -- (signal)
  pixel_buffer_n2037 <= pixel_buffer_c_rd_valid; -- (signal)
  n2038 <= vram_rd_data (7 downto 0);
  pixel_buffer_n2040 <= pixel_buffer_c_half_full; -- (signal)
  pixel_buffer : entity work.fifo_1c1r1w_fwft_8_8 port map (
    clk => clk,
    res_n => res_n,
    rd_ack => color_ack,
    wr_data => n2038,
    wr => fifo_wr,
    rd_data => pixel_buffer_c_rd_data,
    rd_valid => pixel_buffer_c_rd_valid,
    full => open,
    half_full => pixel_buffer_c_half_full);
  process (clk, n1904)
  begin
    if n1904 = '1' then
      n2048 <= "00000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n2048 <= state_nxt;
    end if;
  end process;
  n2049 <= n2026 & n2007 & n2004 & n1999;
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
  signal n1802 : std_logic_vector (61 downto 0);
  signal n1803 : std_logic_vector (31 downto 0);
  signal s1 : std_logic_vector (111 downto 0);
  signal s2 : std_logic_vector (29 downto 0);
  signal s2_nxt : std_logic_vector (29 downto 0);
  signal n1809 : std_logic;
  signal n1810 : std_logic;
  signal n1811 : std_logic;
  signal n1813 : std_logic;
  signal n1815 : std_logic;
  signal n1816 : std_logic_vector (15 downto 0);
  signal n1817 : std_logic_vector (15 downto 0);
  signal n1818 : std_logic_vector (111 downto 0);
  signal n1829 : std_logic;
  signal n1830 : std_logic_vector (15 downto 0);
  signal n1832 : std_logic;
  signal n1833 : std_logic_vector (15 downto 0);
  signal n1835 : std_logic_vector (14 downto 0);
  signal n1837 : std_logic_vector (15 downto 0);
  signal n1838 : std_logic;
  signal n1839 : std_logic;
  signal n1840 : std_logic_vector (15 downto 0);
  signal n1842 : std_logic;
  signal n1843 : std_logic;
  signal n1844 : std_logic_vector (15 downto 0);
  signal n1846 : std_logic_vector (14 downto 0);
  signal n1848 : std_logic_vector (15 downto 0);
  signal n1849 : std_logic;
  signal n1850 : std_logic;
  signal n1851 : std_logic;
  signal n1855 : std_logic;
  signal n1857 : std_logic;
  signal n1858 : std_logic;
  signal n1859 : std_logic_vector (7 downto 0);
  signal n1860 : std_logic_vector (7 downto 0);
  signal n1861 : std_logic;
  signal n1862 : std_logic;
  signal n1864 : std_logic;
  signal n1866 : std_logic_vector (31 downto 0);
  signal n1867 : std_logic_vector (15 downto 0);
  signal n1868 : std_logic_vector (31 downto 0);
  signal n1869 : std_logic_vector (31 downto 0);
  signal n1871 : std_logic_vector (14 downto 0);
  signal n1872 : std_logic_vector (15 downto 0);
  signal n1873 : std_logic_vector (30 downto 0);
  signal n1874 : std_logic_vector (30 downto 0);
  signal n1875 : std_logic_vector (30 downto 0);
  signal n1876 : std_logic_vector (31 downto 0);
  signal n1877 : std_logic_vector (31 downto 0);
  signal n1878 : std_logic_vector (20 downto 0);
  signal n1879 : std_logic_vector (7 downto 0);
  signal n1883 : std_logic_vector (7 downto 0);
  constant n1884 : std_logic_vector (15 downto 0) := "0000000000000000";
  signal n1885 : std_logic_vector (7 downto 0);
  signal n1886 : std_logic_vector (20 downto 0);
  signal n1887 : std_logic;
  constant n1889 : std_logic := '0';
  signal n1890 : std_logic_vector (111 downto 0);
  signal n1891 : std_logic_vector (111 downto 0);
  signal n1892 : std_logic_vector (29 downto 0);
  signal n1893 : std_logic_vector (29 downto 0);
  signal n1894 : std_logic_vector (29 downto 0);
  signal n1895 : std_logic_vector (15 downto 0);
begin
  wr_in_progress <= n1811;
  stall <= vram_wr_full;
  oob <= n1855;
  vram_wr_addr <= n1886;
  vram_wr_data <= n1895;
  vram_wr <= n1887;
  vram_wr_access_mode <= n1889;
  n1802 <= bd_h & bd_w & bd_b;
  n1803 <= position_y & position_x;
  s1 <= n1891; -- (signal)
  s2 <= n1893; -- (signal)
  s2_nxt <= n1894; -- (signal)
  n1809 <= s1 (0);
  n1810 <= s2 (0);
  n1811 <= n1809 or n1810;
  n1813 <= not res_n;
  n1815 <= not vram_wr_full;
  n1816 <= n1803 (31 downto 16);
  n1817 <= n1803 (15 downto 0);
  n1818 <= alpha_color & alpha_mode & n1817 & n1816 & color & n1802 & wr;
  n1829 <= s1 (0);
  n1830 <= s1 (102 downto 87);
  n1832 <= '1' when signed (n1830) >= signed'("0000000000000000") else '0';
  n1833 <= s1 (102 downto 87);
  n1835 <= s1 (47 downto 33);
  n1837 <= '0' & n1835;
  n1838 <= '1' when signed (n1833) < signed (n1837) else '0';
  n1839 <= n1838 and n1832;
  n1840 <= s1 (86 downto 71);
  n1842 <= '1' when signed (n1840) >= signed'("0000000000000000") else '0';
  n1843 <= n1842 and n1839;
  n1844 <= s1 (86 downto 71);
  n1846 <= s1 (62 downto 48);
  n1848 <= '0' & n1846;
  n1849 <= '1' when signed (n1844) < signed (n1848) else '0';
  n1850 <= n1849 and n1843;
  n1851 <= not n1850;
  n1855 <= '0' when n1851 = '0' else '1';
  n1857 <= n1829 when n1851 = '0' else '0';
  n1858 <= s1 (103);
  n1859 <= s1 (70 downto 63);
  n1860 <= s1 (111 downto 104);
  n1861 <= '1' when n1859 = n1860 else '0';
  n1862 <= n1861 and n1858;
  n1864 <= n1857 when n1862 = '0' else '0';
  n1866 <= s1 (32 downto 1);
  n1867 <= s1 (102 downto 87);
  n1868 <= "0000000000000000" & n1867;  --  uext
  n1869 <= std_logic_vector (unsigned (n1866) + unsigned (n1868));
  n1871 <= s1 (47 downto 33);
  n1872 <= s1 (86 downto 71);
  n1873 <= "0000000000000000" & n1871;  --  uext
  n1874 <= "000000000000000" & n1872;  --  uext
  n1875 <= std_logic_vector (resize (unsigned (n1873) * unsigned (n1874), 31));
  n1876 <= "0" & n1875;  --  uext
  n1877 <= std_logic_vector (unsigned (n1869) + unsigned (n1876));
  n1878 <= n1877 (20 downto 0);  --  trunc
  n1879 <= s1 (70 downto 63);
  n1883 <= s2 (29 downto 22);
  n1885 <= n1884 (15 downto 8);
  n1886 <= s2 (21 downto 1);
  n1887 <= s2 (0);
  n1890 <= s1 when n1815 = '0' else n1818;
  process (clk, n1813)
  begin
    if n1813 = '1' then
      n1891 <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1891 <= n1890;
    end if;
  end process;
  n1892 <= s2 when n1815 = '0' else s2_nxt;
  process (clk, n1813)
  begin
    if n1813 = '1' then
      n1893 <= "000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1893 <= n1892;
    end if;
  end process;
  n1894 <= n1879 & n1878 & n1864;
  n1895 <= n1885 & n1883;
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
  signal n1530 : std_logic_vector (31 downto 0);
  signal n1533 : std_logic_vector (15 downto 0);
  signal n1534 : std_logic_vector (15 downto 0);
  signal state : std_logic_vector (163 downto 0);
  signal state_nxt : std_logic_vector (163 downto 0);
  signal n1537 : std_logic;
  signal n1540 : std_logic;
  signal n1554 : std_logic_vector (30 downto 0);
  signal n1555 : std_logic_vector (31 downto 0);
  signal n1556 : std_logic_vector (15 downto 0);
  signal n1557 : std_logic_vector (31 downto 0);
  signal n1558 : std_logic_vector (15 downto 0);
  signal n1559 : std_logic_vector (31 downto 0);
  signal n1562 : std_logic_vector (31 downto 0);
  signal n1563 : std_logic_vector (31 downto 0);
  signal n1564 : std_logic_vector (31 downto 0);
  signal n1565 : std_logic_vector (3 downto 0);
  signal n1567 : std_logic_vector (3 downto 0);
  signal n1568 : std_logic_vector (3 downto 0);
  signal n1570 : std_logic;
  signal n1572 : std_logic_vector (31 downto 0);
  signal n1575 : std_logic_vector (31 downto 0);
  signal n1576 : std_logic_vector (31 downto 0);
  signal n1580 : std_logic;
  signal n1582 : std_logic_vector (31 downto 0);
  signal n1585 : std_logic_vector (15 downto 0);
  signal n1588 : std_logic;
  signal n1590 : std_logic_vector (31 downto 0);
  signal n1593 : std_logic_vector (15 downto 0);
  signal n1596 : std_logic;
  signal n1598 : std_logic_vector (31 downto 0);
  signal n1601 : std_logic_vector (15 downto 0);
  signal n1604 : std_logic;
  signal n1606 : std_logic_vector (31 downto 0);
  signal n1609 : std_logic_vector (15 downto 0);
  signal n1612 : std_logic;
  signal n1613 : std_logic_vector (31 downto 0);
  signal n1614 : std_logic_vector (31 downto 0);
  signal n1615 : std_logic;
  signal n1616 : std_logic_vector (31 downto 0);
  signal n1618 : std_logic;
  signal n1619 : std_logic_vector (31 downto 0);
  signal n1621 : std_logic_vector (31 downto 0);
  signal n1623 : std_logic_vector (31 downto 0);
  signal n1624 : std_logic_vector (31 downto 0);
  signal n1625 : std_logic_vector (31 downto 0);
  signal n1626 : std_logic_vector (31 downto 0);
  signal n1627 : std_logic_vector (31 downto 0);
  signal n1628 : std_logic_vector (31 downto 0);
  signal n1629 : std_logic_vector (31 downto 0);
  signal n1631 : std_logic_vector (31 downto 0);
  signal n1633 : std_logic_vector (31 downto 0);
  signal n1634 : std_logic_vector (31 downto 0);
  signal n1636 : std_logic_vector (31 downto 0);
  signal n1639 : std_logic_vector (163 downto 0);
  signal n1640 : std_logic_vector (3 downto 0);
  signal n1641 : std_logic_vector (3 downto 0);
  signal n1642 : std_logic_vector (159 downto 0);
  signal n1643 : std_logic_vector (159 downto 0);
  signal n1644 : std_logic_vector (159 downto 0);
  signal n1649 : std_logic;
  signal n1651 : std_logic_vector (31 downto 0);
  signal n1652 : std_logic_vector (31 downto 0);
  signal n1653 : std_logic_vector (31 downto 0);
  signal n1654 : std_logic_vector (31 downto 0);
  signal n1657 : std_logic_vector (15 downto 0);
  signal n1658 : std_logic_vector (15 downto 0);
  signal n1661 : std_logic;
  signal n1663 : std_logic_vector (31 downto 0);
  signal n1664 : std_logic_vector (31 downto 0);
  signal n1665 : std_logic_vector (31 downto 0);
  signal n1666 : std_logic_vector (31 downto 0);
  signal n1669 : std_logic_vector (15 downto 0);
  signal n1670 : std_logic_vector (15 downto 0);
  signal n1673 : std_logic;
  signal n1675 : std_logic_vector (31 downto 0);
  signal n1676 : std_logic_vector (31 downto 0);
  signal n1677 : std_logic_vector (31 downto 0);
  signal n1678 : std_logic_vector (31 downto 0);
  signal n1681 : std_logic_vector (15 downto 0);
  signal n1682 : std_logic_vector (15 downto 0);
  signal n1685 : std_logic;
  signal n1687 : std_logic_vector (31 downto 0);
  signal n1688 : std_logic_vector (31 downto 0);
  signal n1689 : std_logic_vector (31 downto 0);
  signal n1690 : std_logic_vector (31 downto 0);
  signal n1693 : std_logic_vector (15 downto 0);
  signal n1694 : std_logic_vector (15 downto 0);
  signal n1697 : std_logic;
  signal n1699 : std_logic_vector (31 downto 0);
  signal n1700 : std_logic_vector (31 downto 0);
  signal n1701 : std_logic_vector (31 downto 0);
  signal n1702 : std_logic_vector (31 downto 0);
  signal n1705 : std_logic_vector (15 downto 0);
  signal n1706 : std_logic_vector (15 downto 0);
  signal n1709 : std_logic;
  signal n1711 : std_logic_vector (31 downto 0);
  signal n1712 : std_logic_vector (31 downto 0);
  signal n1713 : std_logic_vector (31 downto 0);
  signal n1714 : std_logic_vector (31 downto 0);
  signal n1717 : std_logic_vector (15 downto 0);
  signal n1718 : std_logic_vector (15 downto 0);
  signal n1721 : std_logic;
  signal n1723 : std_logic_vector (31 downto 0);
  signal n1724 : std_logic_vector (31 downto 0);
  signal n1725 : std_logic_vector (31 downto 0);
  signal n1726 : std_logic_vector (31 downto 0);
  signal n1729 : std_logic_vector (15 downto 0);
  signal n1730 : std_logic_vector (15 downto 0);
  signal n1733 : std_logic;
  signal n1735 : std_logic_vector (31 downto 0);
  signal n1736 : std_logic_vector (31 downto 0);
  signal n1737 : std_logic_vector (31 downto 0);
  signal n1738 : std_logic_vector (31 downto 0);
  signal n1741 : std_logic_vector (15 downto 0);
  signal n1742 : std_logic_vector (15 downto 0);
  signal n1745 : std_logic;
  signal n1746 : std_logic_vector (14 downto 0);
  signal n1749 : std_logic;
  signal n1764 : std_logic;
  signal n1766 : std_logic_vector (15 downto 0);
  signal n1767 : std_logic_vector (15 downto 0);
  signal n1768 : std_logic_vector (3 downto 0);
  signal n1769 : std_logic_vector (3 downto 0);
  signal n1770 : std_logic_vector (31 downto 0);
  signal n1771 : std_logic_vector (31 downto 0);
  signal n1772 : std_logic_vector (31 downto 0);
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
  signal n1794 : std_logic;
  signal n1796 : std_logic_vector (163 downto 0);
  signal n1797 : std_logic_vector (163 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  signal n1798 : std_logic_vector (163 downto 0);
  signal n1799 : std_logic_vector (31 downto 0);
begin
  busy <= n1749;
  pixel_valid <= n1794;
  pixel_x <= n1533;
  pixel_y <= n1534;
  n1530 <= center_y & center_x;
  n1533 <= n1799 (15 downto 0);
  n1534 <= n1799 (31 downto 16);
  state <= n1797; -- (isignal)
  state_nxt <= n1798; -- (signal)
  n1537 <= not res_n;
  n1540 <= '1' when unsigned'(1 => stall) <= unsigned'("0") else '0';
  n1554 <= "0000000000000000" & radius;  --  uext
  n1555 <= "0" & n1554;  --  uext
  n1556 <= n1530 (15 downto 0);
  n1557 <= std_logic_vector (resize (signed (n1556), 32));  --  sext
  n1558 <= n1530 (31 downto 16);
  n1559 <= std_logic_vector (resize (signed (n1558), 32));  --  sext
  n1562 <= state (67 downto 36);
  n1563 <= state (99 downto 68);
  n1564 <= state (35 downto 4);
  n1565 <= state (3 downto 0);
  n1567 <= state (3 downto 0);
  n1568 <= n1567 when start = '0' else "0001";
  n1570 <= '1' when n1565 = "0000" else '0';
  n1572 <= std_logic_vector (unsigned'("00000000000000000000000000000001") - unsigned (n1555));
  n1575 <= std_logic_vector (resize (signed'("00000000000000000000000000000010") * signed (n1555), 32));
  n1576 <= std_logic_vector(-signed (n1575));
  n1580 <= '1' when n1565 = "0001" else '0';
  n1582 <= std_logic_vector (unsigned (n1559) + unsigned (n1555));
  n1585 <= n1582 (15 downto 0);  --  trunc
  n1588 <= '1' when n1565 = "0011" else '0';
  n1590 <= std_logic_vector (unsigned (n1559) - unsigned (n1555));
  n1593 <= n1590 (15 downto 0);  --  trunc
  n1596 <= '1' when n1565 = "0100" else '0';
  n1598 <= std_logic_vector (unsigned (n1557) + unsigned (n1555));
  n1601 <= n1598 (15 downto 0);  --  trunc
  n1604 <= '1' when n1565 = "0101" else '0';
  n1606 <= std_logic_vector (unsigned (n1557) - unsigned (n1555));
  n1609 <= n1606 (15 downto 0);  --  trunc
  n1612 <= '1' when n1565 = "0110" else '0';
  n1613 <= state (131 downto 100);
  n1614 <= state (163 downto 132);
  n1615 <= '1' when signed (n1613) < signed (n1614) else '0';
  n1616 <= state (35 downto 4);
  n1618 <= '1' when signed (n1616) >= signed'("00000000000000000000000000000000") else '0';
  n1619 <= state (163 downto 132);
  n1621 <= std_logic_vector (unsigned (n1619) - unsigned'("00000000000000000000000000000001"));
  n1623 <= std_logic_vector (unsigned (n1563) + unsigned'("00000000000000000000000000000010"));
  n1624 <= std_logic_vector (unsigned (n1564) + unsigned (n1623));
  n1625 <= state (163 downto 132);
  n1626 <= n1625 when n1618 = '0' else n1621;
  n1627 <= n1563 when n1618 = '0' else n1623;
  n1628 <= n1564 when n1618 = '0' else n1624;
  n1629 <= state (131 downto 100);
  n1631 <= std_logic_vector (unsigned (n1629) + unsigned'("00000000000000000000000000000001"));
  n1633 <= std_logic_vector (unsigned (n1562) + unsigned'("00000000000000000000000000000010"));
  n1634 <= std_logic_vector (unsigned (n1628) + unsigned (n1633));
  n1636 <= std_logic_vector (unsigned (n1634) + unsigned'("00000000000000000000000000000001"));
  n1639 <= n1626 & n1631 & n1627 & n1633 & n1636 & "0111";
  n1640 <= n1639 (3 downto 0);
  n1641 <= "0000" when n1615 = '0' else n1640;
  n1642 <= n1639 (163 downto 4);
  n1643 <= state (163 downto 4);
  n1644 <= n1643 when n1615 = '0' else n1642;
  n1649 <= '1' when n1565 = "0010" else '0';
  n1651 <= state (131 downto 100);
  n1652 <= std_logic_vector (unsigned (n1557) + unsigned (n1651));
  n1653 <= state (163 downto 132);
  n1654 <= std_logic_vector (unsigned (n1559) + unsigned (n1653));
  n1657 <= n1652 (15 downto 0);  --  trunc
  n1658 <= n1654 (15 downto 0);  --  trunc
  n1661 <= '1' when n1565 = "0111" else '0';
  n1663 <= state (131 downto 100);
  n1664 <= std_logic_vector (unsigned (n1557) - unsigned (n1663));
  n1665 <= state (163 downto 132);
  n1666 <= std_logic_vector (unsigned (n1559) + unsigned (n1665));
  n1669 <= n1664 (15 downto 0);  --  trunc
  n1670 <= n1666 (15 downto 0);  --  trunc
  n1673 <= '1' when n1565 = "1000" else '0';
  n1675 <= state (131 downto 100);
  n1676 <= std_logic_vector (unsigned (n1557) + unsigned (n1675));
  n1677 <= state (163 downto 132);
  n1678 <= std_logic_vector (unsigned (n1559) - unsigned (n1677));
  n1681 <= n1676 (15 downto 0);  --  trunc
  n1682 <= n1678 (15 downto 0);  --  trunc
  n1685 <= '1' when n1565 = "1001" else '0';
  n1687 <= state (131 downto 100);
  n1688 <= std_logic_vector (unsigned (n1557) - unsigned (n1687));
  n1689 <= state (163 downto 132);
  n1690 <= std_logic_vector (unsigned (n1559) - unsigned (n1689));
  n1693 <= n1688 (15 downto 0);  --  trunc
  n1694 <= n1690 (15 downto 0);  --  trunc
  n1697 <= '1' when n1565 = "1010" else '0';
  n1699 <= state (163 downto 132);
  n1700 <= std_logic_vector (unsigned (n1557) + unsigned (n1699));
  n1701 <= state (131 downto 100);
  n1702 <= std_logic_vector (unsigned (n1559) + unsigned (n1701));
  n1705 <= n1700 (15 downto 0);  --  trunc
  n1706 <= n1702 (15 downto 0);  --  trunc
  n1709 <= '1' when n1565 = "1011" else '0';
  n1711 <= state (163 downto 132);
  n1712 <= std_logic_vector (unsigned (n1557) - unsigned (n1711));
  n1713 <= state (131 downto 100);
  n1714 <= std_logic_vector (unsigned (n1559) + unsigned (n1713));
  n1717 <= n1712 (15 downto 0);  --  trunc
  n1718 <= n1714 (15 downto 0);  --  trunc
  n1721 <= '1' when n1565 = "1100" else '0';
  n1723 <= state (163 downto 132);
  n1724 <= std_logic_vector (unsigned (n1557) + unsigned (n1723));
  n1725 <= state (131 downto 100);
  n1726 <= std_logic_vector (unsigned (n1559) - unsigned (n1725));
  n1729 <= n1724 (15 downto 0);  --  trunc
  n1730 <= n1726 (15 downto 0);  --  trunc
  n1733 <= '1' when n1565 = "1101" else '0';
  n1735 <= state (163 downto 132);
  n1736 <= std_logic_vector (unsigned (n1557) - unsigned (n1735));
  n1737 <= state (131 downto 100);
  n1738 <= std_logic_vector (unsigned (n1559) - unsigned (n1737));
  n1741 <= n1736 (15 downto 0);  --  trunc
  n1742 <= n1738 (15 downto 0);  --  trunc
  n1745 <= '1' when n1565 = "1110" else '0';
  n1746 <= n1745 & n1733 & n1721 & n1709 & n1697 & n1685 & n1673 & n1661 & n1649 & n1612 & n1604 & n1596 & n1588 & n1580 & n1570;
  with n1746 select n1749 <=
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
  with n1746 select n1764 <=
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
  with n1746 select n1766 <=
    n1741 when "100000000000000",
    n1729 when "010000000000000",
    n1717 when "001000000000000",
    n1705 when "000100000000000",
    n1693 when "000010000000000",
    n1681 when "000001000000000",
    n1669 when "000000100000000",
    n1657 when "000000010000000",
    "0000000000000000" when "000000001000000",
    n1609 when "000000000100000",
    n1601 when "000000000010000",
    n1556 when "000000000001000",
    n1556 when "000000000000100",
    "0000000000000000" when "000000000000010",
    "0000000000000000" when "000000000000001",
    "0000000000000000" when others;
  with n1746 select n1767 <=
    n1742 when "100000000000000",
    n1730 when "010000000000000",
    n1718 when "001000000000000",
    n1706 when "000100000000000",
    n1694 when "000010000000000",
    n1682 when "000001000000000",
    n1670 when "000000100000000",
    n1658 when "000000010000000",
    "0000000000000000" when "000000001000000",
    n1558 when "000000000100000",
    n1558 when "000000000010000",
    n1593 when "000000000001000",
    n1585 when "000000000000100",
    "0000000000000000" when "000000000000010",
    "0000000000000000" when "000000000000001",
    "0000000000000000" when others;
  n1768 <= state (3 downto 0);
  with n1746 select n1769 <=
    "0010" when "100000000000000",
    "1110" when "010000000000000",
    "1101" when "001000000000000",
    "1100" when "000100000000000",
    "1011" when "000010000000000",
    "1010" when "000001000000000",
    "1001" when "000000100000000",
    "1000" when "000000010000000",
    n1641 when "000000001000000",
    "0010" when "000000000100000",
    "0110" when "000000000010000",
    "0101" when "000000000001000",
    "0100" when "000000000000100",
    "0011" when "000000000000010",
    n1568 when "000000000000001",
    n1768 when others;
  n1770 <= n1644 (31 downto 0);
  n1771 <= state (35 downto 4);
  with n1746 select n1772 <=
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
    n1572 when "000000000000010",
    n1771 when "000000000000001",
    n1771 when others;
  n1773 <= n1644 (63 downto 32);
  n1774 <= state (67 downto 36);
  with n1746 select n1775 <=
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
    "00000000000000000000000000000000" when "000000000000010",
    n1774 when "000000000000001",
    n1774 when others;
  n1776 <= n1644 (95 downto 64);
  n1777 <= state (99 downto 68);
  with n1746 select n1778 <=
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
    n1576 when "000000000000010",
    n1777 when "000000000000001",
    n1777 when others;
  n1779 <= n1644 (127 downto 96);
  n1780 <= state (131 downto 100);
  with n1746 select n1781 <=
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
    "00000000000000000000000000000000" when "000000000000010",
    n1780 when "000000000000001",
    n1780 when others;
  n1782 <= n1644 (159 downto 128);
  n1783 <= state (163 downto 132);
  with n1746 select n1784 <=
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
    n1555 when "000000000000010",
    n1783 when "000000000000001",
    n1783 when others;
  n1794 <= n1764 when stall = '0' else '0';
  n1796 <= state when n1540 = '0' else state_nxt;
  process (clk, n1537)
  begin
    if n1537 = '1' then
      n1797 <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1797 <= n1796;
    end if;
  end process;
  n1798 <= n1784 & n1781 & n1778 & n1775 & n1772 & n1769;
  n1799 <= n1767 & n1766;
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
  signal n1524 : std_logic_vector (61 downto 0);
  signal n1525 : std_logic_vector (61 downto 0) := "00000000000000000000000000000000000000000000000000000000000000";
  signal n1527 : std_logic_vector (61 downto 0);
begin
  rd1_data <= n1525;
  n1524 <= n1525 when rd1 = '0' else n1527;
  process (clk)
  begin
    if rising_edge (clk) then
      n1525 <= n1524;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (61 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n1527 <= ram(to_integer (unsigned (rd1_addr)));
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
  signal n1136 : std_logic;
  signal n1142 : std_logic_vector (4 downto 0);
  signal n1144 : std_logic;
  signal n1147 : std_logic;
  signal n1148 : std_logic_vector (15 downto 0);
  signal n1150 : std_logic_vector (15 downto 0);
  signal n1153 : std_logic;
  signal n1154 : std_logic_vector (5 downto 0);
  signal n1155 : std_logic_vector (5 downto 0);
  signal n1156 : std_logic_vector (15 downto 0);
  signal n1157 : std_logic_vector (15 downto 0);
  signal n1159 : std_logic;
  signal n1160 : std_logic_vector (20 downto 0);
  signal n1166 : std_logic_vector (4 downto 0);
  signal n1168 : std_logic;
  signal n1169 : std_logic_vector (15 downto 0);
  signal n1170 : std_logic;
  signal n1171 : std_logic;
  signal n1172 : std_logic_vector (20 downto 0);
  signal n1174 : std_logic_vector (20 downto 0);
  signal n1175 : std_logic_vector (20 downto 0);
  signal n1177 : std_logic_vector (20 downto 0);
  signal n1178 : std_logic_vector (20 downto 0);
  signal n1181 : std_logic;
  signal n1182 : std_logic_vector (15 downto 0);
  signal n1184 : std_logic;
  signal n1187 : std_logic_vector (5 downto 0);
  signal n1188 : std_logic_vector (5 downto 0);
  signal n1189 : std_logic_vector (5 downto 0);
  signal n1190 : std_logic_vector (20 downto 0);
  signal n1191 : std_logic_vector (20 downto 0);
  signal n1194 : std_logic;
  signal n1196 : std_logic;
  signal n1198 : std_logic;
  signal n1200 : std_logic_vector (20 downto 0);
  signal n1201 : std_logic;
  signal n1204 : std_logic;
  signal n1207 : std_logic;
  signal n1209 : std_logic;
  signal n1211 : std_logic_vector (5 downto 0);
  signal n1212 : std_logic_vector (5 downto 0);
  signal n1213 : std_logic_vector (15 downto 0);
  signal n1214 : std_logic_vector (15 downto 0);
  signal n1216 : std_logic;
  signal n1219 : std_logic;
  signal n1221 : std_logic_vector (31 downto 0);
  signal n1223 : std_logic;
  signal n1225 : std_logic_vector (31 downto 0);
  signal n1227 : std_logic;
  signal n1228 : std_logic_vector (31 downto 0);
  signal n1229 : std_logic;
  signal n1233 : std_logic;
  signal n1234 : std_logic_vector (5 downto 0);
  signal n1235 : std_logic_vector (5 downto 0);
  signal n1239 : std_logic;
  signal n1240 : std_logic_vector (5 downto 0);
  signal n1241 : std_logic_vector (15 downto 0);
  signal n1242 : std_logic_vector (15 downto 0);
  signal n1244 : std_logic;
  signal n1245 : std_logic_vector (31 downto 0);
  signal n1247 : std_logic_vector (5 downto 0);
  signal n1248 : std_logic_vector (5 downto 0);
  signal n1249 : std_logic_vector (15 downto 0);
  signal n1250 : std_logic_vector (15 downto 0);
  signal n1252 : std_logic;
  signal n1254 : std_logic;
  signal n1256 : std_logic_vector (15 downto 0);
  signal n1258 : std_logic_vector (15 downto 0);
  signal n1259 : std_logic_vector (15 downto 0);
  signal n1260 : std_logic_vector (15 downto 0);
  signal n1261 : std_logic;
  signal n1263 : std_logic_vector (15 downto 0);
  signal n1265 : std_logic_vector (15 downto 0);
  signal n1266 : std_logic_vector (15 downto 0);
  signal n1267 : std_logic_vector (15 downto 0);
  signal n1269 : std_logic;
  signal n1270 : std_logic_vector (33 downto 0);
  signal n1271 : std_logic_vector (20 downto 0);
  signal n1273 : std_logic;
  signal n1276 : std_logic;
  signal n1279 : std_logic;
  signal n1284 : std_logic;
  signal n1287 : std_logic;
  signal n1289 : std_logic_vector (5 downto 0);
  signal n1290 : std_logic_vector (5 downto 0);
  signal n1291 : std_logic_vector (15 downto 0);
  signal n1292 : std_logic_vector (15 downto 0);
  signal n1293 : std_logic_vector (1 downto 0);
  signal n1294 : std_logic_vector (1 downto 0);
  signal n1295 : std_logic_vector (14 downto 0);
  signal n1296 : std_logic_vector (14 downto 0);
  signal n1297 : std_logic_vector (14 downto 0);
  signal n1298 : std_logic_vector (14 downto 0);
  signal n1299 : std_logic_vector (14 downto 0);
  signal n1300 : std_logic_vector (14 downto 0);
  signal n1301 : std_logic_vector (14 downto 0);
  signal n1302 : std_logic_vector (14 downto 0);
  signal n1303 : std_logic_vector (20 downto 0);
  signal n1304 : std_logic_vector (20 downto 0);
  signal n1305 : std_logic_vector (15 downto 0);
  signal n1306 : std_logic_vector (15 downto 0);
  signal n1307 : std_logic_vector (20 downto 0);
  signal n1308 : std_logic_vector (20 downto 0);
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
  signal n1326 : std_logic_vector (15 downto 0);
  signal n1327 : std_logic_vector (15 downto 0);
  signal n1328 : std_logic_vector (15 downto 0);
  signal n1329 : std_logic_vector (15 downto 0);
  signal n1330 : std_logic_vector (15 downto 0);
  signal n1331 : std_logic_vector (15 downto 0);
  signal n1332 : std_logic_vector (15 downto 0);
  signal n1333 : std_logic_vector (15 downto 0);
  signal n1334 : std_logic_vector (15 downto 0);
  signal n1335 : std_logic_vector (7 downto 0);
  signal n1336 : std_logic_vector (7 downto 0);
  signal n1337 : std_logic_vector (7 downto 0);
  signal n1338 : std_logic_vector (7 downto 0);
  signal n1339 : std_logic_vector (61 downto 0);
  signal n1340 : std_logic_vector (61 downto 0);
  signal n1341 : std_logic_vector (7 downto 0);
  signal n1342 : std_logic_vector (7 downto 0);
  signal n1343 : std_logic_vector (1 downto 0);
  signal n1344 : std_logic_vector (1 downto 0);
  signal n1365 : std_logic;
  signal n1368 : std_logic;
  signal n1371 : std_logic;
  signal n1374 : std_logic_vector (7 downto 0);
  signal n1377 : std_logic_vector (31 downto 0);
  signal n1382 : std_logic;
  signal n1385 : std_logic;
  signal n1388 : std_logic_vector (20 downto 0);
  signal n1391 : std_logic_vector (15 downto 0);
  signal n1394 : std_logic;
  signal n1398 : std_logic;
  signal n1401 : std_logic;
  signal n1404 : std_logic;
  signal n1409 : std_logic_vector (20 downto 0);
  signal n1411 : std_logic_vector (15 downto 0);
  signal n1414 : std_logic;
  signal n1416 : std_logic;
  signal n1417 : std_logic_vector (20 downto 0);
  signal n1419 : std_logic_vector (15 downto 0);
  signal n1422 : std_logic;
  signal n1424 : std_logic;
  signal gfx_circle_inst_c_busy : std_logic;
  signal gfx_circle_inst_c_pixel_valid : std_logic;
  signal gfx_circle_inst_c_pixel_x : std_logic_vector (15 downto 0);
  signal gfx_circle_inst_c_pixel_y : std_logic_vector (15 downto 0);
  signal n1428 : std_logic_vector (31 downto 0);
  signal n1429 : std_logic_vector (15 downto 0);
  signal n1430 : std_logic_vector (15 downto 0);
  signal n1432 : std_logic_vector (31 downto 0);
  signal pw_c_wr_in_progress : std_logic;
  signal pw_c_stall : std_logic;
  signal pw_c_oob : std_logic;
  signal pw_c_vram_wr_addr : std_logic_vector (20 downto 0);
  signal pw_c_vram_wr_data : std_logic_vector (15 downto 0);
  signal pw_c_vram_wr : std_logic;
  signal pw_c_vram_wr_access_mode : std_logic;
  signal n1435 : std_logic_vector (61 downto 0);
  signal n1436 : std_logic_vector (31 downto 0);
  signal n1437 : std_logic_vector (14 downto 0);
  signal n1438 : std_logic_vector (14 downto 0);
  signal n1439 : std_logic_vector (15 downto 0);
  signal n1440 : std_logic_vector (15 downto 0);
  signal n1442 : std_logic_vector (7 downto 0);
  signal n1448 : std_logic_vector (1 downto 0);
  signal n1449 : std_logic_vector (7 downto 0);
  signal n1450 : std_logic_vector (7 downto 0);
  signal n1452 : std_logic;
  signal n1453 : std_logic_vector (7 downto 0);
  signal n1454 : std_logic_vector (7 downto 0);
  signal n1456 : std_logic;
  signal n1457 : std_logic_vector (7 downto 0);
  signal n1458 : std_logic_vector (7 downto 0);
  signal n1460 : std_logic;
  signal n1461 : std_logic_vector (2 downto 0);
  signal n1466 : std_logic;
  signal n1474 : std_logic_vector (7 downto 0);
  signal n1479 : std_logic_vector (7 downto 0);
  signal pr_c_color : std_logic_vector (7 downto 0);
  signal pr_c_color_valid : std_logic;
  signal pr_c_vram_rd_addr : std_logic_vector (20 downto 0);
  signal pr_c_vram_rd : std_logic;
  signal pr_c_vram_rd_access_mode : std_logic;
  signal n1485 : std_logic_vector (31 downto 0);
  signal n1486 : std_logic_vector (14 downto 0);
  signal n1487 : std_logic_vector (14 downto 0);
  signal n1488 : std_logic_vector (14 downto 0);
  signal n1489 : std_logic_vector (14 downto 0);
  signal n1490 : std_logic_vector (14 downto 0);
  signal n1491 : std_logic_vector (14 downto 0);
  signal n1497 : std_logic_vector (63 downto 0);
  signal n1498 : std_logic_vector (309 downto 0);
  signal n1499 : std_logic_vector (309 downto 0);
  signal n1501 : std_logic_vector (61 downto 0);
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
  wrap_vram_wr_addr <= n1417;
  wrap_vram_wr_data <= n1419;
  wrap_vram_wr <= n1422;
  wrap_vram_wr_access_mode <= n1424;
  wrap_vram_rd_addr <= n1271;
  wrap_vram_rd <= n1273;
  wrap_vram_rd_access_mode <= n1276;
  wrap_fr_base_addr <= n108;
  wrap_gcf_rd <= n1279;
  wrap_rd_data <= n107;
  wrap_rd_valid <= n1284;
  wrap_frame_sync <= n1287;
  operand_buffer <= n1497; -- (signal)
  state <= n1498; -- (signal)
  state_nxt <= n1499; -- (signal)
  bdt_wr <= n1365; -- (signal)
  bdt_rd <= n1368; -- (signal)
  stall <= pw_c_stall; -- (signal)
  pw_wr <= n1371; -- (signal)
  pw_color <= n1374; -- (signal)
  pw_position <= n1377; -- (signal)
  pw_alpha_mode <= n1382; -- (signal)
  pw_oob <= pw_c_oob; -- (signal)
  pw_vram_wr_addr <= pw_c_vram_wr_addr; -- (signal)
  pw_vram_wr_data <= pw_c_vram_wr_data; -- (signal)
  pw_vram_wr <= pw_c_vram_wr; -- (signal)
  pw_vram_wr_access_mode <= pw_c_vram_wr_access_mode; -- (signal)
  direct_vram_wr <= n1385; -- (signal)
  direct_vram_wr_addr <= n1388; -- (signal)
  direct_vram_wr_data <= n1391; -- (signal)
  direct_vram_wr_access_mode <= n1394; -- (signal)
  pr_start <= n1398; -- (signal)
  pr_color <= pr_c_color; -- (signal)
  pr_color_valid <= pr_c_color_valid; -- (signal)
  pr_color_ack <= n1401; -- (signal)
  pr_vram_rd_addr <= pr_c_vram_rd_addr; -- (signal)
  pr_vram_rd <= pr_c_vram_rd; -- (signal)
  pr_vram_rd_access_mode <= pr_c_vram_rd_access_mode; -- (signal)
  circle_start <= n1404; -- (signal)
  circle_busy <= gfx_circle_inst_c_busy; -- (signal)
  circle_pixel_valid <= gfx_circle_inst_c_pixel_valid; -- (signal)
  circle_pixel <= n1432; -- (signal)
  instr_color <= n115; -- (signal)
  current_instr <= n12; -- (signal)
  bdt_bmpidx <= n1501; -- (signal)
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
  n75 <= operands_buffer_operand_buffer_int when n1279 = '0' else n69;
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
  n1135 <= '1' when n1133 = "01111" else '0';
  n1136 <= n1127 or n1135;
  n1142 <= current_instr (15 downto 11);
  n1144 <= '1' when n1142 = "01110" else '0';
  n1147 <= '0' when n1144 = '0' else '1';
  n1148 <= state (157 downto 142);
  n1150 <= std_logic_vector (unsigned (n1148) - unsigned'("0000000000000001"));
  n1153 <= '0' when n1136 = '0' else n1147;
  n1154 <= state (5 downto 0);
  n1155 <= n1154 when n1136 = '0' else "010010";
  n1156 <= state (157 downto 142);
  n1157 <= n1156 when n1136 = '0' else n1150;
  n1159 <= '1' when n125 = "010001" else '0';
  n1160 <= state (141 downto 121);
  n1166 <= current_instr (15 downto 11);
  n1168 <= '1' when n1166 = "01110" else '0';
  n1169 <= data when n1168 = '0' else wrap_gcf_data;
  n1170 <= not wrap_vram_wr_full;
  n1171 <= current_instr (0);
  n1172 <= state (141 downto 121);
  n1174 <= std_logic_vector (unsigned (n1172) + unsigned'("000000000000000000010"));
  n1175 <= state (141 downto 121);
  n1177 <= std_logic_vector (unsigned (n1175) + unsigned'("000000000000000000001"));
  n1178 <= n1177 when n1171 = '0' else n1174;
  n1181 <= '0' when n1171 = '0' else '1';
  n1182 <= state (157 downto 142);
  n1184 <= '1' when n1182 = "0000000000000000" else '0';
  n1187 <= "010001" when n1184 = '0' else "000000";
  n1188 <= state (5 downto 0);
  n1189 <= n1188 when n1170 = '0' else n1187;
  n1190 <= state (141 downto 121);
  n1191 <= n1190 when n1170 = '0' else n1178;
  n1194 <= '0' when n1170 = '0' else '1';
  n1196 <= '1' when n1170 = '0' else n1181;
  n1198 <= '1' when n125 = "010010" else '0';
  n1200 <= addrhi & addrlo;
  n1201 <= current_instr (0);
  n1204 <= '0' when n1201 = '0' else '1';
  n1207 <= '0' when wrap_vram_wr_emtpy = '0' else '1';
  n1209 <= '1' when n125 = "001100" else '0';
  n1211 <= state (5 downto 0);
  n1212 <= n1211 when wrap_vram_rd_valid = '0' else "001110";
  n1213 <= state (120 downto 105);
  n1214 <= n1213 when wrap_vram_rd_valid = '0' else wrap_vram_rd_data;
  n1216 <= '1' when n125 = "001101" else '0';
  n1219 <= '1' when n125 = "001110" else '0';
  n1221 <= state (221 downto 190);
  n1223 <= '1' when n125 = "011010" else '0';
  n1225 <= state (221 downto 190);
  n1227 <= '1' when n125 = "011011" else '0';
  n1228 <= state (221 downto 190);
  n1229 <= not pw_oob;
  n1233 <= '0' when wrap_vram_wr_emtpy = '0' else '1';
  n1234 <= state (5 downto 0);
  n1235 <= n1234 when wrap_vram_wr_emtpy = '0' else "011101";
  n1239 <= '0' when n1229 = '0' else n1233;
  n1240 <= "011110" when n1229 = '0' else n1235;
  n1241 <= state (120 downto 105);
  n1242 <= "1111111111111111" when n1229 = '0' else n1241;
  n1244 <= '1' when n125 = "011100" else '0';
  n1245 <= state (221 downto 190);
  n1247 <= state (5 downto 0);
  n1248 <= n1247 when wrap_vram_rd_valid = '0' else "011110";
  n1249 <= state (120 downto 105);
  n1250 <= n1249 when wrap_vram_rd_valid = '0' else wrap_vram_rd_data;
  n1252 <= '1' when n125 = "011101" else '0';
  n1254 <= current_instr (4);
  n1256 <= state (205 downto 190);
  n1258 <= std_logic_vector (unsigned (n1256) + unsigned'("0000000000000001"));
  n1259 <= state (205 downto 190);
  n1260 <= n1259 when n1254 = '0' else n1258;
  n1261 <= current_instr (5);
  n1263 <= state (221 downto 206);
  n1265 <= std_logic_vector (unsigned (n1263) + unsigned'("0000000000000001"));
  n1266 <= state (221 downto 206);
  n1267 <= n1266 when n1261 = '0' else n1265;
  n1269 <= '1' when n125 = "011110" else '0';
  n1270 <= n1269 & n1252 & n1244 & n1227 & n1223 & n1219 & n1216 & n1209 & n1198 & n1159 & n1126 & n1122 & n1118 & n1097 & n1041 & n846 & n838 & n782 & n773 & n695 & n690 & n612 & n607 & n536 & n532 & n512 & n464 & n461 & n454 & n443 & n434 & n372 & n351 & n134;
  with n1270 select n1271 <=
    pw_vram_wr_addr when "1000000000000000000000000000000000",
    pw_vram_wr_addr when "0100000000000000000000000000000000",
    pw_vram_wr_addr when "0010000000000000000000000000000000",
    pw_vram_wr_addr when "0001000000000000000000000000000000",
    pw_vram_wr_addr when "0000100000000000000000000000000000",
    pw_vram_wr_addr when "0000010000000000000000000000000000",
    pw_vram_wr_addr when "0000001000000000000000000000000000",
    n1200 when "0000000100000000000000000000000000",
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
  with n1270 select n1273 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    n1239 when "0010000000000000000000000000000000",
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
  with n1270 select n1276 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    n1204 when "0000000100000000000000000000000000",
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
  with n1270 select n1279 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    n1153 when "0000000001000000000000000000000000",
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
  with n1270 select n1284 <=
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
  with n1270 select n1287 <=
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
  n1289 <= state (5 downto 0);
  with n1270 select n1290 <=
    "000000" when "1000000000000000000000000000000000",
    n1248 when "0100000000000000000000000000000000",
    n1240 when "0010000000000000000000000000000000",
    "011100" when "0001000000000000000000000000000000",
    "011011" when "0000100000000000000000000000000000",
    "000000" when "0000010000000000000000000000000000",
    n1212 when "0000001000000000000000000000000000",
    "001101" when "0000000100000000000000000000000000",
    n1189 when "0000000010000000000000000000000000",
    n1155 when "0000000001000000000000000000000000",
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
    n1289 when others;
  n1291 <= state (21 downto 6);
  with n1270 select n1292 <=
    n1291 when "1000000000000000000000000000000000",
    n1291 when "0100000000000000000000000000000000",
    n1291 when "0010000000000000000000000000000000",
    n1291 when "0001000000000000000000000000000000",
    n1291 when "0000100000000000000000000000000000",
    n1291 when "0000010000000000000000000000000000",
    n1291 when "0000001000000000000000000000000000",
    n1291 when "0000000100000000000000000000000000",
    n1291 when "0000000010000000000000000000000000",
    n1291 when "0000000001000000000000000000000000",
    n1291 when "0000000000100000000000000000000000",
    n1291 when "0000000000010000000000000000000000",
    n1291 when "0000000000001000000000000000000000",
    n1291 when "0000000000000100000000000000000000",
    n1291 when "0000000000000010000000000000000000",
    n1291 when "0000000000000001000000000000000000",
    n1291 when "0000000000000000100000000000000000",
    n1291 when "0000000000000000010000000000000000",
    n1291 when "0000000000000000001000000000000000",
    n1291 when "0000000000000000000100000000000000",
    n1291 when "0000000000000000000010000000000000",
    n1291 when "0000000000000000000001000000000000",
    n1291 when "0000000000000000000000100000000000",
    n1291 when "0000000000000000000000010000000000",
    n1291 when "0000000000000000000000001000000000",
    n1291 when "0000000000000000000000000100000000",
    n1291 when "0000000000000000000000000010000000",
    n1291 when "0000000000000000000000000001000000",
    n1291 when "0000000000000000000000000000100000",
    n1291 when "0000000000000000000000000000010000",
    n1291 when "0000000000000000000000000000001000",
    n1291 when "0000000000000000000000000000000100",
    wrap_gcf_data when "0000000000000000000000000000000010",
    n1291 when "0000000000000000000000000000000001",
    n1291 when others;
  n1293 <= state (23 downto 22);
  with n1270 select n1294 <=
    n1293 when "1000000000000000000000000000000000",
    n1293 when "0100000000000000000000000000000000",
    n1293 when "0010000000000000000000000000000000",
    n1293 when "0001000000000000000000000000000000",
    n1293 when "0000100000000000000000000000000000",
    n1293 when "0000010000000000000000000000000000",
    n1293 when "0000001000000000000000000000000000",
    n1293 when "0000000100000000000000000000000000",
    n1293 when "0000000010000000000000000000000000",
    n1293 when "0000000001000000000000000000000000",
    n1293 when "0000000000100000000000000000000000",
    n1293 when "0000000000010000000000000000000000",
    n1293 when "0000000000001000000000000000000000",
    n1293 when "0000000000000100000000000000000000",
    n1293 when "0000000000000010000000000000000000",
    n1293 when "0000000000000001000000000000000000",
    n1293 when "0000000000000000100000000000000000",
    n1293 when "0000000000000000010000000000000000",
    n1293 when "0000000000000000001000000000000000",
    n1293 when "0000000000000000000100000000000000",
    n1293 when "0000000000000000000010000000000000",
    n1293 when "0000000000000000000001000000000000",
    n1293 when "0000000000000000000000100000000000",
    n1293 when "0000000000000000000000010000000000",
    n1293 when "0000000000000000000000001000000000",
    n1293 when "0000000000000000000000000100000000",
    n1293 when "0000000000000000000000000010000000",
    n1293 when "0000000000000000000000000001000000",
    n1293 when "0000000000000000000000000000100000",
    n1293 when "0000000000000000000000000000010000",
    n1293 when "0000000000000000000000000000001000",
    n370 when "0000000000000000000000000000000100",
    n314 when "0000000000000000000000000000000010",
    n1293 when "0000000000000000000000000000000001",
    n1293 when others;
  n1295 <= state (38 downto 24);
  with n1270 select n1296 <=
    n1295 when "1000000000000000000000000000000000",
    n1295 when "0100000000000000000000000000000000",
    n1295 when "0010000000000000000000000000000000",
    n1295 when "0001000000000000000000000000000000",
    n1295 when "0000100000000000000000000000000000",
    n1295 when "0000010000000000000000000000000000",
    n1295 when "0000001000000000000000000000000000",
    n1295 when "0000000100000000000000000000000000",
    n1295 when "0000000010000000000000000000000000",
    n1295 when "0000000001000000000000000000000000",
    n1295 when "0000000000100000000000000000000000",
    n1295 when "0000000000010000000000000000000000",
    n1295 when "0000000000001000000000000000000000",
    n1295 when "0000000000000100000000000000000000",
    n1295 when "0000000000000010000000000000000000",
    n1295 when "0000000000000001000000000000000000",
    n1295 when "0000000000000000100000000000000000",
    n1295 when "0000000000000000010000000000000000",
    n1295 when "0000000000000000001000000000000000",
    n1295 when "0000000000000000000100000000000000",
    n1295 when "0000000000000000000010000000000000",
    n1295 when "0000000000000000000001000000000000",
    n1295 when "0000000000000000000000100000000000",
    n1295 when "0000000000000000000000010000000000",
    n1295 when "0000000000000000000000001000000000",
    n1295 when "0000000000000000000000000100000000",
    n1295 when "0000000000000000000000000010000000",
    "000000000000000" when "0000000000000000000000000001000000",
    n446 when "0000000000000000000000000000100000",
    n437 when "0000000000000000000000000000010000",
    n1295 when "0000000000000000000000000000001000",
    n1295 when "0000000000000000000000000000000100",
    n1295 when "0000000000000000000000000000000010",
    n1295 when "0000000000000000000000000000000001",
    n1295 when others;
  n1297 <= state (53 downto 39);
  with n1270 select n1298 <=
    n1297 when "1000000000000000000000000000000000",
    n1297 when "0100000000000000000000000000000000",
    n1297 when "0010000000000000000000000000000000",
    n1297 when "0001000000000000000000000000000000",
    n1297 when "0000100000000000000000000000000000",
    n1297 when "0000010000000000000000000000000000",
    n1297 when "0000001000000000000000000000000000",
    n1297 when "0000000100000000000000000000000000",
    n1297 when "0000000010000000000000000000000000",
    n1297 when "0000000001000000000000000000000000",
    n1297 when "0000000000100000000000000000000000",
    n1297 when "0000000000010000000000000000000000",
    n1297 when "0000000000001000000000000000000000",
    n1297 when "0000000000000100000000000000000000",
    n1297 when "0000000000000010000000000000000000",
    n1297 when "0000000000000001000000000000000000",
    n1297 when "0000000000000000100000000000000000",
    n1297 when "0000000000000000010000000000000000",
    n1297 when "0000000000000000001000000000000000",
    n1297 when "0000000000000000000100000000000000",
    n1297 when "0000000000000000000010000000000000",
    n1297 when "0000000000000000000001000000000000",
    n1297 when "0000000000000000000000100000000000",
    n1297 when "0000000000000000000000010000000000",
    n1297 when "0000000000000000000000001000000000",
    n1297 when "0000000000000000000000000100000000",
    n1297 when "0000000000000000000000000010000000",
    "000000000000000" when "0000000000000000000000000001000000",
    n448 when "0000000000000000000000000000100000",
    "000000000000000" when "0000000000000000000000000000010000",
    n1297 when "0000000000000000000000000000001000",
    n1297 when "0000000000000000000000000000000100",
    n1297 when "0000000000000000000000000000000010",
    n1297 when "0000000000000000000000000000000001",
    n1297 when others;
  n1299 <= state (68 downto 54);
  with n1270 select n1300 <=
    n1299 when "1000000000000000000000000000000000",
    n1299 when "0100000000000000000000000000000000",
    n1299 when "0010000000000000000000000000000000",
    n1299 when "0001000000000000000000000000000000",
    n1299 when "0000100000000000000000000000000000",
    n1299 when "0000010000000000000000000000000000",
    n1299 when "0000001000000000000000000000000000",
    n1299 when "0000000100000000000000000000000000",
    n1299 when "0000000010000000000000000000000000",
    n1299 when "0000000001000000000000000000000000",
    n1299 when "0000000000100000000000000000000000",
    n1299 when "0000000000010000000000000000000000",
    n1299 when "0000000000001000000000000000000000",
    n1299 when "0000000000000100000000000000000000",
    n1299 when "0000000000000010000000000000000000",
    n1299 when "0000000000000001000000000000000000",
    n1299 when "0000000000000000100000000000000000",
    n1299 when "0000000000000000010000000000000000",
    n1299 when "0000000000000000001000000000000000",
    n1299 when "0000000000000000000100000000000000",
    n1299 when "0000000000000000000010000000000000",
    n1299 when "0000000000000000000001000000000000",
    n1299 when "0000000000000000000000100000000000",
    n1299 when "0000000000000000000000010000000000",
    n1299 when "0000000000000000000000001000000000",
    n1299 when "0000000000000000000000000100000000",
    n1299 when "0000000000000000000000000010000000",
    n458 when "0000000000000000000000000001000000",
    n450 when "0000000000000000000000000000100000",
    n440 when "0000000000000000000000000000010000",
    n1299 when "0000000000000000000000000000001000",
    n1299 when "0000000000000000000000000000000100",
    n1299 when "0000000000000000000000000000000010",
    n1299 when "0000000000000000000000000000000001",
    n1299 when others;
  n1301 <= state (83 downto 69);
  with n1270 select n1302 <=
    n1301 when "1000000000000000000000000000000000",
    n1301 when "0100000000000000000000000000000000",
    n1301 when "0010000000000000000000000000000000",
    n1301 when "0001000000000000000000000000000000",
    n1301 when "0000100000000000000000000000000000",
    n1301 when "0000010000000000000000000000000000",
    n1301 when "0000001000000000000000000000000000",
    n1301 when "0000000100000000000000000000000000",
    n1301 when "0000000010000000000000000000000000",
    n1301 when "0000000001000000000000000000000000",
    n1301 when "0000000000100000000000000000000000",
    n1301 when "0000000000010000000000000000000000",
    n1301 when "0000000000001000000000000000000000",
    n1301 when "0000000000000100000000000000000000",
    n1301 when "0000000000000010000000000000000000",
    n1301 when "0000000000000001000000000000000000",
    n1301 when "0000000000000000100000000000000000",
    n1301 when "0000000000000000010000000000000000",
    n1301 when "0000000000000000001000000000000000",
    n1301 when "0000000000000000000100000000000000",
    n1301 when "0000000000000000000010000000000000",
    n1301 when "0000000000000000000001000000000000",
    n1301 when "0000000000000000000000100000000000",
    n1301 when "0000000000000000000000010000000000",
    n1301 when "0000000000000000000000001000000000",
    n1301 when "0000000000000000000000000100000000",
    n1301 when "0000000000000000000000000010000000",
    n459 when "0000000000000000000000000001000000",
    n452 when "0000000000000000000000000000100000",
    n441 when "0000000000000000000000000000010000",
    n1301 when "0000000000000000000000000000001000",
    n1301 when "0000000000000000000000000000000100",
    n1301 when "0000000000000000000000000000000010",
    n1301 when "0000000000000000000000000000000001",
    n1301 when others;
  n1303 <= state (104 downto 84);
  with n1270 select n1304 <=
    n1303 when "1000000000000000000000000000000000",
    n1303 when "0100000000000000000000000000000000",
    n1303 when "0010000000000000000000000000000000",
    n1303 when "0001000000000000000000000000000000",
    n1303 when "0000100000000000000000000000000000",
    n1303 when "0000010000000000000000000000000000",
    n1303 when "0000001000000000000000000000000000",
    n1303 when "0000000100000000000000000000000000",
    n1303 when "0000000010000000000000000000000000",
    n1303 when "0000000001000000000000000000000000",
    n1303 when "0000000000100000000000000000000000",
    n1303 when "0000000000010000000000000000000000",
    n1303 when "0000000000001000000000000000000000",
    n1303 when "0000000000000100000000000000000000",
    n1303 when "0000000000000010000000000000000000",
    n1303 when "0000000000000001000000000000000000",
    n1303 when "0000000000000000100000000000000000",
    n1303 when "0000000000000000010000000000000000",
    n1303 when "0000000000000000001000000000000000",
    n1303 when "0000000000000000000100000000000000",
    n1303 when "0000000000000000000010000000000000",
    n1303 when "0000000000000000000001000000000000",
    n1303 when "0000000000000000000000100000000000",
    n1303 when "0000000000000000000000010000000000",
    n530 when "0000000000000000000000001000000000",
    n1303 when "0000000000000000000000000100000000",
    n1303 when "0000000000000000000000000010000000",
    n1303 when "0000000000000000000000000001000000",
    n1303 when "0000000000000000000000000000100000",
    n1303 when "0000000000000000000000000000010000",
    n1303 when "0000000000000000000000000000001000",
    n1303 when "0000000000000000000000000000000100",
    n1303 when "0000000000000000000000000000000010",
    n1303 when "0000000000000000000000000000000001",
    n1303 when others;
  n1305 <= state (120 downto 105);
  with n1270 select n1306 <=
    n1305 when "1000000000000000000000000000000000",
    n1250 when "0100000000000000000000000000000000",
    n1242 when "0010000000000000000000000000000000",
    n1305 when "0001000000000000000000000000000000",
    n1305 when "0000100000000000000000000000000000",
    n1305 when "0000010000000000000000000000000000",
    n1214 when "0000001000000000000000000000000000",
    n1305 when "0000000100000000000000000000000000",
    n1305 when "0000000010000000000000000000000000",
    n1305 when "0000000001000000000000000000000000",
    n1305 when "0000000000100000000000000000000000",
    n1305 when "0000000000010000000000000000000000",
    n1305 when "0000000000001000000000000000000000",
    n1305 when "0000000000000100000000000000000000",
    n1305 when "0000000000000010000000000000000000",
    n1305 when "0000000000000001000000000000000000",
    n1305 when "0000000000000000100000000000000000",
    n1305 when "0000000000000000010000000000000000",
    n1305 when "0000000000000000001000000000000000",
    n1305 when "0000000000000000000100000000000000",
    n1305 when "0000000000000000000010000000000000",
    n1305 when "0000000000000000000001000000000000",
    n1305 when "0000000000000000000000100000000000",
    n1305 when "0000000000000000000000010000000000",
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
  n1307 <= state (141 downto 121);
  with n1270 select n1308 <=
    n1307 when "1000000000000000000000000000000000",
    n1307 when "0100000000000000000000000000000000",
    n1307 when "0010000000000000000000000000000000",
    n1307 when "0001000000000000000000000000000000",
    n1307 when "0000100000000000000000000000000000",
    n1307 when "0000010000000000000000000000000000",
    n1307 when "0000001000000000000000000000000000",
    n1307 when "0000000100000000000000000000000000",
    n1191 when "0000000010000000000000000000000000",
    n1307 when "0000000001000000000000000000000000",
    n1123 when "0000000000100000000000000000000000",
    n1119 when "0000000000010000000000000000000000",
    n1307 when "0000000000001000000000000000000000",
    n1307 when "0000000000000100000000000000000000",
    n1307 when "0000000000000010000000000000000000",
    n1307 when "0000000000000001000000000000000000",
    n1307 when "0000000000000000100000000000000000",
    n1307 when "0000000000000000010000000000000000",
    n1307 when "0000000000000000001000000000000000",
    n1307 when "0000000000000000000100000000000000",
    n1307 when "0000000000000000000010000000000000",
    n1307 when "0000000000000000000001000000000000",
    n1307 when "0000000000000000000000100000000000",
    n1307 when "0000000000000000000000010000000000",
    n1307 when "0000000000000000000000001000000000",
    n1307 when "0000000000000000000000000100000000",
    n1307 when "0000000000000000000000000010000000",
    n1307 when "0000000000000000000000000001000000",
    n1307 when "0000000000000000000000000000100000",
    n1307 when "0000000000000000000000000000010000",
    n1307 when "0000000000000000000000000000001000",
    n1307 when "0000000000000000000000000000000100",
    n1307 when "0000000000000000000000000000000010",
    n1307 when "0000000000000000000000000000000001",
    n1307 when others;
  n1309 <= state (157 downto 142);
  with n1270 select n1310 <=
    n1309 when "1000000000000000000000000000000000",
    n1309 when "0100000000000000000000000000000000",
    n1309 when "0010000000000000000000000000000000",
    n1309 when "0001000000000000000000000000000000",
    n1309 when "0000100000000000000000000000000000",
    n1309 when "0000010000000000000000000000000000",
    n1309 when "0000001000000000000000000000000000",
    n1309 when "0000000100000000000000000000000000",
    n1309 when "0000000010000000000000000000000000",
    n1157 when "0000000001000000000000000000000000",
    n when "0000000000100000000000000000000000",
    n when "0000000000010000000000000000000000",
    n1309 when "0000000000001000000000000000000000",
    n1309 when "0000000000000100000000000000000000",
    n1309 when "0000000000000010000000000000000000",
    n1309 when "0000000000000001000000000000000000",
    n1309 when "0000000000000000100000000000000000",
    n1309 when "0000000000000000010000000000000000",
    n1309 when "0000000000000000001000000000000000",
    n1309 when "0000000000000000000100000000000000",
    n1309 when "0000000000000000000010000000000000",
    n1309 when "0000000000000000000001000000000000",
    n1309 when "0000000000000000000000100000000000",
    n1309 when "0000000000000000000000010000000000",
    n1309 when "0000000000000000000000001000000000",
    n1309 when "0000000000000000000000000100000000",
    n1309 when "0000000000000000000000000010000000",
    n1309 when "0000000000000000000000000001000000",
    n1309 when "0000000000000000000000000000100000",
    n1309 when "0000000000000000000000000000010000",
    n1309 when "0000000000000000000000000000001000",
    n1309 when "0000000000000000000000000000000100",
    n1309 when "0000000000000000000000000000000010",
    n1309 when "0000000000000000000000000000000001",
    n1309 when others;
  n1311 <= n533 (15 downto 0);
  n1312 <= n605 (15 downto 0);
  n1313 <= n1021 (15 downto 0);
  n1314 <= state (173 downto 158);
  with n1270 select n1315 <=
    n1314 when "1000000000000000000000000000000000",
    n1314 when "0100000000000000000000000000000000",
    n1314 when "0010000000000000000000000000000000",
    n1314 when "0001000000000000000000000000000000",
    n1314 when "0000100000000000000000000000000000",
    n1314 when "0000010000000000000000000000000000",
    n1314 when "0000001000000000000000000000000000",
    n1314 when "0000000100000000000000000000000000",
    n1314 when "0000000010000000000000000000000000",
    n1314 when "0000000001000000000000000000000000",
    n1314 when "0000000000100000000000000000000000",
    n1314 when "0000000000010000000000000000000000",
    n1314 when "0000000000001000000000000000000000",
    n1314 when "0000000000000100000000000000000000",
    n1313 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1314 when "0000000000000000100000000000000000",
    n1314 when "0000000000000000010000000000000000",
    n1314 when "0000000000000000001000000000000000",
    n1314 when "0000000000000000000100000000000000",
    n679 when "0000000000000000000010000000000000",
    n609 when "0000000000000000000001000000000000",
    n1312 when "0000000000000000000000100000000000",
    n1311 when "0000000000000000000000010000000000",
    n1314 when "0000000000000000000000001000000000",
    n1314 when "0000000000000000000000000100000000",
    n1314 when "0000000000000000000000000010000000",
    n1314 when "0000000000000000000000000001000000",
    n1314 when "0000000000000000000000000000100000",
    n1314 when "0000000000000000000000000000010000",
    n1314 when "0000000000000000000000000000001000",
    n1314 when "0000000000000000000000000000000100",
    n1314 when "0000000000000000000000000000000010",
    n1314 when "0000000000000000000000000000000001",
    n1314 when others;
  n1316 <= n533 (31 downto 16);
  n1317 <= n605 (31 downto 16);
  n1318 <= n1021 (31 downto 16);
  n1319 <= state (189 downto 174);
  with n1270 select n1320 <=
    n1319 when "1000000000000000000000000000000000",
    n1319 when "0100000000000000000000000000000000",
    n1319 when "0010000000000000000000000000000000",
    n1319 when "0001000000000000000000000000000000",
    n1319 when "0000100000000000000000000000000000",
    n1319 when "0000010000000000000000000000000000",
    n1319 when "0000001000000000000000000000000000",
    n1319 when "0000000100000000000000000000000000",
    n1319 when "0000000010000000000000000000000000",
    n1319 when "0000000001000000000000000000000000",
    n1319 when "0000000000100000000000000000000000",
    n1319 when "0000000000010000000000000000000000",
    n1319 when "0000000000001000000000000000000000",
    n1319 when "0000000000000100000000000000000000",
    n1318 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1319 when "0000000000000000100000000000000000",
    n1319 when "0000000000000000010000000000000000",
    n762 when "0000000000000000001000000000000000",
    n692 when "0000000000000000000100000000000000",
    n1319 when "0000000000000000000010000000000000",
    n1319 when "0000000000000000000001000000000000",
    n1317 when "0000000000000000000000100000000000",
    n1316 when "0000000000000000000000010000000000",
    n1319 when "0000000000000000000000001000000000",
    n1319 when "0000000000000000000000000100000000",
    n1319 when "0000000000000000000000000010000000",
    n1319 when "0000000000000000000000000001000000",
    n1319 when "0000000000000000000000000000100000",
    n1319 when "0000000000000000000000000000010000",
    n1319 when "0000000000000000000000000000001000",
    n1319 when "0000000000000000000000000000000100",
    n1319 when "0000000000000000000000000000000010",
    n1319 when "0000000000000000000000000000000001",
    n1319 when others;
  n1321 <= n429 (15 downto 0);
  n1322 <= n510 (15 downto 0);
  n1323 <= n681 (15 downto 0);
  n1324 <= n764 (15 downto 0);
  n1325 <= n836 (15 downto 0);
  n1326 <= state (205 downto 190);
  with n1270 select n1327 <=
    n1260 when "1000000000000000000000000000000000",
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
    n1073 when "0000000000000100000000000000000000",
    n1326 when "0000000000000010000000000000000000",
    n1326 when "0000000000000001000000000000000000",
    n1325 when "0000000000000000100000000000000000",
    n1326 when "0000000000000000010000000000000000",
    n1324 when "0000000000000000001000000000000000",
    n1326 when "0000000000000000000100000000000000",
    n1323 when "0000000000000000000010000000000000",
    n1326 when "0000000000000000000001000000000000",
    n1326 when "0000000000000000000000100000000000",
    n1326 when "0000000000000000000000010000000000",
    n1326 when "0000000000000000000000001000000000",
    n1322 when "0000000000000000000000000100000000",
    n1326 when "0000000000000000000000000010000000",
    n1326 when "0000000000000000000000000001000000",
    n1326 when "0000000000000000000000000000100000",
    n1326 when "0000000000000000000000000000010000",
    n1321 when "0000000000000000000000000000001000",
    n1326 when "0000000000000000000000000000000100",
    n316 when "0000000000000000000000000000000010",
    n1326 when "0000000000000000000000000000000001",
    n1326 when others;
  n1328 <= n429 (31 downto 16);
  n1329 <= n510 (31 downto 16);
  n1330 <= n681 (31 downto 16);
  n1331 <= n764 (31 downto 16);
  n1332 <= n836 (31 downto 16);
  n1333 <= state (221 downto 206);
  with n1270 select n1334 <=
    n1267 when "1000000000000000000000000000000000",
    n1333 when "0100000000000000000000000000000000",
    n1333 when "0010000000000000000000000000000000",
    n1333 when "0001000000000000000000000000000000",
    n1333 when "0000100000000000000000000000000000",
    n1333 when "0000010000000000000000000000000000",
    n1333 when "0000001000000000000000000000000000",
    n1333 when "0000000100000000000000000000000000",
    n1333 when "0000000010000000000000000000000000",
    n1333 when "0000000001000000000000000000000000",
    n1333 when "0000000000100000000000000000000000",
    n1333 when "0000000000010000000000000000000000",
    n1333 when "0000000000001000000000000000000000",
    n1094 when "0000000000000100000000000000000000",
    n1333 when "0000000000000010000000000000000000",
    n1333 when "0000000000000001000000000000000000",
    n1332 when "0000000000000000100000000000000000",
    n1333 when "0000000000000000010000000000000000",
    n1331 when "0000000000000000001000000000000000",
    n1333 when "0000000000000000000100000000000000",
    n1330 when "0000000000000000000010000000000000",
    n1333 when "0000000000000000000001000000000000",
    n1333 when "0000000000000000000000100000000000",
    n1333 when "0000000000000000000000010000000000",
    n1333 when "0000000000000000000000001000000000",
    n1329 when "0000000000000000000000000100000000",
    n1333 when "0000000000000000000000000010000000",
    n1333 when "0000000000000000000000000001000000",
    n1333 when "0000000000000000000000000000100000",
    n1333 when "0000000000000000000000000000010000",
    n1328 when "0000000000000000000000000000001000",
    n1333 when "0000000000000000000000000000000100",
    n318 when "0000000000000000000000000000000010",
    n1333 when "0000000000000000000000000000000001",
    n1333 when others;
  n1335 <= state (229 downto 222);
  with n1270 select n1336 <=
    n1335 when "1000000000000000000000000000000000",
    n1335 when "0100000000000000000000000000000000",
    n1335 when "0010000000000000000000000000000000",
    n1335 when "0001000000000000000000000000000000",
    n1335 when "0000100000000000000000000000000000",
    n1335 when "0000010000000000000000000000000000",
    n1335 when "0000001000000000000000000000000000",
    n1335 when "0000000100000000000000000000000000",
    n1335 when "0000000010000000000000000000000000",
    n1335 when "0000000001000000000000000000000000",
    n1335 when "0000000000100000000000000000000000",
    n1335 when "0000000000010000000000000000000000",
    n1335 when "0000000000001000000000000000000000",
    n1335 when "0000000000000100000000000000000000",
    n1335 when "0000000000000010000000000000000000",
    n1335 when "0000000000000001000000000000000000",
    n1335 when "0000000000000000100000000000000000",
    n1335 when "0000000000000000010000000000000000",
    n1335 when "0000000000000000001000000000000000",
    n1335 when "0000000000000000000100000000000000",
    n1335 when "0000000000000000000010000000000000",
    n1335 when "0000000000000000000001000000000000",
    n1335 when "0000000000000000000000100000000000",
    n1335 when "0000000000000000000000010000000000",
    n1335 when "0000000000000000000000001000000000",
    n1335 when "0000000000000000000000000100000000",
    n1335 when "0000000000000000000000000010000000",
    n1335 when "0000000000000000000000000001000000",
    n1335 when "0000000000000000000000000000100000",
    n1335 when "0000000000000000000000000000010000",
    n1335 when "0000000000000000000000000000001000",
    n1335 when "0000000000000000000000000000000100",
    n320 when "0000000000000000000000000000000010",
    n1335 when "0000000000000000000000000000000001",
    n1335 when others;
  n1337 <= state (237 downto 230);
  with n1270 select n1338 <=
    n1337 when "1000000000000000000000000000000000",
    n1337 when "0100000000000000000000000000000000",
    n1337 when "0010000000000000000000000000000000",
    n1337 when "0001000000000000000000000000000000",
    n1337 when "0000100000000000000000000000000000",
    n1337 when "0000010000000000000000000000000000",
    n1337 when "0000001000000000000000000000000000",
    n1337 when "0000000100000000000000000000000000",
    n1337 when "0000000010000000000000000000000000",
    n1337 when "0000000001000000000000000000000000",
    n1337 when "0000000000100000000000000000000000",
    n1337 when "0000000000010000000000000000000000",
    n1337 when "0000000000001000000000000000000000",
    n1337 when "0000000000000100000000000000000000",
    n1337 when "0000000000000010000000000000000000",
    n1337 when "0000000000000001000000000000000000",
    n1337 when "0000000000000000100000000000000000",
    n1337 when "0000000000000000010000000000000000",
    n1337 when "0000000000000000001000000000000000",
    n1337 when "0000000000000000000100000000000000",
    n1337 when "0000000000000000000010000000000000",
    n1337 when "0000000000000000000001000000000000",
    n1337 when "0000000000000000000000100000000000",
    n1337 when "0000000000000000000000010000000000",
    n1337 when "0000000000000000000000001000000000",
    n1337 when "0000000000000000000000000100000000",
    n1337 when "0000000000000000000000000010000000",
    n1337 when "0000000000000000000000000001000000",
    n1337 when "0000000000000000000000000000100000",
    n1337 when "0000000000000000000000000000010000",
    n1337 when "0000000000000000000000000000001000",
    n1337 when "0000000000000000000000000000000100",
    n322 when "0000000000000000000000000000000010",
    n1337 when "0000000000000000000000000000000001",
    n1337 when others;
  n1339 <= state (299 downto 238);
  with n1270 select n1340 <=
    n1339 when "1000000000000000000000000000000000",
    n1339 when "0100000000000000000000000000000000",
    n1339 when "0010000000000000000000000000000000",
    n1339 when "0001000000000000000000000000000000",
    n1339 when "0000100000000000000000000000000000",
    n1339 when "0000010000000000000000000000000000",
    n1339 when "0000001000000000000000000000000000",
    n1339 when "0000000100000000000000000000000000",
    n1339 when "0000000010000000000000000000000000",
    n1339 when "0000000001000000000000000000000000",
    n1339 when "0000000000100000000000000000000000",
    n1339 when "0000000000010000000000000000000000",
    n1339 when "0000000000001000000000000000000000",
    n1339 when "0000000000000100000000000000000000",
    n1339 when "0000000000000010000000000000000000",
    n1339 when "0000000000000001000000000000000000",
    n1339 when "0000000000000000100000000000000000",
    n1339 when "0000000000000000010000000000000000",
    n1339 when "0000000000000000001000000000000000",
    n1339 when "0000000000000000000100000000000000",
    n1339 when "0000000000000000000010000000000000",
    n1339 when "0000000000000000000001000000000000",
    n1339 when "0000000000000000000000100000000000",
    n1339 when "0000000000000000000000010000000000",
    n1339 when "0000000000000000000000001000000000",
    n1339 when "0000000000000000000000000100000000",
    bdt_bmpidx when "0000000000000000000000000010000000",
    n1339 when "0000000000000000000000000001000000",
    n1339 when "0000000000000000000000000000100000",
    n1339 when "0000000000000000000000000000010000",
    n1339 when "0000000000000000000000000000001000",
    n1339 when "0000000000000000000000000000000100",
    n1339 when "0000000000000000000000000000000010",
    n1339 when "0000000000000000000000000000000001",
    n1339 when others;
  n1341 <= state (307 downto 300);
  with n1270 select n1342 <=
    n1341 when "1000000000000000000000000000000000",
    n1341 when "0100000000000000000000000000000000",
    n1341 when "0010000000000000000000000000000000",
    n1341 when "0001000000000000000000000000000000",
    n1341 when "0000100000000000000000000000000000",
    n1341 when "0000010000000000000000000000000000",
    n1341 when "0000001000000000000000000000000000",
    n1341 when "0000000100000000000000000000000000",
    n1341 when "0000000010000000000000000000000000",
    n1341 when "0000000001000000000000000000000000",
    n1341 when "0000000000100000000000000000000000",
    n1341 when "0000000000010000000000000000000000",
    n1341 when "0000000000001000000000000000000000",
    n1341 when "0000000000000100000000000000000000",
    n1341 when "0000000000000010000000000000000000",
    n1341 when "0000000000000001000000000000000000",
    n1341 when "0000000000000000100000000000000000",
    n1341 when "0000000000000000010000000000000000",
    n1341 when "0000000000000000001000000000000000",
    n1341 when "0000000000000000000100000000000000",
    n1341 when "0000000000000000000010000000000000",
    n1341 when "0000000000000000000001000000000000",
    n1341 when "0000000000000000000000100000000000",
    n1341 when "0000000000000000000000010000000000",
    n1341 when "0000000000000000000000001000000000",
    n1341 when "0000000000000000000000000100000000",
    n1341 when "0000000000000000000000000010000000",
    n1341 when "0000000000000000000000000001000000",
    n1341 when "0000000000000000000000000000100000",
    n1341 when "0000000000000000000000000000010000",
    n1341 when "0000000000000000000000000000001000",
    n1341 when "0000000000000000000000000000000100",
    n324 when "0000000000000000000000000000000010",
    n1341 when "0000000000000000000000000000000001",
    n1341 when others;
  n1343 <= state (309 downto 308);
  with n1270 select n1344 <=
    n1343 when "1000000000000000000000000000000000",
    n1343 when "0100000000000000000000000000000000",
    n1343 when "0010000000000000000000000000000000",
    n1343 when "0001000000000000000000000000000000",
    n1343 when "0000100000000000000000000000000000",
    n1343 when "0000010000000000000000000000000000",
    n1343 when "0000001000000000000000000000000000",
    n1343 when "0000000100000000000000000000000000",
    n1343 when "0000000010000000000000000000000000",
    n1343 when "0000000001000000000000000000000000",
    n1343 when "0000000000100000000000000000000000",
    n1343 when "0000000000010000000000000000000000",
    n1343 when "0000000000001000000000000000000000",
    n1343 when "0000000000000100000000000000000000",
    n1343 when "0000000000000010000000000000000000",
    n1343 when "0000000000000001000000000000000000",
    n1343 when "0000000000000000100000000000000000",
    n1343 when "0000000000000000010000000000000000",
    n1343 when "0000000000000000001000000000000000",
    n1343 when "0000000000000000000100000000000000",
    n1343 when "0000000000000000000010000000000000",
    n1343 when "0000000000000000000001000000000000",
    n1343 when "0000000000000000000000100000000000",
    n1343 when "0000000000000000000000010000000000",
    n1343 when "0000000000000000000000001000000000",
    n1343 when "0000000000000000000000000100000000",
    n1343 when "0000000000000000000000000010000000",
    n1343 when "0000000000000000000000000001000000",
    n1343 when "0000000000000000000000000000100000",
    n1343 when "0000000000000000000000000000010000",
    n1343 when "0000000000000000000000000000001000",
    n1343 when "0000000000000000000000000000000100",
    n326 when "0000000000000000000000000000000010",
    n1343 when "0000000000000000000000000000000001",
    n1343 when others;
  with n1270 select n1365 <=
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
  with n1270 select n1368 <=
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
  with n1270 select n1371 <=
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
  with n1270 select n1374 <=
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
  with n1270 select n1377 <=
    "00000000000000000000000000000000" when "1000000000000000000000000000000000",
    n1245 when "0100000000000000000000000000000000",
    n1228 when "0010000000000000000000000000000000",
    n1225 when "0001000000000000000000000000000000",
    n1221 when "0000100000000000000000000000000000",
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
  with n1270 select n1382 <=
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
  with n1270 select n1385 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    n1194 when "0000000010000000000000000000000000",
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
  with n1270 select n1388 <=
    "000000000000000000000" when "1000000000000000000000000000000000",
    "000000000000000000000" when "0100000000000000000000000000000000",
    "000000000000000000000" when "0010000000000000000000000000000000",
    "000000000000000000000" when "0001000000000000000000000000000000",
    "000000000000000000000" when "0000100000000000000000000000000000",
    "000000000000000000000" when "0000010000000000000000000000000000",
    "000000000000000000000" when "0000001000000000000000000000000000",
    "000000000000000000000" when "0000000100000000000000000000000000",
    n1160 when "0000000010000000000000000000000000",
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
  with n1270 select n1391 <=
    "0000000000000000" when "1000000000000000000000000000000000",
    "0000000000000000" when "0100000000000000000000000000000000",
    "0000000000000000" when "0010000000000000000000000000000000",
    "0000000000000000" when "0001000000000000000000000000000000",
    "0000000000000000" when "0000100000000000000000000000000000",
    "0000000000000000" when "0000010000000000000000000000000000",
    "0000000000000000" when "0000001000000000000000000000000000",
    "0000000000000000" when "0000000100000000000000000000000000",
    n1169 when "0000000010000000000000000000000000",
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
  with n1270 select n1394 <=
    '1' when "1000000000000000000000000000000000",
    '1' when "0100000000000000000000000000000000",
    '1' when "0010000000000000000000000000000000",
    '1' when "0001000000000000000000000000000000",
    '1' when "0000100000000000000000000000000000",
    '1' when "0000010000000000000000000000000000",
    '1' when "0000001000000000000000000000000000",
    '1' when "0000000100000000000000000000000000",
    n1196 when "0000000010000000000000000000000000",
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
  with n1270 select n1398 <=
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
  with n1270 select n1401 <=
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
  with n1270 select n1404 <=
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
  n1409 <= "000000000000000000000" when pw_vram_wr = '0' else pw_vram_wr_addr;
  n1411 <= "0000000000000000" when pw_vram_wr = '0' else pw_vram_wr_data;
  n1414 <= '0' when pw_vram_wr = '0' else '1';
  n1416 <= '1' when pw_vram_wr = '0' else pw_vram_wr_access_mode;
  n1417 <= n1409 when direct_vram_wr = '0' else direct_vram_wr_addr;
  n1419 <= n1411 when direct_vram_wr = '0' else direct_vram_wr_data;
  n1422 <= n1414 when direct_vram_wr = '0' else '1';
  n1424 <= n1416 when direct_vram_wr = '0' else direct_vram_wr_access_mode;
  gfx_circle_inst : entity work.gfx_circle_renamed port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    start => circle_start,
    stall => stall,
    center_x => n1429,
    center_y => n1430,
    radius => radius,
    busy => gfx_circle_inst_c_busy,
    pixel_valid => gfx_circle_inst_c_pixel_valid,
    pixel_x => gfx_circle_inst_c_pixel_x,
    pixel_y => gfx_circle_inst_c_pixel_y);
  n1428 <= state (221 downto 190);
  n1429 <= n1428 (15 downto 0);
  n1430 <= n1428 (31 downto 16);
  n1432 <= gfx_circle_inst_c_pixel_y & gfx_circle_inst_c_pixel_x;
  pw : entity work.pixel_writer_21_16 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    wr => pw_wr,
    bd_b => n1436,
    bd_w => n1437,
    bd_h => n1438,
    color => pw_color,
    position_x => n1439,
    position_y => n1440,
    alpha_mode => pw_alpha_mode,
    alpha_color => n1479,
    vram_wr_full => wrap_vram_wr_full,
    wr_in_progress => open,
    stall => pw_c_stall,
    oob => pw_c_oob,
    vram_wr_addr => pw_c_vram_wr_addr,
    vram_wr_data => pw_c_vram_wr_data,
    vram_wr => pw_c_vram_wr,
    vram_wr_access_mode => pw_c_vram_wr_access_mode);
  n1435 <= state (299 downto 238);
  n1436 <= n1435 (31 downto 0);
  n1437 <= n1435 (46 downto 32);
  n1438 <= n1435 (61 downto 47);
  n1439 <= pw_position (15 downto 0);
  n1440 <= pw_position (31 downto 16);
  n1442 <= state (237 downto 230);
  n1448 <= state (309 downto 308);
  n1449 <= state (307 downto 300);
  n1450 <= n1442 and n1449;
  n1452 <= '1' when n1448 = "01" else '0';
  n1453 <= state (307 downto 300);
  n1454 <= n1442 or n1453;
  n1456 <= '1' when n1448 = "10" else '0';
  n1457 <= state (307 downto 300);
  n1458 <= n1442 xor n1457;
  n1460 <= '1' when n1448 = "11" else '0';
  n1461 <= n1460 & n1456 & n1452;
  with n1461 select n1466 <=
    '0' when "100",
    '0' when "010",
    '0' when "001",
    '1' when others;
  with n1461 select n1474 <=
    n1458 when "100",
    n1454 when "010",
    n1450 when "001",
    "XXXXXXXX" when others;
  n1479 <= n1474 when n1466 = '0' else n1442;
  pr : entity work.pixel_reader_21_16 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    start => pr_start,
    bd_b => n1485,
    bd_w => n1486,
    bd_h => n1487,
    section_x => n1488,
    section_y => n1489,
    section_w => n1490,
    section_h => n1491,
    color_ack => pr_color_ack,
    vram_rd_data => wrap_vram_rd_data,
    vram_rd_busy => wrap_vram_rd_busy,
    vram_rd_valid => wrap_vram_rd_valid,
    color => pr_c_color,
    color_valid => pr_c_color_valid,
    vram_rd_addr => pr_c_vram_rd_addr,
    vram_rd => pr_c_vram_rd,
    vram_rd_access_mode => pr_c_vram_rd_access_mode);
  n1485 <= bdt_bmpidx (31 downto 0);
  n1486 <= bdt_bmpidx (46 downto 32);
  n1487 <= bdt_bmpidx (61 downto 47);
  n1488 <= bb_section (14 downto 0);
  n1489 <= bb_section (29 downto 15);
  n1490 <= bb_section (44 downto 30);
  n1491 <= bb_section (59 downto 45);
  n1497 <= wrap_gcf_data & n57 & n58 & n59;
  process (wrap_clk, n118)
  begin
    if n118 = '1' then
      n1498 <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (wrap_clk) then
      n1498 <= state_nxt;
    end if;
  end process;
  n1499 <= n1344 & n1342 & n1340 & n1338 & n1336 & n1334 & n1327 & n1320 & n1315 & n1310 & n1308 & n1306 & n1304 & n1302 & n1300 & n1298 & n1296 & n1294 & n1292 & n1290;
  n1501 <= n105 & n104 & n103;
  assert vram_addr_width = 21 report "Unsupported generic value! vram_addr_width must be 21." severity failure;
  assert vram_data_width = 16 report "Unsupported generic value! vram_data_width must be 16." severity failure;
end architecture;
