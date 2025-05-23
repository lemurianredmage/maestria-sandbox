----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.05.2025 21:51:17
-- Design Name: 
-- Module Name: characters_memory - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity characters_memory is
    Port ( ADDR : in std_logic_vector(5 downto 0);
           DATA : out std_logic_vector(6 downto 0));
end characters_memory;

architecture Behavioral of characters_memory is
    -- Letters
    constant CHARACTER_A : std_logic_vector (6 downto 0) := "0001000";
    constant CHARACTER_B : std_logic_vector (6 downto 0) := "0000011";
    constant CHARACTER_C : std_logic_vector (6 downto 0) := "1000110";
    constant CHARACTER_D : std_logic_vector (6 downto 0) := "0100001";
    constant CHARACTER_E : std_logic_vector (6 downto 0) := "0000110";
    constant CHARACTER_F : std_logic_vector (6 downto 0) := "0001110";
    constant CHARACTER_G : std_logic_vector (6 downto 0) := "0010000";
    constant CHARACTER_H : std_logic_vector (6 downto 0) := "0001001";
    constant CHARACTER_I : std_logic_vector (6 downto 0) := "1100110";
    constant CHARACTER_J : std_logic_vector (6 downto 0) := "1100001";
    constant CHARACTER_K : std_logic_vector (6 downto 0) := "0000101";
    constant CHARACTER_L : std_logic_vector (6 downto 0) := "1000111";
    constant CHARACTER_M : std_logic_vector (6 downto 0) := "1001000";
    constant CHARACTER_N : std_logic_vector (6 downto 0) := "0101011";
    constant CHARACTER_O : std_logic_vector (6 downto 0) := "1000000";
    constant CHARACTER_P : std_logic_vector (6 downto 0) := "0001100";
    constant CHARACTER_Q : std_logic_vector (6 downto 0) := "0011000";
    constant CHARACTER_R : std_logic_vector (6 downto 0) := "0101111";
    constant CHARACTER_S : std_logic_vector (6 downto 0) := "0010010";
    constant CHARACTER_T : std_logic_vector (6 downto 0) := "0000111";
    constant CHARACTER_U : std_logic_vector (6 downto 0) := "1100011";
    constant CHARACTER_V : std_logic_vector (6 downto 0) := "1000001";
    constant CHARACTER_W : std_logic_vector (6 downto 0) := "1100010";
    constant CHARACTER_X : std_logic_vector (6 downto 0) := "0001111";
    constant CHARACTER_Y : std_logic_vector (6 downto 0) := "0010001";
    constant CHARACTER_Z : std_logic_vector (6 downto 0) := "0110110";
    -- Numbers
    constant CHARACTER_ZERO : std_logic_vector (6 downto 0) := "1000000";
    constant CHARACTER_ONE : std_logic_vector (6 downto 0) := "1111001";
    constant CHARACTER_TWO : std_logic_vector (6 downto 0) := "0100100";
    constant CHARACTER_THREE : std_logic_vector (6 downto 0) := "0110000";
    constant CHARACTER_FOUR : std_logic_vector (6 downto 0) := "0011001";
    constant CHARACTER_FIVE : std_logic_vector (6 downto 0) := "0010010";
    constant CHARACTER_SIX : std_logic_vector (6 downto 0) := "0000010";
    constant CHARACTER_SEVEN : std_logic_vector (6 downto 0) := "1111000";
    constant CHARACTER_EIGHT : std_logic_vector (6 downto 0) := "0000000";
    constant CHARACTER_NINE : std_logic_vector (6 downto 0) := "0011000";
    -- Special Characters
    constant CHARACTER_HYPHEN : std_logic_vector (6 downto 0) := "0111111";
    constant CHARACTER_BLANK : std_logic_vector (6 downto 0) := "1111111";
    
    type characters_array is array (0 to 37) of std_logic_vector (6 downto 0);
    constant characters_memory : characters_array := (
        CHARACTER_A,
        CHARACTER_B,
        CHARACTER_C,
        CHARACTER_D,
        CHARACTER_E,
        CHARACTER_F,
        CHARACTER_G,
        CHARACTER_H,
        CHARACTER_I,
        CHARACTER_J,
        CHARACTER_K,
        CHARACTER_L,
        CHARACTER_M,
        CHARACTER_N,
        CHARACTER_O,
        CHARACTER_P,
        CHARACTER_Q,
        CHARACTER_R,
        CHARACTER_S,
        CHARACTER_T,
        CHARACTER_U,
        CHARACTER_V,
        CHARACTER_W,
        CHARACTER_X,
        CHARACTER_Y,
        CHARACTER_Z,
        CHARACTER_ZERO,
        CHARACTER_ONE,
        CHARACTER_TWO,
        CHARACTER_THREE,
        CHARACTER_FOUR,
        CHARACTER_FIVE,
        CHARACTER_SIX,
        CHARACTER_SEVEN,
        CHARACTER_EIGHT,
        CHARACTER_NINE,
        CHARACTER_HYPHEN,
        CHARACTER_BLANK
    );
begin
process(ADDR)
    variable pos: integer;
begin
pos := to_integer(unsigned(ADDR));
DATA <= characters_memory(pos);
end process;
end Behavioral;
