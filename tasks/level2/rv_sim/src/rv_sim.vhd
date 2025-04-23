library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_sys_pkg.all;
use work.rv_core_pkg.all;
use work.rv_alu_pkg.all;

architecture arch of rv is

	constant CLK_PERIOD : time := 1000 ms/CLK_FREQ;

	type registers_t is array (REG_COUNT-1 downto 0) of data_t;
	-- TODO: Add further types, constants, functions and signals as needed

	function get_byteena(funct3: funct3_t; mem_addr: data_t) return std_logic_vector is
		type byteena_mask_t is array(0 to 3) of std_logic_vector(3 downto 0);
		constant BYTE_EN_MASK : byteena_mask_t:= ("1000", "0100", "0010", "0001");
		constant HW_EN_MASK : byteena_mask_t:= ("1100", "1100", "0011", "0011");
	begin

		return "1111";
	end function;

	function byte_to_word_addr(data : data_t) return mem_address_t is
		begin
			return data(RV_SYS_ADDR_WIDTH+1 downto 2);
		end function;

begin

	main: process is
		variable registers : registers_t;
		variable pc        : data_t;
		variable instr     : instr_t;
		variable opcode    : opcode_t;
		variable funct3    : funct3_t;
		variable funct7    : funct7_t;
		variable immediate : data_t;

		-- TODO: Add further variables and procedures as needed

		-- TODO: Drive dmem_out and return rddata in the correct byte ordering and withe the correct extending bytes if required
		procedure read_from_dmem(constant funct3: funct3_t; constant byte_addr: data_t; variable rddata: out data_t) is
		begin
		end procedure;

		-- TODO: Write wrdata (processor byte ordering) to dmem_out
		procedure write_to_dmem(constant funct3: funct3_t; constant byte_addr: data_t; constant wrdata: data_t) is
		begin
		end procedure;

		--TODO: Read the address in the imem the pc currently points to and return it in rddata
		procedure read_from_imem(variable rddata: out instr_t) is
		begin
			imem_out.rd <= '1';
			imem_out.address <= pc(imem_out.address'length+1 downto 2);
			wait for CLK_PERIOD;
			imem_out.rd <= '0';
			--TODO: return data in imem_in.rddata
		end procedure;

	begin
		dmem_out <= MEM_OUT_NOP;
		imem_out <= MEM_OUT_NOP;
		wait until res_n;
		wait until rising_edge(clk);
		wait for 1 ns;

		loop
			read_from_imem(instr);
			-- TODO: Add implementation (get instruction, decode and execute it)
		end loop;
		wait;
	end process;

end architecture;
