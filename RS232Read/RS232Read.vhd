library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity RS232Read is
  port(

    RST     :   in  std_logic; -- Reset
    CLK     :   in  std_logic; -- Clock
    Rx      :   in  std_logic; -- Received Data
	 NBaud	:	 in  std_logic_vector(3 downto 0); -- Baud rate index
	 
	 RTR_out    :  out  std_logic;
	 Stop_out   :  out  std_logic;
	 FBaud_out 	: 	out std_logic;
	 Q_out		:	out std_logic_vector(7 downto 0);
	 
    S       :  out std_logic_vector(13 downto 0) -- Data for the 2 7-segments
   );
end RS232Read;

architecture moore of RS232Read is
signal FBaud   :   std_logic; -- Counter finished
signal DTR     :   std_logic; -- Data Terminal Ready
signal RTR     :   std_logic; -- Ready To Receive
signal Stop    :   std_logic; -- Stop receiving
signal Q       :   std_logic_vector(7 downto 0); -- Data Byte Received



component BaudRateRD is
	port(
	RST		:	in	std_logic;
	CLK		:	in	std_logic;
	DTR		:	in	std_logic;
	NBaud		:	in	std_logic_vector(3 downto 0);	-- Number of Bauds by second
	FBaud		:	out	std_logic						-- Base frequency
	);
end component;

component FSMRead is
	port(
	RST		:	in	std_logic;
	CLK		:	in 	std_logic;
	Rx		:	in	std_logic;
	FBaud	:	in	std_logic;
	DTR		:	out	std_logic;
	Stop		:	out	std_logic;
	RTR		:	out std_logic
	);
end component;

component RegSerPar is
	port(
	RST		:	in	std_logic;
	CLK		:	in	std_logic;
	Rx			:	in	std_logic;
	RTR		:	in	std_logic;
	Q			:	out std_logic_vector(7 downto 0)
	);
end component;

component hex_7seg is
    port(
    RST		:	in	std_logic;
	 CLK		:	in 	std_logic;
    Stop		:	in	std_logic;
	 Q       :  in std_logic_vector(3 downto 0);

    S       :   out std_logic_vector(6 downto 0)
    );
end component;

begin
	 RTR_out <= RTR;
	 Stop_out <= Stop;
	 FBaud_out <= FBaud;
	 Q_out <= Q;
	 
    FSM      :   FSMRead port map(RST,CLK,Rx,FBaud,DTR,Stop,RTR);
    RegS     :   RegSerPar port map(RST,CLK,Rx,RTR,Q);
    BaudR    :   BaudRateRD port map(RST,CLK,DTR,NBaud,FBaud);
    SEG_0    :   hex_7seg port map(RST,CLK,Stop,Q(3 downto 0),S(6 downto 0));
    SEG_1    :   hex_7seg port map(RST,CLK,Stop,Q(7 downto 4),S(13 downto 7));

end moore;
