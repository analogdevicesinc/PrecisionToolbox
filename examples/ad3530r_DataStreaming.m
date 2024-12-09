%% Script for generating and transmitting a set of samples to a 
%% connected AD3530r board

%% Generate data
samplerate = 50000;
amplitude = 2^15; 
frequency = 250;
sine_wave = dsp.SineWave(amplitude, frequency);
sine_wave.ComplexOutput = false;
sine_wave.SamplesPerFrame = 200;
sine_wave.SampleRate = samplerate;
sine_wave.PhaseOffset = [0 pi/2 pi];
data = sine_wave();

% Add offset for unipolar DAC
data = data+2^15;
data = uint16(data);

%% Tx set up
% Instantiate the system object
tx = adi.AD3530r.Tx;
% Specify uri
tx.uri = 'ip:analog.local';
tx.EnableCyclicBuffers = true;
tx.SampleRate = samplerate;
tx.EnabledChannels = [1 2 3];

% Stream data
tx(data)

%Pause the execution to see the ouput for 5 seconds
pause(5);

% Delete the system object
tx.release();