% CN0585 Streaming example

board_ip = 'local_board_ip';
uri = cat(2, 'ip:', board_ip);

% Describe the devices

cn0585_device_rx = adi.CN0585.Rx('uri',uri);
cn0585_device_tx0 = adi.CN0585.Tx0('uri',uri);
cn0585_device_tx1 = adi.CN0585.Tx1('uri',uri);

cn0585_device_tx0.EnableCyclicBuffers = true;
cn0585_device_tx1.EnableCyclicBuffers = true;

cn0585_device_rx.BufferTypeConversionEnable = true;

% Enable the channels to write data to (options are 1, 2 )

cn0585_device_tx0.EnabledChannels = [1, 2];
cn0585_device_tx1.EnabledChannels = [1, 2];

% Enable the channels to read data from (options are 1, 2, 3 ,4 )

cn0585_device_rx.EnabledChannels = [1, 2, 3, 4];

% Generate the sinewave signal

amplitude = 2 ^ 15;
sampFreq = cn0585_device_tx0.SamplingRate;
toneFreq = 1e3;
N = sampFreq / toneFreq;
x = linspace(-pi, pi, N).';
sine_wave = amplitude * sin(x);

% Continuously load data in the buffer and configure the GPIOs state
% (SetupInit Base file)
% DAC1 has to be updated and started first and then DAC0 in order to have syncronized data between devices 

cn0585_device_tx1([sine_wave, sine_wave]);
cn0585_device_tx0([sine_wave, sine_wave]);

% Stream status available options: "start_stream_synced", "start_stream", "stop_stream"

cn0585_device_tx1.StreamStatus = 'start_stream';
cn0585_device_tx0.StreamStatus = 'start_stream';

% The data will be stored inside "data" variable

data = cn0585_device_rx();

title('ADAQ23876 Channels');
subplot(4, 1, 1);
plot(data(:, 1));
ylabel('Channel A');
subplot(4, 1, 2);
plot(data(:, 2));
ylabel('Channel B');
subplot(4, 1, 3);
plot(data(:, 3));
ylabel('Channel C');
subplot(4, 1, 4);
plot(data(:, 4));
ylabel('Channel D');
xlabel('Number of samples');

% Release the device

cn0585_device_tx1.StreamStatus = 'stop_stream';
cn0585_device_tx0.StreamStatus = 'stop_stream';

cn0585_device_tx1.release();
cn0585_device_tx0.release();

cn0585_device_rx.release();
