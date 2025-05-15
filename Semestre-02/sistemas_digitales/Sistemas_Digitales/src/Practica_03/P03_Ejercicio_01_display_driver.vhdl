----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2025 21:31:38
-- Design Name: 
-- Module Name: display_driver - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity display_driver is
    Port (
        clk  : in STD_LOGIC;
        bcd  : in STD_LOGIC_VECTOR (15 downto 0);
        seg  : out STD_LOGIC_VECTOR (6 downto 0);
        an   : out STD_LOGIC_VECTOR (3 downto 0)
    );
end display_driver;

architecture Behavioral of display_driver is
    signal refresh_counter : INTEGER range 0 to 19999 := 0;
    signal digit_select     : INTEGER range 0 to 3 := 0;
    signal digit_value      : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if refresh_counter = 19999 then
                refresh_counter <= 0;
                digit_select <= (digit_select + 1) mod 4;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    with digit_select select
        digit_value <= bcd(3 downto 0)   when 0,
                       bcd(7 downto 4)   when 1,
                       bcd(11 downto 8)  when 2,
                       bcd(15 downto 12) when 3;

    with digit_select select
        an <= "1110" when 0,
              "1101" when 1,
              "1011" when 2,
              "0111" when 3;

    with digit_value select
        seg <= "1000000" when "0000", -- 0
               "1111001" when "0001", -- 1
               "0100100" when "0010", -- 2
               "0110000" when "0011", -- 3
               "0011001" when "0100", -- 4
               "0010010" when "0101", -- 5
               "0000010" when "0110", -- 6
               "1111000" when "0111", -- 7
               "0000000" when "1000", -- 8
               "0011000" when "1001", -- 9
               "1111111" when others;
end Behavioral;