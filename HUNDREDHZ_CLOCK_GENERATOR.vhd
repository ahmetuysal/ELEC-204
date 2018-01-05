----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:55:40 11/17/2017 
-- Design Name: 
-- Module Name:    HUNDREDHZ_CLOCK_GENERATOR - Behavioral 
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

entity CLOCK_GENERATOR is
    Port ( MCLK : in  STD_LOGIC;
           HZCLOCK : out  STD_LOGIC);
end CLOCK_GENERATOR;

architecture Behavioral of CLOCK_GENERATOR is

SIGNAL COUNTER : STD_LOGIC_VECTOR(16 DOWNTO 0) := "00000000000000000";

begin

CLK_PROCESS: PROCESS(MCLK)

BEGIN 

	IF(MCLK'EVENT AND MCLK = '1') THEN
		IF(COUNTER < "10011100010000000") THEN 
			COUNTER <= COUNTER + 1;
		ELSE 
			COUNTER <= "00000000000000000";
		END IF;
	END IF;
END PROCESS;

   HZCLOCK <= '1' 	WHEN COUNTER < "01001110001000000" ELSE '0';

end Behavioral;

