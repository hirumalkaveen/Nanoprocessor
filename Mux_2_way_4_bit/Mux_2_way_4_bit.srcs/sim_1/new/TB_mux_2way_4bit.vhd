----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2026 11:22:21 AM
-- Design Name: 
-- Module Name: TB_mux_2way_4bit - Behavioral
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

entity TB_mux_2way_4bit is
--  Port ( );
end TB_mux_2way_4bit;

architecture Behavioral of TB_mux_2way_4bit is

component Mux_2_way_4_bit

port (

    sel : in std_logic;
    in0 : in std_logic_vector (3 downto 0);
    in1 : in std_logic_vector (3 downto 0);
    mux_out : out std_logic_vector (3 downto 0)
);

end component;

signal sel : std_logic;
signal in0  : std_logic_vector(3 downto 0);
signal in1  : std_logic_vector(3 downto 0);
signal mux_out : std_logic_vector(3 downto 0);

begin

    uut : Mux_2_way_4_bit
        port map(
        
        sel => sel,
        in0 => in0,
        in1 => in1,
        mux_out => mux_out
        
        );
        
    process
    begin

        in0 <= "1010"; -- A
        in1 <= "1011"; -- B
        
        wait for 100 ns;
        
        sel <= '0';
        
        wait for 100 ns;
        
        sel <= '1';
        
        wait for 100ns;
        
        wait;
    
    end process;


end Behavioral;
