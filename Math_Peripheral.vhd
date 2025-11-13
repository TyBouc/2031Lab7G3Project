LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Math_Peripheral IS
    PORT (
        CLOCK     : IN  STD_LOGIC;
        RESETN    : IN  STD_LOGIC;
        IO_ADDR   : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
        IO_READ   : IN  STD_LOGIC;
        IO_WRITE  : IN  STD_LOGIC;
        IO_DATA   : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Math_Peripheral;

ARCHITECTURE rtl OF Math_Peripheral IS
    SIGNAL x1, x2   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Result   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL IO_OUT   : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    -- Main write process
    PROCESS (CLOCK, RESETN)
    BEGIN
        IF RESETN = '0' THEN
            x1 <= (OTHERS => '0');
            x2 <= (OTHERS => '0');
            Result <= (OTHERS => '0');

        ELSIF rising_edge(CLOCK) THEN
            IF IO_WRITE = '1' THEN
                CASE IO_ADDR IS

							WHEN "00100100000" =>  -- 0x90 MULT
								 x1 <= IO_DATA(7 DOWNTO 4);
								 x2 <= IO_DATA(3 DOWNTO 0);
								 Result <= STD_LOGIC_VECTOR(
									  RESIZE(UNSIGNED(IO_DATA(7 DOWNTO 4)) * UNSIGNED(IO_DATA(3 DOWNTO 0)), 8)
								 );

				WHEN "00100100001" =>  -- 0x91 DIV
					 x1 <= IO_DATA(7 DOWNTO 4);
					 x2 <= IO_DATA(3 DOWNTO 0);
					 IF IO_DATA(3 DOWNTO 0) /= "0000" THEN
						  Result <= STD_LOGIC_VECTOR(
								RESIZE(UNSIGNED(IO_DATA(7 DOWNTO 4)) / UNSIGNED(IO_DATA(3 DOWNTO 0)), 8)
						  );
					 ELSE
						  Result <= (OTHERS => '0');
					 END IF;

				WHEN "00100100010" =>  -- 0x92 MOD
					 x1 <= IO_DATA(7 DOWNTO 4);
					 x2 <= IO_DATA(3 DOWNTO 0);
					 IF IO_DATA(3 DOWNTO 0) /= "0000" THEN
						  Result <= STD_LOGIC_VECTOR(
								RESIZE(UNSIGNED(IO_DATA(7 DOWNTO 4)) MOD UNSIGNED(IO_DATA(3 DOWNTO 0)), 8)
						  );
					 ELSE
						  Result <= (OTHERS => '0');
					 END IF;



										  WHEN OTHERS =>
												NULL;

						 END CASE;
					END IF;
			  END IF;
		 END PROCESS;

    -- Read process
    PROCESS (IO_ADDR, IO_READ, Result)
    BEGIN
        IF IO_READ = '1' THEN
            CASE IO_ADDR IS
                WHEN "00100100110" =>  -- 0x96 byte
                    IO_OUT <= "00000000" & Result;
                WHEN OTHERS =>
                    IO_OUT <= (OTHERS => '0');
            END CASE;
        ELSE
            IO_OUT <= (OTHERS => 'Z');
        END IF;
    END PROCESS;

    IO_DATA <= IO_OUT WHEN IO_READ = '1' ELSE (OTHERS => 'Z');

END rtl;
