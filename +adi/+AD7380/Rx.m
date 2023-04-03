classdef Rx < adi.Base.Base
    % AD7380 Precision ADC Class
    % adi.AD7380.Rx Receives data from the AD7380 ADC
    %   The adi.AD7380.Rx System object is a signal source that can receive
    %   data from the AD7380.
    %
    %   rx = adi.AD7380.Rx;
    %   rx = adi.AD7380.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad7380-7381.pdf">AD7380 Datasheet</a>

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second. Options are:
        %   '256000','128000','64000','32000','16000','8000','4000',
        %   '2000','1000'
        SampleRate = '4000000'
        SamplesPerFrame = 1024
    end


    % Channel names
    properties (Nontunable, Hidden)
        channel_names = {
                         'voltage0'
                         'voltage1'
                        }
        Type = 'Rx'
    end

    % isOutput
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Constant, Hidden)
        SampleRateSet = matlab.system.StringSet({'4000000', '256000', '128000', '64000', ...
            '32000', '16000', '8000', '4000', '2000', '1000'})

    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        dataTypeStr = 'int16'
        phyDevName = 'ad7380'
        devName = 'ad7380'
    end

    properties (Hidden, Constant)
        ComplexData = false
    end

    methods

        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.Base.Base(varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
            obj.uri = 'ip:analog.local';
        end

        function flush(obj)
            flushBuffers(obj);
        end

        % Check SamplingRate
        function set.SampleRate(obj, value)
            obj.SampleRate = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sampling_frequency', value);
            end
        end

    end

    %% API Functions
    methods (Hidden, Access = protected)

        function setupExtra(obj)
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required since Simulink support doesn't support
            % modification to nontunable variables at SetupImpl

            % obj.setDeviceAttributeRAW('sampling_frequency',num2str(obj.SampleRate));

        end

        

    end
end
