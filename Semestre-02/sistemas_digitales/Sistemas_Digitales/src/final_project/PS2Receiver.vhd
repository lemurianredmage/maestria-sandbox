----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2025 20:42:43
-- Design Name: 
-- Module Name: PS2Receiver - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PS2Receiver is
    Port (
        clk      : in  STD_LOGIC;
        kclk     : in  STD_LOGIC;
        kdata    : in  STD_LOGIC;
        keycode  : out STD_LOGIC_VECTOR(15 downto 0);
        oflag    : out STD_LOGIC
    );
end PS2Receiver;

architecture Behavioral of PS2Receiver is

    signal kclkf, kdataf : STD_LOGIC;
    signal datacur, dataprev : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal cnt : unsigned(3 downto 0) := (others => '0');
    signal flag, pflag : STD_LOGIC := '0';
    signal keycode_reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal oflag_reg : STD_LOGIC := '0';

    component debouncer is
        Generic (
            COUNT_MAX   : integer := 19;
            COUNT_WIDTH : integer := 5
        );
        Port (
            clk : in  STD_LOGIC;
            I   : in  STD_LOGIC;
            O   : out STD_LOGIC
        );
    end component;

begin

    oflag <= oflag_reg;
    keycode <= keycode_reg;

    db_clk : debouncer
        generic map (
            COUNT_MAX => 19,
            COUNT_WIDTH => 5
        )
        port map (
            clk => clk,
            I   => kclk,
            O   => kclkf
        );

    db_data : debouncer
        generic map (
            COUNT_MAX => 19,
            COUNT_WIDTH => 5
        )
        port map (
            clk => clk,
            I   => kdata,
            O   => kdataf
        );

    -- Shift in bits from PS/2
    process(kclkf)
    begin
        if falling_edge(kclkf) then
            case cnt is
                when "0001" => datacur(0) <= kdataf;
                when "0010" => datacur(1) <= kdataf;
                when "0011" => datacur(2) <= kdataf;
                when "0100" => datacur(3) <= kdataf;
                when "0101" => datacur(4) <= kdataf;
                when "0110" => datacur(5) <= kdataf;
                when "0111" => datacur(6) <= kdataf;
                when "1000" => datacur(7) <= kdataf;
                when "1001" => flag <= '1';
                when "1010" => flag <= '0';
                when others => null;
            end case;

            if cnt <= "1001" then
                cnt <= cnt + 1;
            elsif cnt = "1010" then
                cnt <= (others => '0');
            end if;
        end if;
    end process;

    -- Output keycode and flag
    process(clk)
    begin
        if rising_edge(clk) then
            if flag = '1' and pflag = '0' then
                keycode_reg <= dataprev & datacur;
                oflag_reg <= '1';
                dataprev <= datacur;
            else
                oflag_reg <= '0';
            end if;
            pflag <= flag;
        end if;
    end process;

end Behavioral;

