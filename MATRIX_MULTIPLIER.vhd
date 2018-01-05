----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:39:22 11/17/2017 
-- Design Name: 
-- Module Name:    MATRIX_MULTIPLIER - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MATRIX_MULTIPLIER is
    Port ( A1 : in  STD_LOGIC_VECTOR (4 downto 0);
           A2 : in  STD_LOGIC_VECTOR (4 downto 0);
           A3 : in  STD_LOGIC_VECTOR (4 downto 0);
           A4 : in  STD_LOGIC_VECTOR (4 downto 0);
           B1 : in  STD_LOGIC_VECTOR (4 downto 0);
           B2 : in  STD_LOGIC_VECTOR (4 downto 0);
           B3 : in  STD_LOGIC_VECTOR (4 downto 0);
           B4 : in  STD_LOGIC_VECTOR (4 downto 0);
           C1 : out  STD_LOGIC_VECTOR (10 downto 0);
           C2 : out  STD_LOGIC_VECTOR (10 downto 0);
           C3 : out  STD_LOGIC_VECTOR (10 downto 0);
           C4 : out  STD_LOGIC_VECTOR (10 downto 0));
end MATRIX_MULTIPLIER;

architecture Behavioral of MATRIX_MULTIPLIER is

SIGNAL A1_INT,A2_INT,A3_INT,A4_INT,B1_INT,B2_INT,B3_INT,B4_INT,C1_INT,C2_INT,C3_INT,C4_INT : INTEGER;

begin

	A1_INT <= to_integer(unsigned(A1));
	A2_INT <= to_integer(unsigned(A2));
	A3_INT <= to_integer(unsigned(A3));
	A4_INT <= to_integer(unsigned(A4));
	B1_INT <= to_integer(unsigned(B1));
	B2_INT <= to_integer(unsigned(B2));
	B3_INT <= to_integer(unsigned(B3));
	B4_INT <= to_integer(unsigned(B4));

	C1_INT <= A1_INT * B1_INT + A2_INT * B3_INT;
	C2_INT <= A1_INT * B2_INT + A2_INT * B4_INT;
	C3_INT <= A3_INT * B1_INT + A4_INT * B3_INT;
	C4_INT <= A3_INT * B2_INT + A4_INT * B4_INT;
	
	C1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(C1_INT,C1'LENGTH));
	C2 <= STD_LOGIC_VECTOR(TO_UNSIGNED(C2_INT,C2'LENGTH));
	C3 <= STD_LOGIC_VECTOR(TO_UNSIGNED(C3_INT,C3'LENGTH));
	C4 <= STD_LOGIC_VECTOR(TO_UNSIGNED(C4_INT,C4'LENGTH));
end Behavioral;

