LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--Group 16: Lukas Rupretch, Guhan Iyer

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
    clkin_50	: in	std_logic;							-- The 50 MHz FPGA Clockinput
	 rst_n		: in	std_logic;							-- The RESET input (ACTIVE LOW)
	 pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	 sw   		: in  	std_logic_vector(7 downto 0); -- The switch inputs
    leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	
	
	
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
--	sm_clken_wv   : out std_logic;
--	blink_sig_wv  : out std_logic;
--	EW_a, EW_g, EW_d : out std_logic;
--	NS_a, NS_g, NS_d : out std_logic;
	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS 
   component segment7_mux port (
          clk        	: in  	std_logic := '0';
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin      		: in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	    : out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	    : out	std_logic_vector(3 downto 0)							 
 );
   end component;

	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				    : out	std_logic;							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;
	
	component synchronizer port(
			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
   end component; 
	
  component holding_register port (
			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
  end component;

	component State_Machine port (
			 clk_input, reset						: IN std_logic;
			 I0, I1									: IN std_logic;
			 blink									: IN std_logic;
			 State_Num								: OUT std_logic_vector (3 downto 0);
			 NS_G, NS_A, NS_R						: OUT std_logic;
			 EW_G, EW_A, EW_R						: OUT std_logic;
			 NS_Crossing, EW_Crossing			: OUT std_logic;
			 NS_Reg_Clear,	EW_Reg_Clear		: OUT std_logic
 );
	end component;
   
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode								: boolean := FALSE;  -- set to FALSE for LogicalStep board downloads																						-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			    : std_logic; --reset signals
	SIGNAL sm_clken, blink_sig							: std_logic; --cycle generator signal to apply to TLC and blink signal to determine flashing light freq.
	SIGNAL pb_n_filtered, pb							: std_logic_vector(3 downto 0); --push button signals 
	SIGNAL synch_out 										: std_logic_vector(1 downto 0); --holding signal from synchronzier output
	SIGNAL NS_Green, NS_Amber, NS_Red				: std_logic; --EW Outputs from the state machine to be concatenated
	SIGNAL EW_Green, EW_Amber, EW_Red				: std_logic; -- EW Outputs from the state machine to be concatenated
	SIGNAL tIO_0, tIO_1									: std_logic; --signals from holding register to State Machine corresponding to a cross request
	SIGNAL S_N												: std_logic_vector(3 downto 0); --state number signal
	SIGNAL NS_HR_C, EW_HR_C								: std_logic; --holding register clear signals
	
BEGIN
----------------------------------------------------------------------------------------------------
--Instances of components

INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered); 

INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb); --inverts push buttons and reset input

INST2: synchronizer     port map (clkin_50, synch_rst, rst, synch_rst);	-- the synchronizer is also reset by synch_rst.

INST3: synchronizer		port map (clkin_50, synch_rst, pb(1), synch_out(1)); --Synchronizes EW cross request with the global clock

INST4: synchronizer 		port map (clkin_50, synch_rst, pb(0), synch_out(0)); --Synchronizes NS cross request with global clock

INST5: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig); 

INST6: holding_register port map (clkin_50, synch_rst, EW_HR_C, synch_out(1), tIO_1); --captures EW synchronizer outputs to then service to the State Machine until they are cleared
INST7: holding_register port map (clkin_50, synch_rst, NS_HR_C, synch_out(0), tIO_0); --captures NS synchronizer outputs to then service to the State Machine until they are cleared

INST8: State_Machine    port map (sm_clken, synch_rst, tIO_0, tIO_1, blink_sig, S_N, NS_Green, NS_Amber, NS_Red, EW_Green, EW_Amber, EW_Red, leds(0), leds(2), NS_HR_C, EW_HR_C); 
--Based on clock and holding register signals, determines the state of the circuit, certain LED outputs, and whether or not the hold on cross requests can be cleared.

INST9: segment7_mux		port map (clkin_50, NS_Amber & "00" & NS_Green & "00" & NS_Red, EW_Amber & "00" & EW_Green & "00" & EW_Red, seg7_data, seg7_char2, seg7_char1);
--maps the outputs of the state machine to seven segment displays, with appropriate concatenation.

leds(7 downto 4) <= S_N;

leds(3) <= tIO_1;
leds(1) <= tIO_0;

--Waveform Signals
--sm_clken_wv <= sm_clken;
--blink_sig_wv <= blink_sig;

--EW_g <= EW_Amber;
--EW_d <= EW_Green;
--EW_a <= EW_Red;
--
--NS_g <= NS_Amber;
--NS_d <= NS_Green;
--NS_a <= NS_Red;
 
END SimpleCircuit;
