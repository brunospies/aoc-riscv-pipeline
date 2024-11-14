-------------------------------------------------------------------------
-- Design unit: Stage 1 (IF/ID)
-- Description: Register of Instruction Decode Stage data
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

   
entity Stage_ID is
    generic (
        INIT    : integer := 0
    );
    port (  
        clock               : in  std_logic;
        reset               : in  std_logic;
        ce                  : in  std_logic;  
	    incremented_pc_in   : in  std_logic_vector(31 downto 0);  
        incremented_pc_out  : out std_logic_vector(31 downto 0);
        instruction_in      : in  std_logic_vector(31 downto 0);  
        instruction_out     : out std_logic_vector(31 downto 0)                
    );
end Stage_ID;


architecture behavioral of Stage_ID is 
    
begin

    -- PC+4 register
    Incremented_pc:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => ce, 
            d           => incremented_pc_in, 
            q           => incremented_pc_out
        );
    
    -- Instruction register
    Instruction:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => ce, 
            d           => instruction_in, 
            q           => instruction_out
        );
    
end behavioral;