library ieee;
use ieee.std_logic_1164.all;

use work.vnorm_pkg.all;
use work.uart_data_streamer_pkg.all;

architecture top_arch_vnorm of top is
	signal valid_out : std_ulogic;
	signal os_valid  : std_ulogic;

	signal os_data, is_data : std_ulogic_vector(95 downto 0);
	signal os_data_rev      : std_ulogic_vector(95 downto 0);

	signal vector_in, vector_out : vec3_t;

	function reverse_bytes(x: std_ulogic_vector) return std_ulogic_vector is
		constant WIDTH    : positive := x'length;
		variable reversed : std_ulogic_vector(WIDTH-1 downto 0);
	begin
		for i in 0 to WIDTH/8-1 loop
			reversed(8*(i+1)-1 downto 8*i) := x(WIDTH-1-8*i downto WIDTH-8*(i+1));
		end loop;

		return reversed;
	end function;

begin

	vnorm_inst : vnorm
	port map(
		clk        => clk,
		res_n      => keys(0),
		vector_in  => vector_in,
		valid_in   => os_valid,
		vector_out => vector_out,
		valid_out  => valid_out
	);

	os_data_rev <= reverse_bytes(os_data);

	vector_in.x <= std_logic_vector(os_data_rev(31 downto  0));
	vector_in.y <= std_logic_vector(os_data_rev(63 downto 32));
	vector_in.z <= std_logic_vector(os_data_rev(95 downto 64));

	is_data(95 downto 64) <= reverse_bytes(std_ulogic_vector(vector_out.x));
	is_data(63 downto 32) <= reverse_bytes(std_ulogic_vector(vector_out.y));
	is_data(31 downto 0)  <= reverse_bytes(std_ulogic_vector(vector_out.z));

	uart_data_streamer_inst : uart_data_streamer
	generic map (
		CLK_FREQ        => 50_000_000,
		BAUD_RATE       => 9600,
		IS_BUFFER_DEPTH => 64,
		OS_BUFFER_DEPTH => 64,
		OS_BYTES        => 12,
		IS_BYTES        => 12
	)
	port map (
		clk   => clk,
		res_n => keys(0),

		rx => rx,
		tx => tx,

		halt => switches(0),
		full => ledg(0),

		os_valid => os_valid,
		os_data  => os_data,
		os_ready => '1',

		is_valid => valid_out,
		is_data  => is_data,
		is_ready => open
	);

end architecture;
