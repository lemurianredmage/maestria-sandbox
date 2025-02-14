----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/13/2025 06:48:21 PM
-- Design Name: 
-- Module Name: P01_Ejercicio_03_tb - Behavioral
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

entity P01_Ejercicio_03_tb is
end P01_Ejercicio_03_tb;

architecture Behavioral of P01_Ejercicio_03_tb is

    -- Signals to connect DUT (Device Under Test)
    signal clk_tb : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '0';
    signal seg_tb : STD_LOGIC_VECTOR (6 downto 0);
    signal an_tb : STD_LOGIC_VECTOR (3 downto 0);

    -- 100 MHz -> 10 ns per cycle
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instance of DUT
    uut: entity work.P01_Ejercicio_03
        generic map (SIMULATION_MODE => true)
        port map (
            clk => clk_tb,
            reset => reset_tb,
            seg => seg_tb,
            an => an_tb
        );

    -- 100 MHz clock creation
    clk_process: process
    begin
        while now < 100 ms loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Simulation process
    stim_process: process
    begin
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 100 ms;
        report "Simulation Finished!" severity note;
        wait;
    end process;

end Behavioral;

