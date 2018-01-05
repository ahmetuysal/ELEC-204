----------------------------------------------------------------------------------
-- University: Koc University, Istanbul Turkey 
-- Course Number: ELEC 204 - Fall 2017
--	Student: Ahmet Uysal - 60780
-- 
-- Create Date:    00:37:26 12/22/2017 
-- Module Name:    SEVSEG_DRIVER - Behavioral 
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

entity SEVSEG_DRIVER is
    Port ( SEVSEG_CLOCK : in  STD_LOGIC;
           MINUTE_COUNTER : in  STD_LOGIC_VECTOR (4 downto 0);
           SEVSEG_DRIVER : out  STD_LOGIC_VECTOR (7 downto 0);
           SEVSEG_DATA : out  STD_LOGIC_VECTOR (3 downto 0));
end SEVSEG_DRIVER;

architecture Behavioral of SEVSEG_DRIVER is

SIGNAL COUNTER: STD_LOGIC := '0';
SIGNAL BCD_DATA: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

-- DOUBLE DABBLE ALGORITHM --
PROCEDURE F_5BIT_BINARY_2_8BIT_BCD (
	SIGNAL FIVEBIT_BINARY_IN : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL RESULT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	)IS
		
		VARIABLE TEMP : STD_LOGIC_VECTOR(4 DOWNTO 0);
		VARIABLE BCD : UNSIGNED(7 DOWNTO 0);
		
		BEGIN
		--Zero the bcd var
		BCD := (OTHERS => '0');
		--Read input to temp var
		TEMP(4 DOWNTO 0) := FIVEBIT_BINARY_IN;
		
		--Cycle 5 times (number of input bits)
		
		FOR I IN 0 TO 4 LOOP
		
			IF(BCD(3 DOWNTO 0) >  4) THEN
				BCD(3 DOWNTO 0) := BCD(3 DOWNTO 0) +3;
			END IF;
			--shift bcd left 1 bit, concatanate with msb of temp
			BCD := BCD(6 DOWNTO 0) & TEMP(4);
			--Shift temp left 1 bit
			TEMP := TEMP(3 DOWNTO 0) & '0';
		END LOOP;
			
		RESULT <= STD_LOGIC_VECTOR(BCD);
			
END PROCEDURE F_5BIT_BINARY_2_8BIT_BCD;


begin

PROCESS_CLK : PROCESS(SEVSEG_CLOCK)
	BEGIN 
		IF (SEVSEG_CLOCK'EVENT AND SEVSEG_CLOCK = '1') THEN
			COUNTER <= NOT COUNTER ;
		END IF;
		
		F_5BIT_BINARY_2_8BIT_BCD(MINUTE_COUNTER,BCD_DATA);
		
		
	END PROCESS;

-- SELECTING SEVSEG CELL TO UPDATE 
	WITH COUNTER SELECT SEVSEG_DRIVER <=
	"11111110" WHEN '0',
	"11111101" WHEN '1',
	"00001111" WHEN OTHERS;

-- SELECTING DATA TO DISPLAY
	WITH COUNTER SELECT SEVSEG_DATA <=
	BCD_DATA(3 DOWNTO 0) WHEN '0',
	BCD_DATA(7 DOWNTO 4) WHEN '1',
	"1111" WHEN OTHERS;
	

end Behavioral;

