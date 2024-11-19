-------------------------------------------------------------------------
-- Design unit: ALU
-- Description: 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_package.all;

entity ALU is
    port( 
        operand1    : in std_logic_vector(31 downto 0);
        operand2    : in std_logic_vector(31 downto 0);
        pc          : in std_logic_vector(31 downto 0);
        result      : out std_logic_vector(31 downto 0);
        operation   : in Instruction_type; 
    );
end ALU;

architecture behavioral of ALU is

    signal op1_u, op2_u: UNSIGNED(31 downto 0);
    signal op1_s, op2_s: SIGNED(31 downto 0);
    signal op1_i, op2_i: INTEGER;

    constant zero : STD_LOGIC_VECTOR(31 downto 0):= (others=>0); 
    constant one  : STD_LOGIC_VECTOR(31 downto 0):= x"00000001";
    constant four : UNSIGNED(31 downto 0)        := x"00000004"; 

begin

    op1_u <= UNSIGNED(operand1);
    op2_u <= UNSIGNED(operand2);

    op1_s <= SIGNED(operand1);
    op2_s <= SIGNED(operand2); 
   
    op1_i <= TO_INTEGER(operand1, 32);
    op2_i <= TO_INTEGER(operand2, 32);

    result <= operand2                               when operation = LUI else 
              std_logic_vector(signed(pc) + op2_s)   when operation = AUIPC else
              std_logic_vector(unsigned(pc) + four)  when operation = JAL or operation = JALR else
              operand1 and operand2                  when operation = ANDI or operation = AND_ else
              one                                    when ((operation = SLTI or operation = SLT) and (op1_s < op1_s)) or ((operation = SLTIU or operation = SLTU) and (op1_u < op1_u)) else
              zero                                   when ((operation = SLTI or operation = SLT) and (op1_s >= op1_s)) or ((operation = SLTIU or operation = SLTU) and (op1_u >= op1_u)) else
              operand1 xor operand2                  when operation = XORI or operation = XOR_ else
              operand1 or operand2                   when operation = OR_ or operation = ORI else
              operand1 sll op2_i                     when operation = SLLI or operation = SLL_ else
              operand1 srl op2_i                     when operation = SRLI or operation = SRL_ else
              operand1 sra op2_i                     when operation = SRAI or operation = SRA_ else
              std_logic_vector(op1_s - op2_s)        when operation = SUB else 
              std_logic_vector(op1_s + op2_s); --B types, Load, Store, ADDI, ADD, and others instructions;
              
end behavioral;

