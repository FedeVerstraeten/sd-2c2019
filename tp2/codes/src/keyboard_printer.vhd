----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP2 - Recepción de caracteres por UART y visualización VGA
----------------------------------------------------------------------------------
-- Filename: keyboard_printer.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    Keyboard printer
-- Module Name:    Keyboard printer
-- @Copyright (C):
--    This file is part of 'TP2 - Recepción de caracteres por UART y visualización VGA'.
--    Unauthorized copying or use of this file via any medium
--    is strictly prohibited.
----------------------------------------------------------------------------------
-- Description: 
-- Main program of keyboard_printer
--
--  Baud Rate = 115200
--  Clock rate = 50 us
----------------------------------------------------------------------------------
-- Dependencies:
----------------------------------------------------------------------------------
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keyboard_printer is

  port (
    clk_i : in std_logic;    -- Clock input (from pin)
    rst_i : in std_logic;    -- Active HIGH reset (from pin)
    rxd_i : in std_logic;    -- RS232 RXD pin - directly from pin
    
    hs_o  : out std_logic;
    vs_o  : out std_logic;
    red_o : out std_logic_vector(2 downto 0);
    grn_o : out std_logic_vector(2 downto 0);
    blu_o : out std_logic_vector(1 downto 0)

    );

  attribute loc: string;
  
  -- Pin mapping of kit Arty z7-10
  --attribute loc of clk   : signal is "B8";
  --attribute loc of hs    : signal is "T4";
  --attribute loc of vs    : signal is "U3";
  --attribute loc of red_o : signal is "R8 T8 R9";
  --attribute loc of grn_o : signal is "P6 P8 N8";
  --attribute loc of blu_o : signal is "U4 U5";

end entity keyboard_printer;

architecture beh of keyboard_printer is

  component uart 
    generic(
      BAUD_RATE: integer := 115200;   
      CLOCK_RATE: integer := 50E6
    );
    port(
      clk_pin: in std_logic;
      rst_pin: in std_logic;
      rxd_pin: in std_logic;
      
      rxd_clk_rx:  out std_logic;
      rx_data:     out std_logic_vector(7 downto 0);
      rx_data_rdy: out std_logic;
      frm_err:     out std_logic
    );
  end component;

  component font_rom is
    port(
      clk: in std_logic;
      addr: in std_logic_vector(10 downto 0);
      data: out std_logic_vector(7 downto 0)
    );
  end component font_rom;

  component vga_ctrl is
    port (
      mclk      : in  std_logic;
      red_i     : in  std_logic;
      grn_i     : in  std_logic;
      blu_i     : in  std_logic;
      hs        : out std_logic;
      vs        : out std_logic;
      red_o     : out std_logic_vector(2 downto 0);
      grn_o     : out std_logic_vector(2 downto 0);
      blu_o     : out std_logic_vector(1 downto 0);
      pixel_row : out std_logic_vector(9 downto 0);
      pixel_col : out std_logic_vector(9 downto 0)
    );
  end component vga_ctrl;


begin

  inst_uart: uart
    port map(
      -- IN
      clk_pin     => clk_i,
      rst_pin     => rst_i,
      rxd_pin     => rxd_i,
      -- OUT
      rxd_clk_rx  => rxd_clk_rx,
      rx_data     => rx_date,
      rx_data_rdy => rx_data_rdy,
      frm_err     => open
    );

  inst_rom : font_rom
    port map(
      -- IN
      char_address => char_address_aux,
      font_row     => font_row_aux,
      font_col     => font_col_aux,
      -- OUT
      rom_out      => rom_out_aux
    );

  inst_vga : vga_ctrl
    port map(
      -- IN
      mclk      => clk,
      red_i     => red_i,
      grn_i     => grn_i,
      blu_i     => blu_i,
      -- OUT
      hs        => hs_aux,
      vs        => vs_aux,
      red_o     => red_o_aux,
      grn_o     => grn_o_aux,
      blu_o     => blu_o_aux,
      pixel_row => pixel_row_aux,
      pixel_col => pixel_col_aux
    );

  ---- Logica para ir eligiendo la entrada del mux y la fila y columna de la char
  ---- ROM
  --sel_aux <= "000" when unsigned(pixel_row_aux(9 downto 3)) = 30 and unsigned(pixel_col_aux(9 downto 3)) = 30 else
  --           "011" when unsigned(pixel_row_aux(9 downto 3)) = 30 and unsigned(pixel_col_aux(9 downto 3)) = 31 else
  --           "001" when unsigned(pixel_row_aux(9 downto 3)) = 30 and unsigned(pixel_col_aux(9 downto 3)) = 32 else
  --           "010" when unsigned(pixel_row_aux(9 downto 3)) = 30 and unsigned(pixel_col_aux(9 downto 3)) = 33 else
  --           "101" when unsigned(pixel_row_aux(9 downto 3)) = 30 and unsigned(pixel_col_aux(9 downto 3)) = 34 else
  --           "100" when unsigned(pixel_row_aux(9 downto 3)) = 30 and unsigned(pixel_col_aux(9 downto 3)) = 35 else
  --           "110";

  ---- Conecto la salida de la logica con la char ROM
  --font_row_aux <= pixel_row_aux(2 downto 0);
  --font_col_aux <= pixel_col_aux(2 downto 0);

  ---- Conecto la salida del mux con la entrada de la char ROM
  --char_address_aux <= sel_output_aux;

  --hs    <= hs_aux;
  --vs    <= vs_aux;
  --red_o <= red_o_aux;
  --grn_o <= grn_o_aux;
  --blu_o <= blu_o_aux;

end architecture beh;