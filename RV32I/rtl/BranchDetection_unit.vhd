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
        branch_prediction  : in  std_logic;
        Data1_ID           : in  std_logic_vector(31 downto 0);
        Data2_ID           : in  std_logic_vector(31 downto 0);
        branch_decision    : out std_logic;
        bubble_branch_ID   : out std_logic
    );
end BranchDetection_unit;

architecture arch1 of BranchDetection_unit is

    signal branch_decision_mux : std_logic;

begin

    branch_decision_mux <= '1' when instruction = JALR or 
                                   (instruction = BEQ and Data1_ID = Data2_ID) or
                                   (instruction = BNE and Data1_ID /= Data2_ID) or
                                   (instruction = BLT and signed(Data1_ID) < signed(Data2_ID)) or
                                   (instruction = BGE and signed(Data1_ID) >= signed(Data2_ID)) or
                                   (instruction = BLTU and Data1_ID < Data2_ID) or
                                   (instruction = BGEU and Data1_ID >= Data2_ID) else
                           '0';
    
    branch_decision <= branch_decision_mux;
    
    bubble_branch_ID <= '1' when branch_decision_mux /= branch_prediction else
                        '0'; 
            
end arch1;