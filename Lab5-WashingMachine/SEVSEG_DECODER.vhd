----------------------------------------------------------------------------------
-- University: Koc University, Istanbul Turkey 
-- Course Number: ELEC 204 - Fall 2017
--	Student: Ahmet Uysal - 60780
-- 
-- Create Date:    02:44:17 12/22/2017 
-- Module Name:    SEVSEG_DECODER - Behavioral 
-- Project Name: Lab 5 - Washing Machine Controller
-- Target Devices: Prometheus FPGA Board
-- Description: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SEVSEG_DECODER is
    Port ( SEVSEG_DATA : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
           SEVSEG_BUS : out  STD_LOGIC_VECTOR(6 DOWNTO 0));
end SEVSEG_DECODER;

architecture Behavioral of SEVSEG_DECODER is

begin

WITH SEVSEG_DATA SELECT SEVSEG_BUS <=
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
	"1111111" WHEN OTHERS;
	
end Behavioral;

