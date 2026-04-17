classdef Rx < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD4113 Precision ADC Class
    %
    % adi.AD4113.Rx Receives data from the AD4113 ADC
    % The adi.AD4113.Rx System object is a signal source that can receive
    % data from the AD4113.
    %
    %   `rx = adi.AD4113.Rx;`
    %   `rx = adi.AD4113.Rx('serial:COM59,230400');`
    %
    % `AD4113 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4113.pdf>`_

    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 400
    end

% Channel names
    properties (Nontunable, Hidden, Constant)
        channel_names = { ...
                         'voltage0', 'voltage1', 'voltage2', 'voltage3', ...
                         'voltage4', 'voltage5', 'voltage6', 'voltage7', ...
                         'voltage8', 'voltage9', 'voltage10', 'voltage11', ...
                         'voltage12', 'voltage13', 'voltage14', 'voltage15'}
    end

    % isOutput
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName = 'ad4113'
        devName = 'ad4113'
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

        end
    end
end
