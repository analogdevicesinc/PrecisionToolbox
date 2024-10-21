%% Script for capturing data from a connected AD7625 board

% Instantiate the system object
rx = adi.AD7625.Rx('uri','ip:analog.local');

% Connect to device and initialize data
rx();

% Retrieve ADC scale
rx.VoltageScale();

% Print system object properties
rx

% Delete the system object
release(rx)
