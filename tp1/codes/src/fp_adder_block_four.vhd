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
    significand_s: in unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    carry_out: in std_logic; 
    flag_r: in std_logic;
    flag_g: in std_logic;
    flag_s: in std_logic;
    
    significand_s_normalized: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    exponent_a_plus_b: out unsigned(FP_EXP-1 downto 0);
    flag_r_add: out std_logic;
    flag_s_add: out std_logic
  );
  
end fp_adder_block_four;

architecture beh of fp_adder_block_four is
  signal index: unsigned(4 downto 0):= (others => '0');
begin
  
  index_def:process(sign_a,sign_b,significand_s,carry_out)
    variable index_aux: integer :=0;
  begin

    if (sign_a /= sign_b) then

      if (significand_s( FP_LEN-(FP_EXP+1) downto 0) /= (significand_s( FP_LEN-(FP_EXP+1) downto 0 )'range => '0')) then
        while (significand_s((FP_LEN-(FP_EXP+1)) - index_aux)= '0') loop
          index_aux := index_aux + 1;
        end loop;       
      else
        index_aux:= FP_LEN-FP_EXP;
      end if;     
      index <= to_unsigned(index_aux,5);  

    else
      if ( carry_out = '0') then        
        while (significand_s((FP_LEN-(FP_EXP+1)) - index_aux)= '0') loop
          index_aux := index_aux + 1;
        end loop;
        index <= to_unsigned(index_aux,5);    
      end if;
    end if ;
  end process index_def;

  significand_s_normalized <= ( carry_out & significand_s( (FP_LEN-(FP_EXP+1)) downto 1) ) 
  when ((sign_a xor sign_b)='0' and carry_out='1') 
    else ( significand_s( (FP_LEN-(FP_EXP+1)) - to_integer(index) downto 0) & flag_g ) 
      when to_integer(index) = 1 
    else ( significand_s( (FP_LEN-(FP_EXP+1)) - to_integer(index) downto 0) & flag_g & ( (significand_s( (to_integer(index) - 2) downto 0)'range) => '0') ) 
      when to_integer(index) >= 2 
    else ( flag_g & (significand_s( (FP_LEN - (FP_EXP+1) - 1 ) downto 0)'range => '0') ) 
      when (to_integer(index) = (FP_LEN-(FP_EXP+1)+1) and flag_g = '1') 
    else ( others => '0');

  -- with carry and sign_a = sing_b
  exponent_a_plus_b <= ( exponent_a + to_unsigned(1,FP_EXP) )
  when ((sign_a xor sign_b)='0' and carry_out='1') 
    else ( exponent_a - index);     
                
  flag_r_add <= significand_s(0) 
  when ((sign_a xor sign_b)='0' and carry_out='1')  --r:= FP_LENSB de S antes del desplazamiento
    else flag_g 
      when to_integer(index) = 0 -- r:=g
    else '0' 
      when to_integer(index) >= 2 ;
  
  flag_s_add <= (flag_g or significand_s(0) or flag_s) 
  when ((sign_a xor sign_b)='0' and carry_out='1') -- s:= or(g,r,s)
    else (flag_r or flag_s) 
      when to_integer(index) = 0 --s:= or(r,s)
    else '0' 
      when to_integer(index) >= 2 ;
          
end beh;