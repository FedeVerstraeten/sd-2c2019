library IEEE;
use IEEE.std_logic_1164.all;

entity sum_1b is
  port(
    A: in std_logic;
    B: in std_logic;
    Ci: in std_logic;
    S: out std_logic;
    Co: out std_logic
  );
end;

architecture sum_1b_arq of sum_1b is
begin
  S <= A xor B xor Ci;
  Co <= (A and B) or (A and Ci) or (B and Ci);
end;

---------------------------------------
-- Test
---------------------------------------
--library IEEE;
--use IEEE.std_logic_1164.all;

--entity test is
--end;

--architecture test_arq of test is
--  signal A_t: std_logic:= '0';
--  signal B_t: std_logic:= '0';
--  signal Ci_t: std_logic:= '0';
--  signal S_t: std_logic;
--  signal Co_t: std_logic;
  
--  -- Declaracion del componente a probar
--  component sum_1b is
--    port(
--      A: in std_logic;
--      B: in std_logic;
--      Ci: in std_logic;
--      S: out std_logic;
--      Co: out std_logic
--    );
--  end component;
  
--begin

--  -- Instanciacion del componente a probar
--  inst_sumador: sum_1b
--    port map(
--      A => A_t,
--      B => B_t,
--      Ci => Ci_t,
--      S => S_t,
--      Co => Co_t
--    );
  
--  -- Senales de prueba
--  A_t <= not A_t after 10 ns;
--  B_t <= not B_t after 20 ns;
--  Ci_t <= not Ci_t after 40 ns;
  
--end;