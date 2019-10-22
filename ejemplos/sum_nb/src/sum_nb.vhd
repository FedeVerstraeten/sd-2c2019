library IEEE;
use IEEE.std_logic_1164.all;

entity sum_nb is
  generic(
    N: natural := 4
  );
  port(
    a: in std_logic_vector(N-1 downto 0);
    b: in std_logic_vector(N-1 downto 0);
    ci: in std_logic;
    s: out std_logic_vector(N-1 downto 0);
    co: out std_logic
  );
  
  -- Mapeo de pines de la FPGA
  attribute LOC: string;
  attribute LOC of a: signal is "K17 K18 H18 G18";
  attribute LOC of b: signal is "R17 N17 L13 L14";
  attribute LOC of ci: signal is "B18";
  attribute LOC of s: signal is "K14 K15 J15 J14";
  attribute LOC of co: signal is "E17";
end;

architecture sum_nb_arq of sum_nb is
  signal c_aux: std_logic_vector(N downto 0);
begin
  c_aux(0) <= ci;
  co <= c_aux(N);
  
  -- Conecto cada i-esimo sumador de 1bit al siguiente
  sumGen: for i in 0 to N-1 generate
    sum1b_i: entity work.sum_1b
      port map(
        a => a(i),
        b => b(i),
        ci => c_aux(i),
        s => s(i),
        co => c_aux(i+1)
      );
  end generate;

end;
