----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP1 - Aritmetica de punto flotante
----------------------------------------------------------------------------------
-- Filename: fp_adder.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    Floating Point Adder
-- Module Name:    FP Adder
-- @Copyright (C):
--    This file is part of 'TP1 - Aritmetica de punto flotante'.
--    Unauthorized copying or use of this file via any medium
--    is strictly prohibited.
----------------------------------------------------------------------------------
-- Description: 
-- Implementation to add two floating point numbers IEEE-754
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

entity fp_adder is
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
    
    s_out: out std_logic_vector( ( FP_LEN -1) downto 0)
  );
end fp_adder;

architecture beh of fp_adder is 
  
  constant EXP_SIZE_T: natural:= 7;  
  constant WORD_SIZE_T: natural:= 25;
  
  component fp_adder_block_one
    generic(
      FP_EXP: integer:= EXP_SIZE_T;
      FP_LEN: integer:= WORD_SIZE_T
    );
    port(
      -- Port in
      a_in: in std_logic_vector(FP_LEN-1 downto 0);
      b_in: in std_logic_vector(FP_LEN-1 downto 0);

      -- Port out
      sign_a: out std_logic;
      sign_b: out std_logic;
      exponent_a: out unsigned(FP_EXP-1 downto 0);
      exponent_b: out unsigned(FP_EXP-1 downto 0);
      significand_a: out unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
      significand_b: out unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
      flag_swap: out std_logic
    );
  end component;
  
  component fp_adder_pipe_one
    generic(
      FP_EXP: integer:= EXP_SIZE_T;
      FP_LEN: integer:= WORD_SIZE_T
    );
    port(
      clk: in std_logic;
      rst: in std_logic;
    
      -- Port in
      sign_a_d1: in std_logic;
      sign_b_d1: in std_logic;
      exponent_a_d1: in unsigned(FP_EXP-1 downto 0);
      exponent_b_d1: in unsigned(FP_EXP-1 downto 0);
      significand_a_d1: in unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
      significand_b_d1: in unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
      flag_swap_d1: in std_logic;
    
      -- Port out
      sign_a_q1: out std_logic;
      sign_b_q1: out std_logic;
      exponent_a_q1: out unsigned(FP_EXP-1 downto 0);
      exponent_b_q1: out unsigned(FP_EXP-1 downto 0);
      significand_a_q1: out unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
      significand_b_q1: out unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
      flag_swap_q1: out std_logic
    );
  end component;
  
  component fp_adder_block_two
    generic(
      FP_EXP: integer:= EXP_SIZE_T;
      FP_LEN: integer:= WORD_SIZE_T
    );
    port(
      -- Port in
      sign_a: in std_logic;
      sign_b: in std_logic;   
      exponent_a: in unsigned(FP_EXP-1 downto 0);
      exponent_b: in unsigned(FP_EXP-1 downto 0);
      significand_a: in unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
      significand_b: in unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
    
      -- Port out
      significand_a_plus_b_with_carry: out unsigned ( (FP_LEN-(FP_EXP+1) + 1) downto 0);
      flag_r: out std_logic;
      flag_g: out std_logic;
      flag_s: out std_logic
    );
  end component;
  
  component fp_adder_pipe_two
  
    generic(
      FP_EXP: integer:= EXP_SIZE_T;
      FP_LEN: integer:= WORD_SIZE_T
    );

    port(
      clk: in std_logic;
      rst: in std_logic;
    
      -- Port in
      sign_a_d2: in std_logic;
      sign_b_d2: in std_logic;
      exponent_a_d2: in unsigned(FP_EXP-1 downto 0);
      significand_a_plus_b_with_carry_d2: in unsigned ( (FP_LEN-(FP_EXP+1) + 1) downto 0);
      flag_r_d2: in std_logic;
      flag_g_d2: in std_logic;
      flag_s_d2: in std_logic;
      flag_swap_d2: in std_logic;
    
      -- Port out
      sign_a_q2: out std_logic;
      sign_b_q2: out std_logic;   
      exponent_a_q2: out unsigned(FP_EXP-1 downto 0);
      significand_a_plus_b_with_carry_q2: out unsigned ( (FP_LEN-(FP_EXP+1) + 1) downto 0);
      flag_r_q2: out std_logic;
      flag_g_q2: out std_logic;
      flag_s_q2: out std_logic;
      flag_swap_q2: out std_logic
    );
  end component;
  
  component fp_adder_block_three
  
    generic(
      FP_EXP: integer:= EXP_SIZE_T;
      FP_LEN: integer:= WORD_SIZE_T
    );
  
    port(
      -- Port in
      sign_a: in std_logic;
      sign_b: in std_logic;
      significand_a_plus_b_with_carry: in unsigned ( (FP_LEN-(FP_EXP+1) + 1) downto 0);

      -- Port out
      significand_s: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
      carry_out: out std_logic;
      flag_s_twos_comp: out std_logic
    );
  end component;
  
  component fp_adder_pipe_three
    generic(
      FP_EXP: integer:= EXP_SIZE_T;
      FP_LEN: integer:= WORD_SIZE_T
    );
    port(
      clk: in std_logic;
      rst: in std_logic;
    
      -- Port in
      sign_a_d3: in std_logic;
      sign_b_d3: in std_logic;
      exponent_a_d3: in unsigned(FP_EXP-1 downto 0);
      flag_r_d3: in std_logic;
      flag_g_d3: in std_logic;
      flag_s_d3: in std_logic;
      significand_s_d3: in unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
      flag_swap_d3: in std_logic;
      carry_out_d3: in std_logic;
      flag_s_twos_comp_d3: in std_logic;

      -- Port out
      sign_a_q3: out std_logic;
      sign_b_q3: out std_logic;
      exponent_a_q3: out unsigned(FP_EXP-1 downto 0);
      flag_r_q3: out std_logic;
      flag_g_q3: out std_logic;
      flag_s_q3: out std_logic;
      significand_s_q3: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
      flag_swap_q3: out std_logic;
      carry_out_q3: out std_logic;
      flag_s_twos_comp_q3: out std_logic    
    );
  end component;
  
  component fp_adder_block_four
    generic(
      FP_EXP: integer:= EXP_SIZE_T;
      FP_LEN: integer:= WORD_SIZE_T
    );
    port(
      -- Port in
      sign_a: in std_logic;
      sign_b: in std_logic;
      exponent_a: in unsigned(FP_EXP-1 downto 0);
      significand_s: in unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
      carry_out: in std_logic;
      flag_r: in std_logic;
      flag_g: in std_logic;
      flag_s: in std_logic;

      -- Port out
      significand_s_normalized: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
      exponent_a_plus_b: out unsigned(FP_EXP-1 downto 0);
      flag_r_add: out std_logic;
      flag_s_add: out std_logic
    );
  end component;
  
  component fp_adder_pipe_four
    generic(
      FP_EXP: integer:= EXP_SIZE_T;
      FP_LEN: integer:= WORD_SIZE_T
    );
    port(
      clk: in std_logic;
      rst: in std_logic;
    
      -- Port in
      sign_a_d4: in std_logic;
      sign_b_d4: in std_logic;
      flag_swap_d4: in std_logic;
      flag_s_twos_comp_d4: in std_logic;
      significand_s_normalized_d4: in unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
      exponent_a_plus_b_d4: in unsigned(FP_EXP-1 downto 0);
      flag_r_add_d4: in std_logic;
      flag_s_add_d4: in std_logic;
    
      -- Port out
      sign_a_q4: out std_logic;
      sign_b_q4: out std_logic;
      flag_swap_q4: out std_logic;
      flag_s_twos_comp_q4: out std_logic;
      significand_s_normalized_q4: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
      exponent_a_plus_b_q4: out unsigned(FP_EXP-1 downto 0);
      flag_r_add_q4: out std_logic;
      flag_s_add_q4: out std_logic
    );
  
  end component;
  
  component fp_adder_block_five
    generic(
      FP_EXP: integer:= EXP_SIZE_T;
      FP_LEN: integer:= WORD_SIZE_T
    );
    port(
      -- Port in
      sign_a: in std_logic;
      sign_b: in std_logic;
      flag_swap: in std_logic;
      flag_s_twos_comp: in std_logic;
      flag_r_add: in std_logic;
      flag_s_add: in std_logic;
      significand_s_normalized: in unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
      exponent_a_plus_b: in unsigned(FP_EXP-1 downto 0);
    
      -- Port out
      s_out: out std_logic_vector( ( FP_LEN -1) downto 0)
    );
  end component;
  
  -- Signals definition
  -- Block one output
  signal sign_a: std_logic;
  signal sign_b: std_logic;
  signal exponent_a: unsigned(FP_EXP-1 downto 0);
  signal exponent_b: unsigned(FP_EXP-1 downto 0);
  signal significand_a: unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
  signal significand_b: unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
  signal flag_swap: std_logic;
  
  -- Pipe one output
  signal sign_a_q1: std_logic;
  signal sign_b_q1: std_logic;
  signal exponent_a_q1: unsigned(FP_EXP-1 downto 0);
  signal exponent_b_q1: unsigned(FP_EXP-1 downto 0);
  signal significand_a_q1: unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
  signal significand_b_q1: unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
  signal flag_swap_q1: std_logic;
  
  -- Block two output
  signal significand_a_plus_b_with_carry: unsigned ( (FP_LEN-(FP_EXP+1) + 1) downto 0);
  signal flag_r: std_logic;
  signal flag_g: std_logic;
  signal flag_s: std_logic;
  
  -- Pipe two output
  signal sign_a_q2: std_logic;
  signal sign_b_q2: std_logic;    
  signal exponent_a_q2: unsigned(FP_EXP-1 downto 0);
  signal significand_a_plus_b_with_carry_q2: unsigned( (FP_LEN-(FP_EXP+1) + 1) downto 0);
  signal flag_r_q2: std_logic;
  signal flag_g_q2: std_logic;
  signal flag_s_q2: std_logic;
  signal flag_swap_q2: std_logic;
  
  -- Block three output
  signal significand_s: unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
  signal carry_out: std_logic;
  signal flag_s_twos_comp: std_logic;

  -- Pipe three output
  signal sign_a_q3: std_logic;
  signal sign_b_q3: std_logic;
  signal exponent_a_q3: unsigned(FP_EXP-1 downto 0);
  signal flag_r_q3: std_logic;
  signal flag_g_q3: std_logic;
  signal flag_s_q3: std_logic;
  signal significand_s_q3: unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
  signal flag_swap_q3: std_logic;
  signal carry_out_q3: std_logic;
  signal flag_s_twos_comp_q3: std_logic;
  
  -- Block four output
  signal significand_s_normalized: unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
  signal exponent_a_plus_b: unsigned(FP_EXP-1 downto 0);
  signal flag_r_add: std_logic;
  signal flag_s_add: std_logic;
  
  -- Pipe four output
  signal sign_a_q4: std_logic;
  signal sign_b_q4: std_logic;
  signal flag_swap_q4: std_logic;
  signal flag_s_twos_comp_q4: std_logic;
  signal flag_r_add_q4: std_logic;
  signal flag_s_add_q4: std_logic;
  signal significand_s_normalized_q4: unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
  signal exponent_a_plus_b_q4: unsigned(FP_EXP-1 downto 0);
    
begin

  fp_adder_block_1: fp_adder_block_one
  port map(
    -- IN
    -- input fp_adder
    a_in => a_in,
    b_in => b_in,

    -- OUT
    sign_a => sign_a,
    sign_b => sign_b,
    exponent_a => exponent_a,
    exponent_b => exponent_b,
    significand_a => significand_a,
    significand_b => significand_b,
    flag_swap => flag_swap
  );  

  fp_adder_pipe_1: fp_adder_pipe_one  
  port map(
    -- IN
    clk => clk,
    rst => rst,
    -- signals from block_one
    sign_a_d1 => sign_a,
    sign_b_d1 => sign_b,
    exponent_a_d1 => exponent_a,
    exponent_b_d1 => exponent_b,
    significand_a_d1 => significand_a,
    significand_b_d1 => significand_b,
    flag_swap_d1 => flag_swap,

    -- OUT
    sign_a_q1 => sign_a_q1,
    sign_b_q1 => sign_b_q1,
    exponent_a_q1 => exponent_a_q1,
    exponent_b_q1 => exponent_b_q1,
    significand_a_q1 => significand_a_q1,
    significand_b_q1 => significand_b_q1,
    flag_swap_q1 => flag_swap_q1
  );  
  
  fp_adder_block_2: fp_adder_block_two
  port map(
    -- IN
    -- signals from pipe_one
    sign_a => sign_a_q1,
    sign_b => sign_b_q1,
    exponent_a => exponent_a_q1,
    exponent_b => exponent_b_q1,
    significand_a => significand_a_q1,
    significand_b => significand_b_q1,
    
    -- OUT
    significand_a_plus_b_with_carry => significand_a_plus_b_with_carry,
    flag_r => flag_r,
    flag_g => flag_g,
    flag_s => flag_s
  );

  fp_adder_pipe_2: fp_adder_pipe_two
  port map(
    -- IN
    clk => clk,
    rst => rst,
    -- signals from pipe_one
    sign_a_d2 => sign_a_q1,
    sign_b_d2 => sign_b_q1,
    exponent_a_d2 => exponent_a_q1,
    flag_swap_d2 => flag_swap_q1,

    -- signals from block_two
    significand_a_plus_b_with_carry_d2 => significand_a_plus_b_with_carry,
    flag_r_d2 => flag_r,
    flag_g_d2 => flag_g,
    flag_s_d2 => flag_s,
  
    -- OUT
    sign_a_q2 => sign_a_q2,
    sign_b_q2 => sign_b_q2,   
    exponent_a_q2 => exponent_a_q2,
    significand_a_plus_b_with_carry_q2 => significand_a_plus_b_with_carry_q2,
    flag_r_q2 => flag_r_q2,
    flag_g_q2 => flag_g_q2,
    flag_s_q2 => flag_s_q2,
    flag_swap_q2 => flag_swap_q2
  );
  
  fp_adder_block_3: fp_adder_block_three
  port map(
    -- IN
    -- signals from pipe_two
    sign_a => sign_a_q2,
    sign_b => sign_b_q2,
    significand_a_plus_b_with_carry => significand_a_plus_b_with_carry_q2,
  
    -- OUT
    significand_s => significand_s,
    carry_out => carry_out,
    flag_s_twos_comp => flag_s_twos_comp
  );
    
  fp_adder_pipe_3: fp_adder_pipe_three
  port map(
    -- IN
    clk => clk,
    rst => rst,

    -- signals from pipe_two
    sign_a_d3 => sign_a_q2,
    sign_b_d3 => sign_b_q2,
    exponent_a_d3 => exponent_a_q2,
    flag_r_d3 => flag_r_q2,
    flag_g_d3 => flag_g_q2,
    flag_s_d3 => flag_s_q2,
    flag_swap_d3 => flag_swap_q2,

    -- signals from block_three
    significand_s_d3 => significand_s,
    carry_out_d3 => carry_out,
    flag_s_twos_comp_d3 => flag_s_twos_comp,
  
    -- OUT
    sign_a_q3 => sign_a_q3,
    sign_b_q3 => sign_b_q3,
    exponent_a_q3 => exponent_a_q3,
    flag_r_q3 => flag_r_q3,
    flag_g_q3 => flag_g_q3,
    flag_s_q3 => flag_s_q3,
    flag_swap_q3 => flag_swap_q3,
    significand_s_q3 => significand_s_q3,
    carry_out_q3 => carry_out_q3,
    flag_s_twos_comp_q3 => flag_s_twos_comp_q3
  );
  
  fp_adder_block_4 : fp_adder_block_four
  port map(
    -- IN
    -- signals from pipe_three
    sign_a => sign_a_q3,
    sign_b => sign_b_q3,
    exponent_a => exponent_a_q3,
    significand_s => significand_s_q3,
    carry_out => carry_out_q3,
    flag_r => flag_r_q3,
    flag_g => flag_g_q3,
    flag_s => flag_s_q3,
  
    -- OUT
    significand_s_normalized => significand_s_normalized,
    exponent_a_plus_b => exponent_a_plus_b,
    flag_r_add => flag_r_add,
    flag_s_add => flag_s_add
  );
  
  fp_adder_pipe_4 : fp_adder_pipe_four 
  port map(
    -- IN
    clk => clk,
    rst => rst,
    -- signals from pipe_three
    sign_a_d4 => sign_a_q3,
    sign_b_d4 => sign_b_q3,
    flag_swap_d4 => flag_swap_q3,
    flag_s_twos_comp_d4 => flag_s_twos_comp_q3,

    -- signals from block_four
    significand_s_normalized_d4 => significand_s_normalized,
    exponent_a_plus_b_d4 => exponent_a_plus_b,
    flag_r_add_d4 => flag_r_add,
    flag_s_add_d4 => flag_s_add,
    
    -- OUT
    sign_a_q4 => sign_a_q4,
    sign_b_q4 => sign_b_q4,
    flag_swap_q4 => flag_swap_q4,
    flag_s_twos_comp_q4 => flag_s_twos_comp_q4,
    significand_s_normalized_q4 => significand_s_normalized_q4,
    exponent_a_plus_b_q4 => exponent_a_plus_b_q4,
    flag_r_add_q4 => flag_r_add_q4,
    flag_s_add_q4 => flag_s_add_q4
  );
  
  fp_adder_block_5 : fp_adder_block_five
  port map(
    -- IN
    -- signals from pipe_four
    sign_a => sign_a_q4,
    sign_b => sign_b_q4,
    flag_swap => flag_swap_q4,
    flag_s_twos_comp => flag_s_twos_comp_q4,
    significand_s_normalized => significand_s_normalized_q4,
    exponent_a_plus_b => exponent_a_plus_b_q4,
    flag_r_add => flag_r_add_q4,
    flag_s_add => flag_s_add_q4,

    -- OUT  
    s_out => s_out
  );
  
end beh;