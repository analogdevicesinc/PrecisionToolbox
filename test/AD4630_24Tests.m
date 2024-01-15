classdef AD4630_24Tests < HardwareTests
    
    properties
        uri = 'ip:analog-2.local';
        author = 'ADI';
    end

    properties(TestParameter)
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

        function testAD4630_24AttrSampleAveragingLength(testCase,sample_averaging_length)
        % The average mode works only with the output data mode set to 30-bit average
            adc = adi.AD4630_24.Rx('uri',testCase.uri);
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

