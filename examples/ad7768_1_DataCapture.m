%% Script for capturing and displaying a continuous set of samples from a connected AD7768-1 board

% Instantiate the system object
rx = adi.AD7768_1.Rx;
% Specify uri
rx.uri = 'ip:analog.local';
rx.SamplesPerFrame = 4096;  % Using values less than 3660 can yield poor performance, generally
rx.EnabledChannels = [1];

% The parameter below specifies the number of frames or buffers to capture.
% Refer to the Streaming section in the documentation if discontinuities
% are observed in the acquired data.
rx.FrameCount = 1;

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
