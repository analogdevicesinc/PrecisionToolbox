classdef AD4630_24Tests < HardwareTests
    
    properties(TestParameter)
    end
    properties
        uri = 'ip:analog-2.local';
        author = 'ADI';
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
            disp("Clone works.");
            adc = adi.AD4630_24.Rx('uri',testCase.uri);
            data = adc();
            adc.release();
            testCase.assertTrue(sum(abs(double(data)))>0);
        end
        
    end
    
end

