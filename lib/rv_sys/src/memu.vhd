library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rv_sys_pkg.all;

entity memu is
	port (
		op     : in  memu_op_t;
		addr   : in  mem_data_t;
		wrdata : in  mem_data_t;
		rddata : out mem_data_t := (others => '0');
		busy   : out std_ulogic := '0';

		xl : out std_ulogic := '0';
		xs : out std_ulogic := '0';
		
		mem_in  : in  mem_in_t;
		mem_out : out mem_out_t
	);
end entity;

architecture rtl of memu is
	alias wb0 : std_ulogic_vector(7 downto 0) is wrdata(7 downto 0);
	alias wb1 : std_ulogic_vector(7 downto 0) is wrdata(15 downto 8);
	alias wb2 : std_ulogic_vector(7 downto 0) is wrdata(23 downto 16);
	alias wb3 : std_ulogic_vector(7 downto 0) is wrdata(31 downto 24);
	
	alias db0 : std_ulogic_vector(7 downto 0) is mem_in.rddata(7 downto 0);
	alias db1 : std_ulogic_vector(7 downto 0) is mem_in.rddata(15 downto 8);
	alias db2 : std_ulogic_vector(7 downto 0) is mem_in.rddata(23 downto 16);
	alias db3 : std_ulogic_vector(7 downto 0) is mem_in.rddata(31 downto 24);
begin
	--wrdata & byteena
	process(all) is
	begin
		case op.access_type is
			when MEM_B | MEM_BU =>
				if(addr(1 downto 0)="00") then
					mem_out.byteena<="1000";
					mem_out.wrdata<=(others=>'-');
					mem_out.wrdata(31 downto 24)<=wb0;
				elsif(addr(1 downto 0)="01") then
					mem_out.byteena<="0100";
					mem_out.wrdata<=(others=>'-');
					mem_out.wrdata(23 downto 16)<=wb0;
				elsif(addr(1 downto 0)="10") then
					mem_out.byteena<="0010";
					mem_out.wrdata<=(others=>'-');
					mem_out.wrdata(15 downto 8)<=wb0;
				else
					mem_out.byteena<="0001";
					mem_out.wrdata<=(others=>'-');
					mem_out.wrdata(7 downto 0)<=wb0;
				end if;
			when MEM_H | MEM_HU =>
				if(addr(1 downto 0)="00" or addr(1 downto 0)="01") then
					mem_out.byteena<="1100";
					mem_out.wrdata<=(others=>'-');
					mem_out.wrdata(31 downto 16) <= wb0 & wb1;
				else
					mem_out.byteena<="0011";
					mem_out.wrdata<=(others=>'-');
					mem_out.wrdata(15 downto 0) <= wb0 & wb1;
				end if;
			when MEM_W =>
				mem_out.byteena<="1111";
				mem_out.wrdata<=wb0 & wb1 & wb2 & wb3;
		end case;
	end process;

	--R
	process(all) is
	begin
		case op.access_type is
			when MEM_B =>
				case addr(1 downto 0) is
					when "00" =>
						rddata(31 downto 8) <= (others=>db3(7));
						rddata(7 downto 0) <= db3;
					when "01" =>
						rddata(31 downto 8) <= (others=>db2(7));
						rddata(7 downto 0) <= db2;
					when "10" =>
						rddata(31 downto 8) <= (others=>db1(7));
						rddata(7 downto 0) <= db1;
					when others =>
						rddata(31 downto 8) <= (others=>db0(7));
						rddata(7 downto 0) <= db0;
				end case;
			when MEM_BU =>
				rddata(31 downto 8)<=(others=>'0');
				case addr(1 downto 0) is
					when "00" => rddata(7 downto 0) <= db3;
					when "01" => rddata(7 downto 0) <= db2;
					when "10" => rddata(7 downto 0) <= db1;
					when others => rddata(7 downto 0) <= db0;
				end case;
			when MEM_H =>
				case addr(1) is
					when '0' =>
						rddata(31 downto 16) <= (others=>db2(7));
						rddata(15 downto 0) <= db2 & db3;
					when others =>
						rddata(31 downto 16) <= (others=>db0(7));
						rddata(15 downto 0) <= db0 & db1;
				end case;
			when MEM_HU =>
				rddata(31 downto 16)<=(others=>'0');
				case addr(1) is
					when '0' => rddata(15 downto 0) <= db2 & db3;
					when others => rddata(15 downto 0) <= db0 & db1;
				end case;
			when MEM_W =>
				rddata <= db0 & db1 & db2 & db3;
		end case;
	end process;

	--XL
	process(all) is
	begin
		xl<='0';
		if(op.rd = '1') then
			case op.access_type is
				when MEM_H =>
					if(addr(1 downto 0)="01" or addr(1 downto 0)="11") then
						xl<='1';
					end if;
				when MEM_HU =>
					if(addr(1 downto 0)="01" or addr(1 downto 0)="11") then
						xl<='1';
					end if;
				when MEM_W =>
					if(addr(1 downto 0)="01" or addr(1 downto 0)="10" or addr(1 downto 0)="11") then
						xl<='1';
					end if;
				when others =>
					null;
			end case;
		end if;
	end process;

	--XS
	process(all) is
	begin
		xs<='0';
		if (op.wr='1') then
			case op.access_type is
				when MEM_H =>
					if(addr(1 downto 0)="01" or addr(1 downto 0)="11") then
						xs<='1';
					end if;
				when MEM_HU =>
					if(addr(1 downto 0)="01" or addr(1 downto 0)="11") then
						xs<='1';
					end if;
				when MEM_W =>
					if(addr(1 downto 0)="01" or addr(1 downto 0)="10" or addr(1 downto 0)="11") then
						xs<='1';
					end if;
				when others =>
					null;
			end case;
		end if;
	end process;

	busy <= mem_in.busy or mem_out.rd;

	mem_out.rd<=op.rd and not xl; --op.memread and not(XL or XS);
	mem_out.wr<=op.wr and not(xl or xs);
	mem_out.address<=addr(mem_out.address'length+1 downto 2);
end architecture;
