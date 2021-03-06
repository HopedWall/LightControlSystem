library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity FaultDetector is
port (	enable : in std_logic; 
	err_MM, err_CM: in std_logic;
	FAULT: out std_logic_vector(3 downto 0) 	
      );
end FaultDetector;
        
architecture FaultDetector_behav of FaultDetector is
-- Declaration of components needed for TB. 
component Decoder2x4_behav is 
port(	A1,A0  : in std_logic; 
	enable : in std_logic;
	B3,B2,B1,B0: out std_logic
      );
end component;

begin
	fault_detector: entity Decoder2x4 port map (err_MM, err_CM, enable, FAULT(3), FAULT(2), FAULT(1), FAULT(0));
	-- OUTPUT:
	-- 0001 : OK.
	-- 0010	: CM_error.
	-- 0100	: MM_error.
	-- 1000 : CM and MM errors.	
end FaultDetector_behav;
