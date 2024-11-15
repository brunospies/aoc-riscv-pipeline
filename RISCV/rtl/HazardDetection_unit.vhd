-------------------------------------------------------------------------
-- Design unit: Hazard Detection Unit
-- Description: Detect data dependency with lw and the next instruction and
-- generates a bubble.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity HazardDetection_unit is
    port ( 
        rs2_ID                : in  std_logic_vector (4 downto 0);
        rs1_ID                : in  std_logic_vector (4 downto 0);
        rs2_EX                : in  std_logic_vector (4 downto 0);
        MemToReg_EX           : in  std_logic;
        ce_pc                 : out std_logic;
        ce_stage_ID           : out std_logic;
        bubble_hazard_EX      : out std_logic
    );
end HazardDetection_unit;

architecture arch1 of HazardDetection_unit is

signal ce : std_logic;

begin

    ce <= '0' when MemToReg_EX = '1' and (rs2_EX = rs1_ID or rs2_EX = rs2_ID) else
          '1';
    
    ce_pc <= ce;
    ce_stage_ID <= ce;

    bubble_hazard_EX <= not ce;
            
end arch1;