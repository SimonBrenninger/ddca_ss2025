
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.uart_data_streamer_pkg.all;
use work.mem_pkg.all;

use work.sync_pkg.all;

entity uart_data_streamer is
	generic (
		CLK_FREQ        : positive := 50_000_000;
		SYNC_STAGES     : positive := 2;
		IS_BUFFER_DEPTH : positive := 16;
		IS_BYTES        : positive;
		OS_BUFFER_DEPTH : positive := 16;
		OS_BYTES        : positive;
		BAUD_RATE       : positive := 9600;
		BYTE_ORDER      : BYTE_ORDER_T := BIG_ENDIAN
	);
	port (
		clk   : in std_ulogic;
		res_n : in std_ulogic;

		-- UART
		rx : in  std_ulogic;
		tx : out std_ulogic;

		-- output stream -- from rx to core
		os_valid : out std_ulogic;
		os_data  : out std_ulogic_vector(OS_BYTES * 8 - 1 downto 0);
		os_ready : in  std_ulogic;
		halt     : in  std_ulogic;

		-- input stream -- from core to tx
		is_valid : in  std_ulogic;
		is_data  : in  std_ulogic_vector(IS_BYTES * 8 - 1 downto 0);
		is_ready : out std_ulogic;
		full     : out std_ulogic
	);
end entity;


architecture arch of uart_data_streamer is
	constant CLK_DIVISOR : integer := CLK_FREQ/BAUD_RATE;
	constant OS_DATA_WIDTH : positive := OS_BYTES * 8;
	constant IS_DATA_WIDTH : positive := IS_BYTES * 8;

	signal tx_fifo_rd_ack, tx_fifo_rd_valid, tx_fifo_full : std_ulogic := '0';
	signal tx_fifo_data_out : std_ulogic_vector(OS_DATA_WIDTH-1 downto 0) := (others => '0');

	signal rx_fifo_wr : std_ulogic := '0';
	signal rx_fifo_data_in : std_ulogic_vector(IS_DATA_WIDTH-1 downto 0) := (others => '0');

	signal rx_fifo_valid, rx_fifo_full : std_ulogic := '0';

	signal rx_sync : std_ulogic := '0';
begin
	rx_syncer: sync
	generic map(
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '0'
	)
	port map(
		clk      => clk,
		res_n    => res_n,

		data_in  => rx,
		data_out => rx_sync
	);

	-- data from core to tx to outside
	tx_fifo : fifo_1c1r1w_fwft
	generic map (
		DEPTH      => IS_BUFFER_DEPTH,
		DATA_WIDTH => IS_DATA_WIDTH
	)
	port map (
		clk       => clk,
		res_n     => res_n,

		rd_data   => tx_fifo_data_out,
		rd_ack    => tx_fifo_rd_ack,
		rd_valid  => tx_fifo_rd_valid,

		wr_data   => is_data,
		wr        => (not tx_fifo_full) and is_valid,

		full      => tx_fifo_full,
		half_full => open
	);

	-- data  from outside  to rx to core
	rx_fifo : fifo_1c1r1w_fwft
	generic map (
		DEPTH      => OS_BUFFER_DEPTH,
		DATA_WIDTH => OS_DATA_WIDTH
	)
	port map (
		clk       => clk,
		res_n     => res_n,

		rd_data   => os_data,
		rd_ack    => os_ready and os_valid,
		rd_valid  => rx_fifo_valid,

		wr_data   => rx_fifo_data_in,
		wr        => is_ready and rx_fifo_wr,

		full      => rx_fifo_full,
		half_full => open
	);

	full <= rx_fifo_full;

	is_ready <= not tx_fifo_full;

	os_valid <= rx_fifo_valid and (not halt);

	uart_tx_fsm : block
		type TRANSMITTER_STATE_TYPE is (IDLE, NEW_DATA, NEXT_DATA, SEND_START_BIT, TRANSMIT_FIRST, TRANSMIT, TRANSMIT_NEXT, TRANSMIT_STOP_NEXT, TRANSMIT_STOP);

		signal transmitter_state : TRANSMITTER_STATE_TYPE;
		signal transmitter_state_next : TRANSMITTER_STATE_TYPE;

		--clock cycle counter
		signal clk_cnt : integer range 0 to CLK_DIVISOR;
		signal clk_cnt_next : integer range 0 to CLK_DIVISOR;

		-- bit counter
		signal bit_cnt : integer range 0 to 7;
		signal bit_cnt_next : integer range 0 to 7;

		signal transmit_data : std_ulogic_vector(7 downto 0); -- buffer for the current byte
		signal transmit_data_next : std_ulogic_vector(7 downto 0);

		signal transmit_data_subrange_cnt, transmit_data_subrange_cnt_next : natural := 0;
		signal transmit_data_whole, transmit_data_whole_next : std_ulogic_vector(OS_DATA_WIDTH-1 downto 0) := (others => '0');
	begin
		sync : process(res_n, clk)
		begin
			if res_n = '0' then
				transmitter_state <= IDLE;
				clk_cnt <= 0;
			elsif rising_edge(clk) then
				transmitter_state <= transmitter_state_next;
				clk_cnt <= clk_cnt_next;
				bit_cnt <= bit_cnt_next;
				transmit_data <= transmit_data_next;
				transmit_data_whole <= transmit_data_whole_next;
				transmit_data_subrange_cnt <= transmit_data_subrange_cnt_next;
			end if;
		end process;

		next_state : process(clk_cnt, bit_cnt, transmitter_state, transmit_data_subrange_cnt, tx_fifo_rd_valid)
		begin
			transmitter_state_next <= transmitter_state; --default

			case transmitter_state is

				when IDLE =>
					if tx_fifo_rd_valid = '1' then --check if the fifo is empty
						transmitter_state_next <= NEW_DATA;
					end if;

				when NEW_DATA =>
					transmitter_state_next <= SEND_START_BIT;

				when NEXT_DATA =>
					transmitter_state_next <= SEND_START_BIT;

				when SEND_START_BIT =>
					--check if the bittime is over
					if clk_cnt = CLK_DIVISOR - 2 then
						transmitter_state_next <= TRANSMIT_FIRST;
					end if;

				when TRANSMIT_FIRST =>
					transmitter_state_next <= TRANSMIT;

				when TRANSMIT =>
					if clk_cnt = CLK_DIVISOR - 2 and bit_cnt < 7 then
						transmitter_state_next <= TRANSMIT_NEXT;
					elsif clk_cnt = CLK_DIVISOR - 2 then
						transmitter_state_next <= TRANSMIT_STOP_NEXT;
					end if;

				when TRANSMIT_NEXT =>
					transmitter_state_next <= TRANSMIT;

				when TRANSMIT_STOP_NEXT =>
					transmitter_state_next <= TRANSMIT_STOP;

				when TRANSMIT_STOP =>
					if clk_cnt = CLK_DIVISOR - 2 then
						if transmit_data_subrange_cnt < (IS_BYTES) then
							transmitter_state_next <= NEXT_DATA;
						elsif tx_fifo_rd_valid = '1' then
							transmitter_state_next <= NEW_DATA;
						else
							transmitter_state_next <= IDLE;
						end if;
					end if;
			end case;
		end process;


		output : process(clk_cnt, bit_cnt, transmitter_state, transmit_data, transmit_data_subrange_cnt, transmit_data_whole, tx_fifo_data_out)
		begin

			transmit_data_next <= transmit_data;
			clk_cnt_next <= clk_cnt;
			bit_cnt_next <= bit_cnt;
			tx_fifo_rd_ack <= '0';
			tx <= '1'; -- the idle state of the tx output is high
			transmit_data_whole_next <= transmit_data_whole;
			transmit_data_subrange_cnt_next <= transmit_data_subrange_cnt;

			case transmitter_state is

				when IDLE =>
					--do nothing
				when NEW_DATA =>
					-- set ack to read the next byte from the fifo,
					-- ack is reset automaticaly by the default assignment, when the next state is entered
					tx_fifo_rd_ack <= '1';
					transmit_data_whole_next <= tx_fifo_data_out;
					clk_cnt_next <= 0; --reset counter
					transmit_data_subrange_cnt_next <= 0;
				when NEXT_DATA =>
					clk_cnt_next <= 0; --reset counter

				when SEND_START_BIT =>
					tx <= '0'; --send start bit, low --> automatic reset by default assignment
					clk_cnt_next <= clk_cnt + 1;

				when TRANSMIT_FIRST =>
					clk_cnt_next <= 0; -- reset clk counter
					-- get next byte from transmit_data_wholetransmit_data_whole
					if BYTE_ORDER = LITTLE_ENDIAN then
						transmit_data_next <= transmit_data_whole(8 * (IS_BYTES - transmit_data_subrange_cnt) - 1 downto 8 * (IS_BYTES - transmit_data_subrange_cnt - 1));
					else
						transmit_data_next <= transmit_data_whole(8 * (transmit_data_subrange_cnt + 1) - 1 downto 8 * transmit_data_subrange_cnt);
					end if;

					bit_cnt_next <= 0;
					tx <= '0'; --we are still sending the start bit!

					transmit_data_subrange_cnt_next <= transmit_data_subrange_cnt + 1;

				when TRANSMIT =>
					clk_cnt_next <= clk_cnt + 1;
					tx <= transmit_data(0);

				when TRANSMIT_NEXT =>
					clk_cnt_next <= 0;
					bit_cnt_next <= bit_cnt + 1;
					tx <= transmit_data(0);
					transmit_data_next(6 downto 0) <= transmit_data(7 downto 1); -- shift transmit_data
					-- srl shift right logical

				when TRANSMIT_STOP_NEXT =>
					clk_cnt_next <= 0;
					tx <= transmit_data(0);

				when TRANSMIT_STOP =>
					clk_cnt_next <= clk_cnt + 1;

			end case;

		end process;
	end block;

	uart_rx_fsm : block
		type RECEIVER_STATE_TYPE is (
			IDLE,
			WAIT_START_BIT,
			GOTO_MIDDLE_OF_START_BIT,
			MIDDLE_OF_START_BIT,
			WAIT_DATA_BIT,
			MIDDLE_OF_DATA_BIT,
			WAIT_STOP_BIT,
			MIDDLE_OF_STOP_BIT
		);

		signal receiver_state : RECEIVER_STATE_TYPE := IDLE;
		signal receiver_state_next : RECEIVER_STATE_TYPE := IDLE;

		signal clk_cnt : integer range 0 to CLK_DIVISOR := 0;
		signal clk_cnt_next : integer range 0 to CLK_DIVISOR := 0;

		signal bit_cnt : integer range 0 to 7 := 0;
		signal bit_cnt_next : integer range 0 to 7 := 0;

		signal data_int : std_ulogic_vector(7 downto 0) := (others => '0');
		signal data_int_next : std_ulogic_vector(7 downto 0) := (others => '0');

		signal rx_fifo_data_subrange_cnt, rx_fifo_data_subrange_cnt_next : natural := 0;
		signal rx_fifo_acc_data, rx_fifo_acc_data_next : std_ulogic_vector(IS_DATA_WIDTH-1 downto 0) := (others => '0');
		signal rx_fifo_wr_int, rx_fifo_wr_next : std_ulogic := '0';
	begin
		sync : process(res_n, clk)
		begin
			if res_n = '0' then
				receiver_state <= IDLE;
				rx_fifo_data_subrange_cnt <= 0;
				rx_fifo_acc_data <= (others => '0');
			elsif rising_edge(clk) then
				receiver_state <= receiver_state_next;
				clk_cnt <= clk_cnt_next;
				bit_cnt <= bit_cnt_next;
				data_int <= data_int_next;
				--uart_data_pkg <= uart_data_pkg_next;
				rx_fifo_data_subrange_cnt <= rx_fifo_data_subrange_cnt_next;
				rx_fifo_acc_data <= rx_fifo_acc_data_next;
				rx_fifo_wr_int <= rx_fifo_wr_next;
			end if;
		end process;

		next_state : process(all)
		begin

			receiver_state_next <= receiver_state;

			case receiver_state is

				when IDLE =>
					if(rx_fifo_full = '0' and rx_sync = '1') then
						receiver_state_next <= WAIT_START_BIT;
					end if;

				when WAIT_START_BIT =>
					if(rx_sync = '0') then
						receiver_state_next <= GOTO_MIDDLE_OF_START_BIT;
					end if;

				when GOTO_MIDDLE_OF_START_BIT =>
					if(clk_cnt = CLK_DIVISOR/2-2) then
						receiver_state_next <= MIDDLE_OF_START_BIT;
					end if;

				when MIDDLE_OF_START_BIT =>
					receiver_state_next <= WAIT_DATA_BIT;

				when WAIT_DATA_BIT =>
					if(clk_cnt = CLK_DIVISOR-2) then
						receiver_state_next <= MIDDLE_OF_DATA_BIT;
					end if;

				when MIDDLE_OF_DATA_BIT =>
					if(bit_cnt < 7) then
						receiver_state_next <= WAIT_DATA_BIT;
					else
						receiver_state_next <= WAIT_STOP_BIT;
					end if;

				when WAIT_STOP_BIT =>
					if(clk_cnt = CLK_DIVISOR-2) then
						receiver_state_next <= MIDDLE_OF_STOP_BIT;
					end if;

				when MIDDLE_OF_STOP_BIT =>
					if(rx_sync = '1') then
						receiver_state_next <= WAIT_START_BIT;
					else
						receiver_state_next <= IDLE;
					end if;
			end case;

		end process;


		output : process(all)
		begin
			clk_cnt_next <= clk_cnt;
			bit_cnt_next <= bit_cnt;
			data_int_next <= data_int;

			rx_fifo_acc_data_next <= rx_fifo_acc_data;
			rx_fifo_data_subrange_cnt_next <= rx_fifo_data_subrange_cnt;
			rx_fifo_wr_next <= '0';

			case receiver_state is

				when IDLE =>

				when WAIT_START_BIT =>
					bit_cnt_next <= 0;
					clk_cnt_next <= 0;

				when GOTO_MIDDLE_OF_START_BIT =>
					clk_cnt_next <= clk_cnt + 1;

				when MIDDLE_OF_START_BIT =>
					clk_cnt_next <= 0;

				when WAIT_DATA_BIT =>
					clk_cnt_next <= clk_cnt + 1;

				when MIDDLE_OF_DATA_BIT =>
					clk_cnt_next <= 0;
					if(bit_cnt < 7) then
						bit_cnt_next <= bit_cnt + 1;
					else
						bit_cnt_next <= bit_cnt;
					end if;
					data_int_next <= rx_sync & data_int(7 downto 1);

				when WAIT_STOP_BIT =>
					clk_cnt_next <= clk_cnt + 1;

				when MIDDLE_OF_STOP_BIT =>
					if BYTE_ORDER = LITTLE_ENDIAN then
						rx_fifo_acc_data_next(8 * (OS_BYTES - rx_fifo_data_subrange_cnt) - 1   downto 8 * (OS_BYTES - rx_fifo_data_subrange_cnt -1)) <= data_int;
					else
						rx_fifo_acc_data_next(8 * (rx_fifo_data_subrange_cnt + 1) - 1   downto 8 * rx_fifo_data_subrange_cnt) <= data_int;
					end if;
					rx_fifo_data_subrange_cnt_next <= rx_fifo_data_subrange_cnt + 1;

					if rx_fifo_data_subrange_cnt = OS_BYTES - 1 then
						rx_fifo_data_subrange_cnt_next <= 0;
						rx_fifo_wr_next <= '1';
					end if;
			end case;

		end process;

		rx_fifo_data_in <= rx_fifo_acc_data;
		rx_fifo_wr      <= rx_fifo_wr_int;
	end block;

end architecture;


