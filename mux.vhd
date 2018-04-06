library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux is
	port (clk_1Hz	: in 	std_logic;									-- 1Hz Input
			cor		: in 	std_logic;									-- time settings pin (increment)
			sel		: in  std_logic;									-- mux control pin for 1 Hz and time settings pins
			freq_out	: out std_logic;									-- mux output
			state		: out std_logic									-- mux state
			);
end mux;

architecture mux1 of mux is

signal mux_sel			: integer	range 0 to 1 := 0;			-- signal for mux select pin
signal inv_cor			: std_logic;
begin
inv_cor  <= not cor;														-- button invert (because its active low)
	mux: process (sel)													-- process for mux select
	begin
		if(sel'event AND sel = '0') then
			if(mux_sel = 1) then
				mux_sel <= 0;
			else
				mux_sel <= mux_sel + 1;
			end if;
		end if;
	end process mux;
	
	with mux_sel select													-- mux output select
	freq_out <= clk_1Hz 	when 0,
					inv_cor	when 1,
					'0' when others;
					
	with mux_sel select													-- mux state indicator
	state <= 	'1' 	when 1,												
					'0' 	when 0,
					'0' when others;
--	state <= std_logic(mux_sel);
					
end mux1;