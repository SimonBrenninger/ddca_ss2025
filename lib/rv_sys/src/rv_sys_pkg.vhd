library ieee;
use ieee.std_logic_1164.all;

package rv_sys_pkg is

	-- NOTE: these are word addresses
	constant RV_SYS_ADDR_WIDTH : positive := 14;
	constant RV_SYS_DATA_WIDTH : positive := 32;

	-- Utility types and constants for interfacing with the instruction and data memories
	subtype mem_address_t    is std_ulogic_vector(RV_SYS_ADDR_WIDTH-1 downto 0);
	subtype mem_data_t       is std_ulogic_vector(RV_SYS_DATA_WIDTH-1 downto 0);
	subtype mem_byteena_t    is std_ulogic_vector(RV_SYS_DATA_WIDTH/8-1 downto 0);

	-- NOTE: memory direction (in, out) is seen from RiscV.
	type mem_out_t is record
		address  : mem_address_t;
		rd       : std_ulogic;
		wr       : std_ulogic;
		byteena  : mem_byteena_t;
		wrdata   : mem_data_t;
	end record;

	constant MEM_OUT_NOP : mem_out_t := (
		address => (others => '0'),
		rd      => '0',
		wr      => '0',
		byteena => (others => '1'),
		wrdata  => (others => '0')
	);

	type mem_in_t is record
		busy   : std_ulogic;
		rddata : mem_data_t;
	end record;

	constant MEM_IN_NOP : mem_in_t := (
		busy   => '0',
		rddata => (others => '0')
	);

	type mem_data_array_t is array(natural range<>) of mem_data_t;

	function swap_endianness(i : mem_data_t) return mem_data_t;

	type memu_access_type_t is (
		MEM_B,
		MEM_BU,
		MEM_H,
		MEM_HU,
		MEM_W
	);

	type memu_op_t is record
		rd          : std_ulogic;
		wr          : std_ulogic;
		access_type : memu_access_type_t;
	end record;

	constant MEMU_NOP : memu_op_t := (
		rd          => '0',
		wr          => '0',
		access_type => MEM_W
	);

	component rv_sys is
		generic (
			BAUD_RATE         : natural := 115200;
			CLK_FREQ          : natural := 75000000;
			SIMULATE_ELF_FILE : string  := "OFF";
			GPIO_ADDR_WIDTH   : natural := 8;
			DMEM_DELAY        : natural := 0;
			IMEM_DELAY        : natural := 0
		);
		port (
			clk   : in std_ulogic;
			res_n : in std_ulogic;

			cpu_reset_n : out std_ulogic;

			-- instruction memory interface
			imem_out : in  mem_out_t;
			imem_in  : out mem_in_t;

			-- data memory interface
			dmem_out : in  mem_out_t;
			dmem_in  : out mem_in_t;

			-- UART port
			rx : in  std_ulogic;
			tx : out std_ulogic;

			-- GPIO
			gp_out : out mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0);
			gp_in  : in  mem_data_array_t(2**GPIO_ADDR_WIDTH-1 downto 0)
		);
	end component;

	component memu is
		port (
			op     : in  memu_op_t;
			addr   : in  mem_data_t;
			wrdata : in  mem_data_t;
			rddata : out mem_data_t := (others => '0');
			busy   : out std_ulogic := '0';

			xl : out std_ulogic := '0';
			xs : out std_ulogic := '0';

			-- to rv_sys
			mem_in  : in  mem_in_t;
			mem_out : out mem_out_t
		);
	end component;

end package;

package body rv_sys_pkg is
	function swap_endianness(i : mem_data_t) return mem_data_t is
	begin
		return i(7 downto 0) & i(15 downto 8) & i(23 downto 16) & i(31 downto 24);
	end function;
end package body;
