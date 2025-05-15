----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2025 21:30:56
-- Design Name: 
-- Module Name: bin_to_bcd - Behavioral
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

entity bin_to_bcd is
    Port (
        bin_in  : in STD_LOGIC_VECTOR(11 downto 0);
        bcd_out : out STD_LOGIC_VECTOR(15 downto 0)
    );
end bin_to_bcd;

architecture Behavioral of bin_to_bcd is
begin
    process(bin_in)
        variable binary : INTEGER;
        variable thousands, hundreds, tens, ones : INTEGER;
    begin
        binary := to_integer(unsigned(bin_in));
        thousands := binary / 1000;
        hundreds := (binary mod 1000) / 100;
        tens := (binary mod 100) / 10;
        ones := binary mod 10;

        bcd_out <= std_logic_vector(to_unsigned(thousands, 4) &
                                    to_unsigned(hundreds, 4) &
                                    to_unsigned(tens, 4) &
                                    to_unsigned(ones, 4));
    end process;
end Behavioral;
