library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity ppm_in_pwm_out is

	generic(
		clock_freq		: integer := 27_000_000;
		clock_freq_mhz	: integer := 27;
		freq			: integer := 50
	);
	
	port(
		clk				: in std_logic ;
		i_ppm			: in std_logic;
		o_ch			: out std_logic_vector(2 downto 0)-- Modify this output for adding more output signal
	
	);
end ppm_in_pwm_out;

architecture main of ppm_in_pwm_out is
-------------------------------------------------Declerations--------------------------------------	
	signal current_ch_value		:	integer 	:= 0;
	signal current_ch_number	:	integer		:= 1;
	
	type ch_values_array is array (1 to 9) of integer;
	signal ch_values			:	ch_values_array  := (others => 0);
-------------------------------------------------Components----------------------------------------
	
	component ppm_decoder is
		generic(
			clock_freq_mhz		:	integer	:= 27;
			ppm_end_time_limit	:	integer	:= 4000 --4ms end signal for sync
		);
		port(
		i_clk			: in std_logic;
		i_ppm_signal	: in std_logic;
		o_ch_value		: inout integer;
		o_ch_number		: inout	integer	:= 1
		);
	end component;
	
	component pwm_encoder is
		generic(
			clock_freq		: integer := 27_000_000;
			clock_freq_mhz	: integer := 27;
			freq			: integer := 50
		);
		port(
			i_clk	: in std_logic;	
			o_pwm	: out std_logic;
			i_duty	: in integer
		);

	end component;
	
-------------------------------------------------Main----------------------------------------------
begin
-------------------------------------------------Detecting ppm from another module-----------------
	detect_ppm : ppm_decoder
	generic map(
		clock_freq_mhz		=> 27,
		ppm_end_time_limit	=> 4000
	)
	port map(
		i_clk => clk,
		i_ppm_signal => i_ppm,
		o_ch_value => current_ch_value,
		o_ch_number => current_ch_number
	);
-------------------------------------------------Data assigment------------------------------------
	process(i_ppm)
	begin
		if rising_edge(i_ppm) then
			ch_values(current_ch_number)	<= 	current_ch_value;--Scan all channels.
		end if;
	end process;
-------------------------------------------------PWM Creator CH1-----------------------------------
	crete_pwm_ch1 : pwm_encoder
	generic map(
		clock_freq	=> clock_freq,
		freq		=> 50 -- standart for RC servos
	)
	port map(
		i_clk	=> clk,
		o_pwm	=> O_ch(0),
		i_duty	=> ch_values(1)
	);
-------------------------------------------------PWM Creator CH2-----------------------------------
	crete_pwm_ch2 : pwm_encoder
	generic map(
		clock_freq	=> clock_freq,
		freq		=> 50 -- standart for RC servos
	)
	port map(
		i_clk	=> clk,
		o_pwm	=> o_ch(1),
		i_duty	=> ch_values(2)
	);	
-------------------------------------------------PWM Creator CH3-----------------------------------
	crete_pwm_ch3 : pwm_encoder
	generic map(
		clock_freq	=> clock_freq,
		freq		=> 50 -- standart for RC servos
	)
	port map(
		i_clk	=> clk,
		o_pwm	=> o_ch(2),
		i_duty	=> ch_values(3)
	);
--If you add more pwm_encoder block here, you can create more PWM signal. Don't forget to modify entity of this module.
	

	
end main;