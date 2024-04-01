classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD7124.Base
    % AD7124-4 Precision ADC Class
    % 
    % adi.AD7124-4.Rx Receives data from the AD7124 ADC
    % The adi.AD7124-4.Rx System object is a signal source that can receive
    % data from the AD7124-4.
    %
    %   `rx = adi.AD7124_4.Rx;`
    %   `rx = adi.AD7124_4.Rx('uri','ip:192.168.2.1');`
    %
    % `AD7124-4 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7124-4.pdf>`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2'...
            'voltage3','voltage4','voltage5','voltage6','voltage7'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD7124.Base('ad7124-4','ad7124-4',varargin{:});
        end
    end
    
 end

  