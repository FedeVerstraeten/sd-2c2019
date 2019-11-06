library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_pipe_four is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );
  
  port(
    clk: in std_logic;
    rst: in std_logic;
    
    sign_a_d4: in std_logic;
    sign_b_d4: in std_logic;
    flag_swap_d4: in std_logic;
    flag_s_twos_comp_d4: in std_logic;
    
    significand_s_normalized_d4: in unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    exponent_a_plus_b_d4: in unsigned(FP_EXP-1 downto 0);
    flag_r_add_d4: in std_logic;
    flag_s_add_d4: in std_logic;
    flag_infinite_d4: in std_logic;
    flag_overflow_d4: in std_logic;
    flag_underflow_d4: in std_logic;
    flag_zero_significand_d4: in std_logic;

    sign_a_q4: out std_logic;
    sign_b_q4: out std_logic;
    flag_swap_q4: out std_logic;
    flag_s_twos_comp_q4: out std_logic;
    significand_s_normalized_q4: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    exponent_a_plus_b_q4: out unsigned(FP_EXP-1 downto 0);
    flag_r_add_q4: out std_logic;
    flag_s_add_q4: out std_logic;
    flag_infinite_q4: out std_logic;
    flag_overflow_q4: out std_logic;
    flag_underflow_q4: out std_logic;
    flag_zero_significand_q4: out std_logic
  );
  
end fp_adder_pipe_four;

architecture beh of fp_adder_pipe_four is
begin
  pipeline_step_four: process(clk,rst)
  begin
    if(rst='1') then
      sign_a_q4 <= '0';
      sign_b_q4 <= '0'; 
      flag_swap_q4 <= '0';
      flag_s_twos_comp_q4 <= '0';
      flag_r_add_q4 <= '0';
      flag_s_add_q4 <= '0';
      significand_s_normalized_q4 <= (others => '0');
      exponent_a_plus_b_q4 <= (others => '0');
      flag_infinite_q4 <= '0';
      flag_overflow_q4 <= '0';
      flag_underflow_q4 <= '0';
      flag_zero_significand_q4 <= '0';
    elsif(falling_edge(clk)) then
      sign_a_q4 <= sign_a_d4;
      sign_b_q4 <= sign_b_d4; 
      flag_swap_q4 <= flag_swap_d4;
      flag_s_twos_comp_q4 <= flag_s_twos_comp_d4;
      flag_r_add_q4 <= flag_r_add_d4;
      flag_s_add_q4 <= flag_s_add_d4;
      significand_s_normalized_q4 <= significand_s_normalized_d4;
      exponent_a_plus_b_q4 <= exponent_a_plus_b_d4;
      flag_infinite_q4 <= flag_infinite_d4;
      flag_overflow_q4 <= flag_overflow_d4;
      flag_underflow_q4 <= flag_underflow_d4;
      flag_zero_significand_q4 <= flag_zero_significand_d4;
    end if; 
  end process;
end beh;
