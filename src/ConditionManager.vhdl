library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ConditionManager is 
port(
  clk, enable: in std_logic;
  cond: in std_logic_vector(1 downto 0);
  m, n, s, e : out std_logic); -- ouput.
end ConditionManager;

architecture ConditionManager_behav of ConditionManager is
	TYPE statetype IS (S_OFF, S_MAINTENANCE, S_NOMINAL, S_STANDBY, S_ERROR); -- States.
	signal currentstate, nextstate: statetype;
begin

fsm_cond: process(cond, currentstate)
variable mnse: std_logic_vector(3 downto 0); -- variable for remember output values.
begin

case currentstate is 
	when S_OFF => mnse := "0000";
		case cond is 
			when "00" => nextstate <= S_MAINTENANCE; 	
			when others => nextstate <= S_OFF; 
		end case;  --- Enable=0
	when S_MAINTENANCE => mnse := "1000";
		case cond is 
			when "01" => nextstate <= S_NOMINAL; 
			when "11" => nextstate <= S_STANDBY; 
			when "00" => nextstate <= S_MAINTENANCE; 	
			when others => nextstate <= S_ERROR; 
		end case;  --- cond=00
	when S_NOMINAL => mnse := "0100";
		case cond is 
			when "01" => nextstate <= S_NOMINAL; 
			when "11" => nextstate <= S_STANDBY; 
			when "00" => nextstate <= S_MAINTENANCE; 	
			when others => nextstate <= S_ERROR; 
		end case;  --- cond=01
	when S_STANDBY => mnse := "0010";
		case cond is 
			when "01" => nextstate <= S_NOMINAL; 
			when "11" => nextstate <= S_STANDBY; 
			when "00" => nextstate <= S_MAINTENANCE; 	
			when others => nextstate <= S_ERROR; 
		end case;  --- cond=11
	when S_ERROR => mnse :="0001"; 		
		case cond is 
			when "01" => nextstate <= S_NOMINAL; 
			when "11" => nextstate <= S_STANDBY; 
			when "00" => nextstate <= S_MAINTENANCE;
			when others => nextstate <= S_ERROR; --TODO: review
		end case;  --- cond=10
end case; -- currentstate case

-- Assign varible BUS to single output signals.
e <= mnse(0);
s <= mnse(1);
n <= mnse(2);
m <= mnse(3);

end process;

-- Process for udate current state with next state variables on clk's rising edge.
-- Enable: Sinc. - Active High.
fsm_reset_cond: process(clk) 
begin
if rising_edge(clk) then
	if enable='1' then
              	currentstate <= nextstate;
	elsif enable = '0' then
		currentstate <= S_OFF; -- If enable = 0 --> OFF state.
        end if; -- end if enable
end if; -- end if rising edge
end process;

end ConditionManager_behav;