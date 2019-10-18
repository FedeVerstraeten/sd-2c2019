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
    exponent_a_d4: in unsigned(FP_EXP-1 downto 0);
    flag_r_d4: in std_logic;
    flag_g_d4: in std_logic;
    flag_s_d4: in std_logic;
    significand_s_d4: in unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    flag_swap_d4: in std_logic;
    carry_out_d4: in std_logic;
    flag_s_twos_comp_d4: in std_logic;
    index_d4: in unsigned(4 downto 0);
    
    sign_a_q4: out std_logic;
    sign_b_q4: out std_logic;
    exponent_a_q4: out unsigned(FP_EXP-1 downto 0);
    flag_r_q4: out std_logic;
    flag_g_q4: out std_logic;
    flag_s_q4: out std_logic;
    significand_s_q4: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    flag_swap_q4: out std_logic;
    carry_out_q4: out std_logic;
    flag_s_twos_comp_q4: out std_logic;
    index_q4: out unsigned(4 downto 0)
  );
end fp_adder_pipe_four;

architecture beh of fp_adder_pipe_four is
begin
  pipeline_step_four: process(clk,rst)
  begin
    if(rst='1') then
      sign_a_q4 <= '0';
      sign_b_q4 <= '0'; 
      exponent_a_q4 <= (others => '0');
      flag_r_q4 <= '0';
      flag_g_q4 <= '0';
      flag_s_q4 <= '0';
      significand_s_q4 <= (others => '0');
      flag_swap_q4 <= '0';
      carry_out_q4 <= '0';
      flag_s_twos_comp_q4 <= '0';
      index_q4 <= (others => '0');
    elsif(rising_edge(clk)) then
      sign_a_q4 <= sign_a_d4;
      sign_b_q4 <= sign_b_d4; 
      exponent_a_q4 <= exponent_a_d4;
      flag_r_q4 <= flag_r_d4;
      flag_g_q4 <= flag_g_d4;
      flag_s_q4 <= flag_s_d4;
      significand_s_q4 <= significand_s_d4;
      flag_swap_q4 <= flag_swap_d4;
      carry_out_q4 <= carry_out_d4;
      flag_s_twos_comp_q4 <= flag_s_twos_comp_d4;
      index_q4 <= index_d4;
    end if; 
  end process;
end beh;
