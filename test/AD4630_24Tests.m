classdef AD4630_24Tests < HardwareTests
    
    properties
        uri = 'ip:analog-2.local';
        author = 'ADI';
    end

    properties(TestParameter)
        % start frequency, stop frequency, step, tolerance, repeats
        signal_test = {{10000,250000,2500,0.05,10}};
        signal_vpp = {0.1, 0.3, 0.5};

        sample_rate = {'10000', '50000', '100000', ...
            '200000', '500000', '1000000', ...
            '1760000', '2000000'};
        
        sample_averaging_length = { ...
            '2', '4', '8', '16', '32', '64', '128', '256', ...
            '512', '1024', '2048', '4096', '8192', '16384', ...
            '32768', '65536'};
    end

    methods(TestClassSetup)
        % Check hardware connected
        function CheckForHardware(testCase)
            Device = @()adi.AD4630_24.Rx('uri',testCase.uri);
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
        
        function testAD4630_24Smoke(testCase)
            adc = adi.AD4630_24.Rx('uri',testCase.uri);
            [data,valid] = adc();
            adc.release();
            testCase.assertTrue(valid);
            testCase.assertTrue(sum(abs(double(data)))>0);
        end

        function testAD4630_24AttrSampleRate(testCase,sample_rate)
        % '1750000' is set as '1754386'
            adc = adi.AD4630_24.Rx('uri',testCase.uri);
            adc.uri = testCase.uri;
            val = sample_rate;
            adc.SampleRate = val;
            [data,valid] = adc();
            ret_val = adc.getDeviceAttributeRAW('sampling_frequency',9);
            adc.release();
            testCase.assertTrue(valid);
            testCase.assertTrue(sum(abs(double(data)))>0);
%             testCase.assertTrue(strcmp(val,string(ret_val)), ...
%                 'Sample rate unexpected')
            testCase.verifyEqual(str2double(ret_val),str2double(val), ...
                'RelTol',0,'Sample rate unexpected')
        end

        % function testAD4630_24AttrSampleAveragingLength(testCase,sample_averaging_length)
        % % The average mode works only with the output data mode set to 30-bit average
        % % Skip test for now since it causes ERROR:READ LINE: -32 in iio_info
        %     adc = adi.AD4630_24.Rx('uri',testCase.uri);
        %     val = sample_averaging_length;
        %     adc.SampleAveragingLength = val;
        %     [data,valid] = adc();
        %     ret_val = adc.getDeviceAttributeRAW('sample_averaging',8);
        %     adc.release();
        %     testCase.assertTrue(valid);
        %     testCase.assertTrue(sum(abs(double(data)))>0);
        %     testCase.assertTrue(strcmp(val,string(ret_val)));
        % end

        function testAD4630_24DifferentialInputRMS(testCase,signal_vpp)
            % Signal source setup
            m2k_class = instr_m2k();
            m2k = m2k_class.connect(getenv('M2K_URI'), false);
            siggen = m2k_class.create_instr(m2k, "siggen");
            % ADC setup
            adc = adi.AD4630_24.Rx('uri',testCase.uri);
            fs = str2double(adc.SampleRate);

            % Set channel 1 to 50KHz, 500mHz and minimize channel 2 amplitude
            signal_frequency = 5e4;
            m2k_class.control(siggen, 0, [signal_frequency, signal_vpp, 0, 0]);
            m2k_class.control(siggen, 1, [signal_frequency, 0.000001, 0, 0]);
            for k = 1:5
                [data,valid] = adc();
            end
            data = double(data);
            % Generate same signal in channel 2 to double signal at differential inputs
            m2k_class.control(siggen, 1, [signal_frequency, signal_vpp, 0, 0]);
            for k = 1:5
                [data1,valid1] = adc();
            end
            data1 = double(data1);

            % Clean up
            adc.release();
            m2k_class.contextClose();

            % Assertions
            testCase.assertTrue(valid & valid1);
            testCase.verifyEqual(rms(data1),rms(data)*2,'RelTol',0.3)
        end

        function testAD4630_24DifferentialInputSweep(testCase,signal_test)
            % Signal source setup
            m2k_class = instr_m2k();
            m2k = m2k_class.connect(getenv('M2K_URI'), false);
            siggen = m2k_class.create_instr(m2k, "siggen");
            % ADC setup
            adc = adi.AD4630_24.Rx('uri',testCase.uri);
            adc.EnabledChannels = [1,2];
            fs = str2double(adc.SampleRate);

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
                m2k_class.control(siggen, 1, [frequency, 0.5, 0, 0]);
                for k = 1:5
                    [data,valid] = adc();
                end
                data = double(data);
                freq = estFrequencyMax(double(data),fs);

                % Assertions
                testCase.assertTrue(valid);
                testCase.verifyEqual(freq(1),freq(2),'RelTol',tol)
                testCase.verifyEqual(mean(freq),frequency,'RelTol',tol,...
                    'Frequency of signal unexpected')
            end

            % Clean up
            adc.release();
            m2k_class.contextClose();

            
        end
    end
    
end

