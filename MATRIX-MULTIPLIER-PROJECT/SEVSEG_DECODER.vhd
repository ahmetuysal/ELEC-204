----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:47:23 11/17/2017 
-- Design Name: 
-- Module Name:    SEVSEG_DECODER - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SEVSEG_DECODER is
    Port ( SEVSEG_DATA_BCD : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
           SEVSEG_BUS : out  STD_LOGIC_VECTOR (6 downto 0));
end SEVSEG_DECODER;

architecture Behavioral of SEVSEG_DECODER is

begin

WITH SEVSEG_DATA_BCD SELECT SEVSEG_BUS <=
	"0000001" WHEN "0000",--0
	"1001111" WHEN "0001",--1
	"0010010" WHEN "0010",--2
	"0000110" WHEN "0011",--3
	"1001100" WHEN "0100",--4
	"0100100" WHEN "0101",--5
	"0100000" WHEN "0110",--6
	"0001111" WHEN "0111",--7
	"0000000" WHEN "1000",--8
	"0000100" WHEN "1001",--9
	"0001000" WHEN "1010",--A
	"1100000" WHEN "1011",--B
	"0110001" WHEN "1100",--C
	"1111111" WHEN OTHERS;

end Behavioral;

