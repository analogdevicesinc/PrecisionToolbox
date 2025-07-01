classdef Rx < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD4080 Precision ADC Class
    %
    % adi.AD4080.Rx Receives data from the AD4080 ADC
    % The adi.AD4080.Rx System object is a signal source that can receive
    % data from the AD4080.
    %
    %   `rx = adi.AD4080.Rx;`
    %   `rx = adi.AD4080.Rx('serial:COM19,230400');`
    %
    % `AD4080 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4080.pdf>`_

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '40000000'

        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 400
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
        phyDevName = 'ad4080'
        devName = 'ad4080'
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
            obj.uri = 'serial:COM19,230400';
        end

        function set.SampleRate(obj, value)
            % Set device sampling rate
            if value ~= 40000000 && value ~= 20000000 && value ~= 10000000
                error('SampleRate must be 40000000, 20000000, or 10000000.');
            end
            obj.SampleRate = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('select_conversion_rate', num2str(value));
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

            obj.setDeviceAttributeRAW('select_conversion_rate', num2str(obj.SampleRate));

        end
    end
end