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
-- Baud Rate = 19200
-- Clock rate = 50 us
----------------------------------------------------------------------------------
-- Dependencies:
--    mod_m_counter.vhd
--    uart_rx.vhd
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
     -- Default setting:
     -- 19,200 baud, 8 data bis, 1 stop its, 2^2 FIFO
    DBIT: integer:=8;     -- # data bits  
    SB_TICK: integer:=16; -- # ticks for stop bits, 16/24/32
                          --   for 1/1.5/2 stop bits
    DVSR: integer:= 163;  -- baud rate divisor
                          -- DVSR = 50M/(16*baud rate)
    DVSR_BIT: integer:=8 -- # bits of DVSR
   );
   port(
      clk, reset: in std_logic;
      rx: in std_logic;
      rx_ready: out std_logic;
      r_data: out std_logic_vector(7 downto 0)
   );
end uart;

architecture arch of uart is
   signal tick: std_logic;
begin
  baud_gen_unit: entity work.mod_m_counter(arch)
  generic map(
      M=>DVSR, 
      N=>DVSR_BIT)
  port map(
      clk=>clk,
      reset=>reset,
      q=>open, 
      max_tick=>tick
  );
  
  uart_rx_unit: entity work.uart_rx(arch)
  generic map(
      DBIT=>DBIT,
      SB_TICK=>SB_TICK
  )
  port map(
      clk=>clk,
      reset=>reset,
      rx=>rx,
      s_tick=>tick,
      rx_done_tick=>rx_ready,
      dout=>r_data
  );
end arch;