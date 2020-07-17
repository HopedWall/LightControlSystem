library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	 	 
entity test_ConditionManager is
    end test_ConditionManager;
    
architecture test_ConditionManager_behav of test_ConditionManager is
    
component ConditionManager is 
port(
  clk, enable: in std_logic;
  cond: in std_logic_vector(1 downto 0);
  m,n,s : out std_logic);
end ConditionManager;

component counter is
    generic ( Nb : integer) ;
    port( T           :in std_logic;
          clk         :in std_logic; 
          OUT_COUNT   :out std_logic_vector(Nb-1 downto 0)
    );
    end component;  

signal cond_int, m_int, n_int, s_int: std_logic;
signal clk_int, enable_int: std_logic;

constant numb : integer := 2;
cond_int <= data_out_counter(numb downto 0);

begin
    
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

signal data_out_counter: std_logic_vector(numb downto 0);

CM: ConditionManager port map(clk_int, '1', cond_int, m_int, n_int, s_int);
counter_tb : counter generic map (Nb => numb)
	  port map(enable_int, clock_int, data_out_counter);
   
end test_ConditionManager_behav;
