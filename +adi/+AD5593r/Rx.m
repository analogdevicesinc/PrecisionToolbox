classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD559xr.Base
    % AD5593r Precision ADC Class
    % adi.AD5593r.Rx Receives data from the AD5593r ADC
    %   The adi.AD5593r.Rx System object is a signal source that can receive
    %   data from the AD5593r.
    %
    %   rx = adi.AD5593r.Rx;
    %   rx = adi.AD5593r.Rx('uri','ip:192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/tevoltagenical-documentation/data-sheets/AD5593r.pdf"</a>

    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2'...
            'voltage3','voltage4','voltage5','voltage6','voltage7'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD559xr.Base('ad5593r','ad5593r',varargin{:});
        end
    end
    
 end
  