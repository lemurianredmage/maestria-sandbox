----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2025 21:36:53
-- Design Name: 
-- Module Name: debouncer - Behavioral
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

entity debouncer is
    generic (
        COUNT_MAX   : integer := 255;
        COUNT_WIDTH : integer := 8
    );
    port (
        clk : in std_logic;
        I   : in std_logic;
        O   : out std_logic
    );
end entity debouncer;

architecture Behavioral of debouncer is
    signal count : unsigned(COUNT_WIDTH-1 downto 0) := (others => '0');
    signal Iv    : std_logic := '0';
    signal Orexp    : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if I = Iv then
                if count = to_unsigned(COUNT_MAX, COUNT_WIDTH) then
                    Orexp <= I;
                else
                    count <= count + 1;
                end if;
            else
                count <= (others => '0');
                Iv <= I;
            end if;
        end if;
    end process;

    O <= Orexp;

end architecture Behavioral;


