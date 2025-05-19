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
        keycode_out : out STD_LOGIC_VECTOR(15 downto 0)
    );
end top;

architecture Behavioral of top is

    signal tready, ready, tstart, start, cn, flag : STD_LOGIC := '0';
    signal CLK50MHZ : STD_LOGIC := '0';
    signal tbuf : STD_LOGIC_VECTOR(31 downto 0);
    signal tbus : STD_LOGIC_VECTOR(7 downto 0);
    signal keycode, keycodev : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal bcount : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');

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
        
        keycode_out <= keycode;
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

end Behavioral;
