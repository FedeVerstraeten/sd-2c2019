library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sumador is
     generic(N: integer:= 4);        -- valor genérico
     port(
          A: in std_logic_vector(N-1 downto 0);  -- operando A
          B: in std_logic_vector(N-1 downto 0);  -- operando B
          Cin: in std_logic;       -- carry de entrada
          Sal: out std_logic_vector(N-1 downto 0);-- resultado de la operación
          Cout: out std_logic                     -- carry de salida
     );
end;

architecture sum of sumador is
     -- declaración de una señal auxiliar
     -- signal Sal_aux: std_logic_vector(N+1 downto 0);
     signal Sal_aux: unsigned(N+1 downto 0);
begin
     Sal_aux <= ('0' & unsigned(A) & Cin) + ('0' & unsigned(B) & '1');
     Sal <= std_logic_vector(Sal_aux(N downto 1));        
     Cout <= Sal_aux(N+1);        
end;
