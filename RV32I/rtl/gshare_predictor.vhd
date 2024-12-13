-------------------------------------------------------------------------
-- Design unit: GSHARE branch predictor
-- Description: 
--
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_package.all;

entity gshare_predictor is
    generic (
        LENGTH      : integer := 256;
        N           : integer := 8 
    );
    port ( 
        clock             : in  std_logic;
        reset             : in  std_logic; 
        branch_decision   : in  std_logic;
        current_pc        : in  std_logic_vector(31 downto 0);
        instruction       : in  std_logic_vector(31 downto 0);
        next_pc           : in  std_logic_vector(31 downto 0);
        format_ID         : in  Instruction_format;
        format_IF         : in  Instruction_format;
        predicted_pc      : out std_logic_vector(31 downto 0);
        branch_prediction : out std_logic
    );
end gshare_predictor;


architecture behavioral of gshare_predictor is

    type Counters is array(0 to LENGTH-1) of std_logic_vector(1 downto 0);

    signal counter: Counters;
    signal ghr: std_logic_vector(N-1 downto 0); -- Global History Register with 8 bits
    signal index_IF, index_ID : std_logic_vector(N-1 downto 0);
    signal id_IF, id_ID : integer;
    signal branchTarget: std_logic_vector(31 downto 0);
    signal imm_data: std_logic_vector(31 downto 0);


begin            
    index_IF <= branchTarget(N+1 downto 2) xor ghr;
    id_IF <= to_integer(unsigned(index_IF));

    index_ID <= next_PC(N+1 downto 2) xor ghr;
    id_ID <= to_integer(unsigned(index_ID));

    branchTarget <= STD_LOGIC_VECTOR(UNSIGNED(current_pc) + UNSIGNED(imm_data));

    imm_data <= ((19 downto 0 =>instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0') when format_IF = B else
                ((11 downto 0 =>instruction(31)) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & "0"); -- J type

    process(clock, reset)
    begin
        
        if reset = '1' then
            for i in 0 to LENGTH-1 loop
                counter(i) <= "01"; -- weakly not taken
            end loop;

            ghr <= (others=>'0');
        
        elsif rising_edge(clock) then
            if format_ID = B then
                counter(id_ID) <= "00" when counter(id_ID) = "01" and branch_decision = '0' else
                                  "10" when counter(id_ID) = "01" and branch_decision = '1' else
                                  "01" when counter(id_ID) = "10" and branch_decision = '0' else
                                  "11" when counter(id_ID) = "10" and branch_decision = '1' else 
                                  "00" when counter(id_ID) = "00" and branch_decision = '0' else
                                  "01" when counter(id_ID) = "00" and branch_decision = '1' else
                                  "10" when counter(id_ID) = "11" and branch_decision = '0' else
                                  "11";
                
                ghr <= ghr(N-2 downto 0) & branch_decision;

            end if;
        end if;
            
    end process;
    
    predicted_pc <= branchTarget when (format_IF = B and counter(id_IF)(1) = '1' and branch_decision = '0') or format_IF = J else
                    next_pc;
    
    branch_prediction <= counter(id_IF)(1) when format_IF = B else
                         '0';
    
end behavioral;
