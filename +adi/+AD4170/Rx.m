classdef Rx < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD4170 Precision ADC Class
    % 
    % adi.AD4170.Rx Receives data from the AD4170 ADC
    % The adi.AD4170.Rx System object is a signal source that can receive
    % data from the AD4170.
    %
    %   `rx = adi.AD4170.Rx;`
    %   `rx = adi.AD4170.Rx('serial:COM18,230400');`
    %
    % `AD4170 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4170.pdf>`_

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '32500'

        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 1024

        %AdcMode ADC Mode
        % ADC Mode for data capture, represented as a string.
        % It supports the following: 'Continuous_Conversion',
        % 'Continuous_Conversion_FIR', 'Continuous_Conversion_IIR',
        % 'Standby', 'Power_Down', 'Idle'
        AdcMode = 'Continuous_Conversion'

        %Fs Fs
        % Fs for configuring the sampling rate of the device.
        % It supports a numeric value. Please refer to the DS
        % for more details on configuring FS
        Fs = 20

    end

    % Channel names
    properties (Nontunable, Hidden, Constant)
        channel_names = { ...
                         'voltage0', 'voltage1', 'voltage2', 'voltage3'}
    end

    % isOutput
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName = 'ad4170'
        devName = 'ad4170'
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
            obj.uri = 'serial:COM18,230400';
        end

        function flush(obj)
            % Flush the buffer
            flushBuffers(obj);
        end

        function set.AdcMode(obj, value)
            % Set device ADC Mode
            obj.AdcMode = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('adc_mode', value);
            end
        end

        function set.Fs(obj, value)
            % Set device Fs
            obj.Fs = value;
            if obj.ConnectedToDevice
                obj.setAttributeRAW('voltage0', 'fs', value, false, obj.iioDev);
                obj.setAttributeRAW('voltage1', 'fs', value, false, obj.iioDev);
                obj.setAttributeRAW('voltage2', 'fs', value, false, obj.iioDev);
                obj.setAttributeRAW('voltage3', 'fs', value, false, obj.iioDev);
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
            obj.setDeviceAttributeRAW('adc_mode',num2str(obj.AdcMode));
            obj.setAttributeRAW('voltage0', 'fs', num2str(obj.Fs), false, obj.iioDev, false);
            obj.setAttributeRAW('voltage1', 'fs', num2str(obj.Fs), false, obj.iioDev, false);
            obj.setAttributeRAW('voltage2', 'fs', num2str(obj.Fs), false, obj.iioDev, false);
            obj.setAttributeRAW('voltage3', 'fs', num2str(obj.Fs), false, obj.iioDev, false);
        end
    end
end