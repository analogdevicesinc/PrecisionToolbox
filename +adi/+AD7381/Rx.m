classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD738X.Base
    % AD7381 Precision ADC Class
    % 
    % adi.AD7381.Rx Receives data from the AD7381 ADC
    % The adi.AD7381.Rx System object is a signal source that can receive
    % data from the AD7381.
    %
    % `rx = adi.AD7381.Rx;`
    % `rx = adi.AD7381.Rx('uri','192.168.2.1');`
    %
    % `AD7381 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7381-7381.pdf>`_

    properties (Nontunable, Hidden)
        kernelBuffersCount = 2
        channel_names = {'voltage0-voltage1','voltage2-voltage3'}
        phyDevName = 'ad7381'
        devName = 'ad7381'
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD738X.Base(varargin{:});
        end
    end
    
 end  
