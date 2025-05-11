library ieee;
use ieee.std_logic_1164.all;

--Group 16: Lukas Rupretch, Guhan Iyer

entity holding_register is port (

			clk				: in std_logic;
			reset				: in std_logic;
			register_clr	: in std_logic;
			din				: in std_logic;
			dout				: out std_logic
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic;


BEGIN

hold_reg : process(clk)
	begin
		if (rising_edge(clk)) then
			sreg <= (din or sreg) and (not(register_clr or reset));
		end if;
		dout <= sreg;
	end process;
END circuit;