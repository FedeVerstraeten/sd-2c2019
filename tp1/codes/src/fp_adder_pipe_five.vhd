library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_pipe_five is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );
  
  port(
    clk: in std_logic;
    rst: in std_logic;
    
    sign_a_d5: in std_logic;
    sign_b_d5: in std_logic;
    flag_swap_d5: in std_logic;
    flag_s_twos_comp_d5: in std_logic;
    flag_r_add_d5: in std_logic;
    flag_s_add_d5: in std_logic;
    significand_s_normalized_d5: in unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    exponent_a_plus_b_d5: in unsigned(FP_EXP-1 downto 0);
    
    sign_a_q5: out std_logic;
    sign_b_q5: out std_logic;
    flag_swap_q5: out std_logic;
    flag_s_twos_comp_q5: out std_logic;
    flag_r_add_q5: out std_logic;
    flag_s_add_q5: out std_logic;
    significand_s_normalized_q5: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    exponent_a_plus_b_q5: out unsigned(FP_EXP-1 downto 0)
  );
  
end fp_adder_pipe_five;

architecture beh of fp_adder_pipe_five is
begin
  pipeline_step_five: process(clk,rst)
  begin
    if(rst='1') then
      sign_a_q5 <= '0';
      sign_b_q5 <= '0'; 
      flag_swap_q5 <= '0';
      flag_s_twos_comp_q5 <= '0';
      flag_r_add_q5 <= '0';
      flag_s_add_q5 <= '0';
      significand_s_normalized_q5 <= (others => '0');
      exponent_a_plus_b_q5 <= (others => '0');
    elsif(rising_edge(clk)) then
      sign_a_q5 <= sign_a_d5;
      sign_b_q5 <= sign_b_d5; 
      flag_swap_q5 <= flag_swap_d5;
      flag_s_twos_comp_q5 <= flag_s_twos_comp_d5;
      flag_r_add_q5 <= flag_r_add_d5;
      flag_s_add_q5 <= flag_s_add_d5;
      significand_s_normalized_q5 <= significand_s_normalized_d5;
      exponent_a_plus_b_q5 <= exponent_a_plus_b_d5;
    end if; 
  end process;
end beh;
