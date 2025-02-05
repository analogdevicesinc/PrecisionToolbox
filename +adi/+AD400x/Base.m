classdef Base < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD400X is a family of precision ADCs with sample rates between 500
    % kSPS and 2 MSPS
    %
    % AD4000/AD4004/AD4008 are single-channel, 16-bit unsigned ADCs
    % AD4001/AD4005 are single-channel, 16-bit signed ADCs
    % AD4002/AD4006/AD4010 are single-channel, 18-bit unsigned ADCs
    % AD4003/AD4007/AD4011 are single-channel, 18-bit signed ADCs

    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 4096
    end

    properties (Dependent)
        % VoltageScale Voltage Scale
        %   ADC Voltage scale.
        VoltageScale

        % VoltageOffset Voltage Offset
        %   ADC Voltage offset.
        VoltageOffset
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

        %% Check Voltage Scale
        function rValue = get.VoltageScale(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble(char(obj.channel_names(1)), 'scale', obj.isOutput);
            else
                rValue = NaN;
            end
        end

        %% Check Voltage Offset
        function rValue = get.VoltageOffset(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble(char(obj.channel_names(1)), 'offset', obj.isOutput);
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
