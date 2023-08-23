
-- ECE 124 SECTION 206 Group 21, Daniel Chen (21003899) and Akshat Kachroo (21006031)

library ieee;
use ieee.std_logic_1164.all;

-- inverter function used to convert the buttons from active low to active high

entity PB_inverters is port (
	rst_n 	: in  std_logic; -- input reset signal
	rst		: out std_logic; -- output reset signal
 	pb_n		: in  std_logic_vector (3 downto 0);	-- input button signals
	pb			: out	std_logic_vector(3 downto 0) 	-- output button signals
	); 
end PB_inverters;

architecture ckt of PB_inverters is

begin
pb <= NOT(pb_n); -- reversing the buttons inputs
rst <= NOT(rst_n); -- inverting the reset button


end ckt;