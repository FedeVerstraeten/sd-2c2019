library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Sin_Cos is
	generic(
		DATA_W: integer:= 11;	-- cantidad de bits del dato
		ADDR_W: integer:= 11	-- cantidad de bits de las direcciones de memoria
	);
	port(
		clk_i : in std_logic;                      -- clock
		ang_i : in std_logic_vector(ADDR_W-1 downto 0); -- entrada de datos, ángulo
		sin_o : out unsigned(DATA_W-2 downto 0);          -- salida del seno (salgo con N-2 bits)
		cos_o : out unsigned(DATA_W-2 downto 0)           -- salida del coseno (salgo con N-2 bits)
    );
end entity Sin_Cos;

architecture RTL of Sin_Cos is
	signal addr_sin: std_logic_vector(ADDR_W-3 downto 0):=(others => '0'); -- address de la tabla, correspondiente al seno (10 bits)
	signal addr_cos: std_logic_vector(ADDR_W-3 downto 0):=(others => '0'); -- address de la tabla, correspondiente al coseno (10 bits).
	signal out_sin: std_logic_vector(DATA_W-3 downto 0):=(others => '0'); -- salida de la rom, salida seno (10 bits).
	signal out_cos: std_logic_vector(DATA_W-3 downto 0):=(others => '0'); -- salida de la rom, salida coseno (10 bits).

	signal sign_cos: std_logic:='0'; -- sign of cos

	signal aux_sin: std_logic_vector(DATA_W-3 downto 0):=(others => '0'); -- seniales para la salida de la ROM
	signal aux_cos: std_logic_vector(DATA_W-3 downto 0):=(others => '0');

	component Sin_Rom is
		generic(
			ADD_W  : integer:=10;
			DATA_W : integer:=9
        );
		port(
			clk_i    : in std_logic;
			addr1_i  : in std_logic_vector(ADD_W-1 downto 0);
			addr2_i  : in std_logic_vector(ADD_W-1 downto 0);
			data1_o  : out std_logic_vector(DATA_W-1 downto 0);
			data2_o  : out std_logic_vector(DATA_W-1 downto 0)
        );
	end component Sin_Rom;

begin

    addr_sin <= ang_i(ADDR_W-3 downto 0) when ang_i(ADDR_W-2)='0' else not(ang_i(ADDR_W-3 downto 0));
  
    addr_cos <= not(addr_sin);

    Sin_Cos_Table: Sin_Rom
		generic map(
--			ADD_W => N-2, DATA_W => N-2)
			ADD_W => ADDR_W-2, DATA_W => DATA_W-2)
		port map(
			clk_i => clk_i,
			addr1_i => addr_sin,
			addr2_i => addr_cos,
			data1_o => out_sin,
			data2_o => out_cos
		);

	sign_cos<=(ang_i(ADDR_W-1) xor ang_i(ADDR_W-2));
    
    aux_sin <= out_sin when ang_i(ADDR_W-1)='0' else not(out_sin);
    aux_cos <= out_cos when sign_cos='0' else not(out_cos);
 
    sin_o <= unsigned(not ang_i(ADDR_W-1) & aux_sin);

    cos_o <= unsigned(not sign_cos & aux_cos);

end architecture RTL; -- Entity: Sin_Cos