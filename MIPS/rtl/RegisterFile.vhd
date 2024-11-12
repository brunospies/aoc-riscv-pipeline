-------------------------------------------------------------------------
-- Design unit: Register file
-- Description: 32 general purpose registers
--     - 2 read ports
--     - 1 write port
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegisterFile is
    port ( 
        clock           : in std_logic;
        reset           : in std_logic; 
        write           : in std_logic;
        readRegister1   : in std_logic_vector(4 downto 0);
        readRegister2   : in std_logic_vector(4 downto 0);
        writeRegister   : in std_logic_vector(4 downto 0);
        writeData       : in std_logic_vector(31 downto 0);
        readData1       : out std_logic_vector(31 downto 0); 
        readData2       : out std_logic_vector(31 downto 0) 
    );
end RegisterFile;

architecture structural of RegisterFile is

   type RegArray is array(0 to 31) of std_logic_vector(31 downto 0);
   signal reg : RegArray;            -- Array with the stored registers value                            
   signal writeEnable : std_logic_vector(31 downto 0); -- Registers write enable signal

begin            

    Registers: for i in 0 to 31 generate        

        -- Register $0 is the constant 0, not a register.
        -- This is implemented by never enabling writes to register $0.
        writeEnable(i) <= '1' when i > 0 and UNSIGNED(writeRegister) = i and Write = '1' else '0';

        -- Generate the remaining registers
        Regs: entity work.RegisterNbits 
            generic map (
                LENGTH      => 32
                --INIT_VALUE  => i
            )
            port map (
                clock   => clock, 
                reset   => reset, 
                ce      => writeEnable(i), 
                d       => writeData, 
                q       => reg(i)
            );
   end generate Registers;   
    
    -- Register source (rs)
    ReadData1 <= reg(TO_INTEGER(UNSIGNED(ReadRegister1)));   

    -- Register target (rt)
    ReadData2 <= reg(TO_INTEGER(UNSIGNED(ReadRegister2)));
   
end structural;



architecture behavioral of RegisterFile is

   type RegArray is array(0 to 31) of std_logic_vector(31 downto 0);
   signal reg: RegArray;            -- Array with the stored registers value                            
   signal writeEnable : std_logic_vector(31 downto 0); -- Registers write enable signal

begin            

    
    process(clock, reset)
    begin
        
        if reset = '1' then
            for i in 0 to 31 loop
                reg(i) <= (others=>'0');
                --reg(i) <= CONV_STD_LOGIC_VECTOR(i, 32);
            end loop;
        
        elsif rising_edge(clock) then
            
            if write = '1' and UNSIGNED(writeRegister) > 0 then    -- Register $0 is the constant 0, not a register.
                reg(TO_INTEGER(UNSIGNED(writeRegister))) <= writeData;
            end if;
        
        end if;
            
    end process;  
    
    
    -- Register source (rs)
    ReadData1 <= reg(TO_INTEGER(UNSIGNED(ReadRegister1)));   

    -- Register target (rt)
    ReadData2 <= reg(TO_INTEGER(UNSIGNED(ReadRegister2)));
   
end behavioral;