library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_block_five is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );
  
  port(
    sign_a: in std_logic;
    sign_b: in std_logic;
    flag_swap: in std_logic;
    flag_s_twos_comp: in std_logic;
    flag_r_add: in std_logic;
    flag_s_add: in std_logic;
    significand_s_normalized: in unsigned(FP_LEN-(FP_EXP+1) downto 0);
    exponent_a_plus_b: in unsigned(FP_EXP-1 downto 0);
    flag_infinite: in std_logic;
    flag_overflow: in std_logic;
    flag_underflow: in std_logic;
    flag_zero_significand: in std_logic;

    s_out: out std_logic_vector( ( FP_LEN -1) downto 0)
  );
  
end fp_adder_block_five;

architecture beh of fp_adder_block_five is

  signal sign_s: std_logic;
  signal exponent_s: unsigned(FP_EXP-1 downto 0);
  signal significand_add_one_with_carry: unsigned (FP_LEN-FP_EXP downto 0);
  signal exponent_add_one: unsigned(FP_EXP-1 downto 0); 
  signal significand_s_normalized_rounded_aux: unsigned(FP_LEN-FP_EXP downto 0);
  signal significand_s_normalized_rounded: unsigned(FP_LEN-(FP_EXP+1) downto 0);
  signal mantissa_s: unsigned(FP_LEN-(FP_EXP+1)-1 downto 0);
  
begin
  exponent_add_one <= ( (exponent_add_one( (FP_EXP-2) downto 0 )'range =>'0' ) & '1' );
  
  -- SIGN
  -- According to the sign rule table
  sign_s <= sign_a when (sign_a = sign_b) else 
        sign_b when (( sign_a /= sign_b ) and flag_swap = '1') else
        sign_a when (( sign_a /= sign_b ) and flag_swap = '0' and flag_s_twos_comp = '0') else
        sign_b when (( sign_a /= sign_b ) and flag_swap = '0' and flag_s_twos_comp = '1') else
           '0' when flag_zero_significand = '1' else
           '0' when flag_underflow = '1';

  -- SIGNIFICAND
  significand_add_one_with_carry <= ( (significand_add_one_with_carry( (FP_LEN-(FP_EXP+1)+1) downto 1 )'range =>'0' ) & (flag_s_add or flag_r_add));  
  
  significand_s_normalized_rounded_aux <= ( unsigned('0' & std_logic_vector(significand_s_normalized)) + significand_add_one_with_carry );
                    
  mantissa_s <= unsigned(significand_s_normalized_rounded_aux(FP_LEN-(FP_EXP+1) downto 1)) 
  when (significand_s_normalized_rounded_aux(FP_LEN - FP_EXP) = '1') 
  -- Infinite value validation
  else to_unsigned(0,FP_LEN-(FP_EXP+1)) when flag_infinite = '1'
  -- Zero significand validation
  else to_unsigned(0,FP_LEN-(FP_EXP+1)) when flag_zero_significand = '1'
  -- Overflow validation 
  --else to_unsigned(2**(FP_LEN-FP_EXP-1)-1,FP_LEN-(FP_EXP+1)) when flag_overflow = '1'
  -- Underflow validation
  else to_unsigned(0,FP_LEN-(FP_EXP+1)) when flag_underflow ='1'
  else significand_s_normalized_rounded_aux(FP_LEN-(FP_EXP+1)-1 downto 0 );
  
  -- EXPONENT
  exponent_s <= (exponent_a_plus_b + exponent_add_one)
    when (significand_s_normalized_rounded_aux( FP_LEN - FP_EXP ) = '1')
    -- Infinite value validation
    else to_unsigned(2**FP_EXP-1,FP_EXP) when flag_infinite = '1'
    -- Zero significand validation
    else to_unsigned(0,FP_EXP) when flag_zero_significand = '1'
    -- Overflow validation
    --else to_unsigned(2**FP_EXP-2,FP_EXP) when flag_overflow = '1'
    -- Underflow validation
    else to_unsigned(0,FP_EXP) when (flag_underflow = '1')
    else exponent_a_plus_b;
  
  -- Concat sign + exp + mantissa
  s_out <= ( sign_s & std_logic_vector(exponent_s) & std_logic_vector(mantissa_s(FP_LEN-(FP_EXP+1)-1 downto 0)));
        
end beh;