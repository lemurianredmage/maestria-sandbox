----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2025 21:31:38
-- Design Name: 
-- Module Name: display_driver - Behavioral
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

entity display is
    Port (
        clk  : in STD_LOGIC;
        rst  : in STD_LOGIC;
        voltage_mV : in integer range 0 to 3300;
        seg  : out STD_LOGIC_VECTOR (7 downto 0);
        an   : out STD_LOGIC_VECTOR (3 downto 0)
    );
end display;

architecture Behavioral of display is
    signal refresh_counter : INTEGER range 0 to 100000 := 0;
    signal refresh_clk : std_logic := '0';
    signal max_count : integer range 0 to 3 := 0;
    signal dig_entero, dig_decima, dig_centesima : integer range 0 to 9 := 0;
    
    type seg7_type is array (0 to 9) of std_logic_vector(7 downto 0);
    
    constant seg7_table : seg7_type := (
        "11000000", -- 0
        "11111001", -- 1
        "10100100", -- 2
        "10110000", -- 3
        "10011001", -- 4
        "10010010", -- 5
        "10000010", -- 6
        "11111000", -- 7
        "10000000", -- 8
        "10010000"  -- 9
    );
    
    constant seg7_table_punto : seg7_type := (
        "01000000", -- 0
        "01111001", -- 1
        "00100100", -- 2
        "00110000", -- 3
        "00011001", -- 4
        "00010010", -- 5
        "00000010", -- 6
        "01111000", -- 7
        "00000000", -- 8
        "00010000"  -- 9
    );
    
    constant CHAR_V : std_logic_vector(7 downto 0) := "11100011";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if refresh_counter = 100000 then
                refresh_counter <= 0;
                refresh_clk <= not refresh_clk;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;
    
    process(voltage_mV)
    begin
        dig_entero <= voltage_mV / 1000;
        dig_decima <= (voltage_mV mod 1000) / 100;
        dig_centesima <= (voltage_mV mod 100) / 10;
    end process;
    
    process(refresh_clk, rst)
        begin
        if rst = '1' then
            max_count <= 0;
            an <= "1111";
            seg <= "11111111";
        elsif rising_edge(refresh_clk) then
            case max_count is
                when 0 =>
                    an <= "0111";
                    seg <= seg7_table_punto(dig_entero);
                when 1 =>
                    an <= "1011";
                    seg <= seg7_table(dig_decima);
                when 2 =>
                    an <= "1101";
                    seg <= seg7_table(dig_centesima);
                when 3 =>
                    an <= "1110";
                    seg <= CHAR_V;
             end case;
             
             max_count <= max_count + 1;
             if max_count = 3 then
                max_count <= 0;
             end if;
          end if;
    end process;
end Behavioral;