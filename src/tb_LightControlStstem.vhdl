library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	 	 
entity test_LightControlSystem is
    end test_LightControlSystem;
    
architecture test_LightControlSystem_behav of test_LightControlSystem is

-- Declaration of components needed for TB. 
component LightControlSystem is 
port(
  clk, enable: in std_logic;
  mod5, mod12, mod15: in std_logic;
  m, n, s: in std_logic;
  red, yellow, green : out std_logic);
end component;

-- Internal signals declaration.
signal red_int, yellow_int, green_int: std_logic;

signal clk_int, enable_int: std_logic;
signal mod5_int, mod12_int, mod15_int : std_logic;
signal m_int, n_int, s_int : std_logic;

begin

-- Process used for test.    
clk_gen: process
begin
clk_int <= '1'; wait for 5 ns;
clk_int <= '0'; wait for 5 ns;
end process;

enable_gen: process
begin
enable_int <= '0'; wait for 10 ns;
enable_int <= '1'; wait for 10 ns;
end process;

mod5_gen: process
begin
mod5_int <= '0'; wait for 20 ns;
mod5_int <= '1'; wait for 20 ns;
end process;

mod12_gen: process
begin
mod12_int <= '0'; wait for 40 ns;
mod12_int <= '1'; wait for 40 ns;
end process;

mod15_gen: process
begin
mod15_int <= '0'; wait for 80 ns;
mod15_int <= '1'; wait for 80 ns;
end process;

m_int_gen: process
begin
m_int <= '0'; wait for 160 ns;
m_int <= '1'; wait for 160 ns;
end process;

n_int_gen: process
begin
n_int <= '0'; wait for 320 ns;
n_int <= '1'; wait for 320 ns;
end process;

s_int_gen: process
begin
s_int <= '0'; wait for 640 ns;
s_int <= '1'; wait for 640 ns;
end process;

-- Instancing components with map of corresponding signals.
--LCS: LightControlSystem port map(clk_int, '1', mod5_int, mod12_int, mod15_int, m_int, n_int, s_int, red_int, yellow_int, green_int);
   
end test_LightControlSystem_behav;