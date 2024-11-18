classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD738X.Base
    % AD7386-4 Precision ADC Class
    % 
    % adi.AD7386_4.Rx Receives data from the AD7386-4 ADC
    % The adi.AD7386_4.Rx System object is a signal source that can receive
    % data from the AD7386-4.
    %
    % `rx = adi.AD7386_4.Rx;`
    % `rx = adi.AD7386_4.Rx('uri','192.168.2.1');`
    %
    % `AD7386-4 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7386-4-7387-4-7388-4.pdf>`_

    properties (Nontunable, Hidden)
        kernelBuffersCount = 8
        channel_names = {'voltage0','voltage1','voltage2','voltage3','voltage3','voltage5','voltage6','voltage7'}
        phyDevName = 'ad7386-4'
        devName = 'ad7386-4'
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD738X.Base(varargin{:});
        end
    end
    
 end  
