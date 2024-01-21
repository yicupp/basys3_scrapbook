----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.01.2024 21:44:42
-- Design Name: 
-- Module Name: sevenSegModule - Behavioral
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
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenSegModule is
    Port (  hexIn0      : in std_logic_vector (3 downto 0);     -- Hex number to decode, rightmost
            hexIn1      : in std_logic_vector (3 downto 0);     -- Hex number to decode, second from right
            hexIn2      : in std_logic_vector (3 downto 0);     -- Hex number to decode, second from left
            hexIn3      : in std_logic_vector (3 downto 0);     -- Hex number to decode, leftmost
            clk         : in std_logic;
            dutyPeriod  : in std_logic_vector (31 downto 0);
            segOut      : out std_logic_vector (6 downto 0);     -- 7-Seg LED, active low
            anOut       : out std_logic_vector (3 downto 0)
    );
end sevenSegModule;

architecture Behavioral of sevenSegModule is
    component sevenSegDecoderNumberToLed is
        Port    (   hexIn       : in std_logic_vector (3 downto 0);     -- Hex number to decode
                    segOut      : out std_logic_vector (6 downto 0)     -- 7-Seg LED, active low
                );
        end component;
    
    signal  digitPhase  : std_logic_vector (3 downto 0) := "1110";
    signal  dutyCounter : std_logic_vector (31 downto 0) := (others => '0');
    signal  hexDecodeIn : std_logic_vector (3 downto 0);
    
begin
    segDecode : sevenSegDecoderNumberToLed port map (segOut => segOut, hexIn => hexDecodeIn);
    anOut <= digitPhase;
    
    -- Input to the decoder depends on which digit's turn it is to display
    with digitPhase select
        hexDecodeIn <= hexIn0 when "1110",
                       hexIn1 when "1101",
                       hexIn2 when "1011",
                       hexIn3 when "0111",
                       "1111" when others;
                       
    -- Timer to select digit
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(dutyCounter >= dutyPeriod) then
                dutyCounter <= (others => '0');
                digitPhase <= digitPhase(2 downto 0) & digitPhase(3);
            else
                dutyCounter <= dutyCounter + 1;
            end if;
        end if;
    end process;

end Behavioral;
