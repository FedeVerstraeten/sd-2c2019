library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_block_four is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );
  
  port(
    sign_a: in std_logic;
    sign_b: in std_logic;
    exponent_a: in unsigned(FP_EXP-1 downto 0);
    significand_s: in unsigned(FP_LEN-(FP_EXP+1) downto 0);
    carry_out: in std_logic; 
    flag_r: in std_logic;
    flag_g: in std_logic;
    flag_s: in std_logic;
    
    significand_s_normalized: out unsigned(FP_LEN-(FP_EXP+1) downto 0);
    exponent_a_plus_b: out unsigned(FP_EXP-1 downto 0);
    flag_r_add: out std_logic;
    flag_s_add: out std_logic;
    flag_overflow: out std_logic;
    flag_underflow: out std_logic;
    flag_zero_significand: out std_logic
  );
  
end fp_adder_block_four;

architecture beh of fp_adder_block_four is
  -- Max size 2^5=32 of right shift 
  signal index_shift: unsigned(4 downto 0):= (others => '0');
begin

  right_shift_index:process(sign_a,sign_b,significand_s,carry_out)
    variable index_aux: integer :=0;
  begin
    index_aux := 0;
    if (sign_a /= sign_b) or carry_out='0' then
      while (significand_s((FP_LEN-(FP_EXP+1)) - index_aux) = '0' and index_aux<(FP_LEN-(FP_EXP+1))) loop
        index_aux := index_aux + 1;
      end loop;
      index_shift <= to_unsigned(index_aux,5);    
    end if;
  end process right_shift_index;

  -- if sign_a=sign_b and carry_out=1
  significand_s_normalized <= ( carry_out & significand_s((FP_LEN-(FP_EXP+1)) downto 1) ) 
  when ((sign_a xor sign_b)='0' and carry_out='1')
    --significand_s without left shift
    else significand_s( (FP_LEN-(FP_EXP+1)) - to_integer(index_shift) downto 0)
      when to_integer(index_shift) = 0
    -- significand_s & flag_g
    else ( significand_s( (FP_LEN-(FP_EXP+1)) - to_integer(index_shift) downto 0) & flag_g ) 
      when to_integer(index_shift) = 1 
    -- significand_s & flag_g & 0..0
    else ( significand_s( (FP_LEN-(FP_EXP+1)) - to_integer(index_shift) downto 0) & flag_g & ( (significand_s( (to_integer(index_shift) - 2) downto 0)'range) => '0') ) 
      when to_integer(index_shift) >= 2
    -- significand zero
    else ( flag_g & (significand_s( (FP_LEN - (FP_EXP+1) - 1 ) downto 0)'range => '0') ) 
      when (to_integer(index_shift) = (FP_LEN-(FP_EXP+1)+1) and flag_g = '1') 
    else ( others => '0');

  -- with carry and sign_a = sing_b
  --exponent_a_plus_b <= ( exponent_a + to_unsigned(1,FP_EXP) )
  --when ((sign_a xor sign_b)='0' and carry_out='1') 
  --  else ( exponent_a - index_shift);

  -- Zero significand
  flag_zero_significand <= '1' when to_integer(significand_s)=0 else '0';

  -- Underflow & Overflow validation
  limits_validation:process(sign_a,sign_b,carry_out,exponent_a,index_shift)
    constant EXP_BIAS: integer := (2**(FP_EXP-1))-1;
    constant EXP_MAX: integer := (2**(FP_EXP-1))-1;
    constant EXP_MIN: integer := -((2**(FP_EXP-1))-2);
    variable exp_a_int: integer;
  begin
    
    exp_a_int := (to_integer(exponent_a(FP_EXP-1 downto 0)) - EXP_BIAS);
    
    -- with carry and sign_a = sing_b
    if ((sign_a xor sign_b)='0' and carry_out='1') then    
      -- Overflow
      if ( exp_a_int+1 > EXP_MAX) then
        flag_overflow <= '1';
      else
        exponent_a_plus_b <= ( exponent_a + to_unsigned(1,FP_EXP));
        flag_overflow <= '0';
      end if;
 
    else
      -- Underflow
      if (exp_a_int - to_integer(index_shift) < EXP_MIN) then
        flag_underflow <= '1';
      else
        exponent_a_plus_b <= (exponent_a - index_shift);
        flag_underflow <= '0';
      end if;
    end if;
  end process limits_validation;

  flag_r_add <= '0';
  flag_s_add <= '0';
          
end beh;