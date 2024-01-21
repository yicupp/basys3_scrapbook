----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.01.2024 20:55:34
-- Design Name: 
-- Module Name: sevenSegDecoderNumberToLed - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- This module decodes a hex number to the corresponding 7-seg LED pattern as per 
-- https://digilent.com/reference/basys3/refmanual
-- Inputs:
-- 4-bit Hex Value between 0 - 10
-- Outputs:
-- 7-bit in the form CA CB CC CD CE CF CG, active low
-- Values out of range result in LED off
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

entity sevenSegDecoderNumberToLed is
  Port (    hexIn       : in std_logic_vector (3 downto 0);     -- Hex number to decode
            segOut      : out std_logic_vector (6 downto 0)     -- 7-Seg LED, active low
  );
end sevenSegDecoderNumberToLed;

architecture Behavioral of sevenSegDecoderNumberToLed is

begin
    with hexIn select
        segOut <=   "1000000"   when "0000",
                    "1111001"   when "0001",
                    "0100100"   when "0010",
                    "0110000"   when "0011",
                    "0011001"   when "0100",
                    "0010010"   when "0101",
                    "0000010"   when "0110",
                    "1111000"   when "0111",
                    "0000000"   when "1000",
                    "0011000"   when "1001",
                    "0000000"   when others;

end Behavioral;
