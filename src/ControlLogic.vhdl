library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


-- contains to_integer
use ieee.numeric_std.all;

entity ControlLogic is
generic (Nb : integer);
port(
  clk, enable : in std_logic;	-- CLK is 1 hz/period is 1 sec
  mod5, mod12, mod15 : in std_logic; -- modalities from ModManager
  m,n,s : in std_logic; -- conditions from CondManager
  data_out_counter : in std_logic_vector(Nb downto 0);
  enable_count, reset_counter : out std_logic; -- for enable/setting the counter
  red, yellow, green : out std_logic); -- ouput, each represents 1 color
end ControlLogic;

architecture ControlLogic_behav of ControlLogic is
begin

control_lights: process(clk)
variable mod_time : integer := 5; -- variable for storing modality time
variable curr_time : integer := 0;
variable red_var, yellow_var, green_var : std_logic := '0';
begin
  
if rising_edge(clk) then
   -- should we keep enable?
   if enable = '1' then

    curr_time := to_integer(UNSIGNED(data_out_counter));
    
    -- get modality time
    if mod5 = '1' then
       mod_time := 5;
    elsif mod12 = '1' then
       mod_time := 12;
    elsif mod15 = '1' then
       mod_time := 15;
    end if;

    -- maintenance
    if m = '1' then -- and n = '0' and s = '0'?
       red_var := '1';
       yellow_var := '1';
       green_var := '1';
    end if;


   else -- enable = '0'
       red_var := '0';
       yellow_var := '0';
       green_var := '0';

   end if;
end if;

-- update signals from variables before process ends
red <= red_var;
yellow <= yellow_var;
green <= green_var;

end process;

end ControlLogic_behav;