-------------------------------------------------------------------------
-- Design unit: SHIFT_UNIT
-- Description: 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity shift_unit is
    port( 
        operand1    : in std_logic_vector(31 downto 0);
        operand2    : in std_logic_vector(31 downto 0);
        result      : out std_logic_vector(31 downto 0);
        operation   : in std_logic(1 downto 0); 
    );
end shift_unit;

architecture behavioral of shift_unit is

    type array_shift is array (32 downto 0) of std_logic_vector(31 downto 0);
    
    signal results_sll: array_shift;
    signal results_srl: array_shift;
    signal results_sra: array_shift;

    signal shift_amount : integer;

begin
    SHIFT_GENERATE: for i in 0 to 30 generate
        results_sll(i) <= (operand1(31-i downto 0) & (others=>'0'));
        results_srl(i) <= ((others=>'0') & operand1(31 downto i));
        results_sra(i) <= ((others=>operand1(31)) & operand1(31 downto i));
    end generate SHIFT_GENERATE;

    results_sll(31) <= operand1(31) & (others=>'0');
    results_srl(31) <= (others=>'0') & operand1(31);
    results_sra(31) <= (others=>operand1(31));

    results_sll(32) <= (others=>'0');
    results_srl(32) <= (others=>'0');
    results_sra(32) <= (others=>'0');

    shift_amount <= to_integer(to_unsigned(operand2)) when operand2 < x"00000010" else -- operand2<32
                    32;

    result <= results_sll(shift_amount) when operation = SLLI or operation = SLLL else
              results_srl(shift_amount) when operation = SRLI or operation = SRLL else
              results_sra(shift_amount) when operation = SRAI or operation = SRAA else
              (others=>'0');
              
end behavioral;

