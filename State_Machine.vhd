library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Group 16: Lukas Rupretch, Guhan Iyer

Entity State_Machine IS Port
(
 clk_input, reset						: IN std_logic;
 I0, I1									: IN std_logic;
 blink									: IN std_logic;
 State_Num								: OUT std_logic_vector (3 downto 0);
 NS_G, NS_A, NS_R						: OUT std_logic;
 EW_G, EW_A, EW_R						: OUT std_logic;
 NS_Crossing, EW_Crossing			: OUT std_logic;
 NS_Reg_Clear,	EW_Reg_Clear		: OUT std_logic
 );
END ENTITY;
 

 Architecture SM of State_Machine is
 
 TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


 BEGIN
 

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS EXAMPLE
 
Register_Section: PROCESS (clk_input)  -- this process updates with a clock (should be once a second? see 2.1.2)
BEGIN
	IF(rising_edge(clk_input)) THEN
		IF (reset = '1') THEN
			current_state <= S0;
		ELSIF (reset = '0') THEN
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC

Transition_Section: PROCESS (I0, I1, current_state) 

BEGIN
  CASE current_state IS
		  WHEN S0 =>		
				next_state <= S1;

		  WHEN S1 =>
				IF (I0 = '1' and I1 = '1') THEN
					next_state <= S2;
				ELSIF (I1 = '1') THEN
					next_state <= S6;
				ELSE
					next_state <= S2;
				END IF;
	
		  WHEN S2 =>		
					next_state <= S3;
			
			WHEN S3 =>		
					next_state <= S4;
					
			WHEN S4 =>		
					next_state <= S5;
					
			WHEN S5 =>		
					next_state <= S6;
					
			WHEN S6 =>		
					next_state <= S7;
					
			WHEN S7 =>		
					next_state <= S8;
					
			WHEN S8 =>		
					next_state <= S9;
					
			WHEN S9 =>
				IF (I0 = '1' and I1 = '1') THEN
					next_state <= S10;
				ELSIF (I0 = '1') THEN
					next_state <= S14;
				ELSE
					next_state <= S10;
				END IF;
					
			WHEN S10 =>		
					next_state <= S11;
					
			WHEN S11 =>		
					next_state <= S12;
					
			WHEN S12 =>		
					next_state <= S13;
					
			WHEN S13 =>		
					next_state <= S14;
					
			WHEN S14 =>		
					next_state <= S15;
					
			WHEN S15 =>		
					next_state <= S0;

	  END CASE;
 END PROCESS;
 

-- DECODER SECTION

Decoder_Section: PROCESS (blink, current_state) 

BEGIN
     CASE current_state IS
	  
         WHEN S0 =>		
			NS_G <= blink;
			NS_A <= '0';
			NS_R <= '0';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '0';
			EW_R <= '1';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "0000";
			
         WHEN S1 =>		
			NS_G <= blink;
			NS_A <= '0';
			NS_R <= '0';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '0';
			EW_R <= '1';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "0001";

         WHEN S2 =>		
			NS_G <= '1';
			NS_A <= '0';
			NS_R <= '0';
			NS_Crossing <= '1';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '0';
			EW_R <= '1';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "0010";
			
         WHEN S3 =>		
			NS_G <= '1';
			NS_A <= '0';
			NS_R <= '0';
			NS_Crossing <= '1';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '0';
			EW_R <= '1';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "0011";

         WHEN S4 =>		
			NS_G <= '1';
			NS_A <= '0';
			NS_R <= '0';
			NS_Crossing <= '1';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '0';
			EW_R <= '1';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "0100";

         WHEN S5 =>		
			NS_G <= '1';
			NS_A <= '0';
			NS_R <= '0';
			NS_Crossing <= '1';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '0';
			EW_R <= '1';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "0101";
				
         WHEN S6 =>		
			NS_G <= '0';
			NS_A <= '1';
			NS_R <= '0';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '1';
			
			EW_G <= '0';
			EW_A <= '0';
			EW_R <= '1';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "0110";
				
         WHEN S7 =>		
			NS_G <= '0';
			NS_A <= '1';
			NS_R <= '0';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '0';
			EW_R <= '1';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "0111";
			
			WHEN S8 =>		
			NS_G <= '0';
			NS_A <= '0';
			NS_R <= '1';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= blink;
			EW_A <= '0';
			EW_R <= '0';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "1000";
			
			WHEN S9 =>		
			NS_G <= '0';
			NS_A <= '0';
			NS_R <= '1';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= blink;
			EW_A <= '0';
			EW_R <= '0';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "1001";
			
			WHEN S10 =>		
			NS_G <= '0';
			NS_A <= '0';
			NS_R <= '1';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '1';
			EW_A <= '0';
			EW_R <= '0';
			EW_Crossing <= '1';
			EW_Reg_Clear <= '0';
			
			State_Num <= "1010";
			
			WHEN S11 =>		
			NS_G <= '0';
			NS_A <= '0';
			NS_R <= '1';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '1';
			EW_A <= '0';
			EW_R <= '0';
			EW_Crossing <= '1';
			EW_Reg_Clear <= '0';
			
			State_Num <= "1011";
			
			WHEN S12 =>		
			NS_G <= '0';
			NS_A <= '0';
			NS_R <= '1';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '1';
			EW_A <= '0';
			EW_R <= '0';
			EW_Crossing <= '1';
			EW_Reg_Clear <= '0';
			
			State_Num <= "1100";
			
			WHEN S13 =>		
			NS_G <= '0';
			NS_A <= '0';
			NS_R <= '1';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '1';
			EW_A <= '0';
			EW_R <= '0';
			EW_Crossing <= '1';
			EW_Reg_Clear <= '0';
			
			State_Num <= "1101";
			
			WHEN S14 =>		
			NS_G <= '0';
			NS_A <= '0';
			NS_R <= '1';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '1';
			EW_R <= '0';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '1';
			
			State_Num <= "1110";
			
			WHEN S15 =>		
			NS_G <= '0';
			NS_A <= '0';
			NS_R <= '1';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '1';
			EW_R <= '0';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			State_Num <= "1111";
				
         WHEN others =>		
 			NS_G <= '0';
			NS_A <= '0';
			NS_R <= '0';
			NS_Crossing <= '0';
			NS_Reg_Clear <= '0';
			
			EW_G <= '0';
			EW_A <= '0';
			EW_R <= '0';
			EW_Crossing <= '0';
			EW_Reg_Clear <= '0';
			
			
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
