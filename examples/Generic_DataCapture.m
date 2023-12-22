%% Script for capturing buffers of data from a connected IIO device

% Instantiate the Generic Rx system object, and specify the device name, uri
% and phyDevName in the manner shown below
rx = adi.Generic.Rx("devName", 'ad4630-24', 'phyDevName', 'ad4630-24',...
    'uri', 'ip:analog.local');

% Specify number of samples to fetch using buffered capture
rx.SamplesPerFrame = 4096;

% Enable channels for data capture
rx.EnabledChannels = [1];

% Uncomment to display device and channel attribute names
%rx.DeviceAttributeNames
%rx.ChannelAttributeNames

% Read and write attribute values
% For example, with ad4630-24
%   rx.GetDeviceAttrValue('sampling_frequency')
%   rx.SetDeviceAttrValue('sampling_frequency', '2000000');
%   rx.SetChannelAttrValue('differential0', 'hardwaregain', '2');

% Capture data
data = rx();

% Plot samples
enabledChannels = size(data, 2);
figure(1);
for i = 1:enabledChannels
    subplot(enabledChannels, 1, i);
    plot(data(1:rx.SamplesPerFrame, i));
    title("Channel " + num2str(rx.EnabledChannels(i)));
end

% Delete the system object
release(rx);