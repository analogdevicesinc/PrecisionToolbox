classdef Rx < adi.common.Rx ...
        & adi.AD463x.Base

    % AD4030-24 Precision ADC Class
    % adi.AD4030.Rx Receives data from the AD4030-24 ADC
    %   The adi.AD4030.Rx System object is a signal source that can receive
    %   data from the AD4030-24.
    %
    %   rx = adi.AD4030.Rx;
    %   rx = adi.AD4030.Rx('uri','192.168.2.1');
    %
    %   <a href="http://www.analog.com/media/en/technical-documentation/data-sheets/AD4030-24.pdf">AD4030-24 Datasheet</a>

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    properties (Hidden)
        % Number of frames or buffers of data to capture
        FrameCount = 1
    end

    properties (Nontunable, Hidden)

        % Channels present with default register settings -
        channel_names = {'differential0', 'differential1'}
    end

    properties (Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName = 'ad4030-24'
        devName = 'ad4030-24'
    end

    methods

        %% Constructor
        function obj = Rx(varargin)
            coder.allowpcode('plain');
            obj = obj@adi.AD463x.Base(varargin{:});

        end

    end
end
