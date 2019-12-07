----------------------------------------------------------------------------------
-- Title: FIUBA - 66.17 Sistemas Digitales
-- Project: TP2 - Recepción de caracteres por UART y visualización VGA
----------------------------------------------------------------------------------
-- Filename: text_screen_top.vhd
---------------------------------------------------------------------------------- 
-- Author: Federico Verstraeten
-- Design Name:    Text Screen Top
-- Module Name:    Text Screen Top
-- @Copyright (C):
--    This file is part of 'TP2 - Recepción de caracteres por UART y visualización VGA'.
--    Unauthorized copying or use of this file via any medium
--    is strictly prohibited.
----------------------------------------------------------------------------------
-- Description: 
-- Main program of text_screen_top
--
--  Baud Rate = 19200
--  Clock rate = 50 us
----------------------------------------------------------------------------------
-- Dependencies:
--    clock_manager_wrapper.vhd
--    vga_sync.vhd
--    uart.vhd
--    text_screen_gen.vhd
----------------------------------------------------------------------------------
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity text_screen_top is
   generic(
      BAUD_RATE: integer := 19200;    -- Baud rate
      CLOCK_RATE: integer := 50E6     -- Freq 50 Mhz
   );
   port(
      sys_clk_pin: in std_logic;      -- external SYS clock
      reset: in std_logic;            -- external reset
      rxd_pin: in std_logic;          -- bits from USB-UART pin
      hsync: out  std_logic;          -- horizontal signal
      vsync: out std_logic;           -- vertical signal
      rgb: out std_logic_vector(2 downto 0) -- VGA monitor output
   );
end text_screen_top;

architecture arch of text_screen_top is
   signal pixel_x, pixel_y: std_logic_vector(9 downto 0);
   signal video_on, pixel_tick: std_logic;
   signal sys_clk: std_logic;
   signal rgb_reg, rgb_next: std_logic_vector(2 downto 0);
   signal write_enable: std_logic;
   signal data_in: std_logic_vector(7 downto 0);
begin

    clk_manager: entity work.clock_manager_wrapper
    port map(
        -- IN
        reset=>reset,
        sys_clk_pin=>sys_clk_pin,
        -- OUT
        sys_clk=>sys_clk
    );

   -- VGA sync circuit instance
    vga_sync_unit: entity work.vga_sync
    port map(
        -- IN
        clk=>sys_clk,
        reset=>reset,
        -- OUT
        hsync=>hsync,
        vsync=>vsync,
        video_on=>video_on,
        p_tick=>pixel_tick,
        pixel_x=>pixel_x,
        pixel_y=>pixel_y
    );
   
    -- UART circuit
    -- baud rate (default) 19,200
    -- clock rate 5 MHz
    uart_rx: entity work.uart
    port map(
        -- IN
        clk => sys_clk,
        reset => reset,
        rx => rxd_pin,
        -- OUT
        r_data => data_in,
        rx_ready => write_enable
    );
    
   -- full-screen text generator instance
    text_gen_unit: entity work.text_screen_gen
    port map(
        -- IN
        clk=>sys_clk,
        reset=>reset,
        write_enable=>write_enable,
        data_in=>data_in(6 downto 0),
        video_on=>video_on,
        pixel_x=>pixel_x,
        pixel_y=>pixel_y,
        -- OUT
        text_rgb=>rgb_next
    );
    
   -- rgb buffer
   process (sys_clk)
   begin
      if (sys_clk'event and sys_clk='1') then
         if (pixel_tick='1') then
            rgb_reg <= rgb_next;
         end if;
      end if;
   end process;
   rgb <= rgb_reg;
end arch;