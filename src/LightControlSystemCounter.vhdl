library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity LightControlSystem is 
port(
  clk, enable : in std_logic;	-- CLK is 1 hz/period is 1 sec
  mod5, mod12, mod15 : in std_logic; -- modalities from ModManager
  m,n,s : in std_logic; -- conditions from CondManager
  data_out_counter : in std_logic_vector(Nb-1 downto 0); -- time from Counter 
  red, yellow, green : out std_logic); -- ouput, each represents 1 color
end LightControlSystem;

architecture LightControlSystem_behav of LightControlSystem is

constant Nb : integer := 2;

-- COUNTER w/ reset, this will be used to keep track of time
component counter_reset is
    generic ( Nb : integer) ;
    port( T           :in std_logic;
          clk         :in std_logic; 
          reset       :in std_logic;
          OUT_COUNT   :out std_logic_vector(Nb-1 downto 0)
    );
end component;  

-- CONTROL LOGIC, this controls the outputs
entity ControlLogic is 
port(
  clk, enable : in std_logic;	-- CLK is 1 hz/period is 1 sec
  mod5, mod12, mod15 : in std_logic; -- modalities from ModManager
  m,n,s : in std_logic; -- conditions from CondManager
  data_out_counter : in std_logic_vector(Nb downto 0); -- time from Counter
  red, yellow, green : out std_logic); -- ouput, each represents 1 color
end ControlLogic;

-- begin architecture
begin

-- TODO: connect components

end LightControlSystem_behav;
