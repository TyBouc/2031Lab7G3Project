LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY Math_Peripheral IS
    PORT (
        CLOCK,
        RESETN   : IN    STD_LOGIC;
        IO_ADDR  : IN    STD_LOGIC_VECTOR(10 DOWNTO 0);
        IO_READ  : IN    STD_LOGIC;
        IO_WRITE : IN    STD_LOGIC;
        IO_DATA  : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Math_Peripheral;
ARCHITECTURE a OF Math_Peripheral IS

    -- Internal registers
    SIGNAL Mult_x1, Mult_x2     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Div_num, Div_den     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Mod_num, Mod_den     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Sin_x, Cos_x         : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Result_H, Result_L   : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL IO_EN : STD_LOGIC;
    SIGNAL IO_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

	Begin --GoFromHere
    
    IO_EN <= IO_READ OR IO_WRITE;

    PROCESS (CLOCK, RESETN)
    BEGIN
        IF RESETN = '0' THEN
            Mult_x1 <= (OTHERS => '0');
            Mult_x2 <= (OTHERS => '0');
            Div_num  <= (OTHERS => '0');
            Div_den  <= (OTHERS => '0');
            Mod_num  <= (OTHERS => '0');
            Mod_den  <= (OTHERS => '0');
            Sin_x    <= (OTHERS => '0');
            Cos_x    <= (OTHERS => '0');
            Result_H <= (OTHERS => '0');
            Result_L <= (OTHERS => '0');
        ELSIF RISING_EDGE(CLOCK) THEN
            IF IO_EN = '1' THEN
                -- Handle IO_WRITE and IO_READ operations here
                -- (Implementation of read/write logic goes here)
            END IF;
        END IF;
    END PROCESS;

    IO_DATA <= IO_OUT WHEN IO_READ = '1' ELSE (OTHERS => 'Z');