library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- clock divide entity
entity clock_div is
	generic (
				One_Hz : integer := 25000000;					 -- 25MHz generic
				Ten_Hz : integer := 2500000							-- 2,5MHz generic
--				Ten_Hz : integer := 125000						
				);
	port(
			i_clk	  		: in std_logic;							-- 50MHz input
			i_reset 		: in std_logic;							-- Reset
			o_1Hz_out   : out std_logic							-- 1Hz output
--			o_10Hz_out	: out std_logic							-- 10Hz output
		  );
end clock_div;

-- clock divide architecture
architecture bhv of clock_div is

signal temp_1Hz 		: std_logic;							-- temporary signal for 1Hz output
--signal temp_10Hz		: std_logic := '0';					-- temporary signal for 10Hz output
signal counter_1Hz 	: integer 	:= 0;    				-- counter for 1Hz output
signal counter_10Hz 	: integer 	:= 0;						-- counter for 10Hz output

begin
	process (i_clk, i_reset)
		begin
		if(i_reset = '0') then									-- if reset is acitve (active-low) reset everything
			temp_1Hz 		<= '0';
--			temp_10Hz		<= '0';
			counter_1Hz 	<= 0;
--			counter_10Hz	<= 0;
		elsif (i_clk'event and i_clk = '1') then			-- if rising_edge start counting				
			if(counter_1Hz = One_Hz) then						-- if 1Hz counter is 25 Million then
				temp_1Hz 	<= NOT temp_1Hz;					-- toggle 1Hz output
				counter_1Hz	<= 0;									-- and reset 1Hz counter
			else		
				counter_1Hz <= counter_1Hz + 1;				-- Increment 1Hz counter
			end if;	
				
--			if(counter_10Hz = Ten_Hz) then					-- if 10Hz counter is 2,5 Million then
--				temp_10Hz 		<= NOT temp_10Hz;				-- toggle 10Hz output
--				counter_10Hz 	<= 0;								-- and reset 10Hz output
--			else	
--				counter_10Hz <= counter_10Hz + 1;			-- Increment 10Hz counter
--			end if;	
		end if;	
	end process;	
		
		o_1Hz_out 	<= temp_1Hz;								-- 1Hz output
--		o_10Hz_out	<= temp_10Hz;								-- 10hz output
end bhv;

-- END of File