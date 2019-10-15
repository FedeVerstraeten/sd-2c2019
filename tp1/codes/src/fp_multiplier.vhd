----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP1 - Aritmetica de punto flotante
----------------------------------------------------------------------------------
-- Filename: fp_multiplier.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    Floating Point Multiplier
-- Module Name:    FP Multiplier
-- @Copyright (C):
--    This file is part of 'TP1 - Aritmetica de punto flotante'.
--    Unauthorized copying or use of this file via any medium
--    is strictly prohibited.
----------------------------------------------------------------------------------
-- Description: 
-- Implementation to multiply floating point numbers IEEE-754
-- Using combinational circuits
-- Clock(clk) and Reset(rst) input signal is not necessary
--
-- 32|    31|30          23|22                    0|
--   | sign |   exponent   |      significand      |
--
-- Part         | # bits
-- -----------------------
-- sign         |    1
-- exponent     |    8
-- significand  |   23
-- TOTAL        |   32 
----------------------------------------------------------------------------------
-- Dependencies:
-- 
----------------------------------------------------------------------------------
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; -- definicion de tipos
use IEEE.numeric_std.all;

entity fp_multiplier is
  
  generic(
    FP_EXP: integer:= 7;
    FP_LEN: integer:= 25
  );

  port(
    a_in: in std_logic_vector(FP_LEN-1 downto 0);
    b_in: in std_logic_vector(FP_LEN-1 downto 0);
    s_out: out std_logic_vector(FP_LEN-1 downto 0)
  );
  
end fp_multiplier;

architecture beh of fp_multiplier is

  signal sign_a: std_logic;
  signal sign_b: std_logic;
  signal sign_res: std_logic := '0';
  
  
begin

  -- Sign calculation
  sign_res <= a_in(FP_LEN-1) xor b_in(FP_LEN-1);

  multiply: process(a_in,b_in)
    variable significand_a: unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0) := (others => '0');
    variable significand_b: unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0) := (others => '0');
    variable significand_a_times_b_2F_plus_2_length: unsigned( (2*(FP_LEN-FP_EXP))-1 downto 0) := (others => '0');
    variable significand_a_times_b: unsigned ( (FP_LEN-(FP_EXP+1)) - 1 downto 0) := (others => '0');
    
    variable exponent_a: unsigned(FP_EXP-1 downto 0);
    variable exponent_b: unsigned(FP_EXP-1 downto 0);
    variable exp_res: unsigned (FP_EXP-1 downto 0);
    
    variable exp_bias: integer := (2**(FP_EXP-1)) - 1;
    variable exp_increase: integer := 0;
  
    begin    
      -- Significan/Mantissa calculation      
      significand_a := unsigned('1' & a_in( (FP_LEN - (FP_EXP+1)) - 1 downto 0));
      significand_b := unsigned('1' & b_in( (FP_LEN - (FP_EXP+1)) - 1 downto 0));
      
      significand_a_times_b_2F_plus_2_length :=  significand_a * significand_b;
      
      -- if the MSB is equal to 1
      if (significand_a_times_b_2F_plus_2_length(2*(FP_LEN-FP_EXP)-1) = '1' ) then
        exp_increase := 1;
        significand_a_times_b :=  significand_a_times_b_2F_plus_2_length( (2*(FP_LEN-FP_EXP))-2 downto (FP_LEN-FP_EXP));
      else
        exp_increase := 0 ;
        significand_a_times_b :=  significand_a_times_b_2F_plus_2_length( (2*(FP_LEN-FP_EXP)) - 2 downto (FP_LEN-FP_EXP));
      end if;
      
      -- Exponent calculation
      exponent_a :=  ( unsigned(a_in( (FP_LEN-1) - 1 downto (FP_LEN-FP_EXP) - 1)) - to_unsigned(exp_bias,FP_EXP) );
      exponent_b :=  ( unsigned(b_in( (FP_LEN-1) - 1 downto (FP_LEN-FP_EXP) - 1)) - to_unsigned(exp_bias,FP_EXP) );
      exp_res := (exponent_a + exponent_b + to_unsigned(exp_bias,FP_EXP) + to_unsigned(exp_increase,FP_EXP));  
      
      -- Carga exponente y mantisa
      s_out(FP_LEN-2 downto 0) <=  std_logic_vector(exp_res) & std_logic_vector(significand_a_times_b);  
  end process;

  s_out(FP_LEN-1) <= sign_res;
end beh;