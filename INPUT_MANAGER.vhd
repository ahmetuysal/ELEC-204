----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:59:22 11/17/2017 
-- Design Name: 
-- Module Name:    INPUT_MANAGER - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity INPUT_MANAGER is
    Port ( INPUT : in  STD_LOGIC_VECTOR (9 downto 0);
           INPUT_SELECT : in  STD_LOGIC;
           SAVE_BUTTON : in  STD_LOGIC;
			  RESET_BUTTON : in STD_LOGIC;
           A1 : out  STD_LOGIC_VECTOR (4 downto 0);
           A2 : out  STD_LOGIC_VECTOR (4 downto 0);
           A3 : out  STD_LOGIC_VECTOR (4 downto 0);
           A4 : out  STD_LOGIC_VECTOR (4 downto 0);
           B1 : out  STD_LOGIC_VECTOR (4 downto 0);
           B2 : out  STD_LOGIC_VECTOR (4 downto 0);
           B3 : out  STD_LOGIC_VECTOR (4 downto 0);
           B4 : out  STD_LOGIC_VECTOR (4 downto 0);
			  SELECT_COUNTER : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			  ISSELECTING : out STD_LOGIC;
			  LED_CONTROLLER : out STD_LOGIC_VECTOR(3 DOWNTO 0));
			  
end INPUT_MANAGER;

architecture Behavioral of INPUT_MANAGER is

SIGNAL COUNTER : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
SIGNAL ISSELECTED : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

begin

	INPUT_PROCESS : PROCESS(INPUT_SELECT)
	
	BEGIN
		IF (INPUT_SELECT'EVENT AND INPUT_SELECT = '1') THEN
			COUNTER <= COUNTER + 1;
		END IF;
	END PROCESS;
	
--	RESET_PROCESS : PROCESS(RESET_BUTTON) --Deleted because we cannot access a signal from two different processes
--	
--	BEGIN
--		IF(RESET_BUTTON'EVENT AND RESET_BUTTON = '1') THEN
--			ISSELECTED <= "0000";
--		END IF;
--	END PROCESS;

	SAVE_AND_RESET_PROCESS : PROCESS(SAVE_BUTTON,RESET_BUTTON)

	BEGIN
		IF (SAVE_BUTTON'EVENT AND SAVE_BUTTON = '1' AND ISSELECTED /= "1111") THEN
			IF (COUNTER = "00") THEN
				A1 <= INPUT (9 DOWNTO 5);
				A2 <= INPUT (4 DOWNTO 0);
				ISSELECTED(0) <= '1';
			ELSIF (COUNTER = "01") THEN
				A3 <= INPUT (9 DOWNTO 5);
				A4 <= INPUT (4 DOWNTO 0);
				ISSELECTED(1) <= '1';
			ELSIF (COUNTER = "10") THEN
				B1 <= INPUT (9 DOWNTO 5);
				B2 <= INPUT (4 DOWNTO 0);
				ISSELECTED(2) <= '1';
			ELSIF (COUNTER = "11") THEN
				B3 <= INPUT (9 DOWNTO 5);
				B4 <= INPUT (4 DOWNTO 0);
				ISSELECTED(3) <= '1';
			END IF;
		END IF;
		
		IF(RESET_BUTTON = '1') THEN -- NO RESET_BUTTON'EVENT B/C we cant have "flip-flop sensitive to the rising edge of two different clocks"
			ISSELECTED <= "0000";
		END IF;
		
	END PROCESS;
	
	WITH ISSELECTED SELECT ISSELECTING <=
		'0' WHEN "1111",
		'1' WHEN OTHERS;	
		
	SELECT_COUNTER <= COUNTER;
	LED_CONTROLLER <= ISSELECTED;
end Behavioral;

