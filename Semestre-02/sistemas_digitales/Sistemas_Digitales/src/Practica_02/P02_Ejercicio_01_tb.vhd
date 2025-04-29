----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2025 21:47:47
-- Design Name: 
-- Module Name: practice_02_tb - Behavioral
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

entity tb_ds_practice_2_part_1 is
-- No ports for a testbench
end tb_ds_practice_2_part_1;

architecture behavior of tb_ds_practice_2_part_1 is
    -- Testbench Signals
    signal clk_tb           : std_logic := '0';
    signal reset_tb         : std_logic := '1';
    signal green_light_tb   : std_logic;
    signal yellow_light_tb  : std_logic;
    signal red_light_tb     : std_logic;

    -- Simulation parameters
    constant CLK_PERIOD : time := 10 ns; -- 100MHz clock (10ns period)

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.ds_practice_2_part_1
        generic map (
            MAX_COUNT => 500_000 -- <<< Smaller value to simulate faster!
        )
        port map (
            clk           => clk_tb,
            reset         => reset_tb,
            green_light   => green_light_tb,
            yellow_light  => yellow_light_tb,
            red_light     => red_light_tb
        );

    -- Clock Generation Process
    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Simulation process
    stim_process: process
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

end behavior;
