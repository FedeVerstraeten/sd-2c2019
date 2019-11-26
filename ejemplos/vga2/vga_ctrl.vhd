---------------------------------------------------------
--
-- Controlador de VGA
-- Version actualizada a 07/06/2016
--
-- Modulos:
--    vga_sync
--    gen_pixels
--
---------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_ctrl is
	port(
		clk, rst: in std_logic;
		sw: in std_logic_vector (2 downto 0);
		hsync , vsync : out std_logic;
		rgb : out std_logic_vector(2 downto 0)
	);
	
	-- attribute LOC: string;
	-- attribute LOC of clk: signal is "C9";
	-- attribute LOC of rst: signal is "D18";
	-- attribute LOC of sw: signal is "H18 L14 L13";
	-- attribute LOC of hsync: signal is "F15";
	-- attribute LOC of vsync: signal is "F14";
	-- attribute LOC of rgb: signal is "H14 H15 G15";

end vga_ctrl;

architecture vga_ctrl_arch of vga_ctrl is

	signal rgb_reg: std_logic_vector(2 downto 0);
	signal pixel_x, pixel_y: std_logic_vector(9 downto 0);
	signal video_on: std_logic;

begin

	-- instanciacion del controlador VGA
	vga_sync_unit: entity work.vga_sync
		port map(
			clk 	=> clk,
			rst 	=> rst,
			hsync 	=> hsync,
			vsync 	=> vsync,
			vidon	=> video_on,
			p_tick 	=> open,
			pixel_x => pixel_x,
			pixel_y => pixel_y
		);

	pixeles: entity work.gen_pixels
		port map(
			clk		=> clk,
			reset	=> rst,
			sw		=> sw,
			pixel_x	=> pixel_x,
			pixel_y	=> pixel_y,
			ena		=> video_on,
			rgb		=> rgb
		);
		
	-- -- rgb buffer
	-- process(clk, rst)
	-- begin
		-- if rst = '1' then
			-- rgb_reg <= (others => '0');
		-- elsif rising_edge(clk) then
			-- rgb_reg <= sw;
		-- end if;
	-- end process;

	-- rgb <= rgb_reg when video_on = '1' else "000";

end vga_ctrl_arch;