library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity demux is
	port (data			: in 	std_logic;												-- demux input (from mux)		
			sel			: in  std_logic;												-- demux control
			disp_clk		: out std_logic;												-- data to clock output
			disp_sec		: out std_logic;												-- data to seconds display output
			disp_min		: out std_logic;												-- data to minutes display output
			disp_hour	: out std_logic;												-- data to hour display output
			state			: out std_logic_vector(3 downto 0)						-- demux state output
			);
end demux;

architecture demux1 of demux is

signal demux_sel			: integer	:= 0;											-- signal for demux control

begin
	demux: process (sel)																	-- process for demux control
		begin
			if(sel'event AND sel = '0') then
				if(demux_sel = 3) then
					demux_sel <= 0;
				else
					demux_sel <= demux_sel + 1;
				end if;
			end if;
		end process demux;
		
	de_mux: process(demux_sel, data)													-- demux architecture
	begin
		case demux_sel is
			when 0 => disp_clk 	<= data; disp_sec <= '0'; disp_min <= '0'; disp_hour <= '0'; 
			when 1 => disp_sec 	<= data;	disp_clk <= '0'; disp_min <= '0'; disp_hour <= '0';
			when 2 => disp_min 	<= data;	disp_sec <= '0'; disp_clk <= '0'; disp_hour <= '0';
			when 3 => disp_hour 	<= data; disp_sec <= '0'; disp_min <= '0'; disp_clk  <= '0';
			when others => 
				disp_clk		<= '0';
			   disp_sec		<= '0';
			   disp_min		<= '0';
			   disp_hour	<= '0';
		end case;
	end process de_mux;
	
	
	state <= std_logic_vector(to_unsigned(demux_sel, state'length));		-- demux state indicator
--	with demux_sel select
--	freq_out <= disp_clk		when 0,
--					disp_sec 	when 1,
--					disp_min 	when 2,
--					disp_hour	when 3,
--					'0' when 	others;

end demux1;