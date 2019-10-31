library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_pipe_one is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );

  port(
    clk: in std_logic;
    rst: in std_logic;
    
    sign_a_d1: in std_logic;
    sign_b_d1: in std_logic;
    exponent_a_d1: in unsigned(FP_EXP-1 downto 0);
    exponent_b_d1: in unsigned(FP_EXP-1 downto 0);
    significand_a_d1: in unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
    significand_b_d1: in unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
    flag_swap_d1: in std_logic;
    
    sign_a_q1: out std_logic;
    sign_b_q1: out std_logic;
    exponent_a_q1: out unsigned(FP_EXP-1 downto 0);
    exponent_b_q1: out unsigned(FP_EXP-1 downto 0);
    significand_a_q1: out unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
    significand_b_q1: out unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
    flag_swap_q1: out std_logic
    
  );
  
end fp_adder_pipe_one;

architecture beh of fp_adder_pipe_one is
begin
  pipeline_step_one: process(clk,rst)
  begin
    if(rst='1') then
      sign_a_q1 <= '0';
      sign_b_q1 <= '0'; 
      exponent_a_q1 <= (others=>'0');
      exponent_b_q1 <= (others=>'0');
      significand_a_q1 <= (others=>'0');
      significand_b_q1 <= (others=>'0');
      flag_swap_q1 <= '0';
    elsif(falling_edge(clk)) then
      sign_a_q1 <= sign_a_d1;
      sign_b_q1 <= sign_b_d1; 
      exponent_a_q1 <= exponent_a_d1;
      exponent_b_q1 <= exponent_b_d1;
      significand_a_q1 <= significand_a_d1;
      significand_b_q1 <= significand_b_d1;
      flag_swap_q1 <= flag_swap_d1;
    end if; 
  end process;
end beh;
