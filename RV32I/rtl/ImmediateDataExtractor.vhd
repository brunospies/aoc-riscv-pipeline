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

--architecture arch1 of ImmediateDataExtractor is

--begin
--    imm_data <= (others=>instruction(31)) & instruction(31 downto 20) when instruction_f = I else
--                (others=>instruction(31)) & instruction(31 downto 25) & instruction(11 downto 7) when instruction_f = S else
--                (others=>instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0' when instruction_f = B else
--                instructionothers & (others=>'0') when instruction_f = U else
--                (others=>instruction(31)) & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';
--end arch1;

architecture arch2 of ImmediateDataExtractor is
    begin
        imm_data <= 
            -- Tipo I: Load e instruções imediatas
            (instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & 
             instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & 
            instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31 downto 20)) when instruction_f = I else
            -- Tipo S: Store
            (instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & 
             instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & 
            instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31 downto 25) & instruction(11 downto 7)) when instruction_f = S else
            -- Tipo B: Branch
            (instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & 
             instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & 
            instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0') when instruction_f = B else
            -- Tipo U: LUI e AUIPC
            (instruction(31 downto 12) & "000000000000") when instruction_f = U else
            -- Tipo J: Jump
            (instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(31) & 
            instruction(31) & instruction(31) & instruction(31) & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & "0");

    end arch2;
    