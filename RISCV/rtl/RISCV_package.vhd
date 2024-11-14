-------------------------------------------------------------------------
-- Design unit: MIPS package
-- Description: package with...
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package RISCV_package is  
        
    -- inst_type defines the instructions decodable by the control unit
    type Instruction_type is (ADDU, SUBU, AAND, OOR, SW, LW, ADDIU, ORI, SLT, BEQ, J, LUI, INVALID_INSTRUCTION, BUBBLE);
 
    type Microinstruction is record
        RegWrite    : std_logic;        -- Register file write control
        ALUSrc      : std_logic_vector(1 downto 0); -- Selects the ALU second operand
        RegDst      : std_logic;        -- Selects the destination register
        MemToReg    : std_logic;        -- Selects the data to the register file
        MemWrite    : std_logic;        -- Enable the data memory write
        Branch      : std_logic;        -- Indicates the BEQ instruction
        Jump        : std_logic;        -- Indicates the J instruction
        instruction : Instruction_type; -- Decoded instruction            
    end record;
         
end RISCV_package;


