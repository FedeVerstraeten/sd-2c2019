library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- declaracion de entidad
entity cont_binN is
  generic(
    N: natural := 4
  );
  port(
    clk: in std_logic;
    rst: in std_logic;
    ena: in std_logic;
    Q: out std_logic_vector(N-1 downto 0)
  );
end;

-- cuerpo de arquitectura
architecture cont_binN_arq of cont_binN is
begin

  process(clk, rst)
    variable count: unsigned(N-1 downto 0);
  begin
    if rst = '1' then
      count := (others => '0');
    elsif rising_edge(clk) then
      if ena = '1' then
        count := count + 1;
      end if;
    end if;
    Q <= std_logic_vector(count);
  end process;  
  
end;