% Analog Devices, Inc. Precision Toolbox
% Version 21.2.1 (R2021b)
%
% ==== Table of Contents (TOC) ====
%
% Parts
% -----------------------
%   <a href="matlab:help adi.AD4000            ">AD4000</a>         - ADC
%   <a href="matlab:help adi.AD4001            ">AD4001</a>         - ADC
%   <a href="matlab:help adi.AD4002            ">AD4002</a>         - ADC
%   <a href="matlab:help adi.AD4003            ">AD4003</a>         - ADC
%   <a href="matlab:help adi.AD4004            ">AD4004</a>         - ADC
%   <a href="matlab:help adi.AD4005            ">AD4005</a>         - ADC
%   <a href="matlab:help adi.AD4006            ">AD4006</a>         - ADC
%   <a href="matlab:help adi.AD4007            ">AD4007</a>         - ADC
%   <a href="matlab:help adi.AD4008            ">AD4008</a>         - ADC
%   <a href="matlab:help adi.AD4010            ">AD4010</a>         - ADC
%   <a href="matlab:help adi.AD4011            ">AD4011</a>         - ADC
%   <a href="matlab:help adi.AD4020            ">AD4020</a>         - ADC
%   <a href="matlab:help adi.AD4021            ">AD4021</a>         - ADC
%   <a href="matlab:help adi.AD4022            ">AD4022</a>         - ADC
%   <a href="matlab:help adi.AD4030            ">AD4030-24</a>      - ADC
%   <a href="matlab:help adi.AD4050            ">AD4050</a>         - ADC
%   <a href="matlab:help adi.AD4052            ">AD4052</a>         - ADC
%   <a href="matlab:help adi.AD4060            ">AD4060</a>         - ADC
%   <a href="matlab:help adi.AD4062            ">AD4062</a>         - ADC
%   <a href="matlab:help adi.AD4630_16         ">AD4630-16</a>      - ADC
%   <a href="matlab:help adi.AD4630_24         ">AD4630-24</a>      - ADC
%   <a href="matlab:help adi.AD4170            ">AD4170</a>         - ADC
%   <a href="matlab:help adi.AD4190            ">AD4190</a>         - ADC
%   <a href="matlab:help adi.ADAQ4224          ">ADAQ4224</a>       - ADAQ
%   <a href="matlab:help adi.AD4858            ">AD4858</a>         - ADC
%   <a href="matlab:help adi.AD7380            ">AD7380</a>         - ADC
%   <a href="matlab:help adi.AD7381            ">AD7381</a>         - ADC
%   <a href="matlab:help adi.AD7383            ">AD7383</a>         - ADC
%   <a href="matlab:help adi.AD7384            ">AD7384</a>         - ADC
%   <a href="matlab:help adi.AD7386            ">AD7386</a>         - ADC
%   <a href="matlab:help adi.AD7387            ">AD7387</a>         - ADC
%   <a href="matlab:help adi.AD7388            ">AD7388</a>         - ADC
%   <a href="matlab:help adi.AD7380_4          ">AD7380-4</a>       - ADC
%   <a href="matlab:help adi.AD7381_4          ">AD7381-4</a>       - ADC
%   <a href="matlab:help adi.AD7383_4          ">AD7383-4</a>       - ADC
%   <a href="matlab:help adi.AD7384_4          ">AD7384-4</a>       - ADC
%   <a href="matlab:help adi.AD7386_4          ">AD7386-4</a>       - ADC
%   <a href="matlab:help adi.AD7387_4          ">AD7387-4</a>       - ADC
%   <a href="matlab:help adi.AD7388_4          ">AD7388-4</a>       - ADC
%   <a href="matlab:help adi.ADAQ4370_4        ">ADAQ4370-4</a>     - ADC
%   <a href="matlab:help adi.ADAQ4380_4        ">ADAQ4380-4</a>     - ADC
%   <a href="matlab:help adi.AD7625            ">AD7625</a>         - ADC
%   <a href="matlab:help adi.AD7626            ">AD7626</a>         - ADC
%   <a href="matlab:help adi.AD7960            ">AD7960</a>         - ADC
%   <a href="matlab:help adi.AD7961            ">AD7961</a>         - ADC
%   <a href="matlab:help adi.AD7605_4          ">AD7605_4</a>       - ADC
%   <a href="matlab:help adi.AD7606_4          ">AD7606_4</a>       - ADC
%   <a href="matlab:help adi.AD7606_6          ">AD7606_6</a>       - ADC
%   <a href="matlab:help adi.AD7606_8          ">AD7606_8</a>       - ADC
%   <a href="matlab:help adi.AD7606B           ">AD7606B</a>        - ADC
%   <a href="matlab:help adi.AD7606C_16        ">AD7606C_16</a>     - ADC
%   <a href="matlab:help adi.AD7606C_18        ">AD7606C_18</a>     - ADC
%   <a href="matlab:help adi.AD7768            ">AD7768</a>         - ADC
%   <a href="matlab:help adi.AD7768_1          ">AD7768-1</a>       - ADC
%   <a href="matlab:help adi.AD7944            ">AD7944</a>         - ADC
%   <a href="matlab:help adi.AD7985            ">AD7985</a>         - ADC
%   <a href="matlab:help adi.AD7986            ">AD7986</a>         - ADC
%   <a href="matlab:help adi.AD2S1210          ">AD2S1210</a>       - Resolver-to-Digital Converter
%   <a href="matlab:help adi.AD3530r           ">AD3530r</a>       - DAC
%   <a href="matlab:help adi.AD5760            ">AD5760</a>         - DAC
%   <a href="matlab:help adi.AD5780            ">AD5780</a>         - DAC
%   <a href="matlab:help adi.AD5781            ">AD5781</a>         - DAC
%   <a href="matlab:help adi.AD5790            ">AD5790</a>         - DAC
%   <a href="matlab:help adi.AD5791            ">AD5791</a>         - DAC
%   <a href="matlab:help adi.AD7124_4          ">AD7124_4</a>       - ADC
%   <a href="matlab:help adi.AD7124_8          ">AD7124_8</a>       - ADC
%   <a href="matlab:help adi.AD4080            ">AD4080</a>         - ADC
%   <a href="matlab:help adi.AD5592r           ">AD5592r</a>        - ADC
%   <a href="matlab:help adi.AD5593r           ">AD5593r</a>        - ADC
%   <a href="matlab:help adi.AD4020            ">AD4020</a>         - ADC
%   <a href="matlab:help adi.AD3552R           ">AD43552R</a>       - DAC
%   <a href="matlab:help adi.LTC2387           ">LTC2387</a>        - DAC
%
% Boards and Platforms
% -----------------------
%   <a href="matlab:help adi.CN0585            ">CN0585</a>         - FMC development board for precision data acquisition
