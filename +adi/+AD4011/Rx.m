classdef Rx < adi.AD400x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD4011 Precision ADC Class
    % 
    % adi.AD4011.Rx Receives data from the AD4011 ADC
    % The adi.AD4011.Rx System object is a signal source that can receive
    % data from the AD4011.
    %
    %   `rx = adi.AD4011.Rx;`
    %   `rx = adi.AD4011.Rx('uri','192.168.2.1');`
    %
    % `AD4011 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4003-4007-4011.pdf>`_

    % Channel names
    properties (Nontunable, Hidden, Constant)
        channel_names = {'voltage0-voltage1'}
    end

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '1000000'
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD400x.Base('ad4011', 'ad4011', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end

        % Set SampleRate
        function set.SampleRate(obj, value)
            obj.SampleRate = value;
            if obj.ConnectedToDevice
                obj.setAttributeRAW('voltage0-voltage1', 'sampling_frequency', num2str(value), false);
            end
        end
    end
end
