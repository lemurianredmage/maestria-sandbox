----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2025 23:30:13
-- Design Name: 
-- Module Name: index_decoder_to_characters_memory - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity index_decoder_to_characters_memory is
    Port ( ascii_code : in STD_LOGIC_VECTOR(7 downto 0);
           character_address : out STD_LOGIC_VECTOR(5 downto 0));
end index_decoder_to_characters_memory;

architecture Behavioral of index_decoder_to_characters_memory is

begin
    process(ascii_code)
    begin
        case ascii_code is
            -- Letters (A-Z)
            when x"1C" => character_address <= "000000"; -- A
            when x"32" => character_address <= "000001"; -- B
            when x"21" => character_address <= "000010"; -- C
            when x"23" => character_address <= "000011"; -- D
            when x"24" => character_address <= "000100"; -- E
            when x"2B" => character_address <= "000101"; -- F
            when x"34" => character_address <= "000110"; -- G
            when x"33" => character_address <= "000111"; -- H
            when x"43" => character_address <= "001000"; -- I
            when x"3B" => character_address <= "001001"; -- J
            when x"42" => character_address <= "001010"; -- K
            when x"4B" => character_address <= "001011"; -- L
            when x"3A" => character_address <= "001100"; -- M
            when x"31" => character_address <= "001101"; -- N
            when x"44" => character_address <= "001110"; -- O
            when x"4D" => character_address <= "001111"; -- P
            when x"15" => character_address <= "010000"; -- Q
            when x"2D" => character_address <= "010001"; -- R
            when x"1B" => character_address <= "010010"; -- S
            when x"2C" => character_address <= "010011"; -- T
            when x"3C" => character_address <= "010100"; -- U
            when x"2A" => character_address <= "010101"; -- V
            when x"1D" => character_address <= "010110"; -- W
            when x"22" => character_address <= "010111"; -- X
            when x"35" => character_address <= "011000"; -- Y
            when x"1A" => character_address <= "011001"; -- Z
            -- Numbers (0-9)
            when x"45" => character_address <= "011010"; -- 0
            when x"16" => character_address <= "011011"; -- 1
            when x"1E" => character_address <= "011100"; -- 2
            when x"26" => character_address <= "011101"; -- 3
            when x"25" => character_address <= "011110"; -- 4
            when x"2E" => character_address <= "011111"; -- 5
            when x"36" => character_address <= "100000"; -- 6
            when x"3D" => character_address <= "100001"; -- 7
            when x"3E" => character_address <= "100010"; -- 8
            when x"46" => character_address <= "100011"; -- 9
            -- Special keys
            when x"4E" => character_address <= "100100"; -- "-"
            -- Others
            when others => character_address <= "100101"; -- (Blank)
        end case;
    end process;

end Behavioral;
