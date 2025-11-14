LIBRARY IEEE;
LIBRARY LPM;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE LPM.LPM_COMPONENTS.ALL;

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
    -- 8-bit operands
    SIGNAL a, b    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    -- 16-bit result
    SIGNAL Result  : STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- enable for tri-state bus driver
    SIGNAL IO_EN   : STD_LOGIC;

BEGIN

    PROCESS (CLOCK, RESETN)
		-- For Sqaure Root ----------------------------------------------------------------------------
		VARIABLE num : UNSIGNED(15 DOWNTO 0); 
		VARIABLE res : UNSIGNED(7 DOWNTO 0); 
		VARIABLE bit0 : UNSIGNED(7 DOWNTO 0); 
		-----------------------------------------------------------------------------------------------
		
		-- For Exponentiation -------------------------------------------------------------------------
		VARIABLE base1 : UNSIGNED(15 DOWNTO 0);
		VARIABLE exp   : UNSIGNED(7 DOWNTO 0);
		VARIABLE res1  : UNSIGNED(15 DOWNTO 0);
		-----------------------------------------------------------------------------------------------
		
    BEGIN
        IF RESETN = '0' THEN
            a      <= (OTHERS => '0');
            b      <= (OTHERS => '0');
            Result <= (OTHERS => '0');

        ELSIF rising_edge(CLOCK) THEN
            IF IO_WRITE = '1' THEN
                CASE IO_ADDR IS
                    -- 0x90 : Load 1st 8-bit operand (A) from IO_DATA[7:0]
                    WHEN "00010010000" =>  -- 0x90
                        a <= IO_DATA(7 DOWNTO 0);
								

                    -- 0x91 : Load 2nd 8-bit operand (B) from IO_DATA[7:0]
                    WHEN "00010010001" =>  -- 0x91
                        b <= IO_DATA(7 DOWNTO 0);

                    -- 0x92 : Unsigned multiply (A * B) -> 16-bit
                    WHEN "00010010010" =>  -- 0x92
                        Result <= STD_LOGIC_VECTOR(UNSIGNED(a) * UNSIGNED(b));
								

                    -- 0x93 : Signed multiply (A * B) -> 16-bit
                    WHEN "00010010011" =>  -- 0x93
                        Result <= STD_LOGIC_VECTOR(SIGNED(a) * SIGNED(b));
								

                    -- 0x94 : Unsigned division (A / B) -> quotient in low 8 bits
                    WHEN "00010010100" =>  -- 0x94
                        IF UNSIGNED(b) /= 0 THEN
                            Result <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(a) / UNSIGNED(b),16));
                        ELSE
                            Result <= (OTHERS => '0');  -- divide-by-zero -> 0
                        END IF;
								
								
						  -- 0x95   Signed Division (A/B) -- Quotient in Lower 8 bits
						  WHEN "00010010101" => -- 0x95
								IF SIGNED(b) /= 0 THEN
									Result <=  STD_LOGIC_VECTOR(RESIZE(SIGNED(a) / SIGNED(b),16));
								ELSE 
									Result <= (OTHERS => '0');
								END IF;	
								
						  -- 0x96	Unsigned Modulus A MOD B 
							WHEN "00010010110" => -- 0x96
								IF UNSIGNED(b) /= 0 THEN
									Result <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(a) MOD UNSIGNED(b),16));
								ELSE
									Result <= (OTHERS => '0');
								END IF;
							
						  -- 0x97  Signed Modulus A MOD B
							WHEN "00010010111" => -- 0x97
								IF SIGNED(b) /= 0 THEN
									Result <= STD_LOGIC_VECTOR(RESIZE(SIGNED(a) MOD SIGNED(b),16));
								ELSE
									Result <= (OTHERS => '0');
								END IF;
							
							--0x98 2's Complement ABS Value
								
                        WHEN "00010011000" => -- 0x98: 2's Comp ABS (A)
                            -- Check if 'a' is negative
                            IF SIGNED(a) < 0 THEN
                                Result <= STD_LOGIC_VECTOR(RESIZE(-SIGNED(a),16));
                            ELSE
                                Result <= STD_LOGIC_VECTOR(RESIZE(SIGNED(a),16));
                            END IF;
									 
							-- 0x99 Truncated Square Root
							 WHEN "00010011001" => --0x99 Sqaure Root (Truncated to Integer)
							 num := RESIZE(UNSIGNED(a),16);
							 res := (OTHERS => '0');
							 bit0 := TO_UNSIGNED(128,8);
								FOR i IN 7 DOWNTO 0 LOOP
									IF (res + bit0) * (res + bit0) <= num THEN
										res := res + bit0;
									END IF;
									bit0 := bit0 / 2;
								END LOOP;
								Result <= STD_LOGIC_VECTOR(RESIZE(res,16));
							
							--0x9A Exponentiation
							 WHEN "00010011010" =>
							 base1 := RESIZE(UNSIGNED(a), 16);   -- base = A
							 exp   := UNSIGNED(b);               -- exponent = B
							 res1  := TO_UNSIGNED(1, 16);        -- result starts at 1
							 
								FOR i IN 7 DOWNTO 0 LOOP
									IF exp = 0 THEN
										EXIT;
									END IF;
									res1 := RESIZE(res1 * base1, res1'length);
									exp := exp - 1	;
								END LOOP;
								Result <= STD_LOGIC_VECTOR(RESIZE(res1,16));
							
							
								
                    WHEN OTHERS =>
                        NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    IO_BUS: lpm_bustri
    GENERIC MAP (
        lpm_width => 16
    )
    PORT MAP (
        data     => Result,
        enabledt => IO_EN,
        tridata  => IO_DATA
    );

    -- Drive IO_DATA ONLY when reading from result address (0x9F)
    IO_EN <= '1' WHEN (IO_ADDR = "00010011111") AND (IO_READ = '1') ELSE '0';

END rtl;