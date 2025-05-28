----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2025 12:48:06
-- Design Name: 
-- Module Name: signboard_finite_state_machine - Behavioral
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
use work.signboard_types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity signboard_finite_state_machine is
    Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            character_data : out STD_LOGIC_VECTOR(6 downto 0);
            signboard_data : in STD_LOGIC_VECTOR(6 downto 0);
            display_characters : inout display_characters_array;
            signboard_address : out STD_LOGIC_VECTOR(3 downto 0);
            ascii_code : in STD_LOGIC_VECTOR(7 downto 0);
            new_key : in STD_LOGIC_VECTOR(6 downto 0);
            start : in STD_LOGIC;
            btn_scroll : in STD_LOGIC;
            signboard_write_enable : inout STD_LOGIC;
            
            read_ready : inout STD_LOGIC;
            signboard_characters_position : inout integer;
            signboard_characters_scroll_position : inout integer;
            signboard_characters_scroll_length : inout integer;
            last_ascii_code : inout STD_LOGIC_VECTOR(7 downto 0);
            state  : inout signboard_state_type);
end signboard_finite_state_machine;

architecture Behavioral of signboard_finite_state_machine is
    signal temp_state : signboard_state_type := WAIT_KEY;
    signal temp_signboard_characters : signboard_characters_array;
    signal temp_display_characters : display_characters_array;
    
    signal temp_last_ascii_code : STD_LOGIC_VECTOR(7 downto 0);
    
    signal temp_signboard_characters_position : integer range 0 to 15 := 0;
    signal temp_signboard_characters_scroll_position : integer range 0 to 15 := 0;
    signal temp_signboard_characters_scroll_length : integer range 0 to 15 := 0;
    signal temp_signboard_address : std_logic_vector(3 downto 0);
    
    signal MAX_COUNT_SCROLL : integer := 50_000_000;
    signal scroll_div : integer := 0;
begin
    
    process (clk, reset)
    begin
        if reset = '1' then
            temp_signboard_characters_position <= 0;
            temp_signboard_characters_scroll_position <= 0;
            temp_signboard_characters_scroll_length <= 0;
            
            temp_display_characters <= (others => (others => '1'));
--            display_characters <= temp_display_characters;
            
--            temp_signboard_characters := (others => (others => '1'));
--            signboard_characters <= temp_signboard_characters;
            
            temp_signboard_address <= "0000";
             
            temp_last_ascii_code <= "11111111";
            
            temp_state <= WAIT_KEY;
            
            scroll_div <= 0;
        elsif rising_edge(clk) then
            case temp_state is
                when WAIT_KEY =>
                    if start = '1' then
                        temp_state <= STORE_CHAR;
                    elsif btn_scroll = '1' then
                        temp_state <= SCROLL;
                        temp_signboard_characters_scroll_position <= 0;
                        temp_signboard_address <= "0000";
                        temp_display_characters <= ("1111111", "1111111", "1111111", "1111111");
                    end if;
                when STORE_CHAR =>
                    if temp_signboard_characters_position <= 15 then
                        signboard_write_enable <= '0';
                        temp_last_ascii_code <= ascii_code;
                        if ascii_code = x"5A" and ascii_code /= temp_last_ascii_code then -- ENTER key released
--                            char_buffer(temp_signboard_characters_position) <= temp_display_characters(0);
                            character_data <= temp_display_characters(0);
                            signboard_write_enable <= '1';
--                            characters_address;
                            temp_signboard_address <= std_logic_vector(to_unsigned(temp_signboard_characters_position, signboard_address'length));
                            
                            temp_display_characters(3) <= temp_display_characters(2);
                            temp_display_characters(2) <= temp_display_characters(1);
                            temp_display_characters(1) <= temp_display_characters(0);
                            temp_display_characters(0) <= "1111111";
                            
                            temp_signboard_characters_position <= temp_signboard_characters_position + 1;
                            temp_signboard_characters_scroll_length <= temp_signboard_characters_scroll_length + 1;
                        else
                            temp_display_characters(0) <= new_key;
                        end if;
                        
                        temp_state <= WAIT_KEY;
                        
                        if btn_scroll = '1' then
                            temp_state <= SCROLL;
                        end if;
                     else
                        temp_signboard_characters_position <= 0;
                     end if;
                when SCROLL =>
                    if scroll_div = MAX_COUNT_SCROLL then
                        scroll_div <= 0;
                        
                        if read_ready = '1' then
                            -- Aquí ya leíste el dato válido del ciclo anterior
                            temp_display_characters(3) <= temp_display_characters(2);
                            temp_display_characters(2) <= temp_display_characters(1);
                            temp_display_characters(1) <= temp_display_characters(0);
                            temp_display_characters(0) <= signboard_data;
                
                            temp_signboard_characters_scroll_position <= temp_signboard_characters_scroll_position + 1;
                
                            if temp_signboard_characters_scroll_position = temp_signboard_characters_scroll_length - 1 then
                                temp_signboard_characters_scroll_position <= 0;
                                temp_signboard_address <= "0000";
                            else
                                temp_signboard_address <= std_logic_vector(to_unsigned(temp_signboard_characters_scroll_position, signboard_address'length));
                            end if;
                
                            read_ready <= '0'; -- Ya usamos el dato
                        else
                            -- Prepara la lectura del siguiente carácter
                            temp_signboard_address <= std_logic_vector(to_unsigned(temp_signboard_characters_scroll_position, signboard_address'length));
                            read_ready <= '1'; -- En el siguiente ciclo se usará el dato
                        end if;
                    else
                       scroll_div <= scroll_div + 1; 
                    end if;
                    if btn_scroll = '0' then
                        temp_state <= WAIT_KEY;
                    end if;
            end case;
        end if;
    end process;
    signboard_address <= temp_signboard_address;
    display_characters <= temp_display_characters;
    signboard_characters_position <= temp_signboard_characters_position;
    signboard_characters_scroll_position <= temp_signboard_characters_scroll_position;
    signboard_characters_scroll_length <= temp_signboard_characters_scroll_length;
    last_ascii_code <= temp_last_ascii_code;
    state <= temp_state;
end Behavioral;