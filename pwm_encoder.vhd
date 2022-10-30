--Written by Seckin Albamya for detecting and measuring the width of channel values.
library ieee;
use ieee.std_logic_1164.all;

entity pwm_encoder is

	generic(
			clock_freq		: integer := 27_000_000;
			clock_freq_mhz	: integer := 27;
			freq			: integer := 50
			);
	port(
		i_clk	: in	std_logic;	
		o_pwm	: out	std_logic;
		i_duty	: in	integer
	);

end pwm_encoder;

architecture pwm_generator of pwm_encoder is

	signal counter			:	integer		:= 0;

begin
	
	process(i_clk)
	begin
		if rising_edge(i_clk) then--in every rising edge of the ppm signal
			counter <= counter + 1;
			if counter < (i_duty * clock_freq_mhz) then--counts until reaches the duty time in microsecond
				o_pwm 	<= '0';
			elsif counter < (clock_freq / freq) then--counts until reaches the full period of the signal
				o_pwm <= '1';
			else
				counter <= 0;
			end if;
		end if;
	end process;

end pwm_generator;