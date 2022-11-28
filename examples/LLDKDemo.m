% set the bord uri
uri = 'ip:10.48.65.161';

% create a sinus signal
x = linspace(-pi,pi,2^15).';
b = sin(x);

tx0 = adi.LLDK.Tx0('uri',uri);
tx0.EnableCyclicBuffers = true;
tx0(b);
tx0.step(b);

tx1 = adi.LLDK.Tx1('uri',uri);
tx1.EnableCyclicBuffers = true;
tx1(b);
tx1.step(b);

rx = adi.LLDK.Rx('uri',uri);
% to be able to read data from the Rx component we need to eneble the
% following flag BufferTypeConversionEnable
rx.BufferTypeConversionEnable = true;

% The followind example will read data from channels 1 and 2 and plot them
% It will first read from channel 1 then channel 2 then both of them

% Enable the first channel and read it's data
rx.EnabledChannels = [1];
[data,valid] = rx();
subplot(3,1,1);plot(data);
drawnow;
rx.release(); % after we plot the date we need to release the Rx

% Enable the second channel and read it's data
rx.EnabledChannels = [2];
[data,valid] = rx();
subplot(3,1,2);plot(data);
drawnow;
rx.release();% after we plot the date we need to release the Rx

% Enable channels 1 and 2 and read data from both at the same time
rx.EnabledChannels = [1 2];
[data,valid] = rx();
subplot(3,1,3);plot(data);
drawnow;
rx.release();% after we plot the date we need to release the Rx
