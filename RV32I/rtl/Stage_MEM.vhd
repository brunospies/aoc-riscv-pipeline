-------------------------------------------------------------------------
-- Design unit: Stage 3 (EX/MEM)
-- Description: Register of Memory (read an write) Stage data
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISCV_package.all;

   
entity Stage_MEM is
    generic (
        INIT    : integer := 0
    );
    port (  
        clock            : in  std_logic;
        reset            : in  std_logic;
	    alu_result_in    : in  std_logic_vector(31 downto 0);  
        alu_result_out   : out std_logic_vector(31 downto 0); 
	    write_data_in    : in  std_logic_vector(31 downto 0);  
        write_data_out   : out std_logic_vector(31 downto 0);
        rd_in            : in  std_logic_vector(4 downto 0); 
        rd_out           : out std_logic_vector(4 downto 0);
        uins_in          : in  Microinstruction;
        uins_out         : out Microinstruction                
    );
end Stage_MEM;


architecture behavioral of Stage_MEM is 
    
begin
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

    -- Write data register
    Write_data:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => write_data_in, 
            q           => write_data_out
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
            d           => rd_in, 
            q           => rd_out
        );

    -- Control registers   
    process(clock, reset)
    begin
        if reset = '1' then
            uins_out.instruction <= INVALID_INSTRUCTION;
	        uins_out.RegWrite  <= '0';
            uins_out.MemWrite  <= "0000";
            uins_out.MemToReg  <= '0';     
        
        elsif rising_edge(clock) then
            uins_out.instruction <= uins_in.instruction;
	        uins_out.RegWrite    <= uins_in.RegWrite;
            uins_out.MemWrite    <= uins_in.MemWrite;
            uins_out.MemToReg    <= uins_in.MemToReg;
        end if;
    end process;
    
end behavioral;  
