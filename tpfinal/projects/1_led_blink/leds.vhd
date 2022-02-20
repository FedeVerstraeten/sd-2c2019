----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/31/2022 01:00:01 AM
-- Design Name: 
-- Module Name: leds - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led1 is
    Port (  clk : in std_logic;
            rst : in std_logic;
            sal : out std_logic_vector(7 downto 0);
            ent : in std_logic_vector(7 downto 0)
    );
end led1;

architecture Behavioral of led1 is

begin

process(clk)
begin
    if (ent(0) and ent(1)) = '1' then
        sal <= "01101100";
    else
        sal <= "00000000";
    end if;
end process;

end Behavioral;
