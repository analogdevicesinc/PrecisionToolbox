classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD7134.Base
    % AD4134 Precision ADC Class
    %
    % adi.AD4134.Rx Receives data from the AD4134 ADC
    % The adi.AD4134.Rx System object is a signal source that can receive
    % data from the AD4134.
    %
    %   rx = adi.AD4134.Rx;
    %   rx = adi.AD4134.Rx('uri','ip:192.168.2.1');
    %
    % <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad4134.pdf">AD4134 Datasheet</a>

    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2','voltage3'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD7134.Base('ad4134','ad4134',varargin{:});
        end
    end

end
