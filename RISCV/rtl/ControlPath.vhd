-------------------------------------------------------------------------
-- Design unit: Control path
-- Description: RISCV control path supporting LUI, AUIPC, JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU, LB, LH, LW, LBU, LHU, SB, SH, SW, ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, ADD, SUB, SLL_, SLT, SLTU, XOR_, SRL_, SRA_, OR_, AND_, FENCE, FENCE_i, ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI instructions.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_package.all;


entity ControlPath is
    port (  
        clock           : in std_logic;
        reset           : in std_logic;
        instruction     : in std_logic_vector(31 downto 0);
        uins            : out microinstruction
    );
end ControlPath;
                   

architecture behavioral of ControlPath is

    -- Alias to identify the instructions based on the 'opcode', 'funct3' and 'funct7' fields
    alias  opcode: std_logic_vector(6 downto 0) is instruction(6 downto 0);
    alias  funct3: std_logic_vector(2 downto 0) is instruction(14 downto 12);
    alias  funct7: std_logic_vector(6 downto 0) is instruction(31 downto 25);
    
    signal decodedInstruction: Instruction_type;
    signal decodedFormat:      Instruction_format;
    
begin

    uins.instruction <= decodedInstruction;     -- Used to set the ALU operation
    uins.format      <= decodedFormat;
    
    -- Instruction format decode
    decodedFormat <= U when opcode = "0010111" or opcode = "0110111" else
                     J when opcode = "1101111" else
                     I when opcode = "1100111" or opcode = "1100111" or opcode = "1110011" or opcode = "0001111" else
                     B when opcode = "1100011" else
                     R when opcode = "0110011" else
                     S when opcode = "0100011" else
                     X; -- invalid format

    -- Instruction type decode
    decodedInstruction <= LUI     when decodedFormat = U and opcode(5) = '1' else
                          AUIPC   when decodedFormat = U and opcode(5) = '0' else
                          JAL     when decodedFormat = J else
                          JALR    when opcode = "1100111" else 
                          BEQ     when decodedFormat = B and funct3 = "000" else
                          BNE     when decodedFormat = B and funct3 = "001" else
                          BLT     when decodedFormat = B and funct3 = "100" else
                          BGE     when decodedFormat = B and funct3 = "101" else 
                          BLTU    when decodedFormat = B and funct3 = "110" else
                          BGEU    when decodedFormat = B and funct3 = "111" else 
                          LB      when opcode = "0000011" and funct3 = "000" else 
                          LH      when opcode = "0000011" and funct3 = "001" else
                          LW      when opcode = "0000011" and funct3 = "010" else
                          LBU     when opcode = "0000011" and funct3 = "100" else
                          LHU     when opcode = "0000011" and funct3 = "101" else
                          SB      when decodedFormat = S and funct3 = "000" else
                          SH      when decodedFormat = S and funct3 = "001" else
                          SW      when decodedFormat = S and funct3 = "010" else
                          ADDI    when opcode = "0010011" and funct3 = "000" else
                          SLTI    when opcode = "0010011" and funct3 = "010" else
                          SLTIU   when opcode = "0010011" and funct3 = "011" else
                          XORI    when opcode = "0010011" and funct3 = "100" else 
                          ORI     when opcode = "0010011" and funct3 = "110" else
                          ANDI    when opcode = "0010011" and funct3 = "111" else
                          SLLI    when opcode = "0010011" and funct3 = "001" else
                          SRLI    when opcode = "0010011" and funct3 = "101" and funct7(5) = '0' else
                          SRAI    when opcode = "0010011" and funct3 = "101" and funct7(5) = '1' else
                          ADD     when decodedFormat = R and funct3 = "000" and funct7(5) = '0' else
                          SUB     when decodedFormat = R and funct3 = "000" and funct7(5) = '1' else
                          SLL_    when decodedFormat = R and funct3 = "001" else
                          SLT     when decodedFormat = R and funct3 = "010" else
                          SLTU    when decodedFormat = R and funct3 = "011" else
                          XOR_    when decodedFormat = R and funct3 = "100" else
                          SRL_    when decodedFormat = R and funct3 = "101" and funct7(5) = '0' else
                          SRA_    when decodedFormat = R and funct3 = "101" and funct7(5) = '1' else
                          OR_     when decodedFormat = R and funct3 = "110" else
                          AND_    when decodedFormat = R and funct3 = "111" else
                          FENCE   when opcode = "0001111" and funct3 = "000" else
                          FENCE_I when opcode = "0001111" and funct3 = "001" else
                          ECALL   when opcode = "1110011" and funct3 = "000" and instruction(20) = '0' else
                          EBREAK  when opcode = "1110011" and funct3 = "000" and instruction(20) = '1' else
                          CSRRW   when opcode = "1110011" and funct3 = "001" else
                          
                           
            
    assert not (decodedInstruction = INVALID_INSTRUCTION and reset = '0')    
    report "******************* INVALID INSTRUCTION *************"
    severity error;    

    
end behavioral;
