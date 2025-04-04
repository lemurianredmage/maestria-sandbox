----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2025 05:34:34 PM
-- Design Name: 
-- Module Name: P01_Ejercicio_02 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--      Dise�e, simule e implemente un contador de 0000 a 9999, utilizando un divisor 
--      de frecuencia de X Hz. Para definir la frecuencia (X) del divisor, investigar el 
--      rango de frecuencia que percibe el ojo y elija una de esas frecuencias para el 
--      conteo (la m�s r�pida en donde las unidades de millar y centenas sean perceptibles).
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity P01_Ejercicio_02 is
    Generic ( MAX_COUNT : integer := 2_000_000);
    Port ( clk : in STD_LOGIC;                      -- 100MHz clock for Basys 3
           reset : in STD_LOGIC;                    -- Reset button
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display
           an : out STD_LOGIC_VECTOR (3 downto 0);
           count_out: out STD_LOGIC_VECTOR(15 downto 0) := (others => '0')); -- Digit activator
end P01_Ejercicio_02;

architecture Behavioral of P01_Ejercicio_02 is
    -- Frequency divisor for 50Hz
    -- Usually 50Hz is used in cinemas.
    -- 50Hz calculation for Basys 3 at 100MHz
    -- (100,000,000 / 50) = 2,000,000
    signal counter : integer := 0;
    signal clk_50Hz : STD_LOGIC := '0';
    
    -- 0000 a 9999 counter
    signal count : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    -- 4 digits multiplexor (~1ms refresh rate)
    signal refresh_counter : integer := 0;
    signal active_digit : integer range 0 to 3 := 0;
    signal digit_value : STD_LOGIC_VECTOR(3 downto 0);

begin
    -- Frequency divisor process
    process (clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            clk_50Hz <= '0';
        elsif rising_edge(clk) then
            if counter = MAX_COUNT - 1 then
                counter <= 0;
                clk_50Hz <= not clk_50Hz;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Counter processor 0000-9999
    process (clk_50Hz, reset)
        variable temp_count : STD_LOGIC_VECTOR(15 downto 0);
        variable changed_count: boolean := false;
    begin
        if reset = '1' then
            count <= (others => '0');
        elsif rising_edge(clk_50Hz) then
            temp_count := count;
            
            if temp_count(3 downto 0) > "1001" then
                temp_count(3 downto 0) := "0000";
                temp_count(7 downto 4) := temp_count(7 downto 4) + 1;
                changed_count := true;
            end if;
            
            if temp_count(7 downto 4) > "1001" then
                temp_count(7 downto 4) := "0000";
                temp_count(11 downto 8) := temp_count(11 downto 8) + 1;
                changed_count := true;
            end if;
            
            if temp_count(11 downto 8) > "1001" then
                temp_count(11 downto 8) := "0000";
                temp_count(15 downto 12) := temp_count(15 downto 12) + 1;
                changed_count := true;
            end if;
            
            
            
            if temp_count = "1001100110011001" then -- 9999
                temp_count := "0000000000000000";
            elsif not changed_count then
                temp_count(3 downto 0) := temp_count(3 downto 0) + 1;
            end if;
            
            changed_count := false;
            
            count <= temp_count;
        end if;
    end process;
    count_out <= count;
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
    process (active_digit, count)
    begin
        case active_digit is
            when 0 => digit_value <= count(3 downto 0);   -- Units
            when 1 => digit_value <= count(7 downto 4);   -- Tens
            when 2 => digit_value <= count(11 downto 8);  -- Hundreds
            when 3 => digit_value <= count(15 downto 12); -- Thousands
            when others => digit_value <= "0000";
        end case;
    end process;

    -- 7-segment decoder
    process(digit_value)
    begin
        case digit_value is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when others => seg <= "1111111"; -- Off
        end case;
    end process;

    -- Activation of each of the 4 digits
    process(active_digit)
    begin
        case active_digit is
            when 0 => an <= "1110";         -- Turn on AN0
            when 1 => an <= "1101";         -- Turn on AN1
            when 2 => an <= "1011";         -- Turn on AN2
            when 3 => an <= "0111";         -- Turn on AN3
            when others => an <= "1111";    -- Turn off everything
        end case;
    end process;

end Behavioral;
