classdef Base < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD762X is a family of fully-differential precision ADCs with
    % maximum sample rates between 5 MSPS and 10 MSPS
    %
    % AD7625 is a single-channel, 16-bit signed ADC with a max sample
    % rate of 6 MSPS
    % AD7626 is a single-channel, 16-bit signed ADC with a max sample
    % rate of 10 MSPS
    % AD7960 is a single-channel, 18-bit signed ADC with a max sample
    % rate of 5 MSPS
    % AD7961 is a single-channel, 16-bit signed ADC with a max sample
    % rate of 5 MSPS

    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 4096

	% SampleRate Sample Rate
	%   Baseband sampling rate in Hz, specified as a scalar
	%   in samples per second.
	SampleRate = '500000'
    end

    properties (Dependent)
        % VoltageScale Voltage Scale
        %   ADC Voltage scale.
        VoltageScale

        % VoltageOffset Voltage Offset
        %   ADC Voltage offset.
        VoltageOffset
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
        dataTypeStr
        phyDevName
        devName
    end

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    properties (Hidden, Constant)
        ComplexData = false
    end

    methods
        %% Constructor
        function obj = Base(phydev, dev, dtype, varargin)
            obj = obj@matlabshared.libiio.base(varargin{:});
	    obj.phyDevName = phydev;
	    obj.devName = dev;
	    obj.dataTypeStr = dtype;
        end

	%% Set SampleRate
	function set.SampleRate(obj, value)
	    % Set device sampling rate
	    obj.SampleRate = value;
	    if obj.ConnectedToDevice
	        obj.setDeviceAttributeRAW('sampling_frequency', num2str(value));
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
        function setupInit(obj)
	    obj.setDeviceAttributeRAW('sampling_frequency', ...
	                              num2str(obj.SampleRate));
        end
    end
end
