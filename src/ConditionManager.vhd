library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ConditionManager is 
port(
  clk, enable: in std_logic;
  cond: in std_logic_vector(1 downto 0);
  m,n,s : out std_logic);
end ConditionManager;

architecture ConditionManager_behav of ConditionManager is
	TYPE statetype IS (S_MAINTENANCE, S_NOMINAL, S_STANDBY, S_ERROR); 
	signal currentstate, nextstate: statetype;
begin

fsm_cond: process(cond, currentstate)
variable mns: std_logic_vector(2 downto 0); 
begin
case currentstate is 
	when S_MAINTENANCE => mns := "100";
		case cond is 
			when "01" => nextstate <= S_NOMINAL; 
			when "11" => nextstate <= S_STANDBY; 
			when "00" => nextstate <= S_MAINTENANCE; 	
			when others => nextstate <= S_ERROR; 
		end case;  --- cond=00
	
	when S_NOMINAL => mns := "010";
		case cond is 
			when "01" => nextstate <= S_NOMINAL; 
			when "11" => nextstate <= S_STANDBY; 
			when "00" => nextstate <= S_MAINTENANCE; 	
			when others => nextstate <= S_ERROR; 
		end case;  --- cond=01
	when S_STANDBY => mns := "011";
		case cond is 
			when "01" => nextstate <= S_NOMINAL; 
			when "11" => nextstate <= S_STANDBY; 
			when "00" => nextstate <= S_MAINTENANCE; 	
			when others => nextstate <= S_ERROR; 
		end case;  --- cond=11
	when S_ERROR => mns :="000"; 		
		case cond is 
			when "00" => nextstate <= S_MAINTENANCE; 
			when others => nextstate <= S_ERROR; --TODO: review
		end case;  --- cond=10
end case; -- currentstate case

s <= mns(0);
n <= mns(1);
m <= mns(2);


fsm_reset: process(clk) 
begin
if rising_edge(clk) then
	if enable='1' then
              currentstate <= nextstate;
        end if; -- end if enable
end if; -- end if reset
end process;

end ConditionManager_behav;