library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sum_nb_tb is
end;

architecture sum_nb_tb_arq of sum_nb_tb is

  constant N_t: natural := 4;
  
  -- declaracion del componente a probar
  component sum_nb is
    generic(
      N: natural := 2
    );
    port(
      a: in std_logic_vector(N-1 downto 0);
      b: in std_logic_vector(N-1 downto 0);
      ci: in std_logic;
      s: out std_logic_vector(N-1 downto 0);
      co: out std_logic
    );
  end component;

  -- declaracion de senales de prueba
  -- signal a_tb: std_logic_vector(N_t-1 downto 0) := "0011";
  signal a_tb: std_logic_vector(N_t-1 downto 0) := std_logic_vector(to_unsigned(3, N_t));
--  signal b_tb: std_logic_vector(N_t-1 downto 0) := "0101";
  signal b_tb: std_logic_vector(N_t-1 downto 0) := std_logic_vector(to_unsigned(5, N_t));
  signal ci_tb: std_logic := '0';
  signal s_tb: std_logic_vector(N_t-1 downto 0);
  signal co_tb: std_logic;

begin
  -- GTKWave signal exit:
  --
  -- Time: 0ns....100ns....200ns....300ns
  -- a_tb: |3.......|6.......|........|
  -- b_tb: |5................|8.......|
  -- s_tb: |8.......|B.......|E.......|

  a_tb <= std_logic_vector(to_unsigned(6, N_t)) after 100 ns;
  b_tb <= std_logic_vector(to_unsigned(8, N_t)) after 200 ns;
  ci_tb <= '1' after 300 ns;
  
  DUT: sum_nb
    generic map(
      N => N_t
    )
    port map(
      a => a_tb,
      b => b_tb,
      ci => ci_tb,
      s => s_tb,
      co => co_tb
    );

end;
