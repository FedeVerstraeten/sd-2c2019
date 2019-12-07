library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity clock_manager_wrapper is
  port (
    reset : in std_logic;
    sys_clk : out std_logic;
    sys_clk_pin : in std_logic
  );
end clock_manager_wrapper;

architecture structure of clock_manager_wrapper is
  component clk_wiz_0 is
  port (
    clk_in1 : in std_logic;
    clk_out1 : out std_logic;
    reset : in std_logic;
    locked : out std_logic
  );
  end component clk_wiz_0;
begin
clock_manager_i: component clk_wiz_0
     port map (
      reset => reset,
      locked => open,
      clk_out1 => sys_clk,
      clk_in1 => sys_clk_pin
    );
end structure;