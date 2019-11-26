----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP2 - Recepción de caracteres por UART y visualización VGA
----------------------------------------------------------------------------------
-- Filename: uart_tb.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    UART controller - Test Bench
-- Module Name:    UART controller - Test Bench
-- @Copyright (C):
--    This file is part of 'TP2 - Recepción de caracteres por UART y visualización VGA'.
--    Unauthorized copying or use of this file via any medium
--    is strictly prohibited.
----------------------------------------------------------------------------------
-- Description: 
----------------------------------------------------------------------------------
-- Dependencies:
----------------------------------------------------------------------------------
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tb is
end entity uart_tb;

architecture uart_tb_arch of uart_tb is
  
  constant TCK: time:= 20 ns;         -- clock period
  constant DELAY: natural:= 0;        -- DUT delay
  constant BAUD_VAL: integer:= 115200;
  constant CLOCK_VAL: integer:= 50E6;
  
  signal clk: std_logic:= '0';

  -- signals
  signal rst_pin: std_logic;
  signal rxd_pin: std_logic;
  signal rxd_clk_rx: std_logic;
  signal rx_data: std_logic_vector(7 downto 0) := (others => '0');
  signal rx_data_rdy: std_logic;
  signal frm_err: std_logic;

  -- component to test
  component uart is
   generic(
    BAUD_RATE: integer := 115200;   
    CLOCK_RATE: integer := 50E6
  );
  port(
    clk_pin: in std_logic;
    rst_pin: in std_logic;
    rxd_pin: in std_logic;
    
    rxd_clk_rx:  out std_logic;
    rx_data:     out std_logic_vector(7 downto 0);
    rx_data_rdy: out std_logic;
    frm_err:     out std_logic
  );
  end component uart;
  
begin
  -- System clock generation
  clk <= not(clk) after TCK/2;

  rxd_pin <= '1';
  rst_pin <= '1';

  DUT: uart
    generic map(
      BAUD_RATE => BAUD_VAL,
      CLOCK_RATE => CLOCK_VAL
    )
    port map(
      -- in
      clk_pin => clk,
      rst_pin => rst_pin,
      rxd_pin => rxd_pin,
      -- out
      rxd_clk_rx => rxd_pin,
      rx_data => rx_data,
      rx_data_rdy => rx_data_rdy,
      frm_err => frm_err
    );

end architecture uart_tb_arch; 
