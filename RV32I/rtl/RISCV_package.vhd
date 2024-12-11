-------------------------------------------------------------------------
-- Design unit: RISCV package
-- Description: package with instructions types
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package RISCV_package is  
        
    -- inst_type defines the instructions decodable by the control unit (complete RV32I ISA)
    type Instruction_type is (
        LUI, AUIPC,                                                                 -- U format
        JAL,                                                                        -- J format
        JALR,                                                                       -- I format
        BEQ, BNE, BLT, BGE, BLTU, BGEU,                                             -- B format
        LB, LH, LW, LBU, LHU,                                                       -- I format
        SB, SH, SW,                                                                 -- S format
        ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI,                       -- I format
        ADD, SUB, SLLL, SLT, SLTU, XORR, SRLL, SRAA, ORR, ANDD,                     -- R format
        FENCE, FENCE_i, ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI, -- I format
        INVALID_INSTRUCTION                                                         -- Invalid 
    );

    type Instruction_format is (R, I, S, B, U, J, X);
 
    type Microinstruction is record
        RegWrite    : std_logic;                    -- Register file write control
        ALUSrc      : std_logic;                    -- Selects the ALU second operand
        MemToReg    : std_logic;                    -- Selects the data to the register file
        MemWrite    : std_logic_vector(3 downto 0);  -- Enable the data memory write
        instruction : Instruction_type;             -- Decoded instruction  
        format      : Instruction_format;           -- Indicates the instruction format      
    end record;
         
end RISCV_package;


