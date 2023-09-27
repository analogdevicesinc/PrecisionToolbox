classdef Rx < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD4020 Precision ADC Class
    % adi.AD4020.Rx Receives data from the AD4020 ADC
    %   The adi.AD4020.Rx System object is a signal source that can receive
    %   data from the AD4020.
    %
    %   rx = adi.AD4020.Rx;
    %   rx = adi.AD4020.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad4020-4021-4022.pdf">AD4020 Datasheet</a>

    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 4096
    end

    properties (Dependent)
        % Voltage
        %   ADC Voltage in mV
        Voltage

        % VoltageScale Voltage Scale
        %   ADC Voltage scale.
        VoltageScale

        % VoltageOffset Voltage Offset
        %   ADC Voltage offset.
        VoltageOffset
    end

    properties
        % SamplingFrequency
        %   Sampling Frequency in Hertz.
        SamplingFrequency = 0
    end

    properties (Hidden)
        % Number of frames or buffers of data to capture
        FrameCount = 1
    end

    % Channel names
    properties (Nontunable, Hidden, Constant)
        channel_names = {'voltage0'}
    end

    % isOutput
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName = 'ad4020'
        devName = 'ad4020'
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
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end

        %% Check Voltage
        function rValue = get.Voltage(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeRAW('voltage0', 'raw', obj.isOutput);
            else
                rValue = NaN;
            end
        end

        %% Check Voltage Scale
        function rValue = get.VoltageScale(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('voltage0', 'scale', obj.isOutput);
            else
                rValue = NaN;
            end
        end

        %% Check Voltage Offset
        function rValue = get.VoltageOffset(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('voltage0', 'offset', obj.isOutput);
            else
                rValue = NaN;
            end
        end
    end

    %% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
            % Write sampling frequency attribute from device once connected.

            obj.SamplingFrequency = obj.getDeviceAttributeLongLong('sampling_frequency');
        end
    end
end
