library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity LightControlSystem is 
port(
  clk, enable : in std_logic;	-- enable from CondManager AND noFault
  mod5, mod12, mod15 : in std_logic; -- modalities from ModManager
  m,n,s : in std_logic; -- conditions from CondManager
  red, yellow, green : out std_logic); -- ouput, each represents 1 color
end LightControlSystem;

architecture LightControlSystem_behav of LightControlSystem is
begin

fsm_mod: process
variable mod_time : time := 5 sec; -- variable for storing modality time
begin

--if rising_edge(clk) then
   if enable = '1' then
    
    -- get modality time
    if mod5 = '1' then
       mod_time := 5 sec;
    elsif mod12 = '1' then
       mod_time := 12 sec;
    elsif mod15 = '1' then
       mod_time := 15 sec;
    end if;

    -- maintenance
    if m = '1' then -- and n = '0' and s = '0'?
       red <= '1';
       yellow <= '1';
       green <= '1';
       -- TODO: how to re-modulate green
    end if;

    -- nominal
    if n = '1' then
       red <= '1'; wait for 5 sec; red <= '0';
       green <= '1'; wait for mod_time-2 sec;
       -- must overlap for 2 seconds
       yellow <= '1'; wait for 2 sec; yellow <= '0'; green <= '0';
    end if;

    -- standby
    if s = '1' then
       -- first set green and red to off
       red <= '0';
       green <= '0';
       -- process only modifies yellow
       yellow <= '1'; wait for 1 sec; 
       yellow <= '0'; wait for 2 sec;
    end if;


else -- enable = '0'
    red <= '0';
    yellow <= '0';
    green <= '0';

end if;

end process;

end LightControlSystem_behav;