library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity acum_fase_tb is
end;

architecture p of acum_fase_tb is
    component acum_fase is
        generic(
            Q: natural:= 14;
            N: natural:= 4;
            INCREMENTO_W: natural:= 5
        );
        port(
            clk: in std_logic;
            incremento: in unsigned(INCREMENTO_W-1 downto 0);
            acum_reg: out std_logic_vector(N-1 downto 0)
        );
    end component acum_fase;

    constant N: natural:= 4;  -- cantidad de bits
    constant P: natural:= 5;  -- paso en bits
    signal clk: std_logic:= '0';
    signal paso_prueba: unsigned(P-1 downto 0);
    signal acum_reg_salida: std_logic_vector(N-1 downto 0);

begin

    clk <= not clk after 20 ns;
    paso_prueba <= "00101";
    aa: acum_fase generic map(14, N, P) port map(clk,paso_prueba,acum_reg_salida);
end;