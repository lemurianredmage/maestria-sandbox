----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2025 05:42:03 PM
-- Design Name: 
-- Module Name: P01_Ejercicio_01_tb - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity P01_Ejercicio_01_tb is
end P01_Ejercicio_01_tb;

architecture Behavioral of P01_Ejercicio_01_tb is

    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal seg : STD_LOGIC_VECTOR (6 downto 0);
    signal an : STD_LOGIC_VECTOR (3 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100MHz Clock

begin

    -- Instantiate the DUT (Enable Simulation Mode)
    UUT: entity work.P01_Ejercicio_01
        generic map (SIMULATION_MODE => true) -- ? Speed Up Simulation
        port map (
            clk => clk,
            reset => reset,
            seg => seg,
            an => an
        );

    -- Generate 100MHz Clock
    process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Simulation Stimuli
    process
    begin
        -- Hold reset for 100 ns
        wait for 100 ns;
        reset <= '0';

        -- Run simulation for 2 seconds (enough to see multiple changes)
        wait for 2 sec;

        -- End Simulation
        wait;
    end process;

end Behavioral;