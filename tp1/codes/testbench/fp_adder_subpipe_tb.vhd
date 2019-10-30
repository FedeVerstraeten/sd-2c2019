library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity fp_adder_subpipe_tb is
end entity fp_adder_subpipe_tb;

architecture fp_adder_subpipe_tb_arch of fp_adder_subpipe_tb is
  
  constant TCK: time:= 20 ns;     -- periodo de reloj
  constant DELAY: natural:= 5;    -- retardo de procesamiento del DUT
  constant EXP_SIZE_T: natural:= 7;   -- tamaño exponente
  constant WORD_SIZE_T: natural:= 25; -- tamaño de datos
  constant TEST_PATH: string :="/home/fverstra/Repository/sd-2c2019/tp1/test_files_2015/suma/";
  constant TEST_FILE: string := TEST_PATH & "dummy_test_sum_float_25_7.txt";

  -- File input
  file datos: text open read_mode is TEST_FILE;

  signal clk: std_logic:= '0';
  --signal a_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  --signal b_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  --signal z_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
    
  --signal ciclos: integer := 0;
  --signal errores: integer := 0;
  
  -- Block one input - harcode
  signal a_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');
  signal b_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');
  
   -- Block four output
  signal significand_s_normalized: unsigned(( WORD_SIZE_T - (EXP_SIZE_T+1) ) downto 0);
  signal exponent_a_plus_b: unsigned(EXP_SIZE_T-1 downto 0);
  signal flag_r_add: std_logic;
  signal flag_s_add: std_logic;

begin
  -- Generacion del clock del sistema
  clk <= not(clk) after TCK/ 2; -- reloj

  -- Block one entry
  a_tb <= std_logic_vector(to_unsigned(8153147,25));
  b_tb <= std_logic_vector(to_unsigned(24788495,25));
  -- a_in = 8153147
  -- b_in = 24788495
  -- sign_a = 0
  -- sign_b = 1 
  -- exp_a = 62
  -- exp_b = 61
  -- significand_a = 157755
  -- significand_b = 115185 (complement2)
  -- significand_a_plus_b_with_carry = 346419
  -- carry_our = 1
  -- flag_g = 1
  -- significand_s_normalized = 168551
  -- exponent_a_plus_b = 61

  -- Instanciacion del DUT
  DUT: entity work.fp_adder_subpipe
    generic map(
      FP_EXP => EXP_SIZE_T,
      FP_LEN => WORD_SIZE_T
    )
    port map(
      -- IN
      clk => clk,
      rst => '0',
      a_in => a_tb,
      b_in => b_tb,
 
      -- OUT
      significand_s_normalized => significand_s_normalized,
      exponent_a_plus_b => exponent_a_plus_b,
      flag_r_add => flag_r_add,
      flag_s_add => flag_s_add
  );
 
  -- Verificacion de la condicion
  verificacion: process(clk)
  begin
    if rising_edge(clk) then
      report  "significand_s_normalized: " & integer'image(to_integer(significand_s_normalized)) & " " 
        & "exponent_a_plus_b: " & integer'image(to_integer(exponent_a_plus_b));
    else report
      "Simulacion ok";
    end if;
  end process verificacion;

end architecture fp_adder_subpipe_tb_arch; 