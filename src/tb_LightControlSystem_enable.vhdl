library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	 	 
entity test_LightControlSystem_enable is
    end test_LightControlSystem_enable;
    
architecture test_LightControlSystem_enable_behav of test_LightControlSystem_enable is

-- Counter for testing purposes
component counter is
    generic ( Nb : integer) ;
    port( T           :in std_logic;
          clk         :in std_logic; 
          OUT_COUNT   :out std_logic_vector(Nb-1 downto 0)
    );
end component; 

-- LightControlSystem that must be tested
component LightControlSystemCounter is 
port(
  clk, enable : in std_logic;	-- CLK is 1 hz/period is 1 sec
  mod5, mod12, mod15 : in std_logic; -- modalities from ModManager
  m,n,s : in std_logic; -- conditions from CondManager
  red, yellow, green : out std_logic); -- ouput, each represents 1 color
end component;

constant numb : integer := 6;

-- Internal signals declaration.
signal green_int, yellow_int, red_int : std_logic;
signal clk_int, enable_LCS_int: std_logic;
signal data_out_counter: std_logic_vector(numb-1 downto 0);

begin

-- Process used for test.    
clk_gen: process
begin
clk_int <= '1'; wait for 10 ns;
clk_int <= '0'; wait for 10 ns;
end process;

enable_LCS_gen: process
begin
enable_LCS_int <= '1'; wait for 305 ns;
enable_LCS_int <= '0'; wait for 156 ns;
end process;

input_gen: process
begin
-- maintenance
data_out_counter <= "000100"; wait for 100 ns; -- ok
-- standby
data_out_counter <= "000001"; wait for 100 ns; -- ok
-- nominal 5
data_out_counter <= "100010"; wait for 200 ns; -- ok
-- maintenance
data_out_counter <= "000100"; wait for 100 ns; -- ok
-- nominal 12
data_out_counter <= "010010"; wait for 2000 ns; --ok
-- maintenance
data_out_counter <= "000100"; wait for 100 ns; -- ok
-- nominal 15
data_out_counter <= "001010"; wait for 2500 ns; --ok
end process;

-- Instancing components with map of corresponding signals.
LCS: LightControlSystemCounter port map(clk_int, enable_LCS_int, 
	data_out_counter(5), data_out_counter(4), data_out_counter(3), 
	data_out_counter(2), data_out_counter(1), data_out_counter(0), 
	red_int, yellow_int, green_int);

--counter_tb : counter generic map (Nb => numb)
--	  port map('1', clk_int, data_out_counter);
end test_LightControlSystem_enable_behav;
