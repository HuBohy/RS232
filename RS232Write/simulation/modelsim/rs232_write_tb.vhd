LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_arith.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.STD_LOGIC_UNSIGNED.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY rs232_write  IS 
END ; 
 
ARCHITECTURE rs232_write_arch OF rs232_write IS
  SIGNAL RST   		:  STD_LOGIC ; -- Reset
  SIGNAL CLK   		:  std_logic ; -- Clock
  SIGNAL NBaud 		:  std_logic_vector (3 downto 0) ; -- BaudRateIndex
  SIGNAL STR   		:  STD_LOGIC ; -- Start transmission
  SIGNAL DATAWR   	:  std_logic_vector (7 downto 0)  ; 
  SIGNAL FBaud_out   :  STD_LOGIC ; -- Ok signal for when the counter is over
  SIGNAL EOT   		:  STD_LOGIC ; -- End of transmission
  SIGNAL Tx   			:  STD_LOGIC ; -- Data transmitted
  
  CONSTANT HALF_PERIOD : time := 10 ns; -- Clock (50 MHz) half-period
  
  COMPONENT RS232Write  
    PORT ( 
      RST  			: in STD_LOGIC ; 
      CLK  			: in STD_LOGIC ; 
      NBaud  		: in std_logic_vector (3 downto 0) ;
      STR  			: in STD_LOGIC ;  
      DATAWR  		: in std_logic_vector (7 downto 0) ; 
      FBaud_out  	: out STD_LOGIC ; 
      EOT  			: out STD_LOGIC ;  
      Tx  			: out STD_LOGIC); 
  END COMPONENT ; 
  
BEGIN
  DUT  : RS232Write  
    PORT MAP ( 
      RST   		=> RST  ,
      CLK   		=> CLK  ,
      NBaud   		=> NBaud  ,
      STR   		=> STR  ,
		DATAWR   	=> DATAWR  ,
      FBaud_out   => FBaud_out  ,
      EOT   		=> EOT  ,
      Tx   			=> Tx) ; 


-- "Reset Pattern"
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
 
 
 -- "Transmitted value update Pattern"
  Process(RST, EOT)
	Begin
		if(RST = '1') then
			STR <= '1';
			DATAWR <= "00000000"; -- 0x00
		elsif(EOT'event and EOT='1') then
			case DATAWR is
				when "00000000" => DATAWR <= "01110111"  ; -- 0x77
				when "01110111" => DATAWR <= "00101010"; --0x2A
				when "00101010" => DATAWR <= "10110111"; --0xB7
				when others => STR <= '0';
			end case;
		end if;
 End Process;

-- "NBaud Pattern"
  Process
	Begin
	 NBaud  <= "1101"  ; -- cfr BaudRate
	wait;
 End Process;
END;
