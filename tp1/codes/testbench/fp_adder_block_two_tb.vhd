library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity fp_adder_block_two_tb is
end entity fp_adder_block_two_tb;

architecture fp_adder_block_two_tb_arch of fp_adder_block_two_tb is
  
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
  signal sign_a_q1: std_logic := '0';
  signal sign_b_q1: std_logic := '0';
  signal exponent_a_q1: unsigned(EXP_SIZE_T-1 downto 0):= (others => '0');
  signal exponent_b_q1: unsigned(EXP_SIZE_T-1 downto 0):= (others => '0');
  signal significand_a_q1: unsigned(( WORD_SIZE_T - (EXP_SIZE_T+1)) downto 0):= (others => '0');
  signal significand_b_q1: unsigned(( WORD_SIZE_T - (EXP_SIZE_T+1)) downto 0):= (others => '0');
  signal flag_swap: std_logic :='0';

  -- Block two output
  signal significand_a_plus_b_with_carry: unsigned ( (WORD_SIZE_T-(EXP_SIZE_T+1) + 1) downto 0);
  signal flag_r: std_logic;
  signal flag_g: std_logic;
  signal flag_s: std_logic;

begin
  -- Generacion del clock del sistema
  clk <= not(clk) after TCK/ 2; -- reloj

  --Test_Sequence: process
  --  variable u: unsigned(WORD_SIZE_T-1 downto 0);
  --  variable l: line;
  --  begin
  --  file_open(f, TEST_FILE, read_mode);
  --        while not endfile(f) loop
  --            readline(f, l);
  --            utils_pkg.read_unsigned_decimal_from_line(l, u);
  --            a_file <= unsigned(u);

  --            utils_pkg.read_unsigned_decimal_from_line(l, u);
  --            b_file <= unsigned(u);
              
  --            utils_pkg.read_unsigned_decimal_from_line(l, u);
  --            z_file <= unsigned(u);     
  --      wait for TCK;
  --          assert (z_file = z_dut)
  --            report "Calculation performed " & 
  --                  integer'image(to_integer(a_file)) & " * " &
  --                  integer'image(to_integer(b_file)) & " = " &
  --                   integer'image(to_integer(z_dut)) & " and the expected result was " &
  --                  integer'image(to_integer(z_file))
  --          severity failure;
  --        end loop;
  --    file_close(f);
  --end process Test_Sequence;
  
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

  sign_a_q1 <= '0';
  sign_b_q1 <= '1';
  exponent_a_q1 <= to_unsigned(62,7);
  exponent_b_q1 <= to_unsigned(61,7);
  significand_a_q1 <= to_unsigned(157755,18);
  significand_b_q1 <= to_unsigned(115185,18);
  flag_swap <= '0';

  -- Instanciacion del DUT
  DUT: entity work.fp_adder_block_two
    generic map(
      FP_EXP => EXP_SIZE_T,
      FP_LEN => WORD_SIZE_T
    )
    port map(
    -- IN
    -- signals from pipe_one
    sign_a => sign_a_q1,
    sign_b => sign_b_q1,
    exponent_a => exponent_a_q1,
    exponent_b => exponent_b_q1,
    significand_a => significand_a_q1,
    significand_b => significand_b_q1,
    
    -- OUT
    significand_a_plus_b_with_carry => significand_a_plus_b_with_carry,
    flag_r => flag_r,
    flag_g => flag_g,
    flag_s => flag_s
  );
 
    
  -- Verificacion de la condicion
  verificacion: process(clk)
  begin
    if rising_edge(clk) then
      report  "Significand a+b with carry: " & integer'image(to_integer(significand_a_plus_b_with_carry)) & " " 
        & "Significand_a: " & integer'image(to_integer(significand_a_q1)) & " "
        & "Significand_b: " & integer'image(to_integer(significand_b_q1));
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

end architecture fp_adder_block_two_tb_arch; 