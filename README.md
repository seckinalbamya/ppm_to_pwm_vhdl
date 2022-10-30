RC PPM to PWM converter design on VHDL for FPGA boards

What is the RC PPM Signal?

RC PPM signal is a signal which has to contain more than one channel in one wire. It encodes channel values by using on square wave signal. 
The output value depends on the length of two rising edges.

![ppm_decoding](https://user-images.githubusercontent.com/43293467/198899385-43628ed2-1ad2-46ac-addb-31e2c1f7685d.gif)

In the photo, you can see the encoding system of PPM. The time value between two rising edges equals the on-time of the PWM signal.

The main purpose of the code is synchronous to the beginning of the signal and measure the time value between two rising edges.

If the inverval is 1000us, it means output is %0
if the inverval is 2000us, it means output is %100.

The architecture of the code is given below.

![architecture_ppm_in_pwm_out](https://user-images.githubusercontent.com/43293467/198901325-87a2bd80-151b-406e-895b-c0dc654b3206.png)

There are 3 modules:

1-) ppm_decoder.vhd

It decodes the input PPM signal to the current ch value and ch number. It has 9 pairs of ch value and ch number but 8 of them are meaningful. 8 ch PPM signal has 9 square waves and 8 intervals between signals.
  
o_ch_number(X) and o_ch_value(X) are the output values in integer type.
o_ch_number(0) and o_ch_value(0) are not meaningful signal for output.
  
Assume that all outputs are %100. There are 8 signals and the length of the all signal is 8 * 2000us = 16000us.
We know that the period of the signal is 20000us (50Hz). So there should be 4000us free time at the end of the signal. This module uses this free time to be synchronous with the starting point of the signal. This time is a generic parameter in ppm_decoder.vhd module. It should be 4000 (us) for 8 ch converter.

  
2-)pwm_encoder.vhd

It encodes the pwm signal by using two parameters which are i_duty and freq. Freq (frequency) is a generic parameter because it is a fixed value (50Hz) for RC          
compatibility devices. i_duty is channel value input in microsecond.
  
3-) ppm_in_pwm_out.vhd

It connects ppm_decoder and pwm_encoder modules together.

! PPM signal is time-based signal so the generic clock frequency parameter (freq) in the ppm_in_pwm_out.vhd must be correct.clock_freq_mhz must be the same but in different unit.

!IMPORTANT, the system creates a CORRECT OUTPUT SIGNAL after the end of the first full period (after 20-40ms). Because first of all, it should sync to the signal and then it gives meaningful data. Output is not useful before the data sync is completed! It takes at least 20ms, a maximum of 40ms.

!IMPORTANT, the input and the output signals are inverted! FPGA and servo-receiver is not working at same voltage level. You must use a NPN transistor level shifter for inverting data and levelling the voltage level.

<img width="627" alt="inverter schematics" src="https://user-images.githubusercontent.com/43293467/198905626-d1ae251b-6a2f-451c-b838-dbcb7dc80f43.png">


The code decodes 8 channels PPM signal because most RC receivers use 8 channels PPM signal. 

If you have a question about the code, please don't hesitate to contact me via seckinalbamya@gmail.com
