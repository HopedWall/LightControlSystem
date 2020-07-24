library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity LightControlSystemCounter is 
port(
  clk, enable : in std_logic;	-- CLK is 1 hz/period is 1 sec
  mod5, mod12, mod15 : in std_logic; -- modalities from ModManager
  m,n,s : in std_logic; -- conditions from CondManager
  red, yellow, green : out std_logic); -- ouput, each represents 1 color
end LightControlSystemCounter;

architecture LightControlSystem_behav of LightControlSystemCounter is

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
component ControlLogic is 
  generic (Nb : integer) ;
  port(
  clk, enable : in std_logic;	-- CLK is 1 hz/period is 1 sec
  mod5, mod12, mod15 : in std_logic; -- modalities from ModManager
  m,n,s : in std_logic; -- conditions from CondManager
  data_out_counter : in std_logic_vector(Nb-1 downto 0); -- time from Counter
  red, yellow, green : out std_logic); -- ouput, each represents 1 color
end component;

constant numb : integer := 3;

-- Internal signals declaration.
signal data_out_counter_int: std_logic_vector(numb-1 downto 0);
signal enable_logic_to_count, reset_logic_to_count : std_logic;

-- begin architecture
begin
   -- only connect components
   control_logic_instance : ControlLogic generic map(Nb => numb)
       port map(clk, enable, mod5, mod12, mod15, m, n, s, data_out_counter_int, red, yellow, green);
   
   counter_reset_instance : counter_reset generic map(Nb => numb)
       port map(enable_logic_to_count, clk, reset_logic_to_count, data_out_counter_int);

end LightControlSystem_behav;
