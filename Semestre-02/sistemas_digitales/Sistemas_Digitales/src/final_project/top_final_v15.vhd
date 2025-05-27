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
use work.signboard_types.all;

entity top is
    Generic ( 
        MAX_COUNT : integer := 50_000_000
    );
    Port (
        clk     : in  STD_LOGIC;
        reset : in STD_LOGIC;
        PS2Data : in  STD_LOGIC;
        PS2Clk  : in  STD_LOGIC;
--        keycode_out : out STD_LOGIC_VECTOR(15 downto 0);
        seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display
        an : out STD_LOGIC_VECTOR (3 downto 0);
        btn_scroll : in STD_LOGIC;
        is_wait : out std_logic;
        is_store : out std_logic;
        is_scroll : out std_logic
    );
end top;

architecture Behavioral of top is

    signal start, cn, flag : STD_LOGIC := '0';
    signal keycode, keycodev : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal ascii_code : STD_LOGIC_VECTOR(7 downto 0);
    signal last_ascii_code : STD_LOGIC_VECTOR(7 downto 0);
    signal character_addr : std_logic_vector(5 downto 0);
    
    
    type signboard_characters_array is array (0 to 15) of STD_LOGIC_VECTOR(6 downto 0);
    type display_characters_array is array (0 to 3) of STD_LOGIC_VECTOR(6 downto 0);
    
    type char_array is array (0 to 15) of STD_LOGIC_VECTOR(6 downto 0); -- hasta 16 caracteres
    signal char_buffer : char_array := (others => (others => '1'));
    
    type letter_array is array (0 to 3) of STD_LOGIC_VECTOR(6 downto 0);
    signal display_characters: display_characters_array := ("1111111", "1111111", "1111111", "1111111");
    
     -- 4 digits multiplexor (~1ms refresh rate)
    signal refresh_counter : integer := 0;
    signal active_digit : integer range 0 to 3 := 0;
    signal char_value : STD_LOGIC_VECTOR(6 downto 0);
    signal new_key : STD_LOGIC_VECTOR(6 downto 0);
    
    -- FSM
    type state_type is (WAIT_KEY, STORE_CHAR, SCROLL);
    signal state : state_type := WAIT_KEY;
    
    -- Frequency Divider
--    signal scroll_clk : STD_LOGIC := '0';
    signal scroll_div : integer := 0;
    
    signal signboard_characters_position : integer range 0 to 15 := 0;
    -- Scroll parameters
    signal signboard_characters_scroll_position : integer range 0 to 15 := 0;
    signal signboard_characters_scroll_length : integer range 0 to 15 := 0;
    
    signal character_data : STD_LOGIC_VECTOR(6 downto 0) := "1111111";
    signal signboard_data : STD_LOGIC_VECTOR(6 downto 0) := "1111111";
    signal signboard_address : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal signboard_write_enable : STD_LOGIC := '0';
    signal read_ready : STD_LOGIC := '0';
    
    signal clk_1hz : STD_LOGIC := '0';
    signal clk_100hz : STD_LOGIC := '0';
    
    component frequency_divider is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk_1hz : out STD_LOGIC;
            clk_100hz : out STD_LOGIC
        );
    end component;
    
    component PS2Receiver is
        Port (
            clk     : in  STD_LOGIC;
            kclk    : in  STD_LOGIC;
            kdata   : in  STD_LOGIC;
            keycode : out STD_LOGIC_VECTOR(15 downto 0);
            oflag   : out STD_LOGIC
        );
    end component;
    
    component characters_memory is
        Port (
            ADDR : in std_logic_vector(5 downto 0);
            DATA : out std_logic_vector(6 downto 0)
        );
    end component;
    
    component signboard_memory is
        Port (
            clk : in STD_LOGIC;
            address : in STD_LOGIC_VECTOR (3 downto 0);
            data_in : in  STD_LOGIC_VECTOR (6 downto 0);
            write_enable : in STD_LOGIC;
            read_enable : in STD_LOGIC;
            data_out :  out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    component process_keycode is
        Port (
            clk : in STD_LOGIC;
            keycode : in STD_LOGIC_VECTOR(15 downto 0);
            keycodev : inout STD_LOGIC_VECTOR(15 downto 0);
            flag : in STD_LOGIC;
            cn : out STD_LOGIC;
            start : out STD_LOGIC;
            ascii_code : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    component index_decoder_to_characters_memory is
        Port (
            ascii_code : in STD_LOGIC_VECTOR(7 downto 0);
            character_address : out STD_LOGIC_VECTOR(5 downto 0));
    end component;
    
    component signboard_display is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            display_characters : in display_characters_array;
            anodos : out STD_LOGIC_VECTOR(3 downto 0);
            segments : out STD_LOGIC_VECTOR(6 downto 0));
    end component;

begin
    -- Frequency Divider Process
--    process(clk, reset)
--    begin
--        if reset = '1' then
--            scroll_div <= 0;
--            scroll_clk <= '0';
--        elsif rising_edge(clk) then
--            if scroll_div = MAX_COUNT then
--                scroll_div <= 0;
--                scroll_clk <= not scroll_clk;
--            else
--                scroll_div <= scroll_div + 1;
--            end if;
--        end if;
--    end process;

    frequency_divider_inst : frequency_divider
        port map (
            clk => clk,
            reset => reset,
            clk_1hz => clk_1hz,
            clk_100hz => clk_100hz
        );

    PS2_Receiver_inst : PS2Receiver
        port map (
            clk     => clk,
            kclk    => PS2Clk,
            kdata   => PS2Data,
            keycode => keycode,
            oflag   => flag
        );
        
    process_keycode_insta : process_keycode
        port map (
            clk => clk,
            keycode => keycode,
            keycodev => keycodev,
            flag => flag,
            cn => cn,
            start => start,
            ascii_code => ascii_code
        );
    
    index_decoder_to_characters_memory_insta : index_decoder_to_characters_memory
        port map (
            ascii_code => ascii_code,
            character_address => character_addr
        );
   
    characters_memory_inst : characters_memory
        port map (
            ADDR => character_addr,
            DATA => new_key
        );
        
    signboard_memory_inst : signboard_memory
        port map (
            clk => clk,
            address => signboard_address,
            data_in => character_data,
            write_enable => signboard_write_enable,
            read_enable => btn_scroll,
            data_out =>  signboard_data
        );
    
    -- Scrolling Message Process
    process (clk, reset)
        variable temp_display_characters : display_characters_array;
        variable temp_char_buffer : char_array;
    begin
        if reset = '1' then
            signboard_characters_position <= 0;
            signboard_characters_scroll_position <= 0;
            signboard_characters_scroll_length <= 0;
            signboard_address <= "0000";
--            signboard_data <= "1111111";
            
            temp_display_characters := (others => (others => '1'));
            display_characters <= temp_display_characters;
            
--            temp_char_buffer := (others => (others => '1'));
--            char_buffer <= temp_char_buffer;
            
            last_ascii_code <= "11111111";
            
            state <= WAIT_KEY;
            
            scroll_div <= 0;
        elsif rising_edge(clk) then
            temp_display_characters := display_characters;
            case state is
                when WAIT_KEY =>
                    if start = '1' then
                        state <= STORE_CHAR;
                    elsif btn_scroll = '1' then
                        state <= SCROLL;
                        signboard_characters_scroll_position <= 0;
                        signboard_address <= "0000";
--                        signboard_data <= "1111111";
                        temp_display_characters := ("1111111", "1111111", "1111111", "1111111");
                    end if;
                when STORE_CHAR =>
                    if signboard_characters_position <= 15 then
                        last_ascii_code <= ascii_code;
                        signboard_write_enable <= '0';
                        
                        if keycodev(7 downto 0) = x"5A" and ascii_code /= last_ascii_code then -- ENTER key released
--                            char_buffer(signboard_characters_position) <= temp_display_characters(0);
                            character_data <= temp_display_characters(0);
                            signboard_write_enable <= '1';
                            signboard_address <= std_logic_vector(to_unsigned(signboard_characters_position, signboard_address'length));
                            
                            temp_display_characters(3) := temp_display_characters(2);
                            temp_display_characters(2) := temp_display_characters(1);
                            temp_display_characters(1) := temp_display_characters(0);
                            temp_display_characters(0) := "1111111";
                            
                            signboard_characters_position <= signboard_characters_position + 1;
                            signboard_characters_scroll_length <= signboard_characters_scroll_length + 1;
                        else
                            temp_display_characters(0) := new_key;
                        end if;
                        
                        state <= WAIT_KEY;
                        
                        if btn_scroll = '1' then
                            state <= SCROLL;
                        end if;
                     else
                        signboard_characters_position <= 0;
                     end if;
                when SCROLL =>
                    if scroll_div = MAX_COUNT then
                        scroll_div <= 0;
                        
                        if read_ready = '1' then
                            -- Aquí ya leíste el dato válido del ciclo anterior
                            temp_display_characters(3) := temp_display_characters(2);
                            temp_display_characters(2) := temp_display_characters(1);
                            temp_display_characters(1) := temp_display_characters(0);
                            temp_display_characters(0) := signboard_data;
                
                            signboard_characters_scroll_position <= signboard_characters_scroll_position + 1;
                
                            if signboard_characters_scroll_position = signboard_characters_scroll_length - 1 then
                                signboard_characters_scroll_position <= 0;
                                signboard_address <= "0000";
                            else
                                signboard_address <= std_logic_vector(to_unsigned(signboard_characters_scroll_position, signboard_address'length));
                            end if;
                
                            read_ready <= '0'; -- Ya usamos el dato
                        else
                            -- Prepara la lectura del siguiente carácter
                            signboard_address <= std_logic_vector(to_unsigned(signboard_characters_scroll_position, signboard_address'length));
                            read_ready <= '1'; -- En el siguiente ciclo se usará el dato
                        end if;
                    else
                       scroll_div <= scroll_div + 1; 
                    end if;
                    if btn_scroll = '0' then
                        state <= WAIT_KEY;
                    end if;
            end case;

            display_characters <= temp_display_characters;
        end if;
    end process;
    
    signboard_display_inst : signboard_display
        port map (
            clk => clk,
            reset => reset,
            display_characters => display_characters,
            anodos => an,
            segments => seg
        );
    
    process(state)
    begin
        case state is
            when WAIT_KEY =>
                is_wait <= '1';
                is_store <= '0';
                is_scroll <= '0';
            when STORE_CHAR =>
                is_wait <= '0';
                is_store <= '1';
                is_scroll <= '0';
            when SCROLL =>
                is_wait <= '0';
                is_store <= '0';
                is_scroll <= '1';
         end case;
    end process;

end Behavioral;