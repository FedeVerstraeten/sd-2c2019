library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_ctrl_test is
	port(
		clk, rst: in std_logic;
		sw: in std_logic_vector (2 downto 0);
		hsync , vsync : out std_logic;
		rgb : out std_logic_vector(2 downto 0);
		hsync_test: out std_logic
	);
	
	attribute LOC: string;
	attribute LOC of clk: signal is "C9";
	attribute LOC of rst: signal is "D18";
	attribute LOC of sw: signal is "H18 L14 L13";
	attribute LOC of hsync: signal is "F15";
	attribute LOC of vsync: signal is "F14";
	attribute LOC of rgb: signal is "H14 H15 G15";

	attribute LOC of hsync_test: signal is "D7";
end vga_ctrl_test;

architecture vga_ctrl_test_arq of vga_ctrl_test is
	signal hsync_test_aux: std_logic;
begin

	dut: entity work.vga_ctrl
		port map(
			clk	=> clk,
			rst	=> rst,
			sw	=> sw,
			hsync => hsync_test_aux,
			vsync => vsync,
			rgb => rgb
		);

	hsync <= hsync_test_aux;
	hsync_test <= hsync_test_aux;
	
end vga_ctrl_test_arq;