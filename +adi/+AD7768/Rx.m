classdef Rx < adi.AD7768.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD7768 Precision ADC Class
    % adi.AD7768.Rx Receives data from the AD7768 ADC
    %   The adi.AD7768.Rx System object is a signal source that can receive
    %   data from the AD7768.
    %
    %   rx = adi.AD7768.Rx;
    %   rx = adi.AD7768.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad7768-7768-4.pdf">AD7768 Datasheet</a>

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second. Options are:
        %   '256000','128000','64000','32000','16000','8000','4000',
        %   '2000','1000'
        SampleRate = '256000'

    end

    properties (Hidden)
        % Number of frames or buffers of data to capture
        FrameCount = 1
    end

    properties (Nontunable, Hidden, Constant)
        channel_names = { ...
                         'voltage0', 'voltage1', 'voltage2', 'voltage3', ...
                         'voltage4', 'voltage5', 'voltage6', 'voltage7'}
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Constant, Hidden)
        SampleRateSet = matlab.system.StringSet({ ...
                                                 '256000', '128000', '64000', ...
                                                 '32000', '16000', '8000', '4000', ...
                                                 '2000', '1000'})

    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 2
        dataTypeStr = 'int32'
        phyDevName = 'cf_axi_adc'
        devName = 'cf_axi_adc'
    end

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'

    end

    methods

        %% Constructor
        function obj = Rx(varargin)
            obj = obj@matlabshared.libiio.base(varargin{:});
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

    methods (Access = protected)

        function numOut = getNumOutputsImpl(~)
            numOut = 1;
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

    %% External Dependency Methods
    methods (Hidden, Static)

        function tf = isSupportedContext(bldCfg)
            tf = matlabshared.libiio.ExternalDependency.isSupportedContext(bldCfg);
        end

        function updateBuildInfo(buildInfo, bldCfg)
            % Call the matlabshared.libiio.method first
            matlabshared.libiio.ExternalDependency.updateBuildInfo(buildInfo, bldCfg);
        end

        function bName = getDescriptiveName(~)
            bName = 'AD7768 Precision ADC';
        end

    end
end
