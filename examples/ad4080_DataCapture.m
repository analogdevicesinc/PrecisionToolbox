%% Script for capturing and displaying a continuous set of samples from a 
%% connected EVAL-AD4080-FMCZ board

% Instantiate the system object
rx = adi.AD4080.Rx;
% Specify uri
rx.uri = 'ip:analog.local';

rx.SamplesPerFrame = 4096;
rx.EnabledChannels = [1];
rx.TestMode = 'midscale_short';

% Capture data
data = rx();

enabledChannels = size(data, 2);
figure(1);
for i = 1:enabledChannels
    subplot(enabledChannels, 1, i);
    plot(data(1:rx.FrameCount * rx.SamplesPerFrame, i));
    title("Channel " + num2str(rx.EnabledChannels(i)));
end

% Delete the system object
release(rx);
