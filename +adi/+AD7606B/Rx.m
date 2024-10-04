classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD7606x.Base
    % AD7606B Precision ADC Class
    % 
    % adi.AD7606B.Rx Receives data from the AD7606B ADC
    % The adi.AD7606B.Rx System object is a signal source that can receive
    % data from the AD7606B.
    %
    %   `rx = adi.AD7606B.Rx;`
    %   `rx = adi.AD7606B.Rx('uri','ip:192.168.2.1');`
    %
    % `AD7606 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7606_7606-6_7606-4.pdf>`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2','voltage3','voltage4','voltage5','voltage6','voltage7'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD7606x.Base('ad7606b','ad7606b','int16',varargin{:});
        end
    end
    
 end  
