%% Script for capturing multiple buffers of data from a connected AD4630-16 or 
%% AD4630-24 Evaluation board

% Instantiate the AD4630-24 Rx system object, and specify the uri in this
% manner
rx = adi.AD4630_24.Rx('uri', 'ip:analog.local');

rx.SamplesPerFrame = 4096;  % Using values less than 3660 can yield poor 
% performance, generally

% The parameter below specifies the number of frames or buffers to capture.
% Refer to the Streaming section in the documentation if discontinuities
% are observed in the acquired data.
rx.FrameCount = 1;

% Only a select few channel groupings yield sensible outputs. Refer to the
% Limitations section in the documentation for more details
rx.EnabledChannels = [1];

% Capture data
data = rx();

enabledChannels = size(data, 2);
figure(1);
for i = 1:enabledChannels
    subplot(enabledChannels, 1, i);
    plot(data(1:rx.SamplesPerFrame * rx.FrameCount, i));
    title("Channel " + num2str(rx.EnabledChannels(i)));
end

% Delete the system object
release(rx);
