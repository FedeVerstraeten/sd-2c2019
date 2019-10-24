library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity fp_adder_block_three_tb is
end entity fp_adder_block_three_tb;

architecture fp_adder_block_three_tb_arch of fp_adder_block_three_tb is
  
  constant TCK: time:= 20 ns;     -- periodo de reloj
  constant DELAY: natural:= 5;    -- retardo de procesamiento del DUT
  constant EXP_SIZE_T: natural:= 7;   -- tamaño exponente
  constant WORD_SIZE_T: natural:= 25; -- tamaño de datos
  constant TEST_PATH: string :="/home/fverstra/Repository/sd-2c2019/tp1/test_files_2015/suma/";
  constant TEST_FILE: string := TEST_PATH & "dummy_test_sum_float_25_7.txt";

  -- File input
  file datos: text open read_mode is TEST_FILE;

  signal clk: std_logic:= '0';
  signal a_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal b_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_del: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_dut: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  
  signal ciclos: integer := 0;
  signal errores: integer := 0;
  
  -- La senal z_del_aux se define por un problema de conversión
  signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
  
  -- Prueba con valores harcodeados
  --signal a_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');
  --signal b_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');
  signal sign_a_q2: std_logic := '0';
  signal sign_b_q2: std_logic := '0';
  signal significand_a_plus_b_with_carry_q2: unsigned ( (WORD_SIZE_T-(EXP_SIZE_T+1) + 1) downto 0);
  
  -- Block three output
  signal significand_s: unsigned(( WORD_SIZE_T - (EXP_SIZE_T+1) ) downto 0);
  signal carry_out: std_logic;
  signal flag_s_twos_comp: std_logic;
  --signal index: unsigned(4 downto 0);

begin
  -- Generacion del clock del sistema
  clk <= not(clk) after TCK/ 2; -- reloj
 
  -- Block one entry
  -- a_tb <= std_logic_vector(to_unsigned(8153147,25));
  -- b_tb <= std_logic_vector(to_unsigned(24788495,25))
  -- a_in = 8153147
  -- b_in = 24788495
  -- sign_a = 0
  -- sign_b = 1 
  -- exp_a = 62
  -- exp_b = 61
  -- significand_a = 157755
  -- significand_b = 115185 (complement2)
  -- significand_a_plus_b_with_carry = 346419
  -- flag_g = 1
  sign_a_q2 <= '0';
  sign_b_q2 <= '1';
  significand_a_plus_b_with_carry_q2 <= to_unsigned(157755,19);

  -- Instanciacion del DUT
  DUT: entity work.fp_adder_block_three
    generic map(
      FP_EXP => EXP_SIZE_T,
      FP_LEN => WORD_SIZE_T
    )
    port map(
      -- IN
      -- signals from pipe_two
      sign_a => sign_a_q2,
      sign_b => sign_b_q2,
      significand_a_plus_b_with_carry => significand_a_plus_b_with_carry_q2,
    
      -- OUT
      significand_s => significand_s,
      carry_out => carry_out,
      flag_s_twos_comp => flag_s_twos_comp
    );
 
    
  -- Verificacion de la condicion
  verificacion: process(clk)
  begin
    if rising_edge(clk) then
      report  "Significand S: " & integer'image(to_integer(significand_s)) & " " 
        & "Carry out: " & integer'image(to_integer(unsigned'('0' & carry_out))) & " "
        & "flag_s_twos_comp: " & integer'image(to_integer(unsigned'('0' & flag_s_twos_comp)));
      --assert to_integer(z_del) = to_integer(z_dut) 
      --  report "Error: Salida del DUT no coincide con referencia (salida del dut = "
      --    & integer'image(to_integer(z_dut))
      --    & ", salida del archivo = " 
      --    & integer'image(to_integer(z_del)) & ")"
      --  severity warning;
    else report
      "Simulacion ok";
      
  --    if to_integer(z_del) /= to_integer(z_dut) then
  --      errores <= errores + 1;
  --    end if;
    end if;
  end process verificacion;

end architecture fp_adder_block_three_tb_arch; 