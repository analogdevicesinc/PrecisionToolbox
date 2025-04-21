classdef AD7768_1Tests < HardwareTests

    properties
        uri = 'ip:analog';
        author = 'ADI';
    end

    properties(TestParameter)
        % start. stop, step, tolerance, repeats
        signal_test = {{1000,125000,2500,0.015,10}};
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
            [data,valid] = adc();
            adc.release();
            testCase.assertTrue(valid);
            testCase.assertTrue(sum(abs(double(data)))>0);
        end

        function testAD7768_1Signal(testCase,signal_test)
            % Signal source setup
            m2k_class = instr_m2k();
            m2k = m2k_class.connect(getenv('M2K_URI'), false);
            siggen = m2k_class.create_instr(m2k, "siggen");
            % ADC setup
            adc = adi.AD7768_1.Rx;
            adc.uri = testCase.uri;

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
                    [data,valid] = adc();
                end
                freqEst = testCase.estFrequencyMax(data,str2double(adc.SampleRate));
                testCase.assertTrue(valid);
                testCase.assertTrue(sum(abs(double(data)))>0);
                testCase.verifyEqual(freqEst,frequency,'RelTol',tol,...
                    'Frequency of signal unexpected')
            end
            adc.release();
            m2k_class.contextClose();
        end

    end
    
end

