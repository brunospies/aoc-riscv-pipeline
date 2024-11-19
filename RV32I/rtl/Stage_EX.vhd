-------------------------------------------------------------------------
-- Design unit: Stage 2 (DEC/EXE)
-- Description: Register of Execution Stage data
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISCV_package.all;

   
entity Stage_EX is
    generic (
        INIT    : integer := 0
    );
    port (  
        clock                 : in  std_logic;
        reset                 : in  std_logic; 
        pc_in                 : in  std_logic_vector(31 downto 0);
        pc_out                : out std_logic_vector(31 downto 0);
        read_data_1_in        : in  std_logic_vector(31 downto 0);  
        read_data_1_out       : out std_logic_vector(31 downto 0); 
	    read_data_2_in        : in  std_logic_vector(31 downto 0);  
        read_data_2_out       : out std_logic_vector(31 downto 0); 
        imm_data_in           : in  std_logic_vector(31 downto 0); 
        imm_data_out          : out std_logic_vector(31 downto 0);
        rs1_in                : in  std_logic_vector(4 downto 0);
        rs1_out               : out std_logic_vector(4 downto 0);
        rs2_in                : in  std_logic_vector(4 downto 0);  
        rs2_out               : out std_logic_vector(4 downto 0);
        rd_in                 : in  std_logic_vector(4 downto 0);  
        rd_out                : out std_logic_vector(4 downto 0);
        uins_in               : in  Microinstruction;
        uins_out              : out Microinstruction                
    );
end Stage_EX;


architecture behavioral of Stage_EX is 
    
begin
    -- Read Data 1 register
    PC:   entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => pc_in, 
            q           => pc_out
        );


    -- Read Data 1 register
    Read_data_1:   entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => read_data_1_in, 
            q           => read_data_1_out
        );

    -- Read Data 2 register
    Read_data_2:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => read_data_2_in, 
            q           => read_data_2_out
        );

    -- Imediate data register
    IMM_DATA_REG:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => imm_data_in, 
            q           => imm_data_out
        );

    -- RS2 register
    RS2:    entity work.RegisterNbits
        generic map (
            LENGTH      => 5,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => rs2_in, 
            q           => rs2_out
        );

    -- RD register
    RD:    entity work.RegisterNbits
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
    -- RS1 register
    RS1:    entity work.RegisterNbits
        generic map (
            LENGTH      => 5,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => rs1_in, 
            q           => rs1_out
        );
    -- Control register   
    process(clock, reset)
    begin
        if reset = '1' then
            uins_out.instruction <= INVALID_INSTRUCTION;
	        uins_out.RegWrite    <= '0';
            uins_out.ALUSrc      <= "00";
            uins_out.MemWrite    <= '0';
            uins_out.MemToReg    <= '0';   
            
        elsif rising_edge(clock) then
            uins_out.instruction <= uins_in.instruction;
	        uins_out.RegWrite    <= uins_in.RegWrite;
            uins_out.ALUSrc      <= uins_in.ALUSrc;
            uins_out.MemWrite    <= uins_in.MemWrite;
            uins_out.MemToReg    <= uins_in.MemToReg;
        end if;
    end process;
    
end behavioral;
