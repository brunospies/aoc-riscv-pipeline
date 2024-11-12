-------------------------------------------------------------------------
-- Design unit: Register
-- Description: Parameterizable length clock enabled register.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity RegisterNbits is
    generic (
        LENGTH      : integer := 32;
        INIT_VALUE  : integer := 0 
    );
    port (  
        clock       : in std_logic;
        reset       : in std_logic; 
        ce          : in std_logic;
        d           : in  std_logic_vector (LENGTH-1 downto 0);
        q           : out std_logic_vector (LENGTH-1 downto 0)
    );
end RegisterNbits;


architecture behavioral of RegisterNbits is
begin

    process(clock, reset)
    begin
        if reset = '1' then
            q <= STD_LOGIC_VECTOR(TO_UNSIGNED(INIT_VALUE, LENGTH));        
        
        elsif rising_edge(clock) then
            if ce = '1' then
                q <= d; 
            end if;
        end if;
    end process;
        
end behavioral;