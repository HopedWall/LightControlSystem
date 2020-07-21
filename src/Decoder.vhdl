library ieee;
use ieee.std_logic_1164.all;

----- DECODER 2x4.
entity Decoder2x4 is
port (	A1,A0  : in std_logic; 
	enable : in std_logic;
	B3,B2,B1,B0: out std_logic
      );
end Decoder2x4;
     
architecture Decoder2x4_behav of Decoder2x4 is
	signal temp:std_logic_vector(1 downto 0);
begin
	temp <= A1 & A0;
	B0 <= enable when temp="00" else '0';
	B1 <= enable when temp="01" else '0';
	B2 <= enable when temp="10" else '0';
	B3 <= enable when temp="11" else '0';
end Decoder2x4_behav;