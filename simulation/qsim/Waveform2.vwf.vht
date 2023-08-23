-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "07/17/2023 18:02:58"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          LogicalStep_Lab4_top
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY LogicalStep_Lab4_top_vhd_vec_tst IS
END LogicalStep_Lab4_top_vhd_vec_tst;
ARCHITECTURE LogicalStep_Lab4_top_arch OF LogicalStep_Lab4_top_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL blink_signal : STD_LOGIC;
SIGNAL clkin_50 : STD_LOGIC;
SIGNAL EW_amber_show : STD_LOGIC;
SIGNAL EW_green_show : STD_LOGIC;
SIGNAL EW_red_show : STD_LOGIC;
SIGNAL leds : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL NS_amber_show : STD_LOGIC;
SIGNAL NS_green_show : STD_LOGIC;
SIGNAL NS_red_show : STD_LOGIC;
SIGNAL pb_n : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL rst_n : STD_LOGIC;
SIGNAL seg7_char1 : STD_LOGIC;
SIGNAL seg7_char2 : STD_LOGIC;
SIGNAL seg7_data : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL sm_clk_en : STD_LOGIC;
SIGNAL sw : STD_LOGIC_VECTOR(7 DOWNTO 0);
COMPONENT LogicalStep_Lab4_top
	PORT (
	blink_signal : OUT STD_LOGIC;
	clkin_50 : IN STD_LOGIC;
	EW_amber_show : OUT STD_LOGIC;
	EW_green_show : OUT STD_LOGIC;
	EW_red_show : OUT STD_LOGIC;
	leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	NS_amber_show : OUT STD_LOGIC;
	NS_green_show : OUT STD_LOGIC;
	NS_red_show : OUT STD_LOGIC;
	pb_n : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	rst_n : IN STD_LOGIC;
	seg7_char1 : OUT STD_LOGIC;
	seg7_char2 : OUT STD_LOGIC;
	seg7_data : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	sm_clk_en : OUT STD_LOGIC;
	sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : LogicalStep_Lab4_top
	PORT MAP (
-- list connections between master ports and signals
	blink_signal => blink_signal,
	clkin_50 => clkin_50,
	EW_amber_show => EW_amber_show,
	EW_green_show => EW_green_show,
	EW_red_show => EW_red_show,
	leds => leds,
	NS_amber_show => NS_amber_show,
	NS_green_show => NS_green_show,
	NS_red_show => NS_red_show,
	pb_n => pb_n,
	rst_n => rst_n,
	seg7_char1 => seg7_char1,
	seg7_char2 => seg7_char2,
	seg7_data => seg7_data,
	sm_clk_en => sm_clk_en,
	sw => sw
	);

-- clkin_50
t_prcs_clkin_50: PROCESS
BEGIN
LOOP
	clkin_50 <= '0';
	WAIT FOR 10000 ps;
	clkin_50 <= '1';
	WAIT FOR 10000 ps;
	IF (NOW >= 32000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clkin_50;

-- rst_n
t_prcs_rst_n: PROCESS
BEGIN
	rst_n <= '0';
	WAIT FOR 320000 ps;
	rst_n <= '1';
WAIT;
END PROCESS t_prcs_rst_n;

-- pb_n[3]
t_prcs_pb_n_3: PROCESS
BEGIN
	pb_n(3) <= '1';
WAIT;
END PROCESS t_prcs_pb_n_3;

-- pb_n[2]
t_prcs_pb_n_2: PROCESS
BEGIN
	pb_n(2) <= '1';
WAIT;
END PROCESS t_prcs_pb_n_2;

-- pb_n[1]
t_prcs_pb_n_1: PROCESS
BEGIN
	pb_n(1) <= '1';
	WAIT FOR 17600000 ps;
	pb_n(1) <= '0';
	WAIT FOR 320000 ps;
	pb_n(1) <= '1';
WAIT;
END PROCESS t_prcs_pb_n_1;

-- pb_n[0]
t_prcs_pb_n_0: PROCESS
BEGIN
	pb_n(0) <= '1';
	WAIT FOR 15360000 ps;
	pb_n(0) <= '0';
	WAIT FOR 320000 ps;
	pb_n(0) <= '1';
WAIT;
END PROCESS t_prcs_pb_n_0;
END LogicalStep_Lab4_top_arch;
