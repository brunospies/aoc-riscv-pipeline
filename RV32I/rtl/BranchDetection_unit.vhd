-------------------------------------------------------------------------
-- Design unit: Branch Detection Unit
-- Description: Detect branch and generates a bubble.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISCV_package.all;


entity BranchDetection_unit is
    port (  
        instruction        : in  Instruction_type;
        Data1_ID           : in  std_logic_vector(31 downto 0);
        Data2_ID           : in  std_logic_vector(31 downto 0);
        branch_decision    : out std_logic;
        bubble_branch_ID   : out std_logic
    );
end BranchDetection_unit;

architecture arch1 of BranchDetection_unit is
    signal branch_prediction : std_logic;

begin

    branch_prediction <= '0'; -- move to input when to implement branch predictor

    branch_decision <= '1' when instruction = JAL or instruction = JALR or 
                                (instruction = BEQ and Data1_ID = Data2_ID) or
                                (instruction = BNE and Data1_ID /= Data2_ID) or
                                (instruction = BLT and signed(Data1_ID) < signed(Data2_ID)) or
                                (instruction = BGE and signed(Data1_ID) >= signed(Data2_ID)) or
                                (instruction = BLTU and Data1_ID < Data2_ID) or
                                (instruction = BGEU and Data1_ID >= Data2_ID) else
                       '0';
    
    bubble_branch_ID <= '1' when branch_decision /= branch_prediction else
                        '0'; 
            
end arch1;