----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP1 - Aritmetica de punto flotante
----------------------------------------------------------------------------------
-- Filename: fp_subtractor.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    Floating Point Subtractor
-- Module Name:    FP Subtractor
-- @Copyright (C):
--    This file is part of 'TP1 - Aritmetica de punto flotante'.
--    Unauthorized copying or use of this file via any medium
--    is strictly prohibited.
----------------------------------------------------------------------------------
-- Description: 
-- Implementation to subtract two floating point numbers IEEE-754
-- Using pipeline blocks in 5 stages 
--
-- 32|    31|30          23|22                    0|
--   | sign |   exponent   |       mantissa        |
--
-- Part         | # bits
-- -----------------------
-- sign         |    1
-- exponent     |    8
-- mantissa     |   23
-- TOTAL        |   32
-- 
----------------------------------------------------------------------------------
-- Dependencies:
-- 
----------------------------------------------------------------------------------
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_subtractor is
  -- Default constants value
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );

  port(
    clk: in std_logic;
    rst: in std_logic;
    
    a_in: in std_logic_vector(FP_LEN-1 downto 0);
    b_in: in std_logic_vector(FP_LEN-1 downto 0);
    
    s_out: out std_logic_vector((FP_LEN -1) downto 0)
  );
end fp_subtractor;

architecture beh of fp_subtractor is 
  
  constant EXP_SIZE_T: natural:= 7;  
  constant WORD_SIZE_T: natural:= 25;
  
  component fp_adder
   generic(
    FP_EXP: integer:= EXP_SIZE_T;
    FP_LEN: integer:= WORD_SIZE_T
  );

  port(
    clk: in std_logic;
    rst: in std_logic;
    
    a_in: in std_logic_vector(FP_LEN-1 downto 0);
    b_in: in std_logic_vector(FP_LEN-1 downto 0);
    
    s_out: out std_logic_vector(( FP_LEN -1) downto 0)
  );
  end component;
  
  -- Signals definition
  -- Block adder output
  signal operand_a: std_logic_vector(WORD_SIZE_T-1 downto 0);
  signal operand_b: std_logic_vector(WORD_SIZE_T-1 downto 0);
     
begin

  -- Toggle sign of second operand
  operand_a <= a_in;
  operand_b <= '1' & b_in(WORD_SIZE_T-2 downto 0)
    when b_in(WORD_SIZE_T-1) = '0'
    else '0' & b_in(WORD_SIZE_T-2 downto 0);

  fp_adder_instance:fp_adder
  port map(
    -- IN
    clk => clk,
    rst => rst,

    a_in => operand_a,
    b_in => operand_b,

    -- OUT
    s_out => s_out
  );  

end beh;