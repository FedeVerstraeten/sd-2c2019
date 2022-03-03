----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP FINAL - Implementación de un NCO sobre la plataforma RedPitaya
----------------------------------------------------------------------------------
-- Filename: fp_subtractor.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    NCO Top
-- Module Name:    NCO Top
-- @Copyright (C):
--    'TP FINAL - Implementación de un NCO sobre la plataforma RedPitaya'.
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
use ieee.math_real.all;

library work;
use work.parametersPackage.all;

entity nco_top is
  generic(
    nco_bits : integer := NCOBITS; --Cantidad de bits para el contador del NCO
    freq_control_bits : integer := FREQCONTROLBITS
  );
  port(
    clk: in  std_logic;
    rst: in  std_logic;
    fcw_i : in  std_logic_vector(freq_control_bits-1 downto 0);
    nco_o : out std_logic_vector(nco_bits-1 downto 0)
  );
end nco_top;

architecture beh of nco_top is

  -- Component definitions
  component nco
    generic(
      ncoBits : integer := 10; --Cantidad de bits para el contador del NCO
      freqControlBits : integer := 9 --Cantidad de bits para la palabra de control
    ); 
    port (
      clk_in : in  std_logic;
      rst_in_n : in  std_logic;
      fcw_in : in  std_logic_vector(freqControlBits-1 downto 0);
      nco_out : out std_logic_vector(ncoBits-1 downto 0)
    );
  end component;
  
  component signalLUT
    generic(
      dataBits : integer := 12; --data bits
      addBits : integer := 10 --address bits
    );
    port(
      addr_in : in std_logic_vector(addBits-1 downto 0);
      data_out : out std_logic_vector(dataBits-1 downto 0));
  end component;

  -- Signals definitions
  signal nco_out_s: std_logic_vector(nco_bits-1 downto 0);
begin

  -- Blocks interconnection
  nco_conn: nco
    generic map(
      nco_bits => NCOBITS,
      freq_control_bits => FREQCONTROLBITS
    ) 
    port map(
      clk_in => clk,
      rst_in_n => rst,
      fcw_in => fcw_i,
      nco_out => nco_out_s
    );

  signallut_conn: signalLUT 
    generic map(
      dataBits => DATABITS,
      addBits => NCOBITS
    )
    port map(
      addr_in => nco_out_s,
      data_out => nco_o
    );

end beh;