-------------------------------------------------------------------------
-- Design unit: MIPS pipeline test bench
-- Description: 
-------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_package.all;


entity RISCV_pipeline_tb is
end RISCV_pipeline_tb;


architecture structural of RISCV_pipeline_tb is

    -- Declaração de sinais
    signal clock: std_logic := '0';
    signal reset, MemWrite: std_logic;
    signal instructionAddress, dataAddress, instruction, data_i, data_o : std_logic_vector(31 downto 0);
    signal uins: Microinstruction;

    constant MARS_INSTRUCTION_OFFSET    : std_logic_vector(31 downto 0) := x"00400000";
    constant MARS_DATA_OFFSET           : std_logic_vector(31 downto 0) := x"10010000";
    
    -- Declaração do componente para MIPS_PIPELINE identificado como DUV
    component RISCV_PIPELINE
        generic (
            PC_START_ADDRESS : integer
        );
        port (
            clock               : in std_logic;
            reset               : in std_logic;
            
            -- Interface de memória de instrução
            instructionAddress  : out std_logic_vector(31 downto 0);
            instruction         : in std_logic_vector(31 downto 0);
            
            -- Interface de memória de dados
            dataAddress         : out std_logic_vector(31 downto 0);
            data_i              : in std_logic_vector(31 downto 0);
            data_o              : out std_logic_vector(31 downto 0);
            MemWrite            : out std_logic
        );
    end component;

begin

    clock <= not clock after 5 ns;
    
    reset <= '1', '0' after 7 ns;
                
    -- Instanciação do componente DUV para MIPS_PIPELINE
    DUV: RISCV_PIPELINE 
        generic map (
            PC_START_ADDRESS => TO_INTEGER(UNSIGNED(MARS_INSTRUCTION_OFFSET))
        )
        port map (
            clock               => clock,
            reset               => reset,
            
            -- Interface de memória de instrução
            instructionAddress  => instructionAddress,    
            instruction         => instruction,        
                 
             -- Interface de memória de dados
            dataAddress         => dataAddress,
            data_i              => data_i,
            data_o              => data_o,
            MemWrite            => MemWrite
        );

    -- Instanciação da memória de instruções
    INSTRUCTION_MEMORY: entity work.Memory(behavioral)
        generic map (
            SIZE            => 100,                        -- Profundidade da memória
            START_ADDRESS   => MARS_INSTRUCTION_OFFSET,    -- Endereço inicial MARS (mapeado para o endereço de memória 0x00000000)
            imageFileName   => "BubbleSort_code.txt"
        )
        port map (
            clock           => clock,
            MemWrite        => '0',
            address         => instructionAddress,    
            data_i          => data_o,
            data_o          => instruction
        );
        
    -- Instanciação da memória de dados
    DATA_MEMORY: entity work.Memory(behavioral)
        generic map (
            SIZE            => 100,                  -- Profundidade da memória
            START_ADDRESS   => MARS_DATA_OFFSET,     -- Endereço inicial MARS (mapeado para o endereço de memória 0x00000000)
            imageFileName   => "BubbleSort_data.txt"
        )
        port map (
            clock           => clock,
            MemWrite        => MemWrite,
            address         => dataAddress,    
            data_i          => data_o,
            data_o          => data_i
        );    
    
end structural;

