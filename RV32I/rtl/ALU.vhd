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
        operation   : in Instruction_type 
    );
end ALU;

architecture behavioral of ALU is

    function shift_right_signed(input: SIGNED; shift_amount: INTEGER) return SIGNED is
        variable result: SIGNED(input'range);
    begin
        if shift_amount > 0 then
        
            result := input srl shift_amount; 
            if input(input'high) = '1' then  
                for i in 0 to shift_amount-1 loop
                    result(input'high - i) := '1'; 
                end loop;
            end if;
        else
            result := input;
        end if;
        return result;
    end function;

    signal op1_u, op2_u: UNSIGNED(31 downto 0);
    signal op1_s, op2_s: SIGNED(31 downto 0);

    constant zero : STD_LOGIC_VECTOR(31 downto 0):= (others=>'0'); 
    constant one  : STD_LOGIC_VECTOR(31 downto 0):= x"00000001";
    constant four : UNSIGNED(31 downto 0)        := x"00000004"; 

begin

    op1_u <= UNSIGNED(operand1);
    op2_u <= UNSIGNED(operand2);

    op1_s <= SIGNED(operand1);
    op2_s <= SIGNED(operand2); 

    result <= operand2                                                       when operation = LUI else 
              std_logic_vector(unsigned(pc) + op2_u)                         when operation = AUIPC else
              std_logic_vector(unsigned(pc) + four)                          when operation = JAL or operation = JALR else
              operand1 and operand2                                          when operation = ANDI or operation = ANDD else
              one                                                            when ((operation = SLTI or operation = SLT) and (op1_s < op1_s)) or ((operation = SLTIU or operation = SLTU) and (op1_u < op1_u)) else
              zero                                                           when ((operation = SLTI or operation = SLT) and (op1_s >= op1_s)) or ((operation = SLTIU or operation = SLTU) and (op1_u >= op1_u)) else
              operand1 xor operand2                                          when operation = XORI or operation = XORR else
              operand1 or operand2                                           when operation = ORR or operation = ORI else
              std_logic_vector(op1_u sll to_integer(op2_u))                  when operation = SLLI or operation = SLLL else
              std_logic_vector(op1_u srl to_integer(op2_u))                  when operation = SRLI or operation = SRLL else
              std_logic_vector(shift_right_signed(op1_s, to_integer(op2_u))) when operation = SRAI or operation = SRAA else
              std_logic_vector(op1_s - op2_s)                                when operation = SUB else 
              std_logic_vector(op1_s + op2_s); --B types, Load, Store, ADDI, ADD, and others instructions;
              
end behavioral;

