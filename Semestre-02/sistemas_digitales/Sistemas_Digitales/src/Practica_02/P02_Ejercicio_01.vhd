----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2025 21:56:06
-- Design Name: 
-- Module Name: ds_practice_2_part_1 - Behavioral
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
use ieee.numeric_std.all;

entity ds_practice_2_part_1 is
    Generic ( MAX_COUNT : integer := 50_000_000);
    port(
        clk     : in std_logic; -- reloj de 100MHz de la Basys 3
        reset     : in std_logic; -- botón de reset
        green_light   : out std_logic;
        yellow_light  : out std_logic;
        red_light     : out std_logic
    );
end ds_practice_2_part_1;

architecture behavioral of ds_practice_2_part_1 is
    -- Finite States Machine (FSM) Variables
    type traffic_light_states is (S_START, S_GREEN, S_GREEN_BLINK_ON, S_GREEN_BLINK_OFF, S_YELLOW, S_RED);
    signal current_state : traffic_light_states := S_START;
    signal next_state : traffic_light_states;

    -- Frequency division variables
    signal clk_1Hz : STD_LOGIC := '0';
    signal counter : integer := 0;

    -- Counters for FSM
    signal counter_in_seconds : integer range 0 to 15 := 0;
    signal flickering_counter : integer range 0 to 3 := 0;

    signal flickering: std_logic := '1';
begin
    -- Frequency Divider Process
    process (clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            clk_1Hz <= '0';
        elsif rising_edge(clk) then
            if counter = MAX_COUNT - 1 then -- Counter must be a variable instead a signal, because signal can represent a bus in the hw
                counter <= 0;
                clk_1Hz <= not clk_1Hz;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

-- State Transition Process
    process (clk_1Hz, reset)
    begin
        if reset = '1' then
            current_state <= S_START;
            counter_in_seconds <= 0;
            flickering_counter <= 0;
        elsif rising_edge(clk_1Hz) then
            current_state <= next_state;
            
            counter_in_seconds <= counter_in_seconds + 1;
            
            -- Counters
            case current_state is
                when S_GREEN =>
                    if counter_in_seconds < 14 then
                        counter_in_seconds <= counter_in_seconds + 1;
                    else
                        counter_in_seconds <= 0;
                    end if;
                when S_GREEN_BLINK_ON | S_GREEN_BLINK_OFF =>
                    if flickering_counter < 2 then
                        flickering_counter <= flickering_counter + 1;
                    else
                        flickering_counter <= 0;
                    end if;
                when S_YELLOW =>
                    if counter_in_seconds < 4 then
                        counter_in_seconds <= counter_in_seconds + 1;
                    else
                        counter_in_seconds <= 0;
                    end if;
                when S_RED =>
                    if counter_in_seconds < 9 then
                        counter_in_seconds <= counter_in_seconds + 1;
                    else
                        counter_in_seconds <= 0;
                    end if;
                when others =>
                    counter_in_seconds <= 0;
                    flickering_counter <= 0;
            end case;
        end if;
    end process;

    -- Next State Logic
    process (current_state, counter_in_seconds, flickering_counter)
    begin
        next_state <= current_state; -- default value
        
        case current_state is
            when S_START =>
                next_state <= S_GREEN;
            when S_GREEN =>
                if counter_in_seconds = 14 then
                    next_state <= S_GREEN_BLINK_ON;
                else
                    next_state <= S_GREEN;
                end if;
            when S_GREEN_BLINK_ON =>
                next_state <= S_GREEN_BLINK_OFF;
            when S_GREEN_BLINK_OFF =>
                if flickering_counter = 2 then
                    next_state <= S_YELLOW;
                else
                    next_state <= S_GREEN_BLINK_ON;
                end if;
            when S_YELLOW =>
                if counter_in_seconds = 4 then
                    next_state <= S_RED;
                else
                    next_state <= S_YELLOW;
                end if;
            when S_RED =>
                if counter_in_seconds = 9 then
                    next_state <= S_GREEN;
                else
                    next_state <= S_RED;
                end if;
            when others =>
                next_state <= S_GREEN;
        end case;
    end process;

    -- Output Logic
    process (current_state)
    begin
        -- Default outputs
        green_light <= '0';
        yellow_light <= '0';
        red_light <= '0';

        case current_state is
            when S_GREEN =>
                green_light <= '1';
            when S_GREEN_BLINK_ON =>
                green_light <= '1';
            when S_GREEN_BLINK_OFF =>
                green_light <= '0';
            when S_YELLOW =>
                yellow_light <= '1';
            when S_RED =>
                red_light <= '1';
            when others =>
                -- No output
                null;
        end case;
    end process;

end behavioral;