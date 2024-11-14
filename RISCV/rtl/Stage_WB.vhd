-------------------------------------------------------------------------
-- Design unit: Stage 4 (MEM/WB)
-- Description: Register of Write Back Stage data
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISCV_package.all;

   
entity Stage_WB is
    generic (
        INIT    : integer := 0
    );
    port (  
        clock            : in  std_logic;
        reset            : in  std_logic;
        write_reg_in     : in  std_logic_vector(4 downto 0);
        write_reg_out    : out std_logic_vector(4 downto 0); 
        read_data_in     : in  std_logic_vector(31 downto 0);  
        read_data_out    : out std_logic_vector(31 downto 0); 
	    alu_result_in    : in  std_logic_vector(31 downto 0);  
        alu_result_out   : out std_logic_vector(31 downto 0);  
        uins_in          : in  Microinstruction;
        uins_out         : out Microinstruction                
    );
end Stage_WB;


architecture behavioral of Stage_WB is 
    
begin
    
    -- Read_data register
    Read_data:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => read_data_in, 
            q           => read_data_out
        );

    -- ALU result register
    ALU_result:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => alu_result_in, 
            q           => alu_result_out
        );

    -- Write Reg register
    Write_reg:    entity work.RegisterNbits
        generic map (
            LENGTH      => 5,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => write_reg_in, 
            q           => write_reg_out
        );
        
    -- Control register   
    process(clock, reset)
    begin
        if reset = '1' then
            uins_out.instruction <= INVALID_INSTRUCTION;
	        uins_out.RegWrite  <= '0';
            uins_out.MemToReg  <= '0';
            uins_out.MemWrite  <= '0';   
        
        elsif rising_edge(clock) then
            uins_out.instruction <= uins_in.instruction;
	        uins_out.RegWrite    <= uins_in.RegWrite;
            uins_out.MemToReg    <= uins_in.MemToReg;
            uins_out.MemWrite    <= uins_in.MemWrite;  
        end if;
    end process;
    
end behavioral;