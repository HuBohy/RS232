library	IEEE;
use IEEE.std_logic_1164.all;

entity RegSerPar is
	port( 
	RST		:	in	std_logic;
	CLK		:	in	std_logic;
	Rx			:	in	std_logic;
	RTR		:	in	std_logic;
	Q			:	out	std_logic_vector(7 downto 0)
	);
end RegSerPar;

architecture simple of RegSerPar is -- Register to transmit in series

signal Qp, Qn: std_logic_vector(7 downto 0);
begin				  
	
	COMB: process(Rx,RTR,Qp)
	begin		
		
		if(RTR='0')then 	-- If not Ready To Receive
			Qn<= Qp; 		-- Keep the same buffer
		else
			Qn(7)<= Rx;		-- Put the Received value at the end of the next buffer
			for i in 6 downto 0 loop
				Qn(i)<= Qp(i+1); -- Slide the rest of the buffer to the right
			end loop;
		end if;
		
		Q<= Qp; 				-- Assign the present buffer to the output buffer, which controls the 7-segments
		
	end process COMB;
	
	
	Update: process(RST,CLK,Qn)
	begin
		if(RST='1')then
			Qp<= (others=>'0');
		elsif(CLK'event and CLK='1')then
			Qp<= Qn;		   
		end if;
	end process Update;
				
	
end simple;

