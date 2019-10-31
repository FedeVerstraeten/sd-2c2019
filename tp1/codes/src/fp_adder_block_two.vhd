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
    
    significand_a_plus_b_with_carry: out unsigned ((FP_LEN-(FP_EXP+1) + 1) downto 0);
    flag_r: out std_logic;
    flag_g: out std_logic;
    flag_s: out std_logic
  );
  
end fp_adder_block_two;

architecture beh of fp_adder_block_two is
  
begin

  significand_calculus: 
  process(sign_a,sign_b,exponent_a,exponent_b,significand_a,significand_b)
    
    variable exp_shift: unsigned(FP_EXP-1 downto 0);
    variable p_reg: unsigned((FP_LEN-(FP_EXP+1)) downto 0);

  begin
    exp_shift := (exponent_a - exponent_b);

    -- if sign_a != sign_b, then shift_right (exp_a - exp_b) bits with '1'
    -- else shift_right (exp_a - exp_b) bits  with '0' 
    if (sign_a xor sign_b) = '1' then
      p_reg((FP_LEN-(FP_EXP+1)) downto ((FP_LEN-(FP_EXP+1)) - to_integer(exp_shift)+ 1)) := ( others=> '1');
    else
      p_reg((FP_LEN-(FP_EXP+1)) downto ((FP_LEN-(FP_EXP+1)) - to_integer(exp_shift)+ 1)) := ( others=> '0');
    end if ;
    
    -- Append significand_b to the remaining bits of the p-register
    p_reg((FP_LEN-(FP_EXP+1))-to_integer(exp_shift) downto 0) := significand_b((FP_LEN-(FP_EXP+1)) downto to_integer(exp_shift));
    
    -- bits shifted out of the p-register
    if to_integer(exp_shift)>0 then
      flag_g <= significand_b(to_integer(exp_shift)-1);
    else
      flag_g <= '0';
    end if ;
    
    -- significand_a + significand_b with carry
    significand_a_plus_b_with_carry <= (unsigned('0' & significand_a) + unsigned('0' & p_reg));

    -- Discard flag_r and flag_s by truncation
    flag_r <= '0';
    flag_s <= '0';
  end process;

end beh;
