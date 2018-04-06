library IEEE;
use IEEE.std_logic_1164.all;

entity or_gate is
	port (A, B 	: in 	std_logic;
			Q		: out std_logic
			);
end or_gate;

architecture orgate of or_gate is
begin
	Q <= A OR B;
end orgate;