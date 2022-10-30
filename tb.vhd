library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity tb is

	generic(
			clock_freq		: integer := 27_000_000;
			clock_freq_mhz	: integer := 27;
			freq			: integer := 50
	);
	
	port(
		clk				: inout std_logic := '0';
		o_ch			: out std_logic_vector(2 downto 0)
	);
end tb;

architecture test of tb is
-------------------------------------------------Declerations--------------------------------------		
	signal delay			: time		:= 18.518 ns;-- half clock period of 27MHz crystal.
	signal ppm_signal		: std_logic;	
	signal test_ppm_signal	: std_logic;	
	signal time_counter		: integer	:= 0;	
	
-------------------------------------------------Components----------------------------------------
	component ppm_test_signal is
		generic(
			clock_freq		:	integer	:= 27_000_000;
			clock_freq_mhz	:	integer	:= 27
		);
		port(
			i_clk				: in std_logic;
			o_ppm_test_signal	: out std_logic
		);	
	end component;	
	
	component ppm_in_pwm_out is
		generic(
			clock_freq		: integer := 27_000_000;
			clock_freq_mhz	: integer := 27;
			freq			: integer := 50
		);
		port(
			clk				: in std_logic ;
			i_ppm			: in std_logic;
			o_ch			: out std_logic_vector(2 downto 0)
		);
	end component;
	
-------------------------------------------------Main----------------------------------------------
begin
-------------------------------------------------PPM signal from another module--------------------
	create_ppm : ppm_test_signal
	generic map(
		clock_freq 		=> clock_freq,
		clock_freq_mhz	=> clock_freq_mhz
	)
	port map(
		i_clk 				=> clk,
		o_ppm_test_signal 	=> test_ppm_signal--ppm_signal
	);
	
-------------------------------------------------PPM to PWM----------------------------------------
	converter : ppm_in_pwm_out
	generic map(
		clock_freq		=>clock_freq,	
		clock_freq_mhz	=>clock_freq_mhz,
		freq			=>freq
	)
	port map(
		clk			=> clk,	
		i_ppm		=> ppm_signal,		
		o_ch		=> o_ch	
	);
-------------------------------------------------Clock---------------------------------------------
	process
	begin
		clk <= not clk;
		time_counter <= time_counter + 1;
		wait for delay;
	end process;
-------------------------------------------------Signal cutter-------------------------------------
--signal cutter for testing (assume that something happens while program is running)
	process(clk)
	begin
		if rising_edge(clk) then
			if time_counter > 90_000 then
				ppm_signal <= test_ppm_signal;
			else
				ppm_signal <= '0';
			end if;
		end if;
	end process;
	
	
end test;