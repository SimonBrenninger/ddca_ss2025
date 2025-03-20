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
  signal n2234 : std_logic_vector (7 downto 0);
  signal n2235 : std_logic_vector (7 downto 0) := "00000000";
  signal n2237 : std_logic_vector (7 downto 0);
begin
  rd1_data <= n2235;
  n2234 <= n2235 when rd1 = '0' else n2237;
  process (clk)
  begin
    if rising_edge (clk) then
      n2235 <= n2234;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (7 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n2237 <= ram(to_integer (unsigned (rd1_addr)));
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
  signal memory_inst_n2097 : std_logic_vector (7 downto 0);
  signal memory_inst_c_rd1_data : std_logic_vector (7 downto 0);
  signal n2101 : std_logic;
  signal n2124 : std_logic;
  signal n2125 : std_logic;
  signal n2127 : std_logic_vector (2 downto 0);
  signal n2128 : std_logic_vector (2 downto 0);
  signal n2131 : std_logic;
  signal n2133 : std_logic;
  signal n2134 : std_logic;
  signal n2136 : std_logic_vector (2 downto 0);
  signal n2137 : std_logic_vector (2 downto 0);
  signal n2140 : std_logic;
  signal n2142 : std_logic;
  signal n2143 : std_logic;
  signal n2145 : std_logic_vector (31 downto 0);
  signal n2146 : std_logic;
  signal n2147 : std_logic;
  signal n2149 : std_logic_vector (31 downto 0);
  signal n2150 : std_logic_vector (31 downto 0);
  signal n2151 : std_logic_vector (31 downto 0);
  signal n2153 : std_logic;
  signal n2156 : std_logic;
  signal n2159 : std_logic_vector (2 downto 0);
  signal n2160 : std_logic;
  signal n2162 : std_logic;
  signal n2164 : std_logic;
  signal n2165 : std_logic;
  signal n2167 : std_logic_vector (2 downto 0);
  signal n2168 : std_logic;
  signal n2170 : std_logic;
  signal n2171 : std_logic;
  signal n2173 : std_logic;
  signal n2179 : std_logic;
  signal n2181 : std_logic;
  signal n2182 : std_logic;
  signal n2186 : std_logic;
  signal n2187 : std_logic;
  signal n2189 : std_logic;
  signal n2190 : std_logic;
  signal n2194 : std_logic;
  signal n2203 : std_logic := '1';
  signal n2205 : std_logic := '1';
  signal n2206 : std_logic_vector (2 downto 0);
  signal n2207 : std_logic_vector (2 downto 0);
  signal n2208 : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n2209 : std_logic;
  signal n2210 : std_logic;
  signal n2211 : std_logic;
begin
  rd_data <= memory_inst_n2097;
  empty <= n2209;
  full <= n2210;
  half_full <= n2211;
  read_address <= n2206; -- (signal)
  read_address_next <= n2137; -- (signal)
  write_address <= n2207; -- (signal)
  write_address_next <= n2128; -- (signal)
  full_next <= n2170; -- (signal)
  empty_next <= n2173; -- (signal)
  wr_int <= n2131; -- (signal)
  rd_int <= n2140; -- (signal)
  half_full_next <= n2156; -- (signal)
  pointer_diff <= n2208; -- (isignal)
  pointer_diff_next <= n2151; -- (isignal)
  memory_inst_n2097 <= memory_inst_c_rd1_data; -- (signal)
  memory_inst : entity work.dp_ram_1c1r1w_3_8 port map (
    clk => clk,
    rd1_addr => read_address,
    rd1 => rd_int,
    wr2_addr => write_address,
    wr2_data => wr_data,
    wr2 => wr_int,
    rd1_data => memory_inst_c_rd1_data);
  n2101 <= not res_n;
  n2124 <= not n2210;
  n2125 <= n2124 and wr;
  n2127 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n2128 <= write_address when n2125 = '0' else n2127;
  n2131 <= '0' when n2125 = '0' else '1';
  n2133 <= not n2209;
  n2134 <= n2133 and rd;
  n2136 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n2137 <= read_address when n2134 = '0' else n2136;
  n2140 <= '0' when n2134 = '0' else '1';
  n2142 <= not rd;
  n2143 <= n2142 and wr;
  n2145 <= std_logic_vector (unsigned (pointer_diff) + unsigned'("00000000000000000000000000000001"));
  n2146 <= not wr;
  n2147 <= n2146 and rd;
  n2149 <= std_logic_vector (unsigned (pointer_diff) - unsigned'("00000000000000000000000000000001"));
  n2150 <= pointer_diff when n2147 = '0' else n2149;
  n2151 <= n2150 when n2143 = '0' else n2145;
  n2153 <= '1' when signed (n2151) >= signed'("00000000000000000000000000000100") else '0';
  n2156 <= '0' when n2153 = '0' else '1';
  n2159 <= std_logic_vector (unsigned (read_address) + unsigned'("001"));
  n2160 <= '1' when write_address = n2159 else '0';
  n2162 <= n2209 when n2165 = '0' else '1';
  n2164 <= n2210 when rd = '0' else '0';
  n2165 <= n2160 and rd;
  n2167 <= std_logic_vector (unsigned (write_address) + unsigned'("001"));
  n2168 <= '1' when read_address = n2167 else '0';
  n2170 <= n2164 when n2171 = '0' else '1';
  n2171 <= n2168 and wr;
  n2173 <= n2162 when wr = '0' else '0';
  n2179 <= not n2210;
  n2181 <= not n2186;
  n2182 <= n2181 or n2179;
  n2183: postponed assert n2203 = '1' severity error; --  assert
  n2186 <= '0' when wr = '0' else '1';
  n2187 <= not n2209;
  n2189 <= not n2194;
  n2190 <= n2189 or n2187;
  n2191: postponed assert n2205 = '1' severity error; --  assert
  n2194 <= '0' when rd = '0' else '1';
  process (clk)
  begin
    if rising_edge (clk) then
      n2203 <= n2182;
    end if;
  end process;
  process (clk)
  begin
    if rising_edge (clk) then
      n2205 <= n2190;
    end if;
  end process;
  process (clk, n2101)
  begin
    if n2101 = '1' then
      n2206 <= "000";
    elsif rising_edge (clk) then
      n2206 <= read_address_next;
    end if;
  end process;
  process (clk, n2101)
  begin
    if n2101 = '1' then
      n2207 <= "000";
    elsif rising_edge (clk) then
      n2207 <= write_address_next;
    end if;
  end process;
  process (clk, n2101)
  begin
    if n2101 = '1' then
      n2208 <= "00000000000000000000000000000000";
    elsif rising_edge (clk) then
      n2208 <= pointer_diff_next;
    end if;
  end process;
  process (clk, n2101)
  begin
    if n2101 = '1' then
      n2209 <= '1';
    elsif rising_edge (clk) then
      n2209 <= empty_next;
    end if;
  end process;
  process (clk, n2101)
  begin
    if n2101 = '1' then
      n2210 <= '0';
    elsif rising_edge (clk) then
      n2210 <= full_next;
    end if;
  end process;
  process (clk, n2101)
  begin
    if n2101 = '1' then
      n2211 <= '0';
    elsif rising_edge (clk) then
      n2211 <= half_full_next;
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
  signal fifo_inst_n2062 : std_logic_vector (7 downto 0);
  signal fifo_inst_n2063 : std_logic;
  signal fifo_inst_n2064 : std_logic;
  signal fifo_inst_n2065 : std_logic;
  signal fifo_inst_c_rd_data : std_logic_vector (7 downto 0);
  signal fifo_inst_c_empty : std_logic;
  signal fifo_inst_c_full : std_logic;
  signal fifo_inst_c_half_full : std_logic;
  signal n2074 : std_logic;
  signal n2075 : std_logic;
  signal n2076 : std_logic;
  signal n2077 : std_logic;
  signal n2078 : std_logic;
  signal n2080 : std_logic;
  signal n2082 : std_logic;
  signal n2088 : std_logic;
  signal n2089 : std_logic;
begin
  rd_data <= fifo_inst_n2062;
  rd_valid <= n2089;
  full <= fifo_inst_n2064;
  half_full <= fifo_inst_n2065;
  rd <= n2078; -- (signal)
  empty <= fifo_inst_n2063; -- (signal)
  not_empty <= n2074; -- (signal)
  fifo_inst_n2062 <= fifo_inst_c_rd_data; -- (signal)
  fifo_inst_n2063 <= fifo_inst_c_empty; -- (signal)
  fifo_inst_n2064 <= fifo_inst_c_full; -- (signal)
  fifo_inst_n2065 <= fifo_inst_c_half_full; -- (signal)
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
  n2074 <= not empty;
  n2075 <= rd_ack and not_empty;
  n2076 <= not n2089;
  n2077 <= not_empty and n2076;
  n2078 <= n2075 or n2077;
  n2080 <= not res_n;
  n2082 <= rd or rd_ack;
  n2088 <= n2089 when n2082 = '0' else not_empty;
  process (clk, n2080)
  begin
    if n2080 = '1' then
      n2089 <= '0';
    elsif rising_edge (clk) then
      n2089 <= n2088;
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
  signal n1904 : std_logic_vector (61 downto 0);
  signal n1905 : std_logic_vector (59 downto 0);
  signal state : std_logic_vector (55 downto 0);
  signal state_nxt : std_logic_vector (55 downto 0);
  signal pixbuf_half_full : std_logic;
  signal fifo_wr : std_logic;
  signal n1912 : std_logic;
  signal n1920 : std_logic_vector (20 downto 0);
  signal n1921 : std_logic_vector (1 downto 0);
  signal n1922 : std_logic_vector (14 downto 0);
  signal n1923 : std_logic_vector (14 downto 0);
  signal n1925 : std_logic_vector (31 downto 0);
  signal n1926 : std_logic_vector (31 downto 0);
  signal n1927 : std_logic_vector (31 downto 0);
  signal n1929 : std_logic;
  signal n1930 : std_logic_vector (31 downto 0);
  signal n1931 : std_logic_vector (14 downto 0);
  signal n1932 : std_logic_vector (31 downto 0);
  signal n1933 : std_logic_vector (31 downto 0);
  signal n1934 : std_logic_vector (14 downto 0);
  signal n1935 : std_logic_vector (14 downto 0);
  signal n1936 : std_logic_vector (29 downto 0);
  signal n1937 : std_logic_vector (29 downto 0);
  signal n1938 : std_logic_vector (29 downto 0);
  signal n1939 : std_logic_vector (31 downto 0);
  signal n1940 : std_logic_vector (31 downto 0);
  signal n1941 : std_logic_vector (20 downto 0);
  signal n1942 : std_logic;
  signal n1944 : std_logic_vector (1 downto 0);
  signal n1945 : std_logic_vector (1 downto 0);
  signal n1947 : std_logic;
  signal n1948 : std_logic;
  signal n1950 : std_logic_vector (14 downto 0);
  signal n1951 : std_logic_vector (14 downto 0);
  signal n1952 : std_logic_vector (14 downto 0);
  signal n1953 : std_logic_vector (14 downto 0);
  signal n1955 : std_logic_vector (14 downto 0);
  signal n1956 : std_logic;
  signal n1957 : std_logic_vector (14 downto 0);
  signal n1958 : std_logic_vector (14 downto 0);
  signal n1959 : std_logic_vector (14 downto 0);
  signal n1960 : std_logic_vector (14 downto 0);
  signal n1961 : std_logic_vector (14 downto 0);
  signal n1963 : std_logic_vector (14 downto 0);
  signal n1964 : std_logic;
  signal n1966 : std_logic_vector (14 downto 0);
  signal n1968 : std_logic_vector (14 downto 0);
  signal n1969 : std_logic_vector (1 downto 0);
  signal n1970 : std_logic_vector (14 downto 0);
  signal n1971 : std_logic_vector (14 downto 0);
  signal n1972 : std_logic_vector (14 downto 0);
  signal n1974 : std_logic_vector (14 downto 0);
  signal n1975 : std_logic_vector (31 downto 0);
  signal n1976 : std_logic_vector (1 downto 0);
  signal n1977 : std_logic_vector (1 downto 0);
  signal n1978 : std_logic_vector (14 downto 0);
  signal n1979 : std_logic_vector (14 downto 0);
  signal n1980 : std_logic_vector (14 downto 0);
  signal n1981 : std_logic_vector (14 downto 0);
  signal n1982 : std_logic_vector (14 downto 0);
  signal n1985 : std_logic;
  signal n1986 : std_logic_vector (31 downto 0);
  signal n1987 : std_logic_vector (31 downto 0);
  signal n1988 : std_logic_vector (31 downto 0);
  signal n1990 : std_logic;
  signal n1991 : std_logic_vector (2 downto 0);
  signal n1993 : std_logic;
  signal n1995 : std_logic_vector (1 downto 0);
  signal n1996 : std_logic_vector (1 downto 0);
  signal n1998 : std_logic;
  signal n1999 : std_logic_vector (3 downto 0);
  signal n2002 : std_logic;
  signal n2004 : std_logic_vector (1 downto 0);
  signal n2005 : std_logic_vector (1 downto 0);
  signal n2007 : std_logic_vector (1 downto 0);
  signal n2008 : std_logic_vector (29 downto 0);
  signal n2009 : std_logic_vector (29 downto 0);
  signal n2010 : std_logic_vector (29 downto 0);
  signal n2012 : std_logic_vector (29 downto 0);
  signal n2013 : std_logic_vector (20 downto 0);
  signal n2015 : std_logic_vector (20 downto 0);
  signal n2018 : std_logic_vector (2 downto 0);
  signal n2019 : std_logic_vector (1 downto 0);
  signal n2021 : std_logic;
  signal n2022 : std_logic;
  signal n2023 : std_logic;
  signal n2024 : std_logic_vector (2 downto 0);
  signal n2026 : std_logic_vector (2 downto 0);
  signal n2027 : std_logic;
  signal n2028 : std_logic;
  signal n2029 : std_logic_vector (2 downto 0);
  signal n2031 : std_logic_vector (2 downto 0);
  signal n2032 : std_logic_vector (2 downto 0);
  signal n2033 : std_logic_vector (2 downto 0);
  signal n2034 : std_logic_vector (2 downto 0);
  constant n2036 : std_logic := '0';
  signal n2038 : std_logic_vector (1 downto 0);
  signal n2040 : std_logic;
  signal n2041 : std_logic;
  signal n2042 : std_logic;
  signal pixel_buffer_n2044 : std_logic_vector (7 downto 0);
  signal pixel_buffer_n2045 : std_logic;
  signal n2046 : std_logic_vector (7 downto 0);
  signal pixel_buffer_n2048 : std_logic;
  signal pixel_buffer_c_rd_data : std_logic_vector (7 downto 0);
  signal pixel_buffer_c_rd_valid : std_logic;
  signal pixel_buffer_c_full : std_logic;
  signal pixel_buffer_c_half_full : std_logic;
  signal n2056 : std_logic_vector (55 downto 0);
  signal n2057 : std_logic_vector (55 downto 0);
begin
  color <= pixel_buffer_n2044;
  color_valid <= pixel_buffer_n2045;
  vram_rd_addr <= n1920;
  vram_rd <= n2002;
  vram_rd_access_mode <= n2036;
  n1904 <= bd_h & bd_w & bd_b;
  n1905 <= section_h & section_w & section_y & section_x;
  state <= n2056; -- (signal)
  state_nxt <= n2057; -- (signal)
  pixbuf_half_full <= pixel_buffer_n2048; -- (signal)
  fifo_wr <= n2042; -- (signal)
  n1912 <= not res_n;
  n1920 <= state (52 downto 32);
  n1921 <= state (1 downto 0);
  n1922 <= n1905 (14 downto 0);
  n1923 <= n1905 (29 downto 15);
  n1925 <= n1923 & n1922 & "10";
  n1926 <= state (31 downto 0);
  n1927 <= n1926 when start = '0' else n1925;
  n1929 <= '1' when n1921 = "00" else '0';
  n1930 <= n1904 (31 downto 0);
  n1931 <= state (16 downto 2);
  n1932 <= "00000000000000000" & n1931;  --  uext
  n1933 <= std_logic_vector (unsigned (n1930) + unsigned (n1932));
  n1934 <= state (31 downto 17);
  n1935 <= n1904 (46 downto 32);
  n1936 <= "000000000000000" & n1934;  --  uext
  n1937 <= "000000000000000" & n1935;  --  uext
  n1938 <= std_logic_vector (resize (unsigned (n1936) * unsigned (n1937), 30));
  n1939 <= "00" & n1938;  --  uext
  n1940 <= std_logic_vector (unsigned (n1933) + unsigned (n1939));
  n1941 <= n1940 (20 downto 0);  --  trunc
  n1942 <= not pixbuf_half_full;
  n1944 <= state (1 downto 0);
  n1945 <= n1944 when n1942 = '0' else "11";
  n1947 <= '1' when n1921 = "10" else '0';
  n1948 <= not vram_rd_busy;
  n1950 <= state (16 downto 2);
  n1951 <= n1905 (14 downto 0);
  n1952 <= n1905 (44 downto 30);
  n1953 <= std_logic_vector (unsigned (n1951) + unsigned (n1952));
  n1955 <= std_logic_vector (unsigned (n1953) - unsigned'("000000000000001"));
  n1956 <= '1' when n1950 = n1955 else '0';
  n1957 <= n1905 (14 downto 0);
  n1958 <= state (31 downto 17);
  n1959 <= n1905 (29 downto 15);
  n1960 <= n1905 (59 downto 45);
  n1961 <= std_logic_vector (unsigned (n1959) + unsigned (n1960));
  n1963 <= std_logic_vector (unsigned (n1961) - unsigned'("000000000000001"));
  n1964 <= '1' when n1958 = n1963 else '0';
  n1966 <= state (31 downto 17);
  n1968 <= std_logic_vector (unsigned (n1966) + unsigned'("000000000000001"));
  n1969 <= "10" when n1964 = '0' else "01";
  n1970 <= state (31 downto 17);
  n1971 <= n1968 when n1964 = '0' else n1970;
  n1972 <= state (16 downto 2);
  n1974 <= std_logic_vector (unsigned (n1972) + unsigned'("000000000000001"));
  n1975 <= n1971 & n1957 & n1969;
  n1976 <= n1975 (1 downto 0);
  n1977 <= "10" when n1956 = '0' else n1976;
  n1978 <= n1975 (16 downto 2);
  n1979 <= n1974 when n1956 = '0' else n1978;
  n1980 <= n1975 (31 downto 17);
  n1981 <= state (31 downto 17);
  n1982 <= n1981 when n1956 = '0' else n1980;
  n1985 <= '0' when n1948 = '0' else '1';
  n1986 <= n1982 & n1979 & n1977;
  n1987 <= state (31 downto 0);
  n1988 <= n1987 when n1948 = '0' else n1986;
  n1990 <= '1' when n1921 = "11" else '0';
  n1991 <= state (55 downto 53);
  n1993 <= '1' when n1991 = "000" else '0';
  n1995 <= state (1 downto 0);
  n1996 <= n1995 when n1993 = '0' else "00";
  n1998 <= '1' when n1921 = "01" else '0';
  n1999 <= n1998 & n1990 & n1947 & n1929;
  with n1999 select n2002 <=
    '0' when "1000",
    n1985 when "0100",
    '0' when "0010",
    '0' when "0001",
    'X' when others;
  n2004 <= n1927 (1 downto 0);
  n2005 <= n1988 (1 downto 0);
  with n1999 select n2007 <=
    n1996 when "1000",
    n2005 when "0100",
    n1945 when "0010",
    n2004 when "0001",
    "XX" when others;
  n2008 <= n1927 (31 downto 2);
  n2009 <= n1988 (31 downto 2);
  n2010 <= state (31 downto 2);
  with n1999 select n2012 <=
    n2010 when "1000",
    n2009 when "0100",
    n2010 when "0010",
    n2008 when "0001",
    (29 downto 0 => 'X') when others;
  n2013 <= state (52 downto 32);
  with n1999 select n2015 <=
    n2013 when "1000",
    n2013 when "0100",
    n1941 when "0010",
    n2013 when "0001",
    (20 downto 0 => 'X') when others;
  n2018 <= state (55 downto 53);
  n2019 <= state (1 downto 0);
  n2021 <= '1' when n2019 /= "00" else '0';
  n2022 <= not vram_rd_valid;
  n2023 <= n2022 and n2002;
  n2024 <= state (55 downto 53);
  n2026 <= std_logic_vector (unsigned (n2024) + unsigned'("001"));
  n2027 <= not n2002;
  n2028 <= vram_rd_valid and n2027;
  n2029 <= state (55 downto 53);
  n2031 <= std_logic_vector (unsigned (n2029) - unsigned'("001"));
  n2032 <= n2018 when n2028 = '0' else n2031;
  n2033 <= n2032 when n2023 = '0' else n2026;
  n2034 <= n2018 when n2021 = '0' else n2033;
  n2038 <= state (1 downto 0);
  n2040 <= '1' when n2038 /= "00" else '0';
  n2041 <= n2040 and vram_rd_valid;
  n2042 <= '0' when n2041 = '0' else '1';
  pixel_buffer_n2044 <= pixel_buffer_c_rd_data; -- (signal)
  pixel_buffer_n2045 <= pixel_buffer_c_rd_valid; -- (signal)
  n2046 <= vram_rd_data (7 downto 0);
  pixel_buffer_n2048 <= pixel_buffer_c_half_full; -- (signal)
  pixel_buffer : entity work.fifo_1c1r1w_fwft_8_8 port map (
    clk => clk,
    res_n => res_n,
    rd_ack => color_ack,
    wr_data => n2046,
    wr => fifo_wr,
    rd_data => pixel_buffer_c_rd_data,
    rd_valid => pixel_buffer_c_rd_valid,
    full => open,
    half_full => pixel_buffer_c_half_full);
  process (clk, n1912)
  begin
    if n1912 = '1' then
      n2056 <= "00000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n2056 <= state_nxt;
    end if;
  end process;
  n2057 <= n2034 & n2015 & n2012 & n2007;
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
  signal n1810 : std_logic_vector (61 downto 0);
  signal n1811 : std_logic_vector (31 downto 0);
  signal s1 : std_logic_vector (111 downto 0);
  signal s2 : std_logic_vector (29 downto 0);
  signal s2_nxt : std_logic_vector (29 downto 0);
  signal n1817 : std_logic;
  signal n1818 : std_logic;
  signal n1819 : std_logic;
  signal n1821 : std_logic;
  signal n1823 : std_logic;
  signal n1824 : std_logic_vector (15 downto 0);
  signal n1825 : std_logic_vector (15 downto 0);
  signal n1826 : std_logic_vector (111 downto 0);
  signal n1837 : std_logic;
  signal n1838 : std_logic_vector (15 downto 0);
  signal n1840 : std_logic;
  signal n1841 : std_logic_vector (15 downto 0);
  signal n1843 : std_logic_vector (14 downto 0);
  signal n1845 : std_logic_vector (15 downto 0);
  signal n1846 : std_logic;
  signal n1847 : std_logic;
  signal n1848 : std_logic_vector (15 downto 0);
  signal n1850 : std_logic;
  signal n1851 : std_logic;
  signal n1852 : std_logic_vector (15 downto 0);
  signal n1854 : std_logic_vector (14 downto 0);
  signal n1856 : std_logic_vector (15 downto 0);
  signal n1857 : std_logic;
  signal n1858 : std_logic;
  signal n1859 : std_logic;
  signal n1863 : std_logic;
  signal n1865 : std_logic;
  signal n1866 : std_logic;
  signal n1867 : std_logic_vector (7 downto 0);
  signal n1868 : std_logic_vector (7 downto 0);
  signal n1869 : std_logic;
  signal n1870 : std_logic;
  signal n1872 : std_logic;
  signal n1874 : std_logic_vector (31 downto 0);
  signal n1875 : std_logic_vector (15 downto 0);
  signal n1876 : std_logic_vector (31 downto 0);
  signal n1877 : std_logic_vector (31 downto 0);
  signal n1879 : std_logic_vector (14 downto 0);
  signal n1880 : std_logic_vector (15 downto 0);
  signal n1881 : std_logic_vector (30 downto 0);
  signal n1882 : std_logic_vector (30 downto 0);
  signal n1883 : std_logic_vector (30 downto 0);
  signal n1884 : std_logic_vector (31 downto 0);
  signal n1885 : std_logic_vector (31 downto 0);
  signal n1886 : std_logic_vector (20 downto 0);
  signal n1887 : std_logic_vector (7 downto 0);
  signal n1891 : std_logic_vector (7 downto 0);
  constant n1892 : std_logic_vector (15 downto 0) := "0000000000000000";
  signal n1893 : std_logic_vector (7 downto 0);
  signal n1894 : std_logic_vector (20 downto 0);
  signal n1895 : std_logic;
  constant n1897 : std_logic := '0';
  signal n1898 : std_logic_vector (111 downto 0);
  signal n1899 : std_logic_vector (111 downto 0);
  signal n1900 : std_logic_vector (29 downto 0);
  signal n1901 : std_logic_vector (29 downto 0);
  signal n1902 : std_logic_vector (29 downto 0);
  signal n1903 : std_logic_vector (15 downto 0);
begin
  wr_in_progress <= n1819;
  stall <= vram_wr_full;
  oob <= n1863;
  vram_wr_addr <= n1894;
  vram_wr_data <= n1903;
  vram_wr <= n1895;
  vram_wr_access_mode <= n1897;
  n1810 <= bd_h & bd_w & bd_b;
  n1811 <= position_y & position_x;
  s1 <= n1899; -- (signal)
  s2 <= n1901; -- (signal)
  s2_nxt <= n1902; -- (signal)
  n1817 <= s1 (0);
  n1818 <= s2 (0);
  n1819 <= n1817 or n1818;
  n1821 <= not res_n;
  n1823 <= not vram_wr_full;
  n1824 <= n1811 (31 downto 16);
  n1825 <= n1811 (15 downto 0);
  n1826 <= alpha_color & alpha_mode & n1825 & n1824 & color & n1810 & wr;
  n1837 <= s1 (0);
  n1838 <= s1 (102 downto 87);
  n1840 <= '1' when signed (n1838) >= signed'("0000000000000000") else '0';
  n1841 <= s1 (102 downto 87);
  n1843 <= s1 (47 downto 33);
  n1845 <= '0' & n1843;
  n1846 <= '1' when signed (n1841) < signed (n1845) else '0';
  n1847 <= n1846 and n1840;
  n1848 <= s1 (86 downto 71);
  n1850 <= '1' when signed (n1848) >= signed'("0000000000000000") else '0';
  n1851 <= n1850 and n1847;
  n1852 <= s1 (86 downto 71);
  n1854 <= s1 (62 downto 48);
  n1856 <= '0' & n1854;
  n1857 <= '1' when signed (n1852) < signed (n1856) else '0';
  n1858 <= n1857 and n1851;
  n1859 <= not n1858;
  n1863 <= '0' when n1859 = '0' else '1';
  n1865 <= n1837 when n1859 = '0' else '0';
  n1866 <= s1 (103);
  n1867 <= s1 (70 downto 63);
  n1868 <= s1 (111 downto 104);
  n1869 <= '1' when n1867 = n1868 else '0';
  n1870 <= n1869 and n1866;
  n1872 <= n1865 when n1870 = '0' else '0';
  n1874 <= s1 (32 downto 1);
  n1875 <= s1 (102 downto 87);
  n1876 <= "0000000000000000" & n1875;  --  uext
  n1877 <= std_logic_vector (unsigned (n1874) + unsigned (n1876));
  n1879 <= s1 (47 downto 33);
  n1880 <= s1 (86 downto 71);
  n1881 <= "0000000000000000" & n1879;  --  uext
  n1882 <= "000000000000000" & n1880;  --  uext
  n1883 <= std_logic_vector (resize (unsigned (n1881) * unsigned (n1882), 31));
  n1884 <= "0" & n1883;  --  uext
  n1885 <= std_logic_vector (unsigned (n1877) + unsigned (n1884));
  n1886 <= n1885 (20 downto 0);  --  trunc
  n1887 <= s1 (70 downto 63);
  n1891 <= s2 (29 downto 22);
  n1893 <= n1892 (15 downto 8);
  n1894 <= s2 (21 downto 1);
  n1895 <= s2 (0);
  n1898 <= s1 when n1823 = '0' else n1826;
  process (clk, n1821)
  begin
    if n1821 = '1' then
      n1899 <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1899 <= n1898;
    end if;
  end process;
  n1900 <= s2 when n1823 = '0' else s2_nxt;
  process (clk, n1821)
  begin
    if n1821 = '1' then
      n1901 <= "000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1901 <= n1900;
    end if;
  end process;
  n1902 <= n1887 & n1886 & n1872;
  n1903 <= n1893 & n1891;
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
  signal n1538 : std_logic_vector (31 downto 0);
  signal n1541 : std_logic_vector (15 downto 0);
  signal n1542 : std_logic_vector (15 downto 0);
  signal state : std_logic_vector (163 downto 0);
  signal state_nxt : std_logic_vector (163 downto 0);
  signal n1545 : std_logic;
  signal n1548 : std_logic;
  signal n1562 : std_logic_vector (30 downto 0);
  signal n1563 : std_logic_vector (31 downto 0);
  signal n1564 : std_logic_vector (15 downto 0);
  signal n1565 : std_logic_vector (31 downto 0);
  signal n1566 : std_logic_vector (15 downto 0);
  signal n1567 : std_logic_vector (31 downto 0);
  signal n1570 : std_logic_vector (31 downto 0);
  signal n1571 : std_logic_vector (31 downto 0);
  signal n1572 : std_logic_vector (31 downto 0);
  signal n1573 : std_logic_vector (3 downto 0);
  signal n1575 : std_logic_vector (3 downto 0);
  signal n1576 : std_logic_vector (3 downto 0);
  signal n1578 : std_logic;
  signal n1580 : std_logic_vector (31 downto 0);
  signal n1583 : std_logic_vector (31 downto 0);
  signal n1584 : std_logic_vector (31 downto 0);
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
  signal n1614 : std_logic_vector (31 downto 0);
  signal n1617 : std_logic_vector (15 downto 0);
  signal n1620 : std_logic;
  signal n1621 : std_logic_vector (31 downto 0);
  signal n1622 : std_logic_vector (31 downto 0);
  signal n1623 : std_logic;
  signal n1624 : std_logic_vector (31 downto 0);
  signal n1626 : std_logic;
  signal n1627 : std_logic_vector (31 downto 0);
  signal n1629 : std_logic_vector (31 downto 0);
  signal n1631 : std_logic_vector (31 downto 0);
  signal n1632 : std_logic_vector (31 downto 0);
  signal n1633 : std_logic_vector (31 downto 0);
  signal n1634 : std_logic_vector (31 downto 0);
  signal n1635 : std_logic_vector (31 downto 0);
  signal n1636 : std_logic_vector (31 downto 0);
  signal n1637 : std_logic_vector (31 downto 0);
  signal n1639 : std_logic_vector (31 downto 0);
  signal n1641 : std_logic_vector (31 downto 0);
  signal n1642 : std_logic_vector (31 downto 0);
  signal n1644 : std_logic_vector (31 downto 0);
  signal n1647 : std_logic_vector (163 downto 0);
  signal n1648 : std_logic_vector (3 downto 0);
  signal n1649 : std_logic_vector (3 downto 0);
  signal n1650 : std_logic_vector (159 downto 0);
  signal n1651 : std_logic_vector (159 downto 0);
  signal n1652 : std_logic_vector (159 downto 0);
  signal n1657 : std_logic;
  signal n1659 : std_logic_vector (31 downto 0);
  signal n1660 : std_logic_vector (31 downto 0);
  signal n1661 : std_logic_vector (31 downto 0);
  signal n1662 : std_logic_vector (31 downto 0);
  signal n1665 : std_logic_vector (15 downto 0);
  signal n1666 : std_logic_vector (15 downto 0);
  signal n1669 : std_logic;
  signal n1671 : std_logic_vector (31 downto 0);
  signal n1672 : std_logic_vector (31 downto 0);
  signal n1673 : std_logic_vector (31 downto 0);
  signal n1674 : std_logic_vector (31 downto 0);
  signal n1677 : std_logic_vector (15 downto 0);
  signal n1678 : std_logic_vector (15 downto 0);
  signal n1681 : std_logic;
  signal n1683 : std_logic_vector (31 downto 0);
  signal n1684 : std_logic_vector (31 downto 0);
  signal n1685 : std_logic_vector (31 downto 0);
  signal n1686 : std_logic_vector (31 downto 0);
  signal n1689 : std_logic_vector (15 downto 0);
  signal n1690 : std_logic_vector (15 downto 0);
  signal n1693 : std_logic;
  signal n1695 : std_logic_vector (31 downto 0);
  signal n1696 : std_logic_vector (31 downto 0);
  signal n1697 : std_logic_vector (31 downto 0);
  signal n1698 : std_logic_vector (31 downto 0);
  signal n1701 : std_logic_vector (15 downto 0);
  signal n1702 : std_logic_vector (15 downto 0);
  signal n1705 : std_logic;
  signal n1707 : std_logic_vector (31 downto 0);
  signal n1708 : std_logic_vector (31 downto 0);
  signal n1709 : std_logic_vector (31 downto 0);
  signal n1710 : std_logic_vector (31 downto 0);
  signal n1713 : std_logic_vector (15 downto 0);
  signal n1714 : std_logic_vector (15 downto 0);
  signal n1717 : std_logic;
  signal n1719 : std_logic_vector (31 downto 0);
  signal n1720 : std_logic_vector (31 downto 0);
  signal n1721 : std_logic_vector (31 downto 0);
  signal n1722 : std_logic_vector (31 downto 0);
  signal n1725 : std_logic_vector (15 downto 0);
  signal n1726 : std_logic_vector (15 downto 0);
  signal n1729 : std_logic;
  signal n1731 : std_logic_vector (31 downto 0);
  signal n1732 : std_logic_vector (31 downto 0);
  signal n1733 : std_logic_vector (31 downto 0);
  signal n1734 : std_logic_vector (31 downto 0);
  signal n1737 : std_logic_vector (15 downto 0);
  signal n1738 : std_logic_vector (15 downto 0);
  signal n1741 : std_logic;
  signal n1743 : std_logic_vector (31 downto 0);
  signal n1744 : std_logic_vector (31 downto 0);
  signal n1745 : std_logic_vector (31 downto 0);
  signal n1746 : std_logic_vector (31 downto 0);
  signal n1749 : std_logic_vector (15 downto 0);
  signal n1750 : std_logic_vector (15 downto 0);
  signal n1753 : std_logic;
  signal n1754 : std_logic_vector (14 downto 0);
  signal n1757 : std_logic;
  signal n1772 : std_logic;
  signal n1774 : std_logic_vector (15 downto 0);
  signal n1775 : std_logic_vector (15 downto 0);
  signal n1776 : std_logic_vector (3 downto 0);
  signal n1777 : std_logic_vector (3 downto 0);
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
  signal n1788 : std_logic_vector (31 downto 0);
  signal n1789 : std_logic_vector (31 downto 0);
  signal n1790 : std_logic_vector (31 downto 0);
  signal n1791 : std_logic_vector (31 downto 0);
  signal n1792 : std_logic_vector (31 downto 0);
  signal n1802 : std_logic;
  signal n1804 : std_logic_vector (163 downto 0);
  signal n1805 : std_logic_vector (163 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  signal n1806 : std_logic_vector (163 downto 0);
  signal n1807 : std_logic_vector (31 downto 0);
begin
  busy <= n1757;
  pixel_valid <= n1802;
  pixel_x <= n1541;
  pixel_y <= n1542;
  n1538 <= center_y & center_x;
  n1541 <= n1807 (15 downto 0);
  n1542 <= n1807 (31 downto 16);
  state <= n1805; -- (isignal)
  state_nxt <= n1806; -- (signal)
  n1545 <= not res_n;
  n1548 <= '1' when unsigned'(1 => stall) <= unsigned'("0") else '0';
  n1562 <= "0000000000000000" & radius;  --  uext
  n1563 <= "0" & n1562;  --  uext
  n1564 <= n1538 (15 downto 0);
  n1565 <= std_logic_vector (resize (signed (n1564), 32));  --  sext
  n1566 <= n1538 (31 downto 16);
  n1567 <= std_logic_vector (resize (signed (n1566), 32));  --  sext
  n1570 <= state (67 downto 36);
  n1571 <= state (99 downto 68);
  n1572 <= state (35 downto 4);
  n1573 <= state (3 downto 0);
  n1575 <= state (3 downto 0);
  n1576 <= n1575 when start = '0' else "0001";
  n1578 <= '1' when n1573 = "0000" else '0';
  n1580 <= std_logic_vector (unsigned'("00000000000000000000000000000001") - unsigned (n1563));
  n1583 <= std_logic_vector (resize (signed'("00000000000000000000000000000010") * signed (n1563), 32));
  n1584 <= std_logic_vector(-signed (n1583));
  n1588 <= '1' when n1573 = "0001" else '0';
  n1590 <= std_logic_vector (unsigned (n1567) + unsigned (n1563));
  n1593 <= n1590 (15 downto 0);  --  trunc
  n1596 <= '1' when n1573 = "0011" else '0';
  n1598 <= std_logic_vector (unsigned (n1567) - unsigned (n1563));
  n1601 <= n1598 (15 downto 0);  --  trunc
  n1604 <= '1' when n1573 = "0100" else '0';
  n1606 <= std_logic_vector (unsigned (n1565) + unsigned (n1563));
  n1609 <= n1606 (15 downto 0);  --  trunc
  n1612 <= '1' when n1573 = "0101" else '0';
  n1614 <= std_logic_vector (unsigned (n1565) - unsigned (n1563));
  n1617 <= n1614 (15 downto 0);  --  trunc
  n1620 <= '1' when n1573 = "0110" else '0';
  n1621 <= state (131 downto 100);
  n1622 <= state (163 downto 132);
  n1623 <= '1' when signed (n1621) < signed (n1622) else '0';
  n1624 <= state (35 downto 4);
  n1626 <= '1' when signed (n1624) >= signed'("00000000000000000000000000000000") else '0';
  n1627 <= state (163 downto 132);
  n1629 <= std_logic_vector (unsigned (n1627) - unsigned'("00000000000000000000000000000001"));
  n1631 <= std_logic_vector (unsigned (n1571) + unsigned'("00000000000000000000000000000010"));
  n1632 <= std_logic_vector (unsigned (n1572) + unsigned (n1631));
  n1633 <= state (163 downto 132);
  n1634 <= n1633 when n1626 = '0' else n1629;
  n1635 <= n1571 when n1626 = '0' else n1631;
  n1636 <= n1572 when n1626 = '0' else n1632;
  n1637 <= state (131 downto 100);
  n1639 <= std_logic_vector (unsigned (n1637) + unsigned'("00000000000000000000000000000001"));
  n1641 <= std_logic_vector (unsigned (n1570) + unsigned'("00000000000000000000000000000010"));
  n1642 <= std_logic_vector (unsigned (n1636) + unsigned (n1641));
  n1644 <= std_logic_vector (unsigned (n1642) + unsigned'("00000000000000000000000000000001"));
  n1647 <= n1634 & n1639 & n1635 & n1641 & n1644 & "0111";
  n1648 <= n1647 (3 downto 0);
  n1649 <= "0000" when n1623 = '0' else n1648;
  n1650 <= n1647 (163 downto 4);
  n1651 <= state (163 downto 4);
  n1652 <= n1651 when n1623 = '0' else n1650;
  n1657 <= '1' when n1573 = "0010" else '0';
  n1659 <= state (131 downto 100);
  n1660 <= std_logic_vector (unsigned (n1565) + unsigned (n1659));
  n1661 <= state (163 downto 132);
  n1662 <= std_logic_vector (unsigned (n1567) + unsigned (n1661));
  n1665 <= n1660 (15 downto 0);  --  trunc
  n1666 <= n1662 (15 downto 0);  --  trunc
  n1669 <= '1' when n1573 = "0111" else '0';
  n1671 <= state (131 downto 100);
  n1672 <= std_logic_vector (unsigned (n1565) - unsigned (n1671));
  n1673 <= state (163 downto 132);
  n1674 <= std_logic_vector (unsigned (n1567) + unsigned (n1673));
  n1677 <= n1672 (15 downto 0);  --  trunc
  n1678 <= n1674 (15 downto 0);  --  trunc
  n1681 <= '1' when n1573 = "1000" else '0';
  n1683 <= state (131 downto 100);
  n1684 <= std_logic_vector (unsigned (n1565) + unsigned (n1683));
  n1685 <= state (163 downto 132);
  n1686 <= std_logic_vector (unsigned (n1567) - unsigned (n1685));
  n1689 <= n1684 (15 downto 0);  --  trunc
  n1690 <= n1686 (15 downto 0);  --  trunc
  n1693 <= '1' when n1573 = "1001" else '0';
  n1695 <= state (131 downto 100);
  n1696 <= std_logic_vector (unsigned (n1565) - unsigned (n1695));
  n1697 <= state (163 downto 132);
  n1698 <= std_logic_vector (unsigned (n1567) - unsigned (n1697));
  n1701 <= n1696 (15 downto 0);  --  trunc
  n1702 <= n1698 (15 downto 0);  --  trunc
  n1705 <= '1' when n1573 = "1010" else '0';
  n1707 <= state (163 downto 132);
  n1708 <= std_logic_vector (unsigned (n1565) + unsigned (n1707));
  n1709 <= state (131 downto 100);
  n1710 <= std_logic_vector (unsigned (n1567) + unsigned (n1709));
  n1713 <= n1708 (15 downto 0);  --  trunc
  n1714 <= n1710 (15 downto 0);  --  trunc
  n1717 <= '1' when n1573 = "1011" else '0';
  n1719 <= state (163 downto 132);
  n1720 <= std_logic_vector (unsigned (n1565) - unsigned (n1719));
  n1721 <= state (131 downto 100);
  n1722 <= std_logic_vector (unsigned (n1567) + unsigned (n1721));
  n1725 <= n1720 (15 downto 0);  --  trunc
  n1726 <= n1722 (15 downto 0);  --  trunc
  n1729 <= '1' when n1573 = "1100" else '0';
  n1731 <= state (163 downto 132);
  n1732 <= std_logic_vector (unsigned (n1565) + unsigned (n1731));
  n1733 <= state (131 downto 100);
  n1734 <= std_logic_vector (unsigned (n1567) - unsigned (n1733));
  n1737 <= n1732 (15 downto 0);  --  trunc
  n1738 <= n1734 (15 downto 0);  --  trunc
  n1741 <= '1' when n1573 = "1101" else '0';
  n1743 <= state (163 downto 132);
  n1744 <= std_logic_vector (unsigned (n1565) - unsigned (n1743));
  n1745 <= state (131 downto 100);
  n1746 <= std_logic_vector (unsigned (n1567) - unsigned (n1745));
  n1749 <= n1744 (15 downto 0);  --  trunc
  n1750 <= n1746 (15 downto 0);  --  trunc
  n1753 <= '1' when n1573 = "1110" else '0';
  n1754 <= n1753 & n1741 & n1729 & n1717 & n1705 & n1693 & n1681 & n1669 & n1657 & n1620 & n1612 & n1604 & n1596 & n1588 & n1578;
  with n1754 select n1757 <=
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
  with n1754 select n1772 <=
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
  with n1754 select n1774 <=
    n1749 when "100000000000000",
    n1737 when "010000000000000",
    n1725 when "001000000000000",
    n1713 when "000100000000000",
    n1701 when "000010000000000",
    n1689 when "000001000000000",
    n1677 when "000000100000000",
    n1665 when "000000010000000",
    "0000000000000000" when "000000001000000",
    n1617 when "000000000100000",
    n1609 when "000000000010000",
    n1564 when "000000000001000",
    n1564 when "000000000000100",
    "0000000000000000" when "000000000000010",
    "0000000000000000" when "000000000000001",
    "0000000000000000" when others;
  with n1754 select n1775 <=
    n1750 when "100000000000000",
    n1738 when "010000000000000",
    n1726 when "001000000000000",
    n1714 when "000100000000000",
    n1702 when "000010000000000",
    n1690 when "000001000000000",
    n1678 when "000000100000000",
    n1666 when "000000010000000",
    "0000000000000000" when "000000001000000",
    n1566 when "000000000100000",
    n1566 when "000000000010000",
    n1601 when "000000000001000",
    n1593 when "000000000000100",
    "0000000000000000" when "000000000000010",
    "0000000000000000" when "000000000000001",
    "0000000000000000" when others;
  n1776 <= state (3 downto 0);
  with n1754 select n1777 <=
    "0010" when "100000000000000",
    "1110" when "010000000000000",
    "1101" when "001000000000000",
    "1100" when "000100000000000",
    "1011" when "000010000000000",
    "1010" when "000001000000000",
    "1001" when "000000100000000",
    "1000" when "000000010000000",
    n1649 when "000000001000000",
    "0010" when "000000000100000",
    "0110" when "000000000010000",
    "0101" when "000000000001000",
    "0100" when "000000000000100",
    "0011" when "000000000000010",
    n1576 when "000000000000001",
    n1776 when others;
  n1778 <= n1652 (31 downto 0);
  n1779 <= state (35 downto 4);
  with n1754 select n1780 <=
    n1779 when "100000000000000",
    n1779 when "010000000000000",
    n1779 when "001000000000000",
    n1779 when "000100000000000",
    n1779 when "000010000000000",
    n1779 when "000001000000000",
    n1779 when "000000100000000",
    n1779 when "000000010000000",
    n1778 when "000000001000000",
    n1779 when "000000000100000",
    n1779 when "000000000010000",
    n1779 when "000000000001000",
    n1779 when "000000000000100",
    n1580 when "000000000000010",
    n1779 when "000000000000001",
    n1779 when others;
  n1781 <= n1652 (63 downto 32);
  n1782 <= state (67 downto 36);
  with n1754 select n1783 <=
    n1782 when "100000000000000",
    n1782 when "010000000000000",
    n1782 when "001000000000000",
    n1782 when "000100000000000",
    n1782 when "000010000000000",
    n1782 when "000001000000000",
    n1782 when "000000100000000",
    n1782 when "000000010000000",
    n1781 when "000000001000000",
    n1782 when "000000000100000",
    n1782 when "000000000010000",
    n1782 when "000000000001000",
    n1782 when "000000000000100",
    "00000000000000000000000000000000" when "000000000000010",
    n1782 when "000000000000001",
    n1782 when others;
  n1784 <= n1652 (95 downto 64);
  n1785 <= state (99 downto 68);
  with n1754 select n1786 <=
    n1785 when "100000000000000",
    n1785 when "010000000000000",
    n1785 when "001000000000000",
    n1785 when "000100000000000",
    n1785 when "000010000000000",
    n1785 when "000001000000000",
    n1785 when "000000100000000",
    n1785 when "000000010000000",
    n1784 when "000000001000000",
    n1785 when "000000000100000",
    n1785 when "000000000010000",
    n1785 when "000000000001000",
    n1785 when "000000000000100",
    n1584 when "000000000000010",
    n1785 when "000000000000001",
    n1785 when others;
  n1787 <= n1652 (127 downto 96);
  n1788 <= state (131 downto 100);
  with n1754 select n1789 <=
    n1788 when "100000000000000",
    n1788 when "010000000000000",
    n1788 when "001000000000000",
    n1788 when "000100000000000",
    n1788 when "000010000000000",
    n1788 when "000001000000000",
    n1788 when "000000100000000",
    n1788 when "000000010000000",
    n1787 when "000000001000000",
    n1788 when "000000000100000",
    n1788 when "000000000010000",
    n1788 when "000000000001000",
    n1788 when "000000000000100",
    "00000000000000000000000000000000" when "000000000000010",
    n1788 when "000000000000001",
    n1788 when others;
  n1790 <= n1652 (159 downto 128);
  n1791 <= state (163 downto 132);
  with n1754 select n1792 <=
    n1791 when "100000000000000",
    n1791 when "010000000000000",
    n1791 when "001000000000000",
    n1791 when "000100000000000",
    n1791 when "000010000000000",
    n1791 when "000001000000000",
    n1791 when "000000100000000",
    n1791 when "000000010000000",
    n1790 when "000000001000000",
    n1791 when "000000000100000",
    n1791 when "000000000010000",
    n1791 when "000000000001000",
    n1791 when "000000000000100",
    n1563 when "000000000000010",
    n1791 when "000000000000001",
    n1791 when others;
  n1802 <= n1772 when stall = '0' else '0';
  n1804 <= state when n1548 = '0' else state_nxt;
  process (clk, n1545)
  begin
    if n1545 = '1' then
      n1805 <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (clk) then
      n1805 <= n1804;
    end if;
  end process;
  n1806 <= n1792 & n1789 & n1786 & n1783 & n1780 & n1777;
  n1807 <= n1775 & n1774;
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
  signal n1532 : std_logic_vector (61 downto 0);
  signal n1533 : std_logic_vector (61 downto 0) := "00000000000000000000000000000000000000000000000000000000000000";
  signal n1535 : std_logic_vector (61 downto 0);
begin
  rd1_data <= n1533;
  n1532 <= n1533 when rd1 = '0' else n1535;
  process (clk)
  begin
    if rising_edge (clk) then
      n1533 <= n1532;
    end if;
  end process;
  process (rd1_addr, clk) is
    type ram_type is array (0 to 7)
      of std_logic_vector (61 downto 0);
    variable ram : ram_type := (others => (others => '0'));
  begin
    n1535 <= ram(to_integer (unsigned (rd1_addr)));
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
  subtype typwrap_fifo_gfx_cmd is std_logic_vector (15 downto 0);
  signal wrap_fifo_gfx_cmd: typwrap_fifo_gfx_cmd;
  signal wrap_fifo_gfx_cmd_empty: std_logic;
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
  signal wrap_fifo_gfx_cmd_rd: std_logic;
  subtype typwrap_rd_data is std_logic_vector (15 downto 0);
  signal wrap_rd_data: typwrap_rd_data;
  signal wrap_rd_valid: std_logic;
  signal wrap_frame_sync: std_logic;
  signal operand_buffer : std_logic_vector (63 downto 0);
  signal state : std_logic_vector (309 downto 0);
  signal state_nxt : std_logic_vector (309 downto 0);
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
  signal bdt_wr : std_logic;
  signal bdt_rd : std_logic;
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
  signal n615 : std_logic_vector (15 downto 0);
  signal n617 : std_logic_vector (15 downto 0);
  signal n622 : std_logic;
  signal n626 : std_logic;
  signal n629 : std_logic;
  signal n635 : std_logic;
  signal n641 : std_logic;
  signal n643 : std_logic_vector (15 downto 0);
  signal n645 : std_logic_vector (15 downto 0);
  signal n646 : std_logic_vector (15 downto 0);
  signal n647 : std_logic;
  signal n649 : std_logic;
  signal n651 : std_logic_vector (15 downto 0);
  signal n652 : std_logic_vector (15 downto 0);
  signal n653 : std_logic_vector (15 downto 0);
  signal n654 : std_logic_vector (15 downto 0);
  signal n655 : std_logic;
  signal n657 : std_logic_vector (15 downto 0);
  signal n659 : std_logic_vector (15 downto 0);
  signal n660 : std_logic_vector (15 downto 0);
  signal n661 : std_logic_vector (15 downto 0);
  signal n663 : std_logic;
  signal n665 : std_logic_vector (15 downto 0);
  signal n667 : std_logic_vector (15 downto 0);
  signal n669 : std_logic_vector (15 downto 0);
  signal n671 : std_logic_vector (15 downto 0);
  signal n672 : std_logic_vector (15 downto 0);
  signal n673 : std_logic_vector (31 downto 0);
  signal n674 : std_logic_vector (5 downto 0);
  signal n675 : std_logic_vector (5 downto 0);
  signal n676 : std_logic_vector (15 downto 0);
  signal n677 : std_logic_vector (15 downto 0);
  signal n678 : std_logic_vector (31 downto 0);
  signal n679 : std_logic_vector (31 downto 0);
  signal n681 : std_logic;
  signal n682 : std_logic_vector (15 downto 0);
  signal n683 : std_logic_vector (15 downto 0);
  signal n685 : std_logic;
  signal n687 : std_logic;
  signal n689 : std_logic_vector (15 downto 0);
  signal n692 : std_logic;
  signal n695 : std_logic_vector (15 downto 0);
  signal n697 : std_logic_vector (15 downto 0);
  signal n702 : std_logic;
  signal n706 : std_logic;
  signal n709 : std_logic;
  signal n715 : std_logic;
  signal n721 : std_logic;
  signal n723 : std_logic_vector (15 downto 0);
  signal n725 : std_logic_vector (15 downto 0);
  signal n726 : std_logic_vector (15 downto 0);
  signal n727 : std_logic;
  signal n729 : std_logic;
  signal n731 : std_logic_vector (15 downto 0);
  signal n733 : std_logic_vector (15 downto 0);
  signal n734 : std_logic_vector (15 downto 0);
  signal n735 : std_logic_vector (15 downto 0);
  signal n736 : std_logic;
  signal n738 : std_logic_vector (15 downto 0);
  signal n739 : std_logic_vector (15 downto 0);
  signal n740 : std_logic_vector (15 downto 0);
  signal n741 : std_logic_vector (15 downto 0);
  signal n743 : std_logic;
  signal n745 : std_logic_vector (15 downto 0);
  signal n747 : std_logic_vector (15 downto 0);
  signal n749 : std_logic_vector (15 downto 0);
  signal n751 : std_logic_vector (15 downto 0);
  signal n752 : std_logic_vector (15 downto 0);
  signal n753 : std_logic_vector (31 downto 0);
  signal n754 : std_logic_vector (5 downto 0);
  signal n755 : std_logic_vector (5 downto 0);
  signal n756 : std_logic_vector (15 downto 0);
  signal n757 : std_logic_vector (15 downto 0);
  signal n758 : std_logic_vector (31 downto 0);
  signal n759 : std_logic_vector (31 downto 0);
  signal n760 : std_logic_vector (47 downto 0);
  signal n762 : std_logic;
  signal n763 : std_logic_vector (47 downto 0);
  signal n764 : std_logic_vector (47 downto 0);
  signal n766 : std_logic;
  signal n767 : std_logic;
  signal n769 : std_logic_vector (5 downto 0);
  signal n770 : std_logic_vector (5 downto 0);
  signal n773 : std_logic;
  signal n775 : std_logic;
  signal n781 : std_logic;
  signal n785 : std_logic;
  signal n802 : std_logic;
  signal n804 : std_logic_vector (7 downto 0);
  signal n806 : std_logic_vector (31 downto 0);
  signal n807 : std_logic;
  signal n808 : std_logic;
  signal n810 : std_logic_vector (15 downto 0);
  signal n812 : std_logic_vector (15 downto 0);
  signal n813 : std_logic_vector (15 downto 0);
  signal n814 : std_logic_vector (15 downto 0);
  signal n815 : std_logic_vector (15 downto 0);
  signal n816 : std_logic;
  signal n818 : std_logic_vector (15 downto 0);
  signal n820 : std_logic_vector (15 downto 0);
  signal n821 : std_logic_vector (15 downto 0);
  signal n822 : std_logic_vector (15 downto 0);
  signal n823 : std_logic_vector (15 downto 0);
  signal n825 : std_logic_vector (31 downto 0);
  signal n826 : std_logic_vector (5 downto 0);
  signal n827 : std_logic_vector (5 downto 0);
  signal n828 : std_logic_vector (31 downto 0);
  signal n829 : std_logic_vector (31 downto 0);
  signal n831 : std_logic;
  signal n839 : std_logic;
  signal n853 : std_logic_vector (1 downto 0);
  signal n856 : std_logic_vector (15 downto 0);
  signal n859 : std_logic_vector (15 downto 0);
  signal n862 : std_logic;
  signal n864 : std_logic;
  signal n865 : std_logic;
  signal n866 : std_logic_vector (14 downto 0);
  signal n868 : std_logic_vector (15 downto 0);
  signal n870 : std_logic_vector (15 downto 0);
  signal n871 : std_logic_vector (15 downto 0);
  signal n873 : std_logic_vector (15 downto 0);
  signal n874 : std_logic_vector (15 downto 0);
  signal n876 : std_logic;
  signal n878 : std_logic;
  signal n879 : std_logic;
  signal n880 : std_logic_vector (14 downto 0);
  signal n882 : std_logic_vector (15 downto 0);
  signal n884 : std_logic_vector (15 downto 0);
  signal n885 : std_logic_vector (15 downto 0);
  signal n887 : std_logic_vector (15 downto 0);
  signal n888 : std_logic_vector (15 downto 0);
  signal n890 : std_logic;
  signal n892 : std_logic;
  signal n893 : std_logic;
  signal n895 : std_logic_vector (15 downto 0);
  signal n896 : std_logic_vector (15 downto 0);
  signal n898 : std_logic_vector (15 downto 0);
  signal n899 : std_logic_vector (15 downto 0);
  signal n901 : std_logic_vector (15 downto 0);
  signal n902 : std_logic_vector (15 downto 0);
  signal n904 : std_logic_vector (15 downto 0);
  signal n905 : std_logic_vector (15 downto 0);
  signal n906 : std_logic_vector (15 downto 0);
  signal n908 : std_logic_vector (15 downto 0);
  signal n917 : std_logic_vector (1 downto 0);
  signal n918 : std_logic_vector (7 downto 0);
  signal n919 : std_logic_vector (7 downto 0);
  signal n921 : std_logic;
  signal n922 : std_logic_vector (7 downto 0);
  signal n923 : std_logic_vector (7 downto 0);
  signal n925 : std_logic;
  signal n926 : std_logic_vector (7 downto 0);
  signal n927 : std_logic_vector (7 downto 0);
  signal n929 : std_logic;
  signal n930 : std_logic_vector (2 downto 0);
  signal n935 : std_logic;
  signal n943 : std_logic_vector (7 downto 0);
  signal n948 : std_logic_vector (7 downto 0);
  signal n949 : std_logic;
  signal n954 : std_logic;
  signal n958 : std_logic;
  signal n961 : std_logic;
  signal n967 : std_logic;
  signal n973 : std_logic;
  signal n975 : std_logic_vector (15 downto 0);
  signal n976 : std_logic_vector (14 downto 0);
  signal n978 : std_logic_vector (14 downto 0);
  signal n979 : std_logic_vector (15 downto 0);
  signal n980 : std_logic;
  signal n983 : std_logic_vector (15 downto 0);
  signal n984 : std_logic_vector (14 downto 0);
  signal n986 : std_logic_vector (14 downto 0);
  signal n987 : std_logic_vector (15 downto 0);
  signal n988 : std_logic;
  signal n991 : std_logic_vector (15 downto 0);
  signal n993 : std_logic_vector (15 downto 0);
  signal n994 : std_logic_vector (5 downto 0);
  signal n995 : std_logic_vector (5 downto 0);
  signal n996 : std_logic_vector (15 downto 0);
  signal n997 : std_logic_vector (15 downto 0);
  signal n999 : std_logic_vector (15 downto 0);
  signal n1001 : std_logic_vector (15 downto 0);
  signal n1002 : std_logic_vector (31 downto 0);
  signal n1004 : std_logic;
  signal n1005 : std_logic_vector (15 downto 0);
  signal n1006 : std_logic_vector (15 downto 0);
  signal n1007 : std_logic_vector (15 downto 0);
  signal n1008 : std_logic_vector (15 downto 0);
  signal n1009 : std_logic_vector (15 downto 0);
  signal n1010 : std_logic_vector (31 downto 0);
  signal n1012 : std_logic;
  signal n1013 : std_logic_vector (31 downto 0);
  signal n1014 : std_logic_vector (31 downto 0);
  signal n1017 : std_logic;
  signal n1019 : std_logic;
  signal n1021 : std_logic;
  signal n1023 : std_logic;
  signal n1025 : std_logic_vector (7 downto 0);
  signal n1026 : std_logic_vector (31 downto 0);
  signal n1028 : std_logic_vector (31 downto 0);
  signal n1030 : std_logic;
  signal n1032 : std_logic;
  signal n1034 : std_logic;
  signal n1044 : std_logic_vector (1 downto 0);
  signal n1046 : std_logic;
  signal n1048 : std_logic;
  signal n1050 : std_logic;
  signal n1051 : std_logic;
  signal n1053 : std_logic_vector (15 downto 0);
  signal n1054 : std_logic_vector (14 downto 0);
  signal n1056 : std_logic_vector (15 downto 0);
  signal n1057 : std_logic_vector (15 downto 0);
  signal n1059 : std_logic_vector (15 downto 0);
  signal n1060 : std_logic_vector (14 downto 0);
  signal n1062 : std_logic_vector (15 downto 0);
  signal n1063 : std_logic_vector (15 downto 0);
  signal n1064 : std_logic_vector (15 downto 0);
  signal n1065 : std_logic_vector (15 downto 0);
  signal n1066 : std_logic_vector (15 downto 0);
  signal n1067 : std_logic;
  signal n1069 : std_logic;
  signal n1071 : std_logic;
  signal n1072 : std_logic;
  signal n1074 : std_logic_vector (15 downto 0);
  signal n1075 : std_logic_vector (14 downto 0);
  signal n1077 : std_logic_vector (15 downto 0);
  signal n1078 : std_logic_vector (15 downto 0);
  signal n1080 : std_logic_vector (15 downto 0);
  signal n1081 : std_logic_vector (14 downto 0);
  signal n1083 : std_logic_vector (15 downto 0);
  signal n1084 : std_logic_vector (15 downto 0);
  signal n1085 : std_logic_vector (15 downto 0);
  signal n1086 : std_logic_vector (15 downto 0);
  signal n1087 : std_logic_vector (15 downto 0);
  signal n1090 : std_logic;
  signal n1091 : std_logic;
  signal n1092 : std_logic_vector (20 downto 0);
  signal n1093 : std_logic;
  signal n1096 : std_logic;
  signal n1099 : std_logic_vector (5 downto 0);
  signal n1100 : std_logic_vector (5 downto 0);
  signal n1103 : std_logic;
  signal n1105 : std_logic_vector (20 downto 0);
  signal n1107 : std_logic_vector (15 downto 0);
  signal n1109 : std_logic;
  signal n1111 : std_logic;
  signal n1112 : std_logic_vector (20 downto 0);
  signal n1115 : std_logic;
  signal n1116 : std_logic_vector (20 downto 0);
  signal n1119 : std_logic;
  signal n1120 : std_logic;
  signal n1126 : std_logic_vector (4 downto 0);
  signal n1128 : std_logic;
  signal n1131 : std_logic;
  signal n1132 : std_logic_vector (15 downto 0);
  signal n1134 : std_logic_vector (15 downto 0);
  signal n1137 : std_logic;
  signal n1138 : std_logic_vector (5 downto 0);
  signal n1139 : std_logic_vector (5 downto 0);
  signal n1140 : std_logic_vector (15 downto 0);
  signal n1141 : std_logic_vector (15 downto 0);
  signal n1143 : std_logic;
  signal n1144 : std_logic_vector (20 downto 0);
  signal n1150 : std_logic_vector (4 downto 0);
  signal n1152 : std_logic;
  signal n1153 : std_logic_vector (15 downto 0);
  signal n1154 : std_logic;
  signal n1155 : std_logic;
  signal n1156 : std_logic_vector (20 downto 0);
  signal n1158 : std_logic_vector (20 downto 0);
  signal n1159 : std_logic_vector (20 downto 0);
  signal n1161 : std_logic_vector (20 downto 0);
  signal n1162 : std_logic_vector (20 downto 0);
  signal n1165 : std_logic;
  signal n1166 : std_logic_vector (15 downto 0);
  signal n1168 : std_logic;
  signal n1171 : std_logic_vector (5 downto 0);
  signal n1172 : std_logic_vector (5 downto 0);
  signal n1173 : std_logic_vector (5 downto 0);
  signal n1174 : std_logic_vector (20 downto 0);
  signal n1175 : std_logic_vector (20 downto 0);
  signal n1178 : std_logic;
  signal n1180 : std_logic;
  signal n1182 : std_logic;
  signal n1184 : std_logic_vector (20 downto 0);
  signal n1185 : std_logic;
  signal n1188 : std_logic;
  signal n1191 : std_logic;
  signal n1193 : std_logic;
  signal n1195 : std_logic_vector (5 downto 0);
  signal n1196 : std_logic_vector (5 downto 0);
  signal n1197 : std_logic_vector (15 downto 0);
  signal n1198 : std_logic_vector (15 downto 0);
  signal n1200 : std_logic;
  signal n1203 : std_logic;
  signal n1205 : std_logic_vector (31 downto 0);
  signal n1207 : std_logic;
  signal n1209 : std_logic_vector (31 downto 0);
  signal n1211 : std_logic;
  signal n1212 : std_logic_vector (31 downto 0);
  signal n1213 : std_logic;
  signal n1217 : std_logic;
  signal n1218 : std_logic_vector (5 downto 0);
  signal n1219 : std_logic_vector (5 downto 0);
  signal n1223 : std_logic;
  signal n1224 : std_logic_vector (5 downto 0);
  signal n1225 : std_logic_vector (15 downto 0);
  signal n1226 : std_logic_vector (15 downto 0);
  signal n1228 : std_logic;
  signal n1229 : std_logic_vector (31 downto 0);
  signal n1231 : std_logic_vector (5 downto 0);
  signal n1232 : std_logic_vector (5 downto 0);
  signal n1233 : std_logic_vector (15 downto 0);
  signal n1234 : std_logic_vector (15 downto 0);
  signal n1236 : std_logic;
  signal n1238 : std_logic;
  signal n1240 : std_logic_vector (15 downto 0);
  signal n1242 : std_logic_vector (15 downto 0);
  signal n1243 : std_logic_vector (15 downto 0);
  signal n1244 : std_logic_vector (15 downto 0);
  signal n1245 : std_logic;
  signal n1247 : std_logic_vector (15 downto 0);
  signal n1249 : std_logic_vector (15 downto 0);
  signal n1250 : std_logic_vector (15 downto 0);
  signal n1251 : std_logic_vector (15 downto 0);
  signal n1253 : std_logic;
  signal n1254 : std_logic_vector (33 downto 0);
  signal n1255 : std_logic_vector (20 downto 0);
  signal n1257 : std_logic;
  signal n1260 : std_logic;
  signal n1263 : std_logic;
  signal n1268 : std_logic;
  signal n1271 : std_logic;
  signal n1273 : std_logic_vector (5 downto 0);
  signal n1274 : std_logic_vector (5 downto 0);
  signal n1275 : std_logic_vector (15 downto 0);
  signal n1276 : std_logic_vector (15 downto 0);
  signal n1277 : std_logic_vector (1 downto 0);
  signal n1278 : std_logic_vector (1 downto 0);
  signal n1279 : std_logic_vector (20 downto 0);
  signal n1280 : std_logic_vector (20 downto 0);
  signal n1281 : std_logic_vector (20 downto 0);
  signal n1282 : std_logic_vector (20 downto 0);
  signal n1283 : std_logic_vector (15 downto 0);
  signal n1284 : std_logic_vector (15 downto 0);
  signal n1285 : std_logic_vector (14 downto 0);
  signal n1286 : std_logic_vector (14 downto 0);
  signal n1287 : std_logic_vector (14 downto 0);
  signal n1288 : std_logic_vector (14 downto 0);
  signal n1289 : std_logic_vector (14 downto 0);
  signal n1290 : std_logic_vector (14 downto 0);
  signal n1291 : std_logic_vector (14 downto 0);
  signal n1292 : std_logic_vector (14 downto 0);
  signal n1293 : std_logic_vector (15 downto 0);
  signal n1294 : std_logic_vector (15 downto 0);
  signal n1295 : std_logic_vector (15 downto 0);
  signal n1296 : std_logic_vector (15 downto 0);
  signal n1297 : std_logic_vector (15 downto 0);
  signal n1298 : std_logic_vector (15 downto 0);
  signal n1299 : std_logic_vector (15 downto 0);
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
  signal n1320 : std_logic_vector (7 downto 0);
  signal n1321 : std_logic_vector (7 downto 0);
  signal n1322 : std_logic_vector (7 downto 0);
  signal n1323 : std_logic_vector (7 downto 0);
  signal n1324 : std_logic_vector (61 downto 0);
  signal n1325 : std_logic_vector (61 downto 0);
  signal n1326 : std_logic_vector (7 downto 0);
  signal n1327 : std_logic_vector (7 downto 0);
  signal n1328 : std_logic_vector (1 downto 0);
  signal n1329 : std_logic_vector (1 downto 0);
  signal n1350 : std_logic;
  signal n1353 : std_logic_vector (7 downto 0);
  signal n1355 : std_logic_vector (15 downto 0);
  signal n1356 : std_logic_vector (15 downto 0);
  signal n1357 : std_logic_vector (15 downto 0);
  signal n1358 : std_logic_vector (15 downto 0);
  signal n1359 : std_logic_vector (15 downto 0);
  signal n1360 : std_logic_vector (15 downto 0);
  signal n1361 : std_logic_vector (15 downto 0);
  signal n1362 : std_logic_vector (15 downto 0);
  signal n1364 : std_logic_vector (15 downto 0);
  signal n1365 : std_logic_vector (15 downto 0);
  signal n1366 : std_logic_vector (15 downto 0);
  signal n1367 : std_logic_vector (15 downto 0);
  signal n1368 : std_logic_vector (15 downto 0);
  signal n1369 : std_logic_vector (15 downto 0);
  signal n1370 : std_logic_vector (15 downto 0);
  signal n1371 : std_logic_vector (15 downto 0);
  signal n1372 : std_logic_vector (15 downto 0);
  signal n1374 : std_logic_vector (15 downto 0);
  signal n1382 : std_logic;
  signal n1385 : std_logic;
  signal n1388 : std_logic_vector (20 downto 0);
  signal n1391 : std_logic_vector (15 downto 0);
  signal n1394 : std_logic;
  signal n1397 : std_logic;
  signal n1400 : std_logic;
  signal n1404 : std_logic;
  signal n1407 : std_logic;
  signal n1410 : std_logic;
  signal n1415 : std_logic_vector (20 downto 0);
  signal n1417 : std_logic_vector (15 downto 0);
  signal n1420 : std_logic;
  signal n1422 : std_logic;
  signal n1423 : std_logic_vector (20 downto 0);
  signal n1425 : std_logic_vector (15 downto 0);
  signal n1428 : std_logic;
  signal n1430 : std_logic;
  signal gfx_circle_inst_c_busy : std_logic;
  signal gfx_circle_inst_c_pixel_valid : std_logic;
  signal gfx_circle_inst_c_pixel_x : std_logic_vector (15 downto 0);
  signal gfx_circle_inst_c_pixel_y : std_logic_vector (15 downto 0);
  signal n1434 : std_logic_vector (31 downto 0);
  signal n1435 : std_logic_vector (15 downto 0);
  signal n1436 : std_logic_vector (15 downto 0);
  signal n1438 : std_logic_vector (31 downto 0);
  signal pw_c_wr_in_progress : std_logic;
  signal pw_c_stall : std_logic;
  signal pw_c_oob : std_logic;
  signal pw_c_vram_wr_addr : std_logic_vector (20 downto 0);
  signal pw_c_vram_wr_data : std_logic_vector (15 downto 0);
  signal pw_c_vram_wr : std_logic;
  signal pw_c_vram_wr_access_mode : std_logic;
  signal n1442 : std_logic_vector (61 downto 0);
  signal n1443 : std_logic_vector (31 downto 0);
  signal n1444 : std_logic_vector (14 downto 0);
  signal n1445 : std_logic_vector (14 downto 0);
  signal n1446 : std_logic_vector (15 downto 0);
  signal n1447 : std_logic_vector (15 downto 0);
  signal n1449 : std_logic_vector (7 downto 0);
  signal n1455 : std_logic_vector (1 downto 0);
  signal n1456 : std_logic_vector (7 downto 0);
  signal n1457 : std_logic_vector (7 downto 0);
  signal n1459 : std_logic;
  signal n1460 : std_logic_vector (7 downto 0);
  signal n1461 : std_logic_vector (7 downto 0);
  signal n1463 : std_logic;
  signal n1464 : std_logic_vector (7 downto 0);
  signal n1465 : std_logic_vector (7 downto 0);
  signal n1467 : std_logic;
  signal n1468 : std_logic_vector (2 downto 0);
  signal n1473 : std_logic;
  signal n1481 : std_logic_vector (7 downto 0);
  signal n1486 : std_logic_vector (7 downto 0);
  signal pr_c_color : std_logic_vector (7 downto 0);
  signal pr_c_color_valid : std_logic;
  signal pr_c_vram_rd_addr : std_logic_vector (20 downto 0);
  signal pr_c_vram_rd : std_logic;
  signal pr_c_vram_rd_access_mode : std_logic;
  signal n1492 : std_logic_vector (31 downto 0);
  signal n1493 : std_logic_vector (14 downto 0);
  signal n1494 : std_logic_vector (14 downto 0);
  signal n1495 : std_logic_vector (14 downto 0);
  signal n1496 : std_logic_vector (14 downto 0);
  signal n1497 : std_logic_vector (14 downto 0);
  signal n1498 : std_logic_vector (14 downto 0);
  signal n1504 : std_logic_vector (63 downto 0);
  signal n1505 : std_logic_vector (309 downto 0);
  signal n1506 : std_logic_vector (309 downto 0);
  signal n1507 : std_logic_vector (31 downto 0);
  signal n1509 : std_logic_vector (61 downto 0);
begin
  wrap_clk <= clk;
  wrap_res_n <= res_n;
  wrap_vram_wr_full <= vram_wr_full;
  wrap_vram_wr_emtpy <= vram_wr_emtpy;
  wrap_vram_rd_data <= typwrap_vram_rd_data(vram_rd_data);
  wrap_vram_rd_busy <= vram_rd_busy;
  wrap_vram_rd_valid <= vram_rd_valid;
  wrap_fr_base_addr_req <= fr_base_addr_req;
  wrap_fifo_gfx_cmd <= typwrap_fifo_gfx_cmd(fifo_gfx_cmd);
  wrap_fifo_gfx_cmd_empty <= fifo_gfx_cmd_empty;
  vram_wr_addr <= std_ulogic_vector(wrap_vram_wr_addr);
  vram_wr_data <= std_ulogic_vector(wrap_vram_wr_data);
  vram_wr <= wrap_vram_wr;
  vram_wr_access_mode <= sram_access_mode_t'val (to_integer(unsigned'(0 => wrap_vram_wr_access_mode)));
  vram_rd_addr <= std_ulogic_vector(wrap_vram_rd_addr);
  vram_rd <= wrap_vram_rd;
  vram_rd_access_mode <= sram_access_mode_t'val (to_integer(unsigned'(0 => wrap_vram_rd_access_mode)));
  fr_base_addr <= std_ulogic_vector(wrap_fr_base_addr);
  fifo_gfx_cmd_rd <= wrap_fifo_gfx_cmd_rd;
  rd_data <= gfx_cmd_t(wrap_rd_data);
  rd_valid <= wrap_rd_valid;
  frame_sync <= wrap_frame_sync;
  wrap_vram_wr_addr <= n1423;
  wrap_vram_wr_data <= n1425;
  wrap_vram_wr <= n1428;
  wrap_vram_wr_access_mode <= n1430;
  wrap_vram_rd_addr <= n1255;
  wrap_vram_rd <= n1257;
  wrap_vram_rd_access_mode <= n1260;
  wrap_fr_base_addr <= n108;
  wrap_fifo_gfx_cmd_rd <= n1263;
  wrap_rd_data <= n107;
  wrap_rd_valid <= n1268;
  wrap_frame_sync <= n1271;
  operand_buffer <= n1504; -- (signal)
  state <= n1505; -- (signal)
  state_nxt <= n1506; -- (signal)
  stall <= pw_c_stall; -- (signal)
  pw_wr <= n1350; -- (signal)
  pw_color <= n1353; -- (signal)
  pw_position <= n1507; -- (signal)
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
  bdt_wr <= n1397; -- (signal)
  bdt_rd <= n1400; -- (signal)
  pr_start <= n1404; -- (signal)
  pr_color <= pr_c_color; -- (signal)
  pr_color_valid <= pr_c_color_valid; -- (signal)
  pr_color_ack <= n1407; -- (signal)
  pr_vram_rd_addr <= pr_c_vram_rd_addr; -- (signal)
  pr_vram_rd <= pr_c_vram_rd; -- (signal)
  pr_vram_rd_access_mode <= pr_c_vram_rd_access_mode; -- (signal)
  circle_start <= n1410; -- (signal)
  circle_busy <= gfx_circle_inst_c_busy; -- (signal)
  circle_pixel_valid <= gfx_circle_inst_c_pixel_valid; -- (signal)
  circle_pixel <= n1438; -- (signal)
  instr_color <= n115; -- (signal)
  current_instr <= n12; -- (signal)
  bdt_bmpidx <= n1509; -- (signal)
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
  n16 <= state (141 downto 82);
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
  n69 <= wrap_fifo_gfx_cmd & n67 & n68;
  n72 <= "0000000000000000" & "0000000000000000" & "0000000000000000";
  n75 <= operands_buffer_operand_buffer_int when n1263 = '0' else n69;
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
  n87 <= wrap_fifo_gfx_cmd (2 downto 0);
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
  n107 <= state (81 downto 66);
  n108 <= state (44 downto 24);
  n111 <= current_instr (10);
  n112 <= not n111;
  n113 <= state (229 downto 222);
  n114 <= state (237 downto 230);
  n115 <= n114 when n112 = '0' else n113;
  n118 <= not wrap_res_n;
  n125 <= state (5 downto 0);
  n126 <= not wrap_fifo_gfx_cmd_empty;
  n130 <= '0' when n126 = '0' else '1';
  n131 <= state (5 downto 0);
  n132 <= n131 when n126 = '0' else "000001";
  n134 <= '1' when n125 = "000000" else '0';
  n142 <= wrap_fifo_gfx_cmd (15 downto 11);
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
  n245 <= wrap_fifo_gfx_cmd (15 downto 11);
  n247 <= '1' when n245 = "00000" else '0';
  n250 <= '1' when n245 = "10011" else '0';
  n253 <= '1' when n245 = "10100" else '0';
  n256 <= '1' when n245 = "11111" else '0';
  n259 <= '1' when n245 = "01110" else '0';
  n260 <= wrap_fifo_gfx_cmd (10);
  n261 <= not n260;
  n262 <= wrap_fifo_gfx_cmd (7 downto 0);
  n263 <= wrap_fifo_gfx_cmd (7 downto 0);
  n264 <= state (229 downto 222);
  n265 <= n264 when n261 = '0' else n262;
  n266 <= state (237 downto 230);
  n267 <= n263 when n261 = '0' else n266;
  n270 <= '1' when n245 = "10000" else '0';
  n273 <= '1' when n245 = "00100" else '0';
  n276 <= '1' when n245 = "00101" else '0';
  n277 <= wrap_fifo_gfx_cmd (10);
  n278 <= not n277;
  n280 <= state (205 downto 190);
  n281 <= wrap_fifo_gfx_cmd (9 downto 0);
  n282 <= std_logic_vector (resize (signed (n281), 16));  --  sext
  n283 <= std_logic_vector (unsigned (n280) + unsigned (n282));
  n285 <= state (221 downto 206);
  n286 <= wrap_fifo_gfx_cmd (9 downto 0);
  n287 <= std_logic_vector (resize (signed (n286), 16));  --  sext
  n288 <= std_logic_vector (unsigned (n285) + unsigned (n287));
  n289 <= state (205 downto 190);
  n290 <= n289 when n278 = '0' else n283;
  n291 <= state (221 downto 206);
  n292 <= n288 when n278 = '0' else n291;
  n295 <= '1' when n245 = "00010" else '0';
  n298 <= '1' when n245 = "11001" else '0';
  n299 <= wrap_fifo_gfx_cmd (7 downto 0);
  n305 <= wrap_fifo_gfx_cmd (9 downto 8);
  n308 <= '1' when n245 = "10001" else '0';
  n311 <= '1' when n245 = "01011" else '0';
  n312 <= n311 & n308 & n298 & n295 & n276 & n273 & n270 & n259 & n256 & n253 & n250 & n247;
  with n312 select n313 <=
    "011010" when "100000000000",
    "000000" when "010000000000",
    "001001" when "001000000000",
    "000000" when "000100000000",
    "000100" when "000010000000",
    "010100" when "000001000000",
    "000000" when "000000100000",
    "000010" when "000000010000",
    "000000" when "000000001000",
    "010011" when "000000000100",
    "000101" when "000000000010",
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
  n332 <= wrap_fifo_gfx_cmd (15 downto 11);
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
  n352 <= not wrap_fifo_gfx_cmd_empty;
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
    "001000" when "0010000000",
    "001010" when "0001000000",
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
  n443 <= '1' when n125 = "001000" else '0';
  n445 <= operand_buffer (15 downto 0);
  n446 <= n445 (14 downto 0);  --  trunc
  n447 <= operand_buffer (31 downto 16);
  n448 <= n447 (14 downto 0);  --  trunc
  n449 <= operand_buffer (47 downto 32);
  n450 <= n449 (14 downto 0);  --  trunc
  n451 <= operand_buffer (63 downto 48);
  n452 <= n451 (14 downto 0);  --  trunc
  n454 <= '1' when n125 = "001010" else '0';
  n458 <= bdt_bmpidx (46 downto 32);
  n459 <= bdt_bmpidx (61 downto 47);
  n461 <= '1' when n125 = "001001" else '0';
  n464 <= '1' when n125 = "000101" else '0';
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
  n522 <= state (44 downto 24);
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
  n615 <= state (173 downto 158);
  n617 <= state (221 downto 206);
  n622 <= not stall;
  n626 <= '0' when n622 = '0' else '1';
  n629 <= '1' when n622 = '0' else '0';
  n635 <= 'X' when n622 = '0' else '1';
  n641 <= n635 when n629 = '0' else '0';
  n643 <= state (173 downto 158);
  n645 <= state (205 downto 190);
  n646 <= std_logic_vector (unsigned (n645) + unsigned (dx));
  n647 <= '1' when n643 = n646 else '0';
  n649 <= current_instr (4);
  n651 <= state (205 downto 190);
  n652 <= std_logic_vector (unsigned (n651) + unsigned (dx));
  n653 <= state (205 downto 190);
  n654 <= n653 when n649 = '0' else n652;
  n655 <= current_instr (5);
  n657 <= state (221 downto 206);
  n659 <= std_logic_vector (unsigned (n657) + unsigned'("0000000000000001"));
  n660 <= state (221 downto 206);
  n661 <= n660 when n655 = '0' else n659;
  n663 <= '1' when signed (dx) < signed'("0000000000000000") else '0';
  n665 <= state (173 downto 158);
  n667 <= std_logic_vector (unsigned (n665) - unsigned'("0000000000000001"));
  n669 <= state (173 downto 158);
  n671 <= std_logic_vector (unsigned (n669) + unsigned'("0000000000000001"));
  n672 <= n671 when n663 = '0' else n667;
  n673 <= n661 & n654;
  n674 <= state (5 downto 0);
  n675 <= n674 when n681 = '0' else "000000";
  n676 <= state (173 downto 158);
  n677 <= n672 when n647 = '0' else n676;
  n678 <= state (221 downto 190);
  n679 <= n678 when n685 = '0' else n673;
  n681 <= n647 and n641;
  n682 <= state (173 downto 158);
  n683 <= n682 when n641 = '0' else n677;
  n685 <= n647 and n641;
  n687 <= '1' when n125 = "010111" else '0';
  n689 <= state (221 downto 206);
  n692 <= '1' when n125 = "011000" else '0';
  n695 <= state (205 downto 190);
  n697 <= state (189 downto 174);
  n702 <= not stall;
  n706 <= '0' when n702 = '0' else '1';
  n709 <= '1' when n702 = '0' else '0';
  n715 <= 'X' when n702 = '0' else '1';
  n721 <= n715 when n709 = '0' else '0';
  n723 <= state (189 downto 174);
  n725 <= state (221 downto 206);
  n726 <= std_logic_vector (unsigned (n725) + unsigned (dy));
  n727 <= '1' when n723 = n726 else '0';
  n729 <= current_instr (4);
  n731 <= state (205 downto 190);
  n733 <= std_logic_vector (unsigned (n731) + unsigned'("0000000000000001"));
  n734 <= state (205 downto 190);
  n735 <= n734 when n729 = '0' else n733;
  n736 <= current_instr (5);
  n738 <= state (221 downto 206);
  n739 <= std_logic_vector (unsigned (n738) + unsigned (dy));
  n740 <= state (221 downto 206);
  n741 <= n740 when n736 = '0' else n739;
  n743 <= '1' when signed (dy) < signed'("0000000000000000") else '0';
  n745 <= state (189 downto 174);
  n747 <= std_logic_vector (unsigned (n745) - unsigned'("0000000000000001"));
  n749 <= state (189 downto 174);
  n751 <= std_logic_vector (unsigned (n749) + unsigned'("0000000000000001"));
  n752 <= n751 when n743 = '0' else n747;
  n753 <= n741 & n735;
  n754 <= state (5 downto 0);
  n755 <= n754 when n762 = '0' else "000000";
  n756 <= state (189 downto 174);
  n757 <= n752 when n727 = '0' else n756;
  n758 <= state (221 downto 190);
  n759 <= n758 when n727 = '0' else n753;
  n760 <= n759 & n757;
  n762 <= n727 and n721;
  n763 <= state (221 downto 174);
  n764 <= n763 when n721 = '0' else n760;
  n766 <= '1' when n125 = "011001" else '0';
  n767 <= not stall;
  n769 <= state (5 downto 0);
  n770 <= n769 when n767 = '0' else "000111";
  n773 <= '0' when n767 = '0' else '1';
  n775 <= '1' when n125 = "000110" else '0';
  n781 <= not stall;
  n785 <= '0' when n781 = '0' else '1';
  n802 <= '0' when circle_pixel_valid = '0' else n785;
  n804 <= "00000000" when circle_pixel_valid = '0' else instr_color;
  n806 <= "00000000000000000000000000000000" when circle_pixel_valid = '0' else circle_pixel;
  n807 <= not circle_busy;
  n808 <= current_instr (4);
  n810 <= state (205 downto 190);
  n812 <= '0' & radius;
  n813 <= std_logic_vector (unsigned (n810) + unsigned (n812));
  n814 <= state (205 downto 190);
  n815 <= n814 when n808 = '0' else n813;
  n816 <= current_instr (5);
  n818 <= state (221 downto 206);
  n820 <= '0' & radius;
  n821 <= std_logic_vector (unsigned (n818) + unsigned (n820));
  n822 <= state (221 downto 206);
  n823 <= n822 when n816 = '0' else n821;
  n825 <= n823 & n815;
  n826 <= state (5 downto 0);
  n827 <= n826 when n807 = '0' else "000000";
  n828 <= state (221 downto 190);
  n829 <= n828 when n807 = '0' else n825;
  n831 <= '1' when n125 = "000111" else '0';
  n839 <= '1' when n125 = "011111" else '0';
  n853 <= current_instr (9 downto 8);
  n856 <= state (173 downto 158);
  n859 <= state (189 downto 174);
  n862 <= '1' when n853 = "10" else '0';
  n864 <= '1' when n853 = "11" else '0';
  n865 <= n862 or n864;
  n866 <= bb_section (44 downto 30);
  n868 <= '0' & n866;
  n870 <= state (173 downto 158);
  n871 <= std_logic_vector (unsigned (n868) - unsigned (n870));
  n873 <= std_logic_vector (unsigned (n871) - unsigned'("0000000000000001"));
  n874 <= n856 when n865 = '0' else n873;
  n876 <= '1' when n853 = "01" else '0';
  n878 <= '1' when n853 = "10" else '0';
  n879 <= n876 or n878;
  n880 <= bb_section (59 downto 45);
  n882 <= '0' & n880;
  n884 <= state (189 downto 174);
  n885 <= std_logic_vector (unsigned (n882) - unsigned (n884));
  n887 <= std_logic_vector (unsigned (n885) - unsigned'("0000000000000001"));
  n888 <= n859 when n879 = '0' else n887;
  n890 <= '1' when n853 = "01" else '0';
  n892 <= '1' when n853 = "11" else '0';
  n893 <= n890 or n892;
  n895 <= state (205 downto 190);
  n896 <= std_logic_vector (unsigned (n895) + unsigned (n888));
  n898 <= state (221 downto 206);
  n899 <= std_logic_vector (unsigned (n898) + unsigned (n874));
  n901 <= state (205 downto 190);
  n902 <= std_logic_vector (unsigned (n901) + unsigned (n874));
  n904 <= state (221 downto 206);
  n905 <= std_logic_vector (unsigned (n904) + unsigned (n888));
  n906 <= n902 when n893 = '0' else n896;
  n908 <= n905 when n893 = '0' else n899;
  n917 <= state (309 downto 308);
  n918 <= state (307 downto 300);
  n919 <= pr_color and n918;
  n921 <= '1' when n917 = "01" else '0';
  n922 <= state (307 downto 300);
  n923 <= pr_color or n922;
  n925 <= '1' when n917 = "10" else '0';
  n926 <= state (307 downto 300);
  n927 <= pr_color xor n926;
  n929 <= '1' when n917 = "11" else '0';
  n930 <= n929 & n925 & n921;
  with n930 select n935 <=
    '0' when "100",
    '0' when "010",
    '0' when "001",
    '1' when others;
  with n930 select n943 <=
    n927 when "100",
    n923 when "010",
    n919 when "001",
    "XXXXXXXX" when others;
  n948 <= n943 when n935 = '0' else pr_color;
  n949 <= current_instr (10);
  n954 <= not stall;
  n958 <= '0' when n954 = '0' else '1';
  n961 <= '1' when n954 = '0' else '0';
  n967 <= 'X' when n954 = '0' else '1';
  n973 <= n967 when n961 = '0' else '0';
  n975 <= state (173 downto 158);
  n976 <= bb_section (44 downto 30);
  n978 <= std_logic_vector (unsigned (n976) - unsigned'("000000000000001"));
  n979 <= "0" & n978;  --  uext
  n980 <= '1' when n975 = n979 else '0';
  n983 <= state (189 downto 174);
  n984 <= bb_section (59 downto 45);
  n986 <= std_logic_vector (unsigned (n984) - unsigned'("000000000000001"));
  n987 <= "0" & n986;  --  uext
  n988 <= '1' when n983 = n987 else '0';
  n991 <= state (189 downto 174);
  n993 <= std_logic_vector (unsigned (n991) + unsigned'("0000000000000001"));
  n994 <= state (5 downto 0);
  n995 <= n994 when n1019 = '0' else "100001";
  n996 <= state (189 downto 174);
  n997 <= n993 when n988 = '0' else n996;
  n999 <= state (173 downto 158);
  n1001 <= std_logic_vector (unsigned (n999) + unsigned'("0000000000000001"));
  n1002 <= n997 & "0000000000000000";
  n1004 <= n988 and n980;
  n1005 <= n1002 (15 downto 0);
  n1006 <= n1001 when n980 = '0' else n1005;
  n1007 <= n1002 (31 downto 16);
  n1008 <= state (189 downto 174);
  n1009 <= n1008 when n980 = '0' else n1007;
  n1010 <= n1009 & n1006;
  n1012 <= n1004 and n973;
  n1013 <= state (189 downto 158);
  n1014 <= n1013 when n1021 = '0' else n1010;
  n1017 <= '0' when n973 = '0' else '1';
  n1019 <= n1012 and pr_color_valid;
  n1021 <= n973 and pr_color_valid;
  n1023 <= '0' when pr_color_valid = '0' else n958;
  n1025 <= "00000000" when pr_color_valid = '0' else n948;
  n1026 <= n908 & n906;
  n1028 <= "00000000000000000000000000000000" when pr_color_valid = '0' else n1026;
  n1030 <= '0' when pr_color_valid = '0' else n949;
  n1032 <= '0' when pr_color_valid = '0' else n1017;
  n1034 <= '1' when n125 = "100000" else '0';
  n1044 <= current_instr (9 downto 8);
  n1046 <= current_instr (4);
  n1048 <= '1' when n1044 = "01" else '0';
  n1050 <= '1' when n1044 = "11" else '0';
  n1051 <= n1048 or n1050;
  n1053 <= state (205 downto 190);
  n1054 <= bb_section (59 downto 45);
  n1056 <= '0' & n1054;
  n1057 <= std_logic_vector (unsigned (n1053) + unsigned (n1056));
  n1059 <= state (205 downto 190);
  n1060 <= bb_section (44 downto 30);
  n1062 <= '0' & n1060;
  n1063 <= std_logic_vector (unsigned (n1059) + unsigned (n1062));
  n1064 <= n1063 when n1051 = '0' else n1057;
  n1065 <= state (205 downto 190);
  n1066 <= n1065 when n1046 = '0' else n1064;
  n1067 <= current_instr (5);
  n1069 <= '1' when n1044 = "01" else '0';
  n1071 <= '1' when n1044 = "11" else '0';
  n1072 <= n1069 or n1071;
  n1074 <= state (221 downto 206);
  n1075 <= bb_section (44 downto 30);
  n1077 <= '0' & n1075;
  n1078 <= std_logic_vector (unsigned (n1074) + unsigned (n1077));
  n1080 <= state (221 downto 206);
  n1081 <= bb_section (59 downto 45);
  n1083 <= '0' & n1081;
  n1084 <= std_logic_vector (unsigned (n1080) + unsigned (n1083));
  n1085 <= n1084 when n1072 = '0' else n1078;
  n1086 <= state (221 downto 206);
  n1087 <= n1086 when n1067 = '0' else n1085;
  n1090 <= '1' when n125 = "100001" else '0';
  n1091 <= not wrap_vram_wr_full;
  n1092 <= addrhi & addrlo;
  n1093 <= current_instr (0);
  n1096 <= '0' when n1093 = '0' else '1';
  n1099 <= state (5 downto 0);
  n1100 <= n1099 when n1091 = '0' else "000000";
  n1103 <= '0' when n1091 = '0' else '1';
  n1105 <= "000000000000000000000" when n1091 = '0' else n1092;
  n1107 <= "0000000000000000" when n1091 = '0' else data;
  n1109 <= '1' when n1091 = '0' else n1096;
  n1111 <= '1' when n125 = "001011" else '0';
  n1112 <= addrhi & addrlo;
  n1115 <= '1' when n125 = "010000" else '0';
  n1116 <= addrhi & addrlo;
  n1119 <= '1' when n125 = "001111" else '0';
  n1120 <= not wrap_fifo_gfx_cmd_empty;
  n1126 <= current_instr (15 downto 11);
  n1128 <= '1' when n1126 = "01110" else '0';
  n1131 <= '0' when n1128 = '0' else '1';
  n1132 <= state (157 downto 142);
  n1134 <= std_logic_vector (unsigned (n1132) - unsigned'("0000000000000001"));
  n1137 <= '0' when n1120 = '0' else n1131;
  n1138 <= state (5 downto 0);
  n1139 <= n1138 when n1120 = '0' else "010010";
  n1140 <= state (157 downto 142);
  n1141 <= n1140 when n1120 = '0' else n1134;
  n1143 <= '1' when n125 = "010001" else '0';
  n1144 <= state (65 downto 45);
  n1150 <= current_instr (15 downto 11);
  n1152 <= '1' when n1150 = "01110" else '0';
  n1153 <= data when n1152 = '0' else wrap_fifo_gfx_cmd;
  n1154 <= not wrap_vram_wr_full;
  n1155 <= current_instr (0);
  n1156 <= state (65 downto 45);
  n1158 <= std_logic_vector (unsigned (n1156) + unsigned'("000000000000000000010"));
  n1159 <= state (65 downto 45);
  n1161 <= std_logic_vector (unsigned (n1159) + unsigned'("000000000000000000001"));
  n1162 <= n1161 when n1155 = '0' else n1158;
  n1165 <= '0' when n1155 = '0' else '1';
  n1166 <= state (157 downto 142);
  n1168 <= '1' when n1166 = "0000000000000000" else '0';
  n1171 <= "010001" when n1168 = '0' else "000000";
  n1172 <= state (5 downto 0);
  n1173 <= n1172 when n1154 = '0' else n1171;
  n1174 <= state (65 downto 45);
  n1175 <= n1174 when n1154 = '0' else n1162;
  n1178 <= '0' when n1154 = '0' else '1';
  n1180 <= '1' when n1154 = '0' else n1165;
  n1182 <= '1' when n125 = "010010" else '0';
  n1184 <= addrhi & addrlo;
  n1185 <= current_instr (0);
  n1188 <= '0' when n1185 = '0' else '1';
  n1191 <= '0' when wrap_vram_wr_emtpy = '0' else '1';
  n1193 <= '1' when n125 = "001100" else '0';
  n1195 <= state (5 downto 0);
  n1196 <= n1195 when wrap_vram_rd_valid = '0' else "001110";
  n1197 <= state (81 downto 66);
  n1198 <= n1197 when wrap_vram_rd_valid = '0' else wrap_vram_rd_data;
  n1200 <= '1' when n125 = "001101" else '0';
  n1203 <= '1' when n125 = "001110" else '0';
  n1205 <= state (221 downto 190);
  n1207 <= '1' when n125 = "011010" else '0';
  n1209 <= state (221 downto 190);
  n1211 <= '1' when n125 = "011011" else '0';
  n1212 <= state (221 downto 190);
  n1213 <= not pw_oob;
  n1217 <= '0' when wrap_vram_wr_emtpy = '0' else '1';
  n1218 <= state (5 downto 0);
  n1219 <= n1218 when wrap_vram_wr_emtpy = '0' else "011101";
  n1223 <= '0' when n1213 = '0' else n1217;
  n1224 <= "011110" when n1213 = '0' else n1219;
  n1225 <= state (81 downto 66);
  n1226 <= "1111111111111111" when n1213 = '0' else n1225;
  n1228 <= '1' when n125 = "011100" else '0';
  n1229 <= state (221 downto 190);
  n1231 <= state (5 downto 0);
  n1232 <= n1231 when wrap_vram_rd_valid = '0' else "011110";
  n1233 <= state (81 downto 66);
  n1234 <= n1233 when wrap_vram_rd_valid = '0' else wrap_vram_rd_data;
  n1236 <= '1' when n125 = "011101" else '0';
  n1238 <= current_instr (4);
  n1240 <= state (205 downto 190);
  n1242 <= std_logic_vector (unsigned (n1240) + unsigned'("0000000000000001"));
  n1243 <= state (205 downto 190);
  n1244 <= n1243 when n1238 = '0' else n1242;
  n1245 <= current_instr (5);
  n1247 <= state (221 downto 206);
  n1249 <= std_logic_vector (unsigned (n1247) + unsigned'("0000000000000001"));
  n1250 <= state (221 downto 206);
  n1251 <= n1250 when n1245 = '0' else n1249;
  n1253 <= '1' when n125 = "011110" else '0';
  n1254 <= n1253 & n1236 & n1228 & n1211 & n1207 & n1203 & n1200 & n1193 & n1182 & n1143 & n1119 & n1115 & n1111 & n1090 & n1034 & n839 & n831 & n775 & n766 & n692 & n687 & n612 & n607 & n536 & n532 & n512 & n464 & n461 & n454 & n443 & n434 & n372 & n351 & n134;
  with n1254 select n1255 <=
    pw_vram_wr_addr when "1000000000000000000000000000000000",
    pw_vram_wr_addr when "0100000000000000000000000000000000",
    pw_vram_wr_addr when "0010000000000000000000000000000000",
    pw_vram_wr_addr when "0001000000000000000000000000000000",
    pw_vram_wr_addr when "0000100000000000000000000000000000",
    pw_vram_wr_addr when "0000010000000000000000000000000000",
    pw_vram_wr_addr when "0000001000000000000000000000000000",
    n1184 when "0000000100000000000000000000000000",
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
  with n1254 select n1257 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    n1223 when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    n1191 when "0000000100000000000000000000000000",
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
  with n1254 select n1260 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    n1188 when "0000000100000000000000000000000000",
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
  with n1254 select n1263 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    '0' when "0000000010000000000000000000000000",
    n1137 when "0000000001000000000000000000000000",
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
  with n1254 select n1268 <=
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
  with n1254 select n1271 <=
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
  n1273 <= state (5 downto 0);
  with n1254 select n1274 <=
    "000000" when "1000000000000000000000000000000000",
    n1232 when "0100000000000000000000000000000000",
    n1224 when "0010000000000000000000000000000000",
    "011100" when "0001000000000000000000000000000000",
    "011011" when "0000100000000000000000000000000000",
    "000000" when "0000010000000000000000000000000000",
    n1196 when "0000001000000000000000000000000000",
    "001101" when "0000000100000000000000000000000000",
    n1173 when "0000000010000000000000000000000000",
    n1139 when "0000000001000000000000000000000000",
    "010001" when "0000000000100000000000000000000000",
    "010001" when "0000000000010000000000000000000000",
    n1100 when "0000000000001000000000000000000000",
    "000000" when "0000000000000100000000000000000000",
    n995 when "0000000000000010000000000000000000",
    "100000" when "0000000000000001000000000000000000",
    n827 when "0000000000000000100000000000000000",
    n770 when "0000000000000000010000000000000000",
    n755 when "0000000000000000001000000000000000",
    "011001" when "0000000000000000000100000000000000",
    n675 when "0000000000000000000010000000000000",
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
    n1273 when others;
  n1275 <= state (21 downto 6);
  with n1254 select n1276 <=
    n1275 when "1000000000000000000000000000000000",
    n1275 when "0100000000000000000000000000000000",
    n1275 when "0010000000000000000000000000000000",
    n1275 when "0001000000000000000000000000000000",
    n1275 when "0000100000000000000000000000000000",
    n1275 when "0000010000000000000000000000000000",
    n1275 when "0000001000000000000000000000000000",
    n1275 when "0000000100000000000000000000000000",
    n1275 when "0000000010000000000000000000000000",
    n1275 when "0000000001000000000000000000000000",
    n1275 when "0000000000100000000000000000000000",
    n1275 when "0000000000010000000000000000000000",
    n1275 when "0000000000001000000000000000000000",
    n1275 when "0000000000000100000000000000000000",
    n1275 when "0000000000000010000000000000000000",
    n1275 when "0000000000000001000000000000000000",
    n1275 when "0000000000000000100000000000000000",
    n1275 when "0000000000000000010000000000000000",
    n1275 when "0000000000000000001000000000000000",
    n1275 when "0000000000000000000100000000000000",
    n1275 when "0000000000000000000010000000000000",
    n1275 when "0000000000000000000001000000000000",
    n1275 when "0000000000000000000000100000000000",
    n1275 when "0000000000000000000000010000000000",
    n1275 when "0000000000000000000000001000000000",
    n1275 when "0000000000000000000000000100000000",
    n1275 when "0000000000000000000000000010000000",
    n1275 when "0000000000000000000000000001000000",
    n1275 when "0000000000000000000000000000100000",
    n1275 when "0000000000000000000000000000010000",
    n1275 when "0000000000000000000000000000001000",
    n1275 when "0000000000000000000000000000000100",
    wrap_fifo_gfx_cmd when "0000000000000000000000000000000010",
    n1275 when "0000000000000000000000000000000001",
    n1275 when others;
  n1277 <= state (23 downto 22);
  with n1254 select n1278 <=
    n1277 when "1000000000000000000000000000000000",
    n1277 when "0100000000000000000000000000000000",
    n1277 when "0010000000000000000000000000000000",
    n1277 when "0001000000000000000000000000000000",
    n1277 when "0000100000000000000000000000000000",
    n1277 when "0000010000000000000000000000000000",
    n1277 when "0000001000000000000000000000000000",
    n1277 when "0000000100000000000000000000000000",
    n1277 when "0000000010000000000000000000000000",
    n1277 when "0000000001000000000000000000000000",
    n1277 when "0000000000100000000000000000000000",
    n1277 when "0000000000010000000000000000000000",
    n1277 when "0000000000001000000000000000000000",
    n1277 when "0000000000000100000000000000000000",
    n1277 when "0000000000000010000000000000000000",
    n1277 when "0000000000000001000000000000000000",
    n1277 when "0000000000000000100000000000000000",
    n1277 when "0000000000000000010000000000000000",
    n1277 when "0000000000000000001000000000000000",
    n1277 when "0000000000000000000100000000000000",
    n1277 when "0000000000000000000010000000000000",
    n1277 when "0000000000000000000001000000000000",
    n1277 when "0000000000000000000000100000000000",
    n1277 when "0000000000000000000000010000000000",
    n1277 when "0000000000000000000000001000000000",
    n1277 when "0000000000000000000000000100000000",
    n1277 when "0000000000000000000000000010000000",
    n1277 when "0000000000000000000000000001000000",
    n1277 when "0000000000000000000000000000100000",
    n1277 when "0000000000000000000000000000010000",
    n1277 when "0000000000000000000000000000001000",
    n370 when "0000000000000000000000000000000100",
    n314 when "0000000000000000000000000000000010",
    n1277 when "0000000000000000000000000000000001",
    n1277 when others;
  n1279 <= state (44 downto 24);
  with n1254 select n1280 <=
    n1279 when "1000000000000000000000000000000000",
    n1279 when "0100000000000000000000000000000000",
    n1279 when "0010000000000000000000000000000000",
    n1279 when "0001000000000000000000000000000000",
    n1279 when "0000100000000000000000000000000000",
    n1279 when "0000010000000000000000000000000000",
    n1279 when "0000001000000000000000000000000000",
    n1279 when "0000000100000000000000000000000000",
    n1279 when "0000000010000000000000000000000000",
    n1279 when "0000000001000000000000000000000000",
    n1279 when "0000000000100000000000000000000000",
    n1279 when "0000000000010000000000000000000000",
    n1279 when "0000000000001000000000000000000000",
    n1279 when "0000000000000100000000000000000000",
    n1279 when "0000000000000010000000000000000000",
    n1279 when "0000000000000001000000000000000000",
    n1279 when "0000000000000000100000000000000000",
    n1279 when "0000000000000000010000000000000000",
    n1279 when "0000000000000000001000000000000000",
    n1279 when "0000000000000000000100000000000000",
    n1279 when "0000000000000000000010000000000000",
    n1279 when "0000000000000000000001000000000000",
    n1279 when "0000000000000000000000100000000000",
    n1279 when "0000000000000000000000010000000000",
    n530 when "0000000000000000000000001000000000",
    n1279 when "0000000000000000000000000100000000",
    n1279 when "0000000000000000000000000010000000",
    n1279 when "0000000000000000000000000001000000",
    n1279 when "0000000000000000000000000000100000",
    n1279 when "0000000000000000000000000000010000",
    n1279 when "0000000000000000000000000000001000",
    n1279 when "0000000000000000000000000000000100",
    n1279 when "0000000000000000000000000000000010",
    n1279 when "0000000000000000000000000000000001",
    n1279 when others;
  n1281 <= state (65 downto 45);
  with n1254 select n1282 <=
    n1281 when "1000000000000000000000000000000000",
    n1281 when "0100000000000000000000000000000000",
    n1281 when "0010000000000000000000000000000000",
    n1281 when "0001000000000000000000000000000000",
    n1281 when "0000100000000000000000000000000000",
    n1281 when "0000010000000000000000000000000000",
    n1281 when "0000001000000000000000000000000000",
    n1281 when "0000000100000000000000000000000000",
    n1175 when "0000000010000000000000000000000000",
    n1281 when "0000000001000000000000000000000000",
    n1116 when "0000000000100000000000000000000000",
    n1112 when "0000000000010000000000000000000000",
    n1281 when "0000000000001000000000000000000000",
    n1281 when "0000000000000100000000000000000000",
    n1281 when "0000000000000010000000000000000000",
    n1281 when "0000000000000001000000000000000000",
    n1281 when "0000000000000000100000000000000000",
    n1281 when "0000000000000000010000000000000000",
    n1281 when "0000000000000000001000000000000000",
    n1281 when "0000000000000000000100000000000000",
    n1281 when "0000000000000000000010000000000000",
    n1281 when "0000000000000000000001000000000000",
    n1281 when "0000000000000000000000100000000000",
    n1281 when "0000000000000000000000010000000000",
    n1281 when "0000000000000000000000001000000000",
    n1281 when "0000000000000000000000000100000000",
    n1281 when "0000000000000000000000000010000000",
    n1281 when "0000000000000000000000000001000000",
    n1281 when "0000000000000000000000000000100000",
    n1281 when "0000000000000000000000000000010000",
    n1281 when "0000000000000000000000000000001000",
    n1281 when "0000000000000000000000000000000100",
    n1281 when "0000000000000000000000000000000010",
    n1281 when "0000000000000000000000000000000001",
    n1281 when others;
  n1283 <= state (81 downto 66);
  with n1254 select n1284 <=
    n1283 when "1000000000000000000000000000000000",
    n1234 when "0100000000000000000000000000000000",
    n1226 when "0010000000000000000000000000000000",
    n1283 when "0001000000000000000000000000000000",
    n1283 when "0000100000000000000000000000000000",
    n1283 when "0000010000000000000000000000000000",
    n1198 when "0000001000000000000000000000000000",
    n1283 when "0000000100000000000000000000000000",
    n1283 when "0000000010000000000000000000000000",
    n1283 when "0000000001000000000000000000000000",
    n1283 when "0000000000100000000000000000000000",
    n1283 when "0000000000010000000000000000000000",
    n1283 when "0000000000001000000000000000000000",
    n1283 when "0000000000000100000000000000000000",
    n1283 when "0000000000000010000000000000000000",
    n1283 when "0000000000000001000000000000000000",
    n1283 when "0000000000000000100000000000000000",
    n1283 when "0000000000000000010000000000000000",
    n1283 when "0000000000000000001000000000000000",
    n1283 when "0000000000000000000100000000000000",
    n1283 when "0000000000000000000010000000000000",
    n1283 when "0000000000000000000001000000000000",
    n1283 when "0000000000000000000000100000000000",
    n1283 when "0000000000000000000000010000000000",
    n1283 when "0000000000000000000000001000000000",
    n1283 when "0000000000000000000000000100000000",
    n1283 when "0000000000000000000000000010000000",
    n1283 when "0000000000000000000000000001000000",
    n1283 when "0000000000000000000000000000100000",
    n1283 when "0000000000000000000000000000010000",
    n1283 when "0000000000000000000000000000001000",
    n1283 when "0000000000000000000000000000000100",
    n1283 when "0000000000000000000000000000000010",
    n1283 when "0000000000000000000000000000000001",
    n1283 when others;
  n1285 <= state (96 downto 82);
  with n1254 select n1286 <=
    n1285 when "1000000000000000000000000000000000",
    n1285 when "0100000000000000000000000000000000",
    n1285 when "0010000000000000000000000000000000",
    n1285 when "0001000000000000000000000000000000",
    n1285 when "0000100000000000000000000000000000",
    n1285 when "0000010000000000000000000000000000",
    n1285 when "0000001000000000000000000000000000",
    n1285 when "0000000100000000000000000000000000",
    n1285 when "0000000010000000000000000000000000",
    n1285 when "0000000001000000000000000000000000",
    n1285 when "0000000000100000000000000000000000",
    n1285 when "0000000000010000000000000000000000",
    n1285 when "0000000000001000000000000000000000",
    n1285 when "0000000000000100000000000000000000",
    n1285 when "0000000000000010000000000000000000",
    n1285 when "0000000000000001000000000000000000",
    n1285 when "0000000000000000100000000000000000",
    n1285 when "0000000000000000010000000000000000",
    n1285 when "0000000000000000001000000000000000",
    n1285 when "0000000000000000000100000000000000",
    n1285 when "0000000000000000000010000000000000",
    n1285 when "0000000000000000000001000000000000",
    n1285 when "0000000000000000000000100000000000",
    n1285 when "0000000000000000000000010000000000",
    n1285 when "0000000000000000000000001000000000",
    n1285 when "0000000000000000000000000100000000",
    n1285 when "0000000000000000000000000010000000",
    "000000000000000" when "0000000000000000000000000001000000",
    n446 when "0000000000000000000000000000100000",
    n437 when "0000000000000000000000000000010000",
    n1285 when "0000000000000000000000000000001000",
    n1285 when "0000000000000000000000000000000100",
    n1285 when "0000000000000000000000000000000010",
    n1285 when "0000000000000000000000000000000001",
    n1285 when others;
  n1287 <= state (111 downto 97);
  with n1254 select n1288 <=
    n1287 when "1000000000000000000000000000000000",
    n1287 when "0100000000000000000000000000000000",
    n1287 when "0010000000000000000000000000000000",
    n1287 when "0001000000000000000000000000000000",
    n1287 when "0000100000000000000000000000000000",
    n1287 when "0000010000000000000000000000000000",
    n1287 when "0000001000000000000000000000000000",
    n1287 when "0000000100000000000000000000000000",
    n1287 when "0000000010000000000000000000000000",
    n1287 when "0000000001000000000000000000000000",
    n1287 when "0000000000100000000000000000000000",
    n1287 when "0000000000010000000000000000000000",
    n1287 when "0000000000001000000000000000000000",
    n1287 when "0000000000000100000000000000000000",
    n1287 when "0000000000000010000000000000000000",
    n1287 when "0000000000000001000000000000000000",
    n1287 when "0000000000000000100000000000000000",
    n1287 when "0000000000000000010000000000000000",
    n1287 when "0000000000000000001000000000000000",
    n1287 when "0000000000000000000100000000000000",
    n1287 when "0000000000000000000010000000000000",
    n1287 when "0000000000000000000001000000000000",
    n1287 when "0000000000000000000000100000000000",
    n1287 when "0000000000000000000000010000000000",
    n1287 when "0000000000000000000000001000000000",
    n1287 when "0000000000000000000000000100000000",
    n1287 when "0000000000000000000000000010000000",
    "000000000000000" when "0000000000000000000000000001000000",
    n448 when "0000000000000000000000000000100000",
    "000000000000000" when "0000000000000000000000000000010000",
    n1287 when "0000000000000000000000000000001000",
    n1287 when "0000000000000000000000000000000100",
    n1287 when "0000000000000000000000000000000010",
    n1287 when "0000000000000000000000000000000001",
    n1287 when others;
  n1289 <= state (126 downto 112);
  with n1254 select n1290 <=
    n1289 when "1000000000000000000000000000000000",
    n1289 when "0100000000000000000000000000000000",
    n1289 when "0010000000000000000000000000000000",
    n1289 when "0001000000000000000000000000000000",
    n1289 when "0000100000000000000000000000000000",
    n1289 when "0000010000000000000000000000000000",
    n1289 when "0000001000000000000000000000000000",
    n1289 when "0000000100000000000000000000000000",
    n1289 when "0000000010000000000000000000000000",
    n1289 when "0000000001000000000000000000000000",
    n1289 when "0000000000100000000000000000000000",
    n1289 when "0000000000010000000000000000000000",
    n1289 when "0000000000001000000000000000000000",
    n1289 when "0000000000000100000000000000000000",
    n1289 when "0000000000000010000000000000000000",
    n1289 when "0000000000000001000000000000000000",
    n1289 when "0000000000000000100000000000000000",
    n1289 when "0000000000000000010000000000000000",
    n1289 when "0000000000000000001000000000000000",
    n1289 when "0000000000000000000100000000000000",
    n1289 when "0000000000000000000010000000000000",
    n1289 when "0000000000000000000001000000000000",
    n1289 when "0000000000000000000000100000000000",
    n1289 when "0000000000000000000000010000000000",
    n1289 when "0000000000000000000000001000000000",
    n1289 when "0000000000000000000000000100000000",
    n1289 when "0000000000000000000000000010000000",
    n458 when "0000000000000000000000000001000000",
    n450 when "0000000000000000000000000000100000",
    n440 when "0000000000000000000000000000010000",
    n1289 when "0000000000000000000000000000001000",
    n1289 when "0000000000000000000000000000000100",
    n1289 when "0000000000000000000000000000000010",
    n1289 when "0000000000000000000000000000000001",
    n1289 when others;
  n1291 <= state (141 downto 127);
  with n1254 select n1292 <=
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
    n459 when "0000000000000000000000000001000000",
    n452 when "0000000000000000000000000000100000",
    n441 when "0000000000000000000000000000010000",
    n1291 when "0000000000000000000000000000001000",
    n1291 when "0000000000000000000000000000000100",
    n1291 when "0000000000000000000000000000000010",
    n1291 when "0000000000000000000000000000000001",
    n1291 when others;
  n1293 <= state (157 downto 142);
  with n1254 select n1294 <=
    n1293 when "1000000000000000000000000000000000",
    n1293 when "0100000000000000000000000000000000",
    n1293 when "0010000000000000000000000000000000",
    n1293 when "0001000000000000000000000000000000",
    n1293 when "0000100000000000000000000000000000",
    n1293 when "0000010000000000000000000000000000",
    n1293 when "0000001000000000000000000000000000",
    n1293 when "0000000100000000000000000000000000",
    n1293 when "0000000010000000000000000000000000",
    n1141 when "0000000001000000000000000000000000",
    n when "0000000000100000000000000000000000",
    n when "0000000000010000000000000000000000",
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
    n1293 when "0000000000000000000000000000000100",
    n1293 when "0000000000000000000000000000000010",
    n1293 when "0000000000000000000000000000000001",
    n1293 when others;
  n1295 <= n533 (15 downto 0);
  n1296 <= n605 (15 downto 0);
  n1297 <= n1014 (15 downto 0);
  n1298 <= state (173 downto 158);
  with n1254 select n1299 <=
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
    n1297 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1298 when "0000000000000000100000000000000000",
    n1298 when "0000000000000000010000000000000000",
    n1298 when "0000000000000000001000000000000000",
    n1298 when "0000000000000000000100000000000000",
    n683 when "0000000000000000000010000000000000",
    n609 when "0000000000000000000001000000000000",
    n1296 when "0000000000000000000000100000000000",
    n1295 when "0000000000000000000000010000000000",
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
  n1300 <= n533 (31 downto 16);
  n1301 <= n605 (31 downto 16);
  n1302 <= n764 (15 downto 0);
  n1303 <= n1014 (31 downto 16);
  n1304 <= state (189 downto 174);
  with n1254 select n1305 <=
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
    n1303 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1304 when "0000000000000000100000000000000000",
    n1304 when "0000000000000000010000000000000000",
    n1302 when "0000000000000000001000000000000000",
    n689 when "0000000000000000000100000000000000",
    n1304 when "0000000000000000000010000000000000",
    n1304 when "0000000000000000000001000000000000",
    n1301 when "0000000000000000000000100000000000",
    n1300 when "0000000000000000000000010000000000",
    n1304 when "0000000000000000000000001000000000",
    n1304 when "0000000000000000000000000100000000",
    n1304 when "0000000000000000000000000010000000",
    n1304 when "0000000000000000000000000001000000",
    n1304 when "0000000000000000000000000000100000",
    n1304 when "0000000000000000000000000000010000",
    n1304 when "0000000000000000000000000000001000",
    n1304 when "0000000000000000000000000000000100",
    n1304 when "0000000000000000000000000000000010",
    n1304 when "0000000000000000000000000000000001",
    n1304 when others;
  n1306 <= n429 (15 downto 0);
  n1307 <= n510 (15 downto 0);
  n1308 <= n679 (15 downto 0);
  n1309 <= n764 (31 downto 16);
  n1310 <= n829 (15 downto 0);
  n1311 <= state (205 downto 190);
  with n1254 select n1312 <=
    n1244 when "1000000000000000000000000000000000",
    n1311 when "0100000000000000000000000000000000",
    n1311 when "0010000000000000000000000000000000",
    n1311 when "0001000000000000000000000000000000",
    n1311 when "0000100000000000000000000000000000",
    n1311 when "0000010000000000000000000000000000",
    n1311 when "0000001000000000000000000000000000",
    n1311 when "0000000100000000000000000000000000",
    n1311 when "0000000010000000000000000000000000",
    n1311 when "0000000001000000000000000000000000",
    n1311 when "0000000000100000000000000000000000",
    n1311 when "0000000000010000000000000000000000",
    n1311 when "0000000000001000000000000000000000",
    n1066 when "0000000000000100000000000000000000",
    n1311 when "0000000000000010000000000000000000",
    n1311 when "0000000000000001000000000000000000",
    n1310 when "0000000000000000100000000000000000",
    n1311 when "0000000000000000010000000000000000",
    n1309 when "0000000000000000001000000000000000",
    n1311 when "0000000000000000000100000000000000",
    n1308 when "0000000000000000000010000000000000",
    n1311 when "0000000000000000000001000000000000",
    n1311 when "0000000000000000000000100000000000",
    n1311 when "0000000000000000000000010000000000",
    n1311 when "0000000000000000000000001000000000",
    n1307 when "0000000000000000000000000100000000",
    n1311 when "0000000000000000000000000010000000",
    n1311 when "0000000000000000000000000001000000",
    n1311 when "0000000000000000000000000000100000",
    n1311 when "0000000000000000000000000000010000",
    n1306 when "0000000000000000000000000000001000",
    n1311 when "0000000000000000000000000000000100",
    n316 when "0000000000000000000000000000000010",
    n1311 when "0000000000000000000000000000000001",
    n1311 when others;
  n1313 <= n429 (31 downto 16);
  n1314 <= n510 (31 downto 16);
  n1315 <= n679 (31 downto 16);
  n1316 <= n764 (47 downto 32);
  n1317 <= n829 (31 downto 16);
  n1318 <= state (221 downto 206);
  with n1254 select n1319 <=
    n1251 when "1000000000000000000000000000000000",
    n1318 when "0100000000000000000000000000000000",
    n1318 when "0010000000000000000000000000000000",
    n1318 when "0001000000000000000000000000000000",
    n1318 when "0000100000000000000000000000000000",
    n1318 when "0000010000000000000000000000000000",
    n1318 when "0000001000000000000000000000000000",
    n1318 when "0000000100000000000000000000000000",
    n1318 when "0000000010000000000000000000000000",
    n1318 when "0000000001000000000000000000000000",
    n1318 when "0000000000100000000000000000000000",
    n1318 when "0000000000010000000000000000000000",
    n1318 when "0000000000001000000000000000000000",
    n1087 when "0000000000000100000000000000000000",
    n1318 when "0000000000000010000000000000000000",
    n1318 when "0000000000000001000000000000000000",
    n1317 when "0000000000000000100000000000000000",
    n1318 when "0000000000000000010000000000000000",
    n1316 when "0000000000000000001000000000000000",
    n1318 when "0000000000000000000100000000000000",
    n1315 when "0000000000000000000010000000000000",
    n1318 when "0000000000000000000001000000000000",
    n1318 when "0000000000000000000000100000000000",
    n1318 when "0000000000000000000000010000000000",
    n1318 when "0000000000000000000000001000000000",
    n1314 when "0000000000000000000000000100000000",
    n1318 when "0000000000000000000000000010000000",
    n1318 when "0000000000000000000000000001000000",
    n1318 when "0000000000000000000000000000100000",
    n1318 when "0000000000000000000000000000010000",
    n1313 when "0000000000000000000000000000001000",
    n1318 when "0000000000000000000000000000000100",
    n318 when "0000000000000000000000000000000010",
    n1318 when "0000000000000000000000000000000001",
    n1318 when others;
  n1320 <= state (229 downto 222);
  with n1254 select n1321 <=
    n1320 when "1000000000000000000000000000000000",
    n1320 when "0100000000000000000000000000000000",
    n1320 when "0010000000000000000000000000000000",
    n1320 when "0001000000000000000000000000000000",
    n1320 when "0000100000000000000000000000000000",
    n1320 when "0000010000000000000000000000000000",
    n1320 when "0000001000000000000000000000000000",
    n1320 when "0000000100000000000000000000000000",
    n1320 when "0000000010000000000000000000000000",
    n1320 when "0000000001000000000000000000000000",
    n1320 when "0000000000100000000000000000000000",
    n1320 when "0000000000010000000000000000000000",
    n1320 when "0000000000001000000000000000000000",
    n1320 when "0000000000000100000000000000000000",
    n1320 when "0000000000000010000000000000000000",
    n1320 when "0000000000000001000000000000000000",
    n1320 when "0000000000000000100000000000000000",
    n1320 when "0000000000000000010000000000000000",
    n1320 when "0000000000000000001000000000000000",
    n1320 when "0000000000000000000100000000000000",
    n1320 when "0000000000000000000010000000000000",
    n1320 when "0000000000000000000001000000000000",
    n1320 when "0000000000000000000000100000000000",
    n1320 when "0000000000000000000000010000000000",
    n1320 when "0000000000000000000000001000000000",
    n1320 when "0000000000000000000000000100000000",
    n1320 when "0000000000000000000000000010000000",
    n1320 when "0000000000000000000000000001000000",
    n1320 when "0000000000000000000000000000100000",
    n1320 when "0000000000000000000000000000010000",
    n1320 when "0000000000000000000000000000001000",
    n1320 when "0000000000000000000000000000000100",
    n320 when "0000000000000000000000000000000010",
    n1320 when "0000000000000000000000000000000001",
    n1320 when others;
  n1322 <= state (237 downto 230);
  with n1254 select n1323 <=
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
    n1322 when "0000000000000010000000000000000000",
    n1322 when "0000000000000001000000000000000000",
    n1322 when "0000000000000000100000000000000000",
    n1322 when "0000000000000000010000000000000000",
    n1322 when "0000000000000000001000000000000000",
    n1322 when "0000000000000000000100000000000000",
    n1322 when "0000000000000000000010000000000000",
    n1322 when "0000000000000000000001000000000000",
    n1322 when "0000000000000000000000100000000000",
    n1322 when "0000000000000000000000010000000000",
    n1322 when "0000000000000000000000001000000000",
    n1322 when "0000000000000000000000000100000000",
    n1322 when "0000000000000000000000000010000000",
    n1322 when "0000000000000000000000000001000000",
    n1322 when "0000000000000000000000000000100000",
    n1322 when "0000000000000000000000000000010000",
    n1322 when "0000000000000000000000000000001000",
    n1322 when "0000000000000000000000000000000100",
    n322 when "0000000000000000000000000000000010",
    n1322 when "0000000000000000000000000000000001",
    n1322 when others;
  n1324 <= state (299 downto 238);
  with n1254 select n1325 <=
    n1324 when "1000000000000000000000000000000000",
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
    n1324 when "0000000000000100000000000000000000",
    n1324 when "0000000000000010000000000000000000",
    n1324 when "0000000000000001000000000000000000",
    n1324 when "0000000000000000100000000000000000",
    n1324 when "0000000000000000010000000000000000",
    n1324 when "0000000000000000001000000000000000",
    n1324 when "0000000000000000000100000000000000",
    n1324 when "0000000000000000000010000000000000",
    n1324 when "0000000000000000000001000000000000",
    n1324 when "0000000000000000000000100000000000",
    n1324 when "0000000000000000000000010000000000",
    n1324 when "0000000000000000000000001000000000",
    n1324 when "0000000000000000000000000100000000",
    bdt_bmpidx when "0000000000000000000000000010000000",
    n1324 when "0000000000000000000000000001000000",
    n1324 when "0000000000000000000000000000100000",
    n1324 when "0000000000000000000000000000010000",
    n1324 when "0000000000000000000000000000001000",
    n1324 when "0000000000000000000000000000000100",
    n1324 when "0000000000000000000000000000000010",
    n1324 when "0000000000000000000000000000000001",
    n1324 when others;
  n1326 <= state (307 downto 300);
  with n1254 select n1327 <=
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
    n324 when "0000000000000000000000000000000010",
    n1326 when "0000000000000000000000000000000001",
    n1326 when others;
  n1328 <= state (309 downto 308);
  with n1254 select n1329 <=
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
    n326 when "0000000000000000000000000000000010",
    n1328 when "0000000000000000000000000000000001",
    n1328 when others;
  with n1254 select n1350 <=
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
    n1023 when "0000000000000010000000000000000000",
    '0' when "0000000000000001000000000000000000",
    n802 when "0000000000000000100000000000000000",
    '0' when "0000000000000000010000000000000000",
    n706 when "0000000000000000001000000000000000",
    '0' when "0000000000000000000100000000000000",
    n626 when "0000000000000000000010000000000000",
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
  with n1254 select n1353 <=
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
    n1025 when "0000000000000010000000000000000000",
    "00000000" when "0000000000000001000000000000000000",
    n804 when "0000000000000000100000000000000000",
    "00000000" when "0000000000000000010000000000000000",
    instr_color when "0000000000000000001000000000000000",
    "00000000" when "0000000000000000000100000000000000",
    instr_color when "0000000000000000000010000000000000",
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
  n1355 <= n466 (15 downto 0);
  n1356 <= n538 (15 downto 0);
  n1357 <= n806 (15 downto 0);
  n1358 <= n1028 (15 downto 0);
  n1359 <= n1205 (15 downto 0);
  n1360 <= n1209 (15 downto 0);
  n1361 <= n1212 (15 downto 0);
  n1362 <= n1229 (15 downto 0);
  with n1254 select n1364 <=
    "0000000000000000" when "1000000000000000000000000000000000",
    n1362 when "0100000000000000000000000000000000",
    n1361 when "0010000000000000000000000000000000",
    n1360 when "0001000000000000000000000000000000",
    n1359 when "0000100000000000000000000000000000",
    "0000000000000000" when "0000010000000000000000000000000000",
    "0000000000000000" when "0000001000000000000000000000000000",
    "0000000000000000" when "0000000100000000000000000000000000",
    "0000000000000000" when "0000000010000000000000000000000000",
    "0000000000000000" when "0000000001000000000000000000000000",
    "0000000000000000" when "0000000000100000000000000000000000",
    "0000000000000000" when "0000000000010000000000000000000000",
    "0000000000000000" when "0000000000001000000000000000000000",
    "0000000000000000" when "0000000000000100000000000000000000",
    n1358 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1357 when "0000000000000000100000000000000000",
    "0000000000000000" when "0000000000000000010000000000000000",
    n695 when "0000000000000000001000000000000000",
    "0000000000000000" when "0000000000000000000100000000000000",
    n615 when "0000000000000000000010000000000000",
    "0000000000000000" when "0000000000000000000001000000000000",
    n1356 when "0000000000000000000000100000000000",
    "0000000000000000" when "0000000000000000000000010000000000",
    "0000000000000000" when "0000000000000000000000001000000000",
    n1355 when "0000000000000000000000000100000000",
    "0000000000000000" when "0000000000000000000000000010000000",
    "0000000000000000" when "0000000000000000000000000001000000",
    "0000000000000000" when "0000000000000000000000000000100000",
    "0000000000000000" when "0000000000000000000000000000010000",
    "0000000000000000" when "0000000000000000000000000000001000",
    "0000000000000000" when "0000000000000000000000000000000100",
    "0000000000000000" when "0000000000000000000000000000000010",
    "0000000000000000" when "0000000000000000000000000000000001",
    "0000000000000000" when others;
  n1365 <= n466 (31 downto 16);
  n1366 <= n538 (31 downto 16);
  n1367 <= n806 (31 downto 16);
  n1368 <= n1028 (31 downto 16);
  n1369 <= n1205 (31 downto 16);
  n1370 <= n1209 (31 downto 16);
  n1371 <= n1212 (31 downto 16);
  n1372 <= n1229 (31 downto 16);
  with n1254 select n1374 <=
    "0000000000000000" when "1000000000000000000000000000000000",
    n1372 when "0100000000000000000000000000000000",
    n1371 when "0010000000000000000000000000000000",
    n1370 when "0001000000000000000000000000000000",
    n1369 when "0000100000000000000000000000000000",
    "0000000000000000" when "0000010000000000000000000000000000",
    "0000000000000000" when "0000001000000000000000000000000000",
    "0000000000000000" when "0000000100000000000000000000000000",
    "0000000000000000" when "0000000010000000000000000000000000",
    "0000000000000000" when "0000000001000000000000000000000000",
    "0000000000000000" when "0000000000100000000000000000000000",
    "0000000000000000" when "0000000000010000000000000000000000",
    "0000000000000000" when "0000000000001000000000000000000000",
    "0000000000000000" when "0000000000000100000000000000000000",
    n1368 when "0000000000000010000000000000000000",
    "0000000000000000" when "0000000000000001000000000000000000",
    n1367 when "0000000000000000100000000000000000",
    "0000000000000000" when "0000000000000000010000000000000000",
    n697 when "0000000000000000001000000000000000",
    "0000000000000000" when "0000000000000000000100000000000000",
    n617 when "0000000000000000000010000000000000",
    "0000000000000000" when "0000000000000000000001000000000000",
    n1366 when "0000000000000000000000100000000000",
    "0000000000000000" when "0000000000000000000000010000000000",
    "0000000000000000" when "0000000000000000000000001000000000",
    n1365 when "0000000000000000000000000100000000",
    "0000000000000000" when "0000000000000000000000000010000000",
    "0000000000000000" when "0000000000000000000000000001000000",
    "0000000000000000" when "0000000000000000000000000000100000",
    "0000000000000000" when "0000000000000000000000000000010000",
    "0000000000000000" when "0000000000000000000000000000001000",
    "0000000000000000" when "0000000000000000000000000000000100",
    "0000000000000000" when "0000000000000000000000000000000010",
    "0000000000000000" when "0000000000000000000000000000000001",
    "0000000000000000" when others;
  with n1254 select n1382 <=
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
  with n1254 select n1385 <=
    '0' when "1000000000000000000000000000000000",
    '0' when "0100000000000000000000000000000000",
    '0' when "0010000000000000000000000000000000",
    '0' when "0001000000000000000000000000000000",
    '0' when "0000100000000000000000000000000000",
    '0' when "0000010000000000000000000000000000",
    '0' when "0000001000000000000000000000000000",
    '0' when "0000000100000000000000000000000000",
    n1178 when "0000000010000000000000000000000000",
    '0' when "0000000001000000000000000000000000",
    '0' when "0000000000100000000000000000000000",
    '0' when "0000000000010000000000000000000000",
    n1103 when "0000000000001000000000000000000000",
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
  with n1254 select n1388 <=
    "000000000000000000000" when "1000000000000000000000000000000000",
    "000000000000000000000" when "0100000000000000000000000000000000",
    "000000000000000000000" when "0010000000000000000000000000000000",
    "000000000000000000000" when "0001000000000000000000000000000000",
    "000000000000000000000" when "0000100000000000000000000000000000",
    "000000000000000000000" when "0000010000000000000000000000000000",
    "000000000000000000000" when "0000001000000000000000000000000000",
    "000000000000000000000" when "0000000100000000000000000000000000",
    n1144 when "0000000010000000000000000000000000",
    "000000000000000000000" when "0000000001000000000000000000000000",
    "000000000000000000000" when "0000000000100000000000000000000000",
    "000000000000000000000" when "0000000000010000000000000000000000",
    n1105 when "0000000000001000000000000000000000",
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
  with n1254 select n1391 <=
    "0000000000000000" when "1000000000000000000000000000000000",
    "0000000000000000" when "0100000000000000000000000000000000",
    "0000000000000000" when "0010000000000000000000000000000000",
    "0000000000000000" when "0001000000000000000000000000000000",
    "0000000000000000" when "0000100000000000000000000000000000",
    "0000000000000000" when "0000010000000000000000000000000000",
    "0000000000000000" when "0000001000000000000000000000000000",
    "0000000000000000" when "0000000100000000000000000000000000",
    n1153 when "0000000010000000000000000000000000",
    "0000000000000000" when "0000000001000000000000000000000000",
    "0000000000000000" when "0000000000100000000000000000000000",
    "0000000000000000" when "0000000000010000000000000000000000",
    n1107 when "0000000000001000000000000000000000",
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
  with n1254 select n1394 <=
    '1' when "1000000000000000000000000000000000",
    '1' when "0100000000000000000000000000000000",
    '1' when "0010000000000000000000000000000000",
    '1' when "0001000000000000000000000000000000",
    '1' when "0000100000000000000000000000000000",
    '1' when "0000010000000000000000000000000000",
    '1' when "0000001000000000000000000000000000",
    '1' when "0000000100000000000000000000000000",
    n1180 when "0000000010000000000000000000000000",
    '1' when "0000000001000000000000000000000000",
    '1' when "0000000000100000000000000000000000",
    '1' when "0000000000010000000000000000000000",
    n1109 when "0000000000001000000000000000000000",
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
  with n1254 select n1397 <=
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
  with n1254 select n1400 <=
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
  with n1254 select n1404 <=
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
  with n1254 select n1407 <=
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
    n1032 when "0000000000000010000000000000000000",
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
  with n1254 select n1410 <=
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
    n773 when "0000000000000000010000000000000000",
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
  n1415 <= "000000000000000000000" when pw_vram_wr = '0' else pw_vram_wr_addr;
  n1417 <= "0000000000000000" when pw_vram_wr = '0' else pw_vram_wr_data;
  n1420 <= '0' when pw_vram_wr = '0' else '1';
  n1422 <= '1' when pw_vram_wr = '0' else pw_vram_wr_access_mode;
  n1423 <= n1415 when direct_vram_wr = '0' else direct_vram_wr_addr;
  n1425 <= n1417 when direct_vram_wr = '0' else direct_vram_wr_data;
  n1428 <= n1420 when direct_vram_wr = '0' else '1';
  n1430 <= n1422 when direct_vram_wr = '0' else direct_vram_wr_access_mode;
  gfx_circle_inst : entity work.gfx_circle_renamed port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    start => circle_start,
    stall => stall,
    center_x => n1435,
    center_y => n1436,
    radius => radius,
    busy => gfx_circle_inst_c_busy,
    pixel_valid => gfx_circle_inst_c_pixel_valid,
    pixel_x => gfx_circle_inst_c_pixel_x,
    pixel_y => gfx_circle_inst_c_pixel_y);
  n1434 <= state (221 downto 190);
  n1435 <= n1434 (15 downto 0);
  n1436 <= n1434 (31 downto 16);
  n1438 <= gfx_circle_inst_c_pixel_y & gfx_circle_inst_c_pixel_x;
  pw : entity work.pixel_writer_21_16 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    wr => pw_wr,
    bd_b => n1443,
    bd_w => n1444,
    bd_h => n1445,
    color => pw_color,
    position_x => n1446,
    position_y => n1447,
    alpha_mode => pw_alpha_mode,
    alpha_color => n1486,
    vram_wr_full => wrap_vram_wr_full,
    wr_in_progress => open,
    stall => pw_c_stall,
    oob => pw_c_oob,
    vram_wr_addr => pw_c_vram_wr_addr,
    vram_wr_data => pw_c_vram_wr_data,
    vram_wr => pw_c_vram_wr,
    vram_wr_access_mode => pw_c_vram_wr_access_mode);
  n1442 <= state (299 downto 238);
  n1443 <= n1442 (31 downto 0);
  n1444 <= n1442 (46 downto 32);
  n1445 <= n1442 (61 downto 47);
  n1446 <= pw_position (15 downto 0);
  n1447 <= pw_position (31 downto 16);
  n1449 <= state (237 downto 230);
  n1455 <= state (309 downto 308);
  n1456 <= state (307 downto 300);
  n1457 <= n1449 and n1456;
  n1459 <= '1' when n1455 = "01" else '0';
  n1460 <= state (307 downto 300);
  n1461 <= n1449 or n1460;
  n1463 <= '1' when n1455 = "10" else '0';
  n1464 <= state (307 downto 300);
  n1465 <= n1449 xor n1464;
  n1467 <= '1' when n1455 = "11" else '0';
  n1468 <= n1467 & n1463 & n1459;
  with n1468 select n1473 <=
    '0' when "100",
    '0' when "010",
    '0' when "001",
    '1' when others;
  with n1468 select n1481 <=
    n1465 when "100",
    n1461 when "010",
    n1457 when "001",
    "XXXXXXXX" when others;
  n1486 <= n1481 when n1473 = '0' else n1449;
  pr : entity work.pixel_reader_21_16 port map (
    clk => wrap_clk,
    res_n => wrap_res_n,
    start => pr_start,
    bd_b => n1492,
    bd_w => n1493,
    bd_h => n1494,
    section_x => n1495,
    section_y => n1496,
    section_w => n1497,
    section_h => n1498,
    color_ack => pr_color_ack,
    vram_rd_data => wrap_vram_rd_data,
    vram_rd_busy => wrap_vram_rd_busy,
    vram_rd_valid => wrap_vram_rd_valid,
    color => pr_c_color,
    color_valid => pr_c_color_valid,
    vram_rd_addr => pr_c_vram_rd_addr,
    vram_rd => pr_c_vram_rd,
    vram_rd_access_mode => pr_c_vram_rd_access_mode);
  n1492 <= bdt_bmpidx (31 downto 0);
  n1493 <= bdt_bmpidx (46 downto 32);
  n1494 <= bdt_bmpidx (61 downto 47);
  n1495 <= bb_section (14 downto 0);
  n1496 <= bb_section (29 downto 15);
  n1497 <= bb_section (44 downto 30);
  n1498 <= bb_section (59 downto 45);
  n1504 <= wrap_fifo_gfx_cmd & n57 & n58 & n59;
  process (wrap_clk, n118)
  begin
    if n118 = '1' then
      n1505 <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    elsif rising_edge (wrap_clk) then
      n1505 <= state_nxt;
    end if;
  end process;
  n1506 <= n1329 & n1327 & n1325 & n1323 & n1321 & n1319 & n1312 & n1305 & n1299 & n1294 & n1292 & n1290 & n1288 & n1286 & n1284 & n1282 & n1280 & n1278 & n1276 & n1274;
  n1507 <= n1374 & n1364;
  n1509 <= n105 & n104 & n103;
  assert vram_addr_width = 21 report "Unsupported generic value! vram_addr_width must be 21." severity failure;
  assert vram_data_width = 16 report "Unsupported generic value! vram_data_width must be 16." severity failure;
end architecture;
