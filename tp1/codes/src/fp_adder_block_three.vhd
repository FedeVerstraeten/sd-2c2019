library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_adder_block_three is
  
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
    
    significand_a_plus_b_with_carry: in unsigned ( (FP_LEN-(FP_EXP+1) + 1) downto 0);
    
    flag_r_d3: in std_logic;
    flag_g_d3: in std_logic;
    flag_s_d3: in std_logic;
    
    flag_swap_d3: in std_logic;
    
    sign_a_q3: out std_logic;
    sign_b_q3: out std_logic;
    
    exponent_a_q3: out unsigned(FP_EXP-1 downto 0);
    
    flag_r_q3: out std_logic;
    flag_g_q3: out std_logic;
    flag_s_q3: out std_logic;
    
    flag_swap_q3: out std_logic;
    
    significand_s: out unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);
    carry_out: out std_logic;
    flag_s_twos_comp: out std_logic;
    index: out unsigned(4 downto 0)
  );
  
end fp_adder_block_three;

architecture beh of fp_adder_block_three is

  signal significand_s_aux: unsigned(( FP_LEN - (FP_EXP+1) ) downto 0);

begin

  add: process(clk,rst)
  variable index_aux: integer :=0;
  begin
    if(rst='1') then
      
      sign_a_q3 <= '0';
      sign_b_q3 <= '0';
      
      exponent_a_q3 <= ( others=>'0' );
    
      flag_r_q3 <= '0';
      flag_g_q3 <= '0';
      flag_s_q3 <= '0';
      
      flag_swap_q3 <= '0';
      
      significand_s <= ( others=>'0' );
      
      carry_out <= '0';
      index <= (others=>'0');
      
    elsif(rising_edge(clk)) then
    
      flag_r_q3 <= flag_r_d3;
      flag_g_q3 <= flag_g_d3;
      flag_s_q3 <= flag_s_d3;
      
      flag_swap_q3 <= flag_swap_d3;
      
      sign_a_q3 <= sign_a_d3;
      sign_b_q3 <= sign_b_d3;
      
      exponent_a_q3 <= exponent_a_d3;
    
      if (sign_a_d3 /= sign_b_d3) then
        
        -- No hubo carry out y MSB de S es 1 (resultado negativo)
        if (significand_a_plus_b_with_carry( FP_LEN-(FP_EXP+1)+1 ) = '0') and (significand_a_plus_b_with_carry( FP_LEN-(FP_EXP+1) ) = '1') then 
          significand_s <=  unsigned( not std_logic_vector(significand_a_plus_b_with_carry( (FP_LEN-(FP_EXP+1)) downto 0)))  + to_unsigned(1,(FP_LEN-FP_EXP)) ;
          significand_s_aux <=  unsigned( not std_logic_vector(significand_a_plus_b_with_carry( (FP_LEN-(FP_EXP+1)) downto 0)))  + to_unsigned(1,(FP_LEN-FP_EXP)) ;
          flag_s_twos_comp <= '1';
          carry_out <= '0';
        else
          significand_s <= significand_a_plus_b_with_carry( (FP_LEN-(FP_EXP+1)) downto 0);
          significand_s_aux <= significand_a_plus_b_with_carry( (FP_LEN-(FP_EXP+1)) downto 0);
          flag_s_twos_comp <= '0';
          carry_out <= '1';
        end if;
        
        if (significand_s_aux( FP_LEN-(FP_EXP+1) downto 0) /= (significand_s_aux( FP_LEN-(FP_EXP+1) downto 0 )'range => '0')) then
          while (significand_s_aux( (FP_LEN-(FP_EXP+1)) - index_aux)= '0') loop
            index_aux := index_aux + 1;
          end loop;       
        else
          index_aux:= FP_LEN-FP_EXP;
        end if;
        
        index <= to_unsigned(index_aux,5);
        
      else
      
        significand_s <= significand_a_plus_b_with_carry( (FP_LEN-(FP_EXP+1)) downto 0);
        flag_s_twos_comp <= '0';
        
        -- signos de operandos iguales, pregunto si hay carry out
        if ( significand_a_plus_b_with_carry( FP_LEN-(FP_EXP+1)+1 ) = '1') then
          carry_out <= '1';
        else
          carry_out <= '0';
            
          while (significand_a_plus_b_with_carry( (FP_LEN-(FP_EXP+1)) - index_aux)= '0') loop
            index_aux := index_aux + 1;
          end loop;
          
          index <= to_unsigned(index_aux,5);
          
        end if;
      end if;
    end if;
  end process;
end beh;