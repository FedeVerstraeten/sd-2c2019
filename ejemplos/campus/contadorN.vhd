library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contadorN is
  generic(N: natural := 4);
  port(
    clk: in std_logic;
    rst: in std_logic;
    ena: in std_logic;
    count: out std_logic_vector(N-1 downto 0)
  );
end;

architecture contadorN_arq of contadorN is
  signal aux: unsigned(N-1 downto 0);
begin
  contador: process(clk, rst)
  begin
    if rst = '1' then
      aux <= (others => '0');
    elsif rising_edge(clk) then
      if ena = '1' then
        aux <= aux + 1;
      end if;
    end if;
  end process;
  count <= std_logic_vector(aux);
end;

-- ------------------------------------------------
-- -- Testbench

-- library IEEE;
-- use IEEE.std_logic_1164.all;

-- entity test is
-- end;

-- architecture test_arq of test is

  -- component contadorN is
    -- generic(N: natural := 4);
    -- port(
      -- clk: in std_logic;
      -- rst: in std_logic;
      -- ena: in std_logic;
      -- count: out std_logic_vector(N-1 downto 0)
    -- );
  -- end component;

  -- constant N_t: natural := 5;
  -- signal clk_t: std_logic:= '0';
  -- signal rst_t: std_logic:= '1';
  -- signal ena_t: std_logic:= '1';
  -- signal Count_t: std_logic_vector(N_t-1 downto 0);
  
-- begin
  -- clk_t <= not clk_t after 10 ns;
  -- rst_t <= '0' after 50 ns;
  -- ena_t <= '0' after 620 ns, '1' after 800 ns;

  -- int_cont: contadorN
    -- generic map(N_t)
    -- port map(clk => clk_t, rst => rst_t, ena => ena_t, Count => Count_t);

-- end;
