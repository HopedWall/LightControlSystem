library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	 	 
entity test_Semaforo_TopView is
    end test_Semaforo_TopView;
    
architecture test_Semaforo_TopView_behav of test_Semaforo_TopView is

-- Counter for testing purposes
component Semaforo_TopView is 
port(
  clk, enable, reset	: in std_logic;	-- CLK is 1 hz/period is 1 sec
  condition		: in std_logic_vector(1 downto 0);
  modality		: in std_logic_vector(1 downto 0);
  red, yellow, green 	: out std_logic; -- ouput, each represents 1 color
  fault			: out std_logic_vector(3 downto 0));
end component;	 

-- Internal signals declaration.
signal green_int, yellow_int, red_int: std_logic;
signal fault_int : std_logic_vector(3 downto 0);
signal clk_int: std_logic;
signal cond_int, mod_int : std_logic_vector(1 downto 0);

begin

-- Process used for test.    
clk_gen: process
begin
clk_int <= '1'; wait for 10 ns;
clk_int <= '0'; wait for 10 ns;
end process;

input_gen: process
begin
-- OFF
cond_int <= "01"; mod_int <= "11"; wait for 50 ns; -- Not change -> exit only with 00 on maintenance.
-- Maintenance.
cond_int <= "00"; mod_int <= "00"; wait for 200 ns; -- All lights up.
-- ERROR
--cond_int <= "10"; mod_int <= "11"; wait for 200 ns; -- Not change -> exit only with 00 on maintenance.
-- Stand By.
cond_int <= "11"; mod_int <= "00"; wait for 200 ns; -- Yellow 1 up 2 down. Modality doesn't change.
-- Nominal Mod 5.
cond_int <= "01"; mod_int <= "01"; wait for 1000 ns; -- Mod 5. and modality doesn't change.
-- Maintenance set Mod 12
cond_int <= "00"; mod_int <= "01"; wait for 200 ns; -- All lights up.
-- Nominal Mod 12
cond_int <= "01"; mod_int <= "01"; wait for 1000 ns; -- Mod 5. and modality doesn't change.
-- Maintenance set Mod 15
cond_int <= "00"; mod_int <= "11"; wait for 200 ns; -- All lights up.
-- Nominal Mod 12
cond_int <= "01"; mod_int <= "11"; wait for 1500 ns; -- Mod 5. and modality doesn't change.
end process;

-- Instancing components with map of corresponding signals.
STV: Semaforo_TopView port map(clk_int, '1', '1', cond_int, mod_int,
	red_int, yellow_int, green_int, fault_int);

--counter_tb : counter generic map (Nb => numb)
--	  port map('1', clk_int, data_out_counter);
end test_Semaforo_TopView_behav;
