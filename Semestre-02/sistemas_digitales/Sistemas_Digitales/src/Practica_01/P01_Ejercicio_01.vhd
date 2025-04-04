----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2025 05:39:15 PM
-- Design Name: 
-- Module Name: P01_Ejercicio_01 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Dise�e, simule e implemente un contador de 0 a 9, utilizando un divisor de 
--      frecuencia de 1Hz y un solo d�gito del display (apagar los otros 3 d�gitos).
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity P01_Ejercicio_01 is
    Generic ( MAX_COUNT : integer := 50_000_000);
    Port ( clk : in STD_LOGIC;                      -- 100MHz clock for Basys 3
           reset : in STD_LOGIC;                    -- Reset button
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display
           an : out STD_LOGIC_VECTOR (3 downto 0); -- Digit activator
           count_out : out STD_LOGIC_VECTOR (3 downto 0));
end P01_Ejercicio_01;

architecture Behavioral of P01_Ejercicio_01 is

    signal clk_1Hz : STD_LOGIC := '0';
    
    signal count : STD_LOGIC_VECTOR (3 downto 0);

    -- Counter for frequency division
    signal counter : integer := 0;

begin
    -- Frequency Divider Process
    process (clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            clk_1Hz <= '0';
        elsif rising_edge(clk) then
            if counter = MAX_COUNT - 1 then -- Counter must be a variable instead a signal, because signal can represent a bus in the hw
                counter <= 0;
                clk_1Hz <= not clk_1Hz;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Counter Process (0 to 9)
    process (clk_1Hz, reset)
    begin
        if reset = '1' then
            count <= "0000";
        elsif rising_edge(clk_1Hz) then
            if count = "1001" then
                count <= "0000";
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    count_out <= count;
    -- 7-Segment Decoder
    process(count)
    begin
        case count is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when others => seg <= "1111111"; -- Turn off display
        end case;
    end process;

    -- Activate Only One Digit (AN0)
    an <= "1110";

end Behavioral;
