----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2025 08:31:48 PM
-- Design Name: 
-- Module Name: P02_Ejercicio_01 - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity P02_Ejercicio_01 is
    Generic ( SIMULATION_MODE : boolean := false );
    Port(
        clk: in STD_LOGIC;              -- 100mhz clock
        reset: in STD_LOGIC;            -- Reset button
        clk_1hz: out STD_LOGIC;         -- 1hz clock
        green_light: out STD_LOGIC;     -- Green traffic light
        yellow_light: out STD_LOGIC;    -- Yellow traffic light
        red_light: out STD_LOGIC        -- Red traffic light
    );
end P02_Ejercicio_01;

architecture Behavioral of P02_Ejercicio_01 is
    signal trafficLightState : INTEGER range 0 to 32 := 0;  -- Total cycle of 33 secs for traffic light rotation   
    signal counter: INTEGER range 0 to 49999999 := 0;       -- Frequency divider counter
    signal temp_clk: STD_LOGIC := '0';
    signal MAX_COUNT : integer;
begin
    MAX_COUNT <= 50_000 when SIMULATION_MODE else 50_000_000;
    
    frequencyDivisor:process(clk)
    begin
        if reset = '1' then
            counter <= 0;
            temp_clk <= '0';
        elsif rising_edge(clk) then
            if counter = MAX_COUNT then
                counter <= 0;
                temp_clk <= not temp_clk;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process frequencyDivisor;
    
    trafficLight:process(temp_clk, reset)
    begin
        if reset = '1' then
            trafficLightState <= 0;
        elsif rising_edge(temp_clk) then
            if trafficLightState = 32 then
                trafficLightState <= 0;
            else
                trafficLightState <= trafficLightState + 1;
            end if;
        end if;
    end process trafficLight;

    currentLight:process(trafficLightState)
    begin
        -- Turn off all lights
        green_light <= '0';
        yellow_light <= '0';
        red_light <= '0';
        
        if trafficLightState >= 0 and trafficLightState < 15 then
            green_light <= '1';
        elsif trafficLightState >= 15 and trafficLightState < 21 then
            if (trafficLightState mod 2) = 0 then
                green_light <= '1';
            end if;
        elsif trafficLightState >= 21 and trafficLightState < 26 then
            yellow_light <= '1';
        elsif trafficLightState >= 26 and trafficLightState < 32 then
            red_light <= '1';
        end if;
    end process currentLight;

    clk_1hz <= temp_clk;        -- Output of 1hz clock
end Behavioral;



























