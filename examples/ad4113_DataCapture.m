%% Script for capturing and displaying a continuous set of samples from a
%% connected AD4113 board

% Instantiate the system object
rx = adi.AD4113.Rx();
rx.uri = 'serial:COM35,230400,8n1n';
rx.SamplesPerFrame = 400;
rx.EnabledChannels = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];

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