----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.01.2024 22:07:16
-- Design Name: 
-- Module Name: ledseg - Behavioral
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

entity ledseg is
    Port (  clk_100Mhz  : in std_logic;
            btnC        : in std_logic;
            btnU        : in std_logic;
            btnD        : in std_logic;
            btnL        : in std_logic;
            btnR        : in std_logic;
            seg         : in std_logic;
            dp          : in std_logic;
            an          : in std_logic);
end ledseg;

architecture Behavioral of ledseg is
    signal reset        : std_logic;
begin
    reset <= btnC;

process(clk_100Mhz, reset)
begin

end process;

end Behavioral;