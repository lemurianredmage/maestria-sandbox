----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.05.2025 22:55:30
-- Design Name: 
-- Module Name: process_keycode - Behavioral
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

entity process_keycode is
    Port (
            clk : in STD_LOGIC;
            keycode : in STD_LOGIC_VECTOR(15 downto 0);
            keycodev : inout STD_LOGIC_VECTOR(15 downto 0);
            flag : in STD_LOGIC;
            cn : out STD_LOGIC;
            start : out STD_LOGIC;
            ascii_code : out STD_LOGIC_VECTOR(7 downto 0));
end process_keycode;

architecture Behavioral of process_keycode is
    signal temp_keycodev : STD_LOGIC_VECTOR(15 downto 0) := keycodev;
    signal temp_cn, temp_start : STD_LOGIC := '0';
begin
    process(keycode, temp_keycodev)
    begin
        if keycode(7 downto 0) = x"F0" then
            temp_cn <= '0';
        elsif keycode(15 downto 8) = x"F0" then
            if keycode /= temp_keycodev then
                temp_cn <= '1';
            else
                temp_cn <= '0';
            end if;
        else
            if (keycode(7 downto 0) /= temp_keycodev(7 downto 0)) or (temp_keycodev(15 downto 8) = x"F0") then
                temp_cn <= '1';
            else
                temp_cn <= '0';
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if flag = '1' and temp_cn = '1' then
                temp_start <= '1';
                temp_keycodev <= keycode;
            else
                temp_start <= '0';
            end if;
        end if;
    end process;

    -- Extraer solo el byte del código ASCII (cuando no es F0)
    cn <= temp_cn;
    keycodev <= temp_keycodev;
    ascii_code <= temp_keycodev(7 downto 0);
    start <= temp_start;

end Behavioral;
