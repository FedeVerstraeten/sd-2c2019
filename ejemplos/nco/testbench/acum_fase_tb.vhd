library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity acum_fase_tb is
end;

architecture p of acum_fase_tb is
	component acum_fase is
		generic(
			P: natural:= 5;
			Q: natural:= 14;
			N: natural:= 4 
		);
		port(
			clk: in std_logic;
			acum_reg: out std_logic_vector(N-1 downto 0)
		);
	end component acum_fase;

	constant N: natural:= 4;  -- cantidad de bits
	signal clk: std_logic:= '0';
	signal salida: std_logic_vector(N-1 downto 0);

begin

	clk <= not clk after 20 ns;
	aa: acum_fase generic map(3, 14, N) port map(clk, salida);
end;