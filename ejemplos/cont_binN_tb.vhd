-- declaracion de librerias y paquetes
library IEEE;
use IEEE.std_logic_1164.all;

-- declaracion de entidad
entity cont_binN_tb is
end;

-- cuerpo de arquitectura
architecture cont_binN_tb_arq of cont_binN_tb is
  
  constant N_tb: natural := 10; 
  signal clk_tb: std_logic := '0';
  signal rst_tb: std_logic := '1';
  signal ena_tb: std_logic := '1';
  signal Q_tb: std_logic_vector(N_tb-1 downto 0);
  
begin
  -- generacion de la senal de prueba
  clk_tb <= not clk_tb after 10 ns;
  rst_tb <= '0' after 200 ns;
  ena_tb <= '0' after 500 ns, '1' after 1000 ns;
  
  -- instanciacion del componente
  DUT: entity work.cont_binN
    generic map(
      N => N_tb
    )
    port map(
      clk => clk_tb,
      rst => rst_tb,
      ena => ena_tb,
      Q => Q_tb
    );

end;