library IEEE;

use IEEE.std_logic_1164.all;

entity hex_7seg is
    port(
    RST		:	in	std_logic;
	 CLK		:	in 	std_logic;
    Stop		:	in	std_logic;
	 Q       :  in std_logic_vector(3 downto 0);

    S       :  out std_logic_vector(6 downto 0)
    );

end hex_7seg;

architecture Tabla of Hex_7seg is
signal Qp, Qn	:	std_logic_vector(6 downto 0);

begin

    SEC: process(RST,CLK,Qn)
    begin
        if(RST= '1')then
            Qp<= (others=>'0');
        elsif(CLK'event and CLK='1')then
            Qp<= Qn;
        end if;
    end process SEC;

    COMB: process(Q,Stop)
	begin
        if(Stop= '0')then -- Keep the same value while Q is being modify
            Qn<= Qp;
        else -- Modify the display only when the data is full sent
            case Q is
        		when "0000" => Qn <= NOT("1111110"); -- 0
        		when "0001" => Qn <= NOT("0110000"); -- 1
        		when "0010" => Qn <= NOT("1101101"); -- 2
        		when "0011" => Qn <= NOT("1111001"); -- 3
        		when "0100" => Qn <= NOT("0110011"); -- 4
        		when "0101" => Qn <= NOT("1011011"); -- 5
        		when "0110" => Qn <= NOT("1011111"); -- 6
        		when "0111" => Qn <= NOT("1110010"); -- 7
        		when "1000" => Qn <= NOT("1111111"); -- 8
        		when "1001" => Qn <= NOT("1111011"); -- 9
            when "1010" => Qn <= NOT("1110111"); -- A
        		when "1011" => Qn <= NOT("0011111"); -- b
        		when "1100" => Qn <= NOT("1001110"); -- C
        		when "1101" => Qn <= NOT("0111101"); -- d
        		when "1110" => Qn <= NOT("1001111"); -- E
        		when "1111" => Qn <= NOT("1000111"); -- F
        		when others => Qn <= NOT("1000111"); -- F
    		end case;
        end if;
		  
		  S <= Qn;
		  
	end process COMB;
end Tabla;
