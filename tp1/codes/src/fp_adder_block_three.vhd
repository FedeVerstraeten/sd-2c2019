library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_block_three is
  
  generic(
    FP_EXP: integer:= 8;
    FP_LEN: integer:= 32
  );
  
  port(
    sign_a: in std_logic;
    sign_b: in std_logic;
    significand_a_plus_b_with_carry: in unsigned ((FP_LEN-(FP_EXP+1) + 1) downto 0);
    
    significand_s: out unsigned((FP_LEN-(FP_EXP+1)) downto 0);
    carry_out: out std_logic;
    flag_s_twos_comp: out std_logic
  );
  
end fp_adder_block_three;

architecture beh of fp_adder_block_three is

begin

  check_significand: 
  process(sign_a,sign_b,significand_a_plus_b_with_carry)
  begin
    -- If sign_a and sign_b are diferent
    if (sign_a /= sign_b) then
      
      -- without carry and significand_MSB=1 then the result is negative
      -- apply Complement2 to significand
      if (significand_a_plus_b_with_carry(FP_LEN-(FP_EXP+1)+1) = '0') and (significand_a_plus_b_with_carry(FP_LEN-(FP_EXP+1)) = '1') then 
        significand_s <= unsigned(not std_logic_vector(significand_a_plus_b_with_carry((FP_LEN-(FP_EXP+1)) downto 0))) + to_unsigned(1,(FP_LEN-FP_EXP));
        flag_s_twos_comp <= '1';
        carry_out <= '0';
      else
        significand_s <= significand_a_plus_b_with_carry((FP_LEN-(FP_EXP+1)) downto 0);
        flag_s_twos_comp <= '0';
        carry_out <= '1';
      end if;
            
    else
      -- If sign_a and sign_b are the same
      -- no complent2
      significand_s <= significand_a_plus_b_with_carry((FP_LEN-(FP_EXP+1)) downto 0);
      flag_s_twos_comp <= '0';
      if (significand_a_plus_b_with_carry(FP_LEN-(FP_EXP+1)+1) = '1') then
        carry_out <= '1';
      else
        carry_out <= '0';
      end if;
    end if;
  end process;
end beh;