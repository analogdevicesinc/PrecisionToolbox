classdef AD7768_1Tests < HardwareTests

    properties
        uri = 'ip:localhost';
        author = 'ADI';
    end

    properties(TestParameter)
        % start frequency. stop frequency, step, tolerance, repeats
        signal_test = {{1000,125000,2500,0.015,10}};
        samples_per_frame = {{2^1,2^24,2^8,0.0,10}};
        sample_rate = {'256000', '128000', '64000', ...
                     '32000', '16000', '8000', '4000', ...
                     '2000', '1000'};
        common_mode_voltage = { '(AVDD1-AVSS)/2','2V5', ...
                     '2V05','1V9','1V65','1V1','0V9', ...
                     'OFF'};
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

        function testAD7768_1AttrSampleRate(testCase,sample_rate)
        % FIXME: Hangs unless board is rebooted
            adc = adi.AD7768_1.Rx;
            adc.uri = testCase.uri;
            val = sample_rate;
            adc.SampleRate = val;
            [data,valid] = adc();
            ret_val = adc.getDeviceAttributeRAW('sampling_frequency',8);
            adc.release();
            testCase.assertTrue(valid);
            testCase.assertTrue(sum(abs(double(data)))>0);
            testCase.assertTrue(strcmp(val,string(ret_val)));
        end

        function testAD7768_1AttrCommonModeVolage(testCase,common_mode_voltage)
        % FIXME: Hangs unless board is rebooted
            adc = adi.AD7768_1.Rx;
            adc.uri = testCase.uri;
            val = common_mode_voltage;
            adc.CommonModeVolts = val;
            [data,valid] = adc();
            ret_val = adc.getDeviceAttributeRAW('common_mode_voltage',8);
            adc.release();
            testCase.assertTrue(valid);
            testCase.assertTrue(sum(abs(double(data)))>0);
            testCase.assertTrue(strcmp(val,string(ret_val)));
        end

        function testAD7768_1AttrSamplesPerFrame(testCase,samples_per_frame)
        % This is not written to the device. Should this even be tested?
            adc = adi.AD7768_1.Rx;
            adc.uri = testCase.uri;

            start = samples_per_frame{1};
            stop = samples_per_frame{2};
            step = samples_per_frame{3};
            tol = samples_per_frame{4};
            repeats = samples_per_frame{5};
            numints = round((stop-start)/step);
            for ii = 1:repeats
                ind = randi([0, numints]);
                val = start+(step*ind);
                adc.SamplesPerFrame = val;
                [data, valid] = adc();
                [ret_val,~] = size(data);
                adc.release();
                testCase.assertTrue(valid);
                testCase.assertTrue(sum(abs(double(data)))>0);
                testCase.verifyEqual(ret_val,val,'RelTol',tol,...
                    'Frequency of signal unexpected')
            end
        end
    end
    
end

