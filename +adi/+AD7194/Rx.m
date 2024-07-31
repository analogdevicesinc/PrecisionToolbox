classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD719x.Base
    % AD7194 Precision ADC Class
    % adi.AD7194.Rx Receives data from the AD7194 ADC
    %   The adi.AD7194.Rx System object is a signal source that can receive
    %   data from the AD7194.
    %
    %   `rx = adi.AD7194.Rx;`
    %   `rx = adi.AD7194.Rx('serial:COM18,230400');`
    %
    % `AD7194 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7194.pdf>`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0', 'voltage1','voltage2','voltage3','voltage4','voltage5','voltage6','voltage7','voltage8','voltage9','voltage10','voltage11','voltage12','voltage13','voltage14','voltage15'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD719x.Base('ad7194','ad7194',varargin{:});
        end
    end
    
 end