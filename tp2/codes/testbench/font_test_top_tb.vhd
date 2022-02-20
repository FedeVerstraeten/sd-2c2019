library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity font_test_top_tb is
end entity font_test_top_tb;


architecture font_test_top_tb_arch of font_test_top_tb is

	constant TCK	: time:= 20 ns; 		-- periodo de reloj

	signal clk		: std_logic := '0';
	signal reset	: std_logic := '0';
	signal hsync	: std_logic;					-- sincronismo horizontal
	signal vsync 	: std_logic;					-- sincronismo vertical
	signal rgb 		:  std_logic_vector(2 downto 0);
	
	--Se tuvo que agregar una inicializacion para las siguientes senales en el modulo vga_sync:
	--signal v_count : unsigned(9 downto 0) := (others => '0');
	--signal h_count : unsigned(9 downto 0) := (others => '0');
	--signal pixel_tick: std_logic := '0';
	--Si no, los contadores no incrementaban al sumarles 1 o no cambiaban de estado al negarlos.
	--Se verificaron todos los valores de tiempos y los mismos son correctos
	
begin
	clk <= not(clk) after TCK/ 2; -- reloj
	
	-- dut: entity work.vga_sync
		-- port map(
			-- clk	=> clk,
			-- rst	=> rst,
			-- hsync => hsync,
			-- vsync => vsync,
			-- vidon => vidon,
			-- p_tick => p_tick,
			-- pixel_x => pixel_x,
			-- pixel_y => pixel_y
		-- );
	
	dut: entity work.font_test_top
		port map(
			clk => clk,
			reset => reset,
			hsync => hsync,
			vsync => vsync,
			rgb => rgb
		);

	process is
	begin
		-- wait for 10 ns;
		-- reset <= '1';
		-- wait for 100 ns;
		-- reset <= '0';
		--wait;
		reset <= '1', '0' after 50 ns;
		wait;
	end process;
end font_test_top_tb_arch;