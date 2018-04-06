library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity disp_sec is
	generic (minutes	: integer := 59																	-- generic for 1 minute
				);
	port (i_clk, i_reset 		: in  std_logic;														-- clock and reset
			o_disp_sec_out			: out std_logic_vector(6 downto 0);								-- seconds output
			o_disp_dec_sec_out	: out std_logic_vector(6 downto 0);								-- dec secound output
			o_60_sec_out			: out std_logic														-- 1 minute output for minutes display
			);
end disp_sec;

architecture sec of disp_sec is

signal t_sec 		: 		integer 		:= 0;																-- counter for second
signal t_dec_sec 	: 		integer 		:= 0;																-- counter for decimal part of seconds
signal counter_60	:		integer		:= 0;																-- counter for 1 minute
-- Seven segment Display (SSD) Driver
function ssd (input : integer) 																			-- seven segment display (SSD) driver function
return std_logic_vector is	
variable output : std_logic_vector(6 downto 0);
begin 
	case input is																								
		when 0 				=> output			:= "1000000"; -- 0
		when 1				=> output			:= "1111001"; -- 1
		when 2				=> output			:= "0100100"; -- 2
		when 3				=> output			:= "0110000"; -- 3
		when 4				=> output			:= "0011001"; -- 4
		when 5				=> output			:= "0010010"; -- 5
		when 6				=> output			:= "0000010"; -- 6
		when 7				=> output			:= "1111000"; -- 7
		when 8				=> output 			:= "0000000"; -- 8
		when 9				=> output 			:= "0010000"; -- 9
		when others 		=> output 			:= "1111111"; -- OFF
	end case;
	return output;
end ssd;

begin
	counter: process (i_clk, i_reset)
	begin
		if(i_reset = '0') then																				-- if reset is active (active-low) reset every display
			t_sec 		<= 0;
			t_dec_sec 	<= 0;
			counter_60	<= 0;
		elsif(i_clk'event AND i_clk = '1') then														-- if rising_edge	 then	
			if(t_sec = 9) then																				-- if second display is 9 than 
				t_sec 		<= 0;																				-- reset
				t_dec_sec 	<= t_dec_sec + 1;																-- and increment decimal part of seconds
			else													
				t_sec 		<= t_sec + 1;																	-- increment seconds counter
			end if;
			
			if(t_dec_sec = 5 AND t_sec = 9  ) then														-- decimal part of seconds is 5 and seconds is 9 then
				t_sec 		<= 0;																				-- reset seconds
				t_dec_sec 	<= 0;																				-- reset decimal part of seconds
			end if;
			
			if(counter_60 = minutes) then
				o_60_sec_out <= '1';
				counter_60 <= 0;
			else
				o_60_sec_out <= '0';
				counter_60 <= counter_60 + 1;
			end if;
		end if;
	end process counter;
	
	o_disp_sec_out 		<= ssd(t_sec);
	o_disp_dec_sec_out	<= ssd(t_dec_sec);
	
end sec;