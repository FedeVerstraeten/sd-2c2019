------------------------------------------------------------------------------
----                                                                      ----
----  NCO (Numerically Controlled Oscilator)                              ----
----                                                                      ----                                                                        ----
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;   -- se usa para instanciar la ROM

entity nco is
	generic(
		DATA_W: natural := 11; 	-- cantidad de bits del dato
		ADDR_W: natural := 12; 	-- cantidad de bits de las direcciones de la LUT
		modulo: natural;		-- cantidad de puntos
		PASO_W: natural			-- cantidad de bits del paso
	);
	port(
		clk, rst: in std_logic;
		paso: in unsigned(PASO_W-1 downto 0); -- valor de entrada (paso)
		salida_cos, salida_sen: out unsigned(DATA_W-2 downto 0)
	);
end;

architecture p of nco is
	
	-- Componente que devuelve el valor del seno/coseno para un determinado angulo
	component sin_cos is
		generic(
			DATA_W: integer:= 11;	-- cantidad de bits del dato
			ADDR_W: integer:= 11	-- cantidad de bits de las direcciones de memoria
        );
		port(
			clk_i : in std_logic;                      -- clock
			ang_i : in std_logic_vector(ADDR_W-1 downto 0); -- angulo
			sin_o : out unsigned(DATA_W-2 downto 0);          -- salida del seno (se sale con N-2 bits)
			cos_o : out unsigned(DATA_W-2 downto 0)           -- salida del coseno (se sale con N-2 bits)
		);
	end component sin_cos;
	
	-- Componente que acumula la fase
	component acum_fase is
		generic(
			Q: natural:= 14;	-- modulo
			N: natural:= 4;  	-- cantidad de bits
			INCREMENTO_W: natural:= 8
		);
		port(
			clk: in std_logic;
			incremento: in unsigned(INCREMENTO_W-1 downto 0);		-- incremento de fase
			acum_reg: out std_logic_vector(N-1 downto 0)
		);
	end component acum_fase;

	signal acum_reg_sal: std_logic_vector(ADDR_W-1 downto 0);
	
begin
	af: acum_fase generic map(modulo, ADDR_W, PASO_W) port map(clk, paso, acum_reg_sal);
	ss: sin_cos generic map(DATA_W, ADDR_W) port map(clk, acum_reg_sal, salida_sen, salida_cos);
end;