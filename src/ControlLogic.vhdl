library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- contains to_integer
use ieee.numeric_std.all;

entity ControlLogic is
generic (Nb : integer);
port(
  clk, enable : in std_logic;	-- CLK is 1 hz/period is 1 sec
  mod5, mod12, mod15 : in std_logic; -- modalities from ModManager
  m,n,s : in std_logic; -- conditions from CondManager
  data_out_counter : in std_logic_vector(Nb-1 downto 0);
  reset_counter : out std_logic; -- for enable/setting the counter
  red, yellow, green : out std_logic); -- ouput, each represents 1 color
end ControlLogic;

architecture ControlLogic_behav of ControlLogic is
begin

control_lights: process(data_out_counter)
variable previous_state : character; -- variable for storing previous state
variable reset_variable : std_logic; -- variable for resetting the counter
--variable enable_variable : std_logic;
variable mod_time : integer := 5; -- variable for storing modality time
variable curr_time : integer := 0; -- variable for storing current time from counter
variable red_var, yellow_var, green_var : std_logic := '0'; -- variables for output
variable need_to_reset : character := 'y'; -- used for reset first time.
begin
  
--if rising_edge(clk) then

   -- set reset to 0
   reset_variable := '0';
   --enable_variable := '1';
   -- set lights to 0
   red_var := '0';
   yellow_var := '0';
   green_var := '0';

   -- should we keep enable?
   if enable = '1' then
   
   -- First time counter need to reset. 
   -- If not resetted it starts from 1 after first rising edge.
   if need_to_reset = 'y' then
   	reset_variable := '1';
   	need_to_reset := 'n';
   else

    --report "Curr time" & std_logic'image(data_out_counter(0));
    curr_time := to_integer(UNSIGNED(data_out_counter));
    report "Curr time" & integer'image(curr_time);

    -- reset counter
    if previous_state = 'n' and n = '0' then
       reset_variable := '1';
    end if;
    if previous_state = 'm' and m = '0' then
       reset_variable := '1';
    end if;
    if previous_state = 's' and s = '0' then
       reset_variable := '1';
    end if;
    --if previous_state = 'o' then -- if system was in off or error state reset counter next time that starts.
    --   reset_variable := '1';
    --end if;
    
    -- get modality time
    if mod5 = '1' then
       mod_time := 5;
    elsif mod12 = '1' then
       mod_time := 12;
    elsif mod15 = '1' then
       mod_time := 15;
    end if;

    -- maintenance
    if m = '1' and n = '0' and s = '0' then
       previous_state :=  'm';
       red_var := '1';
       yellow_var := '1';
       green_var := '1';
    end if;

    -- nominal
    if n = '1' and m='0' and s='0' then
       previous_state := 'n';
       if curr_time >= 0 and curr_time < mod_time then     --red for 5 secs
          red_var := '1';
	  report "RED time " & integer'image(curr_time);
       elsif curr_time >= mod_time and curr_time < (2*mod_time - 2) then  --only green for 3 secs
          green_var := '1';
       elsif curr_time >= (2*mod_time-2) and curr_time < 2*mod_time then --green and yellow for 2 secs
          green_var := '1';
          yellow_var := '1';
       end if;
       
       if curr_time > 2*mod_time-1 then
          --report "INSIDE IF";
          reset_variable := '1';
       end if;
    end if;

    -- standby
    if s = '1' and n='0' and m='0' then
      previous_state := 's';
      --report "Curr time" & integer'image(curr_time);
      if (curr_time mod 3) = 0 then
         yellow_var := '1';        --1 sec yellow is on
      else
         yellow_var := '0';        --2 secs yellow is off
      end if;
    end if;

    -- off or error
    --if s = '0' and n='0' and m='0' then
    --  previous_state := 'o';     
    --  red_var := '0';
    --  yellow_var := '0';
    --  green_var := '0';
    --  enable_variable := 0;
    --end if;
  
   end if; -- need_to_reset

   else -- enable = '0' / error or off state
       previous_state := 'o';
       red_var := '0';
       yellow_var := '0';
       green_var := '0';
       --enable_variable := '0';
       need_to_reset := 'y';
   end if;

-- update signals from variables before process ends
--report "Yellow" & std_logic'image(yellow_var);
report "Reset variable" & std_logic'image(reset_variable);

red <= red_var;
yellow <= yellow_var;
green <= green_var;

-- update reset counter
reset_counter <= reset_variable;
--enable_counter <= enable_variable;

end process;

end ControlLogic_behav;