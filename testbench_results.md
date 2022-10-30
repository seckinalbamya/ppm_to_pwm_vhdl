The main code has 3 modules.
- ppm_decoder.vhd
- pwm_encoder.vhd
- ppm_in_pwm_out.vhd

if you want to test these codes on a computer there are 2 more modules.
- ppm_test_signal.vhd
- tb.vhd

I tested these codes on GHDL and GTKWave. The result is given below.

![test_result](https://user-images.githubusercontent.com/43293467/198903348-024660d5-4212-447c-8f6e-3a5c03176a57.JPG)

!IMPORTANT, the system creates a CORRECT OUTPUT SIGNAL after the end of the first full period (after 20-40ms). Because first of all, it should sync to the signal and then it gives meaningful data. Output is not useful before the data sync is completed! It takes at least 20ms, a maximum of 40ms.

![calculating_issue](https://user-images.githubusercontent.com/43293467/198903440-942d35c2-9d7b-4f70-9f31-8db88ffad6d2.JPG)


If you want to reach the simulation results, you can install GHDL-GTKWave and analyze the codes or use the tb.vcd file which is analyzed by me and given to you.
