classdef Rx < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD2S1210 Resolver-to-Digital Converter Class
    % adi.AD2S1210.Rx Receives data from the AD2S1210 Resolver
    %   The adi.AD2S1210.Rx System object is a signal source that can receive
    %   data from the AD2S1210.
    %
    %   rx = adi.AD2S1210.Rx;
    %   rx = adi.AD2S1210.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad2s1210.pdf">AD2S1210 Datasheet</a>

    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 4096
    end

    properties
        % Angle
        %   Resolver angle in Degrees.
        Angle = 0

        % AngleScale Angular Scale
        %   Resolver angle scale.
        AngleScale = 0

        % Velocity Angular Velocity
        %   Resolver velocity in revolutions per second.
        Velocity = 0

        % VelocityScale Velocity Angular Scale
        %   Resolver velocityscale.
        VelocityScale = 0

        % ExcitationFrequency Excitation Frequency
        %   Resolver excitation frequency in Hertz.
        ExcitationFrequency = 0
    end

    properties (Hidden)
        % Number of frames or buffers of data to capture
        FrameCount = 1
    end

    % Channel names
    properties (Nontunable, Hidden, Constant)
        channel_names = {'angl0', 'anglvel0'}
    end

    % isOutput
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 2
        dataTypeStr = 'int16'
        phyDevName = 'ad2s1210'
        devName = 'ad2s1210'
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
            obj.EnabledChannels = [1 2];
            obj.BufferTypeConversionEnable = true;
        end

        %% Check Angle
        function rValue = get.Angle(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeRAW('angl0', 'raw', obj.isOutput);
                obj.Angle = rValue;
            end
        end

        %% Check Angular Scale
        function rValue = get.AngleScale(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('angl0', 'scale', obj.isOutput);
                obj.AngleScale = rValue;
            end
        end

        %% Check Velocity
        function rValue = get.Velocity(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeRAW('anglvel0','raw', obj.isOutput);
                obj.Velocity = rValue;
            end
        end

        %% Check Velocity Scale
        function rValue = get.VelocityScale(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('anglvel0', 'scale', obj.isOutput);
                obj.VelocityScale = rValue;
            end
        end
    end

    %% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
            % Read excitation frequency attribute from device once connected.

            obj.ExcitationFrequency = obj.getDeviceAttributeLongLong('excitation_frequency');
        end
    end
end
