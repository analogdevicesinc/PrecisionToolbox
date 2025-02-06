classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD559xr.Base
    % AD5592r Precision ADC Class
    % adi.AD5592r.Rx Receives data from the AD5592r ADC
    %   The adi.AD5592r.Rx System object is a signal source that can receive
    %   data from the AD5592r.
    %
    %   rx = adi.AD5592r.Rx;
    %   rx = adi.AD5592r.Rx('uri','ip:192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad5592r.pdf"</a>

    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2'...
            'voltage3','voltage4','voltage5','voltage6','voltage7'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD559xr.Base('ad5592r','ad5592r',varargin{:});
        end
    end
    
 end
  