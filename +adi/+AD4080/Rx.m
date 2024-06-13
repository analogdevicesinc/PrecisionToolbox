classdef Rx < adi.common.Rx & adi.common.RxTx & ...
         matlabshared.libiio.base & adi.common.Attribute & ...
         adi.common.RegisterReadWrite & adi.common.Channel 
    % AD4080 Precision ADC Class
    % adi.AD4080.Rx Receives data from the AD4080 ADC
    %   The adi.AD4080.Rx System object is a signal source that can receive
    %   data from the AD4080.
    %
    %   rx = adi.AD4080.Rx;
    %   rx = adi.AD4080.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad4080.pdf">AD4080 Datasheet</a>

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second. Options are:
        %   '256000','128000','64000','32000','16000','8000','4000',
        %   '2000','1000'
        SampleRate = '40000000'
        
        % SamplesPerFrame Samples Per Frame
        %   The number of samples to be captured as part of one continuous buffer
        SamplesPerFrame = 4096

        % Scale Scale
        %   Scale value to be used to convert the code to voltage
        Scale = 0.005722

        % TestMode Test Mode
        %   Test Mode for AD4080. Options are:
        %   'off', 'midscale_short', 'pos_fullscale',
        %   'neg_fullscale', 'checkerboard', 'pn_long', 'on_short', 'one_zero_toggle',
        %   'user', 'bit_toggle', 'sync', 'one_bit_high', 'mixed_bit_frequency'
        TestMode = 'off'

    end

    properties (Nontunable, Hidden)
        channel_names = { ...
                         'voltage0'}
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Constant, Hidden)
        SampleRateSet = matlab.system.StringSet({ ...
                                                 '40000000', '256000', '128000', '64000', ...
                                                 '32000', '16000', '8000', '4000', ...
                                                 '2000', '1000'})

        TestModeSet = matlab.system.StringSet({'off', 'midscale_short', 'pos_fullscale', ...
            'neg_fullscale', 'checkerboard', 'pn_long', 'on_short', 'one_zero_toggle', ...
            'user', 'bit_toggle', 'sync', 'one_bit_high', 'mixed_bit_frequency'})

    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        dataTypeStr = 'int32'
        phyDevName = 'ad4080'
        devName = 'ad4080'
    end

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
        ComplexData = false
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

        % Check TestMode
        function set.TestMode(obj, value)
            obj.TestMode = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('test_mode', value);
            end
        end

    end

    methods (Access = protected)

        function numOut = getNumOutputsImpl(~)
            numOut = 2;
        end

    end

    %% API Functions
    methods (Hidden)

        function setupExtra(obj)
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required since Simulink doesn't support
            % modification to nontunable variables at SetupImpl

            obj.setDeviceAttributeRAW('sampling_frequency', num2str(obj.SampleRate));
            obj.setAttributeRAW('voltage0', 'test_mode', obj.TestMode, false);
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
            bName = 'AD4080 Precision ADC';
        end

    end
end
