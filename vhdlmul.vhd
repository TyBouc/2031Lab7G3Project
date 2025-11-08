-- Quartus Prime VHDL Template
-- Unsigned Multiply with Input and Output Registers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplier_Peripheral is
	port 
	(
		clk : in std_logic;
		reset : in std_logic;
		io_addr : in std_logic_vector(3 downto 0);
		io_wr : in std_logic;
		io_din : in std_logic_vector(15 downto 0);
		io_dout : in std_logic_vector(15 downto 0)
	);
end Multiplier_Peripheral;

architecture Behavior of Multiplier_Peripheral is	

	-- Declare I/O registers
	signal a_reg, b_reg : (7 downto 0) := (others => '0');
	signal result : std_logic_vector(15 downto 0) := (others => '0');
	signal ctrl : std_logic := '0';
	signal done : std_logic := '0';

begin

	process (clk, clear)
	begin
		if (clear ='1') then

			-- Reset all register data to 0
			a_reg <= (others => '0');
			b_reg <= (others => '0');
			out_reg <= (others => '0');

		elsif (rising_edge(clk)) then

			-- Store input and output values in registers
			a_reg <= a;
			b_reg <= b;
			out_reg <= a_reg * b_reg;

		end if;
	end process;

	-- Output multiplication result
	result <= out_reg;

end Behavior;
