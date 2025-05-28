library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package signboard_types is
    type signboard_characters_array is array (0 to 15) of STD_LOGIC_VECTOR(6 downto 0);
    type display_characters_array is array (0 to 3) of STD_LOGIC_VECTOR(6 downto 0);
    type signboard_state_type is (WAIT_KEY, STORE_CHAR, SCROLL);
end package;

package body signboard_types is
end package body;