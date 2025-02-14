----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/13/2025 06:26:12 PM
-- Design Name: 
-- Module Name: P01_Ejercicio_03 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Diseñe, simule e implemente un letrero digital en el display, el mensaje debe 
--      contener al menos 3 palabras y debe desplazarse a la izquierda, una vez que se 
--      imprima la última palabra el mensaje debe volver a imprimirse, elija la 
--      frecuencia apropiada para el desplazamiento.
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

entity P01_Ejercicio_03 is
    Generic ( SIMULATION_MODE : boolean := false ); 
    Port ( clk : in STD_LOGIC;                      -- 100MHz clock for Basys 3
           reset : in STD_LOGIC;                    -- Reset button
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display
           an : out STD_LOGIC_VECTOR (3 downto 0)); -- Digit activator
end P01_Ejercicio_03;

architecture Behavioral of P01_Ejercicio_03 is

    signal clk_scroll : STD_LOGIC := '0';           -- Scrolling clock
    signal position : integer range 0 to 15 := 0;   -- Position in message

    -- Message encoded as 16 characters (use blank spaces for alignment)
    type message_array is array (0 to 15) of STD_LOGIC_VECTOR(3 downto 0);
    constant MESSAGE : message_array := (
        "0001", "0100", "1100", "1100", "1111",     -- "HELLO"
        "1111", "0100", "0111", "0001",             -- "FPGA"
        "1100", "1111", "0100", "0111", "0000",     -- "WORLD"
        "0000", "0000"                              -- (Blank space for looping effect)
    );

    -- Frequency Divider
    signal counter : integer := 0;
    signal MAX_COUNT : integer;

begin

    MAX_COUNT <= 5_000_000 when SIMULATION_MODE else 50_000_000; -- Adjust speed

    -- Frequency Divider Process
    process (clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            clk_scroll <= '0';
        elsif rising_edge(clk) then
            if counter = MAX_COUNT - 1 then
                counter <= 0;
                clk_scroll <= not clk_scroll;       -- Toggle to create scroll effect
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Scrolling Message Process
    process (clk_scroll, reset)
    begin
        if reset = '1' then
            position <= 0;
        elsif rising_edge(clk_scroll) then
            if position = 15 then
                position <= 0;                      -- Reset message when it reaches the end
            else
                position <= position + 1;
            end if;
        end if;
    end process;

    -- 7-Segment Decoder
    process(position)
    begin
        case MESSAGE(position) is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- H
            when "0010" => seg <= "0100100"; -- E
            when "0011" => seg <= "0110000"; -- L
            when "0100" => seg <= "0011001"; -- L
            when "0101" => seg <= "0010010"; -- O
            when "0110" => seg <= "0000010"; -- F
            when "0111" => seg <= "1111000"; -- P
            when "1000" => seg <= "0000000"; -- G
            when "1001" => seg <= "0010000"; -- A
            when "1010" => seg <= "1111001"; -- W
            when "1011" => seg <= "1111110"; -- O
            when "1100" => seg <= "0001000"; -- R
            when "1101" => seg <= "0000011"; -- L
            when "1110" => seg <= "0100000"; -- D
            when others => seg <= "1111111"; -- (Blank)
        end case;
    end process;

    -- Activate Only One Digit at a Time (Cyclic Scrolling)
    process (clk)
    begin
        case position mod 4 is
            when 0 => an <= "1110";         -- 1st digit active
            when 1 => an <= "1101";         -- 2nd digit active
            when 2 => an <= "1011";         -- 3rd digit active
            when 3 => an <= "0111";         -- 4th digit active
            when others => an <= "1111";    -- Default (All Off)
        end case;
    end process;

end Behavioral;
