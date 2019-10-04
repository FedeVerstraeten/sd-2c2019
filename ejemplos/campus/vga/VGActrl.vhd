
dulo: Controlador VGA
-- Descripci�n: 
-- Autor: Sistemas Digitales (66.17)
--        Universidad de Buenos Aires - Facultad de Ingenier�a
--        www.campus.fi.uba.ar
-- Fecha: 16/04/13
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity vga_ctrl is
    port (
    mclk: in std_logic;
    red_i: in std_logic;
    grn_i: in std_logic;
    blu_i: in std_logic;
    hs: out std_logic;
    vs: out std_logic;
    red_o: out std_logic_vector(2 downto 0);
    grn_o: out std_logic_vector(2 downto 0);
    blu_o: out std_logic_vector(1 downto 0);
    pixel_row: out std_logic_vector(9 downto 0);
    pixel_col: out std_logic_vector(9 downto 0)
  );

  attribute loc: string;
      
  -- Mapeo de pines para el kit Nexys 2 (spartan 3E)
  attribute loc of mclk: signal is "B8";
  attribute loc of red_i: signal is "K18";
  attribute loc of grn_i: signal is "H18";
  attribute loc of blu_i: signal is "G18";
  attribute loc of hs: signal is "T4";
  attribute loc of vs: signal is "U3";
  attribute loc of red_o: signal is "R8 T8 R9";
  attribute loc of grn_o: signal is "P6 P8 N8";
  attribute loc of blu_o: signal is "U4 U5";

  -- Mapeo de pines para el kit spartan 3E
  -- attribute loc of mclk: signal is "C9";
  -- attribute loc of red_i: signal is "H18";
  -- attribute loc of grn_i: signal is "L14";
  -- attribute loc of blu_i: signal is "L13";
  -- attribute loc of hs: signal is "F15";
  -- attribute loc of vs: signal is "F14";
  -- attribute loc of red_o: signal is "H14";
  -- attribute loc of grn_o: signal is "H15";
  -- attribute loc of blu_o: signal is "G15";

  -- Mapeo de pines para el kit spartan 3
  -- attribute loc of mclk: signal is "T9";
  -- attribute loc of red_in: signal is "K13";
  -- attribute loc of grn_in: signal is "K14";
  -- attribute loc of blu_in: signal is "J13";
  -- attribute loc of hs: signal is "R9";
  -- attribute loc of vs: signal is "T10";
  -- attribute loc of red_out: signal is "R12";
  -- attribute loc of grn_out: signal is "T12";
  -- attribute loc of blu_out: signal is "R11";

end vga_ctrl;

architecture vga_ctrl_arq of vga_ctrl is

  -- Numero de pixeles en una linea horizontal (800)
  constant hpixels: unsigned(9 downto 0) := "1100100000";
  -- Numero de lineas horizontales en el display (521)
  constant vlines: unsigned(9 downto 0) := "1000001001";
  
  constant hbp: unsigned(9 downto 0) := "0010010000";  -- Back porch horizontal (144)
  constant hfp: unsigned(9 downto 0) := "1100010000";  -- Front porch horizontal (784)
  constant vbp: unsigned(9 downto 0) := "0000011111";  -- Back porch vertical (31)
  constant vfp: unsigned(9 downto 0) := "0111111111";  -- Front porch vertical (511)

  -- Contadores (horizontal y vertical)
  signal hc, vc: unsigned(9 downto 0);
  -- Flag para obtener una habilitaci�n cada dos ciclos de clock
  signal clkdiv_flag: std_logic;
  -- Senal para habilitar la visualizaci�n de datos
  signal vidon: std_logic;
  -- Senal para habilitar el contador vertical
  signal vsenable: std_logic;
  

begin
    -- Divisi�n de la frecuencia del reloj
    process(mclk)
    begin
        if rising_edge(mclk) then
            clkdiv_flag <= not clkdiv_flag;
        end if;
    end process;                                      

    -- Contador horizontal
    process(mclk)
    begin
        if rising_edge(mclk) then
            if clkdiv_flag = '1' then
                if hc = hpixels then                            
                    hc <= (others => '0');  -- El cont horiz se resetea cuando alcanza la cuenta m�xima de pixeles
                    vsenable <= '1';    -- Habilitaci�n del cont vert
                else
                    hc <= hc + 1;     -- Incremento del cont horiz
                    vsenable <= '0';    -- El cont vert se mantiene deshabilitado
                end if;
            end if;
        end if;
    end process;

    -- Contador vertical
    process(mclk)
    begin
        if rising_edge(mclk) then      
            if clkdiv_flag = '1' then           -- Flag que habilita la operaci�n una vez cada dos ciclos (25 MHz)
                if vsenable = '1' then          -- Cuando el cont horiz llega al m�ximo de su cuenta habilita al cont vert
                    if vc = vlines then                              
                        vc <= (others => '0');  -- El cont vert se resetea cuando alcanza la cantidad maxima de lineas
                    else
                        vc <= vc + 1;           -- Incremento del cont vert
                    end if;
                end if;
            end if;
        end if;
    end process;

  -- hs <= '1' when (hc(9 downto 7) = "000") else '0';
  -- vs <= '1' when (vc(9 downto 1) = "000000000") else '0';
    hs <= '1' when (hc < "0001100001") else '0';   -- Generaci�n de la se�al de sincronismo horizontal
    vs <= '1' when (vc < "0000000011") else '0';   -- Generaci�n de la se�al de sincronismo vertical

    pixel_col <= std_logic_vector(hc - 144) when (vidon = '1') else std_logic_vector(hc);    
    pixel_row <= std_logic_vector(vc - 31) when (vidon = '1') else std_logic_vector(vc);
  
  -- Habilitaci�n de la salida de datos por el display cuando se encuentra entre los porches
    vidon <= '1' when (((hc < hfp) and (hc > hbp)) and ((vc < vfp) and (vc > vbp))) else '0';

  -- Ejemplos
  -- Los colores est�n comandados por los switches de entrada del kit

  -- Dibuja un cuadrado rojo
    red_o <= (others => '1') when ((hc(9 downto 6) = "0111") and vc(9 downto 6) = "0100" and red_i = '1' and vidon ='1') else (others => '0');

  -- Dibuja una linea roja (valor espec�fico del contador horizontal
  -- red_o <= '1' when (hc = "1010101100" and red_i = '1' and vidon ='1') else '0';
  
  -- Dibuja una linea verde (valor espec�fico del contador horizontal)
    grn_o <= (others => '1') when (hc = "0100000100" and grn_i = '1' and vidon ='1') else (others => '0');  
  
  -- Dibuja una linea azul (valor espec�fico del contador vertical)
    blu_o <= (others => '1') when (vc = "0100100001" and blu_i = '1' and vidon ='1') else (others => '0');  

  -- Pinta la pantalla del color formado por la combinaci�n de las entradas red_i, grn_i y blu_i (switches)
  -- red_o <= '1' when (red_i = '1' and vidon = '1') else '0';
  -- grn_o <= '1' when (grn_i = '1' and vidon = '1') else '0';
  -- blu_o <= '1' when (blu_i = '1' and vidon = '1') else '0';

end vga_ctrl_arq;
