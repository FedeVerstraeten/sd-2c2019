-- Codigo del banco de prueba del codigo
-- dispositivo de prueba contectado
-- hay que generarle las signal de prueba para probar
-- hay que darle valores a las signals

-- bibloteca
library IEEE;

-- paquete
use IEEE.std_logic_1164.all;

entity sumNb_tb is 
end;

architecture sumNb_tb_arq of sumNv_tb is
    constant N_tb: natural := 4;

    signal a_tb: std_logic_vector(N_tb-1 downto 0) := "0011";
    signal b_tb: std_logic_vector(N_tb-1 downto 0) := "0100";
    signal ci_tb: std_logic;
    signal s_tb: std_logic_vector(N_tb-1 downto 0);
    signal co_tb: std_logic_vector(N_tb-1 downto 0);
    signal co_tb: std_logic;
begin
    ci_tb <= '1' after 200 ns;

    DUT: entity work.sumNb
        generic map(
            N => N_tb
        )
        port map(
            a_i => a_tb,
            b_i => b_tb,
            ci_i => ci_tb,
            co_o => co_tb
        );
end;