%% Script for capturing and displaying a continuous set of samples from a 
%% connected AD559xr board

% Instantiate the system object
rx = adi.AD5592r.Rx();
rx.uri = 'serial:COM43,230400,8n1n';

% Samples Per Frame 
rx.SamplesPerFrame = 400; 

% Enable the channels that are selected as ADC in the firmware
rx.EnabledChannels = [1 2 3 4 5 6 7 8];

% Capture data
data = rx();

enabledChannels = size(data,2);
figure(1);
for i = 1:enabledChannels
    subplot(enabledChannels, 1, i);
    plot(data(1:rx.SamplesPerFrame, i));
    title("Channel " + num2str(rx.EnabledChannels(i)));
end

% Delete the system object
release(rx);