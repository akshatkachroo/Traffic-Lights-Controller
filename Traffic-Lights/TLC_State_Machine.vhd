
-- ECE 124 SECTION 206 Group 21, Daniel Chen (21003899) and Akshat Kachroo (21006031)

library ieee;
use ieee.std_logic_1164.all;

-- mealy state machine is created as the outputs form the machine depend on the current state 
-- as well as the input signal. this can be seen in the decoder section within this file

entity TLC_State_Machine is port (
 	clk, clk_enable, reset, NS_INPUT, EW_INPUT, blink_signal		: in std_logic; -- inputs signal connected to the outputs of the registers
	ns_red, ns_amber, ns_green, ew_red, ew_amber, ew_green, ns_clear, ew_clear, ns_green_display, ew_green_display	: out std_logic;
	state_number		: out std_logic_vector(3 downto 0)
	); 
end TLC_State_Machine;

-- ns_red, ns_amber, ns_green are the outputs for the second digit to be displayed
-- ew_red, ew_amber, ew_green are the outputs for the second digit to be displayed
-- ns_clear, ew_clear connects to the registar output to clear the appropriate state


architecture processState of TLC_State_Machine is

type STATE_NAMES is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15); -- all of the state name values

signal current_state, next_state		: STATE_NAMES; -- creating signal of the type STATE_NAMES

BEGIN

-- REGISTER LOGIC --

registar_logic: process (clk, clk_enable) 
begin
	
	if (rising_edge(clk)) then -- the state machine works on the rising edge
		if (reset = '1') then -- when the reset variable is pressed, it is reset
			current_state <= s0; 
		elsif (reset = '0' AND clk_enable = '1') then
			current_state <= next_state;
		end if;
	end if;
end process;


-- TRANSITION LOGIC PROCESS --
transition_logic: process (NS_INPUT, EW_INPUT, current_state)

	begin
		case current_state is
			when s0 => 
				if ((NS_INPUT = '0') AND (EW_INPUT = '1')) THEN -- when the holding registar for EW is active and NW is not, it jumps
					next_state <= s6;
				else 															-- when the holding registar for EW is active and NW is also active, it continues	
					next_state <= s1;
				end if;
				
			when s1 => 
				if ((NS_INPUT = '0') AND (EW_INPUT = '1')) THEN -- when the holding registar for EW is active and NW is not, it jumps
					next_state <= s6;
				else 
					next_state <= s2; 									-- when the holding registar for EW is active and NW is also active, it continues
				end if;
				
			when s2 =>
				next_state <= s3; -- jumps to state 3
			
			when s3 =>
				next_state <= s4; -- jumps to state 4
			
			when s4 =>
				next_state <= s5; -- jumps to state 5
			
			when s5 =>
				next_state <= s6; -- jumps to state 6
			
			when s6 =>
				next_state <= s7; -- jumps to state 7
				
			when s7 =>
				next_state <= s8; -- jumps to state 8
			
			when s8 => 
				if ((NS_INPUT = '1') AND (EW_INPUT = '0')) THEN -- when the holding registar for EW is active and NW is not, it jumps
					next_state <= s14;
				else 															-- when the holding registar for EW is active and NW is also active, it continues
					next_state <= s9;
				end if;
				
			when s9 => 
				if ((NS_INPUT = '1') AND (EW_INPUT = '0')) THEN -- when the holding registar for EW is active and NW is not, it jumps
					next_state <= s14;
				else 															-- when the holding registar for EW is active and NW is also active, it continues
					next_state <= s10;
				end if;
				
			when s10 =>
				next_state <= s11; -- jumps to state 11
			
			when s11 =>
				next_state <= s12; -- jumps to state 12
				
			when s12 =>
				next_state <= s13; -- jumps to state 13
				
			when s13 =>
				next_state <= s14; -- jumps to state 14
				
			when s14 =>
				next_state <= s15; -- jumps to state 15
				
			when s15 =>
				next_state <= s0;  -- jumps to state 0
				
		end case;
		
	end process;

-- DECODER LOGIC PROCESS --
-- the decoder outputs the desired values according to the current state. This will be related to
-- the red, amber and green status of NS and EW lights, as well as the pedestrian signal and current state number

decoder_logc: process (blink_signal, current_state)
	
	begin
		
		case current_state is
			
			when s0 => 
				ns_red <= '0';
				ns_amber <= '0';
				ns_green <= blink_signal; -- the green signal will be blinking when the blink_signal is inputed
				ew_red <= '1';
				ew_amber <= '0';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '0';
				state_number <= "0000";
			
			when s1 => 
				ns_red <= '0';
				ns_amber <= '0';
				ns_green <= blink_signal;
				ew_red <= '1';
				ew_amber <= '0';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '0';
				state_number <= "0001";
				
			when s2 => 
				ns_red <= '0';
				ns_amber <= '0';
				ns_green <= '1';
				ew_red <= '1';
				ew_amber <= '0';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '1';
				ew_green_display <= '0';
				state_number <= "0010";
				
			when s3 => 
				ns_red <= '0';
				ns_amber <= '0';
				ns_green <= '1';
				ew_red <= '1';
				ew_amber <= '0';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '1';
				ew_green_display <= '0';
				state_number <= "0011";
			
			when s4 => 
				ns_red <= '0';
				ns_amber <= '0';
				ns_green <= '1';
				ew_red <= '1';
				ew_amber <= '0';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '1';
				ew_green_display <= '0';
				state_number <= "0100";
			
			when s5 => 
				ns_red <= '0';
				ns_amber <= '0';
				ns_green <= '1';
				ew_red <= '1';
				ew_amber <= '0';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '1';
				ew_green_display <= '0';
				state_number <= "0101";
			
			when s6 => 
				ns_red <= '0';
				ns_amber <= '1';
				ns_green <= '0';
				ew_red <= '1';
				ew_amber <= '0';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '1'; -- the clear for the NS holding register
				ns_green_display <= '0';
				ew_green_display <= '0';
				state_number <= "0110";
				
			when s7 => 
				ns_red <= '0';
				ns_amber <= '1';
				ns_green <= '0';
				ew_red <= '1';
				ew_amber <= '0';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '0';
				state_number <= "0111";
				
			when s8 => 
				ns_red <= '1';
				ns_amber <= '0';
				ns_green <= '0';
				ew_red <= '0';
				ew_amber <= '0';
				ew_green <= blink_signal;
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '0';
				state_number <= "1000";
			
			when s9 => 
				ns_red <= '1';
				ns_amber <= '0';
				ns_green <= '0';
				ew_red <= '0';
				ew_amber <= '0';
				ew_green <= blink_signal;
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '0';
				state_number <= "1001";
			
			when s10 => 
				ns_red <= '1';
				ns_amber <= '0';
				ns_green <= '0';
				ew_red <= '0';
				ew_amber <= '0';
				ew_green <= '1';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '1';
				state_number <= "1010";
				
			when s11 => 
				ns_red <= '1';
				ns_amber <= '0';
				ns_green <= '0';
				ew_red <= '0';
				ew_amber <= '0';
				ew_green <= '1';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '1';
				state_number <= "1011";
			
			when s12 => 
				ns_red <= '1';
				ns_amber <= '0';
				ns_green <= '0';
				ew_red <= '0';
				ew_amber <= '0';
				ew_green <= '1';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '1';
				state_number <= "1100";
			
			when s13 => 
				ns_red <= '1';
				ns_amber <= '0';
				ns_green <= '0';
				ew_red <= '0';
				ew_amber <= '0';
				ew_green <= '1';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '1';
				state_number <= "1101";
			
			when s14 => 
				ns_red <= '1';
				ns_amber <= '0';
				ns_green <= '0';
				ew_red <= '0';
				ew_amber <= '1';
				ew_green <= '0';
				ew_clear <= '1'; -- the clear for the EW holding register
				ns_clear <= '0'; 
				ns_green_display <= '0';
				ew_green_display <= '0';
				state_number <= "1110";
			
			when s15 => 
				ns_red <= '1';
				ns_amber <= '0';
				ns_green <= '0';
				ew_red <= '0';
				ew_amber <= '1';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '0';
				state_number <= "1111";
				
			when others => 
				ns_red <= '0';
				ns_amber <= '0';
				ns_green <= '0';
				ew_red <= '0';
				ew_amber <= '0';
				ew_green <= '0';
				ew_clear <= '0';
				ns_clear <= '0';
				ns_green_display <= '0';
				ew_green_display <= '0';
				
		end case;
	end process;
	
end architecture processState;

