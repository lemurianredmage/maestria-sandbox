----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2025 06:08:56 PM
-- Design Name: 
-- Module Name: P01_Ejercicio_02_tb - Behavioral
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

entity P01_Ejercicio_02_tb is
end P01_Ejercicio_02_tb;

architecture Behavioral of P01_Ejercicio_02_tb is
    -- Signals to connect DUT (Device Under Test)
    signal clk_tb : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '1';
    signal seg_tb : STD_LOGIC_VECTOR (6 downto 0);
    signal an_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal count_out_tb : STD_LOGIC_VECTOR(15 downto 0);
    
    -- 100 MHz -> 10 ns per cycle
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instance of DUT
    UUT: entity work.P01_Ejercicio_02
        (MAX_COUNT => 500_000)
        port map (
            clk => clk_tb,
            reset => reset_tb,
            seg => seg_tb,
            an => an_tb,
            count_out => count_out_tb);

    -- 100 MHz clock creation
    process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Simulation process
    process
    begin
        -- Init
        wait for 50 ns;     -- Wait for simulation init
        reset_tb <= '1';    -- Apply reset
        wait for 100 ns;
        reset_tb <= '0';    -- Remove reset

        -- One second simulation
        wait for 1 sec;

        -- Finish simulation
        assert false report "Simulation finished" severity failure;
    end process;

end Behavioral;
