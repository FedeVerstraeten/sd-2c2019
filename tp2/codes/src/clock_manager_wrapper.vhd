----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP2 - Recepción de caracteres por UART y visualización VGA
----------------------------------------------------------------------------------
-- Filename: clock_manager_wrapper.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    Clock Manager Wrapper
-- Module Name:    Clock Manager Wrapper
-- @Copyright (C):
--    This file is part of 'TP2 - Recepción de caracteres por UART y visualización VGA'.
--    Unauthorized copying or use of this file via any medium
--    is strictly prohibited.
----------------------------------------------------------------------------------
-- Description: 
--  Wrapper of  IPblock clk_wiz_0 component
----------------------------------------------------------------------------------
-- Dependencies:
--  IP block clk_wiz_0
--  input freq = 125 MHz
--  output freq = 5 MHz
----------------------------------------------------------------------------------
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity clock_manager_wrapper is
  port (
    reset : in std_logic;
    sys_clk : out std_logic;
    sys_clk_pin : in std_logic
  );
end clock_manager_wrapper;

architecture structure of clock_manager_wrapper is
  component clk_wiz_0 is
  port (
    clk_in1 : in std_logic;
    clk_out1 : out std_logic;
    reset : in std_logic;
    locked : out std_logic
  );
  end component clk_wiz_0;
begin
clock_manager_i: component clk_wiz_0
     port map (
      reset => reset,
      locked => open,
      clk_out1 => sys_clk,
      clk_in1 => sys_clk_pin
    );
end structure;