%% Script for capturing and displaying a continuous set of samples from a 
%% connected AD7124-4 board

% Instantiate the system object
rx = adi.AD7124_4.Rx();
rx.uri = 'ip:analog.local';

% Samples per frame cannot exceed 500 if all 16 channels need to be captured on ad7124-8 
rx.SamplesPerFrame = 500; 
rx.EnabledChannels = [1 2 3 4 5 6 7 8];
rx.SampleRate = 19200;

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