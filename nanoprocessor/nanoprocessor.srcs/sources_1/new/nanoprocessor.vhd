----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2026 02:39:11 PM
-- Design Name: 
-- Module Name: nanoprocessor - Behavioral
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
use work.buses.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nanoprocessor is

    port(
        Clock    : in  std_logic;  -- System clock
        Reset    : in  std_logic;  -- Asynchronous reset
        Overflowfinal : out std_logic;  -- Overflow flag from ALU
        Zerofinal     : out std_logic;  -- Zero flag from ALU
        S_7Seg  : out STD_LOGIC_VECTOR(6 downto 0);
        anode   : out STD_LOGIC_VECTOR(3 downto 0);
        Data     : out std_logic_vector (3 downto 0)    -- Output data (Register 7 contents)
    );

end nanoprocessor;


architecture Behavioral of nanoprocessor is

    -- Clock and reset signals
    signal s_Clk : std_logic;
    signal s_Res : std_logic;
    signal s_SlowClk : std_logic;
    
    -- Program counter and addressing signals
    signal s_PCCurrent        : instruction_address;  -- Current program counter value
    signal s_PCNext           : instruction_address;  -- PC + 1 value
    signal s_JumpAddr         : instruction_address;  -- Jump target address
    signal s_JumpEn           : std_logic;       -- Jump control signal
    signal s_SelectedAddr     : instruction_address;  -- Selected next address
    
    -- Instruction and decoding signals
    signal s_Instruction      : instruction_bus;   -- Current instruction
    signal s_RegEn            : register_address;    -- Register write enable 
    signal s_RegSelA          : register_address;    -- First operand select
    signal s_RegSelB          : register_address;    -- Second operand select
    signal s_OpSelect         : std_logic;         -- Operation select (0=ADD, 1=SUB)
    signal s_ImmValue         : data_bus;           -- Immediate value
    signal s_LoadSel          : std_logic;         -- Load select (0=imm, 1=ALU)
    
    
    -- Data path signals
    signal s_RegFileOutputs   : data_buses;      -- All register values
    signal s_OperandA         : data_bus;           -- First ALU operand
    signal s_OperandB         : data_bus;           -- Second ALU operand
    signal s_ALUResult        : data_bus;           -- ALU result
    signal s_WriteData        : data_bus;           -- Data to write to register







component Register_Bank 

    Port(
    Reg_En     : in  register_address;
    Res        : in  STD_LOGIC;
    Clk        : in  STD_LOGIC;
    Data       : in  data_bus;
    Data_Buses : out data_buses
        
    
    );
    
end component;
    
component Mux_8_to_1_4bit

    port(
               sel : in STD_LOGIC_VECTOR (2 downto 0);
               in0 : in STD_LOGIC_VECTOR (3 downto 0);
               in1 : in STD_LOGIC_VECTOR (3 downto 0);
               in2 : in STD_LOGIC_VECTOR (3 downto 0);
               in3 : in STD_LOGIC_VECTOR (3 downto 0);
               in4 : in STD_LOGIC_VECTOR (3 downto 0);
               in5 : in STD_LOGIC_VECTOR (3 downto 0);
               in6 : in STD_LOGIC_VECTOR (3 downto 0);
               in7 : in STD_LOGIC_VECTOR (3 downto 0);
               mux_out : out STD_LOGIC_VECTOR (3 downto 0)
               
    );
    
    end component;
    
component Mux_2_way_4_bit

    Port ( sel : in STD_LOGIC;
           in0 : in STD_LOGIC_VECTOR (3 downto 0);
           in1 : in STD_LOGIC_VECTOR (3 downto 0);
           mux_out : out STD_LOGIC_VECTOR (3 downto 0));
           
end component;

    
    component Inst_Decoder
    
    port(
   
    I: in instruction_bus; -- Instruction
    RC_Jump: in data_bus; -- Register Check for Jump
    R_Enable: out register_address; -- Register Enable
    Reg_A: out register_address; -- Register Select A
    Reg_B: out register_address; -- Register Select B
    OpS: out std_logic; -- Operation Select
    Immediate: out data_bus; -- Immediate value
    J: out std_logic; -- Jump flag
    J_Address: out instruction_address; -- Jump Address,
    L: out std_logic -- Load Select
);

end component;

component Program_ROM

    port(ROM_address : in instruction_address;
         I : out instruction_bus
    );

end component;

component RCA_3

    Port ( A : in STD_LOGIC_VECTOR (2 downto 0);
           B : in STD_LOGIC_VECTOR (2 downto 0);
           C_in : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (2 downto 0);
           C_out : out STD_LOGIC);
           
end component;

component Mux_2_way_3_bit

    Port ( D0 : in STD_LOGIC_VECTOR (2 downto 0);
           D1 : in STD_LOGIC_VECTOR (2 downto 0);
           S  : in STD_LOGIC;
           Y  : out STD_LOGIC_VECTOR (2 downto 0));

end component;

component Program_Counter

    Port ( D : in STD_LOGIC_VECTOR (2 downto 0);
           Res : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (2 downto 0));
           
end component;

component Add_Sub_4

    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Ctrl : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Zero : out STD_LOGIC;
           Overflow : out STD_LOGIC);
           
end component;

component Slow_Clk

    Port ( Clk_in : in STD_LOGIC;
    Clk_out : out STD_LOGIC);
    
end component;

component Seven_seg_LUT

    Port ( address : in STD_LOGIC_VECTOR (3 downto 0);
           data : out STD_LOGIC_VECTOR (6 downto 0));
           
end component;



begin

s_Clk <= Clock;
s_Res <= Reset;
anode <= "1110";

U_SlwClk : Slow_Clk

    port map(
    
        Clk_in => s_Clk,
        Clk_out => s_SlowClk
    );

U_PC : Program_Counter

        Port map (
           D => s_SelectedAddr,
           Res => s_Res,
           Clk => s_SlowClk,
           Q => s_PCCurrent
           
    );
    
U_PC_Adder : RCA_3


    Port map ( A => s_PCCurrent,
           B => "001",
           C_in => '0',
           S => s_PCNext,
           C_out => open
    );


U_AddressSel : Mux_2_way_3_bit

    Port map( D0 => s_PCNext,
           D1 => s_JumpAddr,
           S  => s_JumpEn,
           Y  => s_SelectedAddr
           
    );

U_ROM : Program_ROM

    port map(ROM_address => s_PCCurrent,
         I => s_Instruction
    );



U_ID : Inst_Decoder

    port map(
   
    I => s_Instruction,-- Instruction
    RC_Jump => s_OperandA,-- Register Check for Jump
    R_Enable => s_RegEn,-- Register Enable
    Reg_A => s_RegSelA,-- Register Select A
    Reg_B => s_RegSelB,-- Register Select B
    OpS => s_OpSelect,-- Operation Select
    Immediate => s_ImmValue,-- Immediate value
    J => s_JumpEn,-- Jump flag
    J_Address => s_JumpAddr,-- Jump Address,
    L => s_LoadSel-- Load Select
);



U_LoadSel : Mux_2_way_4_bit

    Port map( sel => s_LoadSel,
           in0 => s_ImmValue,
           in1 => s_ALUResult,
           mux_out => s_WriteData
           
    );


U_Regbank : Register_Bank

    Port map(
    Reg_En     => s_RegEn,
    Res        => s_Res,
    Clk        => s_SlowClk,
    Data       => s_WriteData,
    Data_Buses => s_RegFileOutputs
        
    
    );

U_MuxA : Mux_8_to_1_4bit

    port map(
               sel => s_RegSelA,
               in0 => s_RegFileOUtputs(0),
               in1 => s_RegFileOUtputs(1),
               in2 => s_RegFileOUtputs(2),
               in3 => s_RegFileOUtputs(3),
               in4 => s_RegFileOUtputs(4),
               in5 => s_RegFileOUtputs(5),
               in6 => s_RegFileOUtputs(6),
               in7 => s_RegFileOUtputs(7),
               mux_out => s_OperandA
               
    );


U_MuxB : Mux_8_to_1_4bit

    port map(
               sel => s_RegSelB,
               in0 => s_RegFileOUtputs(0),
               in1 => s_RegFileOUtputs(1),
               in2 => s_RegFileOUtputs(2),
               in3 => s_RegFileOUtputs(3),
               in4 => s_RegFileOUtputs(4),
               in5 => s_RegFileOUtputs(5),
               in6 => s_RegFileOUtputs(6),
               in7 => s_RegFileOUtputs(7),
               mux_out => s_OperandB
               
    );
    
U_ALU : Add_Sub_4

    Port map( 
           A => s_OperandA,
           B => s_OperandB,
           Ctrl => s_OpSelect,
           S => s_ALUResult, 
           Zero => Zerofinal,
           Overflow => Overflowfinal
           
     );


U_SevSegLUT : Seven_seg_LUT

    Port map( address => s_RegFileOutputs(7),
           data => S_7Seg
);

data <= s_RegFileOutputs(7);


end Behavioral;
