library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	 	 
entity test_ModalityManager_enable_reset is
    end test_ModalityManager_enable_reset;
    
architecture test_ModalityManager_enable_reset_behav of test_ModalityManager_enable_reset is

-- Declaration of components needed for TB. 
component ModalityManager is 
port(
  clk, enable, reset: in std_logic;
  modality: in std_logic_vector(1 downto 0);
  mod5, mod12, mod15, err : out std_logic); -- ouput.
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
signal mod5_int, mod12_int, mod15_int, err_int: std_logic;
signal clk_int, enable_counter_int, enable_MM_int, reset_int: std_logic;
signal data_out_counter: std_logic_vector(numb-1 downto 0);

begin

-- Process uses for test.    
clk_gen: process
begin
clk_int <= '1'; wait for 5 ns;
clk_int <= '0'; wait for 5 ns;
end process;

enable_counter: process
begin
enable_counter_int <= '0'; wait for 10 ns;
enable_counter_int <= '1'; wait for 10 ns;
end process;

enable_MM: process
begin
enable_MM_int <= '1'; wait for 63 ns;
enable_MM_int <= '0'; wait for 33 ns;
end process;

reset_gen: process
begin
reset_int <= '1'; wait for 100 ns;
reset_int <= '0'; wait for 32 ns;
end process;

-- Instancing components with map of corresponding signals.
-- Note: RESET when signal equal to 0.
MM: ModalityManager port map(clk_int, enable_MM_int, reset_int, data_out_counter, mod5_int, mod12_int, mod15_int, err_int);
counter_tb : counter generic map (Nb => numb)
	  port map(enable_counter_int, clk_int, data_out_counter);
   
end test_ModalityManager_enable_reset_behav;
