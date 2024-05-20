%% Script for capturing and displaying a continuous set of samples from a 
%% connected AD4052 board

% Instantiate the system object
rx = adi.AD4052.Rx('uri', 'serial:COM13,230400');
rx.SamplesPerFrame = 400; 
rx.EnabledChannels = [1];

rx.SampleRate = 62500; % In sample mode, the sampling rate can be as high as 1MSPS

% Capture data
data = rx();

enabledChannels = size(data, 2);
figure(1);
for i = 1:enabledChannels
    subplot(enabledChannels, 1, i);
    plot(data(1:rx.SamplesPerFrame, i));
    title("Channel " + num2str(rx.EnabledChannels(i)));
end

% Delete the system object
release(rx);