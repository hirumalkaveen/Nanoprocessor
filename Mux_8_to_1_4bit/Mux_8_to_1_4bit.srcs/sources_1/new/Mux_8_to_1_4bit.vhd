----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2026 09:47:05 AM
-- Design Name: 
-- Module Name: Mux_8_to_1_4bit - Behavioral
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

entity Mux_8_to_1_4bit is
    Port ( sel : in STD_LOGIC_VECTOR (2 downto 0);
           in0 : in STD_LOGIC_VECTOR (3 downto 0);
           in1 : in STD_LOGIC_VECTOR (3 downto 0);
           in2 : in STD_LOGIC_VECTOR (3 downto 0);
           in3 : in STD_LOGIC_VECTOR (3 downto 0);
           in4 : in STD_LOGIC_VECTOR (3 downto 0);
           in5 : in STD_LOGIC_VECTOR (3 downto 0);
           in6 : in STD_LOGIC_VECTOR (3 downto 0);
           in7 : in STD_LOGIC_VECTOR (3 downto 0);
           mux_out : out STD_LOGIC_VECTOR (3 downto 0));
end Mux_8_to_1_4bit;

architecture Behavioral of Mux_8_to_1_4bit is

begin

    with sel select
        mux_out <=  in0 when "000",
                    in1 when "001",
                    in2 when "010",
                    in3 when "011",
                    in4 when "100",
                    in5 when "101",
                    in6 when "110",
                    in7 when "111",
                    (others => '0') when others;

end Behavioral;