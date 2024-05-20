classdef Base < adi.common.Rx & adi.common.RxTx & ...
         matlabshared.libiio.base & adi.common.Attribute & ...
         adi.common.RegisterReadWrite & adi.common.Channel
    % AD405x is a family of Precision ADC
    % AD4052 is single channel 16bit SAR ADC with max sampling frequency
    % of 2MSPS

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '62500'
        
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 400
        
        % BurstAveragingLength Burst Averaging Length
        %   Length of the averaging filter in 'burst averaging mode'
        AvgFilterLength = 2
        
        % BurstSampleRate Burst Sample Rate
        %   Rate of internal averaging in 'burst averaging mode'
        BurstSampleRate = "2msps"

    end

    properties (Nontunable, Hidden)
        channel_names = {'voltage0'}
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Hidden, Constant)
        ComplexData = false
    end
	
	methods

        %% Constructor
        function obj = Base(Args)
            arguments
                Args.devName
                Args.phyDevName
                Args.uri
            end
            
            obj = obj@matlabshared.libiio.base();
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;

            % Set device name, phyDevName, uri from input arguments
            try
                obj.devName = Args.devName;
                obj.phyDevName = Args.phyDevName;
                obj.uri = Args.uri;
            catch
                e = MException('MATLAB:notEnoughInputs',['Not enough input ' ...
                    'arguments. Specify devName, phyDevName and uri']);
                throw(e)
            end

            % Determine datatype using trial and error
            possibleDataTypeStr = {'int16', 'int32'};
            for k = 1:length(possibleDataTypeStr)
                try
                    obj.dataTypeStr = possibleDataTypeStr{k};
                    obj.setup();
                    break;
                catch
                end
            end
            assert(obj.ConnectedToDevice == 1, "Connection could not be established with the specified device")
			
			release(obj)
			
        end
        
        function set.AvgFilterLength(obj, value)
            % Setter method for the Averaging Filter Length attribute
            obj.AvgFilterLength = value;
            if obj.ConnectedToDevice
                val = obj.setDeviceAttributeRAW('avg_filter_length', num2str(value));
            end
		
        end
        
        function set.BurstSampleRate(obj, value)
            % Setter method for the Burst Sampple Rate attribute
            obj.BurstSampleRate = value;
            if obj.ConnectedToDevice
                val = obj.setDeviceAttributeRAW('burst_sample_rate', num2str(value));
            end
		
        end
		
    end 
	
	%% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required since Simulink doesn't support
            % modification to nontunable variables at SetupImpl

            obj.setDeviceAttributeRAW('sampling_frequency', num2str(obj.SampleRate));

        end

    end
end