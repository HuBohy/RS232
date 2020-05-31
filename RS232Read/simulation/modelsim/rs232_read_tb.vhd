LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_arith.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.STD_LOGIC_UNSIGNED.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY rs232_read  IS 
END ; 
 
ARCHITECTURE rs232_read_arch OF rs232_read IS
  SIGNAL RST   		:  STD_LOGIC ; -- Reset
  SIGNAL CLK   		:  std_logic ; -- Clock
  SIGNAL NBaud 		:  std_logic_vector (3 downto 0) ; -- BaudRateIndex
  SIGNAL Rx    		:  STD_LOGIC := '0' ; -- Received bit
  SIGNAL Sent			:	std_logic_vector (7 downto 0) ; -- Hexa Value we want to transmit
  SIGNAL NSent			:  std_logic_vector (7 downto 0) ; -- Next hexa value
  SIGNAL FBaud_out   :  STD_LOGIC ; -- Ok signal for when the counter is over
  SIGNAL Stop_out   	:  STD_LOGIC ; -- Stop when 8 bits have been transmitted
  SIGNAL RTR_out   	:  STD_LOGIC ; -- Ready To Receive when we can read one bit
  SIGNAL Q_out			:	std_logic_vector (7 downto 0); -- Actual value on the display buffer
  SIGNAL S   			:  std_logic_vector (13 downto 0) ; -- Signal of the 7-segments
  
  CONSTANT HALF_PERIOD : time := 10 ns; -- Clock (50 MHz) half-period
  
  COMPONENT RS232Read  
    PORT ( 
      RST  			: in STD_LOGIC ; 
      CLK  			: in STD_LOGIC ; 
      NBaud  		: in std_logic_vector (3 downto 0) ; 
      Rx  			: in STD_LOGIC ; 
      FBaud_out  	: out STD_LOGIC ; 
      Stop_out  	: out STD_LOGIC ; 
      RTR_out  	: out STD_LOGIC ;
		Q_out			: out std_logic_vector (7 downto 0);
      S  			: out std_logic_vector (13 downto 0)) ; 
  END COMPONENT ; 
  
BEGIN
  DUT  : RS232Read  
    PORT MAP ( 
      RST   		=> RST  ,
      CLK   		=> CLK  ,
      NBaud   		=> NBaud  ,
      Rx   			=> Rx  ,
      FBaud_out   => FBaud_out  ,
      Stop_out   	=> Stop_out  ,
      RTR_out   	=> RTR_out ,
		Q_out			=>	Q_out,
      S   			=> S  ) ; 


  Process
	Begin
	 RST  <= '1'  ;
	wait for 20 ns ;
	 RST  <= '0'  ;
	wait;
 End Process;


-- "Clock Pattern"
  Process
	Begin
	 CLK <= '0' ;
	 wait for HALF_PERIOD;
	 CLK <= '1' ;
	 wait for HALF_PERIOD;
 End Process;

 
	Process(RST, FBaud_out, NSent) 
		Begin
			if(FBaud_out'event and FBaud_out='1') then -- When counter is over, we shift the Sent buffer so the last bit is received
				Rx <= Sent(0);
				for i in 0 to 6 loop
					Sent(i) <= Sent(i+1);
				end loop;
				Sent(7) <= '0';
			elsif (RST = '1' or NSent'event) then -- Assign the Sent buffer with the next one
				Sent	<= NSent;
			end if;
 End Process;

 
	Process(RST, Stop_out)
		Begin
			if (RST = '1') then
				NSent <= "00000000";
			elsif(Stop_out'event and Stop_out='0') then -- When all 8 bits have been read, we go to the next value we want to receive (arbitrary selected)
				case NSent is 
					when "00000000" => NSent <= "01110111"; --0x77
					when "01110111" => NSent <= "00101010"; --0x2A
					when "00101010" => NSent <= "10110111"; --0xB7
					when others => NSent <= "00000000";
				end case;
			end if;
			
End Process;	


  Process
	Begin
	 NBaud  <= "1101"  ;
	wait;
 End Process;
END;
