library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity multiplicador_tb is
  generic(N : natural := 4);
end;

architecture multiplicador_tb_arq of multiplicador_tb is

  component multiplicador is
    generic(N : natural := 4);
    port(
      OpA       : in  std_logic_vector(N-1 downto 0);
      OpB       : in  std_logic_vector(N-1 downto 0);
      Load      : in  std_logic;
      Clk       : in  std_logic;
      Resultado : out std_logic_vector(2*N-1 downto 0)
      );
  end component;

  signal OpA_tb       : std_logic_vector(N-1 downto 0) := "0011";
  signal OpB_tb       : std_logic_vector(N-1 downto 0) := "0100";
  signal Load_tb      : std_logic                      := '1';
  signal Clk_tb       : std_logic                      := '0';
  signal Resultado_tb : std_logic_vector(2*N-1 downto 0);

begin

-- ES EL CLOCK DE LA FPGA
  clk_tb  <= not clk_tb after 10 ns;
  Load_tb <= '0'        after 20 ns;

-- DUT es una etiqueta Device under test.
-- Podria decir cualquier cosa la etiqueta, 
-- nosotros elegimos esas siglas.
  DUT : multiplicador  
    port map(
      OpA       => OpA_tb,
      OpB       => OpB_tb,
      Load      => Load_tb,
      Clk       => Clk_tb,
      Resultado => Resultado_tb
      );

end;
