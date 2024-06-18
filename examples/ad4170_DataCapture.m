%% Script for capturing and displaying a continuous set of samples from a 
%% connected AD4170 board

% Instantiate the system object
rx = adi.AD4170.Rx();
rx.uri = 'serial:COM18,230400';

% Samples per frame cannot exceed 500 if all 16 channels need to be captured on AD4170 
rx.SamplesPerFrame = 500; 
rx.EnabledChannels = [1];

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