%% Script for generating and transmitting a set of samples to a 
%% connected AD579x board

%% Generate data
samplerate = 50000;
amplitude = 2^17-1; 
frequency = 250;
sine_wave = dsp.SineWave(amplitude, frequency);
sine_wave.ComplexOutput = false;
sine_wave.SamplesPerFrame = 200;
sine_wave.SampleRate = samplerate;
data = sine_wave();

%% Tx set up
% Instantiate the system object
tx = adi.AD5780.Tx;
% Specify uri
tx.uri = 'serial:COM39,230400';
tx.EnableCyclicBuffers = true;
tx.SampleRate = samplerate;
% Power up the channel
tx.PowerDown = 0;
tx.CodeSelect = "2s_complement";

% Stream data
tx(data)

%Pause the execution to see the ouput for 5 seconds
pause(5);

% Delete the system object
tx.release();