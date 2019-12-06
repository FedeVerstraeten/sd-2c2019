----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP2 - Recepción de caracteres por UART y visualización VGA
----------------------------------------------------------------------------------
-- Filename: uart.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    UART controller
-- Module Name:    UART controller
-- @Copyright (C):
--    This file is part of 'TP2 - Recepción de caracteres por UART y visualización VGA'.
--    Unauthorized copying or use of this file via any medium
--    is strictly prohibited.
----------------------------------------------------------------------------------
-- Description: 
-- Baud Rate = 115200
-- Clock rate = 50 us
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

entity uart is
  generic(
    BAUD_RATE: integer := 115200;   
    CLOCK_RATE: integer := 50E6
  );
  port(
    -- Write side inputs
    clk_pin: in std_logic;    -- Clock input (from pin)
    rst_pin: in std_logic;    -- Active HIGH reset (from pin)
    rxd_pin: in std_logic;    -- RS232 RXD pin - directly from pin
    
    rxd_clk_rx:  out std_logic;    -- RXD pin after synchronization to clk_rx
    rx_data:     out std_logic_vector(7 downto 0); -- 8 bit data output valid when rx_data_rdy is asserted
    rx_data_rdy: out std_logic;    -- Ready signal for rx_data
    frm_err:     out std_logic     -- The STOP bit was not detected  
  );
end;

architecture beh of uart is

  component meta_harden is
    port(
      clk_dst:  in std_logic; -- Destination clock
      rst_dst:  in std_logic; -- Reset - synchronous to destination clock
      signal_src: in std_logic; -- Asynchronous signal to be synchronized
      signal_dst: out std_logic -- Synchronized signal
    );
  end component;
  
  component uart_rx is
    generic(
      BAUD_RATE: integer := 115200;   -- Baud rate
      CLOCK_RATE: integer := 50E6     -- 50 MHz
    );

    port(
      -- Write side inputs
      clk_rx: in std_logic;               -- Clock input
      rst_clk_rx: in std_logic;           -- Active HIGH reset - synchronous to clk_rx
      rxd_i: in std_logic;                -- RS232 RXD pin - Directly from pad
  
      rxd_clk_rx: out std_logic;          -- RXD pin after synchronization to clk_rx   
      rx_data: out std_logic_vector(7 downto 0);  -- 8 bit data output valid when rx_data_rdy is asserted 
      rx_data_rdy: out std_logic;         -- Ready signal for rx_data
      frm_err: out std_logic              -- The STOP bit was not detected  
    );
  end component;
  

  -- Signals definition
  -- Meta Harden Reset output
  signal rst_clk_rx: std_logic;

  -- uart_rx output
  --signal rx_data: std_logic_vector(7 downto 0);   
  --signal rx_data_rdy: std_logic;
  
begin
  -- Metastability harden the rst - this is an asynchronous input to the
  -- system (from a pushbutton), and is used in synchronous logic. Therefore
  -- it must first be synchronized to the clock domain (clk_pin in this case)
  -- prior to being used. A simple metastability hardener is appropriate here.
  meta_harden_rst_i0: meta_harden
    port map(
      -- IN
      clk_dst   => clk_pin,
      rst_dst   => '0',       -- No reset on the hardener for reset!
      signal_src  => rst_pin,
      -- OUT
      signal_dst  => rst_clk_rx
    );

  uart_rx_i0: uart_rx 
    generic map(
      CLOCK_RATE  => CLOCK_RATE,
      BAUD_RATE   => BAUD_RATE
    )
    port map(
      -- IN
      clk_rx      => clk_pin,
      rst_clk_rx  => rst_clk_rx,
      rxd_i       => rxd_pin,
      -- OUT
      rxd_clk_rx  => open,
      rx_data_rdy => rx_data_rdy,
      rx_data     => rx_data,
      frm_err     => open
    );
end beh;
