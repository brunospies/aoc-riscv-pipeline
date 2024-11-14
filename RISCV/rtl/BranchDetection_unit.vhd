-------------------------------------------------------------------------
-- Design unit: Branch Detection Unit
-- Description: Detect branch and generates a bubble.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity BranchDetection_unit is
    port (  
        Branch_ID          : in  std_logic;
        zero_branch        : in  std_logic;
        jump_ID            : in  std_logic;
        bubble_branch_ID   : out std_logic
    );
end BranchDetection_unit;

architecture arch1 of BranchDetection_unit is

begin

    bubble_branch_ID <= (Branch_ID and zero_branch) or jump_ID;
            
end arch1;