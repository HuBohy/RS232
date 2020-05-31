-- This module is used for dividing master clock 
-- frequency (50 MHz) to required base Bauds frequency.

library	IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity BaudRateRD is
	port(
	RST		:	in	std_logic;
	CLK		:	in	std_logic;	  
	DTR		:	in	std_logic;
	NBaud		:	in	std_logic_vector(3 downto 0);	-- Index of Baud Rate selected
	FBaud		:	out	std_logic						-- Base frequency 
	); 
end BaudRateRD;

architecture simple of BaudRateRD is

signal NB, Qp, Qn	: std_logic_vector(18 downto 0); -- Size of bits counter, present buffer, next buffer

begin
	
	COMB: process(NBaud,DTR,Qp)
	begin				   	
		
		case NBaud is
			when "0000"=>
			NB<= "1101110111110010010";	-- 110 Bauds (454546)
			when "0001"=>		
			NB<= "0101000101100001010";	-- 300 Bauds (166667)
			when "0010"=>
			NB<= "0010100010110000101";	-- 600 Bauds (83334)
			when "0011"=>
			NB<= "0001010001011000010";	-- 1200 Bauds (41667)
			when "0100"=>					 
			NB<= "0000101000101100001";	-- 2400 Bauds (20834)
			when "0101"=>
			NB<= "0000010100010110000";	-- 4800 Bauds (10417)
			when "0110"=>
			NB<= "0000001010001011000";	-- 9600 Bauds (5209)
			when "0111"=>
			NB<= "0000000110110010000";	-- 14400 Bauds (3473)
			when "1000"=>
			NB<= "0000000101000101100";	-- 19200 Bauds (2605)
			when "1001"=>
			NB<= "0000000010100010110";	-- 38400 Bauds (1303)
			when "1010"=>
			NB<= "0000000001101100100";	-- 57600 Bauds (869)
			when "1011"=>				  			
			NB<= "0000000000110110010";	-- 115200 Bauds (435 = 50 / 115.2)
			when "1100"=>
			NB<= "0000000000110000110";	-- 128000 Bauds (compting to 391 = 50 Mbps / 128 kbps)
			when "1101"=>
			NB<= "0000000000011000011";	-- 256000 Bauds (compting to 196 = 50 Mbps / 256 kbps)
			when others=>
			NB<= "0000000000000000000";	-- 0 Bauds
			
		end case;		
		
			if(DTR='0')then 	-- If Data Terminal is not Ready
				Qn<= NB;			-- Next buffer if reset
				FBaud<= '0';
			else
				if(Qp= "0000000000000000000")then
					Qn<= NB;
					FBaud<= '1';	-- Counter at 0, we can continue (FBaud = OK, load next bit)
				else
					Qn<= Qp-1 ;
					FBaud<= '0';
				end if;
			end if;
	
	end process COMB;
	
	Update: process(RST,CLK,Qn) -- Update buffers
	begin		
		if(RST='1')then
			Qp <= (others=>'0');		  		 
		elsif(CLK'event and CLK='1') then
			Qp <= Qn;				  
		end if;
	end process Update;
		
end simple;



	