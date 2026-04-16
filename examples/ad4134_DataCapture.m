%% Script for capturing and displaying a continuous set of samples from a 
%% connected AD7134 or AD4134 board

% Select the device (uncomment the desired device)
device = 'AD4134'; % 4-channel, 16-bit ADC
% device = 'AD7134'; % 4-channel, 16-bit ADC

% Instantiate the system object
switch device
    case 'AD7134'
        rx = adi.AD7134.Rx();
    case 'AD4134'
        rx = adi.AD4134.Rx();
end

rx.uri = 'ip:analog.local';

% Samples per frame cannot exceed 400 if all 4 channels need to be captured
rx.SamplesPerFrame = 400; 
rx.EnabledChannels = [1 2 3 4];

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
