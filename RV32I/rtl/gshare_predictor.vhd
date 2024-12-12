-------------------------------------------------------------------------
-- Design unit: GSHARE branch predictor
-- Description: 
--
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gshare_predictor is
    generic (
        LENGTH      : integer := 256;
        N           : integer := 8; 
    );
    port ( 
        clock             : in  std_logic;
        reset             : in  std_logic; 
        branch_decision   : in  std_logic;
        current_pc        : in  std_logic_vector(31 downto 0);
        next_pc           : in  std_logic_vector(31 downto 0);
        format            : in  Instruction_format;
        predicted_pc      : out std_logic_vector(31 downto 0);
        branch_prediction : out std_logic
    );
end gshare_predictor;


architecture behavioral of gshare_predictor is

    type Counters_table is array(0 to LENGTH-1) of std_logic_vector(1 downto 0);

    signal counter: Counters_table;
    signal ghr: std_logic_vector(N-1 downto 0); -- Global History Register with 8 bits
    signal index : std_logic_vector(N-1 downto 0);


begin            
    index <= current_pc(N-1 downto 0) xor ghr;
    
    process(clock, reset)
    begin
        
        if reset = '1' then
            for i in 0 to LENGTH-1 loop
                counter(i) <= "01";     -- weak not taken
            end loop;
        
        elsif rising_edge(clock) then
            counter(to_integer(unsigned(index))) <= 
        end if;
            
    end process; 
end behavioral;
