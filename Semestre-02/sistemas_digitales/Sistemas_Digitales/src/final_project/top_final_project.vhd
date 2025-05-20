----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2025 18:25:06
-- Design Name: 
-- Module Name: ds_final_project_final_version - Behavioral
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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port (
        clk     : in  STD_LOGIC;
        PS2Data : in  STD_LOGIC;
        PS2Clk  : in  STD_LOGIC;
        tx      : out STD_LOGIC;
        keycode_out : out STD_LOGIC_VECTOR(15 downto 0);
        seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display
        an : out STD_LOGIC_VECTOR (3 downto 0)
    );
end top;

architecture Behavioral of top is

    signal tready, ready, tstart, start, cn, flag : STD_LOGIC := '0';
    signal CLK50MHZ : STD_LOGIC := '0';
    signal tbuf : STD_LOGIC_VECTOR(31 downto 0);
    signal tbus : STD_LOGIC_VECTOR(7 downto 0);
    signal keycode, keycodev : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal bcount : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal ascii_code : STD_LOGIC_VECTOR(7 downto 0);

    component PS2Receiver is
        Port (
            clk     : in  STD_LOGIC;
            kclk    : in  STD_LOGIC;
            kdata   : in  STD_LOGIC;
            keycode : out STD_LOGIC_VECTOR(15 downto 0);
            oflag   : out STD_LOGIC
        );
    end component;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            CLK50MHZ <= not CLK50MHZ;
        end if;
    end process;

    PS2_Receiver_inst : PS2Receiver
        port map (
            clk     => CLK50MHZ,
            kclk    => PS2Clk,
            kdata   => PS2Data,
            keycode => keycode,
            oflag   => flag
        );

    process(keycode)
    begin
        if keycode(7 downto 0) = x"F0" then
            cn <= '0';
            bcount <= "000";
        elsif keycode(15 downto 8) = x"F0" then
            if keycode /= keycodev then
                cn <= '1';
            else
                cn <= '0';
            end if;
            bcount <= "101";
        else
            if (keycode(7 downto 0) /= keycodev(7 downto 0)) or (keycodev(15 downto 8) = x"F0") then
                cn <= '1';
            else
                cn <= '0';
            end if;
            bcount <= "010";
        end if;
        keycode_out <= keycodev;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if flag = '1' and cn = '1' then
                start <= '1';
                keycodev <= keycode;
            else
                start <= '0';
            end if;
        end if;
    end process;

    -- Extraer solo el byte del código ASCII (cuando no es F0)
    ascii_code <= keycodev(7 downto 0);

    -- Mapeo simple de algunas letras en ASCII (puedes expandir esto)
    process(ascii_code)
    begin
        case ascii_code is
            -- Letters (A-Z)
            when x"1C" => seg <= "0001000"; -- A
            when x"32" => seg <= "0000011"; -- B
            when x"21" => seg <= "1000110"; -- C
            when x"23" => seg <= "0100001"; -- D
            when x"24" => seg <= "0000110"; -- E
            when x"2B" => seg <= "0001110"; -- F
            when x"34" => seg <= "0010000"; -- G
            when x"33" => seg <= "0001001"; -- H
            when x"43" => seg <= "1100110"; -- I
            when x"3B" => seg <= "1100001"; -- J
            when x"42" => seg <= "0000101"; -- K
            when x"4B" => seg <= "1000111"; -- L
            when x"3A" => seg <= "1001000"; -- M
            when x"31" => seg <= "0101011"; -- N
            when x"44" => seg <= "1000000"; -- O
            when x"4D" => seg <= "0001100"; -- P
            when x"15" => seg <= "0011000"; -- Q
            when x"2D" => seg <= "0101111"; -- R
            when x"1B" => seg <= "0010010"; -- S
            when x"2C" => seg <= "0000111"; -- T
            when x"3C" => seg <= "1100011"; -- U
            when x"2A" => seg <= "1000001"; -- V
            when x"1D" => seg <= "1100010"; -- W
            when x"22" => seg <= "0001111"; -- X
            when x"35" => seg <= "0010001"; -- Y
            when x"1A" => seg <= "0110110"; -- Z
            -- Numbers (0-9)
            when x"45" => seg <= "1000000"; -- 0
            when x"16" => seg <= "1111001"; -- 1
            when x"1E" => seg <= "0100100"; -- 2
            when x"26" => seg <= "0110000"; -- 3
            when x"25" => seg <= "0011001"; -- 4
            when x"2E" => seg <= "0010010"; -- 5
            when x"36" => seg <= "0000010"; -- 6
            when x"3D" => seg <= "1111000"; -- 7
            when x"3E" => seg <= "0000000"; -- 8
            when x"46" => seg <= "0011000"; -- 9
            -- Special keys
            when x"4E" => seg <= "0111111"; -- "-"
            -- Others
            when others => seg <= "1111111"; -- (Blank)
        end case;

        an <= "1110";
    end process;

end Behavioral;