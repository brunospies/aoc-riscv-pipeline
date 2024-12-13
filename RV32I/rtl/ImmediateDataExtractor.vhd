-------------------------------------------------------------------------
-- Design unit: Immediate Data Extractor
-- Description: extract the immediate from instruction depending on the format
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISCV_package.all;


entity ImmediateDataExtractor is
    port ( 
        instruction           : in  std_logic_vector (31 downto 7);
        instruction_f         : in  Instruction_format;
        imm_data              : out std_logic_vector (31 downto 0)
    );
end ImmediateDataExtractor;

architecture arch2 of ImmediateDataExtractor is
    begin
        imm_data <= 
            -- Type I: Load and I instructions
            ((19 downto 0 =>instruction(31)) & instruction(31 downto 20)) when instruction_f = I else
            -- Type S: Store
            ((19 downto 0 =>instruction(31)) & instruction(31 downto 25) & instruction(11 downto 7)) when instruction_f = S else
            -- Type B: Branch
            ((19 downto 0 =>instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0') when instruction_f = B else
            -- Type U: LUI and AUIPC
            (instruction(31 downto 12) & "000000000000") when instruction_f = U else
            -- Type J: Jump
            ((11 downto 0 =>instruction(31)) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & "0");

    end arch2;
    