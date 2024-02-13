%% Script for capturing data from a connected AD7944 board

% Instantiate the system object
rx = adi.AD7944.Rx('uri','ip:analog.local');

% Connect to device and initialize data
rx();

% Retrieve ADC voltage scale
rx.VoltageScale();

% Print system object properties
rx

% Delete the system object
release(rx)
