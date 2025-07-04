library ieee;
use ieee.std_logic_1164.all;

--Group 16: Lukas Rupretch, Guhan Iyer

entity synchronizer is port (
			clk		: in std_logic;
			reset		: in std_logic;
			din		: in std_logic;
			dout		: out std_logic
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg		: std_logic_vector(1 downto 0);

BEGIN

synch : process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				sreg <= "00";
			else
				sreg(0) <= din;
				sreg(1) <= sreg(0);
			end if;
		end if;
		dout <= sreg(1);
	end process;

END circuit;