library IEEE;
use IEEE.std_logic_1164.all;
-- Top-Level Entity clock 
entity clock is
	port(
		i_clk, i_reset 			: in 	std_logic;										-- clock (50Mhz) and reset
		mode, inc					: in  std_logic;
		next_disp					: in  std_logic;
		o_clock_sec_out 			: out std_logic_vector(6 downto 0);				-- output for second display
		o_clock_dec_sec_out 		: out std_logic_vector(6 downto 0);				-- output for second display
		o_clock_min_out			: out std_logic_vector(6 downto 0);				-- output for minute display
		o_clock_dec_min_out		: out std_logic_vector(6 downto 0);				-- output for minute display
		o_clock_hour_out			: out std_logic_vector(6 downto 0);	
		o_clock_dec_hour_out		: out std_logic_vector(6 downto 0);	
		sec 							: out std_logic;										-- output for 1Hz indication		
		mux_state					: out std_logic;
		demux_state					: out std_logic_vector(3 downto 0)
	);
end clock;


-- Top-Level architecture
architecture structural of clock is

component clock_div is																		-- clock divide component
	port(
		i_clk	  		: in  std_logic;														-- clock divide referece clock (50MHz)
		i_reset 		: in  std_logic;														-- clock divide reset
		o_1Hz_out   : out std_logic														-- 1Hz output
--		o_10Hz_out	: out std_logic														-- 10Hz output
);
end component;

component mux is
	port (clk_1Hz	: in 	std_logic;
			cor		: in 	std_logic;
			sel		: in  std_logic;
			freq_out	: out std_logic;
			state		: out std_logic
			);
end component;

component demux is
	port (data			: in 	std_logic;
			sel			: in  std_logic;
			disp_clk		: out std_logic;
			disp_sec		: out std_logic;
			disp_min		: out std_logic;
			disp_hour	: out std_logic;
			state			: out std_logic_vector(3 downto 0)
			);
end component;

component disp_sec is
	port (i_clk, i_reset 		: in  std_logic;
			o_disp_sec_out			: out std_logic_vector(6 downto 0);
			o_disp_dec_sec_out	: out std_logic_vector(6 downto 0);
			o_60_sec_out			: out std_logic
			);
end component;

component disp_min is
	port (i_clk, i_reset 		: in  std_logic;
			o_disp_min_out			: out std_logic_vector(6 downto 0);
			o_disp_dec_min_out	: out std_logic_vector(6 downto 0);
			o_60_min_out			: out std_logic
			);
end component;

component disp_hour is
	port (i_clk, i_reset 		: in  std_logic;							
			o_disp_hour_out		: out std_logic_vector(6 downto 0);
			o_disp_dec_hour_out	: out std_logic_vector(6 downto 0)
			);
end component;

component or_gate is
	port (A, B 	: in 	std_logic;
			Q		: out std_logic
			);
end component;


signal s_clock_div_1Hz_out 	: std_logic;											-- itermediate signal for clock_div 1Hz output
signal s_clock_div_10Hz_out	: std_logic;											-- itermediate signal for clock_div 10Hz output
					
signal s_mux_out					: std_logic;

signal s_demux_clock_out		: std_logic;
signal s_demux_sec_out			: std_logic;
signal s_demux_min_out			: std_logic;
signal s_demux_hour_out			: std_logic;

signal s_or_gate_sec_out		: std_logic;
signal s_or_gate_min_out		: std_logic;
signal s_or_gate_hour_out		: std_logic;

signal s_60_sec_out				: std_logic;
signal s_60_min_out				: std_logic;

begin 
	u1 : clock_div port map (	i_clk 				=> i_clk,						-- clock_div clock to Clock (Top_level) input (50MHz)
										i_reset 				=> i_reset,						-- clock_div Reset to Clock Reset
										o_1Hz_out 			=> s_clock_div_1Hz_out		-- 1Hz output to Clock 1Hz output
--										o_10Hz_out			=> s_clock_div_10Hz_out		-- 10Hz output to Clock 10Hz output
									);
									
									
	u2 : mux 		port map (	clk_1Hz				=> s_clock_div_1Hz_out,
										cor					=> inc,
										sel					=> mode,
										freq_out				=> s_mux_out,
										state					=> mux_state
									);
									
	u3 : demux		port map (	data					=> s_mux_out,
										sel					=> next_disp,
										disp_clk				=> s_demux_clock_out,
										disp_sec				=> s_demux_sec_out,
										disp_min				=> s_demux_min_out,
										disp_hour			=> s_demux_hour_out,
										state					=> demux_state
									);
									
gate_sec: or_gate	port map	(	A						=> s_demux_clock_out,
										B						=> s_demux_sec_out,
										Q						=> s_or_gate_sec_out
									);
									
gate_min: or_gate port map (	A						=> s_60_sec_out,
										B						=> s_demux_min_out,
										Q						=> s_or_gate_min_out
										);
									
gate_hour:or_gate port map (	A						=> s_60_min_out,
										B						=> s_demux_hour_out,
										Q						=> s_or_gate_hour_out
									);
									
	u4 : disp_sec	port map (i_clk					=> s_or_gate_sec_out,
									 i_reset					=> i_reset,
									 o_disp_sec_out		=> o_clock_sec_out,
									 o_disp_dec_sec_out	=> o_clock_dec_sec_out,
									 o_60_sec_out			=> s_60_sec_out
									);
									
	u5	: disp_min	port map (i_clk					=> s_or_gate_min_out,
									 i_reset					=> i_reset,
									 o_disp_min_out		=> o_clock_min_out,
									 o_disp_dec_min_out	=> o_clock_dec_min_out,
									 o_60_min_out			=> s_60_min_out
									);
									
	u6	: disp_hour	port map (i_clk					=> s_or_gate_hour_out,
									 i_reset					=> i_reset,
									 o_disp_hour_out		=> o_clock_hour_out,
									 o_disp_dec_hour_out	=> o_clock_dec_hour_out
									);
									
	sec 	<= s_clock_div_1Hz_out;															-- indication for 1Hz
end structural;