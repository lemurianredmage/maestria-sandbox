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
        clk     : in STD_LOGIC;
        vp_in   : in STD_LOGIC;
        vn_in   : in STD_LOGIC;
        seg     : out STD_LOGIC_VECTOR (6 downto 0);
        an      : out STD_LOGIC_VECTOR (3 downto 0)
    );
end top_level;

architecture Structural of top_level is

    signal adc_data    : STD_LOGIC_VECTOR(15 downto 0);
    signal data_ready  : STD_LOGIC;
    signal bcd_out     : STD_LOGIC_VECTOR(15 downto 0);

    component xadc_wiz_0
        port (
            daddr_in : in STD_LOGIC_VECTOR (6 downto 0);
            dclk_in  : in STD_LOGIC;
            den_in   : in STD_LOGIC;
            di_in    : in STD_LOGIC_VECTOR (15 downto 0);
            dwe_in   : in STD_LOGIC;
            do_out   : out STD_LOGIC_VECTOR (15 downto 0);
            drdy_out : out STD_LOGIC;
            vp_in    : in STD_LOGIC;
            vn_in    : in STD_LOGIC
        );
    end component;

    -- Instancias de otros componentes (bin_to_bcd, display_driver, etc.)
    -- se declararían aquí

begin

    U_ADC : xadc_wiz_0
        port map (
            daddr_in => "0000000",  -- dirección para canal A0 (VP/VN)
            dclk_in  => clk,
            den_in   => '1',
            dwe_in   => '0',
            di_in    => (others => '0'),
            do_out   => adc_data,
            drdy_out => data_ready,
            vp_in    => vp_in,
            vn_in    => vn_in
        );

    -- Instancias de conversión binaria y display se agregarían aquí

end Structural;