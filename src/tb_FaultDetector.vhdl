library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	 	 
entity test_FaultDetector is
    end test_FaultDetector;
    
architecture test_FaultDetector_behav of test_FaultDetector is

-- Declaration of components needed for TB. 
component FaultDetector is 
port (	enable		: in std_logic; 
	err_MM, err_CM	: in std_logic;
	FAULT		: out std_logic_vector(3 downto 0) 	
      );
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
signal fault_int: std_logic_vector(3 downto 0);
signal clk_int, enable_int: std_logic;
signal data_out_counter: std_logic_vector(numb-1 downto 0);

begin

-- Process used for test.    
clk_gen: process
begin
clk_int <= '1'; wait for 5 ns;
clk_int <= '0'; wait for 5 ns;
end process;

enable_counter: process
begin
enable_int <= '0'; wait for 10 ns;
enable_int <= '1'; wait for 10 ns;
end process;

-- Instancing components with map of corresponding signals.
				-- err_MM   	     err_CM.
FD: FaultDetector port map('1', data_out_counter(1), data_out_counter(0), fault_int);
counter_tb : counter generic map (Nb => numb) port map(enable_int, clk_int, data_out_counter);
   
end test_FaultDetector_behav;