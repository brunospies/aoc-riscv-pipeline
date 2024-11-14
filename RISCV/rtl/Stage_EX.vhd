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
        read_data_1_in        : in  std_logic_vector(31 downto 0);  
        read_data_1_out       : out std_logic_vector(31 downto 0); 
	    read_data_2_in        : in  std_logic_vector(31 downto 0);  
        read_data_2_out       : out std_logic_vector(31 downto 0); 
	    incremented_pc_in     : in  std_logic_vector(31 downto 0);  
        incremented_pc_out    : out std_logic_vector(31 downto 0);
        imediate_extended_in  : in  std_logic_vector(31 downto 0); 
        imediate_extended_out : out std_logic_vector(31 downto 0);
	    zero_extended_in      : in  std_logic_vector(31 downto 0);
        zero_extended_out     : out std_logic_vector(31 downto 0);
        rs_in                 : in  std_logic_vector(4 downto 0);
        rs_out                : out std_logic_vector(4 downto 0);
        rt_in                 : in  std_logic_vector(4 downto 0);  
        rt_out                : out std_logic_vector(4 downto 0);
        rd_in                 : in  std_logic_vector(4 downto 0);  
        rd_out                : out std_logic_vector(4 downto 0);  
        uins_in               : in  Microinstruction;
        uins_out              : out Microinstruction                
    );
end Stage_EX;


architecture behavioral of Stage_EX is 
    
begin
    
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

    -- PC+4 register
    Incremented_pc:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => incremented_pc_in, 
            q           => incremented_pc_out
        );

    -- Imediate extended register
    Sign_extend:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => imediate_extended_in, 
            q           => imediate_extended_out
        );

     Zero_extend:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => zero_extended_in, 
            q           => zero_extended_out
        );

    -- RT register
    RT:    entity work.RegisterNbits
        generic map (
            LENGTH      => 5,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => rt_in, 
            q           => rt_out
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
    -- RS register
    RS:    entity work.RegisterNbits
        generic map (
            LENGTH      => 5,
            INIT_VALUE  => INIT
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => rs_in, 
            q           => rs_out
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
  	        uins_out.RegDst      <= '0';	
            uins_out.Branch      <= '0';
            uins_out.Jump        <= '0';        
            
        elsif rising_edge(clock) then
            uins_out.instruction <= uins_in.instruction;
	        uins_out.RegWrite    <= uins_in.RegWrite;
            uins_out.ALUSrc      <= uins_in.ALUSrc;
            uins_out.MemWrite    <= uins_in.MemWrite;
            uins_out.MemToReg    <= uins_in.MemToReg;
  	        uins_out.RegDst      <= uins_in.RegDst;	
            uins_out.Branch      <= uins_in.Branch;
            uins_out.Jump        <= uins_in.Jump; 
        end if;
    end process;
    
end behavioral;