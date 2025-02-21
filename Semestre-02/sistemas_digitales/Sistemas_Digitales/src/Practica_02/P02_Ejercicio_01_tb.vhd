----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2025 09:37:35 PM
-- Design Name: 
-- Module Name: P02_Ejercicio_01_tb - Behavioral
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

entity P02_Ejercicio_01_tb is
end P02_Ejercicio_01_tb;

architecture Behavioral of P02_Ejercicio_01_tb is
    -- Signals to connect DUT (Device Under Test)
    SIGNAL clk_tb : STD_LOGIC := '0';           -- 100mhz clock
    SIGNAL reset_tb : STD_LOGIC := '0';         -- Reset button
    SIGNAL clk_1hz_tb : STD_LOGIC := '0';       -- 1hz clock
    SIGNAL green_light_tb : STD_LOGIC := '0';   -- Green traffic light
    SIGNAL yellow_light_tb : STD_LOGIC := '0';  -- Yellow traffic light
    SIGNAL red_light_tb : STD_LOGIC := '0';     -- Red traffic light
    
    constant clk_period : time := 10 ns;        -- Clock period (100mhz -> 10ns per cycle)
begin

    dut: entity work.P02_Ejercicio_01
        generic map (SIMULATION_MODE => true)
        port map(
            clk => clk_tb,
            reset => reset_tb,
            clk_1hz => clk_1hz_tb,
            green_light => green_light_tb,
            yellow_light => yellow_light_tb,
            red_light => red_light_tb
        );

    clk_process:process
    begin
        while now < 40 sec loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
        wait; -- Detener proceso
    end process;
    
    simulation_procces:process
    begin
        wait for 100 ns;
        reset_tb <= '0';
        wait for 40 sec;
        assert false report "Test finalized." severity note;
        wait;
    end process;

end Behavioral;
