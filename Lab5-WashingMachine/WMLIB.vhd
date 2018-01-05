----------------------------------------------------------------------------------
-- University: Koc University, Istanbul Turkey 
-- Course Number: ELEC 204 - Fall 2017
--	Student: Ahmet Uysal - 60780
-- 
-- Create Date:    23:44:23 12/21/2017 
-- Module Name:    WMLIB - Behavioral 
-- Project Name: Lab 5 - Washing Machine Controller
-- Target Devices: Prometheus FPGA Board
-- Description: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WMLIB is
    Port ( START : in  STD_LOGIC;
           PAUSE : in  STD_LOGIC;
           STOP : in  STD_LOGIC;
           FULL : in  STD_LOGIC;
           EMPTY : in  STD_LOGIC;
           MCLK : in  STD_LOGIC;
           MINUTE_INPUT : in  STD_LOGIC_VECTOR (4 downto 0);
           RESET : in  STD_LOGIC;
           LOAD_IN : in  STD_LOGIC;
           SEVSEG_DATA : out  STD_LOGIC_VECTOR (6 downto 0);
           SEVSEG_CONTROL : out  STD_LOGIC_VECTOR (7 downto 0);
			  LOAD_OUT : out STD_LOGIC;
           WASH : out  STD_LOGIC;
           SPIN1 : out  STD_LOGIC;
           RINSE : out  STD_LOGIC;
           SPIN2 : out  STD_LOGIC;
           IDLE : out  STD_LOGIC;
           HOT : out  STD_LOGIC;
           COLD : out  STD_LOGIC;
           DRAIN : out  STD_LOGIC;
           TURN : out  STD_LOGIC);
end WMLIB;

architecture Behavioral of WMLIB is

SIGNAL WIRE_THREEHZ_CLOCK,WIRE_SEVSEG_CLOCK : STD_LOGIC;
SIGNAL WIRE_MINUTE_COUNTER: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL WIRE_SEVSEG_DATA: STD_LOGIC_VECTOR(3 DOWNTO 0);

begin

-- THREE HZ CLOCK

THREEHZCLOCK: ENTITY WORK.THREEHZ_CLOCKGENERATOR PORT MAP(
MCLK => MCLK,
THREEHZ_CLOCK => WIRE_THREEHZ_CLOCK
);

-- SEVSEG CLOCK

SEVSEGCLOCK: ENTITY WORK.SEVSEG_CLOCK_GENERATOR PORT MAP(
MCLK => MCLK,
SEVSEG_CLOCK => WIRE_SEVSEG_CLOCK
);

-- WASHING MACHINE

WASHING_MACHINE: ENTITY WORK.WASHING_MACHINE PORT MAP(
-- INPUTS
THREEHZ_CLOCK => WIRE_THREEHZ_CLOCK,
START => START,
FULL => FULL,
LOAD_IN => LOAD_IN,
MINUTE_INPUT => MINUTE_INPUT,
EMPTY => EMPTY,
RESET => RESET,
PAUSE => PAUSE,
STOP => STOP,
-- OUTPUTS
WASH => WASH,
IDLE => IDLE,
HOT => HOT,
TURN => TURN,
SPIN1 => SPIN1,
DRAIN => DRAIN,
RINSE => RINSE,
COLD => COLD,
LOAD_OUT => LOAD_OUT,
SPIN2 => SPIN2,
MINUTE_COUNTER => WIRE_MINUTE_COUNTER
);

-- SEVSEG DRIVER

SEVSEGDRIVER: ENTITY WORK.SEVSEG_DRIVER PORT MAP(
SEVSEG_CLOCK => WIRE_SEVSEG_CLOCK,
MINUTE_COUNTER => WIRE_MINUTE_COUNTER,
SEVSEG_DRIVER => SEVSEG_CONTROL,
SEVSEG_DATA => WIRE_SEVSEG_DATA
);

-- SEVSEG DECODER

SEVSEGDECODER: ENTITY WORK.SEVSEG_DECODER PORT MAP(
SEVSEG_DATA => WIRE_SEVSEG_DATA,
SEVSEG_BUS => SEVSEG_DATA
);

end Behavioral;

