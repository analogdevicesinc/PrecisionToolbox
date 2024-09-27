classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD7606x.Base
    % AD7606-6 Precision ADC Class
    % 
    % adi.AD7606_6.Rx Receives data from the AD7606-6 ADC
    % The adi.AD7606-6.Rx System object is a signal source that can receive
    % data from the AD7606-6.
    %
    %   `rx = adi.AD7606_4.Rx;`
    %   `rx = adi.AD7606_4.Rx('uri','ip:192.168.2.1');`
    %
    % `AD7606-6 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7606_7606-6_7606-4.pdf>`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2','voltage3','voltage4','voltage5'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD7606x.Base('ad7606-6','ad7606-6','int16',varargin{:});
        end
    end
    
 end  
