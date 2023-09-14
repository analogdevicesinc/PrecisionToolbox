classdef AD7768_1Tests < HardwareTests

    properties
        uri = 'ip:analog';
        author = 'ADI';
        m2k_uri = 'usb:1.59.5'
    end

    properties(TestParameter)
        signal_frequency = {2000,3000,4000,5000,6000};
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

        function testAD7768_1Data(testCase,signal_frequency)
            % Signal source setup
            m2k_class = instr_m2k();
            m2k = m2k_class.connect(getenv('M2K_URI'), false);
            siggen = m2k_class.create_instr(m2k, "siggen");
            % ADC setup
            rx = adi.AD7768_1.Rx;
            rx.uri = testCase.uri;

            % Iterate here
            for k = 1:length(signal_frequency)
                frequency = signal_frequency(k);
                m2k_class.control(siggen, 0, [frequency, 0.5, 0, 0]);
                data = rx();

                % Assert
                freqEst = estFrequencyMax(data,str2double(rx.SampleRate));
                testCase.assertTrue(sum(abs(double(data)))>0);
                testCase.verifyEqual(freqEst,frequency,'RelTol',0.015,...
                    'Frequency of signal unexpected')
            end
            
            % Clean up
            rx.release();
            m2k_class.contextClose();
        end
        
    end
    
end

