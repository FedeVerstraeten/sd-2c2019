library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity toplevel_count is
  generic(N: natural := 4);
  port(
    clk: in std_logic;
    rst: in std_logic;
    ena: in std_logic;
    count: out std_logic_vector(N-1 downto 0)
  );
  
  -- Mapeo de pines para el kit Nexys 2
  attribute loc: string;
  
  attribute loc of clk: signal is "B8";
  attribute loc of rst: signal is "R17";          -- conexion a un switch
  attribute loc of ena: signal is "N17";          -- conexion a un switch
  attribute loc of count: signal is "K14 K15 J15 J14";  -- conexion a leds
end entity;
  
architecture toplevel_count_arq of toplevel_count is

  --Declaracion del componente contador de N bits
  component contadorN is
    generic(N: natural := 4);
    port(
      clk: in std_logic;
      rst: in std_logic;
      ena: in std_logic;
      count: out std_logic_vector(N-1 downto 0)
    );
  end component;
  
  -- Declaracion de senales auxiliares
  signal ena_aux: std_logic;
  signal ena_aux2: std_logic;
  
begin

  -- Generador de senal de habilitacion
  gen_ena: process(clk, rst)
    variable i: integer;
  begin
    if rst = '1' then
      i := 0;     
    elsif rising_edge(clk) then
      if i = 50000000 then
        i := 0;
        ena_aux <= '1';
      else
        i := i + 1;
        ena_aux <= '0';
      end if;
    end if;
  end process;
  
  -- Generacion de senal de habilitacion (tiene en cuenta la habilitacion
  -- general y la producida por el generador de habilitacion)
  ena_aux2 <= ena and ena_aux;
  
  -- Instanciacion del componente contador de N bits
  cont: contadorN
    generic map(4)
    port map(clk => clk, rst => rst, ena => ena_aux2, count => count);

end;
