library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	 	 
entity test_ConditionManager is
    end test_ConditionManager;
    
architecture test_ConditionManager_behav of test_ConditionManager is

-- Declaration of components needed for TB. 
component ConditionManager is 
port(
  clk, enable: in std_logic;
  cond: in std_logic_vector(1 downto 0);
  m,n,s,e : out std_logic);
end component;

component counter is
    generic ( Nb : integer) ;
    port( T           :in std_logic;
          clk         :in std_logic; 
          OUT_COUNT   :out std_logic_vector(Nb-1 downto 0)
    );
end component;  

constant numb : integer := 2;

-- Internal signals declaration.
signal m_int, n_int, s_int, e_int: std_logic;
signal clk_int, enable_int: std_logic;
signal data_out_counter: std_logic_vector(numb-1 downto 0);

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

-- Instancing components with map of corresponding signals.
CM: ConditionManager port map(clk_int, '1', data_out_counter, m_int, n_int, s_int, e_int);
counter_tb : counter generic map (Nb => numb)
	  port map(enable_int, clk_int, data_out_counter);
   
end test_ConditionManager_behav;
