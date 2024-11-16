-------------------------------------------------------------------------
-- Design unit: MIPS Pipeline 
-- Description: Control and data paths port map
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_package.all;

entity RISCV_pipeline is
    generic (
        PC_START_ADDRESS    : integer := 4194304 
    );
    port ( 
        clock, reset        : in std_logic;
        
        -- Instruction memory interface
        instructionAddress  : out std_logic_vector(31 downto 0);
        instruction         : in  std_logic_vector(31 downto 0);
        
        -- Data memory interface
        dataAddress         : out std_logic_vector(31 downto 0);
        data_i              : in  std_logic_vector(31 downto 0);      
        data_o              : out std_logic_vector(31 downto 0);
        MemWrite            : out std_logic 
    );
end RISCV_pipeline;

architecture structural of MIPS_pipeline is
    
    signal uins : Microinstruction;
    signal instruction_1 : std_logic_vector(31 downto 0);


begin

     CONTROL_PATH: entity work.ControlPath(behavioral)
         port map (
             clock          => clock,
             reset          => reset,
             instruction    => instruction_1,
             uins           => uins
         );
         
         
     DATA_PATH: entity work.DataPath(structural)
         generic map (
            PC_START_ADDRESS => PC_START_ADDRESS
         )
         port map (
            clock               => clock,
            reset               => reset,
            
            uins_ID             => uins,
             
            instructionAddress  => instructionAddress,
            instruction_IF      => instruction,
            instruction_out     => instruction_1,
             
            dataAddress         => dataAddress,
            data_i              => data_i,
            data_o              => data_o,
            MemWrite            => MemWrite
         );
     
end structural;
