library ieee;
use ieee.std_logic_1164.all;

use work.rv_sys_pkg.all;

entity mm_serial_port is
	generic (
		CLK_FREQ      : integer;
		BAUD_RATE     : integer;
		SYNC_STAGES   : integer;
		TX_FIFO_DEPTH : integer := 4;
		RX_FIFO_DEPTH : integer := 4
	);
	port (
		clk     : in  std_ulogic;
		res_n   : in  std_ulogic;

		address : in  std_ulogic_vector(0 downto 0);
		wr      : in  std_ulogic;
		wr_data : in  mem_data_t;
		rd      : in  std_ulogic;
		rd_data : out mem_data_t;

		tx      : out std_ulogic;
		rx      : in  std_ulogic
	);
end entity;

architecture behavior of mm_serial_port is

	signal tx_fifo_wr_data : std_ulogic_vector(7 downto 0);
	signal tx_fifo_wr : std_ulogic;
	signal tx_fifo_full : std_ulogic;
	signal tx_fifo_rd : std_ulogic;
	signal tx_fifo_rd_data : std_ulogic_vector(7 downto 0);
	signal tx_fifo_empty : std_ulogic;
	
	signal rx_data : std_ulogic_vector(7 downto 0);
	signal rx_rd : std_ulogic;
	signal rx_data_empty : std_ulogic;
	signal rx_data_full : std_ulogic;

	signal rd_address : std_logic_vector(0 downto 0);

	signal rx_int, tx_int, new_data : std_ulogic;
	signal data : std_ulogic_vector(7 downto 0);
	
	signal tx_free : std_ulogic;
	
	constant CLK_DIVISOR : integer := CLK_FREQ / BAUD_RATE;
begin
	tx_free <= not tx_fifo_full;

	sync_rx : entity work.sync
	generic map (
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '1'
	)
	port map (
		clk => clk,
		res_n => res_n,
		data_in => rx,
		data_out => rx_int
	);
	
	rx_fsm : block
		type rx_fsm_state_t is (IDLE, WAIT_START_BIT, GOTO_MIDDLE_OF_START_BIT, MIDDLE_OF_START_BIT, WAIT_DATA_BIT, MIDDLE_OF_DATA_BIT, WAIT_STOP_BIT, MIDDLE_OF_STOP_BIT);
		signal state, next_state: rx_fsm_state_t;
		signal next_new_data: std_ulogic;
		signal next_data, data_int, next_data_int: std_logic_vector(7 downto 0);

		--clock cycle counter
		signal clk_cnt : integer range 0 to CLK_DIVISOR := 0;
		signal next_clk_cnt : integer range 0 to CLK_DIVISOR := 0;

		--bit counter
		signal bit_cnt : integer range 0 to 8 := 0;
		signal next_bit_cnt : integer range 0 to 8 := 0;
	begin
		rx_fsm_sync : process(res_n, clk)
		begin
			if res_n = '0' then
				state <= IDLE;
				clk_cnt <= 0;
			elsif rising_edge(clk) then
				state <= next_state;

				new_data <= next_new_data;
				data <= next_data;

				clk_cnt <= next_clk_cnt;
				bit_cnt <= next_bit_cnt;
				data_int <= next_data_int;
			end if;
		end process;

		rx_fsm_next: process(all)
		begin
			next_state <= state;
			next_new_data <= new_data;
			next_bit_cnt <= bit_cnt;
			next_clk_cnt <= clk_cnt;
			next_data_int <= data_int;
			next_data <= data;
			
			case state is
				when IDLE =>
					next_new_data <= '0';
					if (rx_int = '1') then
						next_state <= WAIT_START_BIT;
					end if;
				when WAIT_START_BIT =>
					next_bit_cnt <= 0;
					next_clk_cnt <= 0;
					next_new_data <= '0';
					next_data_int <= (others=>'0');
					if (rx_int = '0') then
						next_state <= GOTO_MIDDLE_OF_START_BIT;
					end if;
				when GOTO_MIDDLE_OF_START_BIT =>
					next_clk_cnt <= clk_cnt + 1;
					if (clk_cnt = CLK_DIVISOR/2-2) then
						next_state <= MIDDLE_OF_START_BIT;
					end if;
				when MIDDLE_OF_START_BIT =>
					next_clk_cnt <= 0;
					next_state <= WAIT_DATA_BIT;
				when WAIT_DATA_BIT =>
					next_clk_cnt <= clk_cnt + 1;
					if (clk_cnt = CLK_DIVISOR-2) then
						next_state <= MIDDLE_OF_DATA_BIT;
					end if;
				when MIDDLE_OF_DATA_BIT =>
					next_clk_cnt <= 0;
					next_bit_cnt <= bit_cnt + 1;
					next_data_int <= rx_int & data_int(7 downto 1);
					if (bit_cnt < 7) then
						next_state <= WAIT_DATA_BIT;
					elsif (bit_cnt = 7) then
						next_state <= WAIT_STOP_BIT;
					end if;
				when WAIT_STOP_BIT =>
					next_clk_cnt <= clk_cnt + 1;
					if (clk_cnt = CLK_DIVISOR-2) then
						next_state <= MIDDLE_OF_STOP_BIT;
					end if;
				when MIDDLE_OF_STOP_BIT =>
					next_new_data <= '1';
					next_data <= data_int;
					if (rx_int = '0') then
						next_state <= IDLE;
					elsif (rx_int = '1') then
						next_state <= WAIT_START_BIT;
					end if;
				when others =>
					next_state <= IDLE;
			end case;
		end process;
	end block;
	
	rx_fifo_inst : entity work.fifo_1c1r1w
	generic map (
		DEPTH => RX_FIFO_DEPTH,
		DATA_WIDTH => 8
	)
	port map (
		clk => clk,
		res_n => res_n,
		rd => rx_rd,
		wr => new_data,
		wr_data => data,
		empty => rx_data_empty,
		rd_data => rx_data,
		full => rx_data_full
	);
	
	tx_fifo_inst : entity work.fifo_1c1r1w
	generic map (
		DEPTH => TX_FIFO_DEPTH,
		DATA_WIDTH => 8
	)
	port map (
		clk => clk,
		res_n => res_n,
		wr      => tx_fifo_wr,
		wr_data => tx_fifo_wr_data,
		rd      => tx_fifo_rd,
		rd_data => tx_fifo_rd_data,
		full    => tx_fifo_full,
		empty   => tx_fifo_empty
	);
	
	tx_fsm : block
		type tx_fsm_state_t is (
			IDLE,
			READ_NEW_DATA,
			SEND_START_BIT,
			TRANSMIT_FIRST,
			TRANSMIT,
			TRANSMIT_NEXT,
			TRANSMIT_STOP_NEXT,
			TRANSMIT_STOP
		);
		signal tx_fsm_state, tx_fsm_state_next : tx_fsm_state_t;

		signal clk_cnt : integer range 0 to CLK_DIVISOR;
		signal clk_cnt_next : integer range 0 to CLK_DIVISOR;
		signal bit_cnt : integer range 0 to 7;
		signal bit_cnt_next : integer range 0 to 7;

		signal transmit_data : std_ulogic_vector(7 downto 0); -- buffer for the current byte
		signal transmit_data_next : std_ulogic_vector(7 downto 0);
	begin

		tx_fsm_sync : process(clk, res_n)
		begin
			if res_n = '0' then
				tx_fsm_state <= IDLE;
				clk_cnt <= 0;
				bit_cnt <= 0;
				transmit_data <= (others=>'0');
			elsif rising_edge(clk) then
				tx_fsm_state <= tx_fsm_state_next;
				clk_cnt <= clk_cnt_next;
				bit_cnt <= bit_cnt_next;
				transmit_data <= transmit_data_next;
			end if;
		end process;

		next_state : process(all)
		begin
			tx_fsm_state_next <= tx_fsm_state;
			transmit_data_next <= transmit_data;
			clk_cnt_next <= clk_cnt;
			bit_cnt_next <= bit_cnt;
			tx_fifo_rd <= '0';
			tx <= '1';  -- the idle state of the tx output is high

			case tx_fsm_state is
			
				when IDLE =>
					if tx_fifo_empty = '0' then
						tx_fsm_state_next <= READ_NEW_DATA;
					end if;
				
				when READ_NEW_DATA =>
					tx_fifo_rd <= '1';
					clk_cnt_next <= 0;
					tx_fsm_state_next <= SEND_START_BIT;
					
				when SEND_START_BIT =>
					tx <= '0';
					clk_cnt_next <= clk_cnt + 1;
					--check if the bittime is over
					if clk_cnt = CLK_DIVISOR - 2 then
						tx_fsm_state_next <= TRANSMIT_FIRST;
					end if;
				
				when TRANSMIT_FIRST =>
					clk_cnt_next <= 0;
					transmit_data_next <= tx_fifo_rd_data;
					bit_cnt_next <= 0;
					tx <= '0';
					tx_fsm_state_next <= TRANSMIT;
				
				when TRANSMIT =>
					clk_cnt_next <= clk_cnt + 1;
					tx <= transmit_data(0);
					if clk_cnt = CLK_DIVISOR - 2 and bit_cnt < 7 then
						tx_fsm_state_next <= TRANSMIT_NEXT;
					elsif clk_cnt = CLK_DIVISOR - 2 then
						tx_fsm_state_next <= TRANSMIT_STOP_NEXT;
					end if;
					
				when TRANSMIT_NEXT =>
					clk_cnt_next <= 0;
					bit_cnt_next <= bit_cnt + 1;
					tx <= transmit_data(0);
					transmit_data_next(6 downto 0) <= transmit_data(7 downto 1);
					tx_fsm_state_next <= TRANSMIT;
				
				when TRANSMIT_STOP_NEXT =>
					clk_cnt_next <= 0;
					tx <= transmit_data(0);
					tx_fsm_state_next <= TRANSMIT_STOP;
				
				when TRANSMIT_STOP =>
					clk_cnt_next <= clk_cnt + 1;
					if clk_cnt = CLK_DIVISOR - 2 and tx_fifo_empty = '0' then
						tx_fsm_state_next <= READ_NEW_DATA;
					elsif clk_cnt = CLK_DIVISOR - 2 then
						tx_fsm_state_next <= IDLE;
					end if;
			end case;
		end process;
	end block;

	sync: process (clk, res_n)
	begin
		if res_n = '0' then
			rd_address <= (others => '0');
		elsif rising_edge(clk) then
			if rd = '1' then
				rd_address <= address;
			end if;
		end if;
	end process;

	write: process (all)
	begin
		tx_fifo_wr_data <= wr_data(31 downto 24);
		if address(0) = '1' then
			tx_fifo_wr <= wr;
		else
			tx_fifo_wr <= '0';
		end if;
	end process;

	read: process (all)
	begin
		if address(0) = '1' then
			rx_rd <= rd;
		else
			rx_rd <= '0';
		end if;
		rd_data <= (others => '0');
		if rd_address(0) = '1' then
			rd_data(31 downto 24) <= rx_data;
		else
			rd_data(31 downto 24) <= "00000" & rx_data_full & not rx_data_empty & tx_free;
		end if;
	end process;
end architecture;
