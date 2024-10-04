classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD7606x.Base
    % AD7606C-16 Precision ADC Class
    % 
    % adi.AD7606C_16.Rx Receives data from the AD7606C-16 ADC
    % The adi.AD7606C_16.Rx System object is a signal source that can receive
    % data from the AD7606C-16.
    %
    %   `rx = adi.AD7606C_16.Rx;`
    %   `rx = adi.AD7606C_16.Rx('uri','ip:192.168.2.1');`
    %
    % `AD7606 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7606_7606-6_7606-4.pdf>`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2','voltage3','voltage4','voltage5','voltage6','voltage7'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD7606x.Base('ad7606c-16','ad7606c-16','int16',varargin{:});
        end
    end
    
 end  
