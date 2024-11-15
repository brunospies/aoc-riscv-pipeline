-------------------------------------------------------------------------
-- Design unit: Data path
-- Description: MIPS data path supporting ADDU, SUBU, AND, OR, LW, SW,  
--                  ADDIU, ORI, SLT, BEQ, J, LUI instructions.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISCV_package.all;

   
entity DataPath is
    generic (
        PC_START_ADDRESS    : integer := 0;
        SYNTHESIS           : std_logic := '0'
    );
    port (  
        clock               : in  std_logic;
        reset               : in  std_logic;
        instructionAddress  : out std_logic_vector(31 downto 0);  -- Instruction memory address bus
        instruction_IF      : in  std_logic_vector(31 downto 0);  -- Data bus from instruction memory
        instruction_out     : out std_logic_vector(31 downto 0);  -- Data bus from instruction of Stage_ID for Decode by Control Path
        dataAddress         : out std_logic_vector(31 downto 0);  -- Data memory address bus
        data_i              : in  std_logic_vector(31 downto 0);  -- Data bus from data memory 
        data_o              : out std_logic_vector(31 downto 0);  -- Data bus to data memory
        MemWrite            : out std_logic;
        uins_ID             : in  Microinstruction                -- Control path microinstruction
    );
end DataPath;


architecture structural of DataPath is

    -- Instruction Fetch Stage Signals:
    signal incrementedPC_IF, pc_d, pc_q, incrementedPC_IF_mux, instruction_IF_mux : std_logic_vector(31 downto 0);
    signal ce_pc : std_logic;

    -- Instruction Decode Stage Signals:
    signal incrementedPC_ID, readData1_ID, readData2_ID, imm_data_ID, imm_data_ID_mux : std_logic_vector(31 downto 0);
    signal branchOffset, branchTarget, readReg1, readReg2, Data1_ID, Data1_ID_mux, Data2_ID, Data2_ID_mux, instruction_ID : std_logic_vector(31 downto 0);
    signal rs1_ID, rs2_ID, rd_ID, rs1_ID_mux, rs2_ID_mux, rd_ID_mux: std_logic_vector(4 downto 0);
    signal ce_stage_ID, bubble_branch_ID, branch_decision : std_logic;
    signal uins_ID_mux : Microinstruction;

    -- Execution Stage Signals:
    signal result_EX, readData1_EX, readData2_EX, operand1, operand2 : std_logic_vector(31 downto 0);
    signal ALUoperand2, imm_data_EX, zeroExtended_EX : std_logic_vector(31 downto 0);
    signal uins_EX : Microinstruction;
    signal rd_EX, rd_EX, rs2_EX, rs1_EX : std_logic_vector(4 downto 0);
    signal zero_EX, bubble_hazard_EX : std_logic;

    -- Memory Stage Signals:
    signal result_MEM : std_logic_vector(31 downto 0);
    signal uins_MEM : Microinstruction;
    signal rd_MEM : std_logic_vector(4 downto 0);

    -- Write Back Stage Signals:
    signal writeData, data_i_WB, result_WB: std_logic_vector(31 downto 0);
    signal uins_WB : Microinstruction;
    signal rd_WB : std_logic_vector(4 downto 0);

    -- Auxiliar Signals:
    signal ForwardA, ForwardB, Forward1, Forward2 : std_logic_vector(1 downto 0);
    signal ForwardWb_A, ForwardWb_B : std_logic;
    signal uins_bubble : Microinstruction;

    -- SIMULATION Signals:
    signal decodedInstruction_IF: Instruction_type;
    signal decodedFormat_IF:      Instruction_format;
    alias  opcode: std_logic_vector(6 downto 0) is instruction_IF(6 downto 0);
    alias  funct3: std_logic_vector(2 downto 0) is instruction_IF(14 downto 12);
    alias  funct7: std_logic_vector(6 downto 0) is instruction_IF(31 downto 25); 
    signal cicles : integer := 0;

    
begin

    rs1_ID <= instruction_ID(19 downto 15);
    rs2_ID <= instruction_ID(24 downto 20);
    rd_ID  <= instruction_ID(11 downto 7);

    -- incrementedPC_IF points the next instruction address
    -- ADDER over the PC register
    ADDER_PC: incrementedPC_IF <= STD_LOGIC_VECTOR(UNSIGNED(pc_q) + TO_UNSIGNED(4,32));
        
    -- Instruction memory is addressed by the PC register
    instructionAddress <= pc_q;
    
    -- Compare reads data of reg file for branch 
    COMP_READ_REGS: branch_decision <= '1' when readReg1 = readReg2  else '0';
    
    -- Sign extends the low 16 bits of instruction 
    SIGN_EX: imm_data_ID <= x"FFFF" & instruction_ID(15 downto 0) when instruction_ID(15) = '1' else 
             x"0000" & instruction_ID(15 downto 0);
       
    -- Convert the branch offset from words to bytes (multiply by 4) 
    -- Hardware at the second ADDER input
    SHIFT_L: branchOffset <= imm_data_ID(30 downto 0) & "0";
    
    -- Branch or Jump target address
    -- Branch ADDER
    ADDER_BRANCH: branchTarget <= STD_LOGIC_VECTOR(UNSIGNED(incrementedPC_ID) + UNSIGNED(branchOffset));
    
    -- MUX which selects the PC value
    MUX_PC: pc_d <= branchTarget when (uins_ID.format = B and branch_decision = '1') or uins_ID.format = J or uins_ID.instruction = JALR else
                    incrementedPC_IF;
      
    -- Selects the second ALU operand
    -- MUX at the ALU input
    MUX_ALU: ALUoperand2 <= operand2 when uins_EX.ALUSrc = "00" else
                            zeroExtended_EX when uins_EX.ALUSrc = "01" else
                            imm_data_EX;
    
    -- Selects the data to be written in the register file
    -- MUX at the data memory output
    MUX_DATA_MEM: writeData <= data_i_WB when uins_WB.memToReg = '1' else result_WB;
    
    -- MUX Forward A (operand ALU)
    MUX_FORWARD_A: operand1 <= readData1_EX when ForwardA = "00" else 
    writeData when ForwardA = "01" else
    result_MEM;

    -- MUX Forward B (operand ALU)
    MUX_FORWARD_B: operand2 <= readData2_EX when ForwardB = "00" else 
    writeData when ForwardB = "01" else
    result_MEM;

    -- MUX Forward 1 (comparison BEQ)
    MUX_FORWARD_1: readReg1 <= readData1_ID when Forward1 = "00" else 
    result_EX when Forward1 = "01" else
    result_MEM when Forward1 = "10" else
    writeData;

    -- MUX Forward 2 (comparison BEQ)
    MUX_FORWARD_2: readReg2 <= readData2_ID when Forward2 = "00" else 
    result_EX when Forward2 = "01" else
    result_MEM when Forward2 = "10" else
    writeData;

    -- MUX Forward WB A
    MUX_FORWArd_EX_A: Data1_ID <= writeData when ForwardWb_A = '1' else readData1_ID;

    -- MUX Forward WB B
    MUX_FORWArd_EX_B: Data2_ID <= writeData when ForwardWb_B = '1' else readData2_ID;

    -- ALU output address the data memory
    dataAddress <= result_MEM;
    
    -- PC register
    PROGRAM_COUNTER:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => PC_START_ADDRESS
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => ce_pc, 
            d           => pc_d, 
            q           => pc_q
        );

    -- Register file
    REGISTER_FILE: entity work.RegisterFile(structural)
        port map (
            clock             => clock,
            reset             => reset,            
            write             => uins_WB.RegWrite,            
            readRegister1     => rs1_ID,    
            readRegister2     => rs2_ID,
            writeRegister     => rd_WB,
            writeData         => writeData,          
            readData1         => readData1_ID,        
            readData2         => readData2_ID
        );
    
    
    -- Arithmetic/Logic Unit
    ALU: entity work.ALU(behavioral)
        port map (
            operand1    => operand1,
            operand2    => ALUoperand2,
            result      => result_EX,
            zero        => zero_EX,
            operation   => uins_EX.instruction
        );

    -- Stage Instruction Decode of Pipeline
     Stage_ID: entity work.Stage_ID(behavioral)
        port map (
            clock               => clock, 
            reset               => reset,
            ce                  => ce_stage_ID,  
	        incremented_pc_in   => incrementedPC_IF_mux, 
            incremented_pc_out  => incrementedPC_ID,
            instruction_in      => instruction_IF_mux,
            instruction_out     => instruction_ID
        );

    -- Stage Exexution of Pipeline
    Stage_EX: entity work.Stage_EX(behavioral)
        port map (
            clock                 => clock, 
            reset                 => reset,
            read_data_1_in        => Data1_ID_mux, -- 
      	    read_data_1_out       => readData1_EX,
	        read_data_2_in        => Data2_ID_mux, --
            read_data_2_out       => readData2_EX,
            imm_data_in           => imm_data_ID_mux, --
            imm_data_out          => imm_data_EX,
            rs2_in                => rs2_ID_mux, --
            rs2_out               => rs2_EX,
            rs1_in                => rs1_ID_mux, --
            rs1_out               => rs1_EX,
            rd_in                 => rd_ID_mux,  --
            rd_out                => rd_EX,  
            uins_in               => uins_ID_mux, --
            uins_out              => uins_EX
        );

    -- Stage Memory of Pipeline
    Stage_MEM: entity work.Stage_MEM(behavioral)
        port map (
            clock            => clock, 
            reset            => reset,
	        alu_result_in    => result_EX,
            alu_result_out   => result_MEM,
	        write_data_in    => operand2,
            write_data_out   => data_o,
            rd_in            => rd_EX,
            rd_out           => rd_MEM,
            uins_in          => uins_EX,
            uins_out         => uins_MEM
        );

    -- Stage Write Back of Pipeline
    Stage_WB: entity work.Stage_WB(behavioral)
        port map (
            clock            => clock, 
            reset            => reset,
            rd_in            => rd_MEM,
            rd_out           => rd_WB,
            read_data_in     => data_i, 
            read_data_out    => data_i_WB,
	        alu_result_in    => result_MEM,
            alu_result_out   => result_WB,
            uins_in          => uins_MEM,
            uins_out         => uins_WB
        );

    -- Forwardin Unit
    Forwarding_unit: entity work.Forwarding_unit(arch1)
        port map (
            RegWrite_stage_EX   => uins_EX.RegWrite,
            RegWrite_stage_MEM  => uins_MEM.RegWrite,
            RegWrite_stage_WB   => uins_WB.RegWrite,
            rs1_stage_EX        => rs1_EX,
            rs2_stage_EX        => rs2_EX,
            rs1_stage_ID        => rs1_ID,
            rs2_stage_ID        => rs2_ID,
            rd_stage_EX         => rd_EX,
            rd_stage_MEM        => rd_MEM,
            rd_stage_WB         => rd_WB,
            ForwardA            => ForwardA,
            ForwardB            => ForwardB,
            Forward1            => Forward1,
            Forward2            => Forward2,
            ForwardWb_A         => ForwardWb_A,
            ForwardWb_B         => ForwardWb_B

        );

    -- Hazard Detection Unit
    HazardDetection_unit: entity work.HazardDetection_unit(arch1)
        port map (
            rs2_ID               => rs2_ID,
            rs1_ID               => rs1_ID,
            rs2_EX               => rs2_EX,
            MemToReg_EX          => uins_EX.MemToReg,
            ce_pc                => ce_pc,
            ce_stage_ID          => ce_stage_ID,
            bubble_hazard_EX     => bubble_hazard_EX
        );

    BranchDetection_unit: entity work.BranchDetection_unit(arch1)
        port map (
            instruction_type   => uins_ID.instruction,
            Data1_ID           => Data1_ID,
            Data2_ID           => Data2_ID,
            branch_decision    => branch_decision,
            bubble_branch_ID   => bubble_branch_ID
        );

    -- MemWrite receive signal of Stage MEM
    MemWrite <= uins_MEM.MemWrite;

    -- Instruction_out receive instruction_out of Stage 1 for decodification by Control Path
    instruction_out <= instruction_ID;

    -- MUX BUBBLE ID
    MUX_BUBBLE_incrementedPC_IF: incrementedPC_IF_mux <= incrementedPC_IF when bubble_branch_ID = '0' else
                                                         (others=>'0');

    MUX_BUBBLE_instruction_IF: instruction_IF_mux <= instruction_IF when bubble_branch_ID = '0' else
                                                     (others=>'0');
    
    -- MUX BUBBLE EX

    MUX_BUBBLE_Data1_ID: Data1_ID_mux <= Data1_ID when bubble_hazard_EX = '0' else
                                        (others=>'0');
    
    MUX_BUBBLE_Data2_ID: Data2_ID_mux <= Data2_ID when bubble_hazard_EX = '0' else
                                        (others=>'0');

    MUX_BUBBLE_IMM_DATA_ID: imm_data_ID_mux <= imm_data_ID when bubble_hazard_EX = '0' else
                                               (others=>'0');

    MUX_BUBBLE_rs2_ID: rs2_ID_mux <= rs2_ID when bubble_hazard_EX = '0' else
                                   (others=>'0');

    MUX_BUBBLE_rs1_ID: rs1_ID_mux <= rs1_ID when bubble_hazard_EX = '0' else
                                   (others=>'0');

    MUX_BUBBLE_rd_ID: rd_ID_mux <= rd_ID when bubble_hazard_EX = '0' else
                                   (others=>'0');

    MUX_BUBBLE_uins_ID: uins_ID_mux <= uins_ID when bubble_hazard_EX = '0' else
                                    uins_bubble;

    -- BUBBLE signals 

    uins_bubble.RegWrite     <= '0';
    uins_bubble.ALUSrc       <= "00";
    uins_bubble.MemToReg     <= '0';
    uins_bubble.MemWrite     <= '0';
    uins_bubble.format       <= X;
    uins_bubble.instruction  <= INVALID_INSTRUCTION;

    DECODE_STAGE_IF: -- Decoded Instruction of Instruction Fetch Stage for SIMULATION
    if SYNTHESIS = '0' generate

        process(clock) begin 
            if rising_edge(clock) then
                cicles <= cicles + 1;
            end if;
        end process;

        -- Instruction format decode
    decodedFormat_IF <= U when opcode = "0010111" or opcode = "0110111" else
                     J when opcode = "1101111" else
                     I when opcode = "1100111" or opcode = "1100111" or opcode = "1110011" or opcode = "0001111" else
                     B when opcode = "1100011" else
                     R when opcode = "0110011" else
                     S when opcode = "0100011" else
                     X; -- invalid format

    -- Instruction type decode
    decodedInstruction_IF <=   -- U-format 
                            LUI     when decodedFormat_IF = U and opcode(5) = '1' else
                            AUIPC   when decodedFormat_IF = U and opcode(5) = '0' else
                            -- J-format
                            JAL     when decodedFormat_IF = J else
                            -- I-format
                            JALR    when opcode = "1100111" else 
                            -- B-format
                            BEQ     when decodedFormat_IF = B and funct3 = "000" else
                            BNE     when decodedFormat_IF = B and funct3 = "001" else
                            BLT     when decodedFormat_IF = B and funct3 = "100" else
                            BGE     when decodedFormat_IF = B and funct3 = "101" else 
                            BLTU    when decodedFormat_IF = B and funct3 = "110" else
                            BGEU    when decodedFormat_IF = B and funct3 = "111" else 
                            -- I-format
                            LB      when opcode = "0000011" and funct3 = "000" else 
                            LH      when opcode = "0000011" and funct3 = "001" else
                            LW      when opcode = "0000011" and funct3 = "010" else
                            LBU     when opcode = "0000011" and funct3 = "100" else
                            LHU     when opcode = "0000011" and funct3 = "101" else
                            -- S-format
                            SB      when decodedFormat_IF = S and funct3 = "000" else
                            SH      when decodedFormat_IF = S and funct3 = "001" else
                            SW      when decodedFormat_IF = S and funct3 = "010" else
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
                            ADD     when decodedFormat_IF = R and funct3 = "000" and funct7(5) = '0' else
                            SUB     when decodedFormat_IF = R and funct3 = "000" and funct7(5) = '1' else
                            SLL_    when decodedFormat_IF = R and funct3 = "001" else
                            SLT     when decodedFormat_IF = R and funct3 = "010" else
                            SLTU    when decodedFormat_IF = R and funct3 = "011" else
                            XOR_    when decodedFormat_IF = R and funct3 = "100" else
                            SRL_    when decodedFormat_IF = R and funct3 = "101" and funct7(5) = '0' else
                            SRA_    when decodedFormat_IF = R and funct3 = "101" and funct7(5) = '1' else
                            OR_     when decodedFormat_IF = R and funct3 = "110" else
                            AND_    when decodedFormat_IF = R and funct3 = "111" else
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
    end generate;

end structural;
