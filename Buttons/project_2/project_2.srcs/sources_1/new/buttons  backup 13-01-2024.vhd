----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2023 23:16:12
-- Design Name: 
-- Module Name: buttons - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buttons is
  Port (    clk_100Mhz  : in std_logic;
            btnC        : in std_logic;
            btnU        : in std_logic;
            btnD        : in std_logic;
            btnL        : in std_logic;
            btnR        : in std_logic;
            sw          : in std_logic_vector (15 downto 0);
            led         : out std_logic_vector (15 downto 0));
end buttons;

architecture Behavioral of buttons is
    signal reset        :   std_logic;
    signal pause        :   std_logic;
    signal shifty_reg   :   std_logic_vector (15 downto 0);
    signal shifty_out   :   std_logic_vector (15 downto 0);   
    signal sw_in        :   std_logic_vector (15 downto 0);  
    signal sw_out       :   std_logic_vector (15 downto 0); 
    signal sw_flag      :   std_logic ;
    signal counter      :   std_logic_vector (31 downto 0);
    signal direction    :   std_logic;
    signal reset_counter:   std_logic;
    signal clk_enable   :   std_logic;
    signal sw_reg       :   std_logic_vector (15 downto 0);
    signal reset_clk    :   std_logic;
begin
    reset <= btnC;
    led <= shifty_out;      

process(clk_100Mhz, reset, reset_clk)
begin
    -- Store value of pause
    if(rising_edge(clk_100Mhz)) then
        if(btnD = '1') then
            pause <= '1';
        elsif(btnU = '1') then
            pause <= '0';
        end if;
    end if;
    
    -- Store value of direction
    if(rising_edge(clk_100Mhz)) then
        if(btnL = '1') then
            direction <= '0';
        elsif(btnR = '1') then
            direction <= '1';    
        end if;
    end if;
    
    -- 1 second clock
    if(reset = '1') then
        counter <= (others => '0');
    elsif(rising_edge(clk_100Mhz)) then
        if(counter >= 100000000) then
            clk_enable <= '1';
            counter <= (others => '0');
        else
            clk_enable <= '0';
            counter <= counter + 1;
        end if;
    end if;
end process;

process(clk_enable, clk_100Mhz, reset, sw) 
begin
    -- Behaviour of LED lights
    if(reset = '1') then
        shifty_reg <= (others => '0');
    else
        if(pause = '1') then
            shifty_out <= shifty_reg xor sw;
        end if;
        --if(rising_edge(clk_100Mhz)) then
        --    shifty_reg <= shifty_out;
        --end if;
    end if;
    
    if(reset = '1') then
        shifty_out <= (others => '0');
    elsif(rising_edge(clk_enable)) then
        if(pause = '1') then
            if(btnL = '1' and btnR = '0') then
                shifty_out <= std_logic_vector(rotate_left(unsigned(shifty_out), 1));
                shifty_reg <= std_logic_vector(rotate_left(unsigned(shifty_out), 1));
            elsif(btnR = '1' and btnL = '0') then
                shifty_out <= std_logic_vector(rotate_right(unsigned(shifty_out), 1));
                shifty_reg <= std_logic_vector(rotate_right(unsigned(shifty_out), 1));
            end if;
        elsif(pause = '0') then
            if(direction = '0') then
                shifty_out <= std_logic_vector(rotate_left(unsigned(shifty_out), 1));
                shifty_reg <= std_logic_vector(rotate_left(unsigned(shifty_out), 1));
            elsif(direction = '1') then
                shifty_out <= std_logic_vector(rotate_right(unsigned(shifty_out), 1));
                shifty_reg <= std_logic_vector(rotate_right(unsigned(shifty_out), 1));
            end if;
            --shifty_reg <= shifty_out;
        else
            
        end if;
    end if;
end process;

end Behavioral;
