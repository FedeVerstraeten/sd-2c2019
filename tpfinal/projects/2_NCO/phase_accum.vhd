----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP Final - Implementación de un NCO sobre la plataforma Red Pitaya
----------------------------------------------------------------------------------
-- Filename: phase_accum.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    phase_accum
-- Module Name:    Phase Accumulator
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity phase_accum is
  generic(
    Q: natural:= 14;   -- module
    N: natural:= 4;    -- number of bits
    INC_WIDTH: natural:= 8
  );
  port(
    clk: in std_logic;
    increment: in unsigned(INC_WIDTH-1 downto 0); -- phase increment
    accum_reg: out std_logic_vector(N-1 downto 0) -- accumulation register
    );
end entity phase_accum;

architecture beh of phase_accum is

  signal mod_reg: unsigned(N-1 downto 0):= (others => '0');
  signal rem_nc: unsigned(N-1 downto 0):= (others => '0');  -- contiene el numero que existe en el registro hasta que alcance el valor Q
  signal term_add: unsigned(N-1 downto 0):= (others => '0');
  
begin

  rem_nc <= to_unsigned(Q,N) - mod_reg;

  term_add <= to_unsigned(to_integer(increment),N);

    modular_addition: process(clk) is
    begin
    if rising_edge(clk) then
      if (rem_nc<=to_unsigned(to_integer(increment),N)) then
        mod_reg <= to_unsigned(to_integer(increment),N) - rem_nc;
      else
        mod_reg <= mod_reg + term_add; -- regular addition
      end if;

    end if;
    end process modular_addition;

    accum_reg <= std_logic_vector(mod_reg);

end architecture beh;
