----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2025 21:49:10
-- Design Name: 
-- Module Name: display - Behavioral
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
use work.signboard_types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity signboard_display is
    Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            display_characters : in display_characters_array;
            anodos : out STD_LOGIC_VECTOR(3 downto 0);
            segments : out STD_LOGIC_VECTOR(6 downto 0));
end signboard_display;

architecture Behavioral of signboard_display is
    signal refresh_counter : integer := 0;
    signal active_digit : integer range 0 to 3 := 0;
    signal character_value : STD_LOGIC_VECTOR(6 downto 0);
    signal new_key : STD_LOGIC_VECTOR(6 downto 0);
begin
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
    process (clk, active_digit, display_characters)
    begin
        case active_digit is
            when 0 => character_value <= display_characters(0);
            when 1 => character_value <= display_characters(1);
            when 2 => character_value <= display_characters(2);
            when 3 => character_value <= display_characters(3);
            when others => character_value <= "1111111";
        end case;
    end process;

    -- 7-Segment Decoder
    process(character_value)
    begin
        segments <= character_value;
    end process;

    -- Activate Only One Digit at a Time (Cyclic Scrolling)
    process (clk, active_digit)
    begin
        case active_digit mod 4 is
            when 0 => anodos <= "1110";         -- 1st digit active
            when 1 => anodos <= "1101";         -- 2nd digit active
            when 2 => anodos <= "1011";         -- 3rd digit active
            when 3 => anodos <= "0111";         -- 4th digit active
            when others => anodos <= "1111";    -- Default (All Off)
        end case;
    end process;

end Behavioral;