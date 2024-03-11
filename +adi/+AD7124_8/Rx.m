classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD7124.Base
    % AD7124-8 Precision ADC Class
    % adi.AD7124-8.Rx Receives data from the AD7124 ADC
    %   The adi.AD7124-8.Rx System object is a signal source that can receive
    %   data from the AD7124-8.
    %
    %   rx = adi.AD7124_8.Rx;
    %   rx = adi.AD7124_8.Rx('uri','ip:192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad7124-8.pdf">AD7124-8 Datasheet</a>

    
    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2','voltage3',...
            'voltage4','voltage5','voltage6','voltage7','voltage8','voltage9',...
            'voltage10','voltage11','voltage12','voltage13','voltage14','voltage15'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD7124.Base('ad7124-8','ad7124-8',varargin{:});
        end
    end

end  