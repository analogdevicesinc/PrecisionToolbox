%% Script for capturing and displaying a continuous set of samples from a 
%% connected AD719x board

% Instantiate the system object
rx = adi.AD7193.Rx();
rx.uri = 'serial:COM12,230400,8n1n';

% Samples per frame cannot exceed 500 if all 16 channels need to be captured on ad7194
rx.SamplesPerFrame = 400; 
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