%% Script for capturing and displaying a continuous set of samples from a
%% connected AD4080 board

% Instantiate the system object
rx = adi.AD4080.Rx();
rx.uri = 'serial:COM19,230400,8n1n';
rx.SamplesPerFrame = 400;
rx.SampleRate = 40000000; % Only sampling rates of 40 MHz, 20 MHz, and 10 MHz are valid

% Capture data
data = rx();

enabledChannels = size(data, 2);
figure(1);
subplot(enabledChannels, 1, 1);
plot(data(1:rx.SamplesPerFrame, 1));
title("Channel 0");

% Delete the system object
release(rx);