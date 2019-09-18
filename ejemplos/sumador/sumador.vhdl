-- ejemplo de sumador c <= a + b
-- los puertos con _i son de entrada
-- los puertos con _o son de entrada

-- bibloteca
library IEEE;

-- paquete
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sumNb is
  generic(
      N: natural :=4
  );
  port(
      a_i: in std_logic_vector(N-1 downto 0); -- a in
      b_i: in std_logic_vector(N-1 downto 0); -- b in
      ci_i: in std_logic; -- carry in
      s_o: out std_logic_vector(N-1 downto 0);
      co_o: out std_logic
  );

  architecture sumNb_arq of sumNb is
      -- Agrego de N+1 a 0 porque agregue un bloque de un bit al principio y otro al final
      signal a_aux: unsigned(N+1 downto 0) := '0' & a_i & ci_i;   -- defino el bloque |'0'| |.....a_i.....| |c_i|
      signal b_aux: unsigned(N+1 downto 0) := '0' & b_i & '1';    -- defino el bloque |'0'| |.....b_i.....| |'1'|
      signal s_aux: unsigned(N+1 downto 0) := '0' & b_i & '1';    -- defino el bloque |'0'| |.....b_i.....| |'1'|

  begin
    
