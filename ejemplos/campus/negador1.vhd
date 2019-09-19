library IEEE;
use IEEE.std_logic_1164.all;

entity negador1 is
  port(
    a: in std_logic;
    b: out std_logic
  );
end;

architecture negador_arq of negador1 is
begin
  b <= not a;
end;

---------------------------------------
-- Test
---------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end;

architecture test_arq of test is
  signal a_t: std_logic := '0';
  signal b_t: std_logic;
  
  -- Declaracion del componente a probar
  component negador is
  port(
    a: in std_logic;
    b: out std_logic
  );
  end component;
  
begin

  -- Instanciacion del componente a probar
  inst_negador: negador port map(a => a_t, b => b_t); 

  -- Senal de prueba
  a_t <= '1' after 30 ns, '0' after 100 ns, '1' after 150 ns;
end;