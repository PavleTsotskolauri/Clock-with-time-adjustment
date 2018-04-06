library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- 7 Segment display entity
entity display is
	port(
			i_clk, i_reset			: in std_logic;														-- 1Hz clock and reset			
			o_sec_out 				: out std_logic_vector(6 downto 0);								-- output for second display
			o_dec_sec_out 			: out std_logic_vector(6 downto 0);	   						-- output for second display
			o_min_out 				: out std_logic_vector(6 downto 0);	   						-- output for minute display
			o_dec_min_out 			: out std_logic_vector(6 downto 0);	   						-- output for minute display
			o_hour_out				: out std_logic_vector(6 downto 0);								-- output for hour display
			o_dec_hour_out			: out std_logic_vector(6 downto 0)								-- output for hour display
	);
end display;

-- 7 Segment display architecture
architecture bhv of display is

signal t_sec 		: 		integer 		:= 0;																-- counter for second
signal t_dec_sec 	: 		integer 		:= 0;																-- counter for decimal part of seconds
signal t_min		:		integer		:= 0;																-- counter for minutes
signal t_dec_min	:		integer		:= 0;																-- counter for decimal part of minutes
signal t_hour		:  	integer		:= 0;																-- counter for hours
signal t_dec_hour	:		integer		:= 0;																-- counter for decimal part of hours

begin
	counter: process (i_clk, i_reset)																-- process for clock and reset
	begin	
		if(i_reset = '0') then																				-- if reset is active (active-low) reset every display
			t_sec 			<= 0;
			t_dec_sec		<= 0;
			t_min				<= 0;
			t_dec_min		<= 0;
			t_hour			<= 0;
			t_dec_hour		<= 0;
		elsif(i_clk'event AND i_clk = '1') then						-- if rising_edge	 then	
			if(t_sec = 9) then																				-- if second display is 9 than 
				t_sec 		<= 0;																				-- reset
				t_dec_sec 	<= t_dec_sec + 1;																-- and increment decimal part of seconds
			else													
				t_sec 		<= t_sec + 1;																	-- increment seconds counter
			end if;													
																
			if(t_dec_sec = 5 AND t_sec = 9  ) then														-- decimal part of seconds is 5 and seconds is 9 then
				t_sec 		<= 0;																				-- reset seconds
				t_dec_sec 	<= 0;																				-- reset decimal part of seconds
				t_min			<= t_min + 1;																	-- and increment minute counter
			end if;
			
			if(t_min = 9 AND t_dec_sec = 5 AND t_sec = 9) then										-- if minutes is 9, decimal part of seconds is 5 and seconds is 9 then
				t_sec 		<= 0;																				-- reset seconds
				t_dec_sec 	<= 0;                               									-- reset decimal part of seconds
				t_min 	 	<= 0;																				-- reset minutes
				t_dec_min 	<= t_dec_min + 1;																-- and increment decimal part of minutes
			end if;
			
			if(t_dec_min = 5 AND t_min = 9 AND t_dec_sec = 5 AND t_sec = 9) then				-- if decimal part of minutes is 5, minutes is 9, decimal part of seconds is 5 and seconds is 9 then
				t_sec 		<= 0;																				-- reset seconds
				t_dec_sec 	<= 0;                                                 			-- reset decimal part of seconds				
				t_min	    	<= 0;																				-- reset minutes
				t_dec_min 	<= 0;                                                 			-- reset decimal part of minutes
				t_hour		<= t_hour + 1;
			end if;
			
			if(t_hour = 9 AND t_dec_min = 5 AND t_min = 9 AND t_dec_sec = 5 AND t_sec = 9) then		-- if hour is 9, decimal part of minutes is 5, minutes is 9, decimal part of seconds is 5 and seconds is 9 then
				t_sec 		<= 0;																				-- reset seconds
				t_dec_sec 	<= 0;                                                 			-- reset decimal part of seconds				
				t_min	    	<= 0;																				-- reset minutes
				t_dec_min 	<= 0;                                                 			-- reset decimal part of minutes
				t_hour		<= 0;																				-- reset hours
				t_dec_hour	<= t_dec_hour + 1;															-- and increment decimal part of hours
			end if;
			
			if(t_dec_hour = 2 AND t_hour = 3 AND t_dec_min = 5 AND t_min = 9 AND t_dec_sec = 5 AND t_sec = 9) then	-- if decimal part of hour is 2, hour is 3, decimal part of minutes is 5, minutes is 9, decimal part of seconds is 5 and seconds is 9 then
				t_sec 		<= 0;																				-- reset seconds
				t_dec_sec 	<= 0;                                                 			-- reset decimal part of seconds				
				t_min	    	<= 0;																				-- reset minutes
				t_dec_min 	<= 0;                                                 			-- reset decimal part of minutes
				t_hour		<= 0;																				-- reset hours
				t_dec_hour	<= 0;																				-- reset decimal part of hours
			end if;			
		 end if;
	end process counter;
	
	-- process for display outputs  (common anode)
	decoder:process(t_sec, t_dec_sec, t_min, t_dec_min, t_hour, t_dec_hour)											
	begin		
		
	-- seconds output
	case t_sec is																								
		when 0 				=> o_sec_out			<= "1000000"; -- 0
		when 1				=> o_sec_out			<= "1111001"; -- 1
		when 2				=> o_sec_out			<= "0100100"; -- 2
		when 3				=> o_sec_out			<= "0110000"; -- 3
		when 4				=> o_sec_out			<= "0011001"; -- 4
		when 5				=> o_sec_out			<= "0010010"; -- 5
		when 6				=> o_sec_out			<= "0000010"; -- 6
		when 7				=> o_sec_out			<= "1111000"; -- 7
		when 8				=> o_sec_out 			<= "0000000"; -- 8
		when 9				=> o_sec_out 			<= "0010000"; -- 9
		when others 		=> o_sec_out 			<= "1111111"; -- OFF
	end case;
	
	-- decimal part of seconds output
	case t_dec_sec is																							
		when 0 				=> o_dec_sec_out		<= "1000000"; -- 0
		when 1				=> o_dec_sec_out		<= "1111001"; -- 1
		when 2				=> o_dec_sec_out		<= "0100100"; -- 2
		when 3				=> o_dec_sec_out		<= "0110000"; -- 3
		when 4				=> o_dec_sec_out		<= "0011001"; -- 4
		when 5				=> o_dec_sec_out		<= "0010010"; -- 5
		when 6				=> o_dec_sec_out		<= "0000010"; -- 6
		when 7				=> o_dec_sec_out		<= "1111000"; -- 7
		when 8				=> o_dec_sec_out		<= "0000000"; -- 8
		when 9				=> o_dec_sec_out		<= "0010000"; -- 9
		when others 		=> o_dec_sec_out 		<= "1111111"; -- OFF
	end case;
	
	-- minutes output	
	case t_min is																								
		when 0 				=> o_min_out			<= "1000000"; -- 0
		when 1				=> o_min_out			<= "1111001"; -- 1
		when 2				=> o_min_out			<= "0100100"; -- 2
		when 3				=> o_min_out			<= "0110000"; -- 3
		when 4				=> o_min_out			<= "0011001"; -- 4
		when 5				=> o_min_out			<= "0010010"; -- 5
		when 6				=> o_min_out			<= "0000010"; -- 6
		when 7				=> o_min_out			<= "1111000"; -- 7
		when 8				=> o_min_out			<= "0000000"; -- 8
		when 9				=> o_min_out			<= "0010000"; -- 9
		when others 		=> o_min_out 			<= "1111111"; -- OFF
	end case;
	
	-- decimal part of minutes output
	case t_dec_min is 																						
		when 0 				=> o_dec_min_out		<= "1000000"; -- 0
		when 1				=> o_dec_min_out		<= "1111001"; -- 1
		when 2				=> o_dec_min_out		<= "0100100"; -- 2
		when 3				=> o_dec_min_out		<= "0110000"; -- 3
		when 4				=> o_dec_min_out		<= "0011001"; -- 4
		when 5				=> o_dec_min_out		<= "0010010"; -- 5
		when 6				=> o_dec_min_out		<= "0000010"; -- 6
		when 7				=> o_dec_min_out		<= "1111000"; -- 7
		when 8				=> o_dec_min_out		<= "0000000"; -- 8
		when 9				=> o_dec_min_out		<= "0010000"; -- 9
		when others 		=> o_dec_min_out 		<= "1111111"; -- OFF	
	end case;
	
	-- hour output
	case t_hour is 																							
		when 0 				=> o_hour_out			<= "1000000"; -- 0
		when 1				=> o_hour_out			<= "1111001"; -- 1
		when 2				=> o_hour_out			<= "0100100"; -- 2
		when 3				=> o_hour_out			<= "0110000"; -- 3
		when 4				=> o_hour_out			<= "0011001"; -- 4
		when 5				=> o_hour_out			<= "0010010"; -- 5
		when 6				=> o_hour_out			<= "0000010"; -- 6
		when 7				=> o_hour_out			<= "1111000"; -- 7
		when 8				=> o_hour_out			<= "0000000"; -- 8
		when 9				=> o_hour_out			<= "0010000"; -- 9
		when others 		=> o_hour_out 			<= "1111111"; -- OFF	
	end case;
	
	-- decimal part of hour output
	case t_dec_hour is 																						
		when 0 				=> o_dec_hour_out		<= "1000000"; -- 0
		when 1				=> o_dec_hour_out		<= "1111001"; -- 1
		when 2				=> o_dec_hour_out		<= "0100100"; -- 2
		when 3				=> o_dec_hour_out		<= "0110000"; -- 3
		when 4				=> o_dec_hour_out		<= "0011001"; -- 4
		when 5				=> o_dec_hour_out		<= "0010010"; -- 5
		when 6				=> o_dec_hour_out		<= "0000010"; -- 6
		when 7				=> o_dec_hour_out		<= "1111000"; -- 7
		when 8				=> o_dec_hour_out		<= "0000000"; -- 8
		when 9				=> o_dec_hour_out		<= "0010000"; -- 9
		when others 		=> o_dec_hour_out 	<= "1111111"; -- OFF	
	end case;
	end process decoder;		
end bhv;