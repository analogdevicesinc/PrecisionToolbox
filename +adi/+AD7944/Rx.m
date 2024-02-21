classdef Rx < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD7944 Precision ADC Class
    % adi.AD7944.Rx Receives data from the AD7944 ADC
    %   The adi.AD7944.Rx System object is a signal source that can receive
    %   data from the AD7944.
    %
    %   rx = adi.AD7944.Rx;
    %   rx = adi.AD7944.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad7944.pdf">AD7944 Datasheet</a>

    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 4096

        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = 2500000
    end

    properties (Dependent)
        % Voltage
        %   ADC Voltage in mV
        Voltage

        % VoltageScale Voltage Scale
        %   ADC Voltage scale.
        VoltageScale
    end

    % Channel names
    properties (Nontunable, Hidden, Constant)
        channel_names = {'voltage0-voltage1'}
    end

    % isOutput
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'uint16'
        phyDevName = 'ad7944'
        devName = 'ad7944'
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
                rValue = obj.getAttributeRAW('voltage0-voltage1', 'raw', obj.isOutput);
            else
                rValue = NaN;
            end
        end

        %% Check Voltage Scale
        function rValue = get.VoltageScale(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('voltage0-voltage1', 'scale', obj.isOutput);
            else
                rValue = NaN;
            end
        end
    end

    %% API Functions
    methods (Hidden, Access = protected)
        function setupInit(~)
        end
    end
end
