library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity virtual_jtag_wrapper is
	generic (
		DATA_WIDTH : natural;
		ADR_WIDTH : natural
	);
	port (
		clk   : out std_ulogic;
		res_n : in std_ulogic;

		addr : out std_ulogic_vector(ADR_WIDTH-1 downto 0);
		rd  : out std_ulogic;
		wr  : out std_ulogic;
		rddata : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
		wrdata : out std_ulogic_vector(DATA_WIDTH-1 downto 0)
	);
end entity;

architecture arch of virtual_jtag_wrapper is

	component sld_virtual_jtag is
		generic (
			sld_auto_instance_index : string  := "YES";
			sld_instance_index      : integer := 0;
			sld_ir_width            : integer := 1
		);
		port (
			tdi                : out std_logic;
			tdo                : in  std_logic := 'X';
			ir_in              : out std_logic_vector(1 downto 0);
			ir_out             : in  std_logic_vector(1 downto 0) := (others => 'X');
			virtual_state_cdr  : out std_logic;
			virtual_state_sdr  : out std_logic;
			virtual_state_e1dr : out std_logic;
			virtual_state_pdr  : out std_logic;
			virtual_state_e2dr : out std_logic;
			virtual_state_udr  : out std_logic;
			virtual_state_cir  : out std_logic;
			virtual_state_uir  : out std_logic;
			tck                : out std_logic
		);
	end component;

	signal tck : std_logic;
	signal tdi, tdo : std_logic;
	signal v_sdr, v_udr, v_cdr : std_logic;
	signal ir_in, ir_out : std_logic_vector(1 downto 0);

	subtype instr_t is std_logic_vector(1 downto 0);

	constant BYPASS  : instr_t := b"00";
	constant SET_ADR : instr_t := b"01";
	constant SET_DATA : instr_t := b"10";
	constant GET_DATA : instr_t := b"11";

	-- DRs
	signal dr_bp : std_logic_vector(1 downto 0);
	signal dr_addr : std_logic_vector(ADR_WIDTH-1 downto 0);
	signal dr_data : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
	jtag_inst : component sld_virtual_jtag
	generic map (
		sld_auto_instance_index => "NO",
		sld_instance_index      => 42,
		sld_ir_width            => 2
	)
	port map (
		tck                => tck,
		tdi                => tdi,
		tdo                => tdo,
		ir_in              => ir_in,
		ir_out             => ir_out,
		virtual_state_cdr  => v_cdr,
		virtual_state_sdr  => v_sdr,
		virtual_state_e1dr => open,
		virtual_state_pdr  => open,
		virtual_state_e2dr => open,
		virtual_state_udr  => v_udr,
		virtual_state_cir  => open,
		virtual_state_uir  => open
	);

	clk <= tck;
	ir_out <= ir_in;
	with ir_in select tdo <=
		dr_bp(0)  when BYPASS,
		dr_addr(0) when SET_ADR,
		dr_data(0) when others;

	wr <= v_udr when ir_in = SET_DATA else '0';
	rd <= v_cdr when ir_in = SET_DATA or ir_in = GET_DATA else '0';
	addr <= dr_addr;
	wrdata <= dr_data;

	sync : process(tck, res_n)
	begin
		if res_n = '0' then
			dr_bp  <= (others => '0');
			dr_addr <= (others => '0');
			dr_data <= (others => '0');
		elsif rising_edge(tck) then
			case ir_in is
				when SET_ADR =>
					if v_sdr = '1' then
						dr_addr <= tdi & dr_addr(ADR_WIDTH-1 downto 1);
					end if;
				when SET_DATA | GET_DATA =>
					if v_cdr = '1' then
						dr_data <= rddata;
					elsif v_sdr = '1' then
						dr_data <= tdi & dr_data(DATA_WIDTH-1 downto 1);
					elsif v_udr = '1' then
						dr_addr <= std_logic_vector(unsigned(dr_addr) + 1);
					end if;
				when others =>
					if v_sdr = '1' then
						dr_bp  <= tdi & dr_bp(1 downto 1);
					end if;
			end case;
		end if;
	end process;
end architecture;
