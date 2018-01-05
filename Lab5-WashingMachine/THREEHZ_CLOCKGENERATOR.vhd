----------------------------------------------------------------------------------
-- University: Koc University, Istanbul Turkey 
-- Course Number: ELEC 204 - Fall 2017
--	Student: Ahmet Uysal - 60780
-- 
-- Create Date:    23:55:25 12/21/2017 
-- Module Name:    THREEHZ_CLOCKGENERATOR - Behavioral 
-- Project Name: Lab 5 - Washing Machine Controller
-- Target Devices: Prometheus FPGA Board
-- Description: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity THREEHZ_CLOCKGENERATOR is
    Port ( MCLK : in  STD_LOGIC;
           THREEHZ_CLOCK : out  STD_LOGIC);
end THREEHZ_CLOCKGENERATOR;

architecture Behavioral of THREEHZ_CLOCKGENERATOR is
SIGNAL COUNTER : STD_LOGIC_VECTOR (28 DOWNTO 0):= "00000000000000000000000000000";
begin

process(MCLK)

BEGIN
	IF(MCLK'EVENT AND MCLK = '1') THEN
		IF(COUNTER < "10001111000011010001100000000") THEN 
			COUNTER <= COUNTER +1;
		ELSE
			COUNTER <= "00000000000000000000000000000";
		END IF;
	END IF;
END PROCESS;

THREEHZ_CLOCK <= '1' WHEN COUNTER < "01000111100001101000110000000"
ELSE '0';

end Behavioral;


