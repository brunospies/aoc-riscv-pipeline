-------------------------------------------------------------------------
-- Design unit: Control path
-- Description: RISCV control path supporting LUI, AUIPC, JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU, LB, LH, LW, LBU, LHU, SB, SH, SW, ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, ADD, SUB, SLLL, SLT, SLTU, XORR, SRLL, SRAA, ORR, ANDD, FENCE, FENCE_i, ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI instructions.
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
    decodedInstruction <= -- U-format 
                          LUI     when decodedFormat = U and opcode(5) = '1' else
                          AUIPC   when decodedFormat = U and opcode(5) = '0' else
                          -- J-format
                          JAL     when decodedFormat = J else
                          -- I-format
                          JALR    when opcode = "1100111" else 
                          -- B-format
                          BEQ     when decodedFormat = B and funct3 = "000" else
                          BNE     when decodedFormat = B and funct3 = "001" else
                          BLT     when decodedFormat = B and funct3 = "100" else
                          BGE     when decodedFormat = B and funct3 = "101" else 
                          BLTU    when decodedFormat = B and funct3 = "110" else
                          BGEU    when decodedFormat = B and funct3 = "111" else 
                          -- I-format
                          LB      when opcode = "0000011" and funct3 = "000" else 
                          LH      when opcode = "0000011" and funct3 = "001" else
                          LW      when opcode = "0000011" and funct3 = "010" else
                          LBU     when opcode = "0000011" and funct3 = "100" else
                          LHU     when opcode = "0000011" and funct3 = "101" else
                          -- S-format
                          SB      when decodedFormat = S and funct3 = "000" else
                          SH      when decodedFormat = S and funct3 = "001" else
                          SW      when decodedFormat = S and funct3 = "010" else
                          -- I-format
                          ADDI    when opcode = "0010011" and funct3 = "000" else
                          SLTI    when opcode = "0010011" and funct3 = "010" else
                          SLTIU   when opcode = "0010011" and funct3 = "011" else
                          XORI    when opcode = "0010011" and funct3 = "100" else 
                          ORI     when opcode = "0010011" and funct3 = "110" else
                          ANDI    when opcode = "0010011" and funct3 = "111" else
                          SLLI    when opcode = "0010011" and funct3 = "001" else
                          SRLI    when opcode = "0010011" and funct3 = "101" and funct7(5) = '0' else
                          SRAI    when opcode = "0010011" and funct3 = "101" and funct7(5) = '1' else
                          -- R-format
                          ADD     when decodedFormat = R and funct3 = "000" and funct7(5) = '0' else
                          SUB     when decodedFormat = R and funct3 = "000" and funct7(5) = '1' else
                          SLLL    when decodedFormat = R and funct3 = "001" else
                          SLT     when decodedFormat = R and funct3 = "010" else
                          SLTU    when decodedFormat = R and funct3 = "011" else
                          XORR    when decodedFormat = R and funct3 = "100" else
                          SRLL    when decodedFormat = R and funct3 = "101" and funct7(5) = '0' else
                          SRAA    when decodedFormat = R and funct3 = "101" and funct7(5) = '1' else
                          ORR     when decodedFormat = R and funct3 = "110" else
                          ANDD    when decodedFormat = R and funct3 = "111" else
                          -- FENCE instructions
                          FENCE   when opcode = "0001111" and funct3 = "000" else
                          FENCE_I when opcode = "0001111" and funct3 = "001" else
                          -- SYSTEM instruction
                          ECALL   when opcode = "1110011" and funct3 = "000" and instruction(20) = '0' else
                          EBREAK  when opcode = "1110011" and funct3 = "000" and instruction(20) = '1' else
                          -- CSR instructions
                          CSRRW   when opcode = "1110011" and funct3 = "001" else 
                          CSRRS   when opcode = "1110011" and funct3 = "010" else
                          CSRRC   when opcode = "1110011" and funct3 = "011" else
                          CSRRWI  when opcode = "1110011" and funct3 = "101" else
                          CSRRSI  when opcode = "1110011" and funct3 = "101" else
                          CSRRCI  when opcode = "1110011" and funct3 = "111" else

                          -- Invalid or not implemented instruction
                          INVALID_INSTRUCTION; 
                          
                           
            
    assert not (decodedInstruction = INVALID_INSTRUCTION and reset = '0')    
    report "******************* INVALID INSTRUCTION *************"
    severity error; 
    
    uins.RegWrite <= '1' when decodedFormat = U or decodedFormat = R or decodedFormat = I or decodedFormat = J else 
                     '0';

    uins.ALUSrc <= '1' when decodedFormat = I or decodedFormat = J or decodedFormat = U else 
                   '0'; 

    uins.MemToReg <= '1' when opcode = "0000011" else -- Load Instructions
                     '0'; 

    uins.MemWrite <= '1' when decodedFormat = S else
                     '0';
    

    -- FENCE, BREAK and CSR => TODO...

end behavioral;
