library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_block_one is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );

  port(
    a_in: in std_logic_vector(FP_LEN-1 downto 0);
    b_in: in std_logic_vector(FP_LEN-1 downto 0);
    sign_a: out std_logic;
    sign_b: out std_logic;
    exponent_a: out unsigned(FP_EXP-1 downto 0);
    exponent_b: out unsigned(FP_EXP-1 downto 0);
    significand_a: out unsigned((FP_LEN-(FP_EXP+1)) downto 0);
    significand_b: out unsigned((FP_LEN-(FP_EXP+1)) downto 0);
    flag_swap: out std_logic
  );
  
end fp_adder_block_one;

architecture beh of fp_adder_block_one is

  signal b_aux: std_logic_vector((FP_LEN-(FP_EXP+1)) downto 0);
  
begin
  -- Sign
  sign_a <= a_in(FP_LEN-1);
  sign_b <= b_in(FP_LEN-1);
  
  --If exp_a < exp_b then swap operands 
  flag_swap <= '1' 
  when ( unsigned(a_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) < unsigned(b_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) ) 
  else '0';
  
  -- exp_a <= exp_b
  exponent_a <= unsigned(b_in( (FP_LEN-1) - 1 downto (FP_LEN-FP_EXP) - 1)) 
    when ( unsigned(a_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) < unsigned(b_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) )
    else unsigned(a_in( (FP_LEN-1) - 1 downto (FP_LEN-FP_EXP) - 1));
  
  -- exp_b <= exp_a
  exponent_b <= unsigned(a_in( (FP_LEN-1) - 1 downto (FP_LEN-FP_EXP) - 1))
    when ( unsigned(a_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) < unsigned(b_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) )
    else unsigned(b_in( (FP_LEN-1) - 1 downto (FP_LEN-FP_EXP) - 1));
  
  -- If exp_a < exp_b then
  -- significand_a <= 1,mantissa_b
  -- else significand_a <= 1,mantissa_a
  significand_a <= unsigned('1' & b_in( (FP_LEN - (FP_EXP+1)) - 1 downto 0))
    when ( unsigned(a_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) < unsigned(b_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) )
    else unsigned('1' & a_in( (FP_LEN - (FP_EXP+1)) - 1 downto 0));
  
  -- b_aux <= 1,mantissa_a
  b_aux <= ( '1' & a_in( (FP_LEN - (FP_EXP+1)) - 1 downto 0) )
    when ( unsigned(a_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) < unsigned(b_in((FP_LEN-1)-1 downto (FP_LEN-FP_EXP)-1)) )
    else ( '1' & b_in( (FP_LEN - (FP_EXP+1)) - 1 downto 0) );
  
  -- if sign_a != sing_b then complement2(b)
  significand_b <= ( unsigned(not b_aux) + to_unsigned(1, FP_LEN-(FP_EXP+1) ) ) 
    when (a_in(FP_LEN-1) xor b_in(FP_LEN-1)) = '1'
    else unsigned(b_aux) when (a_in(FP_LEN-1) xor b_in(FP_LEN-1)) = '0';

end beh;
