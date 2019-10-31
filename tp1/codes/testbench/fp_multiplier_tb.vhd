-- Project: TP1 - Aritmetica de punto flotante
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
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
  
  constant TCK: time:= 20 ns;         -- clock period
  constant DELAY: natural:= 0;        -- DUT delay
  constant WORD_SIZE_T: natural:= 25; -- size float
  constant EXP_SIZE_T: natural:= 7;   -- size exponent
  constant TEST_PATH: string :="/home/fverstra/Repository/sd-2c2019/tp1/test_files_2015/multiplicacion/";
  constant TEST_FILE: string := TEST_PATH & "test_mul_float_25_7.txt";

  signal clk: std_logic:= '0';
  signal a_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal b_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_file: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');
  signal z_dut: unsigned(WORD_SIZE_T-1 downto 0):= (others => '0');

  -- Prueba con valores harcodeados
  --signal a_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');
  --signal b_tb: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');
  -----
   
  --file datos: text open read_mode
  file data_file: text;
  
  -- component to test
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
  -- System clock generation
  clk <= not(clk) after TCK/2;

  -- Read from test files
  Test_Sequence: process
    variable u: unsigned(WORD_SIZE_T-1 downto 0);
    variable l: line;
    begin
    file_open(data_file, TEST_FILE, read_mode);
    while not endfile(data_file) loop
        readline(data_file, l);
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
      severity warning;
    end loop;
    file_close(data_file);
    
    -- This statement prevents blocking the 
    -- program when reading from a file
    wait;
  end process Test_Sequence;

  -- Instanciacion del DUT
  -- fp_exp=7 and fp_length=25
  --a_tb <= std_logic_vector(to_unsigned(33419898,25));
  --b_tb <= std_logic_vector(to_unsigned(7995526,25));
  

  DUT: fp_multiplier
    generic map(
      FP_EXP => EXP_SIZE_T,
      FP_LEN => WORD_SIZE_T
    )
    port map(
      a_in => std_logic_vector(a_file),
      b_in => std_logic_vector(b_file),
      --a_in => a_tb, 
      --b_in => b_tb,
      unsigned(s_out) => z_dut
    );

end architecture fp_multiplier_tb_arch; 
