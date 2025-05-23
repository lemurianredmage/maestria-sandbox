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
    Generic ( 
        MAX_COUNT : integer := 50_000_000;
        MAX_COUNT_50_MHZ : integer := 15
    );
    Port (
        clk     : in  STD_LOGIC;
        PS2Data : in  STD_LOGIC;
        PS2Clk  : in  STD_LOGIC;
        tx      : out STD_LOGIC;
--        keycode_out : out STD_LOGIC_VECTOR(15 downto 0);
        seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display
        an : out STD_LOGIC_VECTOR (3 downto 0);
        btn_scroll : in STD_LOGIC
    );
end top;

architecture Behavioral of top is

    signal tready, ready, tstart, start, cn, flag : STD_LOGIC := '0';
    signal CLK50MHZ : STD_LOGIC := '0';
    signal clk_scroll : STD_LOGIC := '0';           -- Scrolling clock
    signal tbuf : STD_LOGIC_VECTOR(31 downto 0);
    signal tbus : STD_LOGIC_VECTOR(7 downto 0);
    signal keycode, keycodev : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal bcount : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal ascii_code : STD_LOGIC_VECTOR(7 downto 0);
    
    
    type char_array is array (0 to 15) of STD_LOGIC_VECTOR(6 downto 0); -- hasta 16 caracteres
    signal char_buffer : char_array := (others => (others => '1'));
    signal position : integer range 0 to 15 := 0;
    
    type letter_array is array (0 to 3) of STD_LOGIC_VECTOR(6 downto 0);
    signal letters: letter_array := ("1111111", "1111111", "1111111", "1111111");
    
    -- Frequency Divider
    signal counter : integer := 0;
    signal counter_50MHZ : integer := 0;
    
     -- 4 digits multiplexor (~1ms refresh rate)
    signal refresh_counter : integer := 0;
    signal active_digit : integer range 0 to 3 := 0;
    signal char_value : STD_LOGIC_VECTOR(6 downto 0);
    signal new_key : STD_LOGIC_VECTOR(6 downto 0);
    
    -- FSM
    type state_type is (WAIT_KEY, STORE_CHAR, SCROLL);
    signal state : state_type := WAIT_KEY;
    
    signal scroll_cnt : integer range 0 to 3 := 0;
    signal scroll_clk : STD_LOGIC := '0';
    signal scroll_div : integer := 0;


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
            scroll_div <= scroll_div + 1;
            
            if counter_50MHZ >= MAX_COUNT_50_MHZ - 1 then
                counter_50MHZ <= 0;
                CLK50MHZ <= not CLK50MHZ;
            elsif scroll_div >= 500_000 then
                scroll_div <= 0;
                scroll_clk <= not scroll_clk;
            else
                counter_50MHZ <= counter_50MHZ + 1;
            end if;
        end if;
    end process;
    
    -- Frequency Divider Process
    process (clk)
    begin
        if rising_edge(clk) then
            if counter = MAX_COUNT - 1 then
                counter <= 0;
                clk_scroll <= not clk_scroll;       -- Toggle to create scroll effect
            else
                counter <= counter + 1;
            end if;
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
        elsif keycode(15 downto 8) = x"F0" then
            if keycode /= keycodev then
                cn <= '1';
            else
                cn <= '0';
            end if;
        else
            if (keycode(7 downto 0) /= keycodev(7 downto 0)) or (keycodev(15 downto 8) = x"F0") then
                cn <= '1';
            else
                cn <= '0';
            end if;
        end if;
--        keycode_out <= keycodev;
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
    
    -- 7-Segment Decoder
    process(ascii_code)
    begin
        case ascii_code is
            -- Letters (A-Z)
            when x"1C" => new_key <= "0001000"; -- A
            when x"32" => new_key <= "0000011"; -- B
            when x"21" => new_key <= "1000110"; -- C
            when x"23" => new_key <= "0100001"; -- D
            when x"24" => new_key <= "0000110"; -- E
            when x"2B" => new_key <= "0001110"; -- F
            when x"34" => new_key <= "0010000"; -- G
            when x"33" => new_key <= "0001001"; -- H
            when x"43" => new_key <= "1100110"; -- I
            when x"3B" => new_key <= "1100001"; -- J
            when x"42" => new_key <= "0000101"; -- K
            when x"4B" => new_key <= "1000111"; -- L
            when x"3A" => new_key <= "1001000"; -- M
            when x"31" => new_key <= "0101011"; -- N
            when x"44" => new_key <= "1000000"; -- O
            when x"4D" => new_key <= "0001100"; -- P
            when x"15" => new_key <= "0011000"; -- Q
            when x"2D" => new_key <= "0101111"; -- R
            when x"1B" => new_key <= "0010010"; -- S
            when x"2C" => new_key <= "0000111"; -- T
            when x"3C" => new_key <= "1100011"; -- U
            when x"2A" => new_key <= "1000001"; -- V
            when x"1D" => new_key <= "1100010"; -- W
            when x"22" => new_key <= "0001111"; -- X
            when x"35" => new_key <= "0010001"; -- Y
            when x"1A" => new_key <= "0110110"; -- Z
            -- Numbers (0-9)
            when x"45" => new_key <= "1000000"; -- 0
            when x"16" => new_key <= "1111001"; -- 1
            when x"1E" => new_key <= "0100100"; -- 2
            when x"26" => new_key <= "0110000"; -- 3
            when x"25" => new_key <= "0011001"; -- 4
            when x"2E" => new_key <= "0010010"; -- 5
            when x"36" => new_key <= "0000010"; -- 6
            when x"3D" => new_key <= "1111000"; -- 7
            when x"3E" => new_key <= "0000000"; -- 8
            when x"46" => new_key <= "0011000"; -- 9
            -- Special keys
            when x"4E" => new_key <= "0111111"; -- "-"
            -- Others
            when others => new_key <= "1111111"; -- (Blank)
        end case;
    end process;
    
    -- Scrolling Message Process
--    process (clk)
--        variable temp_letters : letter_array;
--    begin
--        if rising_edge(clk) then
--            if flag = '1' and cn = '1' then
--                if position <= 15 then
--                    char_buffer(position) <= new_key;
                    
--                    temp_letters := letters;
--                    temp_letters(3) := temp_letters(2);
--                    temp_letters(2) := temp_letters(1);
--                    temp_letters(1) := temp_letters(0);
--                    temp_letters(0) := char_buffer(position);
                    
--                    position <= position + 1;
                    
--                    letters <= temp_letters;
--                end if;
--            end if;
--        end if;
--    end process;

    process (clk)
        variable temp_letters : letter_array;
    begin
        if rising_edge(clk) then
            temp_letters := letters;
            case state is
                when WAIT_KEY =>
                    if start = '1' then
                        state <= STORE_CHAR;
                    elsif btn_scroll = '1' then
                        state <= SCROLL;
                    end if;
                when STORE_CHAR =>
                    temp_letters(3) := temp_letters(2);
                    temp_letters(2) := temp_letters(1);
                    temp_letters(1) := temp_letters(0);
                    temp_letters(0) := new_key;
                    state <= WAIT_KEY;
                    
                    if btn_scroll = '1' then
                        state <= SCROLL;
                    end if;
                when SCROLL =>
                    if scroll_clk = '1' then
                        temp_letters := temp_letters(1 to 3) & temp_letters(0);
                    end if;
                    if btn_scroll = '0' then
                        state <= WAIT_KEY;
                    end if;
                when others =>
                    state <= WAIT_KEY;
            end case;

            letters <= temp_letters;
        end if;
    end process;
    
    -- 4-digit multiplexer
    process (clk)
    begin
        if rising_edge(clk) then
            if refresh_counter = 12499 then  -- Change digits at ~1ms
                refresh_counter <= 0;
                if active_digit = 3 then
                    active_digit <= 0;
                else
                    active_digit <= active_digit + 1;
                end if;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;
    
    -- Select digit to show
    process (active_digit, letters)
    begin
        case active_digit is
            when 0 => char_value <= letters(0);
            when 1 => char_value <= letters(1);
            when 2 => char_value <= letters(2);
            when 3 => char_value <= letters(3);
            when others => char_value <= "1111111";
        end case;
    end process;

    -- 7-Segment Decoder
    process(char_value)
    begin
        seg <= char_value;
    end process;

    -- Activate Only One Digit at a Time (Cyclic Scrolling)
    process (clk)
    begin
        case active_digit mod 4 is
            when 0 => an <= "1110";         -- 1st digit active
            when 1 => an <= "1101";         -- 2nd digit active
            when 2 => an <= "1011";         -- 3rd digit active
            when 3 => an <= "0111";         -- 4th digit active
            when others => an <= "1111";    -- Default (All Off)
        end case;
    end process;

end Behavioral;