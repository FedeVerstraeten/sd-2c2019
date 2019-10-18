library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity fp_adder_tb is
end entity fp_adder_tb;

architecture fp_adder_tb_arch of fp_adder_tb is
  
  constant TCK: time:= 20 ns;     -- periodo de reloj
  constant DELAY: natural:= 5;    -- retardo de procesamiento del DUT
  constant EXP_SIZE_T: natural:= 7;   -- tamaño exponente
  constant WORD_SIZE_T: natural:= 25; -- tamaño de datos
  constant TEST_PATH: string :="/home/fverstra/Repository/sd-2c2019/tp1/test_files_2015/suma/";
  constant TEST_FILE: string := TEST_PATH & "dummy_test_sum_float_25_7.txt";

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
  
  -- File input
  file datos: text open read_mode is TEST_FILE;

  -- Component to test  
  component fp_adder is
    generic(
      FP_EXP: integer:=EXP_SIZE_T;
      FP_LEN: integer:=WORD_SIZE_T
    );

    port(
      clk: in std_logic;
      rst: in std_logic;
      a_in: in std_logic_vector(FP_LEN-1 downto 0);
      b_in: in std_logic_vector(FP_LEN-1 downto 0);
      s_out: out std_logic_vector( ( FP_LEN -1) downto 0)
    );
  end component fp_adder;

  -- Declaracion de la linea de retardo
  component delay_gen is
    generic(
      N: natural:= 32;
      DELAY: natural:= 5
    );
    port(
      clk: in std_logic;
      A: in std_logic_vector(N-1 downto 0);
      B: out std_logic_vector(N-1 downto 0)
    );
  end component;
  
begin
  -- Generacion del clock del sistema
  clk <= not(clk) after TCK/ 2; -- reloj

  Test_Sequence: process
    variable l: line;
    variable ch: character:= ' ';
    variable aux: integer;
  begin
    --while not(endfile(input)) loop
    while not(endfile(datos)) loop
      report "Entrada x ciclo n°: " & integer'image(ciclos);
      wait until rising_edge(clk);
      ciclos <= ciclos + 1;
      readline(datos, l);
      read(l, aux);
      a_file <= to_unsigned(aux, WORD_SIZE_T);
      read(l, ch);
      read(l, aux);
      b_file <= to_unsigned(aux, WORD_SIZE_T);
      read(l, ch);
      read(l, aux);
      z_file <= to_unsigned(aux, WORD_SIZE_T);
    end loop;
    
    file_close(datos);    -- se cierra del archivo
    wait for TCK*(DELAY+1);
    assert false report   -- se aborta la simulacion (fin del archivo)
      "Fin de la simulacion" severity failure;
  end process Test_Sequence;
  
  -- Instanciacion del DUT
  DUT: fp_adder
      generic map(
        FP_EXP => EXP_SIZE_T,
        FP_LEN => WORD_SIZE_T
      )
      port map(
        clk => clk,
        rst => '0',
        a_in => std_logic_vector(a_file),
        b_in => std_logic_vector(b_file),
        unsigned(s_out) => z_dut
      );
  
  -- Instanciacion de la linea de retardo
  del: delay_gen
      generic map(WORD_SIZE_T, DELAY)
      port map(clk, std_logic_vector(z_file), z_del_aux);
        
  z_del <= unsigned(z_del_aux);
  
  -- Verificacion de la condicion
  verificacion: process(clk)
  begin
    if rising_edge(clk) then
--      report integer'image(to_integer(a_file)) & " " & integer'image(to_integer(b_file)) & " " & integer'image(to_integer(z_file));
      assert to_integer(z_del) = to_integer(z_dut) report
        "Error: Salida del DUT no coincide con referencia (salida del dut = " & 
        integer'image(to_integer(z_dut)) &
        ", salida del archivo = " &
        integer'image(to_integer(z_del)) & ")"
        severity warning;
    else report
      "Simulacion ok";
      
      if to_integer(z_del) /= to_integer(z_dut) then
        errores <= errores + 1;
      end if;
    end if;
    
  end process;

end architecture fp_adder_tb_arch; 