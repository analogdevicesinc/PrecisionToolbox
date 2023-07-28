%% Script for capturing and displaying a continuous set of samples from a 
%% connected AD4858 board

%% Trigger setup needs to be performed before this example script can be run
%% Refer to the Limitations section in the documentation for details

% Instantiate the system object
rx = adi.AD4858.Rx;
% Specify uri
rx.uri = 'ip:analog.local';
rx.SamplesPerFrame = 4096;  % Using values less than 3660 can yield poor 
% performance, generally
rx.EnabledChannels = [1 2 3 4 5 6 7 8];

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
