
-- ECE 124 SECTION 206 Group 21, Daniel Chen (21003899) and Akshat Kachroo (21006031)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	
	--sm_clk_en					: out std_logic;
	--blink_signal				: out std_logic;
	--NS_red_show				: out std_logic;
	--NS_amber_show			: out std_logic;
	--NS_green_show			: out std_logic;
	--EW_red_show				: out std_logic;
	--EW_amber_show			: out std_logic;
	--EW_green_show			: out std_logic;

	
	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

   component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 		: in  std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port ( 
			sim_mode			: in boolean;		-- used to select the clocking frequency for the output signals "sm_clken" and "blink".
			reset				: in std_logic;
			clkin      		: in  std_logic; -- input used for counter and register clocking
			sm_clken			: out	std_logic; -- output used to enbl the sm to advance by 1 clk.
			blink		  		: out std_logic  -- output used for blink signal (1/4 the rate of the sm_clken)
  );
   end component;

   component pb_inverters port (
			rst_n 	: in  std_logic; -- input reset signal
			rst		: out std_logic; -- output reset signal
			pb_n		: in  std_logic_vector (3 downto 0);	-- input button signals
			pb			: out	std_logic_vector(3 downto 0) 	-- output button signals
  );
   end component;
	
	component synchronizer port(
			clk					: in std_logic; -- global clock signal
			reset					: in std_logic; -- asynchronous reset signal linked with pb(3)
			din					: in std_logic; -- external input
			dout					: out std_logic -- output signal from the synchronizer
  );
   end component;
 
  component holding_register port (
			clk					: in std_logic;	-- global clock signal
			reset					: in std_logic;	-- asynchronous reset signal
			register_clr		: in std_logic;	-- signal which is used to clear the holding registars
			din					: in std_logic;	-- input into the register coming from the synchronizer
			dout					: out std_logic	-- output signal which will be connected to the state machine
  );
  end component;
  
  component PB_filters port (
		clkin				: in std_logic;
		rst_n				: in std_logic;
		rst_n_filtered	: out std_logic;
		pb_n				: in  std_logic_vector (3 downto 0);
		pb_n_filtered	: out	std_logic_vector(3 downto 0)							 
	);
	end component;
	
	component TLC_State_Machine port (
		clk, clk_enable, reset, NS_INPUT, EW_INPUT, blink_signal		: in std_logic; 
	ns_red, ns_amber, ns_green, ew_red, ew_amber, ew_green, ns_clear, ew_clear, ns_green_display, ew_green_display	: out std_logic;
	state_number		: out std_logic_vector(3 downto 0)
	);
	end component;
				
	
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode							: boolean := TRUE	; -- set to FALSE for LogicalStep board downloads
	                                                     -- set to TRUE for SIMULATIONS
	
	signal sm_clken, blink_sig				: std_logic; -- sm_clken is used for a signal for the enable inputof the registar section within the SM
																	 -- blink_sig is used for the blinking clock of the EW and NS green signals
	
	signal pb_n_filter, pb					: std_logic_vector(3 downto 0); -- buttons used for multiple different functions
	
	signal rst, rst_n_filtered				: std_logic; -- reset variable inserted within the holding_registor
	
	signal ns_synch_output					: std_logic; -- synchronizer output for NS
	signal ew_synch_output					: std_logic; -- synchronzier output for EW
	
	signal synch_rst							: std_logic; -- global reset variable 
	
	signal ns_register_out					: std_logic; -- holding registar output for NS
	signal ew_register_out					: std_logic; -- holding registar output for EW
	
	signal ns_red, ns_amber, ns_green	: std_logic; -- signals associated with the state of the light for NS
	signal ns_output 							: std_logic_vector (6 downto 0); -- concatenated output to display on FBGA board for NS
	signal ew_red, ew_amber, ew_green	: std_logic; -- signals associated with the state of the light for EW
	signal ew_output 							: std_logic_vector (6 downto 0); -- concatenated output to display on FBGA board for EW
	
	signal ns_clear, ew_clear				: std_logic; -- signals used to clear the pedestrian signals
	
BEGIN
----------------------------------------------------------------------------------------------------

ns_output <= ns_amber & "00" & ns_green & "00" & ns_red; -- concatenated signal for NS used to display on the the FBGA board
ew_output <= ew_amber & "00" & ew_green & "00" & ew_red; -- concatenated signal for Ew used to display on the the FBGA board

INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filter, pb); -- instance used to change buttons from active low to active high
INST2: clock_generator 	port map (sim_mode, pb(3), clkin_50, sm_clken, blink_sig); -- generates a clock enabler

INST3: PB_filters port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filter); 

INST4: synchronizer port map (clkin_50, synch_rst, rst, synch_rst); -- button synchronizer
INST5: synchronizer port map (clkin_50, synch_rst, pb(0), ns_synch_output); -- north south synchronizer
INST6: synchronizer port map (clkin_50, synch_rst, pb(1), ew_synch_output); -- east west synchronizer

INST7: holding_register port map (clkin_50, synch_rst, ew_clear, ew_synch_output, ew_register_out); -- north south holding register 
INST8: holding_register port map (clkin_50, synch_rst, ns_clear, ns_synch_output, ns_register_out); -- north south holding register

INST9: TLC_State_Machine port map (clkin_50, sm_clken, synch_rst, ns_register_out, ew_register_out,
											  blink_sig, ns_red, ns_amber, ns_green, ew_red, ew_amber, ew_green,
  										     ns_clear, ew_clear, leds(0), leds(2), leds(7 downto 4)); -- state machine

INST10: segment7_mux port map (clkin_50, ns_output, ew_output, seg7_data, seg7_char2, seg7_char1); -- display to the FPGA board

leds(1) <= ns_register_out;
leds(3) <= ew_register_out;

--sm_clk_en		<= sm_clken;
--blink_signal	<= blink_sig;
--NS_red_show			<= ns_red;
--NS_amber_show			<= ns_amber;
--NS_green_show			<= ns_green;
--EW_red_show			<= ew_red;
--EW_amber_show			<= ew_amber;
--EW_green_show			<= ew_green;


END SimpleCircuit;
