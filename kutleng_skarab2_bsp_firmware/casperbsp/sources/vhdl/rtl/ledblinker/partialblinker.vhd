--------------------------------------------------------------------------------
-- Company          : Kutleng Dynamic Electronics Systems (Pty) Ltd            -
-- Engineer         : Benjamin Hector Hlophe                                   -
--                                                                             -
-- Design Name      : CASPER BSP                                               -
-- Module Name      : partialblinker - rtl                                     -
-- Project Name     : SKARAB2                                                  -
-- Target Devices   : N/A                                                      -
-- Tool Versions    : N/A                                                      -
-- Description      : This module is used to test partial reconfiguration.     -
--                                                                             -
-- Dependencies     : ledflasher                                               -
-- Revision History : V1.0 - Initial design                                    -
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity partialblinker is
    port(
        clk_100MHz       : IN  STD_LOGIC;
        partial_bit_leds : out STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end entity partialblinker;

architecture rtl of partialblinker is
    component ledflasher is
        generic(
            -- Clock frequency in Hz
            G_CLOCK_FREQUENCY : NATURAL := 50_000_000;
            -- LED flashrate in Hz
            G_LED_FLASH_RATE  : NATURAL := 1
        );
        port(
            Clk : in  STD_LOGIC;
            LED : out STD_LOGIC
        );
    end component ledflasher;
begin

    LED5_i : ledflasher
        generic map(
            G_CLOCK_FREQUENCY => 100_000_000,
            G_LED_FLASH_RATE  => 5
        )
        port map(
            Clk => clk_100MHz,
            LED => partial_bit_leds(0)
        );

    LED6_i : ledflasher
        generic map(
            G_CLOCK_FREQUENCY => 100_000_000,
            G_LED_FLASH_RATE  => 3
        )
        port map(
            Clk => clk_100MHz,
            LED => partial_bit_leds(1)
        );

    LED7_i : ledflasher
        generic map(
            G_CLOCK_FREQUENCY => 100_000_000,
            G_LED_FLASH_RATE  => 2
        )
        port map(
            Clk => clk_100MHz,
            LED => partial_bit_leds(2)
        );

    LED8_i : ledflasher
        generic map(
            G_CLOCK_FREQUENCY => 100_000_000,
            G_LED_FLASH_RATE  => 1
        )
        port map(
            Clk => clk_100MHz,
            LED => partial_bit_leds(3)
        );

end architecture rtl;
