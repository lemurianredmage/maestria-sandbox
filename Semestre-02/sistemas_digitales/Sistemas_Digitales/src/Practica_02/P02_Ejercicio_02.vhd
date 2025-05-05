----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2025 14:00:40
-- Design Name: 
-- Module Name: ds_practice_2_part_2 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ds_practice_crosswalk is
    generic (
        MAX_COUNT : integer := 50_000 -- 1Hz (suponiendo reloj 100 MHz)
    );
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        btn_ped     : in std_logic; -- botón de cruce peatonal

        -- Semáforo EO
        eo_green    : out std_logic;
        eo_yellow   : out std_logic;
        eo_red      : out std_logic;

        -- Semáforo NS
        ns_green    : out std_logic;
        ns_yellow   : out std_logic;
        ns_red      : out std_logic
    );
end entity;

architecture behavioral of ds_practice_crosswalk is

    type fsm_state is (
        S_INIT,               -- EO verde, NS rojo
        S_EO_BLINK_ON,
        S_EO_BLINK_OFF,
        S_EO_YELLOW,
        S_EO_TO_NS_GREEN,
        S_NS_BLINK_ON,
        S_NS_BLINK_OFF,
        S_NS_YELLOW
    );

    signal current_state, next_state : fsm_state := S_INIT;

    signal clk_1Hz : std_logic := '0';
    signal div_counter : integer := 0;

    signal sec_counter : integer := 0;
    signal blink_counter : integer range 0 to 2 := 0;

    signal blink_flag : std_logic := '0';
    signal ped_request : std_logic := '0';

begin

    -- Divisor de frecuencia: genera 1Hz
    process(clk, rst)
    begin
        if rst = '1' then
            div_counter <= 0;
            clk_1Hz <= '0';
        elsif rising_edge(clk) then
            if div_counter = MAX_COUNT - 1 then
                div_counter <= 0;
                clk_1Hz <= not clk_1Hz;
            else
                div_counter <= div_counter + 1;
            end if;
        end if;
    end process;

    -- Registrar solicitud de peatón
    process(clk, rst)
    begin
        if rst = '1' then
            ped_request <= '0';
        elsif rising_edge(clk) then
            if btn_ped = '1' and current_state = S_INIT then
                ped_request <= '1';
            elsif current_state = S_INIT and ped_request = '1' then
                ped_request <= '0';
            end if;
        end if;
    end process;

    -- Maquina de estados
    process(clk_1Hz, rst)
    begin
        if rst = '1' then
            current_state <= S_INIT;
            sec_counter <= 0;
            blink_counter <= 0;
            blink_flag <= '0';
        elsif rising_edge(clk_1Hz) then
            current_state <= next_state;

            case current_state is
                when S_EO_BLINK_ON | S_EO_BLINK_OFF | S_NS_BLINK_ON | S_NS_BLINK_OFF =>
                    blink_flag <= not blink_flag;
                    if blink_flag = '1' then
                        if blink_counter = 2 then
                            blink_counter <= 0;
                        else
                            blink_counter <= blink_counter + 1;
                        end if;
                    end if;

                when others =>
                    sec_counter <= sec_counter + 1;
            end case;

            if current_state /= next_state then
                sec_counter <= 0;
                blink_flag <= '0';
            end if;
        end if;
    end process;

    -- Lógica de transición de estados
    process(current_state, ped_request, sec_counter, blink_counter, blink_flag)
    begin
        next_state <= current_state;
        case current_state is
            when S_INIT =>
                if ped_request = '1' then
                    next_state <= S_EO_BLINK_ON;
                end if;

            when S_EO_BLINK_ON =>
                if blink_flag = '1' then
                    next_state <= S_EO_BLINK_OFF;
                end if;

            when S_EO_BLINK_OFF =>
                if blink_flag = '1' then
                    if blink_counter = 2 then
                        next_state <= S_EO_YELLOW;
                    else
                        next_state <= S_EO_BLINK_ON;
                    end if;
                end if;

            when S_EO_YELLOW =>
                if sec_counter = 4 then
                    next_state <= S_EO_TO_NS_GREEN;
                end if;

            when S_EO_TO_NS_GREEN =>
                if sec_counter = 9 then
                    next_state <= S_NS_BLINK_ON;
                end if;

            when S_NS_BLINK_ON =>
                if blink_flag = '1' then
                    next_state <= S_NS_BLINK_OFF;
                end if;

            when S_NS_BLINK_OFF =>
                if blink_flag = '1' then
                    if blink_counter = 2 then
                        next_state <= S_NS_YELLOW;
                    else
                        next_state <= S_NS_BLINK_ON;
                    end if;
                end if;

            when S_NS_YELLOW =>
                if sec_counter = 4 then
                    next_state <= S_INIT;
                end if;

            when others =>
                next_state <= S_INIT;
        end case;
    end process;

    -- Salidas de semáforo
    eo_green  <= '1' when current_state = S_INIT else
                 '1' when current_state = S_EO_BLINK_ON and blink_flag = '1' else
                 '0';

    eo_yellow <= '1' when current_state = S_EO_YELLOW else '0';
    eo_red    <= '1' when current_state = S_EO_TO_NS_GREEN or current_state = S_NS_BLINK_ON or
                          current_state = S_NS_BLINK_OFF or current_state = S_NS_YELLOW else '0';

    ns_green  <= '1' when current_state = S_EO_TO_NS_GREEN else
                 '1' when current_state = S_NS_BLINK_ON and blink_flag = '1' else
                 '0';

    ns_yellow <= '1' when current_state = S_NS_YELLOW else '0';
    ns_red    <= '1' when current_state = S_INIT or current_state = S_EO_BLINK_ON or
                          current_state = S_EO_BLINK_OFF or current_state = S_EO_YELLOW else '0';

end architecture;
