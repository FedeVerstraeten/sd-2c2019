----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP1 - Aritmetica de punto flotante
----------------------------------------------------------------------------------
-- Filename: fp_adder_tb.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    Floating Point Adder - Test Bench
-- Module Name:    FP Adder - TB
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
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.utils_pkg;

entity fp_adder_tb is
end entity fp_adder_tb;

architecture fp_adder_tb_arch of fp_adder_tb is
  
  constant TCK: time:= 20 ns;         -- clock period
  constant DELAY: natural:= 4;        -- DUT delay
  constant WORD_SIZE_T: natural:= 25; -- size exponent
  constant EXP_SIZE_T: natural:= 7;   -- size float
  constant TEST_PATH: string :="/home/fverstra/Repository/sd-2c2019/tp1/test_files_2015/suma/";
  constant TEST_FILE: string := TEST_PATH & "test_sum_float_25_7.txt";

  -- File input
  file datos: text open read_mode is TEST_FILE;

  signal clk: std_logic:= '0';
  signal a_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal b_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal a_del: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal b_del: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_del: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_dut: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  
  signal ciclos: integer := 0;
  signal errores: integer := 0;
  
  -- se define por un problema de conversión
  signal a_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal b_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
  
  -- Prueba con valores harcodeados
  signal a_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');
  signal b_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');


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

  -- Read from test files
  Test_Sequence: process
    variable u: unsigned(WORD_SIZE_T-1 downto 0);
    variable l: line;
    begin
      while not endfile(datos) loop
        readline(datos, l);
        utils_pkg.read_unsigned_decimal_from_line(l, u);
        a_file <= unsigned(u);

        utils_pkg.read_unsigned_decimal_from_line(l, u);
        b_file <= unsigned(u);
        
        utils_pkg.read_unsigned_decimal_from_line(l, u);
        z_file <= unsigned(u); 
        wait for TCK;
      end loop;
      
      -- The WAIT after file_clore statement prevents 
      -- blocking the program when reading from a file
      file_close(datos);
      wait;

      -- abort simulation end of file
      wait for TCK*(DELAY+1);
      assert false report
        "Fin de la simulacion" severity failure;
  end process Test_Sequence;
  
  -- test_sum_float_25_7.txt
  --a_tb <= std_logic_vector(to_unsigned(24867535,25));
  --b_tb <= std_logic_vector(to_unsigned(24577755,25));
 
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
      --a_in => a_tb,
      --b_in => b_tb,
      unsigned(s_out) => z_dut
    );

  -- Instanciacion de la linea de retardo
  del_a: delay_gen
      generic map(WORD_SIZE_T, DELAY)
      port map(clk, std_logic_vector(a_file), a_del_aux);

  del_b: delay_gen
      generic map(WORD_SIZE_T, DELAY)
      port map(clk, std_logic_vector(b_file), b_del_aux);

  del_z: delay_gen
      generic map(WORD_SIZE_T, DELAY)
      port map(clk, std_logic_vector(z_file), z_del_aux);
        
  a_del <= unsigned(a_del_aux);
  b_del <= unsigned(b_del_aux);
  z_del <= unsigned(z_del_aux);
  
  -- Verificacion de la condicion
  verification: process(clk)
  begin
    if falling_edge(clk) then
      ciclos <= ciclos + 1;
      assert to_integer(z_del) = to_integer(z_dut)
        report "Calculation performed " & 
              integer'image(to_integer(unsigned(a_del))) & " + " &
              integer'image(to_integer(unsigned(b_del))) & " = " &
              integer'image(to_integer(z_dut)) & " and the expected result was " &
              integer'image(to_integer(unsigned(z_del)))
        severity warning;
    else report
      "Simulacion ok";
      
    if to_integer(z_del) /= to_integer(z_dut) then
        errores <= errores + 1;
      end if;
    end if;
    report "Ciclos = " & integer'image(ciclos) & ", "
      & "Errores =" & integer'image(errores);
  end process verification;

end architecture fp_adder_tb_arch; 