classdef Rx < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD7985 Precision ADC Class
    % adi.AD7985.Rx Receives data from the AD7985 ADC
    %   The adi.AD7985.Rx System object is a signal source that can receive
    %   data from the AD7985.
    %
    %   rx = adi.AD7985.Rx;
    %   rx = adi.AD7985.Rx('uri','ip:192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad7985.pdf">AD7985 Datasheet</a>

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
        % VoltageScale Voltage Scale
        %   ADC Voltage scale.
        VoltageScale
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
        dataTypeStr = 'uint32'
        phyDevName = 'ad7985'
        devName = 'ad7985'
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

        %% Check Voltage Scale
        function rValue = get.VoltageScale(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('voltage0', 'scale', obj.isOutput);
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
