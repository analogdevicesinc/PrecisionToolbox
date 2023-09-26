%% Script for capturing data from a connected AD2S1210 board

% Instantiate the system object
rx = adi.AD2S1210.Rx('uri','ip:analog.local');

% Connect to device and initialize data
rx();

% Retrieve resolver angle, velocity and associated scales
rx.Angle();
rx.AngleScale();
rx.Velocity();
rx.VelocityScale();

% Print system object properties
rx

% Delete the system object
release(rx);
