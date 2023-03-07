classdef AD4030Tests < HardwareTests
    
    properties(TestParameter)
    end
    properties
        uri = 'ip:analog-2.local';
        author = 'ADI';
    end
    
    methods(TestClassSetup)
        % Check hardware connected
        function CheckForHardware(testCase)
            Device = @()adi.AD4030.Rx;
            testCase.CheckDevice('ip',Device,testCase.uri(4:end),false);
        end
    end
    
    methods (Test)
        
        function testAD4030Smoke(testCase)
            adc = adi.AD4030.Rx('uri',testCase.uri);
            data = adc();
            adc.release();
            testCase.assertTrue(sum(abs(double(data)))>0);
        end
        
    end
    
end

