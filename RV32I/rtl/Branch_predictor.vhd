library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_package.all;


entity Branch_predictor is
    generic (
        SIZE      : integer := 32       -- Size of the branch history table (Index of the PC)
    );
    port (
        clock              : in std_logic;
        reset              : in std_logic;
        incrementedPC_IF   : in std_logic_vector(31 downto 0);  -- Incremented PC in the fetch stage 
        PC_IF              : in std_logic_vector(31 downto 0);  -- PC of the branch instruction in fetch
        pc_predicted_IF    : out std_logic_vector(31 downto 0); -- Predicted PC, controls the PC multiplexer
        PC_ID              : in std_logic_vector(31 downto 0);  -- PC of the branch instruction in decoding
        branchTarget_ID    : in std_logic_vector(31 downto 0);  -- PC of the branch decoding calculated
        jumpTarget_ID      : in std_logic_vector(31 downto 0);  -- Jump target calculated in the ID stage
        branch_decision_ID : in std_logic;                      -- Branch decision in the ID stage
        uins_ID            : in Microinstruction;               -- Instruction in the ID stage
        predicted_ID       : out std_logic;                     -- Prediction status in fetching state
        PC_EX              : in std_logic_vector(31 downto 0);  -- PC of the branch instruction in execution
        branchTarget_EX    : in std_logic_vector(31 downto 0);  -- PC of the branch execution calculated saved for the history table
        uins_EX            : in Microinstruction                -- Instruction in the EX stage
    );
end Branch_predictor;

architecture behavioral of Branch_predictor is

    -- Type declarations
    type branchPC is array(0 to SIZE-1) of std_logic_vector(31 downto 0);
    type prediction is array(0 to SIZE-1) of std_logic_vector(1 downto 0);
    type tag is array(0 to SIZE-1) of std_logic_vector(19 downto 0);
    type valid is array(0 to SIZE-1) of std_logic;

    -- Signal declarations
    signal branchPC_table         : branchPC;
    signal predict_branch_table   : prediction;
    signal tag_memory_table       : tag;
    signal valid_index_table      : valid;
    
    -- Instruction fetch
    alias tag_pc_IF is PC_IF(31 downto 12);
    alias index_IF  is PC_IF(12 downto 2);
    signal taken_IF : std_logic;

    -- Instruction execution
    alias index_ID  is PC_ID(12 downto 2);
    signal taken_ID : std_logic;

    -- Instruction execution stage
    alias tag_pc_EX is PC_EX(31 downto 12);
    alias index_EX  is PC_EX(12 downto 2);

    -- Prediction FSM
    signal new_predict_branch : std_logic_vector(1 downto 0); 
    signal taken_test        : std_logic_vector(1 downto 0);
begin            
    -- Process to write the history table when a branch
    -- Occurs in the execution stage
    process(clock, reset, new_predict_branch)
    begin
        if reset = '1' then
            for i in 0 to SIZE-1 loop
                tag_memory_table(i) <= (others => '0');
                branchPC_table(i) <= (others => '0');
                predict_branch_table(i) <= (others => '0');    -- Set all the predictions to not taken
                valid_index_table(i) <= '0';                   -- Set all the indexes to invalid
            end loop;

        elsif rising_edge(clock) then
            if uins_EX.format = B  then 
                branchPC_table(to_integer(unsigned(index_EX))) <= branchTarget_EX;
                tag_memory_table(to_integer(unsigned(index_EX))) <= tag_pc_EX;
                predict_branch_table(to_integer(unsigned(index_EX))) <= new_predict_branch;
                valid_index_table(to_integer(unsigned(index_EX))) <= '1';
            end if;
        end if;
    end process;

    -- Process to update prediction FSM
    process(clock, reset)
    begin
        if reset = '1' then
            new_predict_branch <= "00";  -- Strongly not taken
        elsif rising_edge(clock) then
            if uins_ID.format = B then  -- Correspondence and update of dynamic branch prediction
                if branch_decision_ID = '1' then
                    case predict_branch_table(to_integer(unsigned(index_ID))) is
                        when "11" =>
                            new_predict_branch <= "11";  -- Strongly taken
                        when "10" =>
                            new_predict_branch <= "11";  -- Taken
                        when "01" =>
                            new_predict_branch <= "10";  -- Weakly taken
                        when others =>
                            new_predict_branch <= "01";  -- Weakly not taken
                    end case;
                else
                    case predict_branch_table(to_integer(unsigned(index_ID))) is
                        when "11" =>
                            new_predict_branch <= "10";  -- Weakly taken
                        when "10" =>
                            new_predict_branch <= "01";  -- Weakly not taken
                        when "01" =>
                            new_predict_branch <= "00";  -- Strongly not taken
                        when others =>
                            new_predict_branch <= "00";  -- Strongly not taken
                    end case;
                end if;
            end if;
        end if;
    end process;

    -- Process to determine if the branch is taken or not
    process(index_IF)
    begin
        case predict_branch_table(to_integer(unsigned(index_IF))) is
            when "11" | "10" =>
                taken_IF <= '1';   -- Branch taken
            when "01" | "00" =>
                taken_IF <= '0';   -- Branch not taken
            when others =>
                taken_IF <= '0';   -- Default not taken
        end case;
    end process;

    -- Process to determine if the branch is taken or not
    process(index_ID)
    begin
        case predict_branch_table(to_integer(unsigned(index_ID))) is
            when "11" | "10" =>
                taken_ID <= '1';   -- Branch taken
            when "01" | "00" =>
                taken_ID <= '0';   -- Branch not taken
            when others =>
                taken_ID <= '0';   -- Default not taken
        end case;
    end process;

    -- Control the PC multiplexer based on the prediction
    MUX_PC_CONTROL: pc_predicted_IF <= branchPC_table(to_integer(unsigned(index_IF))) when
    (taken_IF = '1' and valid_index_table(to_integer(unsigned(index_IF))) = '1' and
    tag_memory_table(to_integer(unsigned(index_IF))) = tag_pc_IF) else -- Branch prediction in the table 
    branchTarget_ID when (branch_decision_ID /= taken_ID) and (branch_decision_ID = '1') and
    ((uins_ID.format = B) or (uins_ID.format = J)) else -- Should have been taken but was not taken or it was jump not relative
    PC_ID when (branch_decision_ID /= taken_ID) and (branch_decision_ID = '0') and
    (uins_ID.format = B) else -- Should have been not taken but was taken
    jumpTarget_ID(30 downto 0) & '0' when uins_ID.instruction = JALR else -- Jump instruction
    incrementedPC_IF; -- Default PC

    -- Prediction status in decoding state to generate the bubble
    predicted_ID <= taken_ID;

end behavioral;
