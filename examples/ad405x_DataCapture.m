%% Script for capturing and displaying a continuous set of samples from a 
%% connected AD405x board

ActiveDevice = "AD4052"; % Devices available are AD4052 and AD4050

% Instantiate the system object
if ActiveDevice == "AD4052"
    rx = adi.AD4052.Rx('uri', 'serial:COM28,230400');
elseif ActiveDevice == "AD4050"
    rx = adi.AD4050.Rx('uri', 'serial:COM28,230400');
else
    rx = adi.AD4052.Rx('uri', 'serial:COM28,230400');
end

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