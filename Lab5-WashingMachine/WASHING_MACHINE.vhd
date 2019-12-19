----------------------------------------------------------------------------------
-- University: Koc University, Istanbul Turkey 
-- Course Number: ELEC 204 - Fall 2017
--	Student: Ahmet Uysal - 60780
-- 
-- Create Date:    00:26:58 12/22/2017 
-- Module Name:    WASHING_MACHINE - Behavioral
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

entity WASHING_MACHINE is
    Port ( THREEHZ_CLOCK : in  STD_LOGIC;
           START : in  STD_LOGIC;
           FULL : in  STD_LOGIC;
           LOAD_IN : in  STD_LOGIC;
           MINUTE_INPUT : in  STD_LOGIC_VECTOR (4 downto 0);
           RESET : in  STD_LOGIC;
           PAUSE : in  STD_LOGIC;
           STOP : in  STD_LOGIC;
			  EMPTY : in  STD_LOGIC;
           IDLE : out  STD_LOGIC;
           HOT : out  STD_LOGIC;
           TURN : out  STD_LOGIC;
           SPIN1 : out  STD_LOGIC;
           DRAIN : out  STD_LOGIC;
           RINSE : out  STD_LOGIC;
			  WASH : out STD_LOGIC;
           COLD : out  STD_LOGIC;
           LOAD_OUT : out  STD_LOGIC;
           SPIN2 : out  STD_LOGIC;
           MINUTE_COUNTER : out  STD_LOGIC_VECTOR (4 downto 0)
           );
end WASHING_MACHINE;

architecture Behavioral of WASHING_MACHINE is

SIGNAL WIRE_IDLE: STD_LOGIC := '1';
SIGNAL WIRE_WASH,WIRE_SPIN1,WIRE_DRAIN,WIRE_RINSE,WIRE_COLD,WIRE_LOAD_OUT,WIRE_SPIN2: STD_LOGIC := '0';
SIGNAL WIRE_MINUTE_COUNTER: STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
SIGNAL IS_STARTED,IS_LOADED: STD_LOGIC := '0';
SIGNAL WIRE_HOT,WIRE_DEC, WIRE_TURN,WIRE_ZERO: STD_LOGIC := '0';

--ERROR:Xst:528 - Multi-source in Unit <WASHING_MACHINE> on signal <WIRE_LOAD_OUT>; this signal is connected to multiple drivers.
--ERROR:Xst:528 - Multi-source in Unit <WASHING_MACHINE> on signal <WIRE_HOT>; this signal is connected to multiple drivers.
--ERROR:Xst:528 - Multi-source in Unit <WASHING_MACHINE> on signal <WIRE_IDLE>; this signal is connected to multiple drivers.

begin

	START_COUNTER_AND_MACHINE_PROCESS: PROCESS(FULL,EMPTY,THREEHZ_CLOCK,PAUSE,START)
	BEGIN
		IF (THREEHZ_CLOCK'EVENT AND THREEHZ_CLOCK = '1') THEN
		
			IF(START = '1' AND IS_STARTED = '0') THEN -- ENTER THE WASH STATE
				WIRE_IDLE <= '0';
				IS_STARTED <= '1';
				WIRE_HOT <= '1';
				WIRE_WASH <= '1';
			END IF;
			
			IF(IS_LOADED = '1' AND PAUSE = '0') THEN
				IF WIRE_MINUTE_COUNTER > 0 THEN
					WIRE_MINUTE_COUNTER <= WIRE_MINUTE_COUNTER - 1;
				END IF;
			END IF;
			
			-- UPDATING WIRE_ZERO
			IF IS_LOADED = '1' THEN
				IF WIRE_MINUTE_COUNTER = "00000" THEN
					WIRE_ZERO <= '1';
				ELSE
					WIRE_ZERO <= '0';
				END IF;
			END  IF;
			
			-- UPDATING WIRE_LOAD_OUT
			IF WIRE_LOAD_OUT = '1' THEN
				WIRE_LOAD_OUT <= '0';
			END IF;
			
			-- WHEN MACHINE TOTALLY FILLED WITH HOT WATER
			IF(WIRE_WASH = '1' AND WIRE_HOT = '1' AND FULL = '1') THEN 
				WIRE_HOT <= '0';
			END IF;
			
			-- WHEN LOAD IS PRESSED FOR THE FIRST TIME IN THE WASH STATE
			IF(WIRE_WASH = '1' AND WIRE_HOT = '0' AND IS_LOADED = '0' AND LOAD_IN = '1') THEN 
				WIRE_MINUTE_COUNTER <= MINUTE_INPUT;
				IS_LOADED <= '1';
				WIRE_DEC <= '1';
				WIRE_TURN <= '1';
			END IF;
			
			-- WHEN THE WASH STATE ENDS
			IF(WIRE_WASH = '1' AND WIRE_ZERO = '1') THEN
				WIRE_WASH <= '0';
				WIRE_TURN <= '0';
				WIRE_DEC <= '0';
				WIRE_SPIN1 <= '1'; -- THE MACHINE IS NOW IN SPIN1 STATE
				WIRE_DRAIN <= '1';
			END IF;
			
			-- WHEN THE MACHINE GETS EMPTY IN SPIN1 STATE
			-- WIRE_DEC IS ADDED TO PREVENT ENTERING THIS IF STATEMENT MULTIPLE TIMES
			IF(WIRE_SPIN1 = '1' AND EMPTY = '1' AND WIRE_DEC = '0') THEN
				LOAD_OUT <= '1';
				WIRE_MINUTE_COUNTER <= "00111";
				WIRE_DEC <= '1';
				WIRE_TURN <= '1';
			END IF;
			
			-- WHEN THE SPIN1 STATE ENDS
			-- WIRE_DEC IS ADDED TO PREVENT ENTERING THIS IF STATEMENT BEFORE MACHINE GETS EMPTY
			IF(WIRE_SPIN1 = '1' AND WIRE_ZERO = '1' AND WIRE_DEC = '1') THEN
				WIRE_DRAIN <= '0';
				WIRE_DEC <= '0';
				WIRE_TURN <= '0';
				WIRE_SPIN1 <= '0';
				WIRE_RINSE <= '1'; -- THE MACHINE IS NOW IN RINSE STATE
				WIRE_COLD <= '1';
			END IF;
			
			-- WHEN THE MACHINE GETS FULL IN RINSE STATE
			IF(WIRE_RINSE = '1' AND WIRE_COLD = '1' AND FULL = '1') THEN
				WIRE_COLD <= '0';
				WIRE_LOAD_OUT <= '1';
				WIRE_MINUTE_COUNTER <= "01010";
				WIRE_DEC <= '1';
				WIRE_TURN <= '1';
			END IF;
			
			-- WHEN THE RINSE STATE ENDS
			-- WIRE_DEC IS ADDED TO PREVENT ENTERING THIS IF STATEMENT BEFORE MACHINE GETS FULL
			IF(WIRE_RINSE = '1' AND WIRE_ZERO = '1' AND WIRE_DEC = '1') THEN 
				WIRE_RINSE <= '0';
				WIRE_TURN <= '0';
				WIRE_DEC <= '0';
				WIRE_SPIN2 <= '1'; -- THE MACHINE IS NOW IN SPIN2 STATE
				WIRE_DRAIN <= '1';
			END IF;
			
			-- WHEN MACHINE GETS EMPTY IN SPIN2 STATE
			-- WIRE_DEC IS ADDED TO PREVENT ENTERING THIS IF STATEMENT MULTIPLE TIMES
			IF(WIRE_SPIN2 = '1' AND EMPTY = '1' AND WIRE_DEC = '0') THEN
				WIRE_LOAD_OUT <= '1';
				WIRE_MINUTE_COUNTER <= "01000";
				WIRE_DEC <= '1';
				WIRE_TURN <= '1';
			END IF;
			
			-- WHEN SPIN2 STATE ENDS AND MACHINE RETURNS THE IDLE STATE
			IF(WIRE_SPIN2 = '1' AND WIRE_ZERO = '1') THEN
				WIRE_DRAIN <= '0';
				WIRE_DEC <= '0';
				WIRE_TURN <= '0';
				WIRE_SPIN2 <= '0';
				WIRE_IDLE <= '1';
				IS_STARTED <= '0';
				IS_LOADED <= '0';
			END IF;
		END IF;
		IDLE <= WIRE_IDLE;
		WASH <= WIRE_WASH;
	HOT <= WIRE_HOT;
   TURN <= WIRE_TURN;
	SPIN1 <= WIRE_SPIN1;
	DRAIN <= WIRE_DRAIN;
	RINSE <= WIRE_RINSE;
	COLD <= WIRE_COLD;
	LOAD_OUT <= WIRE_LOAD_OUT;
	SPIN2 <= WIRE_SPIN2;
	MINUTE_COUNTER <= WIRE_MINUTE_COUNTER;
		
		
	END PROCESS;
	
	-- UPDATING OUTPUTS
	
end Behavioral;

