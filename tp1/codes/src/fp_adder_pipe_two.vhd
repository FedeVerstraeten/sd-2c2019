library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_pipe_two is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );

  port(
    clk: in std_logic;
    rst: in std_logic;
    
    sign_a_d2: in std_logic;
    sign_b_d2: in std_logic;
    exponent_a_d2: in unsigned(FP_EXP-1 downto 0);
    flag_swap_d2: in std_logic;
    flag_infinite_d2: in std_logic;
    
    significand_a_plus_b_with_carry_d2: in unsigned ( (FP_LEN-(FP_EXP+1) + 1) downto 0);
    flag_r_d2: in std_logic;
    flag_g_d2: in std_logic;
    flag_s_d2: in std_logic;
    
    sign_a_q2: out std_logic;
    sign_b_q2: out std_logic;   
    exponent_a_q2: out unsigned(FP_EXP-1 downto 0);
    significand_a_plus_b_with_carry_q2: out unsigned ( (FP_LEN-(FP_EXP+1) + 1) downto 0);
    flag_r_q2: out std_logic;
    flag_g_q2: out std_logic;
    flag_s_q2: out std_logic;
    flag_swap_q2: out std_logic;
    flag_infinite_q2: out std_logic
  );
  
end fp_adder_pipe_two;

architecture beh of fp_adder_pipe_two is
begin
  pipeline_step_two: process(clk,rst)
  begin
    if(rst='1') then
      sign_a_q2 <= '0';
      sign_b_q2 <= '0'; 
      exponent_a_q2 <= (others => '0');
      significand_a_plus_b_with_carry_q2 <= (others => '0');
      flag_r_q2 <= '0';
      flag_g_q2 <= '0';
      flag_s_q2 <= '0';
      flag_swap_q2 <= '0';
      flag_infinite_q2 <= '0';
    elsif(falling_edge(clk)) then
      sign_a_q2 <= sign_a_d2;
      sign_b_q2 <= sign_b_d2; 
      exponent_a_q2 <= exponent_a_d2;
      significand_a_plus_b_with_carry_q2 <= significand_a_plus_b_with_carry_d2;
      flag_r_q2 <= flag_r_d2;
      flag_g_q2 <= flag_g_d2;
      flag_s_q2 <= flag_s_d2;
      flag_swap_q2 <= flag_swap_d2;
      flag_infinite_q2 <= flag_infinite_d2;
    end if; 
  end process;
end beh;