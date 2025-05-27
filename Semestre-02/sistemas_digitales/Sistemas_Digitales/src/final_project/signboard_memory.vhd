----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.05.2025 22:47:58
-- Design Name: 
-- Module Name: signboard_memory - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity signboard_memory is
    Port (
            clk : in STD_LOGIC;
            address : in STD_LOGIC_VECTOR (3 downto 0);
            data_in : in  STD_LOGIC_VECTOR (6 downto 0);
            write_enable : in STD_LOGIC;
            read_enable : in STD_LOGIC;
            data_out :  out STD_LOGIC_VECTOR (6 downto 0)
          );
end signboard_memory;

architecture Behavioral of signboard_memory is
    type signboard_array is array (0 to 15) of STD_LOGIC_VECTOR(6 downto 0);
    signal signboard_data : signboard_array := ( others => (others => '1') );
    signal selected_data_out : STD_LOGIC_VECTOR(6 downto 0) := (others => '1');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if write_enable = '1' then
                signboard_data(to_integer(unsigned(address))) <= data_in;
            end if;
            
            if read_enable = '1' then
                selected_data_out <= signboard_data(to_integer(unsigned(address)));
            end if;
        end if;
    end process;
    data_out <= selected_data_out when read_enable = '1' else (others => '1');
end Behavioral;
