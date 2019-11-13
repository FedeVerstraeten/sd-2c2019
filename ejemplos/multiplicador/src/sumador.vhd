library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sumador is
  generic (
    N : integer := 4);
  port (
    a     : in  std_logic_vector(N-1 downto 0);
    b     : in  std_logic_vector(N-1 downto 0);
    c_in  : in  std_logic;
    sal   : out std_logic_vector(N-1 downto 0);
    c_out : out std_logic
    );
end entity sumador;

architecture sumador_arq of sumador is

  signal a_aux, b_aux, sal_aux : std_logic_vector(N+1 downto 0);

begin  -- architecture sumador_arq

  a_aux <= '0' & a & c_in;
  b_aux <= '0' & b & '1';

  sal_aux <= std_logic_vector(unsigned(a_aux) + unsigned(b_aux));

  sal   <= sal_aux(N downto 1);
  c_out <= sal_aux(N+1);

end architecture sumador_arq;
