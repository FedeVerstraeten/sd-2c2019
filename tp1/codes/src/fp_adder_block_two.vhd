library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_block_two is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );

  port(
    sign_a: in std_logic;
    sign_b: in std_logic;
    exponent_a: in unsigned(FP_EXP-1 downto 0);
    exponent_b: in unsigned(FP_EXP-1 downto 0);
    significand_a: in unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
    significand_b: in unsigned( ( FP_LEN - (FP_EXP+1) ) downto 0);
    
    significand_a_plus_b_with_carry: out unsigned ( (FP_LEN-(FP_EXP+1) + 1) downto 0);
    flag_r: out std_logic;
    flag_g: out std_logic;
    flag_s: out std_logic
  );
  
end fp_adder_block_two;

architecture beh of fp_adder_block_two is

  signal exponent_shift: unsigned(FP_EXP-1 downto 0);
  signal p_reg: unsigned((FP_LEN-(FP_EXP+1)) downto 0);
  
begin

  exponent_shift <= (exponent_a - exponent_b);

  -- if sign_a != sign_b, then shift_right (exp_a - exp_b) bits with '1'
  -- else shift_right (exp_a - exp_b) bits  with '0' 
  p_reg((FP_LEN-(FP_EXP+1)) downto ((FP_LEN-(FP_EXP+1)) - to_integer(exponent_shift)+ 1)) <= ( others=> '1') 
    when (sign_a xor sign_b) = '1' 
    else ( others=> '0'); 
  
  -- Append significand_b to the remaining bits of the p-register
  p_reg((FP_LEN-(FP_EXP+1))-to_integer(exponent_shift) downto 0) <= significand_b((FP_LEN-(FP_EXP+1)) downto to_integer(exponent_shift));
  
  -- bits shifted out of the p-register
  flag_g <= significand_b(to_integer(exponent_shift)-1)
    when (to_integer(exponent_shift)-1)>0 else '0';
  flag_r <= significand_b(to_integer(exponent_shift)-2)
    when (to_integer(exponent_shift)-2)>0 else '0';
  flag_s <= '0';
  --flag_s <= '0' when (significand_b(to_integer(exponent_shift)-3 downto 0) = (significand_b(to_integer(exponent_shift)-3 downto 0)'range => '0')) 
  --  else '1';
  
  -- significand_a + significand_b with carry
  significand_a_plus_b_with_carry <= (unsigned('0' & significand_a) + unsigned('0' & p_reg));
end beh;
