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
            led         : out std_logic_vector (15 downto 0);
            seg         : out std_logic_vector (6 downto 0);
            dp          : out std_logic;
            an          : out std_logic_vector (3 downto 0));
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
    signal time_s       :   std_logic_vector (15 downto 0) := (others => '0');
    signal an_out       :   std_logic_vector (3 downto 0) := "1110";
    signal seg_out      :   std_logic_vector (6 downto 0) := ('0', others => '1');
    signal dp_out       :   std_logic := '0';
    signal seg_in       :   std_logic_vector (3 downto 0) := (others => '1');
    signal seg_counter  :   std_logic_vector (31 downto 0) := (others => '0');
    signal an_ph        :   std_logic_vector (1 downto 0) := "00";
    signal time_s_d0    :   std_logic_vector (3 downto 0) := (others => '1');
    signal time_s_d1    :   std_logic_vector (3 downto 0) := (others => '1');
    signal time_s_d2    :   std_logic_vector (3 downto 0) := (others => '1');
    signal time_s_d3    :   std_logic_vector (3 downto 0) := (others => '1');
    
    component sevenSegDecoderNumberToLed is
        Port    (   hexIn       : in std_logic_vector (3 downto 0);     -- Hex number to decode
                    segOut      : out std_logic_vector (6 downto 0)     -- 7-Seg LED, active low
                );
        end component;
    component sevenSegModule is
        Port (  hexIn0      : in std_logic_vector (3 downto 0);     -- Hex number to decode, rightmost
                hexIn1      : in std_logic_vector (3 downto 0);     -- Hex number to decode, second from right
                hexIn2      : in std_logic_vector (3 downto 0);     -- Hex number to decode, second from left
                hexIn3      : in std_logic_vector (3 downto 0);     -- Hex number to decode, leftmost
                clk         : in std_logic;
                dutyPeriod  : in std_logic_vector (31 downto 0);
                segOut      : out std_logic_vector (6 downto 0);     -- 7-Seg LED, active low
                anOut       : out std_logic_vector (3 downto 0)
                );
        end component;
begin
    reset <= btnC;
    led <= shifty_out;  
    an <= an_out;
    seg <= seg_out;   
    dp <= dp_out; 
    --segDecode : sevenSegDecoderNumberToLed port map (segOut => seg_out, hexIn => seg_in);
    segDrive : sevenSegModule port map (    hexIn0  => time_s_d0,
                                            hexIn1  => time_s_d1,
                                            hexIn2  => time_s_d2,
                                            hexIn3  => time_s_d3,
                                            clk     => clk_100Mhz,
                                            dutyPeriod => std_logic_vector(to_unsigned(500000, 32)),
                                            segOut => seg_out,
                                            anOut => an_out);

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
            time_s <= time_s + 1;
            time_s_d0 <= time_s_d0 + 1;
            if(time_s_d0 >= 9) then
                time_s_d0 <= (others => '0');
                time_s_d1 <= time_s_d1 + 1;
            end if;
            if(time_s_d1 >= 9) then
                time_s_d1 <= (others => '0');
                time_s_d2 <= time_s_d2 + 1;
            end if;
            if(time_s_d2 >= 9) then
                time_s_d2 <= (others => '0');
                time_s_d3 <= time_s_d3 + 1;
            end if;
            if(time_s_d3 >= 9) then
                time_s_d3 <= (others => '0');
            end if;
            --seg_out <= std_logic_vector(rotate_left(unsigned(seg_out), 1));
            --an_out <= std_logic_vector(rotate_right(unsigned(an_out), 1));
        else
            clk_enable <= '0';
            counter <= counter + 1;
        end if;
--        if(seg_counter >= 500000) then
--            seg_counter <= (others => '0');
--            an_out <= std_logic_vector(rotate_left(unsigned(an_out), 1));
--            an_ph <= an_ph + 1;
--            case an_out is
--                when "0111" =>
--                    seg_in <= time_s_d0;
--                when "1110" =>
--                    seg_in <= time_s_d1;
--                when "1101" =>
--                    seg_in <= time_s_d2;
--                when "1011" =>
--                    seg_in <= time_s_d3;
--                when others => 
--                    seg_in <= (others => '0');
--            end case;
--        else
--            seg_counter <= seg_counter + 1;
--        end if;
    end if;
    
end process;

--process(clk_100Mhz)
--begin
--    case seg_in is
--        when "0000" =>
--            seg_out <= "1000000";
--        when "0001" =>
--            seg_out <= "1111001";
--        when "0010" =>
--            seg_out <= "0100100";
--        when "0011" =>
--            seg_out <= "0110000";
--        when "0100" =>
--            seg_out <= "0011001";
--        when "0101" =>
--            seg_out <= "0010010";
--        when "0110" =>
--            seg_out <= "0000010";
--        when "0111" =>
--            seg_out <= "1111000";
--        when "1000" =>
--            seg_out <= "0000000";
--        when "1001" =>
--            seg_out <= "0011000";
--        when "1010" =>
--            seg_out <= "1111111";
--        when "1011" =>
--            seg_out <= "1111111";
--        when "1100" =>
--            seg_out <= "1111111";
--        when "1101" =>
--            seg_out <= "1111111";
--        when "1110" =>
--            seg_out <= "1111111";
--        when "1111" =>
--            seg_out <= "1111111";
--   end case;     
--end process;

process(clk_enable, clk_100Mhz, reset, sw) 
begin
    -- Behaviour of LED lights
    if(reset = '1') then
        shifty_reg <= (others => '0');
        shifty_out <= (others => '0');
    elsif(pause = '1') then
            shifty_out <= shifty_reg xor sw;
    elsif(rising_edge(clk_enable)) then
        if(direction = '0') then
            shifty_out <= std_logic_vector(rotate_left(unsigned(shifty_out), 1));
            shifty_reg <= std_logic_vector(rotate_left(unsigned(shifty_out), 1));
        elsif(direction = '1') then
            shifty_out <= std_logic_vector(rotate_right(unsigned(shifty_out), 1));
            shifty_reg <= std_logic_vector(rotate_right(unsigned(shifty_out), 1));
        end if;
    end if;
end process;

end Behavioral;
