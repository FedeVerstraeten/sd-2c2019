library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_pipe_three is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );
  
  port(
    clk: in std_logic;
    rst: in std_logic;
    
    sign_a_d3: in std_logic;
    sign_b_d3: in std_logic;
    exponent_a_d3: in unsigned(FP_EXP-1 downto 0);
    flag_r_d3: in std_logic;
    flag_g_d3: in std_logic;
    flag_s_d3: in std_logic;
    flag_swap_d3: in std_logic;
    significand_s_d3: in unsigned((FP_LEN - (FP_EXP+1)) downto 0);
    carry_out_d3: in std_logic;
    flag_s_twos_comp_d3: in std_logic;
    
    sign_a_q3: out std_logic;
    sign_b_q3: out std_logic;
    exponent_a_q3: out unsigned(FP_EXP-1 downto 0);
    flag_r_q3: out std_logic;
    flag_g_q3: out std_logic;
    flag_s_q3: out std_logic;
    flag_swap_q3: out std_logic;
    significand_s_q3: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    carry_out_q3: out std_logic;
    flag_s_twos_comp_q3: out std_logic
  );
end fp_adder_pipe_three;

architecture beh of fp_adder_pipe_three is
begin
  pipeline_step_three: process(clk,rst)
  begin
    if(rst='1') then
      sign_a_q3 <= '0';
      sign_b_q3 <= '0'; 
      exponent_a_q3 <= (others => '0');
      flag_r_q3 <= '0';
      flag_g_q3 <= '0';
      flag_s_q3 <= '0';
      flag_swap_q3 <= '0';
      significand_s_q3 <= (others => '0');
      carry_out_q3 <= '0';
      flag_s_twos_comp_q3 <= '0';
    elsif(rising_edge(clk)) then
      sign_a_q3 <= sign_a_d3;
      sign_b_q3 <= sign_b_d3; 
      exponent_a_q3 <= exponent_a_d3;
      flag_r_q3 <= flag_r_d3;
      flag_g_q3 <= flag_g_d3;
      flag_s_q3 <= flag_s_d3;
      flag_swap_q3 <= flag_swap_d3;
      significand_s_q3 <= significand_s_d3;
      carry_out_q3 <= carry_out_d3;
      flag_s_twos_comp_q3 <= flag_s_twos_comp_d3;
    end if; 
  end process;
end beh;
