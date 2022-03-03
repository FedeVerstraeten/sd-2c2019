----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP Final - Implementación de un NCO sobre la plataforma Red Pitaya
----------------------------------------------------------------------------------
-- Filename: nco.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    nco
-- Module Name:    Numerically Controlled Oscilator
-- @Copyright (C):
--    This file is part of 'TP Final - Implementación de un NCO sobre la plataforma Red Pitaya'.
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

library ieeeE;
use ieeeE.std_logic_1164.all;
use ieeeE.numeric_std.all;
use ieeeE.math_real.all;

entity nco is
  generic(
    DATA_WIDTH: natural := 11;            -- data bits width
    ADDR_WIDTH: natural := 12;            -- LUT address bit width
    LUT_WIDTH: natural := (2**ADDR_W)-1;  -- LUT size
    PHASE_INC: natural                    -- phase increment
  );
  port(
    clk: in std_logic;  -- clock signal
    rst: in std_logic;  -- reset signal
    fck_in: in unsigned(PHASE_INC-1 downto 0);       -- freq. control worda input value
    sin_out: : out unsigned(DATA_WIDTH-2 downto 0);  -- sine output signal
    cos_out: out unsigned(DATA_WIDTH-2 downto 0)     -- cosine output signal
  );
end;

architecture beh of nco is
  
  -- Component definitions

  -- Returns the sine/cosine value for a given angle
  component sin_cos is
    generic(
      DATA_WIDTH: integer:= 11;
      ADDR_WIDTH: integer:= 11
        );
    port(
      clk_i : in std_logic;                               -- clock
      ang_i : in std_logic_vector(ADDR_WIDTH-1 downto 0); -- angle
      sin_o : out unsigned(DATA_WIDTH-2 downto 0);        -- sine output N-2 bits
      cos_o : out unsigned(DATA_WIDTH-2 downto 0)         -- cosine output N-2 bits
    );
  end component sin_cos;
  
  -- Phase accumulator
  component phase_accum is
    generic(
      Q: natural:= 14;          -- module
      N: natural:= 4;  -- number of bits
      INC_WIDTH: natural:= 8    -- Increment width
    );
    port(
      clk: in std_logic;
      increment: in unsigned(INCREMENTO_W-1 downto 0);  -- phase increment
      accum_reg: out std_logic_vector(N-1 downto 0)     -- accumulation register
    );
  end component phase_accum;

  -- Signals definitions
  signal accum_reg_sal: std_logic_vector(ADDR_WIDTH-1 downto 0);
  
begin
  -- Component instances
  phase_accum: phase_accum generic map(LUT_WIDTH, ADDR_WIDTH, PHASE_INC) port map(clk, fck_in, accum_reg_sal);
  singnal_synth: sin_cos generic map(DATA_WIDTH, ADDR_WIDTH) port map(clk, accum_reg_sal, salida_sen, salida_cos);
end beh;