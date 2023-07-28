classdef Rx < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD4858 Precision ADC Class
    % adi.AD4858.Rx Receives data from the AD4858 ADC
    %   The adi.AD4858.Rx System object is a signal source that can receive
    %   data from the AD4858.
    %
    %   rx = adi.AD4858.Rx;
    %   rx = adi.AD4858.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad4858.pdf">AD4858 Datasheet</a>

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '500000'

        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 1024
    end

    properties (Hidden)
        % Number of frames or buffers of data to capture
        FrameCount = 1
    end

    % Channel names
    properties (Nontunable, Hidden, Constant)
        channel_names = { ...
                         'voltage0', 'voltage1', 'voltage2', 'voltage3', ...
                         'voltage4', 'voltage5', 'voltage6', 'voltage7'}
    end

    % isOutput
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 2
        dataTypeStr = 'int32'
        phyDevName = 'ad4858'
        devName = 'ad4858'
    end

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    properties (Hidden, Constant)
        ComplexData = false
    end

    methods

        %% Constructor
        function obj = Rx(varargin)
            % Initialize the Rx object
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
            obj.uri = 'ip:analog.local';
        end

        function flush(obj)
            % Flush the buffer
            flushBuffers(obj);
        end

        function set.SampleRate(obj, value)
            % Set device sampling rate
            obj.SampleRate = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sampling_frequency', value);
            end
        end

    end

    %% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required since Simulink support doesn't support
            % modification to nontunable variables at SetupImpl
            obj.setDeviceAttributeRAW('sampling_frequency',num2str(obj.SampleRate));
        end
        
    end
end
