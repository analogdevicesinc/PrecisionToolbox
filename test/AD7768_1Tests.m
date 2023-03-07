classdef AD7768_1Tests < HardwareTests
    
    properties(TestParameter)
    end
    properties
        uri = 'ip:analog';
        author = 'ADI';
    end
    
    methods(TestClassSetup)
        % Check hardware connected
        function CheckForHardware(testCase)
            Device = @()adi.AD7768_1.Rx;
            testCase.CheckDevice('ip',Device,testCase.uri(4:end),false);
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
        
    end
    
end

