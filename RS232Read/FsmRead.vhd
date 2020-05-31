-- This module controls reading process

library	IEEE;
use IEEE.std_logic_1164.all;

entity FSMRead is
	port(
	RST		:	in	std_logic;
	CLK		:	in 	std_logic; 
	Rx			:	in	std_logic;
	FBaud		:	in	std_logic;
	DTR		:	out	std_logic;
	Stop		:	out	std_logic;
	RTR		:	out std_logic
	);
end FSMRead;

architecture simple of FSMRead is

signal Qp, Qn	:	std_logic_vector(4 downto 0); -- Present buffer, next buffer

begin
	
	COMB: process(Qp,Rx,FBaud) -- Load the 8 bits to read
	begin	   
		case Qp is
			when "00000"=> 
			Qn<= "00001";
			Stop<= '1'; -- Reset (Stop reading transmitted data)
			DTR <= '0';
			RTR<= '0';
			
			when "00001"=>		-- Start
			if(FBaud= '0')then
				Qn<= Qp;
			else
				Qn<= "00010";
			end if;
			Stop<= '0';
			DTR <= '1'; -- Starts the bit counter (BaudRate)
			RTR<= '0';							 
			
			when "00010"=>
			Qn<= "00011";
			Stop<= '0';
			DTR <= '1';
			RTR<= '1';	-- Load Bit 0

			when "00011"=>		
			if(FBaud= '0')then
				Qn<= Qp;
			else
				Qn<= "00100";
			end if;
			Stop<= '0';
			DTR <= '1';
			RTR<= '0';
						
			when "00100"=>		
			Qn<= "00101";
			Stop<= '0';
			DTR <= '1';
			RTR<= '1';	-- Load Bit 1

			when "00101"=>
			if(FBaud= '0')then
				Qn<= Qp;
			else
				Qn<= "00110";
			end if;
			Stop<= '0';
			DTR <= '1';
			RTR<= '0';

			when "00110"=>		
			Qn<= "00111";
			Stop<= '0';
			DTR <= '1';
			RTR<= '1';	-- Load Bit 2

			when "00111"=>		
			if(FBaud= '0')then
				Qn<= Qp;
			else
				Qn<= "01000";
			end if;
			Stop<= '0';
			DTR <= '1';
			RTR<= '0';

			when "01000"=>		
			Qn<= "01001";
			Stop<= '0';
			DTR <= '1';
			RTR<= '1';	-- Load Bit 3

			when "01001"=>		
			if(FBaud= '0')then
				Qn<= Qp;
			else
				Qn<= "01010";
			end if;
			Stop<= '0';
			DTR <= '1';
			RTR<= '0';

			when "01010"=>		
			Qn<= "01011";
			Stop<= '0';
			DTR <= '1';
			RTR<= '1';	-- Load Bit 4
			
			when "01011"=>	
			if(FBaud= '0')then
				Qn<= Qp;
			else
				Qn<= "01100";
			end if;
			Stop<= '0';
			DTR <= '1';
			RTR<= '0';
			
			when "01100"=>	
			Qn<= "01101";
			Stop<= '0';
			DTR <= '1';
			RTR<= '1';	-- Load Bit 5
			
			
			when "01101"=>	
			if(FBaud= '0')then
				Qn<= Qp;
			else
				Qn<= "01110";
			end if;
			Stop<= '0';
			DTR <= '1';
			RTR<= '0';
			
			when "01110"=>	
			Qn<= "01111";
			Stop<= '0';
			DTR <= '1';
			RTR<= '1';	-- Load Bit 6			

			
			when "01111"=>	
			if(FBaud= '0')then
				Qn<= Qp;
			else
				Qn<= "10000";
			end if;
			Stop<= '0';
			DTR <= '1';
			RTR<= '0';
			
			when "10000"=>	
			Qn<= "00000";
			Stop<= '0';
			DTR <= '1';
			RTR<= '1';	-- Load Bit 7
			
			when others=>
			Qn<= "00000";
			DTR<= '0';
			Stop<= '0';
			RTR<= '0';	
			
			end case;
			
	end process COMB;
	
	Update: process(RST,CLK,Qn)
	begin
		if(RST= '1')then
			Qp<= (others=>'0'); 
		elsif(CLK'event and CLK='1')then
			Qp<= Qn;
		end if;
	end process Update;
	
end simple;
