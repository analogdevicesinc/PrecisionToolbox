classdef AD7768Tests < HardwareTests
    
    properties(TestParameter)
    end
    properties
        uri = 'ip:analog-2.local';
        author = 'ADI';
    end
    
    methods(TestClassSetup)
        % Check hardware connected
        function CheckForHardware(testCase)
            Device = @()adi.AD7768.Rx;
            testCase.CheckDevice('ip',Device,testCase.uri(4:end),false);
        end
    end
    
    methods (Test)
        
        function testAD7768Smoke(testCase)
            adc = adi.AD7768.Rx('uri',testCase.uri);
            data = adc();
            adc.release();
            testCase.assertTrue(sum(abs(double(data)))>0);
        end
        
    end
    
end

