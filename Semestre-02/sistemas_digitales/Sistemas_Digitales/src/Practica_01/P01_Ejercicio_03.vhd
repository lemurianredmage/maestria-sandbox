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
--      Dise e, simule e implemente un letrero digital en el display, el mensaje debe 
--      contener al menos 3 palabras y debe desplazarse a la izquierda, una vez que se 
--      imprima la  ltima palabra el mensaje debe volver a imprimirse, elija la 
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
    Generic ( SIMULATION_MODE : boolean := false); 
    Port ( clk : in STD_LOGIC;                      -- 100MHz clock for Basys 3
           reset : in STD_LOGIC;                    -- Reset button
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display
           an : out STD_LOGIC_VECTOR (3 downto 0)); -- Digit activator
end P01_Ejercicio_03;

architecture Behavioral of P01_Ejercicio_03 is

    signal clk_scroll : STD_LOGIC := '0';           -- Scrolling clock
    signal position : integer range 0 to 17 := 0;   -- Position in message

    -- Message encoded as 16 characters (use blank spaces for alignment)
    type message_array is array (0 to 17) of STD_LOGIC_VECTOR(3 downto 0);
    constant MESSAGE : message_array := (
        "0001", "0010", "0011", "0100", "0101",     -- "HELLO"
        "1111",
        "0110", "0111", "1000", "1001",             -- "FPGA"
        "1111",
        "1010", "1011", "1100", "1101", "1110",     -- "WORLD"
        "1111", "1111"                              -- (Blank space for looping effect)
    );
    
    -- Current Letters
    type letter_array is array (0 to 3) of STD_LOGIC_VECTOR(3 downto 0);
    signal letters: letter_array := ("1111", "1111", "1111", "1111");
    signal letters_index : integer := 0;

    -- Frequency Divider
    signal counter : integer := 0;
    signal MAX_COUNT : integer;
    
    -- 4 digits multiplexor (~1ms refresh rate)
    signal refresh_counter : integer := 0;
    signal active_digit : integer range 0 to 3 := 0;
    signal char_value : STD_LOGIC_VECTOR(3 downto 0);
begin

    MAX_COUNT <= 50_000 when SIMULATION_MODE else 50_000_000; -- Adjust speed

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
        variable temp_letters : letter_array;
    begin
        if reset = '1' then
            position <= 0;
        elsif rising_edge(clk_scroll) then
            if position = 17 then
                position <= 0;                      -- Reset message when it reaches the end
            else
                temp_letters := letters;
                temp_letters(3) := temp_letters(2);
                temp_letters(2) := temp_letters(1);
                temp_letters(1) := temp_letters(0);
                
                position <= position + 1;
                temp_letters(0) := MESSAGE(position);
                
                letters <= temp_letters;
            end if;
        end if;
    end process;
    
    -- 4-digit multiplexer
    process (clk)
    begin
        if rising_edge(clk) then
            if refresh_counter = 12499 then  -- Change digits at ~1ms
                refresh_counter <= 0;
                if active_digit = 3 then
                    active_digit <= 0;
                else
                    active_digit <= active_digit + 1;
                end if;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;
    
    -- Select digit to show
    process (active_digit, letters)
    begin
        case active_digit is
            when 0 => char_value <= letters(0);
            when 1 => char_value <= letters(1);
            when 2 => char_value <= letters(2);
            when 3 => char_value <= letters(3);
            when others => char_value <= "0000";
        end case;
    end process;

    -- 7-Segment Decoder
    process(position)
    begin
        case char_value is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "0001001"; -- H
            when "0010" => seg <= "0000110"; -- E
            when "0011" => seg <= "1000111"; -- L
            when "0100" => seg <= "1000111"; -- L
            when "0101" => seg <= "1000000"; -- O
            when "0110" => seg <= "0001110"; -- F
            when "0111" => seg <= "0001100"; -- P
            when "1000" => seg <= "0000010"; -- G
            when "1001" => seg <= "0001000"; -- A
            when "1010" => seg <= "0000001"; -- W
            when "1011" => seg <= "1000000"; -- O
            when "1100" => seg <= "0001000"; -- R
            when "1101" => seg <= "1000111"; -- L
            when "1110" => seg <= "1000000"; -- D
            when others => seg <= "1111111"; -- (Blank)
        end case;
    end process;

    -- Activate Only One Digit at a Time (Cyclic Scrolling)
    process (clk)
    begin
        case active_digit mod 4 is
            when 0 => an <= "1110";         -- 1st digit active
            when 1 => an <= "1101";         -- 2nd digit active
            when 2 => an <= "1011";         -- 3rd digit active
            when 3 => an <= "0111";         -- 4th digit active
            when others => an <= "1111";    -- Default (All Off)
        end case;
    end process;

end Behavioral;