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
        ins_format            : in  Instruction_format;
        imm_data              : out std_logic_vector (31 downto 0)
    );
end ImmediateDataExtractor;

architecture arch1 of ImmediateDataExtractor is

begin
    imm_data <= (others=>instruction(31)) & instruction(31 to 20) when ins_format = I else
                (others=>instruction(31)) & instruction(31 to 25) & instruction(11 to 7) when ins_format = S else
                (others=>instruction(31)) & instruction(7) & instruction(30 to 25) & instruction(11 to 8) when ins_format = B else
                instruction(31 to 12) & (others=>'0') when ins_format = U else
                (others=>instruction(31)) & instruction(31) & instruction(19 to 12) & instruction(20) & instruction(30 to 21) & '0';
end arch1;