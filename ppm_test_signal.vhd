--Written by Seckin Albamya for testing the system on FPGA board without real RC receiver.
--It is a test signal for testbench system. It is NOT necessary for system which is implemented on FPGA.
library ieee;
use ieee.std_logic_1164.all;

entity ppm_test_signal is

	generic(
		clock_freq		:	integer		:= 27_000_000;
		clock_freq_mhz	:	integer		:= 27
	);
	
	port(
		i_clk				: in	std_logic;
		o_ppm_test_signal	: out	std_logic
	);	

end ppm_test_signal;

architecture main of ppm_test_signal is
-------------------------------------------------Signal declerations-------------------------------
	type ch_values_array is array (0 to 7) of integer;
	signal ch_values			:	ch_values_array := (1050, 1150, 1200,1350, 1450, 1550, 1650, 1750);
	signal timer_counter		:	integer			:= 0;
	signal temp_counter			:	integer			:= 0;
	signal ppm_period_counter	:	integer			:= 0;
	signal current_ch			:	integer			:= 3;

begin

-------------------------------------------------PPM signal----------------------------------------
	process(i_clk)
	begin
		if rising_edge(i_clk) then
			ch_values(0) <= 1050;
			ch_values(1) <= 1150;
			ch_values(2) <= 1250;
			ch_values(3) <= 1350;
			ch_values(4) <= 1450;
			ch_values(5) <= 1550;
			ch_values(6) <= 1650;
			ch_values(7) <= 1750;
			
		
			timer_counter <= timer_counter + 1;
					
			if current_ch <= 7 then--initial ch value
						
				if timer_counter - temp_counter < clock_freq/2000 then--if time counter is smaller than minimum ch on period
					o_ppm_test_signal <= '1';--output active
				elsif (timer_counter - temp_counter) < clock_freq_mhz*ch_values(current_ch) then -- if time counter is smaller than ch value
					o_ppm_test_signal <= '0';--output_low
				elsif timer_counter - temp_counter = clock_freq_mhz*ch_values(current_ch) then-- when finishes a signal
					temp_counter <= timer_counter;--reset the time counter
					current_ch <= current_ch + 1;--next channel
				end if;
				
			else--after the meaningful signals(ch values)
				if timer_counter - temp_counter < clock_freq/2000 then --if the time counter smaller than ch on time
					o_ppm_test_signal <= '1';--output high
				elsif (timer_counter - ppm_period_counter) < clock_freq/50 then --if time counter is smaller than period of signal
					o_ppm_test_signal <= '0';--cikis low
				elsif timer_counter - ppm_period_counter = clock_freq/50 then-- when a period is finished
					ppm_period_counter <= timer_counter;--reset the timer counter
					temp_counter <= timer_counter;--reset the signal timer counter
					current_ch <= 0;
				end if;
				
			end if;	
			
		end if;
			
	end process;
end main;
	