-------------------------------------------------------------------------
-- Design unit: Forwarding Unit
-- Description: Detects data dependency between the ALU operands in the 
-- EX stage and the write registers in the MEM and WB stages.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity Forwarding_unit is
    port (  
        RegWrite_stage_MEM  : in  std_logic;
        RegWrite_stage_WB   : in  std_logic;
        RegWrite_stage_EX   : in  std_logic;
        rs1_stage_EX        : in  std_logic_vector (4 downto 0);
        rs2_stage_EX        : in  std_logic_vector (4 downto 0);
        rs1_stage_ID        : in  std_logic_vector (4 downto 0);
        rs2_stage_ID        : in  std_logic_vector (4 downto 0);
        rd_stage_MEM        : in  std_logic_vector (4 downto 0);
        rd_stage_WB         : in  std_logic_vector (4 downto 0);
        rd_stage_EX         : in  std_logic_vector (4 downto 0);
        ForwardA            : out std_logic_vector (1 downto 0);
        ForwardB            : out std_logic_vector (1 downto 0);
        Forward1            : out std_logic_vector (1 downto 0);
        Forward2            : out std_logic_vector (1 downto 0);
        ForwardWb_A         : out std_logic;
        ForwardWb_B         : out std_logic
    );
end Forwarding_unit;

architecture arch1 of Forwarding_unit is
begin

    ForwardA <= "10" when RegWrite_stage_MEM = '1' and rd_stage_MEM /= "00000" and rd_stage_MEM = rs1_stage_EX else
                "01" when RegWrite_stage_WB = '1' and rd_stage_WB /= "00000" and rd_stage_WB = rs1_stage_EX else
                "00";

    ForwardB <= "10" when RegWrite_stage_MEM = '1' and rd_stage_MEM /= "00000" and rd_stage_MEM = rs2_stage_EX else
                "01" when RegWrite_stage_WB = '1' and rd_stage_WB /= "00000" and rd_stage_WB = rs2_stage_EX else
                "00";
    
    Forward1 <= "11" when RegWrite_stage_WB = '1' and rd_stage_WB /= "00000" and rd_stage_WB = rs1_stage_ID else
                "10" when RegWrite_stage_MEM = '1' and rd_stage_MEM /= "00000" and rd_stage_MEM = rs1_stage_ID else
                "01" when RegWrite_stage_EX = '1' and rd_stage_EX /= "00000" and rd_stage_EX = rs1_stage_ID else
                "00";

    Forward2 <= "11" when RegWrite_stage_WB = '1' and rd_stage_WB /= "00000" and rd_stage_WB = rs2_stage_ID else
                "10" when RegWrite_stage_MEM = '1' and rd_stage_MEM /= "00000" and rd_stage_MEM = rs2_stage_ID else
                "01" when RegWrite_stage_EX = '1' and rd_stage_EX /= "00000" and rd_stage_EX = rs2_stage_ID else
                "00";
    
    ForwardWb_A <= '1' when RegWrite_stage_WB = '1' and rd_stage_WB = rs1_stage_ID else
                   '0';
    
    ForwardWb_B <= '1' when RegWrite_stage_WB = '1' and rd_stage_WB = rs2_stage_ID else
                   '0';
    
end arch1;