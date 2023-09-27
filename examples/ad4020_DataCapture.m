%% Script for capturing data from a connected AD4020 board

% Instantiate the system object
rx = adi.AD4020.Rx('uri','ip:analog.local');

% Connect to device and initialize data
rx();

% Retrieve ADC voltage, scale and offset
rx.Voltage();
rx.VoltageScale();
rx.VoltageOffset();

% Print system object properties
rx

% Delete the system object
release(rx)
