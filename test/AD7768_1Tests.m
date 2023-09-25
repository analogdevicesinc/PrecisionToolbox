classdef AD7768_1Tests < HardwareTests

    properties
        uri = 'ip:192.168.10.170';
        author = 'ADI';
        m2k_uri = 'usb:1.27.5'
    end

    properties(TestParameter)
        % start frequency. stop frequency, step, tolerance, repeats
        signal_test = {{1000,125000,2500,0.015,10}};
%         sample_rate = {'256000', '128000', '64000', ...
%          '32000', '16000', '8000', '4000', ...
%          '2000', '1000'}
        sample_rate = {'128000'}
    end

    methods(TestClassSetup)
        % Check hardware connected
        function CheckForHardware(testCase)
            Device = @()adi.AD7768_1.Rx;
            testCase.CheckDevice('ip',Device,testCase.uri(4:end),false);
        end
    end

    methods (Static)
        function freq = estFrequencyMax(data,fs)
            nSamp = length(data);
            FFTRxData  = fftshift(10*log10(abs(fft(data))));
            df = fs/nSamp;  freqRangeRx = (0:df:fs/2-df).';
            % Disregard DC 
            [~,ind] = maxk(FFTRxData(end-length(freqRangeRx)+1:end,:),2);
            freq = max(freqRangeRx(ind));
        end
    end
    
    methods (Test)
        
        function testAD7768_1Smoke(testCase)
            adc = adi.AD7768_1.Rx;
            adc.uri = testCase.uri;
            data = adc();
            adc.release();
            testCase.assertTrue(sum(abs(double(data)))>0);
        end

        function testAD7768_1Signal(testCase,signal_test)
            % Signal source setup
            m2k_class = instr_m2k();
            m2k = m2k_class.connect(getenv('M2K_URI'), false);
            siggen = m2k_class.create_instr(m2k, "siggen");
            % ADC setup
            rx = adi.AD7768_1.Rx;
            rx.uri = testCase.uri;

            start = signal_test{1};
            stop = signal_test{2};
            step = signal_test{3};
            tol = signal_test{4};
            repeats = signal_test{5};
            numints = round((stop-start)/step);
            for ii = 1:repeats
                ind = randi([0, numints]);
                frequency = start+(step*ind);
                m2k_class.control(siggen, 0, [frequency, 0.5, 0, 0]);
                for k = 1:5
                    data = rx();
                end
                freqEst = estFrequencyMax(data,str2double(rx.SampleRate));
                testCase.assertTrue(sum(abs(double(data)))>0);
                testCase.verifyEqual(freqEst,frequency,'RelTol',tol,...
                    'Frequency of signal unexpected')
            end
            rx.release();
            m2k_class.contextClose();
        end

%         function testAD7768_1Attr(testCase, sample_rate)
%          % FIXME: Hangs after first setting
%             % ADC setup
%             rx = adi.AD7768_1.Rx;
%             rx.uri = testCase.uri;
% 
%             val = sample_rate;
%             rx.SampleRate = val;
%             rx();
%             ret_val = rx.getDeviceAttributeRAW('sampling_frequency');
%             rx.release();
%             testCase.assertTrue(val==ret_val);
%         end
    end
    
end

