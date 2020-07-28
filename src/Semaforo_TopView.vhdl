library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Semaforo_TopView is 
port(
  clk, enable, reset	: in std_logic;	-- CLK is 1 hz/period is 1 sec
  condition		: in std_logic_vector(1 downto 0);
  modality		: in std_logic_vector(1 downto 0);
  red, yellow, green 	: out std_logic; -- ouput, each represents 1 color
  fault			: out std_logic_vector(3 downto 0));	
end Semaforo_TopView;

architecture Semaforo_TopView_behav of Semaforo_TopView is

-- Condition Manager.
component ConditionManager is
port(
  clk, enable	: in std_logic;
  cond		: in std_logic_vector(1 downto 0);
  counter_reset	: out std_logic; -- reset and enable for counter
  m, n, s, e	: out std_logic); -- ouput.
end component;

-- Modality Manager.
component ModalityManager is 
port(
  clk, enable, reset		: in std_logic;
  modality			: in std_logic_vector(1 downto 0);
  mod5, mod12, mod15, err 	: out std_logic); -- ouput.
end component;

-- LCS.
component LightControlSystemCounter is 
port(
  clk, enable 		: in std_logic;	-- CLK is 1 hz/period is 1 sec
  mod5, mod12, mod15 	: in std_logic; -- modalities from ModManager
  m,n,s 		: in std_logic; -- conditions from CondManager
  red, yellow, green 	: out std_logic); -- ouput, each represents 1 color
end component;

-- Fault Detector. 
component FaultDetector is
port(	
   enable 		: in std_logic; 
   err_MM, err_CM	: in std_logic;
   FAULT		: out std_logic_vector(3 downto 0));
end component;

-- Internal signals declaration.
signal mod5_int, mod12_int, mod15_int, err_MM_int : std_logic;
signal m_int, s_int, n_int, err_CM_int : std_logic;
signal fault_int : std_logic_vector(3 downto 0);
signal A, B, C, D : std_logic;

-- Composed signal declaration.
signal fault_for_enable_int : std_logic; -- OK config: 0001 --> enable = 1.
signal enable_LCS_int 	    : std_logic; -- Enable signal for LCS (Enable if not Fault and global enable).

-- begin architecture
begin

   -- Signal update.
   A <= fault_int(3);
   B <= fault_int(2);
   C <= fault_int(1);
   D <= fault_int(0);

   fault_for_enable_int <= (not A) and (not B) and (not C) and (D); -- OK config: 0001 --> enable = 1.
   enable_LCS_int 	<= enable and fault_for_enable_int; -- Enable signal for LCS (Enable if not Fault and global enable).
  
   -- Condition Manager.
   CM: ConditionManager port map(clk, enable, condition, m_int, n_int, s_int, err_CM_int);

   -- Modality Manager.
   MM: ModalityManager port map(clk, m_int, reset, modality, mod5_int, mod12_int, mod15_int, err_MM_int);
   
   -- LCS.
   LCS: LightControlSystemCounter port map(clk, enable_LCS_int, 
	mod5_int, mod12_int, mod15_int, 
	m_int, n_int, s_int,
	red, yellow, green);

   -- Fault Detector.
   FD: FaultDetector port map(enable, err_MM_int, err_CM_int, fault_int);

   -- Fault update (output).
   fault <= fault_int;

end Semaforo_TopView_behav;
