classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD738X.Base
    % AD7387 Precision ADC Class
    % 
    % adi.AD7387.Rx Receives data from the AD7387 ADC
    % The adi.AD7387.Rx System object is a signal source that can receive
    % data from the AD7387.
    %
    % `rx = adi.AD7387.Rx;`
    % `rx = adi.AD7387.Rx('uri','192.168.2.1');`
    %
    % `AD7387 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/AD7386-7387-7388.pdf>`_

    properties (Nontunable, Hidden)
        kernelBuffersCount = 4
        channel_names = {'voltage0','voltage1','voltage2','voltage3'}
        phyDevName = 'ad7387'
        devName = 'ad7387'
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD738X.Base(varargin{:});
        end
    end
    
 end  
