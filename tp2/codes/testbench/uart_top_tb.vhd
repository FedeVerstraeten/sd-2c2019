
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity uart_top_tb is
end entity uart_top_tb;


architecture uart_top_tb_arq of uart_top_tb is
	constant TCK	: time:= 20 ns; 		-- periodo de reloj
	signal clk		: std_logic := '0';
	signal reset	: std_logic := '0';
	signal rx_ready	: std_logic;
	signal rxd		: std_logic;
	signal data_received: std_logic_vector(7 downto 0);
	
begin
	clk <= not(clk) after TCK/ 2; -- reloj

	dut: entity work.uart
		port map(
			clk => clk,
			reset => reset,
			rx_ready => rx_ready,
			rx => rxd,
			r_data => data_received
		);
	
	reset <= '1', '0' after 100 ns;
	
	rxd <= '1'
	  , '0' after 1 us
	  , '1' after 53 us;
	
	-- rxd <= '1'
          -- , '0' after 100 us
          -- , '1' after 108.6 us
          -- , '0' after 117.36 us
          -- , '1' after 160.76 us
          -- , '0' after 169.44 us
          -- , '1' after 178.04 us;
	
end uart_top_tb_arq;