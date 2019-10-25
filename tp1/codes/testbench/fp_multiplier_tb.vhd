----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP1 - Aritmetica de punto flotante
----------------------------------------------------------------------------------
-- Filename: fp_multiplier_tb.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    Floating Point Multiplier - Test Bench
-- Module Name:    FP Multiplier - TB
-- @Copyright (C):
--    This file is part of 'TP1 - Aritmetica de punto flotante'.
--    Unauthorized copying or use of this file via any medium
--    is strictly prohibited.
----------------------------------------------------------------------------------
-- Description: 
--
----------------------------------------------------------------------------------
-- Dependencies:
-- 
----------------------------------------------------------------------------------
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.utils_pkg;

entity fp_multiplier_tb is
end entity fp_multiplier_tb;

architecture fp_multiplier_tb_arch of fp_multiplier_tb is
  
  constant TCK: time:= 20 ns;     -- periodo de reloj
  constant DELAY: natural:= 0;    -- retardo de procesamiento del DUT
  constant WORD_SIZE_T: natural:= 25; -- tamaño de datos
  constant EXP_SIZE_T: natural:= 7;   -- tamaño exponente
  constant TEST_PATH: string :="/home/fverstra/Repository/sd-2c2019/tp1/test_files_2015/multiplicacion/";
  constant TEST_FILE: string := TEST_PATH & "dummy_test_mul_float_25_7.txt";

  signal clk: std_logic:= '0';
  signal a_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal b_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_dut: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');

  -- Prueba con valores harcodeados
  signal a_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');
  signal b_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');
  
  -----

  signal ciclos: integer := 0;
  signal errores: integer := 0;
  
  -- La senal z_del_aux se define por un problema de conversion
  signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
  
  --file datos: text open read_mode
  file f: text;
  
  -- declaracion del componente a probar
  -- no obligatorio usando entity work.componentX
  component fp_multiplier is
    generic(
      FP_EXP: integer:= 8;
      FP_LEN: integer:= 32
    );
    port(
      a_in: in std_logic_vector(FP_LEN-1 downto 0);
      b_in: in std_logic_vector(FP_LEN-1 downto 0);
      s_out: out std_logic_vector(FP_LEN-1 downto 0)
    );
  end component fp_multiplier;
  
begin
  -- Generacion del clock del sistema
  clk <= not(clk) after TCK/2; -- reloj

  -- Read from test files
  Test_Sequence: process
    variable u: unsigned(WORD_SIZE_T-1 downto 0);
    variable l: line;
    begin
    file_open(f, TEST_FILE, read_mode);
    while not endfile(f) loop
        readline(f, l);
        utils_pkg.read_unsigned_decimal_from_line(l, u);
        a_file <= unsigned(u);

        utils_pkg.read_unsigned_decimal_from_line(l, u);
        b_file <= unsigned(u);
        
        utils_pkg.read_unsigned_decimal_from_line(l, u);
        z_file <= unsigned(u); 
    wait for TCK;
      assert (z_file = z_dut)
        report "Calculation performed " & 
              integer'image(to_integer(a_file)) & " * " &
              integer'image(to_integer(b_file)) & " = " &
               integer'image(to_integer(z_dut)) & " and the expected result was " &
              integer'image(to_integer(z_file))
      severity failure;
    end loop;
    file_close(f);
    
    -- This statement prevents blocking the 
    -- program when reading from a file
    wait;
  end process Test_Sequence;

-- 1103626240 -> 0x41c80000 -> 40
-- 1109393408 -> 0x42200000 -> 25
-- 1148846080 -> 0x447a0000 -> 1000
-- 1149042688 -> 0x447d0000 -> 1012.0[salida, error de redondeo?]
  --a_tb <= std_logic_vector(to_unsigned(1103626240,32));
  --b_tb <= std_logic_vector(to_unsigned(1109393408,32));

  -- test_mul_float_25_7.txt
  -- 33421366 24659682 16269938
  --a_tb <= std_logic_vector(to_unsigned(33421366,25));
  --b_tb <= std_logic_vector(to_unsigned(24659682,25));

  -- Instanciacion del DUT
  -- Definicion fp_exp=7 and fp_length=25

  DUT: fp_multiplier
      generic map(
        FP_EXP => EXP_SIZE_T,
        FP_LEN => WORD_SIZE_T
      )
      port map(
        --clk => clk,
        --rst => '0',
        --a_in => a_tb, 
        --b_in => b_tb,
        a_in => std_logic_vector(a_file),
        b_in => std_logic_vector(b_file),
        unsigned(s_out) => z_dut
      );

end architecture fp_multiplier_tb_arch; 
