----------------------------------------------------------------------------------
-- Company: Koç University
-- Engineer: Ahmet Uysal - MERVE KARAKAS
-- 
-- Create Date:    18:03:15 10/15/2017 
-- Design Name: 	
-- Module Name:    MMLIB - Behavioral 
-- Project Name: 2-by-2 5 bit signed matrix multiplier
-- Target Devices: Prometheus FPGA Board
-- Tool versions: 
-- Description: 
--
-- Dependencies:
-- 	SEVSEG_DRIVER.VHD
--		SEVSEG_DECODER.VHD
--		
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MMLIB is
    Port ( INPUT_MANAGER : in  STD_LOGIC;
			  MCLK : in STD_LOGIC;
           SAVE_BUTTON : in  STD_LOGIC;
			  RESET_BUTTON: in STD_LOGIC;
           ELEMENT_INPUT : in  STD_LOGIC_VECTOR (9 downto 0);
			  SAVED_LED : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
           SEVSEG_CONTROL : out  STD_LOGIC_VECTOR (7 downto 0);
           SEVSEG_DATA : out  STD_LOGIC_VECTOR (6 downto 0));
end MMLIB;

architecture Behavioral of MMLIB is

SIGNAL WIRE_HZ_CLOCK : STD_LOGIC;
SIGNAL WIRE_ISSELECTING : STD_LOGIC;
SIGNAL WIRE_SELECT_COUNTER : STD_LOGIC_VECTOR (1 DOWNTO 0);
SIGNAL WIRE_SEVSEG_DATA : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL WIRE_RESULT_C1 : STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL WIRE_RESULT_C2 : STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL WIRE_RESULT_C3 : STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL WIRE_RESULT_C4 : STD_LOGIC_VECTOR (10 DOWNTO 0);
SIGNAL A1,A2,A3,A4,B1,B2,B3,B4 : STD_LOGIC_VECTOR (4 DOWNTO 0);

begin

--CLOCK GENERATOR

CLOCKGENERATOR : ENTITY WORK.CLOCK_GENERATOR PORT MAP(
		MCLK => MCLK,
		HZCLOCK => WIRE_HZ_CLOCK
);

--INPUT MANAGER

INPUTMANAGER : ENTITY WORK.INPUT_MANAGER PORT MAP(
		INPUT => ELEMENT_INPUT,
		INPUT_SELECT => INPUT_MANAGER,
		SAVE_BUTTON => SAVE_BUTTON,
		RESET_BUTTON => RESET_BUTTON,
		ISSELECTING => WIRE_ISSELECTING,
		SELECT_COUNTER => WIRE_SELECT_COUNTER,
		LED_CONTROLLER => SAVED_LED,
		A1 => A1,
		A2 => A2,
		A3 => A3,
		A4 => A4,
		B1 => B1,
		B2 => B2,
		B3 => B3,
		B4 => B4
);

-- MATRIX MULTIPLIER

MATRIXMULTIPLIER : ENTITY WORK.MATRIX_MULTIPLIER PORT MAP(
		A1 => A1,
		A2 => A2,
		A3 => A3,
		A4 => A4,
		B1 => B1,
		B2 => B2,
		B3 => B3,
		B4 => B4,
		C1 => WIRE_RESULT_C1,
		C2 => WIRE_RESULT_C2,
		C3 => WIRE_RESULT_C3,
		C4 => WIRE_RESULT_C4
);

-- SEVEN SEGMENT DISPLAY DRIVER 

DRIVER : ENTITY WORK.SEVSEG_DRIVER PORT MAP(
		C1 => WIRE_RESULT_C1,
		C2 => WIRE_RESULT_C2,
		C3 => WIRE_RESULT_C3,
		C4 => WIRE_RESULT_C4,
		CLK => WIRE_HZ_CLOCK,
		ISSELECTING => WIRE_ISSELECTING,
		SELECT_COUNTER => WIRE_SELECT_COUNTER,
		SEVSEG_DATA_BCD => WIRE_SEVSEG_DATA,
		SEVSEG_DRIVER => SEVSEG_CONTROL,
		SELECTING_DISPLAY_INPUT => ELEMENT_INPUT
);

-- SEVEN SEGMENT DISPLAY DECODER (INCLUDES CHANGING THE BASE)

DECODER : ENTITY WORK.SEVSEG_DECODER PORT MAP(
		SEVSEG_DATA_BCD => WIRE_SEVSEG_DATA,
		SEVSEG_BUS => SEVSEG_DATA
);
end Behavioral;

