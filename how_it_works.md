RC PPM to PWM converter design on VHDL for FPGA boards

What is the RC PPM Signal?

RC PPM signal is a signal which has contain more than one channel in one wire. It encodes channel values by using on square wave signal. The output value depends on length of two rising edge.

![ppm_decoding](https://user-images.githubusercontent.com/43293467/198899385-43628ed2-1ad2-46ac-addb-31e2c1f7685d.gif)

In the photo you can see the encoding system of PPM.


The code decodes 8 channels PPM signal because most of RC receivers use 8 channels PPM signal. 
