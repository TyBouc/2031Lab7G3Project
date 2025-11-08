LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

LIBRARY LPM;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY FDiv_In IS
	PORT(
		Numerator      : IN  STD_LOGIC(15 DOWNTO 7);
		Denominator      : IN  STD_LOGIC(6 DOWNTO 0);
		Result_Out_H : OUT STD_LOGIC(7 DOWNTO 0); -- Floor
		Result_Out_L : OUT STD_LOGIC(7 DOWNTO 0) -- Rem
	);
END FDiv_In;

ARCHITECTURE a OF FDiv_In IS
	 SIGNAL Num_full : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Den_full : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Quotient : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Remainder      : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	BEGIN
	
	Num_full <= "0000" & Numerator;     -- pad high bits
   Den_full <= "0000" & Denominator;
	
	-- Use LPM function to create bidirection I/O data bus
	IO_BUS: lpm_bustri --maybe?
	GENERIC MAP ( 
		lpm_widthn => 8, -- width of Num
		lpm_widthd => 8, --width of Den
		lpm_nrepresentation => "UNSIGNED", -- defines how num and den are interpreted
      lpm_drepresentation => "UNSIGNED"
		
	)
	PORT MAP (
		numerator => Num_Full,
		denominator => Den_Full,
		quotient => Quotient,
		remainder => Remainder
	)
	Result_OutH <= Quotient;
	Result_OutL <= Remainder;

END rtl;