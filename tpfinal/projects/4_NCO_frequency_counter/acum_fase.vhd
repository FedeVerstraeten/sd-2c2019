------------------------------------------------------------------------------
----                                                                      ----
----  Modulo Acumulador de Fase                                           ----
----                                                                      ----                                                                        ----
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity acum_fase is
	generic(
		Q: natural:= 14;	-- módulo
		N: natural:= 4;  	-- cantidad de bits
		INCREMENTO_W: natural:= 8
	);
	port(
		clk: in std_logic;
		incremento: in unsigned(INCREMENTO_W-1 downto 0);
		acum_reg: out std_logic_vector(N-1 downto 0)
    );
end entity acum_fase;

architecture BEH of acum_fase is

	signal mod_reg: unsigned(N-1 downto 0):= (others => '0');
	signal rem_nc: unsigned(N-1 downto 0):= (others => '0');  -- contiene el numero que existe en el registro hasta que alcance el valor Q
	signal term_add: unsigned(N-1 downto 0):= (others => '0');
  
begin

	rem_nc <= to_unsigned(Q,N) - mod_reg;

	term_add <= to_unsigned(to_integer(incremento),N);

    Modular_Addition: process(clk) is
    begin
		if rising_edge(clk) then
			if (rem_nc<=to_unsigned(to_integer(incremento),N)) then
              mod_reg <= to_unsigned(to_integer(incremento),N) - rem_nc;  -- the register is loaded with a number smaller than P
			else
              mod_reg <= mod_reg + term_add; -- regular addition to be performed, when Q-mod_reg < P
			end if;

		end if;
    end process Modular_Addition;

    acum_reg <= std_logic_vector(mod_reg);

end architecture BEH;