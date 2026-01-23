%% Script for generating and transmitting a set of samples to a 
%% connected ad5706r board

%% Generate data
samplerate = 50000;
amplitude = 2^15; 
frequency = 250;
sine_wave = dsp.SineWave(amplitude, frequency);
sine_wave.ComplexOutput = false;
sine_wave.SamplesPerFrame = 100;
sine_wave.SampleRate = samplerate;
data = sine_wave();
data = uint16(data);

%% Tx set up
% Instantiate the system object
tx = adi.AD5706r.Tx;
% Specify uri
tx.uri = 'serial:COM39,230400';
tx.EnableCyclicBuffers = true;
tx.SampleRate = samplerate;
tx.EnabledChannels = [1];

% Stream data
tx(data)

% Pause the execution to see the ouput for 5 seconds
pause(5);

% Delete the system object
tx.release();