library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	 	 
entity test_CounterReset is
    end test_CounterReset;
    
architecture test_CounterReset_behav of test_CounterReset is

component counter_reset is
    generic ( Nb : integer) ;
    port( T           :in std_logic;
          clk         :in std_logic;
          reset       :in std_logic;
          OUT_COUNT   :out std_logic_vector(Nb-1 downto 0)
    );
end component; 

constant numb : integer := 4;

-- Internal signals declaration.
signal clk_int, enable_int, reset_int : std_logic;
signal data_out_counter: std_logic_vector(numb-1 downto 0);

begin

-- Process uses for test.    
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

reset_gen: process
begin
reset_int <= '0'; wait for 83 ns;
reset_int <= '1'; wait for 33 ns;
end process;

-- Instancing components with map of corresponding signals.
-- Note: RESET when signal equal to 0.
counter_tb : counter_reset generic map (Nb => numb)
	  port map(enable_int, clk_int, reset_int, data_out_counter);
   
end test_CounterReset_behav;
