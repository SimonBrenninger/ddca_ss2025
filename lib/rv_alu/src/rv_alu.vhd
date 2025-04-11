library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_alu_pkg.all;


entity rv_alu is
	port (
		op     : in  rv_alu_op_t;
		a, b   : in  std_ulogic_vector(31 downto 0);
		result : out std_ulogic_vector(31 downto 0);
		z      : out std_ulogic
	);
end entity;

architecture arch of rv_alu is
begin
	process(all) is
	begin
		case op is
			when ALU_NOP =>
				result<= b;
			when ALU_SLT =>
				result <= (others => '0');
				if(signed(a) < signed(b)) then
					result(0) <= '1';
				else
					result(0) <= '0';
				end if;
			when ALU_SLTU =>
				result <= (others => '0');
				if(unsigned(a) < unsigned(b)) then
					result(0) <= '1';
				else
					result(0) <= '0';
				end if;
			when ALU_SLL =>
				result <= std_ulogic_vector(shift_left(unsigned(a), to_integer(unsigned(b(4 downto 0)))));
			when ALU_SRL =>
				result <= std_ulogic_vector(shift_right(unsigned(a), to_integer(unsigned(b(4 downto 0)))));
			when ALU_SRA =>
				result <= std_ulogic_vector(shift_right(signed(a), to_integer(unsigned(b(4 downto 0)))));
			when ALU_ADD =>
				result <= std_ulogic_vector(signed(a) + signed(b));
			when ALU_SUB =>
				result <= std_ulogic_vector(signed(a) - signed(b));
			when ALU_AND =>
				result <= a and b;
			when ALU_OR =>
				result <= A or B;
			when ALU_XOR =>
				result <= a xor b;
			when others =>
				null;
		end case;
	end process;

	z_gen : process(all) is
	begin
		case op is
			when ALU_SUB =>
				if(signed(a) = signed(b)) then
					z <= '1';
				else
					z <= '0';
				end if;
			when ALU_SLT =>
				z <= not result(0);
			when ALU_SLTU =>
				z <= not result(0);
			when others =>
				z <= '-';
		end case;
	end process;
end architecture;
