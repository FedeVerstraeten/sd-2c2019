library ieee;
use ieee.std_logic_1164.all;

entity ffd is
	generic(N: natural:= 8);
	port(
		clk: in std_logic;
		rst: in std_logic;
		D: in std_logic_vector(N-1 downto 0);
		Q: out std_logic_vector(N-1 downto 0)
	);
end entity ffd;

architecture pp of ffd is
begin
	process(clk, rst)
	begin
		if rst = '1' then
			Q <= (others => '0');
		elsif falling_edge(clk) then
			q <= D;
		end if;
	end process;
end;