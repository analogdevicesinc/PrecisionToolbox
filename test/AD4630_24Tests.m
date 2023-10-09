classdef AD4630_24Tests < HardwareTests
    
    properties
        uri = 'ip:analog-2.local';
        author = 'ADI';
    end

    properties(TestParameter)
        sample_rate = {{1000,2000000,30000,0.0015,10}};
        sample_averaging_length = { ...
            '2', '4', '8', '16', '32', '64', '128', '256', ...
            '512', '1024', '2048', '4096', '8192', '16384', ...
            '32768', '65536'};
    end

    methods(TestClassSetup)
        % Check hardware connected
        function CheckForHardware(testCase)
            Device = @()adi.AD4630_24.Rx;
            testCase.CheckDevice('ip',Device,testCase.uri(4:end),false);
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

        function testAD7768_1AttrSamplesPerFrame(testCase,sample_rate)
        % TODO: Test this test
            adc = adi.AD7768_1.Rx;
            adc.uri = testCase.uri;

            start = sample_rate{1};
            stop = sample_rate{2};
            step = sample_rate{3};
            tol = sample_rate{4};
            repeats = sample_rate{5};
            numints = round((stop-start)/step);
            for ii = 1:repeats
                ind = randi([0, numints]);
                val = start+(step*ind);
                adc.SampleRate = num2str(val);
                [data, valid] = adc();
                ret_val = adc.getDeviceAttributeRAW('sample_rate',8);
                adc.release();
                testCase.assertTrue(valid);
                testCase.assertTrue(sum(abs(double(data)))>0);
                testCase.verifyEqual(str2double(ret_val),val,'RelTol',tol,...
                    'Sample rate unexpected')
            end
        end

        function testAD4630_24AttrSampleAveragingLength(testCase,sample_averaging_length)
        % TODO: Test this test
            adc = adi.AD4630_24.Rx;
            adc.uri = testCase.uri;
            val = sample_averaging_length;
            adc.SampleAveragingLength = val;
            [data,valid] = adc();
            ret_val = adc.getDeviceAttributeRAW('sample_averaging',8);
            adc.release();
            testCase.assertTrue(valid);
            testCase.assertTrue(sum(abs(double(data)))>0);
            testCase.assertTrue(strcmp(val,string(ret_val)));
        end
        
    end
    
end

