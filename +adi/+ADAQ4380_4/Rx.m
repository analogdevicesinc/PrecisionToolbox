classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD738X.Base
    % ADAQ4380-4 Precision ADC Class
    % 
    % adi.ADAQ4380_4.Rx Receives data from the ADAQ4380-4 ADC
    % The adi.ADAQ4380_4.Rx System object is a signal source that can receive
    % data from the ADAQ4380-4.
    %
    % `rx = adi.ADAQ4380_4.Rx;`
    % `rx = adi.ADAQ4380_4.Rx('uri','192.168.2.1');`
    %
    % `ADAQ4380-4 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/adaq4380-4.pdf>`_

    properties (Nontunable, Hidden)
        kernelBuffersCount = 4
        channel_names = {'voltage0-voltage1','voltage2-voltage3','voltage4-voltage5','voltage6-voltage7'}
        phyDevName = 'adaq4380-4'
        devName = 'adaq4380-4'
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD738X.Base(varargin{:});
        end
    end
    
 end  
