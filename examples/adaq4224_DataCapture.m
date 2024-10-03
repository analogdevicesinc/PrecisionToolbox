%% Script for capturing and displaying a continuous set of samples from a 
%% connected ADAQ4224 board

% Instantiate the ADAQ4224 Rx system object, and specify the uri in this
% manner
rx = adi.ADAQ4224.Rx('uri','ip:analog.local');

rx.SamplesPerFrame = 4096;  % Using values less than 3660 can yield poor 
% performance, generally
rx.SampleRate = '2000000';
rx.SampleAveragingLength = '16';

% The parameter below specifies the number of frames or buffers to capture.
% Refer to the Streaming section in the documentation if discontinuities
% are observed in the acquired data.
rx.FrameCount = 1;

% Set channel scale value
rx.Scale = 0.001464843;
fprintf("Sampling with gain set to %s\n", num2str(rx.Scale));

% Capture data
data = rx();

enabledChannels = size(data, 2);
figure(1);
for i = 1:enabledChannels
    subplot(enabledChannels, 1, i);
    plot(data(1:rx.SamplesPerFrame * rx.FrameCount, i));
    title("Channel " + num2str(rx.EnabledChannels(i)));
end

% Set channel scale value
rx.Scale = 0.000219726;
fprintf("Sampling with gain set to %s\n", num2str(rx.Scale))

% Capture data
data = rx();

enabledChannels = size(data, 2);
figure(2);
for i = 1:enabledChannels
    subplot(enabledChannels, 1, i);
    plot(data(1:rx.SamplesPerFrame * rx.FrameCount, i));
    title("Channel " + num2str(rx.EnabledChannels(i)));
end

% Delete the system object
release(rx);
