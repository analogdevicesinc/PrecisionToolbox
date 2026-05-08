%% Script for generating and transmitting a set of samples to a 
%% connected AD5529r board

%% Generate data
samplerate = 1000;
amplitude = 2^15 - 1; 
frequency = 5;
sine_wave = dsp.SineWave(amplitude, frequency);
sine_wave.ComplexOutput = false;
sine_wave.SamplesPerFrame = 200;
sine_wave.SampleRate = samplerate;
data = sine_wave();

%% Data offset for unipolar DAC
data = data + 2^15;
data = uint16(data);

%% Tx set up
% Instantiate the system object
tx = adi.AD5529r.Tx;
% Specify uri
tx.uri = 'serial:COM21,230400';
tx.EnableCyclicBuffers = true;
tx.SampleRate = samplerate;
tx.EnabledChannels = 1;

% Stream data
tx(data)

% Pause the execution to see the ouput for 5 seconds
pause(5);

% Delete the system object
tx.release();