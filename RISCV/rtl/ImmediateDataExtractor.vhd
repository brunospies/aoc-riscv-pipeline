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
        instruction_format    : in  Instruction_format;
        imm_data              : out std_logic_vector (31 downto 0)
    );
end ImmediateDataExtractor;

architecture arch1 of ImmediateDataExtractor is

begin
    imm_data <= (31 downto 12 =>instruction(31)) & instruction(31 downto 20) when instruction_format = I else
                (31 downto 12 =>instruction(31)) & instruction(31 downto 25) & instruction(11 downto 7) when instruction_format = S else
                (31 downto 12 =>instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0' when instruction_format = B else
                instruction(31 downto 12) & (11 downto 0 =>'0') when instruction_format = U else
                (31 donwto 21 =>instruction(31)) & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';
end arch1;