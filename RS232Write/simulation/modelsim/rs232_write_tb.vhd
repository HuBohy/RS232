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
  SIGNAL STR   		:  STD_LOGIC  ; 
  SIGNAL DATAWR   	:  std_logic_vector (7 downto 0)  ; 
  SIGNAL FBaud_out   :  STD_LOGIC ; -- Ok signal for when the counter is over
  SIGNAL EOT   		:  STD_LOGIC  ; 
  SIGNAL Tx   			:  STD_LOGIC  ; 
  
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


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 4 us, Period = 0 ps
  Process
	Begin
	 STR  <= '1'  ;
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 4 us, Period = 0 ps
  Process
	Begin
	 DATAWR  <= "01110111"  ;
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 4 us, Period = 0 ps
  Process
	Begin
	 NBaud  <= "1101"  ;
	wait;
 End Process;
END;
