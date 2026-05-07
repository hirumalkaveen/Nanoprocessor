----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2026 10:14:28 AM
-- Design Name: 
-- Module Name: TB_mux_8way_4bit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_mux_8way_4bit is
--  Port ( );
end TB_mux_8way_4bit;

architecture Behavioral of TB_mux_8way_4bit is

component Mux_8_to_1_4bit

    port(
        sel : in std_logic_vector(2 downto 0);
        in0 : in std_logic_vector(3 downto 0);
        in1 : in std_logic_vector(3 downto 0);
        in2 : in std_logic_vector(3 downto 0);
        in3 : in std_logic_vector(3 downto 0);
        in4 : in std_logic_vector(3 downto 0);
        in5 : in std_logic_vector(3 downto 0);
        in6 : in std_logic_vector(3 downto 0);
        in7 : in std_logic_vector(3 downto 0);
        mux_out : out std_logic_vector(3 downto 0)
    
    );
    
end component;

signal sel  : std_logic_vector(2 downto 0) := "000";
signal in0  : std_logic_vector(3 downto 0) := "0000";
signal in1  : std_logic_vector(3 downto 0) := "0001";
signal in2  : std_logic_vector(3 downto 0) := "0010";
signal in3  : std_logic_vector(3 downto 0) := "0011";
signal in4  : std_logic_vector(3 downto 0) := "0100";
signal in5  : std_logic_vector(3 downto 0) := "0101";
signal in6  : std_logic_vector(3 downto 0) := "0110";
signal in7  : std_logic_vector(3 downto 0) := "0111";
signal mux_out : std_logic_vector(3 downto 0);




begin


    uut : Mux_8_to_1_4bit Port map(
    
              sel => sel,
              in0 => in0,
              in1 => in1,
              in2 => in2,
              in3 => in3,
              in4 => in4,
              in5 => in5,
              in6 => in6,
              in7 => in7,
              mux_out => mux_out  
    
    );


    stim_proc : process
    begin

        in0 <= "1010"; -- A
        in1 <= "1011"; -- B
        in2 <= "1100"; -- C
        in3 <= "1101"; -- D
        in4 <= "1110"; -- E
        in5 <= "1111"; -- F
        in6 <= "0001"; -- 1
        in7 <= "0010"; -- 2
        
    for i in 0 to 7 loop
        sel <= std_logic_vector(to_unsigned(i, 3));
        wait for 20 ns;
    end loop;
    
    wait;
    
    end process;
    

end Behavioral;
