classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD738X.Base
    % AD7388 Precision ADC Class
    % 
    % adi.AD7388.Rx Receives data from the AD7388 ADC
    % The adi.AD7388.Rx System object is a signal source that can receive
    % data from the AD7388.
    %
    % `rx = adi.AD7388.Rx;`
    % `rx = adi.AD7388.Rx('uri','192.168.2.1');`
    %
    % `AD7388 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/AD7386-7387-7388.pdf>`_

    properties (Nontunable, Hidden)
        kernelBuffersCount = 4
        channel_names = {'voltage0','voltage1','voltage2','voltage3'}
        phyDevName = 'ad7388'
        devName = 'ad7388'
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD738X.Base(varargin{:});
        end
    end
    
 end  
