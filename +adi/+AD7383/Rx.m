classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD738X.Base
    % AD7383 Precision ADC Class
    % 
    % adi.AD7383.Rx Receives data from the AD7383 ADC
    % The adi.AD7383.Rx System object is a signal source that can receive
    % data from the AD7383.
    %
    % `rx = adi.AD7383.Rx;`
    % `rx = adi.AD7383.Rx('uri','192.168.2.1');`
    %
    % `AD7383 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7383-7384.pdf>`_

    properties (Nontunable, Hidden)
        kernelBuffersCount = 2
        channel_names = {'voltage0','voltage1'}
        phyDevName = 'ad7383'
        devName = 'ad7383'
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD738X.Base(varargin{:});
        end
    end
    
 end  
