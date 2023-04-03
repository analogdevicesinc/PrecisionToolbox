classdef Rx < adi.common.Rx ...
        & adi.AD463x.Base

    % AD4630-24 Precision ADC Class
    % adi.AD4630_24.Rx Receive data from the AD4630-24 ADC
    %   The adi.AD4630_24.Rx System object is a signal source that can receive
    %   data from the AD4630-24.
    %
    %   rx = adi.AD4630_24.Rx;
    %   rx = adi.AD4630_24.Rx('uri','192.168.2.1');
    %
    %   <a href="http://www.analog.com/media/en/technical-documentation/data-sheets/AD4630-24.pdf">AD4630-24 Datasheet</a>

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end



    properties (Nontunable, Hidden)
        % Channels present with default register settings -
        channel_names = {'differential0', 'differential1'}
    end

    properties (Hidden)
        Timeout = Inf
        dataTypeStr = 'int32'
        phyDevName = 'ad4630-24'
        devName = 'ad4630-24'
    end

    methods

        %% Constructor
        function obj = Rx(varargin)
            coder.allowpcode('plain');
            obj = obj@adi.AD463x.Base(varargin{:});

        end

    end
end
