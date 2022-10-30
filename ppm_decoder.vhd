--V1.0 Written by Seckin Albamya for detecting and measuring the width of channel values.
--Please read how_it_works.txt file for understanding the input signal and the code given below.
library ieee;
use ieee.std_logic_1164.all;


entity ppm_decoder is
	generic(
		clock_freq_mhz		:	integer		:= 27;--cloc freq
		ppm_end_time_limit	:	integer		:= 4000 --4ms end signal for synchronization of PPM signal(read how_it_works.txt for more details)
	);
	
	port(
		i_clk			: in std_logic;
		i_ppm_signal	: in std_logic;
		o_ch_value		: inout integer := 0;
		o_ch_number		: inout	integer	:= 1--initial ch value is 1(first channel)
	);

end ppm_decoder;

architecture main of ppm_decoder is

	signal time_counter			:	integer					:= 0;
	signal ppm_counter			:	integer					:= 0;
	
	begin
-------------------------------------------------Detector------------------------------------------
	process(i_clk)
	begin
		if rising_edge(i_clk) then--in every rising edge time counter rises up
				time_counter <= time_counter + 1;
		end if;
	end process;

	process(i_ppm_signal)
	begin
		if rising_edge(i_ppm_signal) then--in every rising edge of the ppm signal
			ppm_counter 	<= time_counter;--function calculates the time difference between two rising edge
			o_ch_value		<= (time_counter - ppm_counter) / clock_freq_mhz;--and divides clock freq for obtaining the time lenght in us
			o_ch_number		<= o_ch_number + 1;--after calculating the period of the one channel, go further with next channel
			
			if o_ch_value > ppm_end_time_limit then -- after end of the signal
				o_ch_number 	<= 1;--go to the first channel
			end if;
			
		end if;
	
	end process;

end main;

	