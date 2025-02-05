library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_7seg is
    Generic ( SIMULATION_MODE : boolean := false );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end counter_7seg;

architecture Behavioral of counter_7seg is

    signal clk_1Hz : STD_LOGIC := '0';
    signal count : STD_LOGIC_VECTOR (3 downto 0) := "0000";

    -- Use a signal instead of a constant
    signal MAX_COUNT : integer;

    -- Counter for frequency division
    signal counter : integer := 0;

begin

    MAX_COUNT <= 50_000 when SIMULATION_MODE else 50_000_000;

    -- Frequency Divider Process
    process (clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            clk_1Hz <= '0';
        elsif rising_edge(clk) then
            if counter = MAX_COUNT - 1 then
                counter <= 0;
                clk_1Hz <= not clk_1Hz;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Counter Process (0 to 9)
    process (clk_1Hz, reset)
    begin
        if reset = '1' then
            count <= "0000";
        elsif rising_edge(clk_1Hz) then
            if count = "1001" then
                count <= "0000";
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    -- 7-Segment Decoder
    process(count)
    begin
        case count is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when others => seg <= "1111111"; -- Turn off display
        end case;
    end process;

    -- Activate Only One Digit (AN0)
    an <= "1110";

end Behavioral;
