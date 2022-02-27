library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;   	-- para instanciar la ROM
use std.textio.all;			-- para sacar valores por un archivo

entity nco_tb is
end;

architecture p of nco_tb is

	component nco is
		generic(
			DATA_W: natural := 11; -- cantidad de bits del dato + 1
			ADDR_W: natural := 12; -- cantidad de bits de las direcciones de la LUT
			modulo: natural;		-- cantidad de puntos
			PASO_W: natural			-- cantidad de bits del paso
		);
		port(
			clk, rst: in std_logic;
			paso: in unsigned(PASO_W-1 downto 0); -- valor de entrada (paso)
			salida_cos, salida_sen: out unsigned(DATA_W-2 downto 0)
		);
	end component;
	
	-- Cantidad de bits del dato + 1
	constant DATA_W: natural:= 13;
	-- Cantidad de bits de las direcciones de la LUT
	constant ADDR_W: natural:= 15;
	-- Cantidad de entradas a la LUT
	constant PUNTOS: natural:= (2**ADDR_W)-1;
	-- Cantidad de bits del paso (incremento)
	constant PASO_W: natural:= 4;
	
	signal clk: std_logic:= '0';
	signal rst: std_logic:= '1';
	signal sin_o: unsigned(DATA_W-2 downto 0);          -- salida del seno (salgo con N-2 bits)
	signal cos_o: unsigned(DATA_W-2 downto 0); 
	signal paso_prueba: unsigned(3 downto 0);
	
	-- Archivo para guardar los datos de la prueba
	file datos: text open write_mode is "./nco_output.txt";

	
begin
	clk <= not clk after 20 ns;
	rst <= '0' after 60 ns;
	-- paso_prueba <= "0101";
	paso_prueba <= "0011", "1000" after 1000 us, "1100" after 2000 us, "0001" after 3000 us;
	
	nco_inst: nco generic map(DATA_W, ADDR_W, PUNTOS, PASO_W) port map(clk, '0', paso_prueba, sin_o, cos_o);
	
	-- Carga de valores en el archivo
	process
		variable l: line;
		variable aux: integer;

	begin
		wait until rising_edge(clk);
		write(l, to_integer(sin_o));
		writeline(datos, l);
	end process;
end;
