%% Script for capturing and displaying a continuous set of samples from a 
%% connected AD4692 board

% Instantiate the system object
rx = adi.AD4692.Rx;

% Specify uri
rx.uri = 'serial:COM4,230400';
rx.SamplesPerFrame = 400;  % Using values less than 3660 can yield poor
 
% performance, generally
rx.EnabledChannels = [1];

% Set the sampling rate
rx.SampleRate = 500000;

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
