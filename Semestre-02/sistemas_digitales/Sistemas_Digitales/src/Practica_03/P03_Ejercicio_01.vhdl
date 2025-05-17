----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2025 22:11:44
-- Design Name: 
-- Module Name: ds_practice_3 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity top_level is
    Port (
        rst, clk : in STD_LOGIC;
        sw       : in STD_LOGIC;
        led      : out STD_LOGIC_VECTOR(15 downto 0);
        ja       : in STD_LOGIC_VECTOR(7 downto 0);
        seg      : out STD_LOGIC_VECTOR (7 downto 0);
        an       : out STD_LOGIC_VECTOR (3 downto 0)
    );
end top_level;

architecture Behavioral of top_level is

    component xadc_wiz_0
        port (
            daddr_in  : in STD_LOGIC_VECTOR (6 downto 0);
            den_in   : in STD_LOGIC;
            di_in : in STD_LOGIC_VECTOR (15 downto 0);
            dwe_in   : in STD_LOGIC;
            do_out   : out STD_LOGIC_VECTOR (15 downto 0);
            drdy_out : out STD_LOGIC;
            dclk_in  : in STD_LOGIC;
            reset_in : in STD_LOGIC;
            vauxp5   : in STD_LOGIC;
            vauxn5   : in STD_LOGIC;
            user_temp_alarm_out : out STD_LOGIC;
            ot_out: out std_logic;
            busy_out : out STD_LOGIC;
            channel_out : STD_LOGIC_VECTOR (4 downto 0);
            eoc_out : out STD_LOGIC;
            eos_out : out STD_LOGIC;
            alarm_out : out STD_LOGIC;
            vp_in    : in STD_LOGIC;
            vn_in    : in STD_LOGIC
        );
    end component;

    component display
        port (
            clk, rst : in STD_LOGIC;
            voltage_mV : in integer range 0 to 3300;
            an : out STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(7 downto 0)
        );
     end component;

signal channel_out : STD_LOGIC_VECTOR (4 downto 0);
signal daddr_in  : STD_LOGIC_VECTOR (6 downto 0);
signal eoc_out : STD_LOGIC;
signal do_out   : STD_LOGIC_VECTOR (15 downto 0);
signal vauxp5, vauxn5   : STD_LOGIC;
signal dec_out : integer range 0 to 65535 := 0;
signal voltage_mV : integer range 0 to 3300 := 0;


begin

    insta_display : display
    port map (
        clk => clk,
        rst  => rst,
        voltage_mV   => voltage_mV,
        an   => an,
        seg  => seg
    );
 
    insta_xadc : xadc_wiz_0
    port map (
        daddr_in  => daddr_in,
        den_in   => eoc_out,
        di_in => "0000000000000000",
        dwe_in => '0',
        do_out   => do_out,
        drdy_out => open,
        dclk_in  => clk,
        reset_in => sw,
        vauxp5   => vauxp5,
        vauxn5   => vauxn5,
        busy_out => open,
        channel_out => channel_out,
        eoc_out => eoc_out,
        eos_out => open,
        alarm_out => open,
        vp_in    => '0',
        vn_in    => '0'
    );

    process(clk, rst)
        variable raw_value : integer range 0 to 65535;
    begin
        if rst = '1' then
            dec_out <= 0;
            voltage_mV <= 0;
        elsif rising_edge(clk) then
            if eoc_out = '1' then
                raw_value := to_integer(unsigned(do_out(15 downto 4)));
                voltage_mV <= (raw_value * 1000) / 4096;
            end if;
        end if;
     end process;
     
          daddr_in <= "00" & channel_out;
          vauxp5 <= ja(4);
          vauxn5 <= ja(0);
          led <= do_out;
end Behavioral;