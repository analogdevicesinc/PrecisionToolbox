classdef Rx < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD7986 Precision ADC Class
    % adi.AD7986.Rx Receives data from the AD7986 ADC
    %   The adi.AD7986.Rx System object is a signal source that can receive
    %   data from the AD7986.
    %
    %   rx = adi.AD7986.Rx;
    %   rx = adi.AD7986.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad7986.pdf">AD7986 Datasheet</a>

    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 4096

	% SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
	SampleRate = 2000000
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
        dataTypeStr = 'int32'
        phyDevName = 'ad7986'
        devName = 'ad7986'
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
